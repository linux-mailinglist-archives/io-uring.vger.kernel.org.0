Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7C13A807D
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhFONke (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 09:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhFONju (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 09:39:50 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF75AC061280;
        Tue, 15 Jun 2021 06:37:42 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id y7so18368800wrh.7;
        Tue, 15 Jun 2021 06:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WvejBb7soWFLyesjzzMqLYg5v4yiPo+2THvt1OF5cEM=;
        b=Z1psfP9mEuoAKWaXTcZUZGKsR873PLGtZ9ZuS0HTjzIh85pfeDTaOMzl4WgDrL9Ks+
         yJTnvRrqv/pLYROL2BUtLI+WrFLGjSZLZi2GSyxJISEFJw5W8jOA88VaNIjxpyTb8cEX
         wiHIweFVSlYFAP8tfrdxtnxt0Dw44w19SO8SDRQSmqMVJmFxn5I4rGROcrZWRo6CCHH9
         WJD/xwEi4hLIjtawOt5LGE20LMfofOi2fwjZsat9h9AY8J0a9JyFt4N8aqAtiBb0jqJQ
         /DurASBxlD4dd/rdzC+vlW/aI07ZqlPlLVqzrmV/WPixK12t7PAhfK+TBr0fjRfNHpQ2
         fc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WvejBb7soWFLyesjzzMqLYg5v4yiPo+2THvt1OF5cEM=;
        b=qLw8jIBvqBEgqnjveAtIFCggaEeqA+PXTtwM4x8isusVvOGz/N+QoB1cTB6IhDPrbw
         dLdieaMxN0cSHIhMZ67AahfatyC5cIJFeti2/ZKYOOCMP6s6/QizgrzPUjbKwocs1eFL
         N6nPORVK9Eh2xJuolfN8qXPIBrm6mkIztZw5TZ1V63/k8+o44Z5e7mSnwAhSxC3FU8of
         EtIpBWfQDLeWf65s2+Hwg/aWgr83BmMwP/puPG5LLTaZN6qb9XBZVb2xzX76U/WRpW3O
         //n9eCqmeLzb0Km9J/wK0O9Wa+o8yFNHi87AOl4XtB3lpPH9gK3o1DK3arttUMAwZv8R
         mFIw==
X-Gm-Message-State: AOAM530xStLyXtLpV8W1TQpgQjcSLLHLq1aFCXNiS9BI2wYHU3qKmL5b
        m51nP8byPbP9K0l/xP4HwxGfjDmZyOqfXdjs
X-Google-Smtp-Source: ABdhPJxoH8a6wyINgazM0d7JbtU2LGkvXDqkvHIYLkP3Dt+/U9CTi8msXiNTw/Q5hDezm0rbiezxuw==
X-Received: by 2002:a5d:48ca:: with SMTP id p10mr25367599wrs.87.1623764261167;
        Tue, 15 Jun 2021 06:37:41 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id z5sm19804632wrv.67.2021.06.15.06.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 06:37:40 -0700 (PDT)
Subject: Re: [PATCH -next] io_uring: Remove unneeded if-null-free check
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210602065410.104240-1-zhengyongjun3@huawei.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f0c13c14-f036-594a-7e5b-356eb6adceaf@gmail.com>
Date:   Tue, 15 Jun 2021 14:37:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210602065410.104240-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/21 7:54 AM, Zheng Yongjun wrote:
> Eliminate the following coccicheck warning:
> 
> fs/io_uring.c:6056:4-9: WARNING: NULL check before some freeing functions is not needed.
> fs/io_uring.c:1744:2-7: WARNING: NULL check before some freeing functions is not needed.
> fs/io_uring.c:3340:2-7: WARNING: NULL check before some freeing functions is not needed.
> fs/io_uring.c:4612:2-7: WARNING: NULL check before some freeing functions is not needed.
> fs/io_uring.c:4375:2-7: WARNING: NULL check before some freeing functions is not needed.
> fs/io_uring.c:3441:2-7: WARNING: NULL check before some freeing functions is not needed.

Take a look at the comments right above changed lines.

> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  fs/io_uring.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
[...]
>  	/* it's reportedly faster than delegating the null check to kfree() */
> -	if (iovec)
> -		kfree(iovec);
> +	kfree(iovec);
[...]

-- 
Pavel Begunkov
