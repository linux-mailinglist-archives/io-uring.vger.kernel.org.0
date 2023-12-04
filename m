Return-Path: <io-uring+bounces-217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CFAD803D56
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17EB3281165
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 18:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693432F86D;
	Mon,  4 Dec 2023 18:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WrFPJTWu"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0C7113
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 10:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701715266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RJWDbiPu4qvL/JC0PNIHJ3Asj8egnHDhDvdQ4O4EMiE=;
	b=WrFPJTWuSTCQbez7h0/kkrOLX5axB04M6lCb8BkMQ9mqkDvADRh5tNt6UJHdCe3s5R4kDC
	fUiTumhq6atVWptvSZoKIqVgBvssQDBjY0n3xOnjU9t3h86PxrTBgSpsrx6eXYyFIMPayd
	Mexai5D+Y5Vow4DREEjGWERNWGVc7SE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-CG4HhxtwPnq28LHp2Gv-Ew-1; Mon, 04 Dec 2023 13:41:00 -0500
X-MC-Unique: CG4HhxtwPnq28LHp2Gv-Ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8931C85A59D;
	Mon,  4 Dec 2023 18:40:59 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.39])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12E2A2026D4C;
	Mon,  4 Dec 2023 18:40:59 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: <linux-nvme@lists.infradead.org>,  <io-uring@vger.kernel.org>,
  <axboe@kernel.dk>,  <hch@lst.de>,  <sagi@grimberg.me>,
  <asml.silence@gmail.com>,  Keith Busch <kbusch@kernel.org>,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
References: <20231204175342.3418422-1-kbusch@meta.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 04 Dec 2023 13:40:58 -0500
In-Reply-To: <20231204175342.3418422-1-kbusch@meta.com> (Keith Busch's message
	of "Mon, 4 Dec 2023 09:53:41 -0800")
Message-ID: <x49zfypstdx.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

I added a CC: linux-security-module@vger

Hi, Keith,

Keith Busch <kbusch@meta.com> writes:

> From: Keith Busch <kbusch@kernel.org>
>
> The uring_cmd operation is often used for privileged actions, so drivers
> subscribing to this interface check capable() for each command. The
> capable() function is not fast path friendly for many kernel configs,
> and this can really harm performance. Stash the capable sys admin
> attribute in the io_uring context and set a new issue_flag for the
> uring_cmd interface.

I have a few questions.  What privileged actions are performance
sensitive?  I would hope that anything requiring privileges would not be
in a fast path (but clearly that's not the case).  What performance
benefits did you measure with this patch set in place (and on what
workloads)?  What happens when a ring fd is passed to another process?

Finally, as Jens mentioned, I would expect dropping priviliges to, you
know, drop privileges.  I don't think a commit message is going to be
enough documentation for a change like this.

Cheers,
Jeff

>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring_types.h | 4 ++++
>  io_uring/io_uring.c            | 1 +
>  io_uring/uring_cmd.c           | 2 ++
>  3 files changed, 7 insertions(+)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index bebab36abce89..d64d6916753f0 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -36,6 +36,9 @@ enum io_uring_cmd_flags {
>  	/* set when uring wants to cancel a previously issued command */
>  	IO_URING_F_CANCEL		= (1 << 11),
>  	IO_URING_F_COMPAT		= (1 << 12),
> +
> +	/* ring validated as CAP_SYS_ADMIN capable */
> +	IO_URING_F_SYS_ADMIN		= (1 << 13),
>  };
>  
>  struct io_wq_work_node {
> @@ -240,6 +243,7 @@ struct io_ring_ctx {
>  		unsigned int		poll_activated: 1;
>  		unsigned int		drain_disabled: 1;
>  		unsigned int		compat: 1;
> +		unsigned int		sys_admin: 1;
>  
>  		struct task_struct	*submitter_task;
>  		struct io_rings		*rings;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1d254f2c997de..4aa10b64f539e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3980,6 +3980,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>  		ctx->syscall_iopoll = 1;
>  
>  	ctx->compat = in_compat_syscall();
> +	ctx->sys_admin = capable(CAP_SYS_ADMIN);
>  	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
>  		ctx->user = get_uid(current_user());
>  
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8a38b9f75d841..764f0e004aa00 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -164,6 +164,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  		issue_flags |= IO_URING_F_CQE32;
>  	if (ctx->compat)
>  		issue_flags |= IO_URING_F_COMPAT;
> +	if (ctx->sys_admin)
> +		issue_flags |= IO_URING_F_SYS_ADMIN;
>  	if (ctx->flags & IORING_SETUP_IOPOLL) {
>  		if (!file->f_op->uring_cmd_iopoll)
>  			return -EOPNOTSUPP;


