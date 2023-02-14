Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A56969C9
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjBNQhR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 11:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBNQhQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 11:37:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D57B1E9C9
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 08:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676392577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eFid/HUqcCzTbg7tAocvaeTvEcVaWGtwlBvvmtIKZvo=;
        b=YjGp56h3V8WjQxh8qd6o+Ren6k6BfieI+ZqLuZCoyEZ8zZrFOVB6SeS7XrpBagQefu1s+E
        54r021kZfHDU9KozG02Wsqobvpfx466U4pZtEsec2wS/sYe8+ynJPOKGj4hveq3ZXncc36
        Mn4OK7E+CJ09LrygmnG5QnVbaQ0dECk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-4P__78GPMs2nE1uirjVMyw-1; Tue, 14 Feb 2023 11:36:13 -0500
X-MC-Unique: 4P__78GPMs2nE1uirjVMyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19CDF85D065;
        Tue, 14 Feb 2023 16:36:12 +0000 (UTC)
Received: from localhost (unknown [10.39.193.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E4D340ED76C;
        Tue, 14 Feb 2023 16:36:11 +0000 (UTC)
Date:   Tue, 14 Feb 2023 11:36:09 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH 0/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
Message-ID: <Y+u4ee5b0Dn518Av@fedora>
References: <20230210153212.733006-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aKR+678H52Jj1vwi"
Content-Disposition: inline
In-Reply-To: <20230210153212.733006-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--aKR+678H52Jj1vwi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 10, 2023 at 11:32:08PM +0800, Ming Lei wrote:
> Hello,
>=20
> Add two OPs which buffer is retrieved via kernel splice for supporting
> fuse/ublk zero copy.
>=20
> The 1st patch enhances direct pipe & splice for moving pages in kernel,
> so that the two added OPs won't be misused, and avoid potential security
> hole.
>=20
> The 2nd patch allows splice_direct_to_actor() caller to ignore signal
> if the actor won't block and can be done in bound time.
>=20
> The 3rd patch add the two OPs.
>=20
> The 4th patch implements ublk's ->splice_read() for supporting
> zero copy.
>=20
> ublksrv(userspace):
>=20
> https://github.com/ming1/ubdsrv/commits/io_uring_splice_buf
>    =20
> So far, only loop/null target implements zero copy in above branch:
>    =20
> 	ublk add -t loop -f $file -z
> 	ublk add -t none -z
>=20
> Basic FS/IO function is verified, mount/kernel building & fio
> works fine, and big chunk IO(BS: 64k/512k) performance gets improved
> obviously.
> =20
> Any comment is welcome!

I'm not familiar enough with the splice implementation to review these
patches, but the performance numbers you posted look great. This could
be very nice for ublk and FUSE servers!

Thanks,
Stefan

> Ming Lei (4):
>   fs/splice: enhance direct pipe & splice for moving pages in kernel
>   fs/splice: allow to ignore signal in __splice_from_pipe
>   io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
>   ublk_drv: support splice based read/write zero copy
>=20
>  drivers/block/ublk_drv.c      | 169 +++++++++++++++++++++++++++++++--
>  fs/splice.c                   |  19 +++-
>  include/linux/pipe_fs_i.h     |  10 ++
>  include/linux/splice.h        |  23 +++++
>  include/uapi/linux/io_uring.h |   2 +
>  include/uapi/linux/ublk_cmd.h |  31 +++++-
>  io_uring/opdef.c              |  37 ++++++++
>  io_uring/rw.c                 | 174 +++++++++++++++++++++++++++++++++-
>  io_uring/rw.h                 |   1 +
>  9 files changed, 456 insertions(+), 10 deletions(-)
>=20
> --=20
> 2.31.1
>=20

--aKR+678H52Jj1vwi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPruHkACgkQnKSrs4Gr
c8hoygf/TxmJ6tYvVhdKWk0lr2xIi3rNSAqFHVsyVI5RCeG5vt1rOh2j8Bfx3HpT
xgxK9fTBY3ZJQahLnEpnzxpWovoCAiIEY+fl13LZDplfKvpDcywDamiDbIz1bVOv
b+WnrCPCQReBrj6YmmZWifW9szuWha4CtzhlVqmv0AQlsziKlaMT/6BrDnvaHecL
E9wsK0RrIS0Fhb/FfpmngtAmPu4EoNzRlR2MbbswQwD5PORr/nx+mbSHlNMdJIIC
r0Z89L/s8h+vsUeoaxqSw12UogY4e7YajYfoZbDRNH91f+zGNo7+VTckO9JnU2+G
4ay3KYY7b9hn04w3sa1WpblmLRG8KQ==
=ZOgV
-----END PGP SIGNATURE-----

--aKR+678H52Jj1vwi--

