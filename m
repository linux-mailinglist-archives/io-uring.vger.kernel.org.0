Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A3963A5CC
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 11:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiK1KNh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 05:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiK1KNg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 05:13:36 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBE113E3B;
        Mon, 28 Nov 2022 02:13:34 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221128101332euoutp01fdb6fb00c4c9f29fc8476c5086890a62~ruAOvHNk23166731667euoutp01Y;
        Mon, 28 Nov 2022 10:13:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221128101332euoutp01fdb6fb00c4c9f29fc8476c5086890a62~ruAOvHNk23166731667euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669630412;
        bh=qMvlhXPd4Uz2aVO//JVo8dPMm6K+lJu+nwCb764lyOs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=J4hjL3cbfRW/RZjltKquY/LIafVIKrccbIBn0l/w9v6JukAdsAHdnPiC7GtkmKRX6
         LixABIpmq5o/TPqc2UTwOkQ+BXFR7H8FnatxempoWr7Q53aHADgNWgjrpRe5IF5XFr
         4O8mri9gFULboleVwdcRRRF1zOdqBXySNSi6R+LU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221128101332eucas1p2eee67107433a9481fe439c89d4ea531d~ruAOhrL171104411044eucas1p2J;
        Mon, 28 Nov 2022 10:13:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 32.C7.10112.CC984836; Mon, 28
        Nov 2022 10:13:32 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221128101332eucas1p1e9a55da84f95426b47d238990f5f88e3~ruAOGTf_c0914109141eucas1p14;
        Mon, 28 Nov 2022 10:13:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221128101332eusmtrp2d2053f00a72f4a52cfa1c490d5122ec1~ruAOFn2pI1566115661eusmtrp2t;
        Mon, 28 Nov 2022 10:13:32 +0000 (GMT)
X-AuditID: cbfec7f4-d09ff70000002780-18-638489cc21e3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id ED.50.09026.BC984836; Mon, 28
        Nov 2022 10:13:32 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221128101331eusmtip27ef299cd3571d4d093df7e29fa48ed68~ruAN4aD1i0777707777eusmtip2d;
        Mon, 28 Nov 2022 10:13:31 +0000 (GMT)
Received: from localhost (106.210.248.49) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Mon, 28 Nov 2022 10:13:31 +0000
Date:   Mon, 28 Nov 2022 11:13:29 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>, <ddiss@suse.de>,
        <linux-security-module@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [RFC 1/1] Use ioctl selinux callback io_uring commands that
 implement the ioctl op convention
