Return-Path: <io-uring+bounces-9313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA384B3893E
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 20:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7653C17B79A
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 18:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1575C21FF55;
	Wed, 27 Aug 2025 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VjUx8993";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qim9gR13";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KCX/1yhO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+5JGnYIP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2A513E41A
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756317877; cv=none; b=HvwHH5IMODghc+oj4v3FVN+YVihaeRRjL+vVnKjjVWfVhfvzcFOUNe1Zmy8dAlw2MtfNJs9oq5BRNbFr/ozTfjwivQzWBAJpSIijQmaZUf+neZpX84FPJOur8a43jAp6lpsoVrTXkrYgJNdt80QCveYIMivCGYUnDLgfZomU6gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756317877; c=relaxed/simple;
	bh=/6G1YNXYzX7A9X1KB3dNHN5UpfyUEmuTM/tZ7+JpiTc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LFwL+czy5Ud/0A4Q2A22un65VkFLXZrvsgQxrlMia8QhafziQrL4xrLZohatoFiblCbfqpU2O7SFCpVtTdvOV5zjOfFHn0d0S1QAZ0arAbeH8B5lsyh8Eb9FfE/oULO1isWtiV8nfBn4X4+hjbAfL85QilfH47qsvorUgObXSsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VjUx8993; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qim9gR13; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KCX/1yhO; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+5JGnYIP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B95E204C5;
	Wed, 27 Aug 2025 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756317872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+SYbNJf6s9rYK9FcduDLjw7jCjh9ZM8y2nFVZyjVSDg=;
	b=VjUx8993coFdBQfvFMp/RPsp0HiW4SD/N0g+xalygqGBA3KMl3G9gLsoL7Ho0pm+di/NMN
	6yNeCieJl4IzF5mRA33VuhOYp3xD0cW8Ha+dGk8T5GwEVkWkg2tFdM77z+RRfT7LJfqfJg
	uUODxdvkpjpZgbDIOY73yq3LkuZOuxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756317872;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+SYbNJf6s9rYK9FcduDLjw7jCjh9ZM8y2nFVZyjVSDg=;
	b=Qim9gR133s3HZuN5rOo2TUEURFh2dXATkAOhYBM6TnJle6WKi3gMq70f2Ik+uf4cxxfqi1
	sjmKI1d0CKqy/7DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="KCX/1yhO";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+5JGnYIP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756317871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+SYbNJf6s9rYK9FcduDLjw7jCjh9ZM8y2nFVZyjVSDg=;
	b=KCX/1yhOy7K9BMeHF9mdxaHS5Cr0AqEQjKGV8GlKxIHtg0GdxW8xjkNMaf8QsVSEVNUmnu
	5zdNnRykdggAq/c26+MzpFu2SOY/QCVdLsUpy0w5XOOcXUU7Y5r+P/cax5xnL6d6uZIo+R
	Yw2Jx0dZW0gWofS9HGW3QPyIhU4sDBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756317871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+SYbNJf6s9rYK9FcduDLjw7jCjh9ZM8y2nFVZyjVSDg=;
	b=+5JGnYIPEJIDUXCaGBYMecFbWS2QlRdVToqvyLRGTaW1dg3lOuzEDUMTXiyIM6TTPZ7O7G
	gUSKYBzjjRnw5uCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B43C13867;
	Wed, 27 Aug 2025 18:04:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1D0lOq5Ir2j9PgAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 27 Aug 2025 18:04:30 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [RFC v1 3/3] io_uring: introduce io_uring querying
