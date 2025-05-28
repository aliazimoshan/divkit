export class SystemModel {
  id: number;
  systemName: string | null;
  idSystem: number;
  userPermissions: string[]; 

  constructor(
    id: number,
    systemName: string | null,
    idSystem: number,
    userPermissions: string[] 
  ) {
    this.id = id;
    this.systemName = systemName;
    this.idSystem = idSystem;
    this.userPermissions = userPermissions; 
  }
}
