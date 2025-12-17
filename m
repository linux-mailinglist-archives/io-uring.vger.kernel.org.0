Return-Path: <io-uring+bounces-11145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A919ECC6C87
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 10:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C80A300977F
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 09:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97563184;
	Wed, 17 Dec 2025 09:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KG3U+zJ/"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93552242D98
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765963543; cv=none; b=UXRCOVXNjliFZecxNAePWpRfWri+YDFTkI65tsyCM+3Bmsk+zr/51uNM/1BsI5yYLKuoMFWMpv33k5BQoyZ7g0t8zjJEJwXX+KKfXVQyxuvqh2TWtAekhjwOl1NP2gq6will+TxNoiSyN+6bxbm/twe0gySwvl18CObNdIhMMa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765963543; c=relaxed/simple;
	bh=1TlE7wICcKAVwJVoiaOG9Pf5Pz0UeTCykL4mx2B6xMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E13trrEJ/LpYKk/MNCPfhhJwv1l+Q6Q4rROhln0tjLP+TPwnA1WiniiIUecpxivOkGuiHNtgEE8NFS4eUltl46oIZdjexs2go/GB7KEhuIfmAn3hbATvgieSZDcOzZqifr5Mz1ICulCCwu5qzEzBIccYqdd3z0C5beE7iDgfRO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KG3U+zJ/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765963539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9+IIVDxiKz/50m0vVWWRYbFCYRcBWOsOhE15R2xWMM4=;
	b=KG3U+zJ/o2WAtyiSsay7pcpT8EUxEVZL7/+c35fZYd+5GxRe8pYoXPa1qEWKDAiRp4eGbV
	I5CzJh/0nUTtbg/WYuRcMfaQaF0XU3aT9qb2pswiEd7Z02sEeZA4tfx8jnggQYsaQu0oGH
	curaEKmpLBh40WeQgi63E7kp9G87u/0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-eBcWCrIfO-Gu8LVgoupy-w-1; Wed,
 17 Dec 2025 04:25:35 -0500
X-MC-Unique: eBcWCrIfO-Gu8LVgoupy-w-1
X-Mimecast-MFC-AGG-ID: eBcWCrIfO-Gu8LVgoupy-w_1765963533
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC8581956050;
	Wed, 17 Dec 2025 09:25:33 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3E3419560B4;
	Wed, 17 Dec 2025 09:25:29 +0000 (UTC)
Date: Wed, 17 Dec 2025 17:25:23 +0800
From: Ming Lei <ming.lei@redhat.com>
To: huang-jl <huang-jl@deepseek.com>
Cc: csander@purestorage.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix nr_segs calculation in io_import_kbuf
Message-ID: <aUJ3A7Ec7EVAI3FB@fedora>
References: <CADUfDZo4Kbkodz3w-BRsSOEwTGeEQeb-yppmMNY5-ipG33B2qg@mail.gmail.com>
 <20251217062632.113983-1-huang-jl@deepseek.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217062632.113983-1-huang-jl@deepseek.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Dec 17, 2025 at 02:26:32PM +0800, huang-jl wrote:
> io_import_kbuf() calculates nr_segs incorrectly when iov_offset is
> non-zero after iov_iter_advance(). It doesn't account for the partial
> consumption of the first bvec.
> 
> The problem comes when meet the following conditions:
> 1. Use UBLK_F_AUTO_BUF_REG feature of ublk.
> 2. The kernel will help to register the buffer, into the io uring.
> 3. Later, the ublk server try to send IO request using the registered
>    buffer in the io uring, to read/write to fuse-based filesystem, with
> O_DIRECT.
> 
> From a userspace perspective, the ublk server thread is blocked in the
> kernel, and will see "soft lockup" in the kernel dmesg.
> 
> When ublk registers a buffer with mixed-size bvecs like [4K]*6 + [12K]
> and a request partially consumes a bvec, the next request's nr_segs
> calculation uses bvec->bv_len instead of (bv_len - iov_offset).
> 
> This causes fuse_get_user_pages() to loop forever because nr_segs
> indicates fewer pages than actually needed.
> 
> Specifically, the infinite loop happens at:
> fuse_get_user_pages()
>   -> iov_iter_extract_pages()
>     -> iov_iter_extract_bvec_pages()
> Since the nr_segs is miscalculated, the iov_iter_extract_bvec_pages
> returns when finding that i->nr_segs is zero. Then
> iov_iter_extract_pages returns zero. However, fuse_get_user_pages does
> still not get enough data/pages, causing infinite loop.
> 
> Example:
>   - Bvecs: [4K, 4K, 4K, 4K, 4K, 4K, 12K, ...]
>   - Request 1: 32K at offset 0, uses 6*4K + 8K of the 12K bvec
>   - Request 2: 32K at offset 32K
>     - iov_offset = 8K (8K already consumed from 12K bvec)
>     - Bug: calculates using 12K, not (12K - 8K) = 4K
>     - Result: nr_segs too small, infinite loop in fuse_get_user_pages.
> 
> Fix by accounting for iov_offset when calculating the first segment's
> available length.
> 
> Fixes: b419bed4f0a6 ("io_uring/rsrc: ensure segments counts are correct on kbuf buffers")
> Signed-off-by: huang-jl <huang-jl@deepseek.com>
> ---
>  v2: Optimize the logic to handle the iov_offset and add Fixes tag.
> 
>  > Please add a Fixes tag
>  
>  Thanks for your notice, this is my first time to send patch to linux. I
>  have add the Fixes tag, but not sure if I am doing it correctly.
> 
>  > Would a simpler fix be just to add a len += iter->iov_offset before the loop?
>  
>  Great suggestion! I have tried it, and also fix the bug correctly.
> 
>  io_uring/rsrc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b331bf..41c89f5c616d 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1059,6 +1059,7 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
>  	if (count < imu->len) {
>  		const struct bio_vec *bvec = iter->bvec;
>  
> +		len += iter->iov_offset;
>  		while (len > bvec->bv_len) {
>  			len -= bvec->bv_len;
>  			bvec++;

Reviewed-by: Ming Lei <ming.lei@redhat.com>



Thanks,
Ming


