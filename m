Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFE063A42A
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 10:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiK1JGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 04:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiK1JGh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 04:06:37 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E4B18390;
        Mon, 28 Nov 2022 01:06:31 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221128090630euoutp02b644d13ce1812976694a731449532e1e~rtFsPp7fB0660106601euoutp02D;
        Mon, 28 Nov 2022 09:06:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221128090630euoutp02b644d13ce1812976694a731449532e1e~rtFsPp7fB0660106601euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669626390;
        bh=ZNy3kAe4Q17+pUeP8YukyCXn4MUBva4golMXWy8TOCU=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Bz2Ce52WsUr6+wNQnGTixMLFpmPiAnBGa/iY6C23dTaP248F5R8A+UkmwGlYVp0sQ
         WhmGUuxDsbrPty4Q+O6a3exjiQKBBmtFgdZAssyMvHw3dLGd28zKtS5KDHkuUkZamg
         MLKbLZTL8+uU0KfQpH8PA2MmJ626XxeXTGTEpsOE=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221128090629eucas1p1bf5471e408fd6f774efec329ff0d338e~rtFr_JGXC2755127551eucas1p1W;
        Mon, 28 Nov 2022 09:06:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A9.26.10112.51A74836; Mon, 28
        Nov 2022 09:06:29 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221128090629eucas1p1998b363b015c1bd16ab46cfcb442e1d7~rtFrkHYPQ1275712757eucas1p1Z;
        Mon, 28 Nov 2022 09:06:29 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221128090629eusmtrp25fd93571871c374724a70730f98ff1e8~rtFri1k8I0851908519eusmtrp22;
        Mon, 28 Nov 2022 09:06:29 +0000 (GMT)
X-AuditID: cbfec7f4-d09ff70000002780-87-63847a157a29
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CA.E2.09026.51A74836; Mon, 28
        Nov 2022 09:06:29 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221128090629eusmtip1ad6d0a371560c81bf342e36026df580e~rtFrWBUOZ2074720747eusmtip1X;
        Mon, 28 Nov 2022 09:06:29 +0000 (GMT)
Received: from localhost (106.210.248.49) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Mon, 28 Nov 2022 09:06:28 +0000
Date:   Mon, 28 Nov 2022 10:06:26 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
CC:     <mcgrof@kernel.org>, <ddiss@suse.de>, <joshi.k@samsung.com>,
        <paul@paul-moore.com>, <ming.lei@redhat.com>,
        <linux-security-module@vger.kernel.org>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
