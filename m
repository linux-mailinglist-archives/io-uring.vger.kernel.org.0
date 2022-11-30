Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6340363E2BB
	for <lists+io-uring@lfdr.de>; Wed, 30 Nov 2022 22:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiK3V3s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Nov 2022 16:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiK3V3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Nov 2022 16:29:47 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6868C900EC;
        Wed, 30 Nov 2022 13:29:44 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221130212940euoutp02da7b387da9d9fa99483e135383d20801~sehJJCNX91850718507euoutp02u;
        Wed, 30 Nov 2022 21:29:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221130212940euoutp02da7b387da9d9fa99483e135383d20801~sehJJCNX91850718507euoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1669843780;
        bh=akhEx41DurukCwscScXy2W8jrCRFMeG68fqPj6Hd0zI=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=FLyeA/XL85JtILsWSe87RtP5osqmGeZXNWjhHppwpfE2R+ovKVapArWx+ITi/GxI7
         rYJeMlfP7Z/Nu3oaQXXiulvxoY5igAzrXLSJErVm96mtyhF0bO8k2UsWC1+6pXqxhD
         qx4TLkFS2A1eSUT1CHHDfMxLCgvuhUT0UMvafSHc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221130212940eucas1p14cbfc0e4c09787d3ed00f9e9c0739e8e~sehIvAaq52135721357eucas1p1t;
        Wed, 30 Nov 2022 21:29:40 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 45.AD.10112.44BC7836; Wed, 30
        Nov 2022 21:29:40 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221130212939eucas1p235600ec236c15b05af0c2df5b24580e4~sehIMd1Gc2791627916eucas1p2c;
        Wed, 30 Nov 2022 21:29:39 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221130212939eusmtrp2aaf52747977ae564c6b6aac0fa5bc23a~sehIL3szs3092830928eusmtrp25;
        Wed, 30 Nov 2022 21:29:39 +0000 (GMT)
X-AuditID: cbfec7f4-cf3ff70000002780-96-6387cb4424d6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id EE.B8.09026.34BC7836; Wed, 30
        Nov 2022 21:29:39 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221130212939eusmtip166dc89a3acdcd91c8b05c3b1fd424984~sehH96xu61256612566eusmtip11;
        Wed, 30 Nov 2022 21:29:39 +0000 (GMT)
Received: from localhost (106.210.248.49) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 30 Nov 2022 21:29:38 +0000
Date:   Wed, 30 Nov 2022 22:29:36 +0100
From:   Joel Granados <j.granados@samsung.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     <mcgrof@kernel.org>, <ddiss@suse.de>, <joshi.k@samsung.com>,
        <paul@paul-moore.com>, <ming.lei@redhat.com>,
        <linux-security-module@vger.kernel.org>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
