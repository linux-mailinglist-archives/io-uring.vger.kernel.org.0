Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7864440034C
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhICQam (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 12:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbhICQal (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 12:30:41 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D167AC061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 09:29:41 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a15so7446281iot.2
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PZfaEwu8D+jLZ61I63uRdheLlU6BCC4tBWJbMjhqJtc=;
        b=oPnjr5P44PWJYg+azMGmAQXkpxEXeRXyDovi06EPMSyvxUDWUSNY3wuMtlBZIRTRcg
         WuQorL5+63JFivCvYkycfSXBWFhRb6b4gFW7JeYaAIpt0Zcm4Nl3jmJIABwD+O9t3Tmu
         K9jwjx4YYbA9QsK4ZW8wa0WJbPQ6gFspbYUSJLzeqJEPRjU7iOIDyVBl9Vin+88wR0ca
         nHLOebmB4J0hbDq1UwbFMIolpNT3B2q3DyiCGBUTRxY70khX6s1t5pFvwbqxGNCUFacz
         tzWhrNfNtrFKh6vTjPHljqBSMpgOHD/28DSyHViLBNf4/d94bfeRowR/UQkqPYMnQhS0
         WNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZfaEwu8D+jLZ61I63uRdheLlU6BCC4tBWJbMjhqJtc=;
        b=bcTljdCqeOwdiieMmjbL5G09DeFl4mdDbtQ/BKrDxjqyXe50RiFp6K9P/e6GuH62qN
         kFi5M7nCcSTd4ynmnkBapfq0cKjWJbtLF9I00+F95CFt+OiSeK4RYcTa0Qcjl3Luv+N3
         ad0NeMrhrhdGVCwIywqrycNgsMtHTTN7bdWYAmmOzA7KHGbb8vyv9dbbd1vN6qdX5BGC
         6W7yLgsGZ+Jhd3NIEgvV6H26clyd+Zc+56dEcBu0i3vgj23p+8ijkeYy5TGzc7WIhffG
         Wu/d2n5Cr2qQNNrXW4Dq9otE/ZoK1PhNHd6iFLzG+3err9QpvEwt4B8zZKusSOInCdPS
         BB2w==
X-Gm-Message-State: AOAM532WZGSdHCIDrFcIl424mwl106VAlZcTaEy9zLgeS61XCAY0fDLz
        JoydlANFjlRfBwLKjO+G1DiWlgeJViW7aQ==
X-Google-Smtp-Source: ABdhPJzPioct3Iy3lXPfpaoLDtF+5MRq+BN2MsstuQniN70PbNDpJM/M01hwDMCGJrU1a7ex7PTUzg==
X-Received: by 2002:a02:664e:: with SMTP id l14mr3306470jaf.56.1630686581207;
        Fri, 03 Sep 2021 09:29:41 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d14sm3244027iod.18.2021.09.03.09.29.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 09:29:40 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
Date:   Fri, 3 Sep 2021 10:29:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210903110049.132958-7-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 5:00 AM, Hao Xu wrote:
> Update io_accept_prep() to enable multishot mode for accept operation.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index eb81d37dce78..34612646ae3c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_accept *accept = &req->accept;
> +	bool is_multishot;
>  
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	accept->flags = READ_ONCE(sqe->accept_flags);
>  	accept->nofile = rlimit(RLIMIT_NOFILE);
>  
> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
> +		return -EINVAL;

I like the idea itself as I think it makes a lot of sense to just have
an accept sitting there and generating multiple CQEs, but I'm a bit
puzzled by how you pass it in. accept->flags is the accept4(2) flags,
which can currently be:

SOCK_NONBLOCK
SOCK_CLOEXEC

While there's not any overlap here, that is mostly by chance I think. A
cleaner separation is needed here, what happens if some other accept4(2)
flag is enabled and it just happens to be the same as
IORING_ACCEPT_MULTISHOT?

-- 
Jens Axboe

