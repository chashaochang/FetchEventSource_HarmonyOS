export default class OpenAIResp {
  id: string = '-';
  object: string = 'chat.completion.chunk';
  created: number = new Date().getTime();
  model: string = '-';
  system_fingerprint: string = '-';
  choices?: OpenAIRespChoices[];

  constructor(choices: OpenAIRespChoices[]) {
    this.choices = choices
  }
}

export class OpenAIRespChoicesDelta {
  content?: string;
  role?: string
}

export class OpenAIRespChoices {
  index?: number;
  delta?: OpenAIRespChoicesDelta;
  finish_reason?: string
}