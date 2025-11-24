Return-Path: <io-uring+bounces-10773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E51FFC8106B
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 15:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 844DC4E4A3C
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DB130F7F9;
	Mon, 24 Nov 2025 14:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IS04L1E0"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA190310629
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763994581; cv=none; b=jUDG2zSisKlX7jXPKuexgSrsfmduB7a44y9WtFP759BaZY2+HPqERxZeFGTwYCsjnmlRe6spJZF92CWmeZPm0Pqa3pMZyq+1D+4lIM4IgQFiVT5LXaJHqXGlEul4kG+RySn8RdOPN71FoHtJen5+ntlK3LZnXDt0PkoqBshfmKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763994581; c=relaxed/simple;
	bh=CgSFqrPbz08k1thWLWXKyhIGCzKzZX1J1oAirp9GeXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+8jCJAwxyEIUojm7y+vYhpARtDxJ7bXVkUsZ7WLxRZPUhKK2IJatpze8kQsIJA3DgtSfm/d2Yug7V/S1tbrEXKyG5SO2ZCqIhtN8lVnmf7wevimlzF4B5NmS326dB7gDFg47FP/B7PczY/RPZp48WH1r37cAjCkDoa6/Yu6+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IS04L1E0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763994578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGe9O4MqeZykFbpjI207t8+Q01ugWhy/meLVbmLRRMg=;
	b=IS04L1E09QSXIdSUrLoAwdCCY4ncuOqLKaNZ0T87RgfZLiev5vMp3/8pBmacUeYvAkZLi0
	yh61ikc2E7sdcZzmWfBELWwkEVZHq1gNyOQuQNmzM2OqaAxZZ7709WUy/tiy5D2s8jUa+S
	IEs4kV+qW66ulXfZLbZlilwjRdksoCo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-2x7AMg27M7GC2VcCrVqT6A-1; Mon,
 24 Nov 2025 09:29:34 -0500
X-MC-Unique: 2x7AMg27M7GC2VcCrVqT6A-1
X-Mimecast-MFC-AGG-ID: 2x7AMg27M7GC2VcCrVqT6A_1763994573
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D133E19541B9;
	Mon, 24 Nov 2025 14:29:32 +0000 (UTC)
Received: from fedora (unknown [10.72.116.210])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06FD218008CC;
	Mon, 24 Nov 2025 14:29:24 +0000 (UTC)
Date: Mon, 24 Nov 2025 22:29:14 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH v3 07/10] io_uring/bpf: implement struct_ops registration
Message-ID: <aSRrundGeeIpaKmd@fedora>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <cce6ee02362fe62aefab81de6ec0d26f43c6c22d.1763031077.git.asml.silence@gmail.com>
 <aSPUtMqilzaPui4f@fedora>
 <015ee1ee-e0a4-491f-833f-9cef8c5349cc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <015ee1ee-e0a4-491f-833f-9cef8c5349cc@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Nov 24, 2025 at 01:12:29PM +0000, Pavel Begunkov wrote:
> On 11/24/25 03:44, Ming Lei wrote:
> > On Thu, Nov 13, 2025 at 11:59:44AM +0000, Pavel Begunkov wrote:
> > > Add ring_fd to the struct_ops and implement [un]registration.
> ...
> > > +static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
> > > +{
> > > +	if (ctx->bpf_ops)
> > > +		return -EBUSY;
> > > +	ops->priv = ctx;
> > > +	ctx->bpf_ops = ops;
> > > +	ctx->bpf_installed = 1;
> > >   	return 0;
> > >   }
> > >   static int bpf_io_reg(void *kdata, struct bpf_link *link)
> > >   {
> > > -	return -EOPNOTSUPP;
> > > +	struct io_uring_ops *ops = kdata;
> > > +	struct io_ring_ctx *ctx;
> > > +	struct file *file;
> > > +	int ret = -EBUSY;
> > > +
> > > +	file = io_uring_register_get_file(ops->ring_fd, false);
> > > +	if (IS_ERR(file))
> > > +		return PTR_ERR(file);
> > > +	ctx = file->private_data;
> > > +
> > > +	scoped_guard(mutex, &io_bpf_ctrl_mutex) {
> > > +		guard(mutex)(&ctx->uring_lock);
> > > +		ret = io_install_bpf(ctx, ops);
> > > +	}
> > 
> > I feel per-io-uring struct_ops is less useful, because it means the io_uring
> > application has to be capable of loading/registering struct_ops prog, which
> > often needs privilege.
> 
> I gave it a thought before, there would need to be a way to pass a
> program from one (e.g. privileged) task to another, e.g. by putting
> it into a list on attachment from where it can be imported. That
> can be extended, and I needed to start somewhere.

If any task can ask such privileged task to load bpf program for itself,
BPF_UNPRIV_DEFAULT_OFF becomes `N` actually for bpf controlled io_uring.

> 
> > For example of IO link use case you mentioned, why does the application need
> > to get privilege for running IO link?
> 
> Links are there to compare with existing features. It's more interesting
> to allow arbitrary relations / result propagation between requests. Maybe
> some common patterns can be generalised, but otherwise nothing can be
> done with this without custom tailored bpf programs.

I know the motivation, which is one thing covered in my IORING_OP_BPF patch
too.


Thanks,
Ming