Subject: Re: [RFC v2 1/1] Use a fs callback to set security specific data
Message-ID: <20221130212936.drfqjdiq6vic3cdc@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="iiqsdd6eqsgh7rd5"
Content-Disposition: inline
In-Reply-To: <Y4YWACJqlhQ80Xby@infradead.org>
X-Originating-IP: [106.210.248.49]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsWy7djP87oup9uTDc79E7RYfbefzeLr/+ks
        FqcnLGKyeNd6jsXiQ88jNosbE54yWhya3MxkcXvSdBYHDo/NK7Q8Lp8t9di0qpPNY+3eF4we
        7/ddZfPYfLra4/MmuQD2KC6blNSczLLUIn27BK6MR2v3shfMEa/49vEhewPjPuEuRk4OCQET
        ia/b3rJ1MXJxCAmsYJR4dWIdE4TzhVFizp4pTCBVQgKfGSX+TdKB6Xi45wJUx3JGiec/TzFC
        OEBF6/sfM0M4Wxglbr76wQrSwiKgKnHn/30WEJtNQEfi/Js7zCC2iICmxK3l7WANzAKnGSU2
        vHwKlhAW8JR40DILrIFXwFzixdkmVghbUOLkzCdgcWaBConpF7cC2RxAtrTE8n8cIGFOAV2J
        xqsfmSFOVZJYc2MfG4RdK3Fqyy2w3yQElnNKnLzWwQqRcJHYf/UpVIOwxKvjW9ghbBmJ/zvn
        M0HY2RI7p+yCqimQmHVyKhvIXgkBa4m+MzkQYUeJuzsPMEGE+SRuvBWEuJJPYtK26cwQYV6J
        jjYhiGo1iR1NWxknMCrPQvLXLCR/zUL4CyKsI7Fg9yc2DGFtiWULXzND2LYS69a9Z1nAyL6K
        UTy1tDg3PbXYKC+1XK84Mbe4NC9dLzk/dxMjMMGd/nf8yw7G5a8+6h1iZOJgPMSoAtT8aMPq
        C4xSLHn5ealKIrwdn9uShXhTEiurUovy44tKc1KLDzFKc7AoifOyzdBKFhJITyxJzU5NLUgt
        gskycXBKNTBlWG/RCj1qfu/Fkvbwb695eOdkHWq9Ivzsxoe97pFdF30WNuf9F69RDFrWd1L+
        adsDo9DU+6qZn7q450wxC7he2yveaTfn1f/jq5qnM96SkHym+5CL0Vny1AJWobh7CmdYvn5+
        eC9e0vnXjn7zm/eeS4WwWlxiLk9u55Dgcj3xZ7PXjmbHS8vO29X/WMnOnip+Rvj2pr3lD1r2
        9Jw7cI9PQHR3Xyi324HVeg/2ffV3VL1hVfXS/7fvipamPclLw+w77PwMqz64ly5zDWSLina3
        zvx1WuOk6Z4Pz4017r+aPGnr9b8vsgKOyzwVfD7pfMENs13PJxkFMt/kPLdX7u6842sCHza4
        Ztw81T3x/fprSizFGYmGWsxFxYkAb4oweOsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t/xu7rOp9uTDXYtVrdYfbefzeLr/+ks
        FqcnLGKyeNd6jsXiQ88jNosbE54yWhya3MxkcXvSdBYHDo/NK7Q8Lp8t9di0qpPNY+3eF4we
        7/ddZfPYfLra4/MmuQD2KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTub
        lNSczLLUIn27BL2Mg927WQtmiVfM3mPRwLhHuIuRk0NCwETi4Z4LbF2MXBxCAksZJdYv/8oM
        kZCR+HTlIzuELSzx51oXVNFHRon+s7/ZIZwtjBKz9rwHq2IRUJW48/8+C4jNJqAjcf7NHbBJ
        IgKaEreWtzODNDALnGaU2PDyKVhCWMBT4kHLLLAGXgFziRdnm1ghpj5jlGhafY0RIiEocXLm
        E6AiDqDuMonHN+whTGmJ5f84QCo4BXQlGq9+hLpaSWLNjX1sEHatxOe/zxgnMArPQjJoFsKg
        WQiDQCqYBbQkbvx7yYQhrC2xbOFrZgjbVmLduvcsCxjZVzGKpJYW56bnFhvpFSfmFpfmpesl
        5+duYgTG+bZjP7fsYFz56qPeIUYmDsZDjCpAnY82rL7AKMWSl5+XqiTC2/G5LVmINyWxsiq1
        KD++qDQntfgQoykwECcyS4km5wMTUF5JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6Yklqdmpq
        QWoRTB8TB6dUA9OO90ZSLb3enmySRSFx1ptPnt7m0/HhY1HkiztPSv0Xlgrt7j0ZH7gtXXVH
        jZD9eR8xwxNincd4glaq7VBP5shMuflymeB0ncnzZa27ZyleORHXGrU9Jub1JAvZno3Kz9vX
        X7buy+H5+OnTL/uENVOO2VQq2P3QN/97MuHivcwj8+W4OjqE9JlubzCvn3xD/nrwq17/mk1W
        lgoiX/dsUp6jcXZLU5Ejv97ju/JLM/m89y969cF3ll+GM/vV79K6yf9/r2/2vOvirMTRw3GA
        J8d1y52lwW77s7Tmlrxd9vyPreicurYfsRMi9E5PnDxx9TTe+ZM5hWPyXrdezPq0MGy1xot5
        9RoBIvujrY91PlBiKc5INNRiLipOBADj+7+FiAMAAA==
