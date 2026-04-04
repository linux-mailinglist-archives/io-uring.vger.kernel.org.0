Return-Path: <io-uring+bounces-12957-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEttJod90Gmm8AYAu9opvQ
	(envelope-from <io-uring+bounces-12957-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 04 Apr 2026 04:55:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD54399AE8
	for <lists+io-uring@lfdr.de>; Sat, 04 Apr 2026 04:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6A7FB3008C2E
	for <lists+io-uring@lfdr.de>; Sat,  4 Apr 2026 02:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16B10182D0;
	Sat,  4 Apr 2026 02:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MA2MhH+R"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1EB2E2663
	for <io-uring@vger.kernel.org>; Sat,  4 Apr 2026 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775271302; cv=none; b=kLPGiIdoWrkk5AXKSSXW5TgpoC5DueLEH9nnpZ4U7pdV2VEc2vEfJO0ySSfQeDZoseQKnRRaW41lijIqvUvL9Gb6bPmcyeh34IORiLi8qJfbaQW6hjCyK7GUjdX1u4t4GeJOWpuYODn1qHVzEgHSuTsp/hlP88U8P9/qcaXRlh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775271302; c=relaxed/simple;
	bh=+NVMGLiLbVKJzT4i2qJJ3xqz3ckvx4Z/RTLL6ALgXLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZJhZQP6P4jFQ6v8zJmbcCCcgE/Ua/nBeauuf+AHVAnPOpRRz8t6uv4XndwqSGVKRWxNNCYVO8HXUiV7s5D9XlkqGG3KLKw4cQpIPK+Ge4xjj5kP3tZalZte23KSgOqOGc7y/bhPSiFIFziNQJlS640asGiLher5DM846+CQlpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MA2MhH+R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775271299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4YjKSQylRy3kG2NY70t36KXH3hh4sUAIIYuvtFISYzU=;
	b=MA2MhH+RFzhNZ2ej1ErkAMdI7BCa2X6NzFbAGZcOtTq0c1bAFa5WfS4xN7IfUGyP6/b9T9
	zfRbrGYZA1AMudAM95M6TJT5EJ2UYphUdx5jNHzIugQqxKdYgoosa5iQ2gildr9T/TDCUD
	/nNt1HdHW+RYs8Y5BFUPXQhN9CUc8xU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-483-E3iSKoadOLqT_Ob4k5LoMw-1; Fri,
 03 Apr 2026 22:54:56 -0400
X-MC-Unique: E3iSKoadOLqT_Ob4k5LoMw-1
X-Mimecast-MFC-AGG-ID: E3iSKoadOLqT_Ob4k5LoMw_1775271295
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7AEB180049D;
	Sat,  4 Apr 2026 02:54:54 +0000 (UTC)
Received: from fedora (unknown [10.72.116.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B02EC19560A6;
	Sat,  4 Apr 2026 02:54:49 +0000 (UTC)
Date: Sat, 4 Apr 2026 10:54:45 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH V3 05/12] io_uring: bpf: extend io_uring with bpf
 struct_ops
Message-ID: <adB9dYjVAGFoIyTG@fedora>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
 <20260324163753.1900977-6-ming.lei@redhat.com>
 <b7216cd5-68f4-4ab5-b1c8-b1c71f38fc00@kernel.dk>
 <ac8_XZZiTmHi3mwq@fedora>
 <cb3e52fc-3dad-4385-b9b7-ade9add5292f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb3e52fc-3dad-4385-b9b7-ade9add5292f@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12957-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 2FD54399AE8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 03, 2026 at 09:46:29AM -0600, Jens Axboe wrote:
> On 4/2/26 10:17 PM, Ming Lei wrote:
> > On Wed, Mar 25, 2026 at 08:09:03PM -0600, Jens Axboe wrote:
> >> On 3/24/26 10:37 AM, Ming Lei wrote:
> >>>  int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> >>>  {
> >>> +	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
> >>> +	u32 opf = READ_ONCE(sqe->bpf_op_flags);
> >>> +	unsigned char bpf_op = uring_bpf_get_op(opf);
> >>> +	const struct uring_bpf_ops *ops;
> >>> +
> >>> +	if (unlikely(!(req->ctx->flags & IORING_SETUP_BPF_EXT)))
> >>> +		goto fail;
> >>> +
> >>> +	if (bpf_op >= IO_RING_MAX_BPF_OPS)
> >>> +		return -EINVAL;
> >>> +
> >>> +	ops = req->ctx->bpf_ext_ops[bpf_op].ops;
> >>> +	data->opf = opf;
> >>> +	data->ops = ops;
> >>> +	if (ops && ops->prep_fn)
> >>> +		return ops->prep_fn(data, sqe);
> >>> +fail:
> >>>  	return -EOPNOTSUPP;
> >>>  }
> >>
> >> Any early exit should ensure 'data' is sane, so that the cleanup doesn't
> >> potentially touch uninitialized crap. This is something that has bit us
> >> in the past. Not an issue for this patch that adds the code, but it will
> >> be once the next patch is applied. Better to clear ->opf/ops here
> >> upfront, so that we never leave this function without 'data' being fully
> >> initialized.
> > 
> > But ->cleanup() is only called in case of REQ_F_NEED_CLEANUP.
> > 
> > Or maybe you mean other cleanup instead of ->cleanup()?
> 
> I do mean ->cleanup() - what I'm trying to say here is that we've had
> cases of REQ_F_NEED_CLEANUP being set late, and hence missing cleanup
> for easily hit error conditions, and non-initialized data being exposed
> in cleanup. It's very easy to miss for later patches that adds another
> error condition. My recommendation is to fully initialize 'data' and set
> REQ_F_NEED_CLEANUP early, which handily avoids that for future changes
> too.

OK, your recommendation is definitely clean & safe, will take it.


Thanks,
Ming


