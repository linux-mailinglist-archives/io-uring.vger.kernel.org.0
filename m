Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA35A6463
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiH3NI7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 09:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiH3NI6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 09:08:58 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFBAAF487
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 06:08:51 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220830130846euoutp014c420686f97a30d39394b1698a1053eb~QIVh5ObiJ2330623306euoutp01d;
        Tue, 30 Aug 2022 13:08:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220830130846euoutp014c420686f97a30d39394b1698a1053eb~QIVh5ObiJ2330623306euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661864926;
        bh=dlsDdZTam3zDcRlgGdhVn68hNSCzeCSRgP9HwY0w0do=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=DF3wM5GNGm3UPI3jLt2EC9roaiwiZxCHccvAh6XiiwgejWOsjSpo1n9jjdZHBrPXm
         Czdt8Leut/heiLAKk5G4BQeX7HN+cm2njnWtZZW4U/cidAvi4582peOo9ipQGg8F1E
         dDLh/bCOStv0JbjbjbDVwGEjmiqMTFUdzahCekOQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220830130846eucas1p10dd182518946c7fd2cba776b011c68dd~QIVhk9JJ12397223972eucas1p18;
        Tue, 30 Aug 2022 13:08:46 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 62.DB.29727.DDB0E036; Tue, 30
        Aug 2022 14:08:45 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220830130845eucas1p27bfbc22140bd9ba4666343f62449c582~QIVhKvGka2893828938eucas1p2t;
        Tue, 30 Aug 2022 13:08:45 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220830130845eusmtrp16eb87818c53376200f718521a9ba5ac6~QIVhIbZd52845928459eusmtrp1J;
        Tue, 30 Aug 2022 13:08:45 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-c3-630e0bdd215f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 81.43.10862.DDB0E036; Tue, 30
        Aug 2022 14:08:45 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220830130845eusmtip2512877797f3dd0ba44fefea10f77800d~QIVg_A9CR3029630296eusmtip2q;
        Tue, 30 Aug 2022 13:08:45 +0000 (GMT)
Received: from localhost (106.210.248.185) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 30 Aug 2022 14:08:44 +0100
Date:   Tue, 30 Aug 2022 15:08:43 +0200
From:   Joel Granados <j.granados@samsung.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
CC:     Kanchan Joshi <joshi.k@samsung.com>,
        Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        <io-uring@vger.kernel.org>
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Message-ID: <20220830130843.mp5j2e5psrg6js56@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="e4kolcecz6lwy2i7"
Content-Disposition: inline
In-Reply-To: <a6cb7a3b-8393-c8f3-60f6-00ae08dab23a@schaufler-ca.com>
X-Originating-IP: [106.210.248.185]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7djPc7p3ufmSDY5NsbZYfbefzeLetl9s
        Fu9az7FY3J40ncWBxePy2VKPtXtfMHoc3b+IzePzJrkAligum5TUnMyy1CJ9uwSujH2zzrAU
        PDSsmLzwPksD42+NLkZODgkBE4n2cwuYuxi5OIQEVjBKLDw3kRXC+cIoMWPNNnYI5zOjxOx3
        e1m6GDnAWvbMLoGIL2eUuPtyEQtc0bdfV6A6tjJKtOxrYAZZwiKgKjH77lVGEJtNQEfi/Js7
        YHERIHvfnudgDcwC6xglrh/fyQ6SEBZwlNj26yKYzStgLnHyyhNWCFtQ4uTMJywgNrNAhcSJ
        h/vZQE5iFpCWWP6PA8TkFHCReD0vA+I3ZYnbHeuZIexaibXHzoCtkhD4wSHReWYFI0TCRWLD
        rEZ2CFtY4tXxLVC2jMTpyT0sEHa2xM4pu6AGFUjMOjmVDRIS1hJ9Z3Igwo4Sqz4dYocI80nc
        eCsIcSSfxKRt05khwrwSHW1CENVqEjuatjJOYFSeheStWUjemoXwFkRYT+LG1CmYwtoSyxa+
        ZoawbSXWrXvPsoCRfRWjeGppcW56arFhXmq5XnFibnFpXrpecn7uJkZgcjr97/inHYxzX33U
        O8TIxMF4iFEFqPnRhtUXGKVY8vLzUpVEeL+f40kW4k1JrKxKLcqPLyrNSS0+xCjNwaIkzpuc
        uSFRSCA9sSQ1OzW1ILUIJsvEwSnVwCR8dP3Lyewvnrcdjtwls2DJY+t4vimNxd/1mKTPs3m5
        m905yzrh1WTT7W4pc3waG+9rrW91yPp8puIl2xXbvQ9zeWXaQsz3b/0t+OeTjYwznwmD5PPs
        CWul7BY9XujO+v/K5avz+Z/90gs8cjlgQoXPdbWVbTJz35ev0fqtqx/2u6l6H0Mj3/3JTc/5
        bvZ+dfHYW7Zgh/KvG+2MwdE/9/Msrgv4MlVUYY8250beuh+qexOsdVYx7qvWXx56LuHqlo2X
        YyJPSElYBuSITF3l+GlRyBT2SB85q6x2++M8ReHLlobfZDT8dDH5iQqXRdfSBN0I69AP9ha8
        Nk6MXeUnpmy8Ynxz4TSpLpbjr5P+sSixFGckGmoxFxUnAgDDHCY6yQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xe7p3ufmSDZ59lbVYfbefzeLetl9s
        Fu9az7FY3J40ncWBxePy2VKPtXtfMHoc3b+IzePzJrkAlig9m6L80pJUhYz84hJbpWhDCyM9
        Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jAd9B5kK7htWtC88ztLA+FOji5GDQ0LA
        RGLP7JIuRi4OIYGljBJtv24xdTFyAsVlJD5d+cgOYQtL/LnWxQZR9JFR4tuaaSwQzlZGiROH
        u8A6WARUJWbfvcoIYrMJ6Eicf3OHGcQWAbL37XnODtLALLCOUeL68Z1gY4UFHCW2/boIZvMK
        mEucvPKEFWLqHWaJ53OWsUAkBCVOznzCAnIrs0CZxLQuCwhTWmL5Pw4Qk1PAReL1vAyIQ5Ul
        bnesZ4awayVe3d/NOIFReBaSObMQ5sxCmANSwQx0586td9gwhLUlli18zQxh20qsW/eeZQEj
        +ypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAGN127OeWHYwrX33UO8TIxMF4iFEFqPPRhtUX
        GKVY8vLzUpVEeL+f40kW4k1JrKxKLcqPLyrNSS0+xGgKDMOJzFKiyfnA5JFXEm9oZmBqaGJm
        aWBqaWasJM7rWdCRKCSQnliSmp2aWpBaBNPHxMEp1cDkavNNjseqSoRhF++WKffZkxw8zjBc
        Wi+ulX+J+8aXXQ6tRvxRh314Zuc8CnkzQc3Ulq+x6bRx3/7uVuUv9j9/5KV2e2XeyGdXtjn/
        O8Z5hafNJ/2i9Rsm+zdv4jvK/7i+skMm+ljNn0U1TVdlvGyvb4v9slvZWKMnd/uM5uN+3yZx
        79qjFclhLyv4fuqSpJZvrtt796XaLyoROiYU8T5ZmXm9rKzy8tpjh2PlJL7WLp3/WXHxppvN
        LGHc0qpL5O/uMLi/15LpxMJ3S8ziFz/j2N+iYmf+NMBss5xK+B5PrRC2qLoLS6Y3nHreqlzy
        88Lv0vMN/Jbn+/7O+jfn5U99yZLF/uHb/mVEmfNuilFiKc5INNRiLipOBABLoo4MZgMAAA==
