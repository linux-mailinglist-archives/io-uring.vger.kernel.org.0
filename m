Return-Path: <io-uring+bounces-447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9225383738C
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 21:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 156E01F24543
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477103FB26;
	Mon, 22 Jan 2024 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iDBJsChl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SP3GTUPJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iDBJsChl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SP3GTUPJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ED83DB86
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954368; cv=none; b=hSMvobR2Omus35wpnVgb3ovt9WiT/Dcj9y/EJHZh2yEuXOYeASo0gjpP52KmFIKtuAEHWUOlw6T/nd0p3SQ/zgZ//0GfYvSZyese4dqEmQVqNcpaupnIRLmwFp14pxhdfIpulrsmfYzowLMn00aX0uJqt3xLHxL9MTIUHue9OtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954368; c=relaxed/simple;
	bh=daCzJeEXJeGZPBRNiteRwWrOHejOtbpeTP7NRYev5YU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qcoFy2a0K2VaR53tdNqnMjdnjguXSUsH/x2SkNZeiz/VG1onOMhgGyZtQPFwCm8LME9iOgyA0NuE+SgazyUUD7Fx35ycRPdZjsBnDk2M5ZWDpVlq9/ihmEpCeCud1qTNMck+5JBYHgLRpME3QrvXyOg9KBCIZM22N85F9B6rLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iDBJsChl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SP3GTUPJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iDBJsChl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SP3GTUPJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9986721FEE;
	Mon, 22 Jan 2024 20:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705954364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7LfTm2bOuvb8eS9ZLw+xgQEhml/PtzIXizwVamTCPc=;
	b=iDBJsChlnIwaObKdzf1VVupUq7VsR7EalL/lsWYXI7H7dZ/ntaVsizWoKBNC236XljLnQE
	efnbrGng+BOw8KnKR+twmzHq4TYS0aGv5tTum/u/x+EkwionwvfERlEK5etuP/MSDpHRI7
	/mopURlkRZstQpszy0FHtWN76Z8b5rI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705954364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7LfTm2bOuvb8eS9ZLw+xgQEhml/PtzIXizwVamTCPc=;
	b=SP3GTUPJEmbmB7mEFZQdzS4wLu9tG3f4OE55IXFMOyC51wo37Gpn2iTmp//uobpx59nK3+
	uQo+TMfIsaP7dPCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705954364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7LfTm2bOuvb8eS9ZLw+xgQEhml/PtzIXizwVamTCPc=;
	b=iDBJsChlnIwaObKdzf1VVupUq7VsR7EalL/lsWYXI7H7dZ/ntaVsizWoKBNC236XljLnQE
	efnbrGng+BOw8KnKR+twmzHq4TYS0aGv5tTum/u/x+EkwionwvfERlEK5etuP/MSDpHRI7
	/mopURlkRZstQpszy0FHtWN76Z8b5rI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705954364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7LfTm2bOuvb8eS9ZLw+xgQEhml/PtzIXizwVamTCPc=;
	b=SP3GTUPJEmbmB7mEFZQdzS4wLu9tG3f4OE55IXFMOyC51wo37Gpn2iTmp//uobpx59nK3+
	uQo+TMfIsaP7dPCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F23F913995;
	Mon, 22 Jan 2024 20:12:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T8k5KTvMrmWUPQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 22 Jan 2024 20:12:43 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: axboe@kernel.dk,  asml.silence@gmail.com,  io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring: add support for truncate
