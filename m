Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B8B62D6BF
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 10:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbiKQJ0X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 04:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240048AbiKQJ0C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 04:26:02 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A4931371;
        Thu, 17 Nov 2022 01:25:52 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221117092549euoutp0262cf81347b1a418339bb8389d5fa8e0d~oVQa0hgBV2581625816euoutp02r;
        Thu, 17 Nov 2022 09:25:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221117092549euoutp0262cf81347b1a418339bb8389d5fa8e0d~oVQa0hgBV2581625816euoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668677149;
        bh=y1DU/xj25pEk6GG2JbqNHNZBSusRczTGRBPOphrPyOc=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=g7DDRPdtvgkke1nzcwVCOpy/JyVbKuDY8Y644z2b1CnRMEIgOfngOkVt4TyzefnqP
         AbpJWOj3x3ClzjzvFCqEFLKbKFRyg598xx0MY9mHEPOkh87zxPhWebV6TP0f4pGHaR
         mplJ0mBll1+pDI2kypT9MZcZoa8KIyavczItZ6x8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221117092549eucas1p2495847f0ebbff490e609a3c12e637cdf~oVQarg1Av0528105281eucas1p2_;
        Thu, 17 Nov 2022 09:25:49 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CC.8E.10112.C1EF5736; Thu, 17
        Nov 2022 09:25:48 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221117092548eucas1p13ec3e9fc735ca2cd414d83ce364717c8~oVQaUgY0q2241822418eucas1p1a;
        Thu, 17 Nov 2022 09:25:48 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221117092548eusmtrp1de838df10351994ce9fff090308face0~oVQaT7J2u1639916399eusmtrp1B;
        Thu, 17 Nov 2022 09:25:48 +0000 (GMT)
X-AuditID: cbfec7f4-d09ff70000002780-d6-6375fe1cc662
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DF.55.09026.C1EF5736; Thu, 17
        Nov 2022 09:25:48 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221117092548eusmtip265e6c3cc23a11292074188eda237be4b~oVQaGZf_72935429354eusmtip2U;
        Thu, 17 Nov 2022 09:25:48 +0000 (GMT)
Received: from localhost (106.210.248.19) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Thu, 17 Nov 2022 09:25:47 +0000
Date:   Thu, 17 Nov 2022 10:25:46 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
CC:     <ddiss@suse.de>, <mcgrof@kernel.org>, <paul@paul-moore.com>,
        <linux-security-module@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <20221117092546.hjzbt52pprztt6dh@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="ycpniufdpqbtvpv2"
