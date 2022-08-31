Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45F25A775F
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 09:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiHaHTS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 03:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiHaHSS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 03:18:18 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5135A3EE
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 00:15:13 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220831071507euoutp011c4ebba89b8a8d89f22d407a562c19e3~QXKCb_7-Z1329313293euoutp01h;
        Wed, 31 Aug 2022 07:15:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220831071507euoutp011c4ebba89b8a8d89f22d407a562c19e3~QXKCb_7-Z1329313293euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661930107;
        bh=Wt/AfTFDT/nrSGD2h0VW26yOnXgfGWduk2OTxD2kJnM=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=T1hGgj21r9dE1x6gsgJLOR1bclbWgx9DCMOSCZdmOsnvn4qn1gm7WRSwpCDr/Y8UI
         +uouDAlGLX1a2+l5yCxGMfS2AtjjifZoZ252fSK/Hwb+3FcFRHlB7WuB81kjGTUcso
         esrd/7kxiMDhp/e9iNMi9BnLloGTVtwrHGVnAJ10=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220831071507eucas1p227e189440963a1eebf9240ef12ffa439~QXKCKP8MK0491004910eucas1p28;
        Wed, 31 Aug 2022 07:15:07 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 83.B1.07817.A7A0F036; Wed, 31
        Aug 2022 08:15:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220831071506eucas1p1403c65170cb6d5e407483155facc3ea6~QXKByG2Wl2105221052eucas1p1S;
        Wed, 31 Aug 2022 07:15:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220831071506eusmtrp203d5102be3f95f8bf46d17ae479679e8~QXKBxXMc10191701917eusmtrp26;
        Wed, 31 Aug 2022 07:15:06 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-fe-630f0a7a033d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 02.33.07473.A7A0F036; Wed, 31
        Aug 2022 08:15:06 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220831071506eusmtip2ba203ef6e52139a0f3cc764a6c42938c~QXKBiBej72296322963eusmtip2y;
        Wed, 31 Aug 2022 07:15:06 +0000 (GMT)
Received: from localhost (106.210.248.185) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 31 Aug 2022 08:15:02 +0100
Date:   Wed, 31 Aug 2022 09:15:01 +0200
From:   Joel Granados <j.granados@samsung.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        <io-uring@vger.kernel.org>
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Message-ID: <20220831071501.xdj7njudv5ovrl64@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="me2obmlf4xujkq6e"
Content-Disposition: inline
In-Reply-To: <41e3fa1e-647a-8f47-9c2b-046209b07a50@schaufler-ca.com>
X-Originating-IP: [106.210.248.185]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djP87pVXPzJBg+3WVusvtvPZnFv2y82
        i3et51gsbk+azuLA4nH5bKnH2r0vGD2O7l/E5vF5k1wASxSXTUpqTmZZapG+XQJXRt/9+oK/
        XhV3ly9jbWD8bdvFyMkhIWAi8fLcbyYQW0hgBaPEl20qXYxcQPYXRomfMzYwQjifGSUe/TzE
        BtPxaMFVFojEckaJ0z/b2eGqnj05zAwxayujRPtWoB0cHCwCqhJn7ymAhNkEdCTOv7kDViIC
        ZO/b8xysl1lgHaPE9eM72UESwgKOEtt+XQSzeQXMJXY83MsMYQtKnJz5hAXEZhaokJj8/y0L
        yHxmAWmJ5f84QMKcAi4SL/c3MEEcqixxu2M9M4RdK7H22BmwXRICXzgktl+9CvWNi8TEeQ9Y
        IGxhiVfHt7BD2DIS/3fOhxqULbFzyi6oQQUSs05OZQPZKyFgLdF3Jgci7Cix6tMhdogwn8SN
        t4IQV/JJTNo2nRkizCvR0SYEUa0msaNpK+MERuVZSP6aheSvWQh/QYT1JG5MncKGIawtsWzh
        a2YI21Zi3br3LAsY2VcxiqeWFuempxYb5aWW6xUn5haX5qXrJefnbmIEJqbT/45/2cG4/NVH
        vUOMTByMhxhVgJofbVh9gVGKJS8/L1VJhPf7OZ5kId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzJ
        mRsShQTSE0tSs1NTC1KLYLJMHJxSDUzZf9uuPg6WWTxX7dj9gl+7D2Sx1Tf+5FsSUtEXGuMe
        tIHBIC54XbPIRkalTJWQP/GL7jR+WzPRIKBMcE6l7j6pJX92JizwiXVoqbU9FhH5ea7kub1R
        homXs5Kfzth6qvPSkr8KuycKRZj/c1JNrH366oLij3PLlVIXtMamno5in92R3GmkO1nR6i3T
        pJBzJyr/GSnmFNrPVLKZNGuK/q2W6piHW94slvbJEevsZmY5uWCm6eSriiqeUidNj6/8//1E
        jMqPo0JZ707M0CsQu3iNTZqvJ6vxneebZLPtS3aqbZWuS+zf+j/kZqnJ5HSlNV+tq0VtdPZv
        F40SvTK78r/S1gB9Vc5Tmh9qcp//Z1FiKc5INNRiLipOBACBbn5IxwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xe7pVXPzJBg/PKlisvtvPZnFv2y82
        i3et51gsbk+azuLA4nH5bKnH2r0vGD2O7l/E5vF5k1wAS5SeTVF+aUmqQkZ+cYmtUrShhZGe
        oaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexsztwgW/vSrebPnG1sD407aLkZNDQsBE
        4tGCqyxdjFwcQgJLGSX+z9zBBJGQkfh05SM7hC0s8edaFxtE0UdGiWX7vjNDOFsZJd63TQVq
        5+BgEVCVOHtPAaSBTUBH4vybO8wgtgiQvW/Pc3aQemaBdYwS14/vBJsqLOAose3XRTCbV8Bc
        YsfDvVBDj7BI9N+7xAyREJQ4OfMJC4jNLFAmsXhlMxPIMmYBaYnl/zhAwpwCLhIv9zdAXa0s
        cbtjPTOEXSvx6v5uxgmMwrOQTJqFZNIshEkQYR2JnVvvsGEIa0ssW/iaGcK2lVi37j3LAkb2
        VYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIFxuu3Yz807GOe9+qh3iJGJg/EQowpQ56MNqy8w
        SrHk5eelKonwfj/HkyzEm5JYWZValB9fVJqTWnyI0RQYihOZpUST84EJJK8k3tDMwNTQxMzS
        wNTSzFhJnNezoCNRSCA9sSQ1OzW1ILUIpo+Jg1OqgUn80b3/eYs4Wv476XHnmvOtmrFKaUfs
        nbbNcd8PV01szM2uXTG59tZPz72iS199/+je653CW6V9XvKxlmnf5113+b/aKVxRvyvxtyFn
        Uv3ZhXYeS6OOHMw5aOujfWvWizQ+ju0R7Lrukk7Mu9ecvWtnbFEjttvEbmF4zK74/ZPEzXTW
        T5+kGRlUyLAt8V2bW4aimk4v/6YnYb9n3LC77Lw0+NmUEN/NKtN5e54sYdZe+NXlX7bX9ulc
        18LU3ZafmvAwW6ZAeq1yZlCVgf2dghL3U/klbXlH3d+cVHgm1WLxc63NVUU3rrx7fIw6Pnfe
        nLDevDo9X/GY8jn26yc3OHzmuPMjv/aE8eNvMgxrOpRYijMSDbWYi4oTAdYVbehoAwAA
