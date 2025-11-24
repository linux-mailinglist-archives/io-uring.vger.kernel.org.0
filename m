Return-Path: <io-uring+bounces-10749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E088C7EE89
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 04:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D41E4345700
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 03:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D4C2116F4;
	Mon, 24 Nov 2025 03:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MaKyrvnJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C368A2749D9
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 03:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763955913; cv=none; b=YWspAwA2ooxBPrPvJYD1twhg+XB/SzxJjgWiTErVYQiuQllWYJaEBnC3FEQh8uthaDGug6XACOIH+4/ZFlOmahcYXiqTPwQmtVWZKiAHqOHA2xegqQdDseit436fe7iKz/KBks2zGsH2LDzF8Xib4txLiTyMPY/w+vMBskIHngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763955913; c=relaxed/simple;
	bh=1o2HlCkp8Gxx6+sHlXsZujpNQF2rQ6yiE44lkUGHba8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6pT3hdggCjQZeNCkE6Dej4TvG38aBASocIIaGCTwWUPv/ii76aq1XkOIH5brQZsFYa4FujPhWvrZXvnrUi5OBb0OzLRfAp1DWDtuv/SYiawcKV2px2WBZKCtUeq6zNTGvU1NhVxRVzCia+qw9UHwKGzAcrHeawK32/uO2y3eYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MaKyrvnJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763955909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ARcJqa+jKTzy4aJDqYL7yDQMnB/xocT9vkDV5GOIjg=;
	b=MaKyrvnJAWVP98qAbCvTSflMy4YdaXvViVHCbQQIi8In0OAfBBH0xi7QO1jZp3KDdvVOBj
	91L+Zdcb/YgM+Dsf6c9FAlA3QrYvqVIYL4ral7TI3fXAFyJSJ8LK4T0GMzRhELf2GlM2rU
	woqOjTEyqhbaMCtnKA1Xu83j1KOZybA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-vr3TWLC-N0aIw2m6Ok1Rog-1; Sun,
 23 Nov 2025 22:45:05 -0500
X-MC-Unique: vr3TWLC-N0aIw2m6Ok1Rog-1
X-Mimecast-MFC-AGG-ID: vr3TWLC-N0aIw2m6Ok1Rog_1763955904
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B0B31956088;
	Mon, 24 Nov 2025 03:45:02 +0000 (UTC)
Received: from fedora (unknown [10.72.116.227])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76AE61956056;
	Mon, 24 Nov 2025 03:44:57 +0000 (UTC)
Date: Mon, 24 Nov 2025 11:44:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH v3 07/10] io_uring/bpf: implement struct_ops registration
Message-ID: <aSPUtMqilzaPui4f@fedora>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <cce6ee02362fe62aefab81de6ec0d26f43c6c22d.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce6ee02362fe62aefab81de6ec0d26f43c6c22d.1763031077.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Nov 13, 2025 at 11:59:44AM +0000, Pavel Begunkov wrote:
> Add ring_fd to the struct_ops and implement [un]registration.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  2 +
>  io_uring/bpf.c                 | 69 +++++++++++++++++++++++++++++++++-
>  2 files changed, 70 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 43432a06d177..3a71ed2d05ea 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -274,6 +274,8 @@ struct io_ring_ctx {
>  		unsigned int		compat: 1;
>  		unsigned int		iowq_limits_set : 1;
>  
> +		unsigned int		bpf_installed: 1;
> +
>  		struct task_struct	*submitter_task;
>  		struct io_rings		*rings;
>  		struct percpu_ref	refs;
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index 24dd2fe9134f..683e87f1a58b 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -4,6 +4,7 @@
>  #include "bpf.h"
>  #include "register.h"
>  
> +static DEFINE_MUTEX(io_bpf_ctrl_mutex);
>  static const struct btf_type *loop_state_type;
>  
>  static int io_bpf_ops__loop(struct io_ring_ctx *ctx, struct iou_loop_state *ls)
> @@ -87,20 +88,86 @@ static int bpf_io_init_member(const struct btf_type *t,
>  			       const struct btf_member *member,
>  			       void *kdata, const void *udata)
>  {
> +	u32 moff = __btf_member_bit_offset(t, member) / 8;
> +	const struct io_uring_ops *uops = udata;
> +	struct io_uring_ops *ops = kdata;
> +
> +	switch (moff) {
> +	case offsetof(struct io_uring_ops, ring_fd):
> +		ops->ring_fd = uops->ring_fd;
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
> +{
> +	if (ctx->bpf_ops)
> +		return -EBUSY;
> +	ops->priv = ctx;
> +	ctx->bpf_ops = ops;
> +	ctx->bpf_installed = 1;
>  	return 0;
>  }
>  
>  static int bpf_io_reg(void *kdata, struct bpf_link *link)
>  {
> -	return -EOPNOTSUPP;
> +	struct io_uring_ops *ops = kdata;
> +	struct io_ring_ctx *ctx;
> +	struct file *file;
> +	int ret = -EBUSY;
> +
> +	file = io_uring_register_get_file(ops->ring_fd, false);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +	ctx = file->private_data;
> +
> +	scoped_guard(mutex, &io_bpf_ctrl_mutex) {
> +		guard(mutex)(&ctx->uring_lock);
> +		ret = io_install_bpf(ctx, ops);
> +	}

I feel per-io-uring struct_ops is less useful, because it means the io_uring
application has to be capable of loading/registering struct_ops prog, which
often needs privilege.

For example of IO link use case you mentioned, why does the application need
to get privilege for running IO link?


Thanks
Ming


