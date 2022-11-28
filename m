Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1B463A2B2
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 09:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiK1IT7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 03:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiK1IT5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 03:19:57 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9E4C76A;
        Mon, 28 Nov 2022 00:19:53 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221128081949euoutp01eda2ce75c2fac738ece6b40be036c41b~rsc8UFvNI3229832298euoutp01u;
        Mon, 28 Nov 2022 08:19:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221128081949euoutp01eda2ce75c2fac738ece6b40be036c41b~rsc8UFvNI3229832298euoutp01u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669623589;
        bh=H4hnoLhzbIutl/2HmxhTcMDKtHdNbNrhiFuNjXEF+G0=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=LUB4pj0A1h+hwol+w84g4EuCiLZ7aDGoVyGdxT7iOR8nPVxwMMoi+GjicqMFTddBP
         uVbgUDLvQ5uG7nogL75Y9oUDEM2kV0ENe7jIS2epNFobkrSwazEXdmdiNP99EdAmKW
         llwkRw9KEM6iNpOkwor7k++AjVO3gN2XhEy89YZY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221128081949eucas1p10ce99a83e68f1b246cb735396e631a4a~rsc8Av5Qn0319803198eucas1p1R;
        Mon, 28 Nov 2022 08:19:49 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 70.4F.09549.52F64836; Mon, 28
        Nov 2022 08:19:49 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221128081948eucas1p2960a8541ffea61853fc054bf71b73b58~rsc7h4V_o0727907279eucas1p2R;
        Mon, 28 Nov 2022 08:19:48 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221128081948eusmtrp2b05b5e452de089bc6f534c6a3b0d6bfb~rsc7geTSE1292012920eusmtrp2G;
        Mon, 28 Nov 2022 08:19:48 +0000 (GMT)
X-AuditID: cbfec7f5-f5dff7000000254d-74-63846f257ab5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id D5.D9.09026.42F64836; Mon, 28
        Nov 2022 08:19:48 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221128081948eusmtip14a1cd205759e81d224e1bc8c9f5e02ff~rsc7TpGmc2319423194eusmtip1a;
        Mon, 28 Nov 2022 08:19:48 +0000 (GMT)
Received: from localhost (106.210.248.49) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Mon, 28 Nov 2022 08:19:48 +0000
Date:   Mon, 28 Nov 2022 09:19:46 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
CC:     <mcgrof@kernel.org>, <ddiss@suse.de>, <joshi.k@samsung.com>,
        <paul@paul-moore.com>, <ming.lei@redhat.com>,
        <linux-security-module@vger.kernel.org>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
