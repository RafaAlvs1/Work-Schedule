import 'package:escalatrabalho/models/setor.dart';
import 'package:flutter/material.dart';

class SetorCard extends StatelessWidget {
  final Setor setor;
  final Function() onTap;

  const SetorCard(this.setor, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125.0,
      child: Card(
        elevation: 1.5,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  setor.nome,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 4.0,
                      ),
                      child: new Text(
                        'máx',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    new Text(
                      setor.quantidade?.toString() ?? '1',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}