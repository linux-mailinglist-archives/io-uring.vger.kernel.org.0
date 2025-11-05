Return-Path: <io-uring+bounces-10382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 33412C368F7
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 17:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 69A174F6057
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 15:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECED9334C0A;
	Wed,  5 Nov 2025 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOMhKiwJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD5B33344E
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762358284; cv=none; b=VZJWQyUF323bybdBZQiW94i141L9D7VVF4HKEppfItAMt+fKSAT99sAjNs7I7Oz0CNasKp5O1oLL7AeJBW+WcEDNoVqNrW0z9E32U9/w+ikmPesrYcvhs7qc/LErXI0s8FAZ+M2zWMkLJMAvHhbOz30t1zO85fDuGIhrX1VEZI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762358284; c=relaxed/simple;
	bh=Id3U/QMgYsA7txZIIsqU3kVa+6SpJ3CR97XEhVc/l74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gl1AEu0RqquSYNQwDxM1deZ4jf6FbDsR2RqVVG15s8VouX4VRaBN4RKqRzDkMHor//fRoQP2j9T1mZPychlGjg4hYQaq/9+xN7ZddxiaUVRD3Tv8BpekVTEhn9lvo3tmvYiFA7EVHszxvBnZ2c01pl6vYJNjvzJGOuzoMmMpVtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOMhKiwJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762358281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lu8ps8Aict3vmkNspVvPaOoX1BVGPxhk2L02diSQBEE=;
	b=jOMhKiwJREuZJFNbvSUl6r/YLR/1Ca8El+IMlkfc74OhaicPwn3QMsS2Sqj2Z+tch7egKb
	tLdp+FsBjpgC1KuOte9kBIsMkyxWGCebMfBVpLKNb7FW9VkZeBwbtM3OWXBkyAfsIXB7od
	0nYDxb9RXMSrDIcg1rPHAkKKftIE4W0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343-R8eNirXANVeN_TZH54-hEw-1; Wed,
 05 Nov 2025 10:57:58 -0500
X-MC-Unique: R8eNirXANVeN_TZH54-hEw-1
X-Mimecast-MFC-AGG-ID: R8eNirXANVeN_TZH54-hEw_1762358277
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9B0C1954B00;
	Wed,  5 Nov 2025 15:57:56 +0000 (UTC)
Received: from fedora (unknown [10.72.120.36])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71C703000198;
	Wed,  5 Nov 2025 15:57:50 +0000 (UTC)
Date: Wed, 5 Nov 2025 23:57:45 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
Message-ID: <aQtz-dw7t7jtqALc@fedora>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Nov 05, 2025 at 12:47:58PM +0000, Pavel Begunkov wrote:
> On 11/4/25 16:21, Ming Lei wrote:
> > Hello,
> > 
> > Add IORING_OP_BPF for extending io_uring operations, follows typical cases:
> 
> BPF requests were tried long time ago and it wasn't great. Performance

Care to share the link so I can learn from the lesson? Maybe things have
changed now...

> for short BPF programs is not great because of io_uring request handling
> overhead. And flexibility was severely lacking, so even simple use cases

What is the overhead? In this patch, OP's prep() and issue() are defined in
bpf prog, but in typical use case, the code size is pretty small, and bpf
prog code is supposed to run in fast path.

> were looking pretty ugly, internally, and for BPF writers as well.

I am not sure what `simple use cases` you are talking about.

> 
> I'm not so sure about your criteria, but my requirement was to at least
> being able to reuse all io_uring IO handling, i.e. submitting requests,
> and to wait/process completions, otherwise a lot of opportunities are
> wasted. My approach from a few months back [1] controlling requests from

Please read the patchset.

This patchset defines new IORING_BPF_OP code, which's ->prep(), ->issue(), ...,
are hooked with struct_ops prog, so all io_uring core code is used, just the
exact IORING_BPF_OP behavior is defined by struct_ops prog.

> the outside was looking much better. At least it covered a bunch of needs
> without extra changes. I was just wiring up io_uring changes I wanted
> to make BPF writer lifes easier. Let me resend the bpf series with it.
> 
> It makes me wonder if they are complementary, but I'm not sure what

I think the two are orthogonal in function, and they can co-exist.

> your use cases are and what capabilities it might need.

The main use cases are described in cover letter and the 3rd patch, please
find the details there.

So far the main case is to access the registered (kernel)buffer
from issue() callback of struct_ops, because the buffer doesn't have
userspace mapping. The last two patches adds support to provide two
buffers(fixed, plain) for IORING_BPF_OP, and in future vectored buffer
will be added too, so IORING_BPF_OP can handle buffer flexibly, such as:

- use exported compress kfunc to compress data from kernel buffer
into another buffer or inplace, then the following linked SQE can be submitted
to write the built compressed data into storage

- in raid use case, calculate IO data parity from kernel buffer, and store
the parity data to another plain user buffer, then the following linked SQE
can be submitted to write the built parity data to storage

Even for userspace buffer, the BPF_OP can support similar handling for saving
one extra io_uring_enter() syscall.

> 
> [1] https://lore.kernel.org/io-uring/cover.1749214572.git.asml.silence@gmail.com/

I looked at your patches, in which SQE is generated in bpf prog(kernel),
and it can't be used in my case.


Thanks,
Ming


