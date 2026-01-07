Return-Path: <io-uring+bounces-11436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8334DCFD418
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 11:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA70730807EF
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 10:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB79D2E0926;
	Wed,  7 Jan 2026 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pRfqWlDK"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9911829D26E
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 10:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767782708; cv=none; b=ciTmIR4PeeEn+T8RNNJMzWaxkFClXjHjZqGPxYKjqER4J4hDljCkNwVOZJvntR6LKOWN8HGqePTNggZerPscNpvo9QTJq0KSLqOcs8n3naWljy72iHU6m2hhhC+59Zp0aIBUYLRpIDGpvqIZ1Mf1hWs8d14GZZF/Rsb2/XKaCf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767782708; c=relaxed/simple;
	bh=v+WKDEsViGraYcGxAfnCHy6lQ12vFK8jQW7jUHTphac=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=a9ItY2oDvnKc8vB/5vk9bmCXYI91id/KjpysJ8X7Zf6n3Uj8aXq3n/et81UQ0mLesU5qzrQDHWzdd1zrXaGK+FGuRCZ1k9XWA6KO+29atlwuz+lWfI5CiDkTslGtVYaNUUiVeCT0/L+AeyH1NC+l9k7JA8YmL0K95wWLGRJandM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pRfqWlDK; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260107104459epoutp03ce0f67b387403878981b180a4fd09f88~IbP_m6ybx2198221982epoutp03X
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 10:44:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260107104459epoutp03ce0f67b387403878981b180a4fd09f88~IbP_m6ybx2198221982epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767782699;
	bh=86JHWYKwvYo56a5/dl3RgoEI+n+U3DhR8uxQgUFdtIE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pRfqWlDKke2TDcucdq0RPbxiojtQY4hhlZFmNRDnvmD5jkI2leKCPbsphqNTLZdpa
	 B3T9WoxFc576/fqABujYQ1QxuIpaSLvzAxH/B2EJGwzkTfAf2CF2OM4OVZ1wE9i2iv
	 lrcBsnabvNXbm22CKLBL44AII8SLoSIoADXeKJWQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260107104458epcas5p40d912ba427bd3a6e5dc68b7a11fa3705~IbP9xQ7kp2752027520epcas5p4a;
	Wed,  7 Jan 2026 10:44:58 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dmPn51C43z3hhTB; Wed,  7 Jan
	2026 10:44:57 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260107104456epcas5p2d338842fca72f093ebf233c5c6bda766~IbP8MOkFV0407704077epcas5p2T;
	Wed,  7 Jan 2026 10:44:56 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260107104455epsmtip2aa182e94aaabac72a7816a5419f4779d~IbP7Q1ueu1746317463epsmtip2F;
	Wed,  7 Jan 2026 10:44:55 +0000 (GMT)
Date: Wed, 7 Jan 2026 16:10:50 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH V2 3/3] io_uring: remove nr_segs recalculation in
 io_import_kbuf()
Message-ID: <20260107104050.wetbkrjfsnzw2duk@green245.gost>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251231030101.3093960-4-ming.lei@redhat.com>
X-CMS-MailID: 20260107104456epcas5p2d338842fca72f093ebf233c5c6bda766
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db825_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260107104456epcas5p2d338842fca72f093ebf233c5c6bda766
References: <20251231030101.3093960-1-ming.lei@redhat.com>
	<20251231030101.3093960-4-ming.lei@redhat.com>
	<CGME20260107104456epcas5p2d338842fca72f093ebf233c5c6bda766@epcas5p2.samsung.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db825_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 31/12/25 11:00AM, Ming Lei wrote:
>io_import_kbuf() recalculates iter->nr_segs to reflect only the bvecs
>needed for the requested byte range. This was added to provide an
>accurate segment count to bio_iov_bvec_set(), which copied nr_segs to
>bio->bi_vcnt for use as a bio split hint.
>
>The previous two patches eliminated this dependency:
> - bio_may_need_split() now uses bi_iter instead of bi_vcnt for split
>   decisions
> - bio_iov_bvec_set() no longer copies nr_segs to bi_vcnt
>
>Since nr_segs is no longer used for bio split decisions, the
>recalculation loop is unnecessary. The iov_iter already has the correct
>bi_size to cap iteration, so an oversized nr_segs is harmless.
>
>Link: https://lkml.org/lkml/2025/4/16/351
>Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db825_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_db825_--

