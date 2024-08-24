Return-Path: <io-uring+bounces-2935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1382295DCF4
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:32:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1F271F22874
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F646143889;
	Sat, 24 Aug 2024 08:32:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F3641C72;
	Sat, 24 Aug 2024 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724488323; cv=none; b=XmUKrEGA9G1Qq9yb8w2kDjClexcY3KGyfvGHFmC6t4+5Mht+KvOY5NMYDQ73VErRrgf5BqsxOaj5XE2JYU5VjFvTEW7tv53kN8+5o0Lk7jyA2Jo1Dfhb6Pnry2ojJ6RfNa2M2pZkmcRJ+jeWNigj0lIL3tcp28ladgAddyMLEAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724488323; c=relaxed/simple;
	bh=hBm5dNcozJ1Y+xmj3Ha9SlUQWSGOjF70IDv5m9tSWJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3crsVtVeGy61wIgi1adyDPnMESolcam0o78i674f9TxtFOpcEv+195cpnW72JrkEnm1I4YNJnxWV9DCO2o5aX/7R2L6zHetDQWEB4iJ0VDXjaAlONDIXDmQ3UI/CelRKO0V8h9rkJg04TNEYQagQ3T4u3tWYQiNDkpcnuJQYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 92986227A87; Sat, 24 Aug 2024 10:31:58 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:31:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 05/10] block: define meta io descriptor
Message-ID: <20240824083158.GD8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104624epcas5p40c1b0f3516100f69cbd31d45867cd289@epcas5p4.samsung.com> <20240823103811.2421-6-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-6-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 23, 2024 at 04:08:05PM +0530, Anuj Gupta wrote:
> +struct uio_meta {
> +	meta_flags_t	flags;
> +	u16		app_tag;
> +	struct		iov_iter iter;
> +};

Odd formatting here - the aligning tab goes before the field name,
not the name of the structure type.