In-Reply-To: <20240122193732.23217-1-tony.solomonik@gmail.com> (Tony
	Solomonik's message of "Mon, 22 Jan 2024 21:37:31 +0200")
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
Date: Mon, 22 Jan 2024 17:12:40 -0300
Message-ID: <875xzlw2iv.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

Tony Solomonik <tony.solomonik@gmail.com> writes:

> Libraries that are built on io_uring currently need to maintain a
> separate thread pool implementation when they want to truncate a file.

I don't think it makes sense to have both ftruncate and truncate in
io_uring.  One can just as easily link an open+ftruncate to have the
same semantics in one go.

> ---
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/Makefile             |  2 +-
>  io_uring/opdef.c              |  8 ++++++
>  io_uring/truncate.c           | 53 +++++++++++++++++++++++++++++++++++
>  io_uring/truncate.h           |  4 +++
>  5 files changed, 67 insertions(+), 1 deletion(-)
>  create mode 100644 io_uring/truncate.c
>  create mode 100644 io_uring/truncate.h
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index f1c16f817742..513f31ee8ce9 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -253,6 +253,7 @@ enum io_uring_op {
>  	IORING_OP_FUTEX_WAIT,
>  	IORING_OP_FUTEX_WAKE,
>  	IORING_OP_FUTEX_WAITV,
> +	IORING_OP_TRUNCATE,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> diff --git a/io_uring/Makefile b/io_uring/Makefile
> index e5be47e4fc3b..4f8ed6530a29 100644
> --- a/io_uring/Makefile
> +++ b/io_uring/Makefile
> @@ -8,6 +8,6 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o xattr.o nop.o fs.o splice.o \
>  					statx.o net.o msg_ring.o timeout.o \
>  					sqpoll.o fdinfo.o tctx.o poll.o \
>  					cancel.o kbuf.o rsrc.o rw.o opdef.o \
> -					notif.o waitid.o
> +					notif.o waitid.o truncate.o
>  obj-$(CONFIG_IO_WQ)		+= io-wq.o
>  obj-$(CONFIG_FUTEX)		+= futex.o
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 799db44283c7..60827099e244 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -35,6 +35,7 @@
>  #include "rw.h"
>  #include "waitid.h"
>  #include "futex.h"
> +#include "truncate.h"
>  
>  static int io_no_issue(struct io_kiocb *req, unsigned int issue_flags)
>  {
> @@ -469,6 +470,10 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_TRUNCATE] = {
> +		.prep			= io_truncate_prep,
> +		.issue			= io_truncate,
> +	},
>  };
>  
>  const struct io_cold_def io_cold_defs[] = {
> @@ -704,6 +709,9 @@ const struct io_cold_def io_cold_defs[] = {
>  	[IORING_OP_FUTEX_WAITV] = {
>  		.name			= "FUTEX_WAITV",
>  	},
> +	[IORING_OP_TRUNCATE] = {
> +		.name			= "TRUNCATE",
> +	},
>  };
>  
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/truncate.c b/io_uring/truncate.c
> new file mode 100644
> index 000000000000..82648b2fbc7e
> --- /dev/null
> +++ b/io_uring/truncate.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/syscalls.h>
> +#include <linux/io_uring.h>
> +
> +#include <uapi/linux/io_uring.h>
> +
> +#include "../fs/internal.h"
> +
> +#include "io_uring.h"
> +#include "truncate.h"
> +
> +struct io_trunc {
> +	struct files    *file;
> +	char __user     *pathname;
> +	loff_t				len;
> +};
> +
> +int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
> +
> +	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	tr->pathname = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	tr->len = READ_ONCE(sqe->len);
> +
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	req->flags |= REQ_F_FORCE_ASYNC;
> +	return 0;
> +}
> +
> +int io_truncate(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
> +	int ret;
> +
> +	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> +
> +	ret = do_sys_truncate(tr->pathname, tr->len);
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	io_req_set_res(req, ret, 0);
> +	return IOU_OK;
> +}
> diff --git a/io_uring/truncate.h b/io_uring/truncate.h
> new file mode 100644
> index 000000000000..ab17cb9acc90
> --- /dev/null
> +++ b/io_uring/truncate.h
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_truncate(struct io_kiocb *req, unsigned int issue_flags);

-- 
Gabriel Krisman Bertazi