Subject: Re: [RFC v2 1/1] Use a fs callback to set security specific data
Message-ID: <20221128090626.we5yvzmtojkezks5@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="7sj7jmcm4hgnm6hp"
Content-Disposition: inline
In-Reply-To: <20221128081946.5w7cptx55wmdwamw@localhost>
X-Originating-IP: [106.210.248.49]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djP87qiVS3JBh87tC1W3+1ns7i37Reb
        xdf/01ks3rWeY7H40POIzeLGhKeMFocmNzNZ3J40ncWBw+Py2VKPTas62TzW7n3B6PF+31U2
        j6P7F7F5bD5d7fF5k1wAexSXTUpqTmZZapG+XQJXxq9dH9kKJgZXbNm6lKWB8adTFyMnh4SA
        icTDHduZuxi5OIQEVjBKHL60mB0kISTwhVFi5QcdiMRnRomeT99YYDoO/ZvEBJFYzijR/PQW
        G1xV07+XUO1bGCU2bskCsVkEVCVO3pwH1s0moCNx/s0dZhBbBMjet+c5O0gzs8BpRokNL5+C
        JYQFPCUetMwCauDg4BUwl1jygw8kzCsgKHFy5hOwOcwCFRKTDj5kBSlhFpCWWP6PAyTMKWAh
        cbDpJiPEoUoSa27sY4OwayVObbkFdrSEwHJOiUXftjGC9EoIuEg07/eDqBGWeHV8CzuELSPx
        f+d8Jgg7W2LnlF3MEHaBxKyTU9kgWq0l+s7kQIQdJe7uPMAEEeaTuPFWEOJIPolJ26YzQ4R5
        JTrahCCq1SR2NG1lnMCoPAvJW7OQvDUL4S2IsI7Egt2f2DCEtSWWLXzNDGHbSqxb955lASP7
        Kkbx1NLi3PTUYqO81HK94sTc4tK8dL3k/NxNjMDkdvrf8S87GJe/+qh3iJGJg/EQowpQ86MN
        qy8wSrHk5eelKonwajI2JwvxpiRWVqUW5ccXleakFh9ilOZgURLnZZuhlSwkkJ5YkpqdmlqQ
        WgSTZeLglGpg4jnpxcX8/d3OE+YTWFhrGT88MDMQkzDg2jJXcbp6pWpO/N2t18JenmpW2eGY
        uJd97sPo+O/v/kkd/ukbUHbwY+RZf+WA4vYZTboh7a4GO4W/LV286FT4bJWN57vWFkjIvzfx
        +TNj3xPjnyaJbdGB3lU6op1f5x12m39tws+JaR4iGSGHnt28ptynVbYwWDppAtNH+88BBdcs
        ju9gCk492lZqm79v4dYqj8Z/Kx5xK02aolC1pHH3kUMTRKaFubn6ZIgW5TZ/Lg/ZtljC5s3T
        H2qfrB/M3ur1fXf67WbxEhOF9aIby3uFNscelc6cHOp8vrH5M2fW830bojNU53SJm6YsCDxo
        OIdhb26jv6GMEktxRqKhFnNRcSIAIOUbD+kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t/xu7qiVS3JBguf8FisvtvPZnFv2y82
        i6//p7NYvGs9x2LxoecRm8WNCU8ZLQ5NbmayuD1pOosDh8fls6Uem1Z1snms3fuC0eP9vqts
        Hkf3L2Lz2Hy62uPzJrkA9ig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jINHe9kK+oMrVk6samD87tTFyMkhIWAicejfJKYuRi4OIYGljBJ7D31h
        hkjISHy68pEdwhaW+HOtiw2i6COjROvKpewQzhZGif0nV7OAVLEIqEqcvDkPzGYT0JE4/+YO
        2CQRIHvfnudgDcwCpxklNrx8CpYQFvCUeNAyC6iBg4NXwFxiyQ8+iKGrmSSe71kEtppXQFDi
        5MwnYEOZBcok+hdeYgWpZxaQllj+jwMkzClgIXGw6SYjxKVKEmtu7GODsGslPv99xjiBUXgW
        kkmzkEyahTAJIqwlcePfSyYMYW2JZQtfM0PYthLr1r1nWcDIvopRJLW0ODc9t9hIrzgxt7g0
        L10vOT93EyMw1rcd+7llB+PKVx/1DjEycTAeYlQB6ny0YfUFRimWvPy8VCURXk3G5mQh3pTE
        yqrUovz4otKc1OJDjKbAUJzILCWanA9MQnkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp
        2ampBalFMH1MHJxSDUy+6qu5RWWEWVYpsIZMnls4favQpY/SzM4LP1WvsRZcLqp5zMWOgcdM
        9fye7SW6Jd1ls8sfSwWHvHX2vrIy/POL5L2npKeqRnw25CmY0WK+tueirkB0LtP2ujrvif81
        9k19lnHm+6UV0brbHk7Y/n5H2tV8rr3NpnmynIZ3lyoHurVkMAvdLfj+YifjkT+zl62piInR
        2Hzpkd3Tv36rcqYUbltXmyWa9CTwQJZd9uTKukBfzeLbRu67Swx/NFkX8kesucZsdzf8wNxX
        WT+VjsdzxH3d9IPZ4qW0SouNYje/rOlN12CJvJ2JrKxLnmdE5BuqFeX8awoNnvpA/M8vy6tt
        PzS4PYu/i51pv2F4UomlOCPRUIu5qDgRAPQ/CPqKAwAA
