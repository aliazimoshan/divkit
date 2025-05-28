export class PatchModel {
  id: string |null;
  jsonObject: string;
  idScreen: string;
  patchName: string;
  systemId: number;

  constructor(
    id: string |null,
    jsonObject: string,
    idScreen: string,
    patchName: string,
    systemId : number
  ) {
    this.id = id;
    this.jsonObject = jsonObject;
    this.idScreen = idScreen;
    this.patchName = patchName;
    this.systemId = systemId;
  }
}
