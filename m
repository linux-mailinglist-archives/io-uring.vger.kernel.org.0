Return-Path: <io-uring+bounces-5788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2A2A07EB8
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31FAB188D17B
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 17:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9817F192D7E;
	Thu,  9 Jan 2025 17:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ExRLZH9J"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9EB644
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736443642; cv=none; b=oS0/HaW6SAsFgpKRtioZrkL8tzfCJMWU88V1F7vaq6QKdXLQnxmFJOQj5r2tn3d9+87eNWL07HDwXcuCzbTGR9Wa6HDKDhKx0Uov1+hNyXvg1JAaEDYt5vinqCdGDxYBq7tT5g/eK0B+Mu/cWJwXL1cQWK9WZXbXzEiokrewIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736443642; c=relaxed/simple;
	bh=kHu+GTsLpij/qrWD7LEXSugYuuXT9Cxa+9S+SVJ5pR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7f/O6nOhvOQQNAEDtNQru92nZbvoO5EGMJSpOF6uHZmweL18eB0X41auz6uJ2LKCbAdZIvwXRAbjx9hNrom018MmK0GVCMxznILdnr02grJT9bomjZni1CDJ58O7b1nBMVECHg5E2q+plwHhx/eoBOBmEAsXsId5TK5wywgSus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ExRLZH9J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736443638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pQbYtM+vj6QMOXJpXz2slqBkN/ZxPHq8K4lAZBFA1DA=;
	b=ExRLZH9JiihU2OxqZ2oPX0zIKEcw+rMJm3qhw2WLJT0+P79Hl2xzvLbWC7S9G/a1L6vxqf
	fO/m+FJnpyuJm/KbO4UtNVjWb9OyNFIQLvkJjQyYS3g1/YazsZPRTMThb/e21kad/0f+Zj
	1Xq47Zo4xigszy0AbPevJR8WmPIlYJ4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-wMhoz6a5O3Gj9HHvWaKu2g-1; Thu,
 09 Jan 2025 12:27:15 -0500
X-MC-Unique: wMhoz6a5O3Gj9HHvWaKu2g-1
X-Mimecast-MFC-AGG-ID: wMhoz6a5O3Gj9HHvWaKu2g
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CE0E1956053;
	Thu,  9 Jan 2025 17:27:13 +0000 (UTC)
Received: from localhost (unknown [10.2.16.220])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFC63195E3D9;
	Thu,  9 Jan 2025 17:27:11 +0000 (UTC)
Date: Thu, 9 Jan 2025 12:27:10 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Ferry Meng <mengferry@linux.alibaba.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [PATCH v1 0/3] virtio-blk: add io_uring passthrough support.
Message-ID: <20250109172710.GA192961@fedora>
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3VE3BC/I/P4n9b3B"
Content-Disposition: inline
In-Reply-To: <20241218092435.21671-1-mengferry@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


--3VE3BC/I/P4n9b3B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 05:24:32PM +0800, Ferry Meng wrote:
> This patchset implements io_uring passthrough surppot in virtio-blk
> driver, bypass vfs and part of block layer logic, resulting in lower
> submit latency and increased flexibility when utilizing virtio-blk.
>=20
> In this version, currently only supports READ/WRITE vec/no-vec operations,
> others like discard or zoned ops not considered in. So the userspace-rela=
ted

If WRITE is supported then FLUSH is also required so that written data
can be persisted without falling back to another API.

