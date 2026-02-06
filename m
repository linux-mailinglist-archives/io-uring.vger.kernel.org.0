Return-Path: <io-uring+bounces-12074-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKFDDR2ehWlKEAQAu9opvQ
	(envelope-from <io-uring+bounces-12074-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 08:54:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A3712FB243
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 08:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 450A93019469
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 07:54:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73823346A0C;
	Fri,  6 Feb 2026 07:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="njO4JYl5"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD2346797;
	Fri,  6 Feb 2026 07:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770364438; cv=none; b=Uf3PikqIAo8xa5w4H1n0fYYQ1KbntBW2doGCKUIvYEoSLKsb4uZPEf0Q2vy1wYLUIG8JKzs/iYQhkM31R9hzczWvAafP3Iua7zz0DoEE1TAzqk/HsDzMX7L7ytFc6LjaY9LEHcww9ZJUUHWRD1qb56dq6dZ1YYiSsF4Os4wzheM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770364438; c=relaxed/simple;
	bh=Pj9iwovf0I2RBgkLPilum2j12NvqmQ4kdpMAZ1DtSrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rf5+D6lIotQFUPmdZ4q65ou+epduZM6oNAGqGRoZJSro+uTg9DLV5trIUuAuzeLhX90jJpkne9yRhoQeJhCnca8m3WoA8jPaNinSdgdXf0ht5gUgtoRp9Wo3NP25ION2ag+S7lugs3CTGYhnjxgymSuspeZ2f9uoDJju9rnHPtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=njO4JYl5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OPT10ujaAbuWZvMuTl5QL4JM0gq3Z+Df3JwzZul1ln0=; b=njO4JYl5kwPtglTv4NpOetzIND
	Or4ylqcGydDzTdk9aCpdcDRKlSkj2njfuZoxgKzQNsEgpIrzfoQFAdftrwlprrC+psxzeN97bMSNy
	AE8LrCALdXqMlOxorIDnD0szVhY2WaYz22tVIfYMGIYXRD3XQVbpFfniEDvMhkiQ2fttw3Z54Fl6J
	oGztf+UXpXjJ2QjsMsiy+hyWfPsMVV754EV6NITBzgmQu4PF9bav6QIhoKHqdLRmiGU0ycm0VZLY6
	ANzOn5qRwklnsLRR5GqYq8HTuANY5yDsiTpZvdLs892c8jxWR/EEMZoxhWEjI5ftNYym71Tn9IEwt
	KtkS+a3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1voGf4-0000000B0cF-2DOp;
	Fri, 06 Feb 2026 07:53:54 +0000
Date: Thu, 5 Feb 2026 23:53:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com,
	csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org,
	asml.silence@gmail.com, xiaobing.li@samsung.com,
	safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed
 buffer rings
Message-ID: <aYWeErf9bgQJANRF@infradead.org>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-4-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116233044.1532965-4-joannelkoong@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12074-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: A3712FB243
X-Rspamd-Action: no action

On Fri, Jan 16, 2026 at 03:30:22PM -0800, Joanne Koong wrote:
> The implementation follows the same pattern as pbuf ring registration,
> reusing the validation and buffer list allocation helpers introduced in
> earlier refactoring. The IOBL_KERNEL_MANAGED flag marks buffer lists as
> kernel-managed for appropriate handling in the I/O path.

Do you have a man page or other documentation for the uapi somewhere?

> +int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
> +{
> +	struct io_uring_buf_reg reg;
> +	struct io_buffer_list *bl;
> +	int ret;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	if (copy_from_user(&reg, arg, sizeof(reg)))
> +		return -EFAULT;
> +
> +	ret = io_validate_buf_reg(&reg, 0);
> +	if (ret)
> +		return ret;

Probably more a comment for patch 1, but wouldn't it make sense
to combine copy from user and vaidation into a single helper?

> +	ret = io_alloc_new_buffer_list(ctx, &reg, &bl);
> +	if (ret)
> +		return ret;

Return the buffer list from io_alloc_new_buffer_list or an ERR_PTR
to simplify this a bit?

> +	ret = io_setup_kmbuf_ring(ctx, bl, &reg);
> +	if (ret) {
> +		kfree(bl);
> +		return ret;
> +	}
> +
> +	bl->flags |= IOBL_KERNEL_MANAGED;

Should io_setup_kmbuf_ring set IOBL_KERNEL_MANAGED as it is the one
creating the kernel managed buffers?

> +{
> +	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;

Isn't this really a GFP_USER allocation and should account towardas the
callers memory cgroup limit?

> +	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
> +		return -EFAULT;
> +
> +	if (WARN_ON_ONCE(!nr_bufs || !buf_size))
> +		return -EINVAL;
> +
> +	nr_pages = ((size_t)buf_size * nr_bufs) >> PAGE_SHIFT;
> +	if (nr_pages > UINT_MAX)
> +		return -E2BIG;

This looks overflow prone, and probably should use check_mul_overflow.


