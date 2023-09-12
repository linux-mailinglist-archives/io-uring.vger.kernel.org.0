Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B799579C1FC
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 03:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbjILBvD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 21:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjILBus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 21:50:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6243713BEB1
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 18:24:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5E9411F8CD;
        Tue, 12 Sep 2023 00:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694479120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EMX1VDN24+OxgIDl2Am7O0dVKjNUIrcW4xMYrciJbNQ=;
        b=qi4XJmxQ3txF+iYZnJrLgzyYH7+y/kTWxuK64j/F/W7Uum1QR0MxrXJ18Rxv406bt+0Iut
        mgo60I5KlDRJtwmNZ0PUSYlFyRKwvlcuFZH4SupZq8HYc+7WUvx2qQttr0SqFoXpO7Z/KE
        XsSJc+I8E312UWpXktxG4NxRnQ7N4pg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694479120;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EMX1VDN24+OxgIDl2Am7O0dVKjNUIrcW4xMYrciJbNQ=;
        b=tqduU8znGfYoz1zKfV8mwVuN3mtARatOsTyC8IGtzqRtHurNeafBLHWkqt1bD8s7lmEzu1
        8ia8vo6FzPDaUjAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 262D313780;
        Tue, 12 Sep 2023 00:38:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QI1gAxCz/2QvWAAAMHmgww
        (envelope-from <krisman@suse.de>); Tue, 12 Sep 2023 00:38:40 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
Subject: Re: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
In-Reply-To: <20230911204021.1479172-4-axboe@kernel.dk> (Jens Axboe's message
        of "Mon, 11 Sep 2023 14:40:21 -0600")
References: <20230911204021.1479172-1-axboe@kernel.dk>
        <20230911204021.1479172-4-axboe@kernel.dk>
Date:   Mon, 11 Sep 2023 20:38:38 -0400
Message-ID: <875y4g5ipd.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> This behaves like IORING_OP_READ, except:
>
> 1) It only supports pollable files (eg pipes, sockets, etc). Note that
>    for sockets, you probably want to use recv/recvmsg with multishot
>    instead.
>
> 2) It supports multishot mode, meaning it will repeatedly trigger a
>    read and fill a buffer when data is available. This allows similar
>    use to recv/recvmsg but on non-sockets, where a single request will
>    repeatedly post a CQE whenever data is read from it.
>
> 3) Because of #2, it must be used with provided buffers. This is
>    uniformly true across any request type that supports multishot and
>    transfers data, with the reason being that it's obviously not
>    possible to pass in a single buffer for the data, as multiple reads
>    may very well trigger before an application has a chance to process
>    previous CQEs and the data passed from them.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/uapi/linux/io_uring.h |  1 +
>  io_uring/opdef.c              | 13 +++++++
>  io_uring/rw.c                 | 66 +++++++++++++++++++++++++++++++++++
>  io_uring/rw.h                 |  2 ++
>  4 files changed, 82 insertions(+)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index daa363d1a502..c35438af679a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -246,6 +246,7 @@ enum io_uring_op {
>  	IORING_OP_FUTEX_WAIT,
>  	IORING_OP_FUTEX_WAKE,
>  	IORING_OP_FUTEX_WAITV,
> +	IORING_OP_READ_MULTISHOT,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index bfb7c53389c0..03e1a6f26fa5 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -460,6 +460,16 @@ const struct io_issue_def io_issue_defs[] = {
>  		.prep			= io_eopnotsupp_prep,
>  #endif
>  	},
> +	[IORING_OP_READ_MULTISHOT] = {
> +		.needs_file		= 1,
> +		.unbound_nonreg_file	= 1,
> +		.pollin			= 1,
> +		.buffer_select		= 1,
> +		.audit_skip		= 1,
> +		.ioprio			= 1,
> +		.prep			= io_read_mshot_prep,
> +		.issue			= io_read_mshot,
> +	},
>  };
>  
>  const struct io_cold_def io_cold_defs[] = {
> @@ -692,6 +702,9 @@ const struct io_cold_def io_cold_defs[] = {
>  	[IORING_OP_FUTEX_WAITV] = {
>  		.name			= "FUTEX_WAITV",
>  	},
> +	[IORING_OP_READ_MULTISHOT] = {
> +		.name			= "READ_MULTISHOT",
> +	},
>  };
>  
>  const char *io_uring_get_opcode(u8 opcode)
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index c3bf38419230..7305792fbbbf 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -123,6 +123,22 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	return 0;
>  }
>  
> +/*
> + * Multishot read is prepared just like a normal read/write request, only
> + * difference is that we set the MULTISHOT flag.
> + */
> +int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	int ret;
> +
> +	ret = io_prep_rw(req, sqe);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	req->flags |= REQ_F_APOLL_MULTISHOT;
> +	return 0;
> +}
> +
>  void io_readv_writev_cleanup(struct io_kiocb *req)
>  {
>  	struct io_async_rw *io = req->async_data;
> @@ -869,6 +885,56 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	return kiocb_done(req, ret, issue_flags);
>  }
>  
> +int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	unsigned int cflags = 0;
> +	int ret;
> +
> +	/*
> +	 * Multishot MUST be used on a pollable file
> +	 */
> +	if (!file_can_poll(req->file))
> +		return -EBADFD;
> +

Please disregard my previous comment about checking for
io_uring_fops. It is not necessary because this kind of file can't be
read in the first place, so it would never get here.

(Also, things seems to be misbehaving on my MUA archive and Lore didn't
get my own message yet, so I'm not replying directly to it)

-- 
Gabriel Krisman Bertazi
