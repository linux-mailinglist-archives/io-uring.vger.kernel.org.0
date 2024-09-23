Return-Path: <io-uring+bounces-3267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 533A897ED96
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 17:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E48281F21D59
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 15:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA14199FC6;
	Mon, 23 Sep 2024 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="onw6jE77"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B975619415E;
	Mon, 23 Sep 2024 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727104070; cv=none; b=OBNH+Xke0oHaFES2EesxeXyCvWG5jhQKTOBw51vQSWbCDObwraFaccDWEOn5MmM0JKepiYpBDSpGtAW8oiw2kPtBcyK8inI5T88H0Ns8jYVh9cBoxlmovPf18njXq7weIODZEXRasKDtYB+CZO1z4t7dgSqmTltwsfGpTIXxVsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727104070; c=relaxed/simple;
	bh=W1pefi5igcK1hr4ybIAeq0pPOZX5WY4nO7qmh+HZtuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7eeGLKbbncJ4PdvNl1jZo8NJDU4yaarZVp3T1Qz8bG46C3oMEtb7PLkBz311rfeuSGJZic1TIzmj+nA1CYZbhHKGyoQcpUC28bENw8j1VqrZOiFuMcT/lhWeK1TRhcLBwTU0NSYY9GmqaOKT9T9kvGnKFbhNpl3J2NDVYOHKe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=onw6jE77; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bHExFaERt4F7uV6B2loAIyCxnFPZqj7/GdDEVUjiXeg=; b=onw6jE77qyXMpPC/XBMmOmI6qw
	pWhIlQC8HWHYz3FNKIsyJiLPgs01cokvhzB02qp/wlZjHoOfx41rHBIwSdfuvU2nQFq9FlzDQ6Swj
	xDDKdVS/oO72CQcDlqPxUjRb2FyXw4usKoIJtr3vgIOskF0M9pWori8Tt39OMbkv6B3oecr+EkhU4
	KMsK/09oB67kuViq2eOgDMty5Ot2Sj8+KMmPkq6xFsgURrKcbldRwUBCn22RP0dh7hh8vXkX/TbpV
	P384mnFNCXUvptbbVO78cgGzEKdnTxnt46okgy91c3bWOBx0xd1kuvuAVaGjsAVojRphFL6nUfMgy
	piQQWxbg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sskfB-0000000EuXL-3QZQ;
	Mon, 23 Sep 2024 15:07:45 +0000
Date: Mon, 23 Sep 2024 16:07:45 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, audit@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240923150745.GB3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 12:30:48AM -0600, Jens Axboe wrote:

> 1) Just don't reuse the entry. Then we can drop the struct
>    filename->aname completely as well. Yes that might incur an extra
>    alloc for the odd case of audit_enabled and being deep enough that
>    the preallocated names have been used, but doesn't anyone really
>    care? It'll be noise in the overhead anyway. Side note - that would
>    unalign struct filename again. Would be nice to drop audit_names from
>    a core fs struct...

You'll get different output in logs, though.  Whether that breaks userland
setups/invalidates certifications/etc.... fuck knows.

If anything, a loop through the list, searching for matching entry would
be safer in that respect.  Order of the items... might or might not be
an issue - see above.

> 2) Add a ref to struct audit_names, RCU kfree it when it drops to zero.
>    This would mean dropping struct audit_context->preallocated_names, as

Costly, that.

>    otherwise we'd run into trouble there if a context gets blown away
>    while someone else has a ref to that audit_names struct. We could do
>    this without a ref as well, as long as we can store an audit_context
>    pointer in struct audit_names and be able to validate it under RCU.
>    If ctx doesn't match, don't use it.

That's one of the variants I mentioned upthread...

