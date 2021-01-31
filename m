Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FDA309DA8
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 16:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhAaPhQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 10:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhAaM6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jan 2021 07:58:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58843C061573
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 04:54:49 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id u14so10318754wml.4
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 04:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xrqc79MULhInEi8i5xGGNHFuIF7xLOhZNQ9HcylQbT4=;
        b=WIh1MF0LaFjL5FLR3rZir3/9YYjzZ/b1Y/goRilw0ULYcTjUhuTil8e+ZFCZgn79Lg
         G8RooHp+LkYc2epfOAsTTeZaXndrZediOgXfmzqtxOhNfwpKVlGw2MaF6HVLrxnsqeTP
         kmHBbziuz8t3H8hjSk360DgV+K8V5jIySnfEwXzDJ3JCUWly/g2fM7gLZONXso8zVybq
         eqEk1Hls9Gd59YFBwDd+9+uMrra+cstGu9LVtxMSpfHcsonBlUFKJMKQzH6xBpfH7Zxc
         YXnzAAujGAnj7XJVBS5UL0+BfNSTY6i/f4eaqbDqapUh71vNgIh2BeKrhCgqtCY19pmQ
         e6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xrqc79MULhInEi8i5xGGNHFuIF7xLOhZNQ9HcylQbT4=;
        b=p9SYXiJDYfsUtaQTOTgWi9dZqOqDhjNO4sN1JwWa2oEIfR5YjsY+kvv930bHpgjq09
         Cu5VAwyyqpUoys7eRvt/OFEVhoJrgQbJs5D77bK09+m4dTZ525kxpz4rWYzBDWx0d1oE
         q/EIx4X09v0R/VzSjnTBSspH105XrIjHvMmfDyWpTOvqJc/TQrqmhZHgszevgxzNwJ7w
         mgQCsdq/gROGBmd/pKF/+nPOxIHwx9zwvkUrzib7x/pKurtTDn56Xt8/qwPg9W/nBXwI
         sM8dlThvc/oPhLerZ/Dusl6u8qskfRu6wyf3JzjIUkuWwyvZhw6Xip/aQ2YH59WXbune
         N5Zg==
X-Gm-Message-State: AOAM532uvZ/Z/9utnVbKBlNlYXMKDNAXalPihdFcnXOSE7tqXtELVhG9
        CYWVxZxex70rVlzoOKLK1zdwKJRzvgBA+g==
X-Google-Smtp-Source: ABdhPJzlNNLLu5+ZIauYvaBvx0OpT9CAi3ZhClElSHywVAmiFrprMS+nTCuQUVGa0dcAZbc303zlnA==
X-Received: by 2002:a05:600c:28b:: with SMTP id 11mr11076636wmk.69.1612097687922;
        Sun, 31 Jan 2021 04:54:47 -0800 (PST)
Received: from [192.168.8.164] ([148.252.128.5])
        by smtp.gmail.com with ESMTPSA id z1sm17879369wrp.62.2021.01.31.04.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 04:54:47 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1611942122-83391-1-git-send-email-haoxu@linux.alibaba.com>
 <1611942813-89187-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io_uring: check kthread parked flag before sqthread
 goes to sleep
Message-ID: <69b64dc4-7201-ba05-748c-901a9a1069f7@gmail.com>
Date:   Sun, 31 Jan 2021 12:51:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1611942813-89187-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 29/01/2021 17:53, Hao Xu wrote:
> 
> So check if sqthread gets park flag right before schedule().
> since ctx_list is always empty when this problem happens, here I put
> kthread_should_park() before setting the wakeup flag(ctx_list is empty
> so this for loop is fast), where is close enough to schedule(). The
> problem doesn't show again in my repro testing after this fix.

Looks good, and I believe I saw syzbot reporting similar thing before.
Two nits below

> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c07913ec0cca..444dc993157e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7132,6 +7132,9 @@ static int io_sq_thread(void *data)
>  			}
>  		}

How about killing btw a kthread_should_park() check few lines
above before prepare_to_wait? Parking is fairly rare, so we
don't need fast path for it.

>  
> +		if (kthread_should_park())
> +			needs_sched = false;
> +
>  		if (needs_sched) {

if (needs_sched && !kthread_should_park())

Looks cleaner to me

>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				io_ring_set_wakeup_flag(ctx);
> 

-- 
Pavel Begunkov
