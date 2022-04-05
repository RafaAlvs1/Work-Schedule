import 'package:escalatrabalho/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PessoaCard extends StatelessWidget {
  final Pessoa pessoa;
  final Function() onTap;

  const PessoaCard(this.pessoa, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: Card(
        elevation: 1.5,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildAvatar(context),
                Text(
                  pessoa?.nome ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAvatar(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(bottom: 8.0),
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: new BorderRadius.all(Radius.circular(8.0),),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: pessoa?.fotoUrl == null ?
          Icon(
            FontAwesomeIcons.userAlt,
            size: 24.0,
            color: Colors.white,
          ) :
          Image(
            image: NetworkImage(pessoa.fotoUrl),
            fit: BoxFit.cover,
          ),
        )
    );
  }
}