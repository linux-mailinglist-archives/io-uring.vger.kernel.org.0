Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE95633B2C
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 12:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiKVLUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 06:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiKVLTi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 06:19:38 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D977160EAE;
        Tue, 22 Nov 2022 03:15:24 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221122111523euoutp01cb9b44b3c2166e07210117b90002aa19~p4_gs4ntj2512825128euoutp01k;
        Tue, 22 Nov 2022 11:15:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221122111523euoutp01cb9b44b3c2166e07210117b90002aa19~p4_gs4ntj2512825128euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669115723;
        bh=taB1ayNauTWTVaNQCsjDQCqNomSnQnHbr75m9LlbHpk=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=WBlkxcuJs+qaiY/JHnrZeflM6AJBmV2pgqBSI5IBu9cD9teRT2sjhxxrqWkfynh7/
         XMiI+4dtt7gY/Q1CQZg3H1podoLww2H15nreYn68FwX796KT6gJLlVmfFzzD/uE2Gc
         EdZwKYLuKLkNHTI7Mlw8jZjLODxdEF7m94E1RvvY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221122111523eucas1p1a57730768d067e84445a3ad971c97cfe~p4_ggEGX22473424734eucas1p1D;
        Tue, 22 Nov 2022 11:15:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 8A.B7.09561.A4FAC736; Tue, 22
        Nov 2022 11:15:22 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221122111522eucas1p2e32d23e6446815e1c7df46dcf7fcc4a2~p4_gJ0aSp2802328023eucas1p2i;
        Tue, 22 Nov 2022 11:15:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221122111522eusmtrp21b48c41f51d0121c48aa83d7757f6293~p4_gI_1_C0154901549eusmtrp2T;
        Tue, 22 Nov 2022 11:15:22 +0000 (GMT)
X-AuditID: cbfec7f2-0c9ff70000002559-13-637caf4a6de6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 6F.E4.09026.A4FAC736; Tue, 22
        Nov 2022 11:15:22 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221122111522eusmtip19524ff8dd64354e6b90cebadbb1fcf64~p4_f8tY8b0249502495eusmtip1o;
        Tue, 22 Nov 2022 11:15:22 +0000 (GMT)
Received: from localhost (106.110.32.133) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 22 Nov 2022 11:15:21 +0000
Date:   Tue, 22 Nov 2022 12:15:23 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Paul Moore <paul@paul-moore.com>,
        Kanchan Joshi <joshi.k@samsung.com>, <ddiss@suse.de>,
        <linux-security-module@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <20221122111523.xo5fq3zxifu7iuif@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="x6eqomp6kiyzflvy"
