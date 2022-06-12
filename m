Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DE4547B4D
	for <lists+io-uring@lfdr.de>; Sun, 12 Jun 2022 19:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiFLRph (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jun 2022 13:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiFLRpa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jun 2022 13:45:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E76E1208A
        for <io-uring@vger.kernel.org>; Sun, 12 Jun 2022 10:45:28 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c21so4588892wrb.1
        for <io-uring@vger.kernel.org>; Sun, 12 Jun 2022 10:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hJCJnYe+oh5t/gEAyUxHjk2Bkd++8D6N/zg2RNfcgvU=;
        b=EzJbBzUlJiogYtb6JtMkN02v8PfR7ty7uLTT1JuITrZFsPNznvy5jKjV5z7Qn7ULtp
         U8eE3S8ojYcurDi7xhWjMNz57c+TR7SVsCnF5SlKvQlbTVdl2PehoJ/dcrysG8AxApQT
         Oc4ErxkMyiVIky0Ot03NkIFqAgYkpgPmGSat+6sgMf7sDH+EnXAo8FbSU6PnQQVLw2Oc
         7JdNL9ngKX+PUXEQVGV1UrmyFvl+frhVS0T8LAfvue5GYZtZnF/L+xGZJdPmoB66mOQf
         LYHdsGGMWr9o1HAyQZLtBMZmRNDB7oRaDcMxLJGup1880tEPdwIwcxrRGghEJmYOvrNd
         PO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hJCJnYe+oh5t/gEAyUxHjk2Bkd++8D6N/zg2RNfcgvU=;
        b=xiGNTzPYZ6F1nyG/8Iwy4LnokeD/tvsL4XYa+re11WSS4K3xVzvToXvuOS8c9mHgaH
         B/EhxSHC341Bbt6dUu25fy3zjZqILB/c3y0dXFdOBqC8WyzKmtT9dIjp0Poz53wXAov/
         1KS3eLvkIBzadlOdBwcrzmXLwnk+w992G/gj1wKdu/2Wvxs8PRzhp58U0S0cIgYOYVkM
         N3qM0eoai1idCo3220OmTPDwV1diA2VfrT2JPmRwGQ/UUJL9mIH/WTpBJyUldulc4ban
         l60gjqRQjaF5MMvFqxaaNY4CQv6adUWdYBRfmH9a3Eb8Imx4K1AhRcQICwxhDk6nvbzB
         zxKA==
X-Gm-Message-State: AOAM533FW5KZiJZCmSOctMc8WzqgLtlpkivE1UIS0f9K8/8vlIlFoW26
        4+nyAfvcCoGzxmVttkIsGpQ=
X-Google-Smtp-Source: ABdhPJzRM5RKDI/TfR86s32Zt9DksjDUC4Ne7F7Wp+kQwzzdgJREext/n2sa7Sh9vrZxul8ZwfEomg==
X-Received: by 2002:a5d:5952:0:b0:217:a419:c417 with SMTP id e18-20020a5d5952000000b00217a419c417mr39341672wri.641.1655055926761;
        Sun, 12 Jun 2022 10:45:26 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c6-20020a5d4146000000b00213ba3384aesm6353524wrq.35.2022.06.12.10.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 10:45:26 -0700 (PDT)
Message-ID: <2cdbfc15-4d44-2a0e-9291-d8ae9bdd20d0@gmail.com>
Date:   Sun, 12 Jun 2022 18:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-5.20 1/6] io_uring: poll: remove unnecessary req->ref
 set
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220611122224.941800-1-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220611122224.941800-1-hao.xu@linux.dev>
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
> We now don't need to set req->refcount for poll requests since the
> reworked poll code ensures no request release race.

Nice, I took this one into the 5.20 branch, cheers

https://github.com/isilence/linux/tree/io_uring/for-5.20

> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/poll.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 0df5eca93b16..73584c4e3e9b 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -683,7 +683,6 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
>   		return -EINVAL;
>   
> -	io_req_set_refcount(req);
>   	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
>   	return 0;
>   }

-- 
Pavel Begunkov