X-CMS-MailID: 20221128090629eucas1p1998b363b015c1bd16ab46cfcb442e1d7
X-Msg-Generator: CA
X-RootMTR: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
References: <20221122103144.960752-1-j.granados@samsung.com>
        <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
        <20221122103144.960752-2-j.granados@samsung.com>
        <1afc3928-710e-9b0f-5b0a-cf2cf8d79cb9@schaufler-ca.com>
        <20221128081946.5w7cptx55wmdwamw@localhost>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--7sj7jmcm4hgnm6hp
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28, 2022 at 09:19:46AM +0100, Joel Granados wrote:
> On Tue, Nov 22, 2022 at 07:18:24AM -0800, Casey Schaufler wrote:
> > On 11/22/2022 2:31 AM, Joel Granados wrote:
> > > Signed-off-by: Joel Granados <j.granados@samsung.com>
> > > ---
> > >  drivers/nvme/host/core.c      | 10 ++++++++++
> > >  include/linux/fs.h            |  2 ++
> > >  include/linux/lsm_hook_defs.h |  3 ++-
> > >  include/linux/security.h      | 16 ++++++++++++++--
> > >  io_uring/uring_cmd.c          |  3 ++-
> > >  security/security.c           |  5 +++--
> > >  security/selinux/hooks.c      | 16 +++++++++++++++-
> > >  7 files changed, 48 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > > index f94b05c585cb..275826fe3c9e 100644
> > > --- a/drivers/nvme/host/core.c
> > > +++ b/drivers/nvme/host/core.c
> > > @@ -4,6 +4,7 @@
> > >   * Copyright (c) 2011-2014, Intel Corporation.
> > >   */
> > > =20
> > > +#include "linux/security.h"
> > >  #include <linux/blkdev.h>
> > >  #include <linux/blk-mq.h>
> > >  #include <linux/blk-integrity.h>
> > > @@ -3308,6 +3309,13 @@ static int nvme_dev_release(struct inode *inod=
e, struct file *file)
> > >  	return 0;
> > >  }
> > > =20
> > > +int nvme_uring_cmd_sec(struct io_uring_cmd *ioucmd,  struct security=
_uring_cmd *sec)
> > > +{
> > > +	sec->flags =3D 0;
> > > +	sec->flags =3D SECURITY_URING_CMD_TYPE_IOCTL;
> > > +	return 0;
> > > +}
> > > +
> > >  static const struct file_operations nvme_dev_fops =3D {
> > >  	.owner		=3D THIS_MODULE,
> > >  	.open		=3D nvme_dev_open,
> > > @@ -3315,6 +3323,7 @@ static const struct file_operations nvme_dev_fo=
ps =3D {
> > >  	.unlocked_ioctl	=3D nvme_dev_ioctl,
> > >  	.compat_ioctl	=3D compat_ptr_ioctl,
> > >  	.uring_cmd	=3D nvme_dev_uring_cmd,
> > > +	.uring_cmd_sec	=3D nvme_uring_cmd_sec,
> > >  };
> > > =20
> > >  static ssize_t nvme_sysfs_reset(struct device *dev,
> > > @@ -3982,6 +3991,7 @@ static const struct file_operations nvme_ns_chr=
_fops =3D {
> > >  	.compat_ioctl	=3D compat_ptr_ioctl,
> > >  	.uring_cmd	=3D nvme_ns_chr_uring_cmd,
> > >  	.uring_cmd_iopoll =3D nvme_ns_chr_uring_cmd_iopoll,
> > > +	.uring_cmd_sec	=3D nvme_uring_cmd_sec,
> > >  };
> > > =20
> > >  static int nvme_add_ns_cdev(struct nvme_ns *ns)
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index e654435f1651..af743a2dd562 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2091,6 +2091,7 @@ struct dir_context {
> > > =20
> > >  struct iov_iter;
> > >  struct io_uring_cmd;
> > > +struct security_uring_cmd;
> > > =20
> > >  struct file_operations {
> > >  	struct module *owner;
> > > @@ -2136,6 +2137,7 @@ struct file_operations {
> > >  	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_fl=
ags);
> > >  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch=
 *,
> > >  				unsigned int poll_flags);
> > > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_u=
ring_cmd*);
> > >  } __randomize_layout;
> > > =20
> > >  struct inode_operations {
> > > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_d=
efs.h
> > > index ec119da1d89b..6cef29bce373 100644
> > > --- a/include/linux/lsm_hook_defs.h
> > > +++ b/include/linux/lsm_hook_defs.h
> > > @@ -408,5 +408,6 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_ev=
ent *event)
> > >  #ifdef CONFIG_IO_URING
> > >  LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
> > >  LSM_HOOK(int, 0, uring_sqpoll, void)
> > > -LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
> > > +LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd,
> > > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_u=
ring_cmd*))
> >=20
> > I'm slow, and I'm sure the question has been covered elsewhere,
> > but I have real trouble understanding why you're sending a function
> > to fetch the security data rather than the data itself. Callbacks
> > are not usual for LSM interfaces. If multiple security modules have
> > uring_cmd hooks (e.g. SELinux and landlock) the callback has to be
> > called multiple times.
>=20
> No particular reason to have a callback, its just how it came out
> initially. I think changing this to a LSM struct is not a deal breaker
> for me. Especially if the callback might be called several times
> unnecessarily.
> TBH, I was expecting more pushback from including it in the file
> opeartions struct directly. Do you see any issue with including LSM
> specific pointers in the file opeartions?