Message-ID: <20221128101329.lcn3bimihmtwsqqm@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="azktuxapv6mevsy2"
Content-Disposition: inline
In-Reply-To: <Y3zW02nH1LQhb/qz@T590>
X-Originating-IP: [106.210.248.49]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7djPc7pnOluSDRrfSlt8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxaHIzk8XtSdNZHNg8Nq3qZPNYu/cFo8f7fVfZPDafrvb4vEkugDWKyyYl
        NSezLLVI3y6BK2PTwVmsBec1K97PnMXSwLhYsYuRk0NCwERixeH37F2MXBxCAisYJbr7bjGB
        JIQEvjBKnG11gEh8ZpR4PuEaI0zHmidtjBCJ5YwS874+Z4ar2tc5kQXC2cIoMen2SlaQFhYB
        VYmX3bPA5rIJ6Eicf3OHGcQWEVCSuHt3NdhyZoGTjBJdHz6wgCSEBXIkrm57wwZi8wqYS3Rf
        OAVlC0qcnPkErIZZoEJiyek9QAs4gGxpieX/OEDCnAIqEp/OTWOHOFVJYs2NfWwQdq3EqS0Q
        v0kITOaUOPQlCcJ2kVjw7iIrhC0s8er4FqheGYn/O+dD1WdL7JyyixnCLpCYdXIqG8haCQFr
        ib4zORBhR4n2+ZsZIcJ8EjfeCkIcyScxadt0Zogwr0RHmxBEtZrEjqatjBMYlWcheWsWkrdm
        IbwFEdaRWLD7ExuGsLbEsoWvmSFsW4l1696zLGBkX8UonlpanJueWmyUl1quV5yYW1yal66X
        nJ+7iRGYuk7/O/5lB+PyVx/1DjEycTAeYlQBan60YfUFRimWvPy8VCURXk3G5mQh3pTEyqrU
        ovz4otKc1OJDjNIcLErivGwztJKFBNITS1KzU1MLUotgskwcnFINTFt4rzFJtLzhys6M9d+g
        +IDnzXsxkZ8bVgcwOTwRy7nOqOOUzPaz0p/p/mPJlkdnjqfnPnq0RvxD3tRYlW//nwd4OW4o
        Vkh5wrZJeh6vQJz/yQ3mCTGnODdP6X96c/tFP8/SBZpPd9ZLf3++quRE6Y9FyTPNklI/TF3J
        3/J+yqrzvkk8682fbq+pOpyaqzX/+vOV+/f++1V3wG/V5ssVnyUj+19d3pS95FvK5b9Wt08E
        qH1tfsC+RzRNylgyxE9wZfjLdafeuF5K2jk1/2Tuvf7Ln108eFOn2RpbLdwVNMdU44nQgcWT
        WG0fLJ9l4cjVsvPGTrlZLxeaLWl6d35K+xcnAyWeX2J1WmdNjRnevPdWYinOSDTUYi4qTgQA
        n52B9tgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t/xe7pnOluSDb63MFp8/T+dxeJd6zkW
        iw89j9gsbkx4ymhxaHIzk8XtSdNZHNg8Nq3qZPNYu/cFo8f7fVfZPDafrvb4vEkugDVKz6Yo
        v7QkVSEjv7jEVina0MJIz9DSQs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+PfvgdsBWc1
        K9ac3MvawLhQsYuRk0NCwERizZM2xi5GLg4hgaWMEscX72OHSMhIfLryEcoWlvhzrYsNougj
        o8TPW01sIAkhgS2MEgeWB4LYLAKqEi+7ZzGB2GwCOhLn39xhBrFFBJQk7t5dzQ7SzCxwklGi
        68MHFpCEsECOxNVtb8AG8QqYS3RfOAW1YSOLxIqVJ5kgEoISJ2c+AWrgAOouk2jsroYwpSWW
        /+MAqeAUUJH4dG4a1KFKEmtu7GODsGslPv99xjiBUXgWkkGzEAbNQhgEUsEsoCVx499LJgxh
        bYllC18zQ9i2EuvWvWdZwMi+ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzCGtx37uWUH48pX
        H/UOMTJxMB5iVAHqfLRh9QVGKZa8/LxUJRFeTcbmZCHelMTKqtSi/Pii0pzU4kOMpsBAnMgs
        JZqcD0wueSXxhmYGpoYmZpYGppZmxkrivJ4FHYlCAumJJanZqakFqUUwfUwcnFINTDMrnSTm
        z18nL/ho8e30vkyufUreQTc/zdAK4BbycT9257JfJ9+rl6u4NVe9mhA366qjk3iftd9s7Rb1
        tzObZ57//KRsy6cq9Y3nl29Ztta7rf9ue1rFquP8VXpq0qe/5N5O6q1cfu5AQqSx2rPLwfFM
        r7VOHeApfDRh6mpvzoKGL5qr38yQmfcvKjzxdnrLjpWTegtnrZx15suVF1ZMHR1rWLVqM/3M
        ZT4yu6iG7SvUUWV9tmTt6m3Kd6sv2PsuOc/E6NxgyP3Lu3bLfNWV+7fNaBMUvpYcN9/fJvdl
        9YacUxKhVlOqr/7d07NofuI+5p+f7TInHdaas/+tjPoXrsB31xx953+9OPWD1MOi9AVKLMUZ
        iYZazEXFiQB6lUXKdgMAAA==
X-CMS-MailID: 20221128101332eucas1p1e9a55da84f95426b47d238990f5f88e3
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
        <CAHC9VhR+RFqJ7c6mFhnMFdDXPcCBg-pnAzEuyOc-TX5hmsubwg@mail.gmail.com>
        <Y3zW02nH1LQhb/qz@T590>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--azktuxapv6mevsy2
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2022 at 10:04:03PM +0800, Ming Lei wrote:
> On Mon, Nov 21, 2022 at 04:05:37PM -0500, Paul Moore wrote:
> > On Mon, Nov 21, 2022 at 2:53 PM Luis Chamberlain <mcgrof@kernel.org> wr=
ote:
> > > On Thu, Nov 17, 2022 at 05:10:07PM -0500, Paul Moore wrote:
> > > > On Thu, Nov 17, 2022 at 4:40 AM Joel Granados <j.granados@samsung.c=
om> wrote:
> > > > > On Wed, Nov 16, 2022 at 02:21:14PM -0500, Paul Moore wrote:
> > > >
> > > > ...
> > > >
> > > > > > * As we discussed previously, the real problem is the fact that=
 we are
> > > > > > missing the necessary context in the LSM hook to separate the
> > > > > > different types of command targets.  With traditional ioctls we=
 can
