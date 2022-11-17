Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D3A62D731
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 10:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiKQJkO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 04:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbiKQJkL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 04:40:11 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE6612094;
        Thu, 17 Nov 2022 01:40:08 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221117094006euoutp02298f95574c6364af5f161659948468bf~oVc5Y1Dj00861108611euoutp02z;
        Thu, 17 Nov 2022 09:40:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221117094006euoutp02298f95574c6364af5f161659948468bf~oVc5Y1Dj00861108611euoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668678006;
        bh=55/L057HC2RqHj0E91P2DkKxIf8atjeCTL9kABwz3oQ=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=MGH6GpXDp3yf4EPZ0u7QFRSLYWN9Dss5iQCozBGvoesh0nWjEm9rTgP8d2JTNEkAe
         GNILwQ7sDkW90SKdBExlmkebj3GJvqBm6RhOsqoQFiSrIYdHI9G882w9jPiIcfSyaV
         dfjJVJdMSDrss45WEL6d2UgGtTDZCV5+jy0c4MF8=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221117094006eucas1p2e5e8c9dd6c1cde6808829769d388576e~oVc5PdExR2090820908eucas1p2-;
        Thu, 17 Nov 2022 09:40:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id FB.34.09561.67106736; Thu, 17
        Nov 2022 09:40:06 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221117094006eucas1p10e90bb11eeeb53ae1a728e9c85ca566c~oVc47WYhw2980629806eucas1p1L;
        Thu, 17 Nov 2022 09:40:06 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221117094006eusmtrp2061da6143aef935279ca53f7162513c7~oVc46u4Qu2808128081eusmtrp2F;
        Thu, 17 Nov 2022 09:40:06 +0000 (GMT)
X-AuditID: cbfec7f2-0b3ff70000002559-da-63760176bc80
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 60.08.09026.67106736; Thu, 17
        Nov 2022 09:40:06 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221117094005eusmtip1bca3e5f8f6a54b90c8494ca5163addd6~oVc4v1kiO2168521685eusmtip1r;
        Thu, 17 Nov 2022 09:40:05 +0000 (GMT)
Received: from localhost (106.210.248.19) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Thu, 17 Nov 2022 09:40:05 +0000
Date:   Thu, 17 Nov 2022 10:40:04 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>, <ddiss@suse.de>,
        <mcgrof@kernel.org>, <linux-security-module@vger.kernel.org>,
        <io-uring@vger.kernel.org>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <20221117094004.b5l64ipicitphkun@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="nklquilnr5juu4kb"
Content-Disposition: inline
In-Reply-To: <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
X-Originating-IP: [106.210.248.19]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7djP87pljGXJBtf/S1p8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxe9J0FgdWj02rOtk81u59weix+XS1x+dNcgEsUVw2Kak5mWWpRfp2CVwZ
        z7bdZSvoNqlYMWEPYwPjQc0uRk4OCQETidMdbYxdjFwcQgIrGCV+7vkM5XxhlHg07ywThPOZ
        UeL6pxvsMC1LXoPYIInljBJHH3WwwFXdeX2eFcLZwiix9cgXZpAWFgFViUMb7zGC2GwCOhLn
        39wBi4sIqEgsfroebCGzwDRGiZsTdrKCJIQFciSubnvDBmLzCphLLNp1nBHCFpQ4OfMJC4jN
        LFAh8fjdY6BBHEC2tMTyfxwgYU6BQImr+7cxQ5yqJPFs43RWCLtWYu2xM2BnSwg0c0rc3L6e
        ESLhIvFz8yeoImGJV8e3QP0pI/F/53wmCDtbYueUXVBDCyRmnZzKBrJXQsBaou9MDkTYUaJ9
        /mZGiDCfxI23ghBX8klM2jadGSLMK9HRJgRRrSaxo2kr4wRG5VlI/pqF5K9ZCH9BhHUkFuz+
        xIYhrC2xbOFrZgjbVmLduvcsCxjZVzGKp5YW56anFhvmpZbrFSfmFpfmpesl5+duYgSmqtP/
        jn/awTj31Ue9Q4xMHIyHGFWAmh9tWH2BUYolLz8vVUmEN/diabIQb0piZVVqUX58UWlOavEh
        RmkOFiVxXrYZWslCAumJJanZqakFqUUwWSYOTqkGJo0F/tc5Fzh2eV85NUHtKGNWlXmjQbHZ
        hL23fqpc3vpLM+jzLjebvj3HztxYzTIr/9KDldq2shXux3xrPA72G+60CRJV8naSP/li5o72
        I0/Xp59T1V3KlG1XFhX+LsUr6lGwxZ0175evOzdV54qY9uwLj0Lt6oW2POz+mteyiqtfSebL
        FT5D1Zg9yRN3lPUa2ype22V0yCFWfVOt7BQG7R+pB60NGVxPLXFfGO7nN3FLbxgbr7jXpryL
        dnUhjOvffO7bs/bHnF9l31Ofdrw5sF37vYBm6t3bfydHOeRoXPpZuNuaI7HqoKnajS6FBWZ5
        zm3/Kjx2aX9bqcpz6eD+lH/mWxq77p5UCz1XF3ttoxJLcUaioRZzUXEiAE10gOzQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/xu7pljGXJBkePsFt8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxe9J0FgdWj02rOtk81u59weix+XS1x+dNcgEsUXo2RfmlJakKGfnFJbZK
        0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZnftbGQs6TSq6fmQ2MO7X7GLk
        5JAQMJFY8voGexcjF4eQwFJGiT0bf7FBJGQkPl35yA5hC0v8udbFBlH0kVFiefsyVghnC6PE
        s5nXWECqWARUJQ5tvMcIYrMJ6Eicf3OHGcQWEVCRWPx0PSNIA7PAFEaJh/9awMYKC+RIXN32
        Bmwdr4C5xKJdx8GahQTWM0n09RlCxAUlTs58AraAWaBMoqvzIFAvB5AtLbH8HwdImFMgUOLq
        /m3MEJcqSTzbOJ0Vwq6VeHV/N+MERuFZSCbNQjJpFsIkiLCWxI1/L5kwhLUlli18zQxh20qs
        W/eeZQEj+ypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAiN127OeWHYwrX33UO8TIxMF4iFEF
        qPPRhtUXGKVY8vLzUpVEeHMvliYL8aYkVlalFuXHF5XmpBYfYjQFhuJEZinR5HxgKskriTc0
        MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5NLUgtgulj4uCUamAKXjo9rSmgcK2T5fWM+Sd+
        3rmh9vrIh6gg5jscPmHhYlFqy0VSFkcpCE+frR/6R/pU+d7vbvtDLnw6d4FRznTeX76X9Ye6
        Knl/LHU/oJHstKH7106bUw6JCw6endXku8M/9rtk75T47Q/5D71rcVyuNpnpheaK6VkZfAVW
        V3lMJKI8SlKffzn9J+NAUIB7+/XWohUHO1Y73FQ+lzZzjbJgo9da3oNCmfrCnZlsW5UsFjNP
        TnpXP/vx5e8+9pMXd6muM7zKGZ/sH7ZplYyvSX1480v+youzTBN2O6b+eyd3VetvuzhLioOe
        1w5rs7nv9149cclHsem/nUvcG06xD8tFNp5YtON876zDjFO7r55RYinOSDTUYi4qTgQAGPlM
        sm0DAAA=
