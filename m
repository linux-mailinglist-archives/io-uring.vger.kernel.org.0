Return-Path: <io-uring+bounces-6832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79539A47625
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 07:57:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 288BC188EF0F
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 06:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573221FF1B4;
	Thu, 27 Feb 2025 06:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bz8u17XL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7621EB5ED
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 06:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740639445; cv=none; b=BFcSN1/fG3hZVUAQMkxlCUrcLMRzW/liX/kVtjDTZC+S0Ip04JY8LxpCqZJh63CXW+S2bHQ6aCTuw8lGXmvsAk/gQDeiGDjuqPEZQCKPCgrTjg/mPGojbYeafyFvSPlqo79y6KHxnTOu+UKK9yfTsuSJ3nt/yvWICKQqyJtskrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740639445; c=relaxed/simple;
	bh=+t1vB+e+bOKQTWYHRPeG3VR1xS2UIFEHDuINsmtsQSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndx2A0Q7DLCuwcBwxy4HIkXmtlXGLOFxiD03FK46A402vVoaSY5cRGlzs84bJAKKEbhQ68OkLa5RddpDDQpexBlAIZggCBirtWVkVt+repUNF4Kjm6Ym/BHJ7fal70eO4amXRyclvSHVJ6aDtQaranhaQ5PRZL3ffcbcouReeRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bz8u17XL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740639442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fN9zyRpTMvyZXcI47Dudh0fWxP2P2sHISATio+64sck=;
	b=Bz8u17XLWGwKTooGeDDorQPyJl5vjFoNUFgsY401yKUXvHo/ol3/ykWfRuBGijHwQFl9Dj
	9lWHEls0KvdIADplwYYHh4mfa5T0OJCIfFGeigMmQ9N0i5MhXxHXNwFkL0t1ikVgOdIFw1
	PXUgSTSmYPOu2rTP5BtGXcA0gtwE0HU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-HLnvhgB0Or-cduU6yFqZwQ-1; Thu,
 27 Feb 2025 01:57:17 -0500
X-MC-Unique: HLnvhgB0Or-cduU6yFqZwQ-1
X-Mimecast-MFC-AGG-ID: HLnvhgB0Or-cduU6yFqZwQ_1740639436
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3F411800874;
	Thu, 27 Feb 2025 06:57:15 +0000 (UTC)
Received: from localhost (unknown [10.2.16.46])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6771D19560AE;
	Thu, 27 Feb 2025 06:57:13 +0000 (UTC)
Date: Thu, 27 Feb 2025 14:57:11 +0800
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
Message-ID: <20250227065711.GB85709@fedora>
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
 <20250219020112.GB38164@fedora>
 <be8704b0-81a4-403b-8b42-d3612099279f@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QutFJKJ1ZBtQgHGb"
Content-Disposition: inline
In-Reply-To: <be8704b0-81a4-403b-8b42-d3612099279f@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


--QutFJKJ1ZBtQgHGb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025 at 07:10:36PM +0800, Ferry Meng wrote:
>=20
> On 2/19/25 10:01 AM, Stefan Hajnoczi wrote:
> > On Wed, Dec 18, 2024 at 05:24:32PM +0800, Ferry Meng wrote:
> > > This patchset implements io_uring passthrough surppot in virtio-blk
> > > driver, bypass vfs and part of block layer logic, resulting in lower
> > > submit latency and increased flexibility when utilizing virtio-blk.
> > Hi,
> > What is the status of this patch series?
> >=20
> > Stefan
>=20
> I apologize for the delayed response. It seems that the maintainer has not
> yet provided feedback on this patch series, and I was actually waiting for
> his comments before proceeding. I have received the feedback from the oth=
er
> reviewers & have already discovered some obvious mistakes in v1 series.
>=20
>=20
> Although I'm occupied with other tasks recently, I expect to send out v2
> patches *in a week*.

Great. I'll review the next revision in more detail.

Thanks,
Stefan