X-CMS-MailID: 20220830130845eucas1p27bfbc22140bd9ba4666343f62449c582
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--e4kolcecz6lwy2i7
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Casey

I have tested this patch and I see the smack_uring_cmd prevents access
to file when smack labels are different. They way I got there was a bit
convoluted and I'll describe it here so ppl can judge how valid the test
is.

Tested-by: Joel Granados <j.granados@samsung.com>

I started by reproducing what Kanchan had done by changing the smack
label from "_" to "Snap". Then I ran the io_uring passthrough test
included in liburing with an unprivileged user and saw that the
smack_uring_cmd function was NOT executed because smack prevented an open on
the device file ("/dev/ng0n1" on my box).

So here I got a bit sneaky and changed the label after the open to the
device was done. This is how I did it:
1. In the io_uring_passthrough.c tests I stopped execution after the
   device was open and before the actual IO.
2. While on hold I changed the label of the device from "_" to "Snap".
   At this point the device had a "Snap" label and the executable had a
   "_" label.
3. Previous to execution I had placed a printk inside the
   smack_uring_cmd function. And I also made sure to printk whenever
   security_uring_command returned because of a security violation.
4. I continued execution and saw that both smack_uiring_cmd and
   io_uring_cmd returned error. Which is what I expected.

I'm still a bit unsure of my setup so if anyone has comments or a way to
make it better, I would really appreciate feedback.

Best

Joel