Content-Disposition: inline
In-Reply-To: <20221116173821.GC5094@test-zns>
X-Originating-IP: [106.210.248.19]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7djPc7oy/0qTDQ7tsbb4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYorhsUlJzMstSi/TtErgy
        btz4wVLwSbHiwJ2FrA2M56W7GDk5JARMJH79fMfYxcjFISSwglHi6p7/UM4XRokL51vYIJzP
        jBIPT3WxwrTsOH6NBSKxnFHi4LoWVriqGYfmQLVsYZSYvGsbO0gLi4CqxMKHM8Ha2QR0JM6/
        ucMMYosIqEt0TD/HBNLALNDGKHF+2i2whLBAjsTVbW/YQGxeAXOJJZ297BC2oMTJmU9YQGxm
        gQqJbbcnAtkcQLa0xPJ/HCBhTgFdif0b57JAnKok8WzjdKizayXWHjvDDrJLQqCdU+LRoQtQ
        CReJg8v6oBqEJV4d38IOYctInJ7cAxXPltg5ZRczhF0gMevkVDaQvRIC1hJ9Z3Igwo4S7fM3
        M0KE+SRuvBWEuJJPYtK26cwQYV6JjjYhiGo1iR1NWxknMCrPQvLXLCR/zUL4CyKsI7Fg9yc2
        DGFtiWULXzND2LYS69a9Z1nAyL6KUTy1tDg3PbXYKC+1XK84Mbe4NC9dLzk/dxMjMFWd/nf8
        yw7G5a8+6h1iZOJgPMSoAtT8aMPqC4xSLHn5ealKIry5F0uThXhTEiurUovy44tKc1KLDzFK
        c7AoifOyzdBKFhJITyxJzU5NLUgtgskycXBKNTDN0NpgY3BlRxJ7n7GY4/tE+0aTiDxn64v1
        3+RVHp+S6r4ocJZp2br2vY5ezX8r14lmzikW+/j1SbXzygUfhVmClsrkhL2pK3jWt+3dzepv
        r5/vlwu0zNPJrJTdsv2Ji279p+1BanHxhXpGs0PmayyanTW3rY1t3t0jkc6TE870+JlFGx3z
        CLM7qL50p4/14stMAu83bDWcYTftNM9qIfWuxm+tSz325gmYiEekZpU0pws+Sqv7tv1YsKPz
        z7Zt2ydNjVOI3GN6d2kyX12+5Ix4rQkOHTMlWERsLzQeUp6TdHnBIaVPfGdVu1f3ck61rYjX
        jVkZNUeKPSg5fb7fpoeyh+ekuR98MT8lOTwgXImlOCPRUIu5qDgRAEViBZ7QAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/xe7oy/0qTDc6+UbT4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYovRsivJLS1IVMvKLS2yV
        og0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQyrv5+z1LwQbFi7dVfLA2MZ6W7
        GDk5JARMJHYcv8bSxcjFISSwlFHi0MXvTBAJGYlPVz6yQ9jCEn+udbFBFH1klFjzrJ0ZwtnC
        KPH860qwDhYBVYmFD2eygthsAjoS59/cYQaxRQTUJTqmn2MCaWAWaGOUOD/tFlhCWCBH4uq2
        N2wgNq+AucSSzl52iKkvGCX+3YDYzSsgKHFy5hOgAzmAussktm9QgzClJZb/4wCp4BTQldi/
        cS4LxKVKEs82TmeFsGslXt3fzTiBUXgWkkGzEAbNQhgEUsEsoCVx499LJgxhbYllC18zQ9i2
        EuvWvWdZwMi+ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzBitx37uWUH48pXH/UOMTJxMB5i
        VAHqfLRh9QVGKZa8/LxUJRHe3IulyUK8KYmVValF+fFFpTmpxYcYTYGBOJFZSjQ5H5hK8kri
        Dc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamPSEVHPe27Vw3L5iLJzO
        d2lxkeHp7zPFK5rat23XV3z6Kfa67POMZ8uNJvzdMiXj6d3zc7YnPd60tGTxkfNGZ5Z+CzcJ
        1PA4zet8ZVq6M/u71XcfhLSxarzX5vqfu8rn6NQVTz+1WCvOCa214gtarepZcPV3TmtTGLeQ
        R0+D+xrxqwpvvm2sv/By1jHV7Z5nny12f/9O4Ne6+67VB4urzv4+LZVc90FnRdn5tNM/XKZW
        vbguyScuWXWOV2qp1v6Vjz2anjk3iLy6sGPGFm8ft7SsBzKPlj5t3FjGduuM2MVkufdhjj8u
        a6Sp+R0MqTX+c+Br2FdzPks2owmHHoYe+MjOcUC/26rO5uyvDVI5IvpKLMUZiYZazEXFiQDP
        Ya9/bQMAAA==
