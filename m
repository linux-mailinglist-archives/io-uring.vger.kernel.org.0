Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B14F6BCF8E
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 13:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCPMdP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 08:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCPMdN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 08:33:13 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E9FCB067
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 05:33:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w9so7063822edc.3
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 05:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678969987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FlUAF92zKhhtlxglEoIQv+yc0AENhZvEk7b0znxtDdE=;
        b=S5l6wLFR5jWVnpwmKxEGWuf8Mtww282ibdbx0ujN3Ip1tdO7swNzBE0QLg+P3iwJxs
         Yyvc6FuRHE+XVC3UTJ7F0niPWEJA5s86XemDMA3BSG8xOA4piITgbd3ZczheL1WmS9m2
         K8fIFlqHZejxbyUCXQTrZhl3Lu5Mg8JH80GW04+rtcdnuHiK4SW03ltmalREdVgWOFDO
         OZn4x6rhyBHTZ0HwzL4+igy4KtU2NJjgl8QnQHo8LXS0+cnSX/0dq9Y0/KYLVnCqb0TT
         1piXqknAc+CXPWPb6MBIpN+JIPTLnXKMxrSteji+vOr7WIlxil3prbropgNoTzQkrcyC
         MkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678969987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlUAF92zKhhtlxglEoIQv+yc0AENhZvEk7b0znxtDdE=;
        b=aJyoDbS8fqB7yPpLS85AGPR1XOdFXbrygizMEp7YRBNngIS3w839f1BO2VSKjgPD9L
         zndN0hXvSjGZvhNMCVJXsX51bkw/zf0Ca+3YdTuhN+q/ErT3wiD5F4yhE/6JklTbO+5x
         aPR0h3gPmOhLdjeUm2xTqvGKWlB5Cvbxxpy4ktqwhL6ccl5TEbDhTC2YhH1e2TGbBkCz
         nBggKfF3chOSVnL6rhHBQA9dTZs1GY+jwoN/eS/bnh1k1G+VSazl+DvfXQvvdOBoC6as
         Sl7iwH2Zr/qpstGam6An9P2kzHDnXIXgF3TyilQAlGLgc7tfGB1lJiAbHaFvNjcizFtu
         +D5Q==
X-Gm-Message-State: AO0yUKVCM+lo/XoLZzbBIW+Jcl8CZavDZSYoP0iZjuJM5+GhujbzZ7hh
        D2y9Tr5GFhF2iN2KnMTOFJCaHDCXnLk=
X-Google-Smtp-Source: AK7set9Z8OD0aqK13c2kbIYA5WAeKW2XlcfMFzPQm/Kl/iC68vHPPJlGsl4mrpxOD1VY+xwS+rY3yA==
X-Received: by 2002:a17:906:7d52:b0:92e:e9c2:7b9e with SMTP id l18-20020a1709067d5200b0092ee9c27b9emr4680928ejp.41.1678969986852;
        Thu, 16 Mar 2023 05:33:06 -0700 (PDT)
Received: from [172.23.55.223] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id s14-20020a50d48e000000b004fc86fcc4b3sm3786581edi.80.2023.03.16.05.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 05:33:06 -0700 (PDT)
Message-ID: <6c8e8d59-3bea-50c6-e164-f6e784b364d6@gmail.com>
Date:   Thu, 16 Mar 2023 12:29:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/1] io_uring/msg_ring: let target know allocated index
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
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

On 3/16/23 12:11, Pavel Begunkov wrote:
> msg_ring requests transferring files support auto index selection via
> IORING_FILE_INDEX_ALLOC, however they don't return the selected index
> to the target ring and there is no other good way for the userspace to
> know where is the receieved file.

Weird, there are two identical mails with the patch, please
ignore either of them.

  
> Return the index for allocated slots and 0 otherwise, which is
> consistent with other fixed file installing requests.
> 
> Cc: stable@vger.kernel.org # v6.0+
> Fixes: e6130eba8a848 ("io_uring: add support for passing fixed file descriptors")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/msg_ring.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index 8803c0979e2a..85fd7ce5f05b 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -202,7 +202,7 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
>   	 * completes with -EOVERFLOW, then the sender must ensure that a
>   	 * later IORING_OP_MSG_RING delivers the message.
>   	 */
> -	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
> +	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
>   		ret = -EOVERFLOW;
>   out_unlock:
>   	io_double_unlock_ctx(target_ctx);
> @@ -229,6 +229,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct file *src_file = msg->src_file;
>   
> +	if (msg->len)
> +		return -EINVAL;
>   	if (target_ctx == ctx)
>   		return -EINVAL;
>   	if (target_ctx->flags & IORING_SETUP_R_DISABLED)

-- 
Pavel Begunkov
