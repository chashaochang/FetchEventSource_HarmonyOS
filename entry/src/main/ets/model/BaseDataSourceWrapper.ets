/**
 * 通用IDataSource配合LazyForEach使用的数据包装类
 */
export class BaseDataSourceWrapper<T> implements IDataSource{
  private list: T[] = []
  private listener?: DataChangeListener

  constructor(list: T[]) {
    this.list = list
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {

  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  notifyDataAdd(index:number){
    this.listener?.onDataAdd(index)
  }

  getData(index: number) {
    return this.list[index]
  }

  totalCount(): number {
    return this.list.length
  }
}