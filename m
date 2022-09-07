Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26985AFED7
	for <lists+io-uring@lfdr.de>; Wed,  7 Sep 2022 10:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIGIRx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 04:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIGIRx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 04:17:53 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3146AB4C4;
        Wed,  7 Sep 2022 01:17:47 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220907081732euoutp01aba57996fd18f465c0d9cc8b8e1bb560~ShhigK7U_1015810158euoutp019;
        Wed,  7 Sep 2022 08:17:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220907081732euoutp01aba57996fd18f465c0d9cc8b8e1bb560~ShhigK7U_1015810158euoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662538652;
        bh=LvzMJviyB7IOZj+t6iKg1uFJXGINIymoLD+GB/JGg/I=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Orlg4lQaEk68n62BhELQc6Nzs6dnAb0G2L88YxfM82pIKno9T1w8yr8xfK35XRHeC
         4u6SyemfMRlRNkZonZTgcNUlwGRybUD9i2aQ9qobTctCZReZiR0GqIt2pZit9GfNOT
         nNlbdbBsDsay/YxKRe8c2Ny5PwUxPZWAJQ/lkNOQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220907081732eucas1p24f610f4fab8a7b27b4dbe03b903a2575~Shhh93wGe0239702397eucas1p2F;
        Wed,  7 Sep 2022 08:17:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 3B.FB.29727.C9358136; Wed,  7
        Sep 2022 09:17:32 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220907081731eucas1p2a07e0f4f6a38073d869e1b1a1f944231~ShhhazTfS2574825748eucas1p2s;
        Wed,  7 Sep 2022 08:17:31 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220907081731eusmtrp1e5787bde0c28fda38aa323df09f23c71~ShhhaCSDM1097010970eusmtrp1F;
        Wed,  7 Sep 2022 08:17:31 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-44-6318539c8995
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 04.16.10862.B9358136; Wed,  7
        Sep 2022 09:17:31 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220907081731eusmtip1d5414e4010f6b91e781e7cc29a72c2f1~ShhhMTfrH2121621216eusmtip1N;
        Wed,  7 Sep 2022 08:17:31 +0000 (GMT)
Received: from localhost (106.210.248.128) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 7 Sep 2022 09:17:30 +0100
Date:   Wed, 7 Sep 2022 10:17:29 +0200
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     <linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>,
        <io-uring@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 2/3] selinux: implement the security_uring_cmd() LSM
 hook