>=20
>=20
> Thanks.
>=20
> > > In this version, currently only supports READ/WRITE vec/no-vec operat=
ions,
> > > others like discard or zoned ops not considered in. So the userspace-=
related
> > > struct is not complicated.
> > >=20
> > > struct virtblk_uring_cmd {
> > > 	__u32 type;
> > > 	__u32 ioprio;
> > > 	__u64 sector;
> > > 	/* above is related to out_hdr */
> > > 	__u64 data;  // user buffer addr or iovec base addr.
> > > 	__u32 data_len; // user buffer length or iovec count.
> > > 	__u32 flag;  // only contains whether a vector rw or not.
> > > };
> > >=20
> > > To test this patch series, I changed fio's code:
> > > 1. Added virtio-blk support to engines/io_uring.c.
> > > 2. Added virtio-blk support to the t/io_uring.c testing tool.
> > > Link: https://github.com/jdmfr/fio
> > >=20
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > Performance
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > Using t/io_uring-vblk, the performance of virtio-blk based on uring-c=
md
> > > scales better than block device access. (such as below, Virtio-Blk wi=
th QEMU,
> > > 1-depth fio)
> > > (passthru) read: IOPS=3D17.2k, BW=3D67.4MiB/s (70.6MB/s)
> > > slat (nsec): min=3D2907, max=3D43592, avg=3D3981.87, stdev=3D595.10
> > > clat (usec): min=3D38, max=3D285,avg=3D53.47, stdev=3D 8.28
> > > lat (usec): min=3D44, max=3D288, avg=3D57.45, stdev=3D 8.28
> > > (block) read: IOPS=3D15.3k, BW=3D59.8MiB/s (62.7MB/s)
> > > slat (nsec): min=3D3408, max=3D35366, avg=3D5102.17, stdev=3D790.79
> > > clat (usec): min=3D35, max=3D343, avg=3D59.63, stdev=3D10.26
> > > lat (usec): min=3D43, max=3D349, avg=3D64.73, stdev=3D10.21
> > >=20
> > > Testing the virtio-blk device with fio using 'engines=3Dio_uring_cmd'
> > > and 'engines=3Dio_uring' also demonstrates improvements in submit lat=
ency.
> > > (passthru) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B=
0 -O0 -n1 -u1 /dev/vdcc0
> > > IOPS=3D189.80K, BW=3D741MiB/s, IOS/call=3D4/3
> > > IOPS=3D187.68K, BW=3D733MiB/s, IOS/call=3D4/3
> > > (block) taskset -c 0 t/io_uring-vblk -b4096 -d8 -c4 -s4 -p0 -F1 -B0 -=
O0 -n1 -u0 /dev/vdc
> > > IOPS=3D101.51K, BW=3D396MiB/s, IOS/call=3D4/3
> > > IOPS=3D100.01K, BW=3D390MiB/s, IOS/call=3D4/4
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D
> > > Changes
> > > =3D=3D=3D=3D=3D=3D=3D
> > >=20
> > > Changes in v1:
> > > --------------
> > > * remove virtblk_is_write() helper
> > > * fix rq_flags type definition (blk_opf_t), add REQ_ALLOC_CACHE flag.
> > > https://lore.kernel.org/io-uring/202412042324.uKQ5KdkE-lkp@intel.com/
> > >=20
> > > RFC discussion:
> > > ---------------
> > > https://lore.kernel.org/io-uring/20241203121424.19887-1-mengferry@lin=
ux.alibaba.com/
> > >=20
> > > Ferry Meng (3):
> > >    virtio-blk: add virtio-blk chardev support.
> > >    virtio-blk: add uring_cmd support for I/O passthru on chardev.
> > >    virtio-blk: add uring_cmd iopoll support.
> > >=20
> > >   drivers/block/virtio_blk.c      | 320 +++++++++++++++++++++++++++++=
++-
> > >   include/uapi/linux/virtio_blk.h |  16 ++
> > >   2 files changed, 331 insertions(+), 5 deletions(-)
> > >=20
> > > --=20
> > > 2.43.5
> > >=20
>=20

--QutFJKJ1ZBtQgHGb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmfADMYACgkQnKSrs4Gr
c8jz7gf/c3Twnw6cmUIGZ/fNaLP0eld0k8vAGDGtBoL4DmX6CVcdgbnhvoYfvAca
lXiz+VFWI1azdrIkU1cuvHfInJgVFrL9Rkq9F6pAEZEplHesY5iRR53l45+eKeM+
/YVI4jJaZQkEsr9YyNkY0TBLLom0o2de0npgg7Plu1j6Bfn7f/omyvyBBCgqEk8x
/RBA8JQ/b2ltF5KV8aIEoXTUiiN43O205Lqx0UlVvahvlWY29WY5k70bFy9Wn7gK
TnDL4NrddTl6vvP5CCo5TQDHZBZNRyQegTpJbc1g7cR6egz5RsNrJ1OeOA7MVpxL
hNoD9AKorcwvOiA7VNcgL6lvIFG6Mw==
=Ccdx
-----END PGP SIGNATURE-----

--QutFJKJ1ZBtQgHGb--