Content-Disposition: inline
In-Reply-To: <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
X-Originating-IP: [106.110.32.133]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsWy7djP87pe62uSDZ4stLT4+n86i8W71nMs
        Fh96HrFZ3JjwlNHi9qTpLA6sHptWdbJ5rN37gtFj8+lqj8+b5AJYorhsUlJzMstSi/TtErgy
        Jtw6wlywTbai/0ATcwNjl0QXIyeHhICJxIsZ39i6GLk4hARWMEq83dHDDuF8YZT4OO04C4Tz
        mVHi8+/LQGUcYC1bt8pBxJczSry7tZEdruhG930mCGcLo8TqzkWMIEtYBFQl3q1+zQpiswno
        SJx/c4cZxBYR0JDYN6EXrIFZYDGjxOLNE1lAEsICORJXt71hA7F5Bcwltuy6zAhhC0qcnPmE
        BeQMZoEKidW9vhCmtMTyfxwgFZwCZhJLNu5ggvhNSeLrm15WCLtW4tSWW2CrJATaOSVmz5vC
        DpFwkVg8oZkNwhaWeHV8C1RcRuL/zvlQg7Ildk7ZxQxhF0jMOjkVGhLWEn1nciDCjhLt8zcz
        QoT5JG68FQQJMwOZk7ZNZ4YI80p0tAlBVKtJ7GjayjiBUXkWkrdmIbw1C+GtWWBzdCQW7P7E
        hiGsLbFs4WtmCNtWYt269ywLGNlXMYqnlhbnpqcWG+allusVJ+YWl+al6yXn525iBCap0/+O
        f9rBOPfVR71DjEwcjIcYVYCaH21YfYFRiiUvPy9VSYS33rMmWYg3JbGyKrUoP76oNCe1+BCj
        NAeLkjgv2wytZCGB9MSS1OzU1ILUIpgsEwenVANT5fyl1peYp1uIX2uz/JaeelNO/VfW3uMW
        J35xh2WdLswQ3lL+yDT25MpDk5/uvDh/2tu0i2n++yyEylf37dm5tivwv+oqxudNt66zT77n
        fIm1bGKowSo5zU219zQTb9zOdBTmSPn30fG37mU7x1CXaddDr1gVnlL9v/XmjvPR1YqZ+W7f
        DrxTXf90z26bXb4fFlue3mmeaL/7yjedyY3LzP7wvYjs/PRok+qGbzxzFTb9cy9vf2xp/eGg
        duoEndPTVkbFMe0q8GLx+DW5vTL37Rf1r9Ur+F8x2ZZ9TrQO/Lf1YZhMb4d4+uO0Cclhx9jN
        u9eLmJ80cRZTvf7RuoyjzLezb6bEF9GAALbTjtF7lFiKMxINtZiLihMBk4M/VM0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/xu7pe62uSDRb2KFt8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxe9J0FgdWj02rOtk81u59weix+XS1x+dNcgEsUXo2RfmlJakKGfnFJbZK
        0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZr+b+YynYIlsx+2ozUwNjh0QX
        IweHhICJxNatcl2MXBxCAksZJaY0TWXqYuQEistIfLrykR3CFpb4c62LDaLoI6PE0ZVX2SGc
        LYwSl+6cZwSpYhFQlXi3+jUriM0moCNx/s0dZhBbREBDYt+EXiaQBmaBxYwSizdPZAFJCAvk
        SFzd9oYNxOYVMJfYsusyI8TUC8wSU49NhEoISpyc+QSsgVmgTOL3qenMIHczC0hLLP/HARLm
        FDCTWLJxB9TZShJf3/SyQti1Ep//PmOcwCg8C8mkWUgmzUKYBBHWkrjx7yUThrC2xLKFr5kh
        bFuJdevesyxgZF/FKJJaWpybnltspFecmFtcmpeul5yfu4kRGLPbjv3csoNx5auPeocYmTgY
        DzGqAHU+2rD6AqMUS15+XqqSCG+9Z02yEG9KYmVValF+fFFpTmrxIUZTYDBOZJYSTc4HJpO8
        knhDMwNTQxMzSwNTSzNjJXFez4KORCGB9MSS1OzU1ILUIpg+Jg5OqQam/Ig5fm679i+x3vjq
        /r8qkZt+0Tob2W3vtzeFBErXneD6+bj279P8Qx3bVrpsvqLpyrsie6WC+xKFP9o3F/EGmzSs
        Nly/pSRm65vsG5x/Svf5f9KtsFK/5PF/r4Jkmo6k4I9yl60rZ5w9918v7O87jS47VWX7Q+yl
        wWeCF0QcPDzb+LLBFV3+fNMbfktEFk2M2+HNfFij7nDV4o4dBTXHHP49Fdqwav+NrXyN2raX
        H4fm5yWLuZiU/eFfliXkZc/ox7jOp3zrfOsi17nyAT6yt7xFH353iV6sWJxy7mTApp3cH/6v
        3OsqySz/ZFNqQXOmQVf0jpXh4c8X9y4yPb/u4g/Z/RIz2wqmHb3r/U9WiaU4I9FQi7moOBEA
        TtOmgm4DAAA=
