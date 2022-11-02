Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998296161B5
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKBLYl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 07:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKBLYl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 07:24:41 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33A2248D3
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 04:24:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso556950wmo.1
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tuTanurUbLKcc2K4q7M4tosl+H4Sl2sL53ZQkhvnhGE=;
        b=dKWUMmylghJpfofN4v4xc6eWK5JOYOSUuxd5onAgPggHxSLHGgmEe9WR8eDdttoNgh
         3mSpKF5tOP++tmxu1VUbaSFgkj3pc1F2HBiPg61dHQk6uy831N7JKGojJ/zWVb0mNvn4
         SU/HvAJrGjS9ZKO0IqDUOG3+2gw72njtW7JbjeLCB+zvgTugLbNlkyxZ0CRzwgc/geTA
         co8ClSPZoqlOsz1J247uDkfaACz+q5tjv+egDTzue7dK9X/uvrIGPlMbXoyZuXVPKzCi
         F8bPb9NXk+9zD4ygEFu4xO6QZ4WonyIJ/ZRalu8j+IJemkQ9TkufRXSOVx+s4Ee3T2rc
         sFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tuTanurUbLKcc2K4q7M4tosl+H4Sl2sL53ZQkhvnhGE=;
        b=JXRLAA01EBe+L3k4o6QjCn19QmGdEbPqxeG+ctFrxXHUImA2+EH0vK/tXmAUj+Jzu3
         MSodPk/FMrcBOGRGf/wAbzo5IG9qp03S+coM7Te2HSKG70QxzVseGtFeanllsIT0SK8d
         ArQD/+jmKmnjS4IwIM2o9yMviS8q6mydCyuiAONkzr/swZuOUL7A2Wt/DEx4Jj4PDwvt
         qEaNEsdC7xZQaagvKzhNFSuSCmA5NjlI/SEu0GVpkVYSngINTV6//TugrObii1G1Joqp
         NYJxsDpGvW8R1dJB3D8pkNvEAVR9oR6TIjlxTF5hv4noZCTrtYkZWlCQRDNU2rLAk+0Q
         eYpQ==
X-Gm-Message-State: ACrzQf3ej1aCC1G9b+PN9BHMcg1dtodhJGqUsk72B3sMha5EMCrIfzE5
        3cnQqFIHlxSzrxh2ne4R5W9m4+aUCy4=
X-Google-Smtp-Source: AMsMyM5WOhw9sawcQ5Z2gGebun+dZQFA/Kyc5DO4yBziwPpbVDgWHbgFb5c44RIbqPanZtLlpAH31w==
X-Received: by 2002:a05:600c:4fcf:b0:3c6:cdb9:b68f with SMTP id o15-20020a05600c4fcf00b003c6cdb9b68fmr25960230wmq.73.1667388278351;
        Wed, 02 Nov 2022 04:24:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2739])
        by smtp.gmail.com with ESMTPSA id fc19-20020a05600c525300b003cf57329221sm2374158wmb.14.2022.11.02.04.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 04:24:37 -0700 (PDT)
Message-ID: <04c1de23-3957-f550-9ab0-940cc6bb9e66@gmail.com>
Date:   Wed, 2 Nov 2022 11:23:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-next 06/12] io_uring: add fixed file peeking function
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-7-dylany@meta.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221031134126.82928-7-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 13:41, Dylan Yudaken wrote:
> Add a helper function to grab the fixed file at a given offset. Will be
> useful for retarget op handlers.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> ---
>   io_uring/io_uring.c | 26 ++++++++++++++++++++------
>   io_uring/io_uring.h |  1 +
>   2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 32eb305c4ce7..a052653fc65e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1841,6 +1841,23 @@ void io_wq_submit_work(struct io_wq_work *work)
>   		io_req_task_queue_fail(req, ret);
>   }
>   
> +static unsigned long __io_file_peek_fixed(struct io_kiocb *req, int fd)
> +	__must_hold(&req->ctx->uring_lock)

Let's mark it inline, it's in the hot path. Yeah, It's small but I
battled compilers enough because from time to time they leave it
not inlined.


> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
> +		return 0;
> +	fd = array_index_nospec(fd, ctx->nr_user_files);
> +	return io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
> +}
> +
> +struct file *io_file_peek_fixed(struct io_kiocb *req, int fd)
> +	__must_hold(&req->ctx->uring_lock)
> +{
> +	return (struct file *) (__io_file_peek_fixed(req, fd) & FFS_MASK);
> +}
> +
>   inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>   				      unsigned int issue_flags)
>   {
> @@ -1849,17 +1866,14 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>   	unsigned long file_ptr;
>   
>   	io_ring_submit_lock(ctx, issue_flags);
> -
> -	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
> -		goto out;
> -	fd = array_index_nospec(fd, ctx->nr_user_files);
> -	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
> +	file_ptr = __io_file_peek_fixed(req, fd);
>   	file = (struct file *) (file_ptr & FFS_MASK);
>   	file_ptr &= ~FFS_MASK;
>   	/* mask in overlapping REQ_F and FFS bits */
>   	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
>   	io_req_set_rsrc_node(req, ctx, 0);
> -out:
> +	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
> +
>   	io_ring_submit_unlock(ctx, issue_flags);
>   	return file;
>   }
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index ef77d2aa3172..781471bfba12 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -44,6 +44,7 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
>   struct file *io_file_get_normal(struct io_kiocb *req, int fd);
>   struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>   			       unsigned issue_flags);
> +struct file *io_file_peek_fixed(struct io_kiocb *req, int fd);
>   
>   static inline bool io_req_ffs_set(struct io_kiocb *req)
>   {

-- 
Pavel Begunkov
