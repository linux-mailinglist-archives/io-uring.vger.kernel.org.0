Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AA074DBCB
	for <lists+io-uring@lfdr.de>; Mon, 10 Jul 2023 18:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjGJQ7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Jul 2023 12:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjGJQ7C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Jul 2023 12:59:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DE0E3;
        Mon, 10 Jul 2023 09:59:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F35561FF3A;
        Mon, 10 Jul 2023 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689008340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aoEB1v5p+JaOAwcNX2Xgzr1h4ME0r6a9ORk8q4gaqfA=;
        b=N7TPH1KC7YSj0Zua71hmaHWdcoFviJJDjfikzYhcw5goXZDLQApt2kUczL79MWRUyShJek
        ZGisHTHmFbYXSTNwgtRmePcMZ8P7vl6g+97RgHE5a42L321+uRnz6vrOnJy6YFcvGKCln9
        VeDEaFe85Udv/3GhxKbJijI3M8sgN9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689008340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aoEB1v5p+JaOAwcNX2Xgzr1h4ME0r6a9ORk8q4gaqfA=;
        b=C+oxvZRvkLlfpxjHxPnh6LEulwCPDr02dhoPjIWSByTBD/bdcoR8O1OLvlk9AiCGr9hY4v
        qiiXRYlVJ1yAkpAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B295D13A05;
        Mon, 10 Jul 2023 16:58:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id knYaJtM4rGQDCgAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 10 Jul 2023 16:58:59 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Lu Hongfei <luhongfei@vivo.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource.kernel@vivo.com
Subject: Re: [PATCH] io_uring: Redefined the meaning of
 io_alloc_async_data's return value
References: <20230710090957.10463-1-luhongfei@vivo.com>
Date:   Mon, 10 Jul 2023 12:58:58 -0400
In-Reply-To: <20230710090957.10463-1-luhongfei@vivo.com> (Lu Hongfei's message
        of "Mon, 10 Jul 2023 17:09:56 +0800")
Message-ID: <87o7kjr9d9.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Lu Hongfei <luhongfei@vivo.com> writes:

> Usually, successful memory allocation returns true and failure returns false,
> which is more in line with the intuitive perception of most people. So it
> is necessary to redefine the meaning of io_alloc_async_data's return value.
>
> This could enhance the readability of the code and reduce the possibility
> of confusion.

just want to say, this is the kind of patch that causes bugs in
downstream kernels.  It is not fixing anything, and when we backport a
future bugfix around it, it is easy to miss it and slightly break the
semantics.

That's my downstream problem, of course. But at least it would be good
practice to change the symbol, making the change hard to miss.  Or
make the function return int instead of bool, which preserves the
interface and is a common C idiom.  Or leave it as it is, which is quite
readable already..

thx,

> Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
> ---
>  io_uring/io_uring.c  | 13 +++++++++----
>  io_uring/net.c       |  4 ++--
>  io_uring/rw.c        |  2 +-
>  io_uring/timeout.c   |  2 +-
>  io_uring/uring_cmd.c |  2 +-
>  5 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e8096d502a7c..19f14b7b417d 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1753,14 +1753,19 @@ unsigned int io_file_get_flags(struct file *file)
>  	return res;
>  }
>  
> +/*
> + * Alloc async data to the req.
> + *
> + * Returns 'true' if the allocation is successful, 'false' otherwise.
> + */
>  bool io_alloc_async_data(struct io_kiocb *req)
>  {
>  	WARN_ON_ONCE(!io_cold_defs[req->opcode].async_size);
>  	req->async_data = kmalloc(io_cold_defs[req->opcode].async_size, GFP_KERNEL);
> -	if (req->async_data) {
> -		req->flags |= REQ_F_ASYNC_DATA;
> +	if (!req->async_data)
>  		return false;
> -	}
> +
> +	req->flags |= REQ_F_ASYNC_DATA;
>  	return true;
>  }
>  
> @@ -1777,7 +1782,7 @@ int io_req_prep_async(struct io_kiocb *req)
>  	if (WARN_ON_ONCE(req_has_async_data(req)))
>  		return -EFAULT;
>  	if (!def->manual_alloc) {
> -		if (io_alloc_async_data(req))
> +		if (!io_alloc_async_data(req))
>  			return -EAGAIN;
>  	}
>  	return cdef->prep_async(req);
> diff --git a/io_uring/net.c b/io_uring/net.c
> index eb1f51ddcb23..49e659d3a874 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -152,7 +152,7 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
>  		}
>  	}
>  
> -	if (!io_alloc_async_data(req)) {
> +	if (io_alloc_async_data(req)) {
>  		hdr = req->async_data;
>  		hdr->free_iov = NULL;
>  		return hdr;
> @@ -1494,7 +1494,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>  		}
>  		if (req_has_async_data(req))
>  			return -EAGAIN;
> -		if (io_alloc_async_data(req)) {
> +		if (!io_alloc_async_data(req)) {
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1bce2208b65c..90d4be57a811 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -523,7 +523,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
>  	if (!req_has_async_data(req)) {
>  		struct io_async_rw *iorw;
>  
> -		if (io_alloc_async_data(req)) {
> +		if (!io_alloc_async_data(req)) {
>  			kfree(iovec);
>  			return -ENOMEM;
>  		}
> diff --git a/io_uring/timeout.c b/io_uring/timeout.c
> index fb0547b35dcd..35a756d22781 100644
> --- a/io_uring/timeout.c
> +++ b/io_uring/timeout.c
> @@ -534,7 +534,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
>  
>  	if (WARN_ON_ONCE(req_has_async_data(req)))
>  		return -EFAULT;
> -	if (io_alloc_async_data(req))
> +	if (!io_alloc_async_data(req))
>  		return -ENOMEM;
>  
>  	data = req->async_data;
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 476c7877ce58..716a28495bf3 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -139,7 +139,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>  	if (ret == -EAGAIN) {
>  		if (!req_has_async_data(req)) {
> -			if (io_alloc_async_data(req))
> +			if (!io_alloc_async_data(req))
>  				return -ENOMEM;
>  			io_uring_cmd_prep_async(req);
>  		}

-- 
Gabriel Krisman Bertazi