> > > > > > look at the ioctl number and determine both the type of
> > > > > > device/subsystem/etc. as well as the operation being requested;=
 there
> > > > > > is no such information available with the io_uring command
> > > > > > passthrough.  In this sense, the io_uring command passthrough is
> > > > > > actually worse than traditional ioctls from an access control
> > > > > > perspective.  Until we have an easy(ish)[1] way to determine the
> > > > > > io_uring command target type, changes like the one suggested he=
re are
> > > > > > going to be doomed as each target type is free to define their =
own
> > > > > > io_uring commands.
> > > > >
> > > > > The only thing that comes immediately to mind is that we can have
> > > > > io_uring users define a function that is then passed to the LSM
> > > > > infrastructure. This function will have all the logic to give rel=
ative
> > > > > context to LSM. It would be general enough to fit all the possibl=
e commands
> > > > > and the logic would be implemented in the "drivers" side so there=
 is no
> > > > > need for LSM folks to know all io_uring users.
> > > >
> > > > Passing a function pointer to the LSM to fetch, what will likely be
> > > > just a constant value, seems kinda ugly, but I guess we only have u=
gly
> > > > options at this point.
> > >
> > > I am not sure if this helps yet, but queued on modules-next we now ha=
ve
> > > an improvement in speed of about 1500x for kallsyms_lookup_name(), and
> > > so symbol lookups are now fast. Makes me wonder if a type of special
> > > export could be drawn up for specific calls which follow a structure
> > > and so the respective lsm could be inferred by a prefix instead of
> > > placing the calls in-place. Then it would not mattter where a call is
> > > used, so long as it would follow a specific pattern / structure with
> > > all the crap you need on it.
> >=20
> > I suspect we may be talking about different things here, I don't think
> > the issue is which LSM(s) may be enabled, as the call is to
> > security_uring_cmd() regardless.  I believe the issue is more of how
> > do the LSMs determine the target of the io_uring command, e.g. nvme or
> > ublk.
> >=20
> > My understanding is that Joel was suggesting a change to the LSM hook
> > to add a function specific pointer (presumably defined as part of the
> > file_operations struct) that could be called by the LSM to determine
> > the target.
> >=20
> > Although now that I'm looking again at the file_operations struct, I
> > wonder if we would be better off having the LSMs inspect the
> > file_operations::owner field, potentially checking the module::name
> > field.  It's a little painful in the sense that it is potentially
> > multiple strcmp() calls for each security_uring_cmd() call, but I'm
> > not sure the passed function approach would be much better.  Do we
> > have a consistent per-module scalar value we can use instead of a
> > character string?
>=20
> In future there may be more uring_cmd kernel users, maybe we need to
> consider to use one reserved field in io_uring_sqe for describing the
> target type if it is one must for security subsystem, and this way
> will be similar with traditional ioctl which encodes this kind of
> info in command type.
This is of course another option. I was a bit reluctant to start the
discussion with this implementation, but now that you have brought it up
I can come up with an initial RFC and we can add it to the mix of
possibilities.

Would you just add it to the end of the struct? or what reserved field
are you referring to?
>=20
>=20
> Thanks,
> Ming
>=20

--azktuxapv6mevsy2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmOEiccACgkQupfNUreW
QU92Dgv/ScMT3mr8AvxoRo5sZiP3f3dtxeH205PV7agYJKInt/x5Tn00YZKj3Xzh
lr2It6u/uyR8SpB/nLOHdVszR8OqdrANZdmEWEKX9uGfHNeBuCDP/ZX84FKr+Kio
SD4hP2U7VjLnV13o8HoP1W9TImsKBVG8q9Wyu23QgF8k5S1G0HVHl/0s5/xda+JM
Xwsopo06SM9p4bpa/HV28UZQY5RGjQSQyw1/CmfgH+wUm7glHf0WT/MkfIJP5Om0
Bx5/bHYwzJkGy4+IhjD6sCJsd4oki85zjIeagr2VPgU9INcqTyhIMCBRK4nROjBa
1YilhKdY8PkczE3tKv/nsZyd7NjIiZ3AcY1Joy3+Vgnygpv8mdLZjQKmEpzi9qA1
NOEXxvX9UEW6WPYGKAueZbyfSYu632wirb+ANLEQOlILRunD/1LhFi+uCAALpyeR
LNOMD2fRwl5a6qrWe9jyJ5h4WWMD2KtrSze44DGSeW5uvj+0qylFHPzceu9oDhyE
yIrMj893
=N71E
-----END PGP SIGNATURE-----

--azktuxapv6mevsy2--
