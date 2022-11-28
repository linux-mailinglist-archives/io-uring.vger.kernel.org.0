Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFBB63A4EA
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 10:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiK1J1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 04:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiK1J1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 04:27:18 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9055518E2E;
        Mon, 28 Nov 2022 01:27:14 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221128092712euoutp0261173c1cabdabfbf147a5c7e04f03aa1~rtXxdPMls2891228912euoutp02-;
        Mon, 28 Nov 2022 09:27:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221128092712euoutp0261173c1cabdabfbf147a5c7e04f03aa1~rtXxdPMls2891228912euoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669627632;
        bh=jlmtysTo2zXH1bzRY6C5IgZ1Ep13550z9Ybaw+sDGwA=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=IzEwcP+GWafS0wzAmkVZGDgg1d+mP8Q9OccfNl3ovNAxEDuT/kgyEag2fEWl1QIFD
         5jOL/dKB1SZXUCl+a5btJE4bIRjT4+fkJubGGukGvxMvP5O4RMkrfQS2R48EGBhLJ+
         nG2L0SHNA4sQ3c94k35Qm1GbuANTNfGgdWrPUViw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221128092712eucas1p190431d9a53f883f1fbff25bd3115f049~rtXxSSe_O3050730507eucas1p14;
        Mon, 28 Nov 2022 09:27:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 3F.7B.10112.0FE74836; Mon, 28
        Nov 2022 09:27:12 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221128092712eucas1p21911bd6c1780f59bfc923f4e7e4f2ba6~rtXw6dl2Z3263332633eucas1p2V;
        Mon, 28 Nov 2022 09:27:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221128092712eusmtrp163775f6450cd3d9349cc04f41b2e0cfe~rtXw5tFfY1456814568eusmtrp1X;
        Mon, 28 Nov 2022 09:27:12 +0000 (GMT)
X-AuditID: cbfec7f4-cf3ff70000002780-3e-63847ef0a82a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D1.07.09026.FEE74836; Mon, 28
        Nov 2022 09:27:11 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221128092711eusmtip17e55abe82590d56e4184e6c510f882df~rtXwvLhYl2152721527eusmtip1-;
        Mon, 28 Nov 2022 09:27:11 +0000 (GMT)
Received: from localhost (106.210.248.49) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Mon, 28 Nov 2022 09:27:11 +0000
Date:   Mon, 28 Nov 2022 10:27:09 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     <mcgrof@kernel.org>, <ddiss@suse.de>, <joshi.k@samsung.com>,
        <ming.lei@redhat.com>, <linux-security-module@vger.kernel.org>,
        <axboe@kernel.dk>, <io-uring@vger.kernel.org>