Subject: Re: [RFC v2 1/1] Use a fs callback to set security specific data
Message-ID: <20221128081946.5w7cptx55wmdwamw@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="kpbi2wk3sryyqins"
Content-Disposition: inline
In-Reply-To: <1afc3928-710e-9b0f-5b0a-cf2cf8d79cb9@schaufler-ca.com>
X-Originating-IP: [106.210.248.49]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7djP87qq+S3JBu2TRC1W3+1ns7i37Reb
        xdf/01ks3rWeY7H40POIzeLGhKeMFocmNzNZ3J40ncWBw+Py2VKPTas62TzW7n3B6PF+31U2
        j6P7F7F5bD5d7fF5k1wAexSXTUpqTmZZapG+XQJXxqEJL5gKFnlXvJ67g7mB8Z5tFyMnh4SA
        icSjBaeYuhi5OIQEVjBK3Jx0mB0kISTwhVHi/B1BiMRnRonGh4tZuhg5wDpeTWGBiC9nlJjy
        5iY7XFHH5yOMEM4WRonbrd+ZQEaxCKhK/OhvZQWx2QR0JM6/ucMMYosA2fv2PAfrZhY4zSix
        4eVTsISwgKfEg5ZZLCA2r4C5RPvip+wQtqDEyZlPwOLMAhUS25Z0MIGcxCwgLbH8HwdImFPA
        RWL9lB2sEL8pSay5sY8Nwq6VOLXlFtifEgLrOSX+HbjLApFwkdg29TNUg7DEq+Nb2CFsGYn/
        O+czQdjZEjun7GKGsAskZp2cygYJCmuJvjM5EGFHibs7DzBBhPkkbrwVhLiST2LStunMEGFe
        iY42IYhqNYkdTVsZJzAqz0Ly1ywkf81C+AsirCOxYPcnNgxhbYllC18zQ9i2EuvWvWdZwMi+
        ilE8tbQ4Nz212DgvtVyvODG3uDQvXS85P3cTIzDBnf53/OsOxhWvPuodYmTiYDzEqALU/GjD
        6guMUix5+XmpSiK8mozNyUK8KYmVValF+fFFpTmpxYcYpTlYlMR52WZoJQsJpCeWpGanphak
        FsFkmTg4pRqYNtxltpm8ViNrZoFW64nmaBebhSf79kw3iK7TEK+boXV2o59J3uwrpRekNqhX
        +6x9veMEI/uEToFLRqv/H/tV2u1SrJWavX+7FdesFUape2XmKDlw+9Yd2v70X42l37OTuxZq
        Pb1nyrMgm0VULriwZy/Tuwn+eqdEDsgdPLniWKF0J7der/3HzKDqpOxu71dzF8iFb3LsOHsy
        //0cc7tHE0X1JeZqNGp4zVHV2zmbZ0K46tvkJ+qHGP6dXv/Sx8845pl1mf3zCctOXt6bsSYj
        hsOgb9n7a2celoVvXfA91Xq1yrzXF5i2xy/Um9WkUbr1pNRe18ZNl4qNQpiFnje9+rFKjbly
        fY7V/1otTbsTSizFGYmGWsxFxYkAjWXWnusDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t/xu7oq+S3JBnt7TCxW3+1ns7i37Reb
        xdf/01ks3rWeY7H40POIzeLGhKeMFocmNzNZ3J40ncWBw+Py2VKPTas62TzW7n3B6PF+31U2
        j6P7F7F5bD5d7fF5k1wAe5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexqEF89gLFnhX/Nv9iK2B8Y5tFyMHh4SAicSrKSxdjFwcQgJLGSX+/nsB
        5HACxWUkPl35yA5hC0v8udbFBmILCXxklFj5WR/C3sIoMac1FsRmEVCV+NHfygpiswnoSJx/
        c4cZxBYBsvftec4OsoBZ4DSjxIaXT8ESwgKeEg9aZoEt4xUwl2hf/JQd4oq/jBJrHjxhhEgI
        Spyc+QSsiFmgTGLFsuksIFczC0hLLP/HARLmFHCRWD9lByvEoUoSa27sY4OwayU+/33GOIFR
        eBaSSbOQTJqFMAkirCVx499LJgxhbYllC18zQ9i2EuvWvWdZwMi+ilEktbQ4Nz232EivODG3
        uDQvXS85P3cTIzDStx37uWUH48pXH/UOMTJxMB5iVAHqfLRh9QVGKZa8/LxUJRFeTcbmZCHe
        lMTKqtSi/Pii0pzU4kOMpsBgnMgsJZqcD0xBeSXxhmYGpoYmZpYGppZmxkrivJ4FHYlCAumJ
        JanZqakFqUUwfUwcnFINTDt6ZBtqH/FOkchQ4BA0mi1gku/+ev8Chsi5KzMmztNzutXZIWc1
        K+fb7jMPZ1Z9E1rvvbBt+imZzZuOWxyefiM7qipjYc6znw/e31vL8uUb+1MmLvFvLCXFByqc
        phRe6399zSB/6SZjmWir674C76Yvc8gW1XGpnx3078GEttBmPm+9C8IGP++83FIm0PGjwmnx
        hFO5D68Vfb+kpLCJs2L3qzqF8jmqC9OPH1mpNrGVpb5zxyc37+yVv+u4Zy8+N30555/l9bfy
        5+ude/+kcaX2oaJV9z9NYr4RLrNfZ6Nk3ry3+14+T/i49Vyo57y7U47f3H4svUY8O29L8+ZH
        S1r7wsWYhb/vy/6ZV/rHuHSDEktxRqKhFnNRcSIAjx393okDAAA=
X-CMS-MailID: 20221128081948eucas1p2960a8541ffea61853fc054bf71b73b58
X-Msg-Generator: CA
X-RootMTR: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
References: <20221122103144.960752-1-j.granados@samsung.com>
        <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
        <20221122103144.960752-2-j.granados@samsung.com>
        <1afc3928-710e-9b0f-5b0a-cf2cf8d79cb9@schaufler-ca.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--kpbi2wk3sryyqins
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2022 at 07:18:24AM -0800, Casey Schaufler wrote:
> On 11/22/2022 2:31 AM, Joel Granados wrote:
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
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index f94b05c585cb..275826fe3c9e 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -4,6 +4,7 @@
> >   * Copyright (c) 2011-2014, Intel Corporation.
> >   */
> > =20
> > +#include "linux/security.h"
> >  #include <linux/blkdev.h>
> >  #include <linux/blk-mq.h>
> >  #include <linux/blk-integrity.h>
> > @@ -3308,6 +3309,13 @@ static int nvme_dev_release(struct inode *inode,=
 struct file *file)
