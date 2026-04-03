Return-Path: <io-uring+bounces-12941-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBymFpk8z2myuAYAu9opvQ
	(envelope-from <io-uring+bounces-12941-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 06:05:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6E3390CE6
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 06:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 418B930293ED
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 04:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52C9282F0F;
	Fri,  3 Apr 2026 04:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RXrUWEri"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E882618DB01
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 04:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189141; cv=none; b=Mz152KTN1zc7qkQZCjRaY5YEgL0L5RpTv3Lng3TbS1gCL2nRiwrebIvQHmfi3ysrAHScESIrdsc8LAdLZONb2xKI0TNx2T2TFeh6dhRvh+mDiS84nKlTcAq9kvxCQkn8yX7AoZvEhE31GH5t6gbDK4hEti22Eadrh57P3F3/RxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189141; c=relaxed/simple;
	bh=rvZlay+4Su6LyFAw5n2XsrbJxnHHhZUcCzqVHKOP+/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZxby2HGa7XSEoykp7EXChMIHVRwaWVdCsQrPgRQSjMnHs/N7VkOY4jcV0xTSViv+BmNVgaYhwOOM3ESuh5cgdlTce4/DcshfBsYkjAiKqEnoI50+MfQW0CKlcL6r1eV2vwG+KClIj8x/LZ2JwlJ4O5U/qQ8uFnJHvbtrCMO0RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RXrUWEri; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775189138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KTxEDmtAw7ivAjgPJXIYiT+IYRO03kGLboiJ11B4IOA=;
	b=RXrUWEriGhGNuF3RG0yevcOvi6NMJoSM2GpTQ3pqIhRZcgYsWumpWmiigWeYOD0lM09v/s
	NgEDP+9Sem868NKcJL7geYxcT0LcEaJkNVms7+nM3Dwyd3d+JY3ZZ1/3dLPYqbGW6A3ske
	eNB+cJhTQKvG58wsYc8aOO99579QiLA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-427-CnBMLc94PR-rEguroQZcuw-1; Fri,
 03 Apr 2026 00:05:35 -0400
X-MC-Unique: CnBMLc94PR-rEguroQZcuw-1
X-Mimecast-MFC-AGG-ID: CnBMLc94PR-rEguroQZcuw_1775189134
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0F0F1800561;
	Fri,  3 Apr 2026 04:05:33 +0000 (UTC)
Received: from fedora (unknown [10.72.116.83])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC19630002D2;
	Fri,  3 Apr 2026 04:05:29 +0000 (UTC)
Date: Fri, 3 Apr 2026 12:05:24 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH V3 05/12] io_uring: bpf: extend io_uring with bpf
 struct_ops
Message-ID: <ac88hCYgrFXBX3-g@fedora>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
 <20260324163753.1900977-6-ming.lei@redhat.com>
 <5e8766d3-a801-48e0-8d27-60e75523ebd1@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e8766d3-a801-48e0-8d27-60e75523ebd1@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12941-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AE6E3390CE6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 07:49:22PM -0600, Jens Axboe wrote:
> On 3/24/26 10:37 AM, Ming Lei wrote:
> > @@ -493,7 +494,16 @@ struct io_ring_ctx {
> >  	DECLARE_HASHTABLE(napi_ht, 4);
> >  #endif
> >  
> > -	struct io_uring_bpf_ops		*bpf_ops;
> > +	/*
> > +	 * bpf_ops and bpf_ext_ops are mutually exclusive: bpf_ops is used
> > +	 * for io_uring_bpf_ops struct_ops, while bpf_ext_ops provides
> > +	 * per-opcode BPF extension operations (IORING_SETUP_BPF_EXT).
> > +	 * The two cannot be active at the same time on the same ring.
> > +	 */
> > +	union {
> > +		struct io_uring_bpf_ops		*bpf_ops;
> > +		struct uring_bpf_ops_kern	*bpf_ext_ops;
> > +	};
> 
> What am I missing here, why is this the case? What makes the use of both
> at the same time impossible?

Please see the following code:

static inline bool io_has_loop_ops(struct io_ring_ctx *ctx)
{
        return data_race(ctx->loop_step);
}

io_uring_enter():
	...
	if (io_has_loop_ops(ctx)) {
		ret = io_run_loop(ctx);
		goto out;
	}
	...

So if ->loop_step is assigned from io_install_bpf() called from bpf_ops
registration, traditional userspace SQE submission and CQE reap are
bypassed completely, then IORING_OP_BPF and any other OP can't be handled
at all.

> 
> > diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
> > index e4b244337aa9..e91c6964405c 100644
> > --- a/io_uring/bpf-ops.c
> > +++ b/io_uring/bpf-ops.c
> > @@ -162,7 +162,6 @@ static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
> >  		return -EOPNOTSUPP;
> >  	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> >  		return -EOPNOTSUPP;
> > -
> >  	if (ctx->bpf_ops)
> >  		return -EBUSY;
> >  	if (WARN_ON_ONCE(!ops->loop_step))
> 
> Spurious whitespace change.

Will remove it in next version.

> 
> > diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> > index 91cf67b5d85b..1af33a89ed2f 100644
> > --- a/io_uring/io_uring.h
> > +++ b/io_uring/io_uring.h
> > @@ -49,7 +49,8 @@ struct io_ctx_config {
> >  			IORING_FEAT_RECVSEND_BUNDLE |\
> >  			IORING_FEAT_MIN_TIMEOUT |\
> >  			IORING_FEAT_RW_ATTR |\
> > -			IORING_FEAT_NO_IOWAIT)
> > +			IORING_FEAT_NO_IOWAIT |\
> > +			IORING_FEAT_BPF)
> 
> Do we need this FEAT flag? If you think so, then it should at least be
> dependent on whether the kernel supports this feature, eg if
> CONFIG_IO_URING_BPF_EXT is set

Good catch!



Thanks,
Ming