X-CMS-MailID: 20220831071506eucas1p1403c65170cb6d5e407483155facc3ea6
X-Msg-Generator: CA
X-RootMTR: 20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
        <20220719135234.14039-1-ankit.kumar@samsung.com>
        <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
        <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
        <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
        <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
        <20220827155954.GA11498@test-zns>
        <a6cb7a3b-8393-c8f3-60f6-00ae08dab23a@schaufler-ca.com>
        <20220830130843.mp5j2e5psrg6js56@localhost>
        <41e3fa1e-647a-8f47-9c2b-046209b07a50@schaufler-ca.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--me2obmlf4xujkq6e
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2022 at 07:16:55AM -0700, Casey Schaufler wrote:
> On 8/30/2022 6:08 AM, Joel Granados wrote:
> > Hey Casey
> >
> > I have tested this patch and I see the smack_uring_cmd prevents access
> > to file when smack labels are different. They way I got there was a bit
> > convoluted and I'll describe it here so ppl can judge how valid the test
> > is.
> >
> > Tested-by: Joel Granados <j.granados@samsung.com>
>=20
> Thank you.
np

>=20
> >
> > I started by reproducing what Kanchan had done by changing the smack
> > label from "_" to "Snap". Then I ran the io_uring passthrough test
> > included in liburing with an unprivileged user and saw that the
> > smack_uring_cmd function was NOT executed because smack prevented an op=
en on
> > the device file ("/dev/ng0n1" on my box).
> >
> > So here I got a bit sneaky and changed the label after the open to the
> > device was done. This is how I did it:
> > 1. In the io_uring_passthrough.c tests I stopped execution after the
> >    device was open and before the actual IO.
> > 2. While on hold I changed the label of the device from "_" to "Snap".
> >    At this point the device had a "Snap" label and the executable had a
> >    "_" label.
> > 3. Previous to execution I had placed a printk inside the
> >    smack_uring_cmd function. And I also made sure to printk whenever
> >    security_uring_command returned because of a security violation.
> > 4. I continued execution and saw that both smack_uiring_cmd and
> >    io_uring_cmd returned error. Which is what I expected.
> >
> > I'm still a bit unsure of my setup so if anyone has comments or a way to
> > make it better, I would really appreciate feedback.
>=20
> This is a perfectly rational approach to the test. Another approach
> would be to add a Smack access rule:
>=20
> 	echo "_ Snap r" > /sys/fs/smackfs/load2
>=20
> and label the device before the test begins. Step 2 changes from labeling
> the device to removing the access rule:
>=20
> 	echo "_ Snap -" > /sys/fs/smackfs/load2
>=20
> and you will get the same result. I wouldn't change your test, but I
> would probably add another that does it using the rule change.

