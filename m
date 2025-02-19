Return-Path: <io-uring+bounces-6545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A953A3AF3B
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 03:01:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6EC0188BB75
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A67175BF;
	Wed, 19 Feb 2025 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYJcvvdU"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB369165F1A
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 02:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739930485; cv=none; b=oL48IFa1FIRSJ80Jemx23H/c8sSQ5VFgyDeolSnhwErICBAchN36XDLR4o2RnjtfBalblxmMFN752aFsRiho1PQ/FnFMhbmgfGAILqBViyyQaZ4fkggENHQ15BRX3dg7SChPosDU8LNOYbcyv+kgSiHxj86crliBAVxTgnI8E7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739930485; c=relaxed/simple;
	bh=gZqQM7O9ByYPgtbt8cvoz84LcIYYYPm2MVl/usKmDxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RuvPntyjdiVjoSEXiy8FRI+EGJ0JtKjypiQJfpxvafHeIJOU/hJzHOLWYLIB+ixDVm/wegbwtw7FHL0tMCy61k5Wk/8c1gHho+5UVxsAWbjlkXH17BzkUTg7FHUs1Y/RFUd/4kGwGeWggvGMFfPjZMrr/fa+jPdqWXA4xW61mjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYJcvvdU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739930482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TTYk5mPgovr+xjBEyGONMlriCe8a4cY2bYNbOhvz11I=;
	b=UYJcvvdU4UIOvsZlyZYMJFvhDEVZBMzzgdbHU5ntq/yqpZidzx/35t6jfmXTQhFar97G/l
	sBJ+gj2Qi5UYXtZw3aqmxCwvuqHxYz22Zczi1eCf9OWwlnY/+hwDKHv1fzGW/IttkLlIVO
	hi2KfIDCX3lArQWgXcBtXBYBi7mAjXA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-uHOYB5vsO6mICsb6iqyLHA-1; Tue,
 18 Feb 2025 21:01:19 -0500
X-MC-Unique: uHOYB5vsO6mICsb6iqyLHA-1
X-Mimecast-MFC-AGG-ID: uHOYB5vsO6mICsb6iqyLHA_1739930477
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACDF81800875;
	Wed, 19 Feb 2025 02:01:16 +0000 (UTC)
Received: from localhost (unknown [10.2.16.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B788300019F;
	Wed, 19 Feb 2025 02:01:14 +0000 (UTC)
Date: Wed, 19 Feb 2025 10:01:12 +0800
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
Message-ID: <20250219020112.GB38164@fedora>
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0EDesKCYBKGeMMyG"
Content-Disposition: inline
In-Reply-To: <20241218092435.21671-1-mengferry@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


--0EDesKCYBKGeMMyG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 05:24:32PM +0800, Ferry Meng wrote:
> This patchset implements io_uring passthrough surppot in virtio-blk
> driver, bypass vfs and part of block layer logic, resulting in lower
> submit latency and increased flexibility when utilizing virtio-blk.

Hi,
What is the status of this patch series?

Stefan

>=20
> In this version, currently only supports READ/WRITE vec/no-vec operations,
> others like discard or zoned ops not considered in. So the userspace-rela=
ted
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

--0EDesKCYBKGeMMyG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAme1O2gACgkQnKSrs4Gr
c8g5MAf+O8k3P8AmJJwDbR4DW92CZdhXuLHVJZkQLtaxAhrAyTMb9MkmxoqnWQRc
/hlcNOeoe3xO9vu53lnY5LiTjh1K77qW7abGrAtzLL4+2VGNmd8rfh/sy+E9Fgse
LY4YnOupHx/1YlCn3KYabbToQcNqybbfgDD/Lv8zqt+2pFF7lWkAd+1FGOgYFyl2
5kQhEWRwUiN9GRP7KfnESxjA92QSOFMYtqlhjy4FjYfgaPKePPVXAphfjGeqS1I/
2IQSETYLfiXAMW6Q6AbL4HMYeSx0OPeozx7SJvG4m5g5aZBbq6tdgqVNvPWUDI1H
kI7ySFuZWYp+g3EO9+COaYXrk6iJWQ==
=X8Wb
-----END PGP SIGNATURE-----

--0EDesKCYBKGeMMyG--


