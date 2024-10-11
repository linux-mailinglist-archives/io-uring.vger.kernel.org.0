Return-Path: <io-uring+bounces-3584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9030A999AE3
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 05:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4319B1F24AEF
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 03:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F301F131C;
	Fri, 11 Oct 2024 03:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwKBlK0f"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9721F4FA6
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 03:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728616069; cv=none; b=FhWVU4bXMrC2LVs11c8fngJiotwZggeg2iifqiB8LlCsQ1kD/xYBQNnauMy/fP5/aAcEBe5VYPmUbMx3U846u6kYWs4fmsC7rc0nDUudyWyeKMcQBNEOvRmHfmSu+MIYLe4asjI+lOirB+zQuHfkwER98UpzzHKFfJjldKC6hKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728616069; c=relaxed/simple;
	bh=s+GtP91lhzA7g8WlS9x2LscjG5YUrgKiKGvt2sRK/jI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aowAWFsuX6xZROxQqcEtttQ1lS0ckcnUMl2h+6yR5JYKZaLWTJeAkJYdNj8re1f8IOMrp36cOWzasveT8eqjG+dMsXM63DJzOwwLs4XRCLRnEqZvCU6Au8/p6Q0YiwnpG8Xe1J5jpeH3f9Ui270chN+P/o4LFQeMgBKBR+J+Aq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwKBlK0f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728616066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKlEsBgYydTnFBw7QLKS2Ck92rhIyjf/5Nd0VrU+MdU=;
	b=TwKBlK0fD/gSqmDUvQD5J6hZOqDbsFcJNvPF/k77LcpsNHj6PNFi7FP5TAZ5JU0LsXBsfg
	WJbrQ3y9QgvFaSzCcEBWtmR8/CVnjDMsBEiTZQHC6Xu+xORbU/zGZ0ZY0ZvaUhKog67BQG
	3KjD7rJiMNCSr0hGdksxVujm47hURc8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-zKqueMzgNPmzOBH1Adcb9Q-1; Thu,
 10 Oct 2024 23:07:43 -0400
X-MC-Unique: zKqueMzgNPmzOBH1Adcb9Q-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91E2419560B2;
	Fri, 11 Oct 2024 03:07:42 +0000 (UTC)
Received: from fedora (unknown [10.72.116.103])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 926F41956089;
	Fri, 11 Oct 2024 03:07:38 +0000 (UTC)
Date: Fri, 11 Oct 2024 11:07:32 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
Message-ID: <ZwiWdO6SS_jlkYrM@fedora>
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
 <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
 <ZwJObC6mzetw4goe@fedora>
 <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
 <ZwdJ7sDuHhWT61FR@fedora>
 <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
 <655b3348-27a1-4bc7-ade7-4d958a692d0b@kernel.dk>
 <ZwiN0Ioy2Y7cfnTI@fedora>
 <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Oct 10, 2024 at 08:39:12PM -0600, Jens Axboe wrote:
> On 10/10/24 8:30 PM, Ming Lei wrote:
> > Hi Jens,
> > 
> > On Thu, Oct 10, 2024 at 01:31:21PM -0600, Jens Axboe wrote:
> >> Hi,
> >>
> >> Discussed this with Pavel, and on his suggestion, I tried prototyping a
> >> "buffer update" opcode. Basically it works like
> >> IORING_REGISTER_BUFFERS_UPDATE in that it can update an existing buffer
> >> registration. But it works as an sqe rather than being a sync opcode.
> >>
> >> The idea here is that you could do that upfront, or as part of a chain,
> >> and have it be generically available, just like any other buffer that
> >> was registered upfront. You do need an empty table registered first,
> >> which can just be sparse. And since you can pick the slot it goes into,
> >> you can rely on that slot afterwards (either as a link, or just the
> >> following sqe).
> >>
> >> Quick'n dirty obviously, but I did write a quick test case too to verify
> >> that:
> >>
> >> 1) It actually works (it seems to)
> > 
> > It doesn't work for ublk zc since ublk needs to provide one kernel buffer
> > for fs rw & net send/recv to consume, and the kernel buffer is invisible
> > to userspace. But  __io_register_rsrc_update() only can register userspace
> > buffer.
> 
> I'd be surprised if this simple one was enough! In terms of user vs
> kernel buffer, you could certainly use the same mechanism, and just
> ensure that buffers are tagged appropriately. I need to think about that
> a little bit.

It is actually same with IORING_OP_PROVIDE_BUFFERS, so the following
consumer OPs have to wait until this OP_BUF_UPDATE is completed.

Suppose we have N consumers OPs which depends on OP_BUF_UPDATE.

1) all N OPs are linked with OP_BUF_UPDATE

Or

2) submit OP_BUF_UPDATE first, and wait its completion, then submit N
OPs concurrently.

But 1) and 2) may slow the IO handing.  In 1) all N OPs are serialized,
and 1 extra syscall is introduced in 2).

The same thing exists in the next OP_BUF_UPDATE which has to wait until
all the previous buffer consumers are done. So the same slow thing are
doubled. Not mention the application will become more complicated.

Here the provided buffer is only visible among the N OPs wide, and making
it global isn't necessary, and slow things down. And has kbuf lifetime
issue.

Also it makes error handling more complicated, io_uring has to remove
the kernel buffer when the current task is exit, dependency or order with
buffer provider is introduced.

There could be more problems, will try to remember all related stuff
thought before.

> 
> There are certainly many different ways that can get propagated which
> would not entail a complicated mechanism. I really like the aspect of
> having the identifier being the same thing that we already use, and
> hence not needing to be something new on the side.
> 
> > Also multiple OPs may consume the buffer concurrently, which can't be
> > supported by buffer select.
> 
> Why not? You can certainly have multiple ops using the same registered
> buffer concurrently right now.

Please see the above problem.

Also I remember that the selected buffer is removed from buffer list,
see io_provided_buffer_select(), but maybe I am wrong.


Thanks,
Ming