In-Reply-To: <6adf4bd06950d999f127595fe4d24d048ce03f5f.1756300192.git.asml.silence@gmail.com>
	(Pavel Begunkov's message of "Wed, 27 Aug 2025 14:21:14 +0100")
References: <cover.1756300192.git.asml.silence@gmail.com>
	<6adf4bd06950d999f127595fe4d24d048ce03f5f.1756300192.git.asml.silence@gmail.com>
Date: Wed, 27 Aug 2025 14:04:29 -0400
Message-ID: <87sehc1w0i.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 6B95E204C5
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

Pavel Begunkov <asml.silence@gmail.com> writes:

> There are many characteristics of a ring or the io_uring subsystem the
> user wants to query. Sometimes it's needed to be done before there is a
> created ring, and sometimes it's needed at runtime in a slow path.
> Introduce a querying interface to achieve that.
>
> It was written with several requirements in mind:
> - Can be used with or without an io_uring instance.
> - Can query multiple attributes in one syscall.
> - Backward and forward compatible.
> - Should be reasobably easy to use.
> - Reduce the kernel code size for introducing new query types.

Hello, Pavel.

Correct me if I'm wrong, or if I completely missed the point, but this
is mostly about returning static information about what the kernel
supports, which can all be calculated at compile-time.

It seems it should be laid out as a procfs/sysfs /sys/kernel/io_uring
subtree instead, making it quickly parseable with the usual coreutils
command line tools, and then abstracted by some liburing APIs.  I don't
see the advantage of creating a custom way for fetching kernel features
information that only works for io_uring.

Sure, parsing sysfs is slow, but it doesn't need to be fast.  It is
annoying, but it can be abstracted in userspace by liburing.  It is more
consistent with the rest of the kernel and, for me, when tracking
customer issues, I can trust the newly introduce files will show up in
their supportconfig/sosreport without any extra change to these
applications.

Then there is the part about probing a specific ring for something, and
we have fdinfo. What information do we want to probe of a
particular ring that is missing?  Perhaps this feature should be split from the
general "is this feature supported" part.

Thanks!

> API: it's implemented as a new registration op IORING_REGISTER_QUERY.
> The user passes one or more query strutctures, each represented by
> struct io_uring_query_hdr. The header stores common control fields for
> query processing and expected to be wrapped into a larger structure
> that has opcode specific fields.
>
> The header contains
> - The query opcode
> - The result field, which on return contains the error code for the query
> - The size of the query structure. The kernel will only populate up to
>   the size, which helps with backward compatibility. The kernel can also
>   reduce the size, so if the current kernel is older than the inteface
>   the user tries to use, it'll get only the supported bits.
> - next_entry field is used to chain multiple queries.
>
> The patch adds a single query type for now, i.e. IO_URING_QUERY_OPCODES,
> which tells what register / request / etc. opcodes are supported, but
> there are particular plans to extend it.


>
> Note: there is a request probing interface via IORING_REGISTER_PROBE,
> but it's a mess. It requires the user to create a ring first, it only
> works for requests, and requires dynamic allocations.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/uapi/linux/io_uring.h       |  3 ++
>  include/uapi/linux/io_uring/query.h | 40 ++++++++++++++
>  io_uring/Makefile                   |  2 +-
>  io_uring/query.c                    | 84 +++++++++++++++++++++++++++++
>  io_uring/query.h                    |  9 ++++
>  io_uring/register.c                 |  6 +++
>  6 files changed, 143 insertions(+), 1 deletion(-)
>  create mode 100644 include/uapi/linux/io_uring/query.h
>  create mode 100644 io_uring/query.c
>  create mode 100644 io_uring/query.h
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 6957dc539d83..7a06da49e2cd 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -665,6 +665,9 @@ enum io_uring_register_op {
>  
>  	IORING_REGISTER_MEM_REGION		= 34,
>  
> +	/* query various aspects of io_uring, see linux/io_uring/query.h */
> +	IORING_REGISTER_QUERY			= 35,
> +
>  	/* this goes last */
>  	IORING_REGISTER_LAST,
>  
> diff --git a/include/uapi/linux/io_uring/query.h b/include/uapi/linux/io_uring/query.h
> new file mode 100644
> index 000000000000..ca58e88095ed
> --- /dev/null
> +++ b/include/uapi/linux/io_uring/query.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
> +/*
> + * Header file for the io_uring query interface.
> + *
> + * Copyright (C) 2025 Pavel Begunkov
> + */
> +#ifndef LINUX_IO_URING_QUERY_H
> +#define LINUX_IO_URING_QUERY_H
> +
> +#include <linux/types.h>
> +
> +struct io_uring_query_hdr {
> +	__u64 next_entry;
> +	__u32 query_op;
> +	__u32 size;
> +	__s32 result;
> +	__u32 __resv[3];
> +};
> +
> +enum {
> +	IO_URING_QUERY_OPCODES			= 0,
> +
> +	__IO_URING_QUERY_MAX,
> +};
> +
> +/* Doesn't require a ring */
> +struct io_uring_query_opcode {
> +	struct io_uring_query_hdr hdr;
> +
> +	/* The number of supported IORING_OP_* opcodes */
> +	__u32	nr_request_opcodes;
> +	/* The number of supported IORING_[UN]REGISTER_* opcodes */
> +	__u32	nr_register_opcodes;
> +	/* Bitmask of all supported IORING_FEAT_* flags */
> +	__u64	features;
> +	/* Bitmask of all supported IORING_SETUP_* flags */
> +	__u64	ring_flags;
> +};
> +
> +#endif
> diff --git a/io_uring/Makefile b/io_uring/Makefile
> index b3f1bd492804..bc4e4a3fa0a5 100644
> --- a/io_uring/Makefile
> +++ b/io_uring/Makefile
> @@ -13,7 +13,7 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
>  					sync.o msg_ring.o advise.o openclose.o \
>  					statx.o timeout.o cancel.o \
>  					waitid.o register.o truncate.o \
> -					memmap.o alloc_cache.o
> +					memmap.o alloc_cache.o query.o
>  obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
>  obj-$(CONFIG_IO_WQ)		+= io-wq.o
>  obj-$(CONFIG_FUTEX)		+= futex.o
> diff --git a/io_uring/query.c b/io_uring/query.c
> new file mode 100644
> index 000000000000..0ae9192f5a57
> --- /dev/null
> +++ b/io_uring/query.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "linux/io_uring/query.h"
> +
> +#include "query.h"
> +#include "io_uring.h"
> +
> +#define IO_MAX_QUERY_SIZE		512
> +
> +static int io_query_ops(void *buffer)
> +{
> +	struct io_uring_query_opcode *e = buffer;
> +
> +	BUILD_BUG_ON(sizeof(struct io_uring_query_opcode) > IO_MAX_QUERY_SIZE);
> +
> +	e->hdr.size = min(e->hdr.size, sizeof(*e));
> +	e->nr_request_opcodes = IORING_OP_LAST;
> +	e->nr_register_opcodes = IORING_REGISTER_LAST;
> +	e->features = IORING_FEATURES;
> +	e->ring_flags = IORING_VALID_SETUP_FLAGS;
> +	return 0;
> +}
> +
> +static int io_handle_query_entry(struct io_ring_ctx *ctx,
> +				 void *buffer,
> +				 void __user *uentry, u64 *next_entry)
> +{
> +	struct io_uring_query_hdr *hdr = buffer;
> +	size_t entry_size = sizeof(*hdr);
> +	int ret = -EINVAL;
> +
> +	if (copy_from_user(hdr, uentry, sizeof(*hdr)) ||
> +	    hdr->size <= sizeof(*hdr))
> +		return -EFAULT;
> +
> +	if (hdr->query_op >= __IO_URING_QUERY_MAX) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +	if (!mem_is_zero(hdr->__resv, sizeof(hdr->__resv)) || hdr->result)
> +		goto out;
> +
> +	hdr->size = min(hdr->size, IO_MAX_QUERY_SIZE);
> +	if (copy_from_user(buffer + sizeof(*hdr), uentry + sizeof(*hdr),
> +			   hdr->size - sizeof(*hdr)))
> +		return -EFAULT;
> +
> +	switch (hdr->query_op) {
> +	case IO_URING_QUERY_OPCODES:
> +		ret = io_query_ops(buffer);
> +		break;
> +	}
> +	if (!ret)
> +		entry_size = hdr->size;
> +out:
> +	hdr->result = ret;
> +	hdr->size = entry_size;
> +	if (copy_to_user(uentry, buffer, entry_size))
> +		return -EFAULT;
> +	*next_entry = hdr->next_entry;
> +	return 0;
> +}
> +
> +int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
> +{
> +	char entry_buffer[IO_MAX_QUERY_SIZE];
> +	void __user *uentry = arg;
> +	int ret;
> +
> +	memset(entry_buffer, 0, sizeof(entry_buffer));
> +
> +	if (nr_args)
> +		return -EINVAL;
> +
> +	while (uentry) {
> +		u64 next;
> +
> +		ret = io_handle_query_entry(ctx, entry_buffer, uentry, &next);
> +		if (ret)
> +			return ret;
> +		uentry = u64_to_user_ptr(next);
> +	}
> +	return 0;
> +}
> diff --git a/io_uring/query.h b/io_uring/query.h
> new file mode 100644
> index 000000000000..171d47ccaaba
> --- /dev/null
> +++ b/io_uring/query.h
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef IORING_QUERY_H
> +#define IORING_QUERY_H
> +
> +#include <linux/io_uring_types.h>
> +
> +int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args);
> +
> +#endif
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 046dcb7ba4d1..6777bfe616ea 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -31,6 +31,7 @@
>  #include "msg_ring.h"
>  #include "memmap.h"
>  #include "zcrx.h"
> +#include "query.h"
>  
>  #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
>  				 IORING_REGISTER_LAST + IORING_OP_LAST)
> @@ -835,6 +836,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_register_mem_region(ctx, arg);
>  		break;
> +	case IORING_REGISTER_QUERY:
> +		ret = io_query(ctx, arg, nr_args);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -904,6 +908,8 @@ static int io_uring_register_blind(unsigned int opcode, void __user *arg,
>  	switch (opcode) {
>  	case IORING_REGISTER_SEND_MSG_RING:
>  		return io_uring_register_send_msg_ring(arg, nr_args);
> +	case IORING_REGISTER_QUERY:
> +		return io_query(NULL, arg, nr_args);
>  	}
>  	return -EINVAL;
>  }

-- 
Gabriel Krisman Bertazi