Followed your proposal and I could see that it went passed the "file
open: permission denied" error. However it did not execute
smack_uring_cmd as smack prevented execution of an ioctl call [1]. This
is probably because the test that I'm using from liburing does a lot of
things to set things up besides just opening the device.
I tried several strings on /sys/fs/smackfs/load2 but had no
luck at actually arriving to the smack_uring_cmd function.

Here is what I tried:
1. echo "_ Snap r-x---" > /sys/fs/smackfs/load2
   which prevented access but not in smack_uring_cmd

2. echo "_ Snap -wx---" > /sys/fs/smackfs/load2
   This of course prevented me from opening the /dev/ng0n1

3. echo "_ Snap rw----" > /sys/fs/smackfs/load2
   This went through the smack_uring_cmd and allowed the interaction.

[1] : Here is the traceback of where smack prevents execution of the
      ioctl call:

#0  smk_tskacc (tsp=3D0xffff888107a27300, obj_known=3D0xffff888105dda540, m=
ode=3Dmode@entry=3D2, a=3Da@entry=3D0xffffc90000c3be80)
    at ../security/smack/smack_access.c:258
#1  0xffffffff8143fbb0 in smk_curacc (obj_known=3D<optimized out>, mode=3Dm=
ode@entry=3D2, a=3Da@entry=3D0xffffc90000c3be80) at ../security/smack/smack=
_access.c:278
#2  0xffffffff8143b4e4 in smack_file_ioctl (file=3D<optimized out>, cmd=3D3=
225964097, arg=3D<optimized out>) at ../security/smack/smack_lsm.c:1539
#3  0xffffffff81411c3f in security_file_ioctl (file=3Dfile@entry=3D0xffff88=
81038c8b00, cmd=3Dcmd@entry=3D3225964097, arg=3Darg@entry=3D140728408424048)
    at ../security/security.c:1552
#4  0xffffffff8126ca3e in __do_sys_ioctl (arg=3D140728408424048, cmd=3D3225=
964097, fd=3D3) at ../fs/ioctl.c:864
#5  __se_sys_ioctl (arg=3D140728408424048, cmd=3D3225964097, fd=3D3) at ../=
fs/ioctl.c:856
#6  __x64_sys_ioctl (regs=3D<optimized out>) at ../fs/ioctl.c:856
#7  0xffffffff81da0978 in do_syscall_x64 (nr=3D<optimized out>, regs=3D0xff=
ffc90000c3bf58) at ../arch/x86/entry/common.c:50
#8  do_syscall_64 (regs=3D0xffffc90000c3bf58, nr=3D<optimized out>) at ../a=
rch/x86/entry/common.c:80
#9  0xffffffff81e0009b in entry_SYSCALL_64 () at ../arch/x86/entry/entry_64=
=2ES:120
#10 0x00007f9c22ae9000 in ?? ()
#11 0x0000000000000000 in ?? ()