Message-ID: <20220907081729.r3ork6q3wnvv7rrv@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="tn4kuwui4hxpj3fy"
Content-Disposition: inline
In-Reply-To: <CAHC9VhTDJogwcYhm2xc29kyO74CZ4wcCysySUr1CX6GcUkPf0Q@mail.gmail.com>
X-Originating-IP: [106.210.248.128]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7djP87pzgiWSDTY+57D4O+kYu0Xz4vVs
        Fu9az7FYfOh5xGZxY8JTRovbk6azWJw/fozdgd3j969JjB6bVnWyeeyfu4bdY+3eF4wenzfJ
        BbBGcdmkpOZklqUW6dslcGX0znvEXLDNvKJj1X7mBsY+/S5GDg4JAROJ++cluhi5OIQEVjBK
        LJw4i72LkRPI+cIosexGNETiM6PEoalb2EASIA1fJ81lhUgsZ5SY3H2TDa5q+stmKGcLo8TJ
        vtusIC0sAioSN+70M4LYbAI6Euff3GEGsUWA4oufrmcEaWAWuMcocePEZiaQhLCAv8TGe1PB
        GngFzCWOXG6GsgUlTs58wgJyOLNAhcTSLfUQprTE8n8cIBWcAoESN2ctZ4e4VFmi6dESVgi7
        VmLtsTPsIKskBCZzSkz8d5oRIuEicXtSB9RrwhKvjm+BapaROD25hwXCzpbYOWUXM4RdIDHr
        5FQ2SNhZS/SdyYEIO0qs39HADBHmk7jxVhAkzAxkTto2HSrMK9HRJgRRrSaxo2kr4wRG5VlI
        3pqF8NYshLdmgc3RkViw+xMbhrC2xLKFr5khbFuJdevesyxgZF/FKJ5aWpybnlpsmJdarlec
        mFtcmpeul5yfu4kRmMJO/zv+aQfj3Fcf9Q4xMnEwHmJUAWp+tGH1BUYplrz8vFQlEd6UHSLJ
        QrwpiZVVqUX58UWlOanFhxilOViUxHmTMzckCgmkJ5akZqemFqQWwWSZODilGphCG3+0v9++
        KE/o7KLKNK0H68O4tYTWJ2nfYT81Pa0ieMax+4sXqpdabLOd9j46Xul9qhgP95st6zsubbx7
        48nftvyCOLNDO59MmnfmWCnzq36vTYsNt0m/3G7AJRn5dXqtSna86PLEskSX61xCF8oXq/jx
        JUueFJ/2o+ksa4XYL36lzwGFHz4HaDGqbE39u2L+vT3Hk+cFKshoGu7f8n3Pce3zn8v8bKt9
        n7++cep+WFkPT+/vlhCZtQdW3ZPWs+7UyZtanpKu/etk/ovsku71B1m506ydGm8WykrOFBC5
        s2LX+w0cTwosQ3Y33fxm9CS0btNL1o6TL9mTTkQJJl975SnBapsVfzxe0VXktbQSS3FGoqEW
        c1FxIgCXAJCw3AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7qzgyWSDS7/l7X4O+kYu0Xz4vVs
        Fu9az7FYfOh5xGZxY8JTRovbk6azWJw/fozdgd3j969JjB6bVnWyeeyfu4bdY+3eF4wenzfJ
        BbBG6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GV8
        3hhesMW8YlGDZANjj34XIyeHhICJxNdJc1m7GLk4hASWMkrsbutihUjISHy68pEdwhaW+HOt
        iw3EFhL4yCix8yc/RMMWRolF7feYQBIsAioSN+70M4LYbAI6Euff3GEGsUWA4oufrmcEaWAW
        uMMo8XLOQxaQhLCAr8Sad4fAmnkFzCWOXG5mhJh6gEliQ99xRoiEoMTJmU/AGpgFyiTaujuA
        4hxAtrTE8n8cIGFOgUCJm7OWQ12qLNH0aAnUB7USr+7vZpzAKDwLyaRZSCbNQpgEEdaSuPHv
        JROGsLbEsoWvmSFsW4l1696zLGBkX8UoklpanJueW2ykV5yYW1yal66XnJ+7iREYz9uO/dyy
        g3Hlq496hxiZOBgPMaoAdT7asPoCoxRLXn5eqpIIb8oOkWQh3pTEyqrUovz4otKc1OJDjKbA
        YJzILCWanA9MNHkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUyL
        FDn7WH/LxsRebnsYus/87+oFB7K/dYgeOyA3MXF+d4X55xXd2y5sufhD769ElDXnj5ZNM636
        lBrzdpVvj374O8m4Ren5Qb6AiGuTwk5NzO+NVb/2vmtXkAxbrcIN4Vulvw5LCoV/ncVneCqr
        Wb+n7kiokAAXZ6Pf/OCZApteVp+V8L1U8SfgtePx2dcu21g/++IY5fJ8XnDTtIbQKqXHEtf3
        ZegW83C8Ndtnaxsdt/W6Ilsm+4FnC4VEQ4VE5b4Lv7DQz/188taRfPPVd/R+Gn02OHgrSUyZ
        XbImSKBURPCHUIHnEr2zh6e41UgayGZMvqi/aueCp/eNbaJ4m5mVDmvGRdh2rmnMWHW2VYml
        OCPRUIu5qDgRACEcNAl8AwAA
X-CMS-MailID: 20220907081731eucas1p2a07e0f4f6a38073d869e1b1a1f944231
X-Msg-Generator: CA
X-RootMTR: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922
References: <166120321387.369593.7400426327771894334.stgit@olly>
        <CGME20220901201553eucas1p258ee1cba97c888aab172d31d9c06e922@eucas1p2.samsung.com>
        <166120327379.369593.4939320600435400704.stgit@olly>
        <20220901201551.hmdrvthtin4gkdz3@localhost>
        <CAHC9VhTDJogwcYhm2xc29kyO74CZ4wcCysySUr1CX6GcUkPf0Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--tn4kuwui4hxpj3fy
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Paul