Subject: Re: [RFC v2 1/1] Use a fs callback to set security specific data
Message-ID: <20221128092709.5rq27tasnyek5ych@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="xd7levmh2jfxsrdl"
Content-Disposition: inline
In-Reply-To: <CAHC9VhTs26x+6TSbPyQg7y0j=gLCc=_GPgmiUgA34wfxmakvZQ@mail.gmail.com>
X-Originating-IP: [106.210.248.49]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSf0yMcRzH973n6em53NnTVe6jMC5CncLC+ZUfs7nYxBijGbfziHVdueuU
        /JhKRrMcp8URdwvVpZNKu2oubpZxuFYiP9pxXbJK5coIKz09GZv/3p/X+/Pe9/PeviQmeO4V
        SO5XJtMqpUwhInzwqvpBx5y+Yyfkc1vc/pKS1rOE5OtwHi7pyXqOS/rOuAhJi7YdSWy6TI7k
        7fk8fKW3tOmZRlpuOk1IS+99QtJeazMhrbAflvaXT9lI7PBZtodW7D9IqyKidvvsu9/cjCW1
        iVOv9j0gjqPG4GzEJYGKhE7tCywb+ZACqgjBgLWLww4DCDo8uTg79CNocDbhfyI30xsI1ihE
        cO9XN8EYo1tv82JZo3JED3dzGAOnZoDzVj7GaIISg6P73aj2p6ZDQfttxAQwqhyB52e2N2P4
        UdHw/oR+5DmS5FOLoNQyh8F8yhceX3KPXoFRqfCs4qoXs4JRQVA4RDKYS20C50M3Yg8Vwa0W
        K8Hqo/Ck8s1oNaAuc8GRfsGbNdbAx/6OsYAfdD6qHOOTwK47M9Y4Hqov1GCsTgL941yCeReo
        pZDzVMHiVdBafZ/D4vHQ8tmXvXI8nK/Kw1jMh1MnBex2CFgy7iItCtb/00v/Ty/9314sFoOh
        1kP8h8PgprELY/VyMJt7cQPyNiEhrVEnxNHq+Uo6JVwtS1BrlHHh8sSEcjTyzexDjwYsqLDz
        S7gNcUhkQ9NHwq6ykgYUiCsTlbTInz8bZcoF/D2yQ2m0KnGXSqOg1TYUROIiIZ+4GCoXUHGy
        ZDqeppNo1R+XQ3IDj3NCphZ1+OZP+3HD69oyP6PoHJoorltrWF5X3BuX5Z62+k3izJdLznFj
        6gXSKrPLs7lrxcNvufKi7QcWmDJ0whiDq27ni57rU33b3g8euOE+ojVJDOag2pWd7Ys1Tn6T
        eeurfE/aLKMqxzgcFq0zxhfycgrKYosHMq4c3L67eNypS5nZ61t3xtcO1g61Bn+4bCO77N+r
        QwN+rNJGTw4IS9aVvMYXlvCEW3jphyPd+Q5LTERUbGmj/eVJcZZqqCdi7zerwmWNbFsS9YTE
        UzyvyMand4+lBAVa1u0yEQEbqqQhMucd3pHFZdHCtPkO//rTNbFLF07oTuUFF2DbeDUV6VST
        CFfvk80LxVRq2W9ILv944QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xu7rv61qSDd6+sbRYfbefzeLr/+ks
        Fu9az7FYfOh5xGZxY8JTRotDk5uZLG5Pms7iwO5x+Wypx6ZVnWwea/e+YPR4v+8qm8fm09Ue
        nzfJBbBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl
        6GUcvHSQveChTsXZzi2MDYwXlLsYOTkkBEwkljVeYOti5OIQEljKKPF8z3pmiISMxKcrH9kh
        bGGJP9e6oIo+Mkp8fPqWHcLZAtSxejoLSBWLgKrE/TVzwbrZBHQkzr+5A2aLCKhILH66nhGk
        gVlgE6PEp99dYGOFBTwlHrTMAmrm4OAVMJdYu0MXYmgXk8TyLpB1nEBxQYmTM5+ALWAWKJPo
        ntXMBFLPLCAtsfwfB0iYUyBQ4v6RJ4wQlypJrLmxjw3CrpX4/PcZ4wRG4VlIJs1CMmkWwiSI
        sJbEjX8vMYW1JZYtfM0MYdtKrFv3nmUBI/sqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwMje
        duznlh2MK1991DvEyMTBeIhRBajz0YbVFxilWPLy81KVRHg1GZuThXhTEiurUovy44tKc1KL
        DzGaAkNxIrOUaHI+MOXklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJpCeWpGanphakFsH0MXFw
        SjUwmQrXOZbEioYdYhevmTSrzFrLs7qtOqC/Mm/Z3Oca1Re9o6u7EkpelLlmn+t3O7Bw5/fj
        j+7rPf5qdMe/uy7r5EGdqpvJHx0dOH4H/7kX+qPuEg9TVOvBkAbRztmvS4KSl31z3R8y+eTm
        lXO9Onuci1KP36l+rW9iY2FjtNPE+51y7VN1S0nu/xP/MNcvPfI5I0dq8rnZ4Ru6Mt+w6XVM
        fGgWK9odv+gtZ5Imt451ku7G4v2cSd9nHjW5a95tyfplVoRJ6kuBU+/mXl7Bx7qsazJf1Hs/
        v+7+T1anbkn/0GYIOXp75oMl4VXXQ9dLRN3nnrZn9RMNm67Lk748fRY9JycwIYnjvkL662Ij
        7/NKLMUZiYZazEXFiQAjtkKigQMAAA==
