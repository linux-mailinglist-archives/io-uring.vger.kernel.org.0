Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DB825132A
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 09:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgHYH2v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 03:28:51 -0400
Received: from sonic309-15.consmr.mail.bf2.yahoo.com ([74.6.129.125]:39887
        "EHLO sonic309-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729194AbgHYH2u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 03:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598340529; bh=Hx2q6/wky65uES3PZmzO6PcrQE/ji4ygndkQ4MNzRq8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=W5vRISjHZryU0Px9pCam6Jjtn9755eiK/07O1LNIBIZKuX54PHQpBe+vGQfbtpxUwXQMe4a8PMTfemjmA37f224l3zq8CIZ/Ee5LitZ3EfWiI3dOY/h2O+6EfxwnO4OLiQ9v3TX2faQkuNsMMVMbVOPSIHE9QPFe4nnycEOUkhSdQfdrBFhm5sNL1lGShQDc5ycdEr+xMcUggldQYCtfPMFJiLXbkUDJRpgagJFDbdqSL2YyDcW7bKCuZzSJ97JUtKWBUlQTH/AzOK6d7KCJdE3VkoOe1HnHkc+0jk3iB5/NPK4XuPFxtLoZUjD9HbTgDBoVByH9cHWxAjic4wNkMg==
X-YMail-OSG: kTFlHf0VM1kMoG3Z27HSviDowYvT.Vd8Lt3XGGg73IYD3.pirgNrrvZfIbXja3S
 JEaBhxsWzlHdEjFY6O09IbU1.CVYAvZUPy3OjOhqX0I3FihXtaKu6bEE42g5mqcrgu1D00ESCCpr
 FdzM5Xqsdkt_X7vq1.nIJQQSdeAk0U4yLavVEY3GzE4a.TQfVpR9lkDqw7DBIEmAqGkm4kxnaGnq
 wZEMLRADPOKbtcjJUr4RZFctEnVa4ieNvlPAD5RP9pJW2LyIw25UnoLPsOuHBB9LXBnQvrnAGs_a
 SUjMFc6hztAVbvhvV088j._PwHkT.bS0fOrieholfHPmUsq8pyJ.3OEVMnPa71Jo1FxYAKMKPaTF
 BZ3zqhKq3XtE.EM0WOTxPRjRfR8f4bA.tXkAPDJwMvFO0Xz0k.OabAn5SuQWrzsbWi0KLmyuyIfJ
 FauCZjqtlz2XuevRn1JCDYcPNCotgPEkrNT4iWlgplsG8Gt3Tck8tLC7B_6Fu3uTT.4NzfkrCkCn
 aPCxlQhiBrS1c1CpOKDUz7g9_0HTTtQIzqijQG3IrgKump41C52t_YrRiiJEeykb6EetioMdnKeD
 Q99KBwv0lilUvj2gCUGJnBgjicTDsDyp2RFtTjo.pf4W3B_X3rRjBgJ.acVJGStSVSvlRMBWc0PG
 TsqGHTshpMp92YYDXMG8ZfRFh5vszZr6BN0.1Bc7sdPYIOuyjY6vXJriR5Dze_WCddpnGCIFX0RW
 gIol8WyxsdbvbgMaPcrXaMpkVZ0FpE7AHgB.PYHGT.6EOjWL2djDEd6s4U9IOkB9hwAi6WsDQvd6
 rtTZfoDL3N9wYhfJsBJlrwp74bA11I0EGLi_5Q0SFSENUy6VSuE9S.s83QkndZEwih8aa7K3.H7b
 BLGZ3YHd2vqWLDJiwNJRsur8OqQnz.L64nhhqkn9ctOFaYQGqGlJSb8TRqmDN7HCxIjUXb6TvybK
 BNOGv2d_1wPstJdNWoIS2HJO7oJqlj_ddPm8uPmZKxB2Ed7KMYsFI81J6dhNZqTCx7OSgnnjI.Zn
 erWfZGggz49wr_XT2W4FwZGmGtp5z3AqBhbPKCo3hE2L.ufLSyWZrxclYK9fpNE_RRzF_5wB2HNC
 Bq0MRkk5GdkKGKaYXpVd_cYhWC77QaYFXY12FpoL5xEeSdLk7uQ7EKYwy4dn6tYMD2V2hXuBzFQD
 tBNQ3oGyPXlVXw2dj1k8CEI9l7swAUWGTcnS7VT91.E.TL59EkI3pHWR8wspiLLHxqCQCTVxen.h
 vMgMtZXh2dF1j.GHQcKr5Kr54E3DdrjILI7z00e_l_9Fn0Q3sGDV_fin3WX11nCHBlFDwDNNM9qn
 F04oPkeArVzLHk5RBSL_evG_vfdQbHHiu9VP8LtevckhsfVcsRALYF1sPlIEnJt0yom2bDhrD.Ht
 u7t9C.MrYdgdi7p6mvg5UOeQFGUCT.K3lLhRXJj9Asyrw5s3Ohw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Tue, 25 Aug 2020 07:28:49 +0000
Date:   Tue, 25 Aug 2020 07:28:48 +0000 (UTC)
From:   Sgt Vivian Robert <sgtvivarob@gmail.com>
Reply-To: sgtvivarob@gmail.com
Message-ID: <653746008.5254685.1598340528745@mail.yahoo.com>
Subject:  kindly respond to my mail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <653746008.5254685.1598340528745.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



Good=C2=A0Day,=C2=A0I=C2=A0am=C2=A0glad=C2=A0to=C2=A0contact=C2=A0you=C2=A0=
through=C2=A0this=C2=A0medium=C2=A0I=E2=80=99m=C2=A0Sgt=C2=A0Vivian=C2=A0Ro=
bert=C2=A0am=C2=A0from=C2=A0united=C2=A0state,=C2=A028=C2=A0years=C2=A0old=
=C2=A0single=C2=A0I=C2=A0am=C2=A0the=C2=A0only=C2=A0surviving=C2=A0child=C2=
=A0of=C2=A0my=C2=A0late=C2=A0parents,=C2=A0I=C2=A0am=C2=A0America=C2=A0fema=
le=C2=A0soldier=C2=A0presently=C2=A0in=C2=A0Afghanistan=C2=A0for=C2=A0the=
=C2=A0training,=C2=A0advising=C2=A0the=C2=A0Afghan=C2=A0forces=C2=A0and=C2=
=A0also=C2=A0helping=C2=A0in=C2=A0stabilizing=C2=A0the=C2=A0country=C2=A0ag=
ainst=C2=A0security=C2=A0challenges,=C2=A0am=C2=A0Actually=C2=A0seeking=C2=
=A0your=C2=A0assistance=C2=A0to=C2=A0evacuate=C2=A0the=C2=A0sum=C2=A0of=C2=
=A0$3.5=C2=A0million,=C2=A0This=C2=A0money=C2=A0I=C2=A0got=C2=A0it=C2=A0as=
=C2=A0my=C2=A0reward=C2=A0in=C2=A0service=C2=A0by=C2=A0Afghanistan=C2=A0gov=
ernment=C2=A0to=C2=A0support=C2=A0me=C2=A0for=C2=A0my=C2=A0Good=C2=A0job=C2=
=A0in=C2=A0their=C2=A0land.=C2=A0Right=C2=A0now,=C2=A0I=C2=A0want=C2=A0you=
=C2=A0to=C2=A0stand=C2=A0as=C2=A0my=C2=A0beneficiary=C2=A0and=C2=A0receive=
=C2=A0the=C2=A0fund=C2=A0my=C2=A0certificate=C2=A0of=C2=A0deposit=C2=A0from=
=C2=A0the=C2=A0Bank=C2=A0where=C2=A0this=C2=A0fund=C2=A0deposited=C2=A0and=
=C2=A0my=C2=A0authorization=C2=A0letter=C2=A0is=C2=A0with=C2=A0me=C2=A0now.=
My=C2=A0contact=C2=A0with=C2=A0you=C2=A0is=C2=A0not=C2=A0by=C2=A0my=C2=A0po=
wer=C2=A0but=C2=A0it=C2=A0is=C2=A0divinely=C2=A0made=C2=A0for=C2=A0God's=C2=
=A0purpose=C2=A0to=C2=A0be=C2=A0fulfilled=C2=A0in=C2=A0our=C2=A0lives.=C2=
=A0I=C2=A0want=C2=A0you=C2=A0to=C2=A0be=C2=A0rest=C2=A0assured=C2=A0that=C2=
=A0this=C2=A0transaction=C2=A0is=C2=A0legitimate=C2=A0and=C2=A0a=C2=A0100%=
=C2=A0risk=C2=A0free=C2=A0involvement,=C2=A0all=C2=A0you=C2=A0have=C2=A0to=
=C2=A0do=C2=A0is=C2=A0to=C2=A0keep=C2=A0it=C2=A0secret=C2=A0and=C2=A0confid=
ential=C2=A0to=C2=A0yourself=C2=A0,=C2=A0this=C2=A0transaction=C2=A0will=C2=
=A0not=C2=A0take=C2=A0more=C2=A0than=C2=A07=C2=A0working=C2=A0banking=C2=A0=
days=C2=A0for=C2=A0the=C2=A0money=C2=A0to=C2=A0get=C2=A0into=C2=A0your=C2=
=A0account=C2=A0based=C2=A0on=C2=A0your=C2=A0sincerity=C2=A0and=C2=A0cooper=
ation.=C2=A0i=C2=A0want=C2=A0you=C2=A0to=C2=A0take=C2=A040%=C2=A0Percent=C2=
=A0of=C2=A0the=C2=A0total=C2=A0money=C2=A0for=C2=A0your=C2=A0personal=C2=A0=
use=C2=A0While=C2=A020%=C2=A0Percent=C2=A0of=C2=A0the=C2=A0money=C2=A0will=
=C2=A0go=C2=A0to=C2=A0charity,=C2=A0people=C2=A0in=C2=A0the=C2=A0street=C2=
=A0and=C2=A0helping=C2=A0the=C2=A0orphanage=C2=A0the=C2=A0remaining=C2=A040=
%=C2=A0percent=C2=A0of=C2=A0the=C2=A0total=C2=A0money=C2=A0.you=C2=A0will=
=C2=A0assist=C2=A0me=C2=A0to=C2=A0invest=C2=A0it=C2=A0in=C2=A0a=C2=A0good=
=C2=A0profitable=C2=A0Venture=C2=A0or=C2=A0you=C2=A0keep=C2=A0it=C2=A0for=
=C2=A0me=C2=A0until=C2=A0I=C2=A0arrive=C2=A0your=C2=A0country.=C2=A0If=C2=
=A0you=E2=80=99re=C2=A0willing=C2=A0to=C2=A0assist=C2=A0me=C2=A0contact=C2=
=A0me=C2=A0through=C2=A0my=C2=A0email=C2=A0address=C2=A0=E2=80=9Csgtvivarob=
@gmail.com.

Stg=C2=A0Vivian=C2=A0Robert
