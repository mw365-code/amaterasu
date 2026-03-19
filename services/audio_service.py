# Phase 3: Audio playback service
# macOS built-in TTS using Apple's `say` command (Japanese voice: Kyoko)

from __future__ import annotations

import subprocess


class AudioService:
    def __init__(self, voice: str = "Kyoko"):
        self.voice = voice

    def speak(self, text: str, language: str = "ja"):
        """Speak the given text using macOS 'say' with Apple's Japanese voice (Kyoko)."""
        if not text or not text.strip():
            return

        if language != "ja":
            raise ValueError(f"Unsupported language: {language}")

        subprocess.run(
            ["say", "-v", self.voice, text],
            check=True,
        )