> >  	return 0;
> >  }
> > =20
> > +int nvme_uring_cmd_sec(struct io_uring_cmd *ioucmd,  struct security_u=
ring_cmd *sec)
> > +{
> > +	sec->flags =3D 0;
> > +	sec->flags =3D SECURITY_URING_CMD_TYPE_IOCTL;
> > +	return 0;
> > +}
> > +
> >  static const struct file_operations nvme_dev_fops =3D {
> >  	.owner		=3D THIS_MODULE,
> >  	.open		=3D nvme_dev_open,
> > @@ -3315,6 +3323,7 @@ static const struct file_operations nvme_dev_fops=
 =3D {
> >  	.unlocked_ioctl	=3D nvme_dev_ioctl,
> >  	.compat_ioctl	=3D compat_ptr_ioctl,
> >  	.uring_cmd	=3D nvme_dev_uring_cmd,
> > +	.uring_cmd_sec	=3D nvme_uring_cmd_sec,
> >  };
> > =20
> >  static ssize_t nvme_sysfs_reset(struct device *dev,
> > @@ -3982,6 +3991,7 @@ static const struct file_operations nvme_ns_chr_f=
ops =3D {
> >  	.compat_ioctl	=3D compat_ptr_ioctl,
> >  	.uring_cmd	=3D nvme_ns_chr_uring_cmd,
> >  	.uring_cmd_iopoll =3D nvme_ns_chr_uring_cmd_iopoll,
> > +	.uring_cmd_sec	=3D nvme_uring_cmd_sec,
> >  };
> > =20
> >  static int nvme_add_ns_cdev(struct nvme_ns *ns)
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index e654435f1651..af743a2dd562 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2091,6 +2091,7 @@ struct dir_context {
> > =20
> >  struct iov_iter;
> >  struct io_uring_cmd;
> > +struct security_uring_cmd;
> > =20
> >  struct file_operations {
> >  	struct module *owner;
> > @@ -2136,6 +2137,7 @@ struct file_operations {
> >  	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flag=
s);
> >  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
> >  				unsigned int poll_flags);
> > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uri=
ng_cmd*);
> >  } __randomize_layout;
> > =20
> >  struct inode_operations {
> > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_def=
s.h
> > index ec119da1d89b..6cef29bce373 100644
> > --- a/include/linux/lsm_hook_defs.h
> > +++ b/include/linux/lsm_hook_defs.h
> > @@ -408,5 +408,6 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_even=
t *event)
> >  #ifdef CONFIG_IO_URING
> >  LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
> >  LSM_HOOK(int, 0, uring_sqpoll, void)
> > -LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
> > +LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd,
> > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uri=
ng_cmd*))
>=20
> I'm slow, and I'm sure the question has been covered elsewhere,
> but I have real trouble understanding why you're sending a function
> to fetch the security data rather than the data itself. Callbacks
> are not usual for LSM interfaces. If multiple security modules have
> uring_cmd hooks (e.g. SELinux and landlock) the callback has to be
> called multiple times.