X-CMS-MailID: 20221128092712eucas1p21911bd6c1780f59bfc923f4e7e4f2ba6
X-Msg-Generator: CA
X-RootMTR: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
References: <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
        <20221122103144.960752-1-j.granados@samsung.com>
        <20221122103144.960752-2-j.granados@samsung.com>
        <CAHC9VhTs26x+6TSbPyQg7y0j=gLCc=_GPgmiUgA34wfxmakvZQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--xd7levmh2jfxsrdl
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 04:02:02PM -0500, Paul Moore wrote:
> On Tue, Nov 22, 2022 at 5:35 AM Joel Granados <j.granados@samsung.com> wr=
ote:
> >
> > Signed-off-by: Joel Granados <j.granados@samsung.com>
> > ---
> >  drivers/nvme/host/core.c      | 10 ++++++++++
> >  include/linux/fs.h            |  2 ++
> >  include/linux/lsm_hook_defs.h |  3 ++-
> >  include/linux/security.h      | 16 ++++++++++++++--
> >  io_uring/uring_cmd.c          |  3 ++-
> >  security/security.c           |  5 +++--
> >  security/selinux/hooks.c      | 16 +++++++++++++++-
> >  7 files changed, 48 insertions(+), 7 deletions(-)
>=20
> ...
>=20
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index f553c370397e..9fe3a230c671 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -21,6 +21,8 @@
> >   *  Copyright (C) 2016 Mellanox Technologies
> >   */
> >
> > +#include "linux/nvme_ioctl.h"
> > +#include "linux/security.h"
> >  #include <linux/init.h>
> >  #include <linux/kd.h>
> >  #include <linux/kernel.h>
> > @@ -6999,18 +7001,30 @@ static int selinux_uring_sqpoll(void)
> >   * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
> >   *
> >   */
> > -static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
> > +static int selinux_uring_cmd(struct io_uring_cmd *ioucmd,
> > +       int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct securi=
ty_uring_cmd*))
> >  {
>=20
> As we discussed in the previous thread, and Casey mentioned already,
> passing a function pointer for the LSM to call isn't a great practice.
> When it was proposed we hadn't really thought of any alternatives, but
> if we can't find a good scalar value to compare somewhere, I think
> inspecting the file_operations::owner::name string to determine the
> target is preferable to the function pointer approach described here.

We don't only need to determine the target; we need the target to
specify the current operation to the LSM infra so it can do its thing.

To me, if we just identify, we would need to have some logic in the
uring_cmd that goes through all the possible uring users to execute
their security specific functions. (Paul please correct me if I'm
misunderstanding you). Something like this

switch (uring_user_type(req->file->f_op->name)):
case nvme:
  nvme_specific_sec_call();
case ublk:
  ublk_specific_sec_call();
case user3:
  user3_specific_sec_call();
=2E.... etc...

This is not scalable because there would need to be uring user code in
uring and that makes no sense as uring is agnostic to whatever is using
it.

>=20
> Although I really would like to see us find, or create, some sort of
> scalar token ID we could use instead.  I fear that doing a lot of
> strcmp()'s to identify the uring command target is going to be a
> problem (one strcmp() for each possible target, multiplied by the
> number of LSMs which implement a io_uring command hook).
Agreed, depending on string compare does not scale.

>=20
> >         struct file *file =3D ioucmd->file;
> >         struct inode *inode =3D file_inode(file);
> >         struct inode_security_struct *isec =3D selinux_inode(inode);
> >         struct common_audit_data ad;
> > +       const struct cred *cred =3D current_cred();
> > +       struct security_uring_cmd sec_uring =3D {0};
> > +       int ret;
> >
> >         ad.type =3D LSM_AUDIT_DATA_FILE;
> >         ad.u.file =3D file;
> >
> > +       ret =3D uring_cmd_sec(ioucmd, &sec_uring);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (sec_uring.flags & SECURITY_URING_CMD_TYPE_IOCTL)
> > +               return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) io=
ucmd->cmd_op);
>=20
> As mentioned previously, we'll need a SELinux policy capability here
> to preserve the SECCLASS_IO_URING/IO_URING__CMD access check for
> existing users/policies.  I expect the logic would look something like
> this (of course the details are dependent on how we identify the
> target module/device/etc.):
>=20
>   if (polcap_foo && uring_tgt) {
>     switch (uring_tgt) {
>     case NVME:
>       return avc_has_perm(...);
>     default:
>       WARN();
>       return avc_has_perm(SECCLASS_IO_URING, IO_URING__CMD);
>     }
>   } else
>     return avc_has_perm(SECCLASS_IO_URING, IO_URING__CMD);
>=20
This is selinux specific. right? I ask because I want to have it
strait in my head what is LSM generic and what is needed for a specific
implementation of an LSM.

> >         return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> >                             SECCLASS_IO_URING, IO_URING__CMD, &ad);
> > +
> >  }
> >  #endif /* CONFIG_IO_URING */
>=20
> --=20
> paul-moore.com

--xd7levmh2jfxsrdl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmOEfusACgkQupfNUreW
QU9mwgv+McQu6DKFwvGb/nN+1SlCtuoJUyzA7TaNWmFSummwUdPvaaU31AxPOI5U
uVSVPqeqG6yq/QeB4cUEryhQ1ofDj9xfbBlwdZ/MKfc3APya06PyKK/4OSnVFhb+
Y/qGXWmoq/IVmqxT0F0vKkA8slPhRpua6jbsvamFyrn5wZ6taDM+X9g/l4vDf/ep
ehR9j5uk9OmrCTVR8m1SwUDIzu0q/2JoueH1AtASx5oYPnR0cfcj5uSEpSlkyAQy
4/MKODxukZ6JCXwEr2rdmKffH8k5kQC6SelMD4PssSSxXtrGRHuvPEkCECg6vY4E
ORuBKrD3AqjX9pqKOg0YZT7RA7sDHVyMz3GReBH5sF0C8IeM5rqQVyMPXvhyRCgl
8UIJPPXwM9Bm/8jy/TfDtI+DSjY+F/3hSoVjVzop3JdKLIDUlzBMjDv3kGeHAbQ8
4pJ9U3H8MJd0qx9rQZLzMSQDNP+LxLaTzM4kkNIKJujC1oWxn/X3D5gU2WTWTo2f
1OHVmmqt
=1Xku
-----END PGP SIGNATURE-----

--xd7levmh2jfxsrdl--