On Thu, Sep 01, 2022 at 05:30:38PM -0400, Paul Moore wrote:
> On Thu, Sep 1, 2022 at 4:15 PM Joel Granados <j.granados@samsung.com> wro=
te:
> > Hey Paul
> >
> > I realize that you have already sent this upstream but I wanted to share
> > the Selinux part of the testing that we did to see if there is any
> > feedback.
> >
> > With my tests I see that the selinux_uring_cmd hook is run and it
> > results in a "avc : denied" when I run it with selinux in permissive
> > mode with an unpriviledged user. I assume that this is the expected
> > behavior. Here is how I tested
> >
> > *** With the patch:
> > * I ran the io_uring_passthrough.c test on a char device with an
> >   unpriviledged user.
> > * I took care of changing the permissions of /dev/ng0n1 to 666 prior
> >   to any testing.
> > * made sure that Selinux was in permissive mode.
> > * Made sure to have audit activated by passing "audit=3D1" to the kernel
> > * After noticing that some audit messages where getting lost I upped the
> >   backlog limit to 256
> > * Prior to executing the test, I also placed a breakpoint inside
> >   selinux_uring_cmd to make sure that it was executed.
> > * This is the output of the audit when I executed the test:
> >
> >   [  136.615924] audit: type=3D1400 audit(1662043624.701:94): avc:  den=
ied  { create } for  pid=3D263 comm=3D"io_uring_passth" anonclass=3D[io_uri=
ng] scontext=3Dsystem_u:system_r:kernel_t tcontext=3Dsystem_u:object_r:kern=
el_t tclass=3Danon_inode permissive=3D1
> >   [  136.621036] audit: type=3D1300 audit(1662043624.701:94): arch=3Dc0=
00003e syscall=3D425 success=3Dyes exit=3D3 a0=3D40 a1=3D7ffca29835a0 a2=3D=
7ffca29835a0 a3=3D561529be2300 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 u=
id=3D1001 gid=3D1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=
=3D1002 fsgid=3D1002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mn=
t/src/liburing/test/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel=
_t key=3D(null)
> >   [  136.624812] audit: type=3D1327 audit(1662043624.701:94): proctitle=
=3D2F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F70617373=
7468726F7567682E74002F6465762F6E67306E31
> >   [  136.626074] audit: type=3D1400 audit(1662043624.702:95): avc:  den=
ied  { map } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_inode:[io=
_uring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system_r:kern=
el_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permissive=
=3D1
> >   [  136.628012] audit: type=3D1400 audit(1662043624.702:95): avc:  den=
ied  { read write } for  pid=3D263 comm=3D"io_uring_passth" path=3D"anon_in=
ode:[io_uring]" dev=3D"anon_inodefs" ino=3D11715 scontext=3Dsystem_u:system=
_r:kernel_t tcontext=3Dsystem_u:object_r:kernel_t tclass=3Danon_inode permi=
ssive=3D1
> >   [  136.629873] audit: type=3D1300 audit(1662043624.702:95): arch=3Dc0=
00003e syscall=3D9 success=3Dyes exit=3D140179765297152 a0=3D0 a1=3D1380 a2=
=3D3 a3=3D8001 items=3D0 ppid=3D252 pid=3D263 auid=3D1001 uid=3D1001 gid=3D=
1002 euid=3D1001 suid=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1=
002 tty=3Dpts1 ses=3D3 comm=3D"io_uring_passth" exe=3D"/mnt/src/liburing/te=
st/io_uring_passthrough.t" subj=3Dsystem_u:system_r:kernel_t key=3D(null)
> >   [  136.632415] audit: type=3D1327 audit(1662043624.702:95): proctitle=
=3D2F6D6E742F7372632F6C69627572696E672F746573742F696F5F7572696E675F70617373=
7468726F7567682E74002F6465762F6E67306E31
> >   [  136.633652] audit: type=3D1400 audit(1662043624.705:96): avc:  den=
ied  { cmd } for  pid=3D263 comm=3D"io_uring_passth" path=3D"/dev/ng0n1" de=
v=3D"devtmpfs" ino=3D120 scontext=3Dsystem_u:system_r:kernel_t tcontext=3Ds=
ystem_u:object_r:device_t tclass=3Dio_uring permissive=3D1
> >   [  136.635384] audit: type=3D1336 audit(1662043624.705:96): uring_op=
=3D46 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 suid=
=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:s=
ystem_r:kernel_t key=3D(null)
> >   [  136.636863] audit: type=3D1336 audit(1662043624.705:96): uring_op=
=3D46 items=3D0 ppid=3D252 pid=3D263 uid=3D1001 gid=3D1002 euid=3D1001 suid=
=3D1001 fsuid=3D1001 egid=3D1002 sgid=3D1002 fsgid=3D1002 subj=3Dsystem_u:s=
ystem_r:kernel_t key=3D(null)
> >
> > * From the output on time 136.633652 I see that the access should have
> >   been denied had selinux been enforcing.
> > * I also saw that the breakpoint hit.
> >
> > *** Without the patch:
> > * I ran the io_uring_passthrough.c test on a char device with an
> >   unpriviledged user.
> > * I took care of changing the permissions of /dev/ng0n1 to 666 prior
> >   to any testing.
> > * made sure that Selinux was in permissive mode.
> > * Made sure to have audit activated by passing "audit=3D1" to the kernel
> > * After noticing that some audit messages where getting lost I upped the
> >   backlog limit to 256
> > * There were no audit messages when I executed the test.
> >
> > As with my smack tests I would really appreciate feecback on the
> > approach I took to testing and it's validity.
>=20
> Hi Joel,
>=20
> Thanks for the additional testing and verification!  Work like this is
> always welcome, regardless if the patch has already been merged
> upstream.
np

>=20
> As far as you test approach is concerned, I think you are on the right
> track, I might suggest resolving the other SELinux/AVC denials you are
> seeing with your test application to help reduce the noise in the
> logs.  Are you familiar with the selinux-testsuite (link below)?
>=20
> * https://protect2.fireeye.com/v1/url?k=3D6f356c96-0ebe79ac-6f34e7d9-74fe=
4860008a-01002a6e4c92bb3e&q=3D1&e=3D46f33488-9311-49fa-9747-da210f2d147d&u=
=3Dhttps%3A%2F%2Fgithub.com%2FSELinuxProject%2Fselinux-testsuite
Thx. Could not figure out how to remove the AVC from a quick look at the
page, but I'll probably figures something out :).

ATM, I'm doing a performance test on the io_uring_passtrhough
path to see how much, if any, perf we loose.

Thx again

Best

Joel

>=20
> --=20
> paul-moore.com

--tn4kuwui4hxpj3fy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmMYU5EACgkQupfNUreW
QU+exwv/X0g5n1BRy1hY0yiluIr96eC5KUJVDsKLa8hRccMaHqD8CmJc86/FJFb4
66BjOajUlxxoatGoW63oAs4drA277IgDEGMkU9sDWZ72C5idsHkQjQIXlkhKHKrh
hhaWZGicOb858Gr+j8xixubSHS3sICaBEPQGBcqH5k0b5dSm+2VlfeeH/HYmErwM
OnUmvTbLjSDyn9qUtMiIXBmgUfOESJIRjoMpdtfjFx2cvW2cUiwYEyU6hynyJhUN
FxxHohdpsKHRoXM4SBqgO+jCw/tb8wX8+iO+fvwncP5DEpFXCKlEK8stUtUssDmG
2vWSaGPrlno4i/IvuemmhOagiIJO5JE614MfgTBla3AaJpdku4ABQYZQN6wyq1Fm
Oa4Y3zdGmUErBQYJ9wDcYHuCnnCH/if0KmxbXZhkfbp5/eLwLn59VH1TBJsKiWx2
gk1y61Upt1PPWbtxA2nRZMqoZdz4lC5LA9wSRtICSJmPZsUd9sX8ovmF5hc993rH
phKt3Je+
=eCfq
-----END PGP SIGNATURE-----

--tn4kuwui4hxpj3fy--