TBH, if we see that a callback is the way to go we can always have a
callback execute it in uring_cmd.c and pass a struct to the LSM infra.
This will avoid the double call the you are referring to.

One advantage of having a callback is that changes withing the uring
user/driver (like a access list changing the way the driver behaves with
certain users) can be updated on every call to uring_cmd_sec. The uring
user/driver can also decide to just return the same struct always.

> >=20
> > >  #endif /* CONFIG_IO_URING */
> > > diff --git a/include/linux/security.h b/include/linux/security.h
> > > index ca1b7109c0db..146b1bbdc2e0 100644
> > > --- a/include/linux/security.h
> > > +++ b/include/linux/security.h
> > > @@ -2065,10 +2065,20 @@ static inline int security_perf_event_write(s=
truct perf_event *event)
> > >  #endif /* CONFIG_PERF_EVENTS */
> > > =20
> > >  #ifdef CONFIG_IO_URING
> > > +enum security_uring_cmd_type
> > > +{
> > > +	SECURITY_URING_CMD_TYPE_IOCTL,
> > > +};
> > > +
> > > +struct security_uring_cmd {
> > > +	u64 flags;
> > > +};
> > >  #ifdef CONFIG_SECURITY
> > >  extern int security_uring_override_creds(const struct cred *new);
> > >  extern int security_uring_sqpoll(void);
> > > -extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
> > > +extern int security_uring_cmd(struct io_uring_cmd *ioucmd,
> > > +		int (*uring_cmd_sec)(struct io_uring_cmd *,
> > > +			struct security_uring_cmd*));
> > >  #else
> > >  static inline int security_uring_override_creds(const struct cred *n=
ew)
> > >  {
> > > @@ -2078,7 +2088,9 @@ static inline int security_uring_sqpoll(void)
> > >  {
> > >  	return 0;
> > >  }
> > > -static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
> > > +static inline int security_uring_cmd(struct io_uring_cmd *ioucmd,
> > > +		int (*uring_cmd_sec)(struct io_uring_cmd *,
> > > +			struct security_uring_cmd*))
> > >  {
> > >  	return 0;
> > >  }
> > > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > > index e50de0b6b9f8..2f650b346756 100644
> > > --- a/io_uring/uring_cmd.c
> > > +++ b/io_uring/uring_cmd.c
> > > @@ -108,10 +108,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned=
 int issue_flags)