No particular reason to have a callback, its just how it came out
initially. I think changing this to a LSM struct is not a deal breaker
for me. Especially if the callback might be called several times
unnecessarily.
TBH, I was expecting more pushback from including it in the file
opeartions struct directly. Do you see any issue with including LSM
specific pointers in the file opeartions?
>=20
> >  #endif /* CONFIG_IO_URING */
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index ca1b7109c0db..146b1bbdc2e0 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -2065,10 +2065,20 @@ static inline int security_perf_event_write(str=
uct perf_event *event)
> >  #endif /* CONFIG_PERF_EVENTS */
> > =20
> >  #ifdef CONFIG_IO_URING
> > +enum security_uring_cmd_type
> > +{
> > +	SECURITY_URING_CMD_TYPE_IOCTL,
> > +};
> > +
> > +struct security_uring_cmd {
> > +	u64 flags;
> > +};
> >  #ifdef CONFIG_SECURITY
> >  extern int security_uring_override_creds(const struct cred *new);
> >  extern int security_uring_sqpoll(void);
> > -extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
> > +extern int security_uring_cmd(struct io_uring_cmd *ioucmd,
> > +		int (*uring_cmd_sec)(struct io_uring_cmd *,
> > +			struct security_uring_cmd*));
> >  #else
> >  static inline int security_uring_override_creds(const struct cred *new)
> >  {
> > @@ -2078,7 +2088,9 @@ static inline int security_uring_sqpoll(void)
> >  {
> >  	return 0;
> >  }
> > -static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
> > +static inline int security_uring_cmd(struct io_uring_cmd *ioucmd,
> > +		int (*uring_cmd_sec)(struct io_uring_cmd *,
> > +			struct security_uring_cmd*))
> >  {
> >  	return 0;
> >  }
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index e50de0b6b9f8..2f650b346756 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -108,10 +108,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned i=
nt issue_flags)
> >  	struct file *file =3D req->file;
> >  	int ret;
> > =20
> > +	//req->file->f_op->owner->ei_funcs
> >  	if (!req->file->f_op->uring_cmd)
> >  		return -EOPNOTSUPP;
> > =20
> > -	ret =3D security_uring_cmd(ioucmd);
> > +	ret =3D security_uring_cmd(ioucmd, req->file->f_op->uring_cmd_sec);
> >  	if (ret)
> >  		return ret;
> > =20
> > diff --git a/security/security.c b/security/security.c
> > index 79d82cb6e469..d3360a32f971 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -2667,8 +2667,9 @@ int security_uring_sqpoll(void)
> >  {
> >  	return call_int_hook(uring_sqpoll, 0);
> >  }
> > -int security_uring_cmd(struct io_uring_cmd *ioucmd)
> > +int security_uring_cmd(struct io_uring_cmd *ioucmd,
> > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uri=
ng_cmd*))
> >  {
> > -	return call_int_hook(uring_cmd, 0, ioucmd);
> > +	return call_int_hook(uring_cmd, 0, ioucmd, uring_cmd_sec);
> >  }
> >  #endif /* CONFIG_IO_URING */
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index f553c370397e..9fe3a230c671 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -21,6 +21,8 @@
> >   *  Copyright (C) 2016 Mellanox Technologies
> >   */
> > =20
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
> > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uri=
ng_cmd*))
> >  {
> >  	struct file *file =3D ioucmd->file;
> >  	struct inode *inode =3D file_inode(file);
> >  	struct inode_security_struct *isec =3D selinux_inode(inode);
> >  	struct common_audit_data ad;
> > +	const struct cred *cred =3D current_cred();
> > +	struct security_uring_cmd sec_uring =3D {0};
> > +	int ret;
> > =20
> >  	ad.type =3D LSM_AUDIT_DATA_FILE;
> >  	ad.u.file =3D file;
> > =20
> > +	ret =3D uring_cmd_sec(ioucmd, &sec_uring);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (sec_uring.flags & SECURITY_URING_CMD_TYPE_IOCTL)
> > +		return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_op);
> > +
> >  	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> >  			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
> > +
> >  }
> >  #endif /* CONFIG_IO_URING */
> > =20

--kpbi2wk3sryyqins
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmOEbx8ACgkQupfNUreW
QU8F0Av/WHTSVjsHs4kCg5Fu33O9hm2r3ahZZp4UOUt+sbtZ5QXqQvBqlzUl4dpX
m7vYQZIyfTSZZu6J9syfYEEYsnTo/Ol/BxqLkV3+dKKNE7JoE+FUgG2FSC9kDiXG
tjynDAb0QbBRhkOla5uYQgqdUaIR7+1rlLXLlvEHFRwbYWmuIkYGCuKLd6SIYIZ9
X3N343v4TnaUhtrh0LKqK1qv2Cuc1+lTahVpDPedt70TEuzUvtyz2KO7PXOqxddM
+CKJXSTEAXT0zjZz471VQhVWo24h3dbDsFjuKmOaeK176QKdrRILGJPg0DrfCC2u
lPVbV9r1n3Z829W7g0sZSJXhsxER8XFU8yygpD4r/QkqPnCEBPnGwY+JLUS7ZYAO
J8sf/vi1JWhPKZiangT32hi84ZUiVTftKuuRLYj/tT4bp/FV09w8wfwLllT9TNpy
vtoUQcifVCifiNTUxhje01xlJ/V3K0WfWq6WQxE0LWhRKWyNSe5ZdE6Bi0SZj9Oo
JKdboHsp
=9f6+
-----END PGP SIGNATURE-----

--kpbi2wk3sryyqins--
