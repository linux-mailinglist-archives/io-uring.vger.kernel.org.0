Return-Path: <io-uring+bounces-10929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E93E8C9E38F
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 09:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8561534A636
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 08:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F882D4B5F;
	Wed,  3 Dec 2025 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="bV6r9i6i"
X-Original-To: io-uring@vger.kernel.org
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381592D480F
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764750681; cv=none; b=aHAt41Px/GVWA6XROnxEMqJz7fHzZxHOPcXKE4s2BlHmxuYA/25ak3UFOVXqDSlSYXq7ZGpjGTEIrVtQfCHpQVUvvDmoeXuqnJdNVYSbq8Gg/19qG1qCVkVxAHQti+p0EfhvvtO4TaCwpHGfm4dIFjXAzFx1o1VTRmcm6qie7Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764750681; c=relaxed/simple;
	bh=w3udpsM+2T3nQ5UURtINjXldf3VB9au4wNTCoRu+8JM=;
	h=In-Reply-To:To:Subject:From:References:Content-Type:Date:
	 Message-Id:Mime-Version; b=dRuLIGXQysNbSXPp+NpmOG2jCCuera9nOSzxs+WBi+ryNHz/qn11Uw2KdDx/hAve/p3iSeQOMpzxmS5slztRzVU7qayFVBgyU1lRE9q6kKMQccjcadMffn9lOX18ys/Rd9CUg/JwoG7f7P6LphvhHCxcxLUJ0uhUP1sHAJT79FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=bV6r9i6i; arc=none smtp.client-ip=118.26.132.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1764750666; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=w3udpsM+2T3nQ5UURtINjXldf3VB9au4wNTCoRu+8JM=;
 b=bV6r9i6iGq3nGG/Z5pAu0TZzedyNUOPvimryp7xYUcU1nv4gwnuzP6bdh4OKcAD5WcM1y3
 iY321ci9VxbK/juDRzQBAzLBCIJk3FQCAxM8vTVExmbS1ZDJhNMGoMGT30rEUSr4zPQ1Xq
 X1dYFSAD+bUwNz66FsUbiSZslr0EaDg7ysAgyMg84H1cvkLcAY/uEC1Nr7MK9d3UI/Iaxb
 CAQf/nVaUciKkxwr9heH+U5Kh3wpTfywKJ2BgEMWUjp0IWH+ujWloTSpWEcH/8rFEP27EE
 0GbInBk5mzUYg/5NtY1dY+jpCkD5oMd16O1ExEXHxkCokacw/Dvwetc4lY2SDg==
In-Reply-To: <20251114092149.40116-1-changfengnan@bytedance.com>
To: <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, 
	<jack@suse.cz>, <asml.silence@gmail.com>, <willy@infradead.org>, 
	<djwong@kernel.org>, <hch@infradead.org>, <ritesh.list@gmail.com>, 
	<linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>, 
	<linux-xfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <ming.lei@redhat.com>, 
	<linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v3 0/2] block: enable per-cpu bio cache by default
From: "changfengnan" <changfengnan@bytedance.com>
References: <20251114092149.40116-1-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+1692ff548+b0c904+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 03 Dec 2025 16:31:02 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.198e8c10.5c50.4606.8f05.84122efb6429@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Ping

> From: "Fengnan Chang"<changfengnan@bytedance.com>
> Date:=C2=A0 Fri, Nov 14, 2025, 17:22
> Subject:=C2=A0 [PATCH v3 0/2] block: enable per-cpu bio cache by default
> To: <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <=
jack@suse.cz>, <asml.silence@gmail.com>, <willy@infradead.org>, <djwong@ker=
nel.org>, <hch@infradead.org>, <ritesh.list@gmail.com>, <linux-fsdevel@vger=
.kernel.org>, <io-uring@vger.kernel.org>, <linux-xfs@vger.kernel.org>, <lin=
ux-ext4@vger.kernel.org>, <linux-block@vger.kernel.org>, <ming.lei@redhat.c=
om>, <linux-nvme@lists.infradead.org>
> Cc: "Fengnan Chang"<changfengnan@bytedance.com>
> For now, per-cpu bio cache was only used in the io_uring + raw block

> device, filesystem also can use this to improve performance.

> After discussion in [1], we think it's better to enable per-cpu bio cache

> by default.

>=C2=A0
> v3:

> fix some build warnings.

>=C2=A0
> v2:

> enable per-cpu bio cache for passthru IO by default.

>=C2=A0
> v1:

> https://lore.kernel.org/linux-fsdevel/CAPFOzZs5mJ9Ts+TYkhioO8aAYfzevcgw7O=
3hjexFNb_tM+kEZA@mail.gmail.com/

>=C2=A0
> [1] https://lore.kernel.org/linux-fsdevel/c4bc7c33-b1e1-47d1-9d22-b189c86=
c6c7d@gmail.com/

>=C2=A0
>=C2=A0
> Fengnan Chang (2):

> =C2=A0 block: use bio_alloc_bioset for passthru IO by default

> =C2=A0 block: enable per-cpu bio cache by default

>=C2=A0
> =C2=A0block/bio.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 26 +=
+++++-----

> =C2=A0block/blk-map.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 90 +++++++++++=
+++++-----------------------

> =C2=A0block/fops.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=
=A04 --

> =C2=A0drivers/nvme/host/ioctl.c | =C2=A02 +-

> =C2=A0include/linux/fs.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A03 --

> =C2=A0io_uring/rw.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A01 -

> =C2=A06 files changed, 49 insertions(+), 77 deletions(-)

>=C2=A0
>=C2=A0
> base-commit: 4a0c9b3391999818e2c5b93719699b255be1f682

> --=C2=A0

> 2.39.5 (Apple Git-154)
>=C2=A0

