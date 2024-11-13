Return-Path: <io-uring+bounces-4641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B61F9C6A66
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 09:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F6461F26B56
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 08:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30136189F2F;
	Wed, 13 Nov 2024 08:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pt5eRkan"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED228189BA3
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 08:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731485627; cv=none; b=Xe3cRghpjAfK/6LqAeQx8NWQ1jGZuf9H2iWl5UBCZNNav22IXQHytYNuXma3JSo+jfkwyK9ogIu6KU9dzmym268pHM/cOJAyxupLTQN5Dvw7seoV/rWnfF4ZMImVI1KtItZ2Nz+KbUbFLTG+sM+m38h9QEbROK7IKdS7bYaT6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731485627; c=relaxed/simple;
	bh=WZYcGCo77oOdbyTIxnBMVS8PnqyOx4CULu3NKdVr53A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SpF3S0veAEJF4PSsOEXywuRfMq0bOC2fPkXxb0h9SNwSBJcwsFQJgcByWO373UMzBMMQpZmtEO4GYqo9R8OnLEIxvbppqFsuo7DQaDQECABjOQOMqJc13X9R/mDIr6FRBs2tMmkC9ajMj4fZYOiA8XT2sDypgCyQh5rElU99P18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pt5eRkan; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731485623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jx8deyfeh2fJtp2XnqSorqsexjkrivPBbZoTtAHAICw=;
	b=Pt5eRkanmj/9BZYYquL7UrD2dBLprYKWUigB7pvzwhjws9ts1+cccJ7LeMMr7g0Myg6N2n
	O0TPFaCt3rDsj65pMxOMtst2NtPqO5lJZvyyyPi36Am2Nk6trLQ1/WnCbnUcgsibg8Onya
	x9vp7vVusqdhsqObrIJEiakKG55QD4I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-ThU26QKOPyqPTW0eaVw5sA-1; Wed,
 13 Nov 2024 03:13:42 -0500
X-MC-Unique: ThU26QKOPyqPTW0eaVw5sA-1
X-Mimecast-MFC-AGG-ID: ThU26QKOPyqPTW0eaVw5sA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B68E1955EE7;
	Wed, 13 Nov 2024 08:13:41 +0000 (UTC)
Received: from fedora (unknown [10.72.116.65])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EF3C195DF81;
	Wed, 13 Nov 2024 08:13:38 +0000 (UTC)
Date: Wed, 13 Nov 2024 16:13:33 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [RFC 0/3] Add BPF for io_uring
Message-ID: <ZzRfrbrAvmbcuOUi@fedora>
References: <cover.1731285516.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1731285516.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Nov 11, 2024 at 01:50:43AM +0000, Pavel Begunkov wrote:
> WARNING: it's an early prototype and could likely be broken and unsafe
> to run. Also, most probably it doesn't do the right thing from the
> modern BPF perspective, but that's fine as I want to get some numbers
> first and only then consult with BPF folks and brush it up.
> 
> A comeback of the io_uring BPF proposal put on top new infrastructure.
> Instead executing BPF as a new request type, it's now run in the io_uring
> waiting loop. The program is called to react every time we get a new
> event like a queued task_work or an interrupt. Patch 3 adds some helpers
> the BPF program can use to interact with io_uring like submitting new
> requests and looking at CQEs. It also controls when to return control
> back to user space by returning one of IOU_BPF_RET_{OK,STOP}, and sets
> the task_work batching size, i.e. how many CQEs to wait for it be run
> again, via a kfunc helper. We need to be able to sleep to submit
> requests, hence only sleepable BPF is allowed. 

I guess this way may break the existed interface of io_uring_enter(),
or at least one flag should be added to tell kernel that the wait behavior
will be overrided by bpf prog.

Also can you share how these perfect parameters may be calculated
by bpf prog? And why isn't io_uring kernel code capable of doing that?

> 
> BPF can help to create arbitrary relations between requests from
> within the kernel

Can you explain it in details about the `arbitrary relations`?

> and later help with tuning the wait loop batching.
> E.g. with minor extensions we can implement batch wait timeouts.
> We can also use it to let the user to safely access internal resources
> and maybe even do a more elaborate request setup than SQE allows it.
> 
> The benchmark is primitive, the non-BPF baseline issues a 2 nop request
> link at a time and waits for them to complete. The BPF version runs
> them (2 * N requests) one by one. Numbers with mitigations on:
> 
> # nice -n -20 taskset -c 0 ./minimal 0 50000000
> type 2-LINK, requests to run 50000000
> sec 10, total (ms) 10314
> # nice -n -20 taskset -c 0 ./minimal 1 50000000
> type BPF, requests to run 50000000
> sec 6, total (ms) 6808
> 
> It needs to be better tested, especially with asynchronous requests
> like reads and other hardware. It can also be further optimised. E.g.
> we can avoid extra locking by taking it once for BPF/task_work_run.
> 
> The test (see examples-bpf/minimal[.bpf].c)
> https://github.com/isilence/liburing.git io_uring-bpf
> https://github.com/isilence/liburing/tree/io_uring-bpf

Looks you pull bpftool & libbpf code into the example, and just
wondering why not link the example with libbpf directly?


Thanks, 
Ming


