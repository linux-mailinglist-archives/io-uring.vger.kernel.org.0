Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEF7536640
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiE0RAk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 13:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiE0RAk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 13:00:40 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12246122B57
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 10:00:39 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y8so5203486iof.10
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 10:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZTUD7kVCikLw1GDTHBn6JIn7ATSvwNHuI+EzEVTT5+4=;
        b=FLvpl+F2ntK0xLM87a728j1GNfMkC6ZxnvBtI8y/QOOqyOKM7HZNRUgiBCm/5JGQxh
         laumTS7HX01PuaYYfRE9/CvON7gJkA+YgCW9Jbra4Zk1uemqCcBwoH4VysELr0ZCa2w6
         84b5FF9GMzD+2bYJ5JcBDIZxzp5rjDOqoL/dzx14kqkIvt/ktZWarzXVcHxRIhPPcFC/
         t4eSXuEgnnJ2ogeu2d1TqbWsFt3OEvqIIFvHAShmUN1asLA/lYekvIKlJprZ49Kyur6H
         0tsb4kM41od5fzEC26IMHKdyiSav41jZ/m8s4u7jZgC14xOo8lmvAc82j67r8UziU7Lp
         Ntlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZTUD7kVCikLw1GDTHBn6JIn7ATSvwNHuI+EzEVTT5+4=;
        b=ZUF5VnkiE8Xd1VO47eB9D9JKiZE87M+THNB9EqvOXkoq5D4Hs5T41/Qqtma7rI/XcA
         lv6Zg/Hynn8l6cxZepXq6Oq/jmQGKfJNoicjFQT2pTsg9LnbUK61XxhjvAhCVH7fHKhP
         X667aVv19oWsvXrLY3UfvHd4ATvcuWZ6op/LPZ9x8e63bHzz31uf9cgaONHqoQhxQBdp
         42wRNIVNLFNF+S355u4sH7M8ROhlqf+8r15+aKcQyupvP3SxfYvX9HnxhV5qmiN643zp
         X/sgZP3WOcvpkWtL1EbLN9gsiF/64MpZn2OFAfDGR3aXQ9o2W83AzduYRmIbM+7aeYNm
         I2iA==
X-Gm-Message-State: AOAM530DZCQEk2MndD+Lu3MsHfx7V81sO3jjZC/udP2HdyXbkLKBgGqd
        Fj0W1PEWVQSJgdiSxlVHaIW6VRMWZ/2wWQ==
X-Google-Smtp-Source: ABdhPJwE1Wmwjcr30UPGczvqY5Qcs8EygByfd93NMinGJdyIz4d7WxYPHwaPRzFoJE935nla2GsFtg==
X-Received: by 2002:a6b:d605:0:b0:65b:476f:7166 with SMTP id w5-20020a6bd605000000b0065b476f7166mr20212574ioa.207.1653670838326;
        Fri, 27 May 2022 10:00:38 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s12-20020a92cb0c000000b002cdf1805808sm1429319ilo.88.2022.05.27.10.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 10:00:37 -0700 (PDT)
Message-ID: <b9c033f1-c377-3046-bf23-aabbf885e161@kernel.dk>
Date:   Fri, 27 May 2022 11:00:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] io_uring: fix file leaks around io_fixed_fd_install()
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220527165333.55212-1-xiaoguang.wang@linux.alibaba.com>
 <20220527165333.55212-2-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527165333.55212-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/22 10:53 AM, Xiaoguang Wang wrote:
