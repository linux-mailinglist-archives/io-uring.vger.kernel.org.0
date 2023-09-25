Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954517ADC79
	for <lists+io-uring@lfdr.de>; Mon, 25 Sep 2023 17:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjIYP6P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Sep 2023 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjIYP6N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Sep 2023 11:58:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D372B6;
        Mon, 25 Sep 2023 08:58:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2DE9221853;
        Mon, 25 Sep 2023 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695657486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBAPgAZrnnoUjBYQVr0SHZ7y8Z1Y/PFBtCLQvwlJc50=;
        b=Hz+zu6Jy7Wgn4MMoze7XYosvmQaARtnoY1CThkd9nf8vpbwOMa2PBqOCVR9oR5zXUej8AK
        R3hMA164SKeuX6/E3p3CjPI8GmiY1VE0gBnEUsguzIjySrKIxFpDy0cmLcw/bDhe6zVENl
        RhrIDZdrfJF2uc7tBjOZb+FYZ1O+lQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695657486;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tBAPgAZrnnoUjBYQVr0SHZ7y8Z1Y/PFBtCLQvwlJc50=;
        b=ALwZL6I+FNTFUQOjxySovVVRxvTXSzDmB3vzC0A1UYaPC/6IWgKpp6rasK5o6Y3fjZSePX
        d8fBBeq6kTEL77Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E92511358F;
        Mon, 25 Sep 2023 15:58:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SzXhMg2uEWX6ZgAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 25 Sep 2023 15:58:05 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH V4 1/2] io_uring: retain top 8bits of uring_cmd flags
 for kernel internal use
In-Reply-To: <20230923025006.2830689-2-ming.lei@redhat.com> (Ming Lei's
        message of "Sat, 23 Sep 2023 10:50:02 +0800")
References: <20230923025006.2830689-1-ming.lei@redhat.com>
        <20230923025006.2830689-2-ming.lei@redhat.com>
Date:   Mon, 25 Sep 2023 11:58:04 -0400
Message-ID: <87v8by5joz.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> Retain top 8bits of uring_cmd flags for kernel internal use, so that we
> can move IORING_URING_CMD_POLLED out of uapi header.

Feel free to add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/io_uring.h      | 3 +++
>  include/uapi/linux/io_uring.h | 5 ++---
>  io_uring/io_uring.c           | 3 +++
>  io_uring/uring_cmd.c          | 2 +-
>  4 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 106cdc55ff3b..ae08d6f66e62 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -22,6 +22,9 @@ enum io_uring_cmd_flags {
>  	IO_URING_F_IOPOLL		= (1 << 10),
>  };
>  
> +/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
> +#define IORING_URING_CMD_POLLED		(1U << 31)
> +
>  struct io_uring_cmd {
>  	struct file	*file;
>  	const struct io_uring_sqe *sqe;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 8e61f8b7c2ce..de77ad08b123 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -246,13 +246,12 @@ enum io_uring_op {
>  };
>  
>  /*
> - * sqe->uring_cmd_flags
> + * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>   *				along with setting sqe->buf_index.
> - * IORING_URING_CMD_POLLED	driver use only
>   */
>  #define IORING_URING_CMD_FIXED	(1U << 0)
> -#define IORING_URING_CMD_POLLED	(1U << 31)
> +#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
>  
>  
>  /*
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 783ed0fff71b..9aedb7202403 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -4666,6 +4666,9 @@ static int __init io_uring_init(void)
>  
>  	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
>  
> +	/* top 8bits are for internal use */
> +	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
> +
>  	io_uring_optable_init();
>  
>  	/*
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 537795fddc87..a0b0ec5473bf 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -91,7 +91,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return -EINVAL;
>  
>  	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
> -	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
> +	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
>  		return -EINVAL;
>  
>  	if (ioucmd->flags & IORING_URING_CMD_FIXED) {

-- 
Gabriel Krisman Bertazi
