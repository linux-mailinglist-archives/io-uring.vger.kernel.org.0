Return-Path: <io-uring+bounces-13895-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fbMJGvr2S2ojdwEAu9opvQ
	(envelope-from <io-uring+bounces-13895-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:42:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D63D17149B5
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:42:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZTNj7ojh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13895-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13895-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDD3A32CDFDB
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 16:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE2A1433BD9;
	Mon,  6 Jul 2026 16:56:20 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC381CEAC2
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 16:56:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783356980; cv=none; b=oylXOdWLR2KOX7ktdwVo3/4mGSr6m/v5ZnMKtmVsbXQcicwnyeDU6xIXvsrgh8Ns9IIO1Vh5bb0n3ASrpfI5rXHP/zXbMfK7kUwy1OHeCkilTwiSz7j8BhWGaCO0DzkZeUJRDvMNjlubBKLnF/5cW3t08faIwckr/ItD3+QyjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783356980; c=relaxed/simple;
	bh=pj9Qhwd3v14MK5Ez1XXQPAeON02TWJz1KkvqtxZoCBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLV61/JIVmX0hlGZiiYW+YsDP1bKLZqGpvB7b71egrHhrugtkhuxFhQQkZrBWrYg/jNvomFQgK61Ih59V228TnI57LEr64ArNxdgXiqUUYihvwJFQuHolXwfzj+PiL7l6ixgwfh2FmIzxIYvQ/R0GYyRwXTB8JepxvVL5VqWbnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTNj7ojh; arc=none smtp.client-ip=209.85.210.169
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-847e6f03df8so4027664b3a.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 09:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783356978; x=1783961778; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KJqSbEEwGKy2Cb+HZgBKJBUYQo8t2/zQH8XFgmSxLqU=;
        b=ZTNj7ojhh2ymUb/HFhuKwLV8Ln2P+mmVjKJGsq17jVwB8/yVsqaoY+4g6P4RPjY+pV
         xpxptZjt7Yli9tM9pL2ordvJqD5yylz/7WdGMSJ5Ze6oj6v5WP1tAeOUVYp9RgUrl+Id
         C5rZekhj5JY2krqEEJfL5Lf85ZjiYeVCMaLiPZzlqIEtg0DFmrKX1H4hNtbkEjDEUEt+
         OJ0czFGv/7p41de6RgiFWR/wF8wY3t8mPgduIcrmkuUbsklIRFjYeVDgQxsRVMNdDStz
         Q00vs9xG1jugYaDnP/8ydPnN0m2T3LbHGEeGES5x7p2zrZuOuWQw1Xeot2isFKyUp4TP
         6IMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783356978; x=1783961778;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KJqSbEEwGKy2Cb+HZgBKJBUYQo8t2/zQH8XFgmSxLqU=;
        b=TzqLKaLfCd7ZCyau38b/w+LS3VocBeYq2kVAxM9mz/6aFF8FSSpaB4DYF5a1ATbBrh
         KGX52Ce2nSJLkWfiuimHhpQyYRltfw7qjLqwtGZdR0VH/chgwHT/jT3g8CwRENe4t9wN
         O0chSIzaWdBT1/+eu4gDruMhLqb45QL5Ws7Oy0wZFvghFJqKYutxXS2a7aZgQa4KnQPV
         Kt7DPxh4n8otKtWV8uVbKQF6SXfOMSMig5RSo+l7e37pOvG/7caSFQ/h65u+mBv1CBqw
         g8ptHLJ0Y+fYIDxITx0wPzbFrr4Nq8IvFbRVzTxTtxLGXnkgPRGGIlIDgQt6brxyLOMG
         urBQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp5sCcS++eYcAxuLfDz2sIrFNkA5tofsr3h+zaHiCB5xoRfJR/WT++NcsG/Z/Iv4HBj5HlvVw4mxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy03gza7qH9+ZDAvmYp5pIVWT8u1pJ9s5gRgFdQmvGMRZkcSNxL
	SidOXA5sTrsfDG1BodyO+gs582EAo5Z9Z8Rodeiz92V7xcwZxXfm3CXVu/tZhyj3ilc=
X-Gm-Gg: AfdE7cmUGuVeTxMqXuZH3NPUyY646bZZeUyPpXCvqUfe9ANTLOKStb0hEqKskT1ee0N
	rRo0dGVuuFtA+45bFB4gie+VvzAt7VHXQVq14PvgMGXTlaHAzo4VRxkc4y6crjScLFcJp2GuAyA
	NiEcEgLISDVFb+GCLb+3jBZkcmYC8EMIR69fSmO3GEDVw0FElrsmK/LkxNEuZFu9EWa3iZ247lB
	Y3/+5Ozd0c13wPVwzV/VVvB0rugfVW5uhb+Cbuo9nxrd3uqNnnkRlB4ctMreD9t5JBGjNxNKjwg
	KcapVCbu0DWf/J4zDN7aPeMTTOjbIAkAHYSha2ByeDR4KdUMXppym7MpHL56bCSZHH8wtTTr929
	R8/ZZFZZV5QnbQYs9tE+FFFSB7of4G0l2DbhE2/LNttJD59pnjDeJSfP4daSFeIjGrWJwtEHuL9
	S+nQTsn7dfsXbvGZqTzmwPqNTHPvNI+XZmVb7HjQ0=
X-Received: by 2002:a05:6a00:e83:b0:847:77e7:6f64 with SMTP id d2e1a72fcca58-84826c976c4mr1541466b3a.20.1783356978171;
        Mon, 06 Jul 2026 09:56:18 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b95c89sm4303497b3a.15.2026.07.06.09.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:56:17 -0700 (PDT)
Date: Tue, 7 Jul 2026 00:56:14 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
Message-ID: <akveLoJcC6bOFybB@naup-virtual-machine>
References: <20260705234534.768138-1-naup96721@gmail.com>
 <717fd2f3-6493-4dc5-ba83-c8d2af278639@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <717fd2f3-6493-4dc5-ba83-c8d2af278639@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13895-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D63D17149B5

Oh, this patch looks more clear. The original iovec is freed only after
 access_ok is verified, and the updated iovec for kmsg is returned to
the upper layer. In the error path, the original iovec object is not
freed, and the upper layer's iovec is not updated along that path.

If there are no other issues, I will send the second version of the
patch when I wake up.

Thanks for your review.

On Mon, Jul 06, 2026 at 10:19:10AM -0600, Jens Axboe wrote:
> On 7/5/26 5:45 PM, Hao-Yu Yang wrote:
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 3cd29477fff2..4055173e0c48 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -256,6 +256,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
> >  	struct io_uring_buf_ring *br = bl->buf_ring;
> >  	struct iovec *org_iovs = arg->iovs;
> >  	struct iovec *iov = arg->iovs;
> > +	struct iovec *old = NULL;
> >  	int nr_iovs = arg->nr_iovs;
> >  	__u16 nr_avail, tail, head;
> >  	struct io_uring_buf *buf;
> > @@ -288,7 +289,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
> >  		if (unlikely(!iov))
> >  			return -ENOMEM;
> >  		if (arg->mode & KBUF_MODE_FREE)
> > -			kfree(arg->iovs);
> > +			old = arg->iovs;
> >  		arg->iovs = iov;
> >  		nr_iovs = nr_avail;
> >  	} else if (nr_avail < nr_iovs) {
> > @@ -318,6 +319,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
> >  		if (unlikely(!access_ok(iov->iov_base, len))) {
> >  			if (arg->iovs != org_iovs)
> >  				kfree(arg->iovs);
> > +			/* hand the still-live cached vec back to the owner */
> > +			arg->iovs = org_iovs;
> >  			return -EFAULT;
> >  		}
> >  		iov++;
> > @@ -330,6 +333,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
> >  		buf = io_ring_head_to_buf(br, ++head, bl->mask);
> >  	} while (--nr_iovs);
> >  
> > +	kfree(old);
> > +
> >  	if (head == tail)
> >  		req->flags |= REQ_F_BL_EMPTY;
> 
> Can't we just do the below, that seems a lot simpler?
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 3cd29477fff2..3bb24d20c890 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -287,8 +287,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		iov = kmalloc_objs(struct iovec, nr_avail);
>  		if (unlikely(!iov))
>  			return -ENOMEM;
> -		if (arg->mode & KBUF_MODE_FREE)
> -			kfree(arg->iovs);
>  		arg->iovs = iov;
>  		nr_iovs = nr_avail;
>  	} else if (nr_avail < nr_iovs) {
> @@ -330,6 +328,9 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
>  		buf = io_ring_head_to_buf(br, ++head, bl->mask);
>  	} while (--nr_iovs);
>  
> +	if (arg->mode & KBUF_MODE_FREE)
> +		kfree(org_iovs);
> +
>  	if (head == tail)
>  		req->flags |= REQ_F_BL_EMPTY;
>  
> 
> 
> -- 
> Jens Axboe