> > >  	struct file *file =3D req->file;
> > >  	int ret;
> > > =20
> > > +	//req->file->f_op->owner->ei_funcs
> > >  	if (!req->file->f_op->uring_cmd)
> > >  		return -EOPNOTSUPP;
> > > =20
> > > -	ret =3D security_uring_cmd(ioucmd);
> > > +	ret =3D security_uring_cmd(ioucmd, req->file->f_op->uring_cmd_sec);
> > >  	if (ret)
> > >  		return ret;
> > > =20
> > > diff --git a/security/security.c b/security/security.c
> > > index 79d82cb6e469..d3360a32f971 100644
> > > --- a/security/security.c
> > > +++ b/security/security.c
> > > @@ -2667,8 +2667,9 @@ int security_uring_sqpoll(void)
> > >  {
> > >  	return call_int_hook(uring_sqpoll, 0);
> > >  }
> > > -int security_uring_cmd(struct io_uring_cmd *ioucmd)
> > > +int security_uring_cmd(struct io_uring_cmd *ioucmd,
> > > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_u=
ring_cmd*))
> > >  {
> > > -	return call_int_hook(uring_cmd, 0, ioucmd);
> > > +	return call_int_hook(uring_cmd, 0, ioucmd, uring_cmd_sec);
> > >  }
> > >  #endif /* CONFIG_IO_URING */
> > > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > > index f553c370397e..9fe3a230c671 100644
> > > --- a/security/selinux/hooks.c
> > > +++ b/security/selinux/hooks.c
> > > @@ -21,6 +21,8 @@
> > >   *  Copyright (C) 2016 Mellanox Technologies
> > >   */
> > > =20
> > > +#include "linux/nvme_ioctl.h"
> > > +#include "linux/security.h"
> > >  #include <linux/init.h>
> > >  #include <linux/kd.h>
> > >  #include <linux/kernel.h>
> > > @@ -6999,18 +7001,30 @@ static int selinux_uring_sqpoll(void)
> > >   * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
> > >   *
> > >   */
> > > -static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
> > > +static int selinux_uring_cmd(struct io_uring_cmd *ioucmd,
> > > +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_u=
ring_cmd*))
> > >  {
> > >  	struct file *file =3D ioucmd->file;
> > >  	struct inode *inode =3D file_inode(file);
> > >  	struct inode_security_struct *isec =3D selinux_inode(inode);
> > >  	struct common_audit_data ad;
> > > +	const struct cred *cred =3D current_cred();
> > > +	struct security_uring_cmd sec_uring =3D {0};
> > > +	int ret;
> > > =20
> > >  	ad.type =3D LSM_AUDIT_DATA_FILE;
> > >  	ad.u.file =3D file;
> > > =20
> > > +	ret =3D uring_cmd_sec(ioucmd, &sec_uring);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (sec_uring.flags & SECURITY_URING_CMD_TYPE_IOCTL)
> > > +		return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_o=
p);
> > > +
> > >  	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
> > >  			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
> > > +
> > >  }
> > >  #endif /* CONFIG_IO_URING */
> > > =20



--7sj7jmcm4hgnm6hp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmOEehAACgkQupfNUreW
QU++6wv6A0BL/mTBGKWTvdLzeDQ6pke7cI7wrG1kcqn8N/AfsYP6vUA8cdByiN7K
6HKdLU28FPSjQAjGDZ9aLLyHe3spOpTge1KwT4EjTzjsBRd9XtJYpL1cahY4qzk/
Bqk2APyIF0WrvsKQy7VLvkyIsDRLQ0mjzbzJX+dj8JHhNQCk90Mys+ubnhnfkuZr
7UW+u545qZ7eGK6vYWaiEXhqH+UANsrCUsG3B7M2HFgdavdwzQrNSHoIFL8Dnw2z
QrKI3ks9vrE+5rvZ/23pC1qUFk1qbZV427JUg3CQE0A6D/VVMSX3SPJxMhSPBkpB
/cFdN4GuoIqGWM/UQ9ZlLES9UlRyYsE0jVllK0SKmUV5Mt5/klw7FAYnaY0TKw4X
RvGDxxEtNmoGYKQ3nYh5bHgkliUWM7rGfL4zga+H7L/gnkgDqxq2QsAuHAzGI7mr
tNHDYb9AuIx2uS2c9hoP64LcBLIoOMAe1arNy7elxFjM9Pq2NCOfTM9lHK+Jwbnd
h6T+munz
=bPjh
-----END PGP SIGNATURE-----

--7sj7jmcm4hgnm6hp--