X-CMS-MailID: 20221117094006eucas1p10e90bb11eeeb53ae1a728e9c85ca566c
X-Msg-Generator: CA
X-RootMTR: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221116125431eucas1p1dfd03b80863fce674a7c662660c94092
References: <20221116125051.3338926-1-j.granados@samsung.com>
        <CGME20221116125431eucas1p1dfd03b80863fce674a7c662660c94092@eucas1p1.samsung.com>
        <20221116125051.3338926-2-j.granados@samsung.com>
        <20221116173821.GC5094@test-zns>
        <CAHC9VhSVzujW9LOj5Km80AjU0EfAuukoLrxO6BEfnXeK_s6bAg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--nklquilnr5juu4kb
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> On Wed, Nov 16, 2022 at 12:49 PM Kanchan Joshi <joshi.k@samsung.com> wrot=
e:
> > On Wed, Nov 16, 2022 at 01:50:51PM +0100, Joel Granados wrote:
> > >Signed-off-by: Joel Granados <j.granados@samsung.com>
> > >---
> > > security/selinux/hooks.c | 15 +++++++++++++--
> > > 1 file changed, 13 insertions(+), 2 deletions(-)
> > >
> > >diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > >index f553c370397e..a3f37ae5a980 100644
> > >--- a/security/selinux/hooks.c
> > >+++ b/security/selinux/hooks.c
> > >@@ -21,6 +21,7 @@
> > >  *  Copyright (C) 2016 Mellanox Technologies
> > >  */
> > >
> > >+#include "linux/nvme_ioctl.h"
> > > #include <linux/init.h>
> > > #include <linux/kd.h>
> > > #include <linux/kernel.h>
> > >@@ -7005,12 +7006,22 @@ static int selinux_uring_cmd(struct io_uring_c=
md *ioucmd)
> > >       struct inode *inode =3D file_inode(file);
> > >       struct inode_security_struct *isec =3D selinux_inode(inode);
> > >       struct common_audit_data ad;
> > >+      const struct cred *cred =3D current_cred();
> > >
> > >       ad.type =3D LSM_AUDIT_DATA_FILE;
> > >       ad.u.file =3D file;
> > >
> > >-      return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> > >-                          SECCLASS_IO_URING, IO_URING__CMD, &ad);
> > >+      switch (ioucmd->cmd_op) {
> > >+      case NVME_URING_CMD_IO:
> > >+      case NVME_URING_CMD_IO_VEC:
> > >+      case NVME_URING_CMD_ADMIN:
> > >+      case NVME_URING_CMD_ADMIN_VEC:
> >
> > We do not have to spell out these opcodes here.
> > How about this instead:
> >
> > +       /*
> > +        * nvme uring-cmd continue to follow the ioctl format, so reuse=
 what
> > +        * we do for ioctl.
> > +        */
> > +       if(_IOC_TYPE(ioucmd->cmd_op) =3D=3D 'N')
> > +               return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) io=
ucmd->cmd_op);
> > +       else
> > +               return avc_has_perm(&selinux_state, current_sid(), isec=
->sid,
> > +                                   SECCLASS_IO_URING, IO_URING__CMD, &=
ad);
> > +       }
> > +
> >
> > Now, if we write the above fragment this way -
> >
> > if (__IOC_TYPE(ioucmd->cmd_op) !=3D 0)
> >         reuse_what_is_done_for_ioctl;
> > else
> >         current_check;
> >
> > That will be bit more generic and can support more opcodes than nvme.
> > ublk will continue to fall into else case, but something else (of
> > future) may go into the if-part and be as fine-granular as ioctl hook
> > has been.
> > Although we defined new nvme opcodes to be used with uring-cmd, it is
> > also possible that some other provider decides to work with existing
> > ioctl-opcode packaged inside uring-cmd and turns it async. It's just
> > another implmentation choice.
> >
> > Not so nice with the above could be that driver-type being 0 seems
> > under conflict already. The table in this page:
> > https://www.kernel.org/doc/html/latest/userspace-api/ioctl/ioctl-number=
=2Ehtml
> > But that is first four out of many others. So those four will fall into
> > else-part (if ever we get there) and everything else will go into the
> > if-part.
> >
> > Let's see whether Paul considers all this an improvement from what is
> > present now.
>=20
> There are a two things that need consideration:
>=20
> * The current access control enforces the SELinux io_uring/cmd
> permission on all io_uring command passthrough operations, that would
> need to be preserved using something we call "policy capabilities".
> The quick summary is that policy capabilities are a way for the
> SELinux policy to signal to the kernel that it is aware of a breaking
> change and the policy is written to take this change into account;
> when the kernel loads this newly capable policy it sets a flag which
> triggers a different behavior in the kernel.  A simple example can be
> found in selinux_file_ioctl(FIONCLEX)/selinux_policycap_ioctl_skip_cloexe=
c(),
> but we can talk more about this later if/when we resolve the other
> issue.
Guess we can tackle this after we see how we can get the necessary
context.