> io_fixed_fd_install() may fail for many reasons, such as short of
> free fixed file bitmap, memory allocation failures, etc. When these
> errors happen, current code forgets to fput(file) correspondingly.
> 
> This patch will fix resource leaks around io_fixed_fd_install(),
> meanwhile io_fixed_fd_install() and io_install_fixed_file() are
> basically similar, fold them into one function.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 77 ++++++++++++++++++++++++++---------------------------------
>  1 file changed, 34 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d50bbf8de4fb..ff50e5f1753d 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1364,8 +1364,8 @@ static void io_req_task_queue(struct io_kiocb *req);
>  static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
>  static int io_req_prep_async(struct io_kiocb *req);
>  
> -static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
> -				 unsigned int issue_flags, u32 slot_index);
> +static int io_install_fixed_file(struct io_kiocb *req, unsigned int issue_flags,
> +				 struct file *file, u32 slot);
>  static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
>  
>  static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
> @@ -5438,36 +5438,6 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>  	return -ENFILE;
>  }
>  
> -static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
> -			       struct file *file, unsigned int file_slot)
> -{
> -	bool alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
> -	struct io_ring_ctx *ctx = req->ctx;
> -	int ret;
> -
> -	if (alloc_slot) {
> -		io_ring_submit_lock(ctx, issue_flags);
> -		ret = io_file_bitmap_get(ctx);
> -		if (unlikely(ret < 0)) {
> -			io_ring_submit_unlock(ctx, issue_flags);
> -			return ret;
> -		}
> -
> -		file_slot = ret;
> -	} else {
> -		file_slot--;
> -	}
> -
> -	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
> -	if (alloc_slot) {
> -		io_ring_submit_unlock(ctx, issue_flags);
> -		if (!ret)
> -			return file_slot;
> -	}
> -
> -	return ret;
> -}
> -
>  static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct open_flags op;
> @@ -5520,11 +5490,14 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
>  		file->f_flags &= ~O_NONBLOCK;
>  	fsnotify_open(file);
>  
> -	if (!fixed)
> +	if (!fixed) {
>  		fd_install(ret, file);
> -	else
> -		ret = io_fixed_fd_install(req, issue_flags, file,
> -						req->open.file_slot);
> +	} else {
> +		ret = io_install_fixed_file(req, issue_flags, file,
> +					    req->open.file_slot);
> +		if (ret < 0)
> +			fput(file);
> +	}
>  err:
>  	putname(req->open.filename);
>  	req->flags &= ~REQ_F_NEED_CLEANUP;
> @@ -6603,8 +6576,10 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
>  		fd_install(fd, file);
>  		ret = fd;
>  	} else {
> -		ret = io_fixed_fd_install(req, issue_flags, file,
> -						accept->file_slot);
> +		ret = io_install_fixed_file(req, issue_flags, file,
> +					    accept->file_slot);
> +		if (ret < 0)
> +			fput(file);
>  	}
>  
>  	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
> @@ -6676,8 +6651,10 @@ static int io_socket(struct io_kiocb *req, unsigned int issue_flags)
>  		fd_install(fd, file);
>  		ret = fd;
>  	} else {
> -		ret = io_fixed_fd_install(req, issue_flags, file,
> +		ret = io_install_fixed_file(req, issue_flags, file,
>  					    sock->file_slot);
> +		if (ret < 0)
> +			fput(file);
>  	}
>  	__io_req_complete(req, issue_flags, ret, 0);
>  	return 0;
> @@ -10130,15 +10107,27 @@ static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
>  	return 0;
>  }
>  
> -static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
> -				 unsigned int issue_flags, u32 slot_index)
> +static int io_install_fixed_file(struct io_kiocb *req, unsigned int issue_flags,
> +				 struct file *file, u32 slot)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	bool needs_switch = false;
>  	struct io_fixed_file *file_slot;
>  	int ret = -EBADF;
> +	bool alloc_slot = slot == IORING_FILE_INDEX_ALLOC;
> +	int slot_index;
>  
>  	io_ring_submit_lock(ctx, issue_flags);
> +	if (alloc_slot) {
> +		slot_index = io_file_bitmap_get(ctx);
> +		if (unlikely(slot_index < 0)) {
> +			io_ring_submit_unlock(ctx, issue_flags);
> +			return slot_index;
> +		}
> +	} else {
> +		slot_index = slot - 1;
> +	}
> +
>  	if (file->f_op == &io_uring_fops)
>  		goto err;
>  	ret = -ENXIO;
> @@ -10178,8 +10167,10 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>  	if (needs_switch)
>  		io_rsrc_node_switch(ctx, ctx->file_data);
>  	io_ring_submit_unlock(ctx, issue_flags);
> -	if (ret)
> -		fput(file);
> +	if (alloc_slot) {
> +		if (!ret)
> +			return slot_index;
> +	}
>  	return ret;
>  }
>  


-- 
Jens Axboe