X-CMS-MailID: 20221117092548eucas1p13ec3e9fc735ca2cd414d83ce364717c8
X-Msg-Generator: CA
X-RootMTR: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
References: <20221116125051.3338926-1-j.granados@samsung.com>
        <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
        <20221116125051.3338926-2-j.granados@samsung.com>
        <20221116173821.GC5094@test-zns>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--ycpniufdpqbtvpv2
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2022 at 11:08:21PM +0530, Kanchan Joshi wrote:
> On Wed, Nov 16, 2022 at 01:50:51PM +0100, Joel Granados wrote:
> > Signed-off-by: Joel Granados <j.granados@samsung.com>
> > ---
> > security/selinux/hooks.c | 15 +++++++++++++--
> > 1 file changed, 13 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index f553c370397e..a3f37ae5a980 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -21,6 +21,7 @@
> >  *  Copyright (C) 2016 Mellanox Technologies
> >  */
> >=20
> > +#include "linux/nvme_ioctl.h"
> > #include <linux/init.h>
> > #include <linux/kd.h>
> > #include <linux/kernel.h>
> > @@ -7005,12 +7006,22 @@ static int selinux_uring_cmd(struct io_uring_cm=
d *ioucmd)
> > 	struct inode *inode =3D file_inode(file);
> > 	struct inode_security_struct *isec =3D selinux_inode(inode);
> > 	struct common_audit_data ad;
> > +	const struct cred *cred =3D current_cred();
> >=20
> > 	ad.type =3D LSM_AUDIT_DATA_FILE;
> > 	ad.u.file =3D file;
> >=20
> > -	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> > -			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
> > +	switch (ioucmd->cmd_op) {
> > +	case NVME_URING_CMD_IO:
> > +	case NVME_URING_CMD_IO_VEC:
> > +	case NVME_URING_CMD_ADMIN:
> > +	case NVME_URING_CMD_ADMIN_VEC:
>=20
> We do not have to spell out these opcodes here.
> How about this instead:
>=20
> +       /*
> +        * nvme uring-cmd continue to follow the ioctl format, so reuse w=
hat
> +        * we do for ioctl.
> +        */
> +       if(_IOC_TYPE(ioucmd->cmd_op) =3D=3D 'N')
> +               return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) iouc=
md->cmd_op);
> +       else
> +               return avc_has_perm(&selinux_state, current_sid(), isec->=
sid,
> +                                   SECCLASS_IO_URING, IO_URING__CMD, &ad=
);
> +       }
> +
>=20
> Now, if we write the above fragment this way -
>=20
> if (__IOC_TYPE(ioucmd->cmd_op) !=3D 0)
> 	reuse_what_is_done_for_ioctl;
> else
> 	current_check;

This is even cleaner. I really like this solution.
>=20
> That will be bit more generic and can support more opcodes than nvme.
> ublk will continue to fall into else case, but something else (of
> future) may go into the if-part and be as fine-granular as ioctl hook
> has been.
I also see that this is the case. Since the io_uring command does not
have a predefined structure another solution for the non ioctl io_uring
commands needs to be found.

> Although we defined new nvme opcodes to be used with uring-cmd, it is
> also possible that some other provider decides to work with existing
> ioctl-opcode packaged inside uring-cmd and turns it async. It's just
> another implmentation choice.
>=20
> Not so nice with the above could be that driver-type being 0 seems
> under conflict already. The table in this page:
> https://www.kernel.org/doc/html/latest/userspace-api/ioctl/ioctl-number.h=
tml
> But that is first four out of many others. So those four will fall into
> else-part (if ever we get there) and everything else will go into the
> if-part.
Agreed, the fact that we might have these crashes also seems to be
another CON for using the ioctl approach

>=20
> Let's see whether Paul considers all this an improvement from what is
> present now.



--ycpniufdpqbtvpv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmN1/hcACgkQupfNUreW
QU/fYwv/dcB3yLs4cV5/K7zJJWfstPf78hYUBRFVuq0WENArCfnA1J8qY+T+EnF0
LZmrgDfHmuaBWuE7+oDw5k50m8TheUZnNpXlfgRaN0YUIQwjbw9ZQgkaTj2h/w9A
aCeqZ45Ge3e5mwrJ/Vf+JfAdm8XA+YZElvSMKR//eduviGkn8ZHTapAirzB/Gb4b
lKAl2KvaU2eVCXW9bbbaoYsZTfdtFEqmn5GPMO4olrsfJzvXe/5+lbxaZgtcajHA
jQFzaM+E9BzBOV5o5tfgsyW8O5hxQKUsWDDKsshH0dU6TVDoGfnFVh48PL0mJXJL
6MWpIq2YmIWsHIz0g8PQcneH6IHw3r7EmNR3u4uqXV4dK6IziWeNMf26mBI4kT+j
x8BGpvDf4ySP0KJDuTqMw9eHqlFuAu2+QaIGrXn734tIMO37Pv9zv/Iwo8ZzyRMA
HPZTJelvtf1CHPkhw3aSY49o3To6BHfyRI8XU1w9Nn2y0iumB+i/yzM0bTNKADC7
dwGcXGxN
=FGuZ
-----END PGP SIGNATURE-----

--ycpniufdpqbtvpv2--
