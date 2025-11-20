Return-Path: <io-uring+bounces-10672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D4571C71B6F
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 02:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1741A4E4009
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 01:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122DD3BB4A;
	Thu, 20 Nov 2025 01:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RvHvsIfv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BDF372AA7
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 01:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763603184; cv=none; b=HJp0IRl41hB3HIsZVGhC9WKEZGHqZxTTSN/s1UEF4BvXaeSJV9MItu9isDVzYx1Xtrpd4N9y3xDkmVYbDqz2cbNKrFDrTzjUk0PJY3ioS1dIN7bTRMVPgWOUsNxsz6Hsgqd777BpAkuKiv10cC6lTXjmjfbRHTJAKOMQsaGPnHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763603184; c=relaxed/simple;
	bh=VYpFdsw544nsFgirUueNVSz87tIpYdjGsqQKyJDDoBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnRkTTz4Xa3Xo5M4idS27PaH7tpFWSuGs2ghy9ZYm9KmPQesLF7AKS7a+ab739bceOlP7PuNPUfbvZNb4FxxjXJDCbQy7F3ao6RHvfENzvW2NTSU3I529ymrLUHwRVT4HsVslVk+HexkK8z4OXzpRqZ6IgQGY42tKlIlUfVL2go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RvHvsIfv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763603181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SPmouy/mUggh3bYO/U1+zlHvx4uL1t93jF9904YUwGY=;
	b=RvHvsIfvS/415lzYY5ULx+E6PAhZGpHjjJJQo7im4k0IzVakuLLQXvB0Moh5xH//2QzlR4
	JvOv4IRYHjCsn34pzvJrV4a/LzUSzmtvAn/LyycjstG1BhH/vGwuG9/Wheal+HMp7JTc+P
	tfImMCRw0dOsasKBcdozs4mWhiPYM4k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-399-SlLhSGgJPgukd1MbAEuFPA-1; Wed,
 19 Nov 2025 20:46:17 -0500
X-MC-Unique: SlLhSGgJPgukd1MbAEuFPA-1
X-Mimecast-MFC-AGG-ID: SlLhSGgJPgukd1MbAEuFPA_1763603176
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC273180049F;
	Thu, 20 Nov 2025 01:46:15 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D9AC19540E7;
	Thu, 20 Nov 2025 01:46:10 +0000 (UTC)
Date: Thu, 20 Nov 2025 09:46:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
Message-ID: <aR5y3pFTgDDNptdx@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <20251104162123.1086035-4-ming.lei@redhat.com>
 <87346a2ijz.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87346a2ijz.fsf@trenco.lwn.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Nov 19, 2025 at 07:39:12AM -0700, Jonathan Corbet wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> 
> > io_uring can be extended with bpf struct_ops in the following ways:
> 
> So I have a probably dumb question I ran into as I tried to figure this
> stuff out.  You define this maximum here...
> 
> > +#define MAX_BPF_OPS_COUNT	(1 << IORING_BPF_OP_BITS)
> 
> ...which sizes the bpf_ops array:
> 
> > +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
> 
> Later, you do registration here:
> 
> > +static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
> > +{
> > +	struct io_ring_ctx *ctx;
> > +	int ret = 0;
> > +
> > +	guard(mutex)(&uring_bpf_ctx_lock);
> > +	list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> > +		mutex_lock(&ctx->uring_lock);
> > +
> > +	if (reg) {
> > +		if (bpf_ops[ops->id].issue_fn)
> > +			ret = -EBUSY;
> > +		else
> > +			bpf_ops[ops->id] = *ops;
> > +	} else {
> > +		bpf_ops[ops->id] = (struct uring_bpf_ops) {0};
> > +	}
> > +
> > +	synchronize_srcu(&uring_bpf_srcu);
> > +
> > +	list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> > +		mutex_unlock(&ctx->uring_lock);
> > +
> > +	return ret;
> > +}
> 
> Nowhere do I find a test ensuring that ops->id is within range;
> MAX_BPF_OPS_COUNT never appears in a test.  What am I missing?

bits of `ops->id` is limited by IORING_BPF_OP_BITS and it is stored in top
8bits of ->bpf_flags, so ops->id is within the range naturally.


Thanks,
Ming