X-CMS-MailID: 20221130212939eucas1p235600ec236c15b05af0c2df5b24580e4
X-Msg-Generator: CA
X-RootMTR: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221122103536eucas1p28f1c88f2300e49942c789721fe70c428
References: <20221122103144.960752-1-j.granados@samsung.com>
        <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
        <20221122103144.960752-2-j.granados@samsung.com>
        <Y4YWACJqlhQ80Xby@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--iiqsdd6eqsgh7rd5
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2022 at 06:24:00AM -0800, Christoph Hellwig wrote:
> This seems to be missing any kind of changelog.  Also the
> subject should say file_operations.  Most of the instances here are
> not in a file system, and they most certainly aren't callbacks.
>=20
> I think you've also missed a whole lot of maintainers.
>=20
> > +#include "linux/security.h"
>=20
> That's now how we include kernel-wide headers.
>=20
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
>=20
> Douple white space and overly long line.
>=20
> > +{
> > +	sec->flags =3D 0;
> > +	sec->flags =3D SECURITY_URING_CMD_TYPE_IOCTL;
>=20
> Double initialization of ->flags.  But how is this supposed to work
> to start with?

This RFC is meant to see how different solutions may play out. I'm not
trying to push anything through yet. Just testing the waters to see what
sticks and what people think about certain approaches. Should have
mentioned that in my cover letter.

My idea was to bring all relevant maintainers into the conversation once
I had a more clear idea on what needed to be done and how I would do it.

Since the patch is just a discussion piece, it is riddled with errors
like the ones you pointed out.

The idea with this second version is to add a security uring callback to
the already existing ones in the file_operations structure. This new
callback will fill in a security struct that will contain all the data
needed for the LSMs to do their thing. This callback can be protected by
an 'ifdef' for performance purposes.

There is a third proposal by Ming Lei that uses the io_uring_sqe struct
to embed io_uring type information. In my todo list I have a task to
implement this and present it as a third option.

best
Joel

--iiqsdd6eqsgh7rd5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmOHyzsACgkQupfNUreW
QU9HTAwAhi+yQJEz+u7CGpkk2uLjgDtZddOFhGwN52ATQkrM+Yyp6Psb0FW89Yx1
zyXDHFuGoAMcxMb7E+x90LZyRsXJEtQkEZz2Z/d9L7ruSCp6SWYb3KrR87s2CNoR
eQbE0gUsAQ6ybAiY0mYcZKxd7uYikZUXlBPh8IBK6ixqpazjofFAODhekPiUzfw7
yDHio1S8dPyym8918Y9kmIUqL4xQNQHIGfHqA3EYwj8Jhvp7keGSPmcuU4hVG9tO
Dl5rCAWvBqABpWH/qNOqXzuOPGtPQxHN+bH2NPvoBdMnxeroo8KbOU0vYjt1KrXW
QhPRap+LqPh5KpeDXRDdu36XczhkwPudxiptGy5tmargelq4OUtktMnUlwNWF13e
RuEsuexCIPhMx+L/XNHrdKla8+TlAkDtsigqP2KtZ4thnYMHYX3seYZeAozTjQK0
Nkib62T3XzPPSR9Rj2A6UQ7s0+rltSXcO92vYuzw7nWT750Bk50ROdGGbOeHowuL
jXMwyF8R
=NpAV
-----END PGP SIGNATURE-----

--iiqsdd6eqsgh7rd5--
