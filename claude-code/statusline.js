#!/usr/bin/env node

const fs = require('fs');
const os = require('os');

function getStatusLine() {
  try {
    // Read JSON input from stdin
    const input = fs.readFileSync(0, 'utf-8');
    const data = JSON.parse(input);

    // Extract context window information
    const contextWindow = data.context_window || {};
    const currentUsage = contextWindow.current_usage;
    const contextWindowSize = contextWindow.context_window_size || 200000;
    const totalInputTokens = contextWindow.total_input_tokens || 0;
    const totalOutputTokens = contextWindow.total_output_tokens || 0;

    // Calculate current context usage (if available)
    let currentTokens = 0;
    let percentage = 0;
    let statusMessage = '';

    if (currentUsage && currentUsage !== null) {
      // Current context tokens include input + cache creation + cache read
      currentTokens = (currentUsage.input_tokens || 0) +
                     (currentUsage.cache_creation_input_tokens || 0) +
                     (currentUsage.cache_read_input_tokens || 0);
      percentage = ((currentTokens / contextWindowSize) * 100).toFixed(1);
    }

    // Determine color and recommendation based on usage
    let color = '\x1b[32m'; // Green
    let recommendation = '';

    if (percentage >= 85) {
      color = '\x1b[31m'; // Red
      recommendation = ' ⚠ COMPACT NOW';
    } else if (percentage >= 70) {
      color = '\x1b[33m'; // Yellow
      recommendation = ' ⚡ Consider compacting soon';
    } else if (percentage >= 50) {
      color = '\x1b[33m'; // Yellow
      recommendation = ' ℹ Monitor usage';
    }

    const reset = '\x1b[0m';
    const dim = '\x1b[2m';

    // Build status line
    const model = data.model?.display_name || 'Claude';
    const modelId = data.model?.id || '';
    const cwd = (data.workspace?.current_dir || process.cwd()).replace(os.homedir(), '~');
    const sessionName = data.session?.name || '';

    // Check if using Bedrock application-inference-profile specifically
    // Pattern: arn:aws:bedrock:*:*:application-inference-profile/*
    const isBedrockInferenceProfile = /^arn:aws:bedrock:[^:]+:[^:]+:application-inference-profile\//.test(modelId);

    // Format token display
    const currentDisplay = currentTokens > 0 ? currentTokens.toLocaleString() : 'N/A';
    const maxDisplay = contextWindowSize.toLocaleString();
    const totalUsage = (totalInputTokens + totalOutputTokens).toLocaleString();

    // Create compact status line
    let status = '';

    // Show session name (first 10 chars) if set
    if (sessionName) {
      const shortSessionName = sessionName.substring(0, 10);
      status = `${dim}[${shortSessionName}]${reset} | `;
    }

    // Only show model name if NOT using Bedrock application-inference-profile (as a warning/notice)
    if (!isBedrockInferenceProfile) {
      status += `${dim}[Using ${model}]${reset} | ${dim}${cwd}${reset}`;
    } else {
      status += `${dim}${cwd}${reset}`;
    }

    if (currentTokens > 0) {
      status += ` | Context: ${color}${currentDisplay}${reset}/${maxDisplay} (${color}${percentage}%${reset})`;
    }

    status += ` | Session: ${totalUsage} tokens`;

    if (recommendation) {
      status += ` ${color}${recommendation}${reset}`;
    }

    console.log(status);
  } catch (error) {
    // Fallback display
    console.log('Claude Code');
  }
}

getStatusLine();