On Mon, Aug 29, 2022 at 09:20:09AM -0700, Casey Schaufler wrote:
> On 8/27/2022 8:59 AM, Kanchan Joshi wrote:
> > On Tue, Aug 23, 2022 at 04:46:18PM -0700, Casey Schaufler wrote:
> >> Limit io_uring "cmd" options to files for which the caller has
> >> Smack read access. There may be cases where the cmd option may
> >> be closer to a write access than a read, but there is no way
> >> to make that determination.
> >>
> >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >> --=20
> >> security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
> >> 1 file changed, 32 insertions(+)
> >>
> >> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> >> index 001831458fa2..bffccdc494cb 100644
> >> --- a/security/smack/smack_lsm.c
> >> +++ b/security/smack/smack_lsm.c
> >> @@ -42,6 +42,7 @@
> >> #include <linux/fs_context.h>
> >> #include <linux/fs_parser.h>
> >> #include <linux/watch_queue.h>
> >> +#include <linux/io_uring.h>
> >> #include "smack.h"
> >>
> >> #define TRANS_TRUE=A0=A0=A0 "TRUE"
> >> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
> >> =A0=A0=A0=A0return -EPERM;
> >> }
> >>
> >> +/**
> >> + * smack_uring_cmd - check on file operations for io_uring
> >> + * @ioucmd: the command in question
> >> + *
> >> + * Make a best guess about whether a io_uring "command" should
> >> + * be allowed. Use the same logic used for determining if the
> >> + * file could be opened for read in the absence of better criteria.
> >> + */
> >> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> >> +{
> >> +=A0=A0=A0 struct file *file =3D ioucmd->file;
> >> +=A0=A0=A0 struct smk_audit_info ad;
> >> +=A0=A0=A0 struct task_smack *tsp;
> >> +=A0=A0=A0 struct inode *inode;
> >> +=A0=A0=A0 int rc;
> >> +
> >> +=A0=A0=A0 if (!file)
> >> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
> >> +
> >> +=A0=A0=A0 tsp =3D smack_cred(file->f_cred);
> >> +=A0=A0=A0 inode =3D file_inode(file);
> >> +
> >> +=A0=A0=A0 smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
> >> +=A0=A0=A0 smk_ad_setfield_u_fs_path(&ad, file->f_path);
> >> +=A0=A0=A0 rc =3D smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
> >> +=A0=A0=A0 rc =3D smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
> >> +
> >> +=A0=A0=A0 return rc;
> >> +}
> >> +
> >> #endif /* CONFIG_IO_URING */
> >>
> >> struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init =3D {
> >> @@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[]
> >> __lsm_ro_after_init =3D {
> >> #ifdef CONFIG_IO_URING
> >> =A0=A0=A0=A0LSM_HOOK_INIT(uring_override_creds, smack_uring_override_c=
reds),
> >> =A0=A0=A0=A0LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
> >> +=A0=A0=A0 LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
> >> #endif
> >
> > Tried this on nvme device (/dev/ng0n1).
> > Took a while to come out of noob setup-related issues but I see that
> > smack is listed (in /sys/kernel/security/lsm), smackfs is present, and
> > the hook (smack_uring_cmd) gets triggered fine on doing I/O on
> > /dev/ng0n1.
> >
> > I/O goes fine, which seems aligned with the label on /dev/ng0n1 (which
> > is set to floor).
> >
> > $ chsmack -L /dev/ng0n1
> > /dev/ng0n1 access=3D"_"
>=20
> Setting the Smack on the object that the cmd operates on to
> something other than "_" would be the correct test. If that
> is /dev/ng0n1 you could use
>=20
> 	# chsmack -a Snap /dev/ng0n1
>=20
> The unprivileged user won't be able to read /dev/ng0n1 so you
> won't get as far as testing the cmd interface. I don't know
> io_uring and nvme well enough to know what other objects may
> be involved. Noob here, too.
>=20
> >
> > I ran fio (/usr/bin/fio), which also has the same label.
> > Hope you expect the same outcome.
> >
> > Do you run something else to see that things are fine e.g. for
> > /dev/null, which also has the same label "_".
> > If yes, I can try the same on nvme side.
> >

--e4kolcecz6lwy2i7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmMOC9AACgkQupfNUreW
QU+A2Qv9GhlOxSJKLuF52v+jEdZFswhatzg4F2DMqJKQazLRmMNakQoS+es8aNwp
XM2+OaYYnC8Sm+qhqDLuPKBdcgIi8YFoYBl6bzCKvNAHOMEU5qd2oY+2hG1JEg3t
seaCs3HZDoxIzFdSvzTDCzLacwBS5KzAb/cuUR9hC11f2iDqKrmw/KnT29m07EY/
fUjf9Ti/jWIDle1jP7ngTJzKILZVceEH4CpQGy5HTBdGo1XZJEuGVYsyTPEaLDOW
jPlD+seql0eqvVYP3RB41T9uYoxKXw7imxsakYRFpye2pqLo7sGT2HtAJ7rY4YzK
0YqC6XV1uUpJO+U/rm80badaZFBVZbEK34mDHegvg/AZbupm6uTNFskpYD4MvDYQ
YyfigwO9X21D4cOXTU71ihXlnpVC4CLcJZ3tppXCQ3qg+qKfLXOENdhtxYbPFZBo
fAbQ499LAC2qYIgEt1+tQxHdmtlTDutVF14lkkEFPHCtgkg/m+neFC5HYqHJB/8S
bjrNwdty
=XTxq
-----END PGP SIGNATURE-----

--e4kolcecz6lwy2i7--
