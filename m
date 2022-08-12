Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7714590A18
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 04:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiHLCC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 22:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbiHLCCZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 22:02:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0381982868
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 19:02:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q9-20020a17090a2dc900b001f58bcaca95so7038073pjm.3
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 19:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=11zcTWO0oljGY1EzL9LHVt+gT25nt8spTrG7rrzy6b0=;
        b=wkcZLIIiSp/Y2A22EdHaCZJlIJ7NJKDrrPjZtaw/34/f5xX4BiVJhNwQFmgoB5oNio
         aeQX+6CTD41VP+7989DBB/Wz6waXiyeq4u2Tuh5iGvK1nkWCEVqyIQhJDJ2M85XMY1Ro
         ma12Qta4X46iOjOHTYPTJj6YOjSf6nyy1+K1WMGnREAgKYgMWXDJVzVHQMgShzIDKa7B
         61gmABFK243bapmbJdH6Jce35/IrSZ9qlVwE6QLdh0SMIygADFGEJKYPupkRfif/0ijV
         KuOE5noSqV08ZMps83KvT7bAaaaHRqiHUzuVmL3nOqneCSg+U70ki58K0BCN74ZffNmp
         pF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=11zcTWO0oljGY1EzL9LHVt+gT25nt8spTrG7rrzy6b0=;
        b=GqB6tmX5fG9r14tayr028X5S5MPsYXp98/8yHKahNw6GJHa0IgtO9uk0lsbg+BUIVM
         kLCwdZ8zPjF5kDU/5pPpN2ZwKuhkqt+alcER9i/5TVssKeyQimazPHDE0nzXciUMGVVj
         sJdRRA86CjJfVkWRoNwl0hHyhhTmOqP8w2vdycAYmGU2kVDCifwv4oas2pDlArNwaZn/
         5BBqYVmsVhrtNfqGgEX+wuwYjK9tfEAJW9qZ61FXLQNDWvuF9YuhCfun75KqAPbnqHtd
         Lqmn96m7mtk4EiVuBXVB9S+FRfXmE6Y3vPBcDuuCFU1N8GrmIUOzc+nNJLpYe6tA4MbN
         Sf2g==
X-Gm-Message-State: ACgBeo1MGgUlARONIvHpsdmeJqwfjmHD5vbtKCEMkikY9DygAICkn/+a
        aQtpigZSwzyVI6GyUh6qoUg7Rb22BIyXOg==
X-Google-Smtp-Source: AA6agR4hL24HIbBlXyE8epaFxFk9InD4TnxjMpEp7FnokbeuHcvYc+Er5wxw6pKd0EA+3XBDpbMOCg==
X-Received: by 2002:a17:90b:1e11:b0:1f4:ee94:6236 with SMTP id pg17-20020a17090b1e1100b001f4ee946236mr1872088pjb.63.1660269744431;
        Thu, 11 Aug 2022 19:02:24 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n7-20020a056a00212700b0052d96d86836sm377745pfj.50.2022.08.11.19.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 19:02:24 -0700 (PDT)
Message-ID: <f6abeede-2681-e41e-38df-456b026e35bb@kernel.dk>
Date:   Thu, 11 Aug 2022 20:02:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: Optimizing return value
Content-Language: en-US
To:     Zhang chunchao <chunchao@nfschina.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@nfschina.com
References: <20220812020000.3720-1-chunchao@nfschina.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220812020000.3720-1-chunchao@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/22 8:00 PM, Zhang chunchao wrote:
> Delete return value ret Initialize assignment, change return value ret
> to EOPNOTSUPP when IO_IS_URING_FOPS failed.
> 
> Signed-off-by: Zhang chunchao <chunchao@nfschina.com>
> ---
>  io_uring/io_uring.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index b54218da075c..1b56f3d1a47b 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3859,16 +3859,17 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>  		void __user *, arg, unsigned int, nr_args)
>  {
>  	struct io_ring_ctx *ctx;
> -	long ret = -EBADF;
> +	long ret;
>  	struct fd f;
>  
>  	f = fdget(fd);
>  	if (!f.file)
>  		return -EBADF;
>  
> -	ret = -EOPNOTSUPP;
> -	if (!io_is_uring_fops(f.file))
> +	if (!io_is_uring_fops(f.file)) {
> +		ret = -EOPNOTSUPP;
>  		goto out_fput;
> +	}
>  
>  	ctx = f.file->private_data;

As mentioned in the other reply, just do the first part. We don't need
to move the other one, I think you'll find the generated code is the
same.

I'd title the commit as "io_uring: remove useless setting of 'ret'".

-- 
Jens Axboe

