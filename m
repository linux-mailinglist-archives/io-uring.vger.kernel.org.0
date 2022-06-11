Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536075474C4
	for <lists+io-uring@lfdr.de>; Sat, 11 Jun 2022 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiFKNOE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jun 2022 09:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiFKNOD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jun 2022 09:14:03 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83993EBA
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 06:14:01 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso876547wmc.4
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 06:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NAOk8d2kggkkkvSUO0Q1bD4RqQYAAIhQ+jRNGOdC0Zg=;
        b=U7BjQ317BfJNKENl3jFRZEenp8F0WyRIHYQk4e5eJMLsqnJyRQ2exDoa+RyPeXwjjG
         GwPbS5419swkes3S+gwPpH8Er/yXAhuATa1CXyqq7KNBtrsoVMF6A7h0xWZyoEr4pUvt
         NUwq5den5xSyAHy2K9cJAmJOxWxRp6913IRab0tGatESQd8PqNTKyRE61MfP8f1bSLGx
         nMKP35kSM1rdr5SzY1/q77R1laQCt1Jdb8cLmWqsottyZT/hH54ZQK+fLWLxDtba0IFI
         59Iri5qBD43wrOG3IzUTMy9PH7E805V0V02zdx4Jf2eEnxMSxdxeDQpfS4uTHQLXJnvg
         sB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NAOk8d2kggkkkvSUO0Q1bD4RqQYAAIhQ+jRNGOdC0Zg=;
        b=XU53jIpqks3Ute6oiwX0p53iUEtQ24b9Jj6Dmk8Flmn98BGwI861NGbPVMci0tuics
         p9HGPDg0H0RqxkAee9Mh8/NC5TH7lLAPoJ/p4TzFX8myrhUdioe7tKZv0fVisMm+hWQ0
         lM1B9Ppo/iieYB+UEIx5jChJQPv1uPMsfIr+/81eEdEkBWpJAMnZUOnrzhcrJGnn6EhM
         sVGbIR8RizZ7H/iOfYwBtCv62njX7e3mTDNrBRlbPumP+5bh2s9g0zZ1KxccYcwZetiE
         vWNrWQtyvi/Gf1dTaAcd2wc6YN5pdjIi4BsnNmzjEHeZQLZi5zY3fzOUCE6jd5tRKD4N
         YO3w==
X-Gm-Message-State: AOAM532uXcMvLlTRkLUcb5D2sdOdYP88wGr9pcIS42HAKxLTSgrdEGAo
        ArntgJhJTt1hklrc+RjBIGjTGnPXHmxPig==
X-Google-Smtp-Source: ABdhPJz9HTjmnZGT+cmmcYoqwdbhgR1aL+Z31lsH3nLcjfT9jDaS5I3ldk+aPw9ptB3L7fw6WZoXww==
X-Received: by 2002:a05:600c:4f87:b0:39c:8091:31e0 with SMTP id n7-20020a05600c4f8700b0039c809131e0mr4887618wmq.84.1654953239980;
        Sat, 11 Jun 2022 06:13:59 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m7-20020a5d4a07000000b00213abce60e4sm2420875wrq.111.2022.06.11.06.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jun 2022 06:13:59 -0700 (PDT)
Message-ID: <3343890c-3aac-089a-4a8c-5ce3d9730238@gmail.com>
Date:   Sat, 11 Jun 2022 14:13:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.19 2/6] io_uring: openclose: fix bug of closing wrong
 fixed file
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220611122224.941800-1-hao.xu@linux.dev>
 <20220611122224.941800-2-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220611122224.941800-2-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/22 13:22, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Don't update ret until fixed file is closed, otherwise the file slot
> becomes the error code.
> 
> Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/rsrc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c

Something strange is going on here, io_uring/rsrc.c was only queued for
5.20, but it's marked 5.19, weird.


> index d78e7f2ea91f..cf8c85d1fb59 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -705,8 +705,8 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
>   		if (ret < 0)
>   			break;
>   		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
> -			ret = -EFAULT;
>   			__io_close_fixed(req, issue_flags, ret);
> +			ret = -EFAULT;
>   			break;
>   		}
>   	}

-- 
Pavel Begunkov
