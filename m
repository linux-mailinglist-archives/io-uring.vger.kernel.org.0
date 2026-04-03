Return-Path: <io-uring+bounces-12942-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PSzC3Q/z2kXuQYAu9opvQ
	(envelope-from <io-uring+bounces-12942-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 06:17:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C49F7390DD2
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 06:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2E4F53008C2C
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 04:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CBB12D9792;
	Fri,  3 Apr 2026 04:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGg7sUFA"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D34623EA89
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 04:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189870; cv=none; b=UC62RQuHbhSZ3QUR267fnyGLsDpa8x5DHKtd/0cFGILsjvMpYq3vX/lXntrNHRXjm2u5KpFh2H70IrGs7PnqiKIdjH7PFdl9bEkMij1GB432FrT5PC4744zMhlDNEcWXYph6hokx3RkTaQOgGCxS2cpdf4qPVtm7gBOhTa4c/7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189870; c=relaxed/simple;
	bh=qyF3K26GuiWIXgM/zTMQciia4eCTzlAoNl0UT+wJS8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPb0fmhaiV/3uW7Yy+a1qANA3SntPtxt81Z5BFD8Pkh+pxKkmlMm9D05w10yar8Ou/oGdh3i1/0Fc+NOrdgiwzgmMhpYvJrP2KUsObHKDXub/rv5ib6ehmOjQ4zxN9x6VvykQRGk8gBzoIkDd/m+4bb8EkV218UpUh9LJGORFTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fGg7sUFA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775189867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9dk4taWr5CSsrkYNbhI6aSxiSvpfoZSTEmGxFAQcCq0=;
	b=fGg7sUFAmp/X6878bVuHE09SfoNCOXjkPgF23JZpeKvS7rIjmSS+fktieAUrP21Gyw+RCZ
	znTxkRQGiveFj421z0uZzkNUSx2DySGHavMbpUggsw3u4HyWyoeOUX7EaHCgyWvTNI5OJU
	WyeZJxSYbfwpeq1Q9FI9ur55vnp08q0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-FuR2_Tc5Mp2-NrVZItz6Fw-1; Fri,
 03 Apr 2026 00:17:44 -0400
X-MC-Unique: FuR2_Tc5Mp2-NrVZItz6Fw-1
X-Mimecast-MFC-AGG-ID: FuR2_Tc5Mp2-NrVZItz6Fw_1775189863
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09ED819560A7;
	Fri,  3 Apr 2026 04:17:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C756D1978D41;
	Fri,  3 Apr 2026 04:17:38 +0000 (UTC)
Date: Fri, 3 Apr 2026 12:17:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH V3 05/12] io_uring: bpf: extend io_uring with bpf
 struct_ops
Message-ID: <ac8_XZZiTmHi3mwq@fedora>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
 <20260324163753.1900977-6-ming.lei@redhat.com>
 <b7216cd5-68f4-4ab5-b1c8-b1c71f38fc00@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7216cd5-68f4-4ab5-b1c8-b1c71f38fc00@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12942-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C49F7390DD2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 08:09:03PM -0600, Jens Axboe wrote:
> On 3/24/26 10:37 AM, Ming Lei wrote:
> >  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >  {
> > +	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
> > +	u32 opf = READ_ONCE(sqe->bpf_op_flags);
> > +	unsigned char bpf_op = uring_bpf_get_op(opf);
> > +	const struct uring_bpf_ops *ops;
> > +
> > +	if (unlikely(!(req->ctx->flags & IORING_SETUP_BPF_EXT)))
> > +		goto fail;
> > +
> > +	if (bpf_op >= IO_RING_MAX_BPF_OPS)
> > +		return -EINVAL;
> > +
> > +	ops = req->ctx->bpf_ext_ops[bpf_op].ops;
> > +	data->opf = opf;
> > +	data->ops = ops;
> > +	if (ops && ops->prep_fn)
> > +		return ops->prep_fn(data, sqe);
> > +fail:
> >  	return -EOPNOTSUPP;
> >  }
> 
> Any early exit should ensure 'data' is sane, so that the cleanup doesn't
> potentially touch uninitialized crap. This is something that has bit us
> in the past. Not an issue for this patch that adds the code, but it will
> be once the next patch is applied. Better to clear ->opf/ops here
> upfront, so that we never leave this function without 'data' being fully
> initialized.

But ->cleanup() is only called in case of REQ_F_NEED_CLEANUP.

Or maybe you mean other cleanup instead of ->cleanup()?


Thanks,
Ming