>=20
> > Best
> >
> > Joel
> >
> > On Mon, Aug 29, 2022 at 09:20:09AM -0700, Casey Schaufler wrote:
> >> On 8/27/2022 8:59 AM, Kanchan Joshi wrote:
> >>> On Tue, Aug 23, 2022 at 04:46:18PM -0700, Casey Schaufler wrote:
> >>>> Limit io_uring "cmd" options to files for which the caller has
> >>>> Smack read access. There may be cases where the cmd option may
> >>>> be closer to a write access than a read, but there is no way
> >>>> to make that determination.
> >>>>
> >>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >>>> --=20
> >>>> security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
> >>>> 1 file changed, 32 insertions(+)
> >>>>
> >>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> >>>> index 001831458fa2..bffccdc494cb 100644
> >>>> --- a/security/smack/smack_lsm.c
> >>>> +++ b/security/smack/smack_lsm.c
> >>>> @@ -42,6 +42,7 @@
> >>>> #include <linux/fs_context.h>
> >>>> #include <linux/fs_parser.h>
> >>>> #include <linux/watch_queue.h>
> >>>> +#include <linux/io_uring.h>
> >>>> #include "smack.h"
> >>>>
> >>>> #define TRANS_TRUE=A0=A0=A0 "TRUE"
> >>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
> >>>> =A0=A0=A0=A0return -EPERM;
> >>>> }
> >>>>
> >>>> +/**
> >>>> + * smack_uring_cmd - check on file operations for io_uring
> >>>> + * @ioucmd: the command in question
> >>>> + *
> >>>> + * Make a best guess about whether a io_uring "command" should
> >>>> + * be allowed. Use the same logic used for determining if the
> >>>> + * file could be opened for read in the absence of better criteria.
> >>>> + */
> >>>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> >>>> +{
> >>>> +=A0=A0=A0 struct file *file =3D ioucmd->file;
> >>>> +=A0=A0=A0 struct smk_audit_info ad;
> >>>> +=A0=A0=A0 struct task_smack *tsp;
> >>>> +=A0=A0=A0 struct inode *inode;
> >>>> +=A0=A0=A0 int rc;
> >>>> +
> >>>> +=A0=A0=A0 if (!file)
> >>>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >>>> +
> >>>> +=A0=A0=A0 tsp =3D smack_cred(file->f_cred);
> >>>> +=A0=A0=A0 inode =3D file_inode(file);
> >>>> +
> >>>> +=A0=A0=A0 smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
> >>>> +=A0=A0=A0 smk_ad_setfield_u_fs_path(&ad, file->f_path);
> >>>> +=A0=A0=A0 rc =3D smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad=
);
> >>>> +=A0=A0=A0 rc =3D smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
> >>>> +
> >>>> +=A0=A0=A0 return rc;
> >>>> +}
> >>>> +
> >>>> #endif /* CONFIG_IO_URING */
> >>>>
> >>>> struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init =3D {
> >>>> @@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[]
> >>>> __lsm_ro_after_init =3D {
> >>>> #ifdef CONFIG_IO_URING
> >>>> =A0=A0=A0=A0LSM_HOOK_INIT(uring_override_creds, smack_uring_override=
_creds),
> >>>> =A0=A0=A0=A0LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
> >>>> +=A0=A0=A0 LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
> >>>> #endif
> >>> Tried this on nvme device (/dev/ng0n1).
> >>> Took a while to come out of noob setup-related issues but I see that
> >>> smack is listed (in /sys/kernel/security/lsm), smackfs is present, and
> >>> the hook (smack_uring_cmd) gets triggered fine on doing I/O on
> >>> /dev/ng0n1.
> >>>
> >>> I/O goes fine, which seems aligned with the label on /dev/ng0n1 (which
> >>> is set to floor).
> >>>
> >>> $ chsmack -L /dev/ng0n1
> >>> /dev/ng0n1 access=3D"_"
> >> Setting the Smack on the object that the cmd operates on to
> >> something other than "_" would be the correct test. If that
> >> is /dev/ng0n1 you could use
> >>
> >> 	# chsmack -a Snap /dev/ng0n1
> >>
> >> The unprivileged user won't be able to read /dev/ng0n1 so you
> >> won't get as far as testing the cmd interface. I don't know
> >> io_uring and nvme well enough to know what other objects may
> >> be involved. Noob here, too.
> >>
> >>> I ran fio (/usr/bin/fio), which also has the same label.
> >>> Hope you expect the same outcome.
> >>>
> >>> Do you run something else to see that things are fine e.g. for
> >>> /dev/null, which also has the same label "_".
> >>> If yes, I can try the same on nvme side.
> >>>

--me2obmlf4xujkq6e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmMPCmgACgkQupfNUreW
QU/IHgwAkA5DFjt5dzDquOw503N8Mu/bequmFQp7y2fjkLGM+OW/M1NrSXgBfFVZ
jrbn3im8trT2mN1IQFf7aY2gUPDBS63cja8WEdxxvBE7WqmoCDXLtDfHZbeYFdNq
3yHM65NNO9UODUNKfXfS7kxLHCoP016KUeO9i10eO9NiVptGU7GUmiEM49IgTG78
JKXgTVwKtk+kDftYzQub9ZVj/PkoHJFJqx97i+DPTXGL2VIXKyNytEZhGlqvMysn
zx+ZORxc0JftkHgeBk071NMZTyA49lYqu2APg5OlSQ8RcH3uAhAyWte7qPW5AxNw
sHgCdT+iCB9j+UoX0+NxPW7SKyhrZdJTEui2NptMjvPE4xk6SevNCpKUaTIOQFOq
7jdvzFrSyji9QAlyKV5ER4WGFPqKn3Bae3C8DBMq6umVllJysO9bGthdfrprqmRq
Bp4vfNh93YdO3BxluIoaUSrSVFnzshfUBvpuBfXxoIwJvnANXyL3tD0/63MpVS3m
1OHDrpmJ
=0k5f
-----END PGP SIGNATURE-----

--me2obmlf4xujkq6e--