X-CMS-MailID: 20221122111522eucas1p2e32d23e6446815e1c7df46dcf7fcc4a2
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
        <20221117094004.b5l64ipicitphkun@localhost>
        <CAHC9VhSa3Yrjf9z5L0oS8Cx=20gUrgfA8evizoVjBNs4AB_cXg@mail.gmail.com>
        <Y3vXLQz1k8E/qu5A@bombadil.infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--x6eqomp6kiyzflvy
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2022 at 11:53:17AM -0800, Luis Chamberlain wrote:
> On Thu, Nov 17, 2022 at 05:10:07PM -0500, Paul Moore wrote:
> > On Thu, Nov 17, 2022 at 4:40 AM Joel Granados <j.granados@samsung.com> =
wrote:
> > > On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> >=20
> > ...
> >=20
> > > > * As we discussed previously, the real problem is the fact that we =
are
> > > > missing the necessary context in the LSM hook to separate the
> > > > different types of command targets.  With traditional ioctls we can
> > > > look at the ioctl number and determine both the type of
> > > > device/subsystem/etc. as well as the operation being requested; the=
re
> > > > is no such information available with the io_uring command
> > > > passthrough.  In this sense, the io_uring command passthrough is
> > > > actually worse than traditional ioctls from an access control
> > > > perspective.  Until we have an easy(ish)[1] way to determine the
> > > > io_uring command target type, changes like the one suggested here a=
re
> > > > going to be doomed as each target type is free to define their own
> > > > io_uring commands.
> > >
> > > The only thing that comes immediately to mind is that we can have
> > > io_uring users define a function that is then passed to the LSM
> > > infrastructure. This function will have all the logic to give relative
> > > context to LSM. It would be general enough to fit all the possible co=
mmands
> > > and the logic would be implemented in the "drivers" side so there is =
no
> > > need for LSM folks to know all io_uring users.
> >=20
> > Passing a function pointer to the LSM to fetch, what will likely be
> > just a constant value, seems kinda ugly, but I guess we only have ugly
> > options at this point.
>=20
> I am not sure if this helps yet, but queued on modules-next we now have
> an improvement in speed of about 1500x for kallsyms_lookup_name(), and
> so symbol lookups are now fast. Makes me wonder if a type of special
> export could be drawn up for specific calls which follow a structure
> and so the respective lsm could be inferred by a prefix instead of
> placing the calls in-place. Then it would not mattter where a call is
> used, so long as it would follow a specific pattern / structure with
> all the crap you need on it.

This is very good to know. Thx for putting this in the foreground.
This problems CAN be seen as two:
1. Knowing where the io_uring is coming from (user, file, drivers...)
2. Calling the appropriate callback (ublk callback or nvme callback...)

In this sense we might be able to use kallsysms_lookup_name() to do the
callback to a relevant driver.

I have posted a version 2 of the RFC without using
kallsysms_lookup_name, but I'll keep it in the back of my mind.

Best
>=20
>   Luis

--x6eqomp6kiyzflvy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmN8r0MACgkQupfNUreW
QU+5wQv/Zj4pPfjWKCkIxBRNfwECckRgRNiLIV3GYpD3PgWgyzfsofZa7cIWbVZz
dKJBvACWesWSnY4ZCXsBF4MbLtjJ3TzFaXZh776Fu9uRter9sFmb1V8kIKCQSk1C
iazuKrbBjQMs7rOj1cfGuwutDWM0NuO5zReupzfQRYw5JdO5+tCipS5vtTa0easR
PLuFOCWJdF5OmuIYG+ViLWOIoCE24fIVLdjnzXN6pe/uvxOPJeSV6weIyPTj80j7
vwyqo1twILo2FKav+7GubdYFVLfMuefMsbUfI6hDL5QKSaj6M34Mi0k03FyzTM0G
YQYGB5+tbFxjnsAIxJ/hQUoHomVbw3aYQTmQPFiJ5d9bM8KS4qEh8EBVDB+XVHu9
LWOCcWA1FQlO+lh+KQEwMtNaJtRT5fCF90F9J+uqVK/x9ucciKZq3v5AROa/Lx9I
y0/L8cfvccknZ9+SYM5ecCVkuvRBaHh8e15wqRkRXV9SICruQ9xTD1UWsUogZIV3
1nAMpiG0
=txKy
-----END PGP SIGNATURE-----

--x6eqomp6kiyzflvy--
