Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD022B587
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 20:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgGWSRr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgGWSRq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 14:17:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CF5C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:17:46 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so6063794wml.3
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+4zeCZ3imNQj775ESiPmEUTSP8jHl3xEYxp+Ml8SkFI=;
        b=lVT4w1C5DpFMbPR5InHgYE9tw152i19XkadjBEf5KNrmFSS7SQrpFUT6NSxnZLdCAM
         MbFqA5mqwTS8EukIFT0rmZZfxXQMKs5DUrI/RlAWVmrVXXjn1GfMXygAnhF7BpS2xRqU
         cbiVMG0R3xi7EFv0jx+ercqu7wWPh8VPBaD0M3onGAY58MsZlV+JciredbliwBoplpIF
         5O69Bmf0GvWAhZ11+NZMcjbjIEDN4EwBAxPK8aNASTXofshJ3D9uNstFd5krUuOpWgfx
         H5sCHv/9wE8Qbej1ueB5VHRqHS9+UqGNAy8oKDFiSn+R+w7J6r7Yr4Zmw4iCLZL5jx+F
         lCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+4zeCZ3imNQj775ESiPmEUTSP8jHl3xEYxp+Ml8SkFI=;
        b=TXkxPdr8guhQcVTnAKCCp5Ty877is3SLVDmAIu2HVH8zjykg2t9UIGjIGWqGUPts+W
         PGoDimFsBp04Vckz1gegUJg5FiflqS9myYAiZ4LX5AcQWcYhDzch2zhTS4NhuWnR6Qvt
         z6ejctJXE5a7c9QYJMkiKkXhxXmHlHmm+6GXJbtsrYx3IUCGvZ1TckM7nnWNB36bBfiY
         nzid1GbOtqpsPjD9PXGkTI4uiw9Jaz+RHE9D3SlW00ig5XY44DWxwsJ2Flg6l6LhpsCQ
         78zrnr2NJjLrKi1hoW6DaC/5hsEfH1dBWNgIpYdCQ+OyeoX6qTLYh5B6eUW/N1NCMDjD
         zniQ==
X-Gm-Message-State: AOAM530xeraY2lyaGu94ufBdZ3gz4ZG7BwhoauL1wLD9INoDuQyk4lYg
        v2sv7EBCgAYSxG4SLJiBt1HxpNAg
X-Google-Smtp-Source: ABdhPJxDNEFnEToC6YA+RAOqpiOzzOQKlLA4LonigC9Quz7w47Cz01qB3t/AOKI/wtOfWFG/JkYxNw==
X-Received: by 2002:a7b:c44d:: with SMTP id l13mr5435314wmi.66.1595528264764;
        Thu, 23 Jul 2020 11:17:44 -0700 (PDT)
Received: from [192.168.43.57] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id u20sm4168039wmc.42.2020.07.23.11.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 11:17:44 -0700 (PDT)
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e42e74bd-6220-c933-fce1-4005c3c7b2dd@gmail.com>
Date:   Thu, 23 Jul 2020 21:15:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/07/2020 21:12, Pavel Begunkov wrote:
> poll_add can have req->work initialised, which will be overwritten in
> __io_arm_poll_handler() because of the union. Luckily, hash_node is
> zeroed in the end, so the damage is limited to lost put for work.creds,
> and probably corrupted work.list.
> 
> That's the easiest and really dirty fix, which rearranges members in the
> union, arm_poll*() modifies and zeroes only work.files and work.mm,
> which are never taken for poll add.
> note: io_kiocb is exactly 4 cachelines now.

Please, tell me if anybody has a good lean solution, because I'm a bit
too tired at the moment to fix it properly.
BTW, that's for 5.8, for-5.9 it should be done differently because of
io_kiocb compaction. 


> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 32b0064f806e..58e6f7d938b6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -669,12 +669,12 @@ struct io_kiocb {
>  		 * restore the work, if needed.
>  		 */
>  		struct {
> -			struct callback_head	task_work;
> -			struct hlist_node	hash_node;
>  			struct async_poll	*apoll;
> +			struct hlist_node	hash_node;
>  		};
>  		struct io_wq_work	work;
>  	};
> +	struct callback_head	task_work;
>  };
>  
>  #define IO_PLUG_THRESHOLD		2
> 

-- 
Pavel Begunkov
