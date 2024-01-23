Return-Path: <io-uring+bounces-455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1625A8391E9
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 16:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 773FDB2393E
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 15:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D20C5F853;
	Tue, 23 Jan 2024 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mrViBuAY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IOew1CzI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mrViBuAY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IOew1CzI"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6665D5FDBE
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706022073; cv=none; b=IAdE7MQMhVCIFA/3llQZA/CdPSHGE1X5qKtzXNJopXZKONkjVqspgiamk1Sd1AYYxV+add34nEutPsT812UAG6ZIJv1FJlTPdI+DaWi+Z1bou5YuAVRmRjcJEoYf0L4/i082PW6Kpb4P5i1YaxBdA6PgZQr/TpK9iD7QpcyoBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706022073; c=relaxed/simple;
	bh=SU6DlB3aa8HepZT7hroMBk34sx2CZREmmF63o0ORdHs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=acoOrWmJXbYC+1T03ZZlspTNOekcfz++ru90l1JDFQTQZKyjjRlVimIPlS+xi8nBPxBXVFMOZxNaCdce4uBJAK5ANRvLy8kTs38f8B8Sldn5/QHlvlfQEQfpYVIQv97h1GS5O8NQlRpQzNI+MoX9yNPG52Dr6Qj2a9QiUI6zT1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mrViBuAY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IOew1CzI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mrViBuAY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IOew1CzI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C70E33782;
	Tue, 23 Jan 2024 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706022069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wBaXDgnKR6CN4SHmYRY4TiVwT4KpBOvXIdS1ZFjwgp4=;
	b=mrViBuAYAr7f4Rpt2BG/KPErVrVXCd7sZi26UTHahV56wzj1+xXQ6Zcf6OAXfkwZLmCl94
	J1rczw6qNaKplX4ffDTNB41dsfyZEc5CgY3XLZTMdDbwMgIif0Po/Ws+Mf2hixM/jiiS8b
	geYvv5xkisiPO9zZMd1vOqIaAkhywK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706022069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wBaXDgnKR6CN4SHmYRY4TiVwT4KpBOvXIdS1ZFjwgp4=;
	b=IOew1CzIkzljTO5YYsDuZJ8gbpsHfGg5Mtc8W1Hsq+PR5ZT8brqrSF+N7vk2sQaQfAwQ4x
	ReImR+gwee8kEsAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706022069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wBaXDgnKR6CN4SHmYRY4TiVwT4KpBOvXIdS1ZFjwgp4=;
	b=mrViBuAYAr7f4Rpt2BG/KPErVrVXCd7sZi26UTHahV56wzj1+xXQ6Zcf6OAXfkwZLmCl94
	J1rczw6qNaKplX4ffDTNB41dsfyZEc5CgY3XLZTMdDbwMgIif0Po/Ws+Mf2hixM/jiiS8b
	geYvv5xkisiPO9zZMd1vOqIaAkhywK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706022069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wBaXDgnKR6CN4SHmYRY4TiVwT4KpBOvXIdS1ZFjwgp4=;
	b=IOew1CzIkzljTO5YYsDuZJ8gbpsHfGg5Mtc8W1Hsq+PR5ZT8brqrSF+N7vk2sQaQfAwQ4x
	ReImR+gwee8kEsAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11F8C13786;
	Tue, 23 Jan 2024 15:01:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qanBMrTUr2VmbQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 23 Jan 2024 15:01:08 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Tony Solomonik <tony.solomonik@gmail.com>
Cc: axboe@kernel.dk,  leitao@debian.org,  io-uring@vger.kernel.org,
  asml.silence@gmail.com
Subject: Re: [PATCH v2 2/2] io_uring: add support for ftruncate
In-Reply-To: <20240123113333.79503-2-tony.solomonik@gmail.com> (Tony
	Solomonik's message of "Tue, 23 Jan 2024 13:33:33 +0200")
Organization: SUSE
References: <CAD62OrGa9pS6-Qgg_UD4r4d+kCSPQihq0VvtVombrbAAOroG=w@mail.gmail.com>
	<20240123113333.79503-1-tony.solomonik@gmail.com>
	<20240123113333.79503-2-tony.solomonik@gmail.com>
Date: Tue, 23 Jan 2024 12:01:02 -0300
Message-ID: <87y1cgrt5d.fsf@mailhost.krisman.be>
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
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[5];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-0.998];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[kernel.dk,debian.org,vger.kernel.org,gmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

Tony Solomonik <tony.solomonik@gmail.com> writes:

> Libraries that are built on io_uring currently need to maintain a
> separate thread pool implementation when they want to truncate a file.
> ---
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/Makefile             |  2 +-
>  io_uring/opdef.c              |  9 +++++++
>  io_uring/truncate.c           | 47 +++++++++++++++++++++++++++++++++++
>  io_uring/truncate.h           |  4 +++
>  5 files changed, 62 insertions(+), 1 deletion(-)
>  create mode 100644 io_uring/truncate.c
>  create mode 100644 io_uring/truncate.h
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index f1c16f817742..be682e000c94 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -253,6 +253,7 @@ enum io_uring_op {
>  	IORING_OP_FUTEX_WAIT,
>  	IORING_OP_FUTEX_WAKE,
>  	IORING_OP_FUTEX_WAITV,
> +	IORING_OP_FTRUNCATE,
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
> index 799db44283c7..7830d087d03f 100644
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
> @@ -469,6 +470,11 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_FTRUNCATE] = {
> +		.needs_file		= 1,
> +		.prep			= io_ftruncate_prep,
> +		.issue			= io_ftruncate,
> +	},
>  };
>  
>  const struct io_cold_def io_cold_defs[] = {
> @@ -704,6 +710,9 @@ const struct io_cold_def io_cold_defs[] = {
>  	[IORING_OP_FUTEX_WAITV] = {
>  		.name			= "FUTEX_WAITV",
>  	},
> +	[IORING_OP_FTRUNCATE] = {
> +		.name			= "FTRUNCATE",
> +	},
>  };
>  
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/truncate.c b/io_uring/truncate.c
> new file mode 100644
> index 000000000000..9d160b91949c
> --- /dev/null
> +++ b/io_uring/truncate.c
> @@ -0,0 +1,47 @@
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
> +struct io_ftrunc {
> +	struct file			*file;

This is unused in the rest of the patch.

> +	loff_t				len;
> +};
> +
> +int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +
> +	if (sqe->addr || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
> +		return -EINVAL;
> +
> +	ft->len = READ_ONCE(sqe->off);
> +
> +	req->flags |= REQ_F_FORCE_ASYNC;
> +	return 0;
> +}
> +
> +int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
> +	int ret;
> +
> +	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> +
> +	ret = __do_ftruncate(req->file, ft->len, 1);
> +
> +	io_req_set_res(req, ret, 0);
> +	return IOU_OK;
> +}
> diff --git a/io_uring/truncate.h b/io_uring/truncate.h
> new file mode 100644
> index 000000000000..ec088293a478
> --- /dev/null
> +++ b/io_uring/truncate.h
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
> +int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags);

-- 
Gabriel Krisman Bertazi