> struct is not complicated.
>=20
> struct virtblk_uring_cmd {
> 	__u32 type;
> 	__u32 ioprio;
> 	__u64 sector;
> 	/* above is related to out_hdr */
> 	__u64 data;  // user buffer addr or iovec base addr.
> 	__u32 data_len; // user buffer length or iovec count.
> 	__u32 flag;  // only contains whether a vector rw or not.
> };=20
>=20
> To test this patch series, I changed fio's code:=20
> 1. Added virtio-blk support to engines/io_uring.c.
> 2. Added virtio-blk support to the t/io_uring.c testing tool.
> Link: https://github.com/jdmfr/fio
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Using t/io_uring-vblk, the performance of virtio-blk based on uring-cmd
> scales better than block device access. (such as below, Virtio-Blk with Q=
EMU,
> 1-depth fio)=20
> (passthru) read: IOPS=3D17.2k, BW=3D67.4MiB/s (70.6MB/s)=20
> slat (nsec): min=3D2907, max=3D43592, avg=3D3981.87, stdev=3D595.10=20
> clat (usec): min=3D38, max=3D285,avg=3D53.47, stdev=3D 8.28=20
> lat (usec): min=3D44, max=3D288, avg=3D57.45, stdev=3D 8.28
> (block) read: IOPS=3D15.3k, BW=3D59.8MiB/s (62.7MB/s)=20
> slat (nsec): min=3D3408, max=3D35366, avg=3D5102.17, stdev=3D790.79=20
> clat (usec): min=3D35, max=3D343, avg=3D59.63, stdev=3D10.26=20
> lat (usec): min=3D43, max=3D349, avg=3D64.73, stdev=3D10.21
>=20
> Testing the virtio-blk device with fio using 'engines=3Dio_uring_cmd'
> and 'engines=3Dio_uring' also demonstrates improvements in submit latency.
> (passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O=
0 -n1 -u1 /dev/vdcc0=20
> IOPS=3D189.80K, BW=3D741MiB/s, IOS/call=3D4/3
> IOPS=3D187.68K, BW=3D733MiB/s, IOS/call=3D4/3=20
> (block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -O0 -=
n1 -u0 /dev/vdc=20
> IOPS=3D101.51K, BW=3D396MiB/s, IOS/call=3D4/3
> IOPS=3D100.01K, BW=3D390MiB/s, IOS/call=3D4/4

This iodepth=3D8 (submission/completion batching 4) result surprised me
because the io_uring calls are already batched but there is still a 4
microsecond improvement per request.

I was expecting to see less improvement when iodepth is increased
because the syscall, io_uring, and some block layer cost is amortized
thanks to batching and block plugging.

Is the virtio-blk driver submitting 4 requests at a time for both
passthru and block? I wonder if something else is going on here.

>=20
> =3D=3D=3D=3D=3D=3D=3D
> Changes
> =3D=3D=3D=3D=3D=3D=3D
>=20
> Changes in v1:
> --------------
> * remove virtblk_is_write() helper
> * fix rq_flags type definition (blk_opf_t), add REQ_ALLOC_CACHE flag.
> https://lore.kernel.org/io-uring/202412042324.uKQ5KdkE-lkp@intel.com/
>=20
> RFC discussion:
> ---------------
> https://lore.kernel.org/io-uring/20241203121424.19887-1-mengferry@linux.a=
libaba.com/
>=20
> Ferry Meng (3):
>   virtio-blk: add virtio-blk chardev support.
>   virtio-blk: add uring_cmd support for I/O passthru on chardev.
>   virtio-blk: add uring_cmd iopoll support.
>=20
>  drivers/block/virtio_blk.c      | 320 +++++++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_blk.h |  16 ++
>  2 files changed, 331 insertions(+), 5 deletions(-)
>=20
> --=20
> 2.43.5
>=20

--3VE3BC/I/P4n9b3B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmeABu4ACgkQnKSrs4Gr
c8jHyggAxZwQ29QQgfNp3N2lpMZshj7//KYUnpXptKL3DjiPOrqv0kP/zLgFnb0Q
1M3YhF6zyll4nhfOSR6PadGIuDeqOWUo0Ya7jpkkETnevPi0BexjOC+3fCRUNP+p
JuJhefhvObAggCiVQXepycJ4URpwmRhA8DluuNux+TsQI+fyslMJ55VO3dEyqzQq
i2iDy8rZ9AWZc90u1BRQ5cIptU6Sdbn2rQpwFaVk1+cMp1WdfF5BsKq+BVsIWm5v
zDlCg0kl3yhc1pJ/h374XNINjlnYS3YEB3YPlO89+KNVtEbzJe0677vA+y6YO7VB
4z6ILKuGVIptHC7Aa4JKwUWAiCDN/A==
=dyzO
-----END PGP SIGNATURE-----

--3VE3BC/I/P4n9b3B--