>=20
> * As we discussed previously, the real problem is the fact that we are
> missing the necessary context in the LSM hook to separate the
> different types of command targets.  With traditional ioctls we can
> look at the ioctl number and determine both the type of
> device/subsystem/etc. as well as the operation being requested; there
> is no such information available with the io_uring command
> passthrough.  In this sense, the io_uring command passthrough is
> actually worse than traditional ioctls from an access control
> perspective.  Until we have an easy(ish)[1] way to determine the
> io_uring command target type, changes like the one suggested here are
> going to be doomed as each target type is free to define their own
> io_uring commands.
The only thing that comes immediately to mind is that we can have
io_uring users define a function that is then passed to the LSM
infrastructure. This function will have all the logic to give relative
context to LSM. It would be general enough to fit all the possible commands
and the logic would be implemented in the "drivers" side so there is no
need for LSM folks to know all io_uring users.

>=20
> [1] Yes, one could theoretically make some determination of the target
> type by inspecting io_uring_cmd::file::f_op (or similar), but checking
> file_operations' function pointers is both a pretty awful layering
> violation and downright ugly; I don't want to have to maintain that
> long-term in a LSM.
>=20
> --
> paul-moore.com

--nklquilnr5juu4kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmN2AXEACgkQupfNUreW
QU986gv/RfS2lnqWvu/7X5AMEGBFITWJJYm+j0bIuQU1fBy3xRA+IsAtcbjMbAZU
DLHTB0leOtMD/9wZ4i2yb5Ft8jL1VJJLIJ7zbbWid5g/yDdQVwHyvVb4DiwQjDRM
PR4+6V1KgXNqw6YFyYiiGVpyfNi3ecCFg9MGKLZlUtNNV3CeOlmVQ+d4irmVWEMY
Mbmo/dWBHcw6MqS4/IAFqDiXwd39T5umgWTzp6//7t2tk9z+WKS8Renre7uO9NIj
xx518sc0ssnbDf2/ej5e964s2lnEFyZIQYjtu3yGQJO4UL6TwDLJXbFtu3HSk+IU
0ZaRfWK9K2+2scffg1VIuuqmTr9P9erGeTT68RRxitYas77l6Zf7WJnysmUbb71G
OFqP2zIppRF9AwbDEEs/Ew05LQmildncsKD4gHDLyFAb19pMTbgKC0BC1+IbOkmf
PWCBX5na2uISPO8Qr2phxTfNPljwigIDEnleio5D6x4spiQfSBxm7+a9HMH47tnj
X+pIxXpV
=BFzw
-----END PGP SIGNATURE-----

--nklquilnr5juu4kb--
