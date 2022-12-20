Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26BD651ADB
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 07:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiLTGpP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 01:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiLTGpN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 01:45:13 -0500
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C8013EA2
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 22:45:12 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id ud5so26957720ejc.4
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 22:45:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6aEp+DhaS6CPT/s+Q2Xa2jbdy1Fi3ohWfF0bfWUwsE=;
        b=n527IwxT190xPl9GmYjaEOz8PHM8Ul+gdTq4K+m788XABFbIyrhj1wGcJMblvSWZpG
         BuRNk1mBUJmXrj2pkpkLiybt/KkE92yWcfr0DcIatEUp/RxYW3itBM7yzZVMQfedrMMl
         lbfjYHZkEG5s3pMHYWiaiU8TohF6WaQ4SGbWmq05LhRF7aMFOK7Hg0MziAkM1oPp+RiH
         ETij5y/Foka/gsDi+qfjeBY9A0YoGfQ9M+FoGFrNtVjMRr2vEDa3w69/njK8+fV6+VRS
         xHqNPfOLTggatKtppaTHFUwK2hr2+CH7BnIKyixcvBDMhl/b1qu709f21AWFb9Cf1+q+
         X7qw==
X-Gm-Message-State: ANoB5pl6HR6FrleTaNt/Or3gPz/GFpTZnupHcaOzZr/v4RgEljOAtI9P
        E2KS4/zvjK1uvthwQvFXp56llayzWcw=
X-Google-Smtp-Source: AA0mqf6O0nh6vkt8+Gcnzf9WaPjXnWRcoCruZ0TUTG16adyDIqVS1JZIHPn4FNPErBzS+C4CP3m3cQ==
X-Received: by 2002:a17:906:b181:b0:7c1:65f7:18d8 with SMTP id w1-20020a170906b18100b007c165f718d8mr31195549ejy.60.1671518710731;
        Mon, 19 Dec 2022 22:45:10 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id z7-20020aa7d407000000b0046b531fcf9fsm5257004edq.59.2022.12.19.22.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 22:45:10 -0800 (PST)
Message-ID: <bf44714f-cdc9-7b07-dff1-a0c1e2b8e437@kernel.org>
Date:   Tue, 20 Dec 2022 07:45:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] io_uring/net: ensure compat import handlers clear
 free_iov
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1fcaa6f3-6dc7-0685-1cb3-3b1179409609@kernel.dk>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <1fcaa6f3-6dc7-0685-1cb3-3b1179409609@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19. 12. 22, 15:36, Jens Axboe wrote:
> If we're not allocating the vectors because the count is below
> UIO_FASTIOV, we still do need to properly clear ->free_iov to prevent
> an erronous free of on-stack data.
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Fixes: 4c17a496a7a0 ("io_uring/net: fix cleanup double free free_iov init")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Tested-by: Jiri Slaby <jirislaby@kernel.org>


> ---
> 
> v2: let's play it a bit safer and just always clear at the top rather
>      in the individual cases.
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 5229976cb582..f76b688f476e 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -494,6 +494,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
>   	if (req->flags & REQ_F_BUFFER_SELECT) {
>   		compat_ssize_t clen;
>   
> +		iomsg->free_iov = NULL;
>   		if (msg.msg_iovlen == 0) {
>   			sr->len = 0;
>   		} else if (msg.msg_iovlen > 1) {
> 

thanks,
-- 
js
suse labs

