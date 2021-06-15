Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189FD3A7B21
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 11:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhFOJvd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 05:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhFOJvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 05:51:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0EFC061574;
        Tue, 15 Jun 2021 02:49:28 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id b205so9045473wmb.3;
        Tue, 15 Jun 2021 02:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=74oE+gbhDpwMRycRJdzxA/S4XWlMWPLO4TF0MBIvhzs=;
        b=NXbyPsgAQmEKU+ruqZe8z1gH1FmSgasJ24bC6mysJQuAuP9AbvGTDMZOltHMelbplP
         lqpgv8NuYsNdBH9ArOZMc5CvmrsnmbkGB+rV+k/U0cD0/KGIlz0+DP8uyMh8u7Qe5dYJ
         rWXBHDinz5am1SQQeslKT6O2kyRKb//T4kuI185cPpBDZKPsMZTV3Ijqew8fyTZlOI5u
         pCRR72pWinVcLLdbrpbI05hTB/PGICvWbMn8jj6MGFWacFJctLW9DwtPxH7bcpgwwwLF
         MQzPzijkO4RdMk6zcTPyVStqkWyko92pfBhbeeZNB1RQ8ulodriwAISw2iQjlRxWpv/w
         L42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=74oE+gbhDpwMRycRJdzxA/S4XWlMWPLO4TF0MBIvhzs=;
        b=RqTFp2BUhwCb2n4lfk0+R8KWS+fKPs9jJJDBkQzFlcYN4/gXSTS39dSfvMGqk5PHO0
         /ZZt7x9WefDfaTOIAZ6NvFmstlL99Fn/kjSJlK3V5YDCxrC8nZvmjjCymA3tkZme3J/c
         yQTCvApsHNr0q7/3K3xU/v8ubcXlXlX4e6p2q0VR6DX2+w9O6nHIcvrWBtSawpKehudq
         o7s8rnyQtGEzVSOATOgK+d11U9ohy+uSydT7bRBSC3msLhwsqOGXBOruWReipAXzI9U2
         2OGn2f02vPBbGtPYu4JdrhfTULkl9ZzhpB2br6PnS39NiL01ce1nic1reeIvwCdgmnW5
         AIZw==
X-Gm-Message-State: AOAM533HYRd2bNhH/srH655yqj42AEJXtdV5JNX4MKuJQp4BEM1+0CE4
        LI0qemhGou1EJGUlilgy3Gdz2RH37KgUHtdr
X-Google-Smtp-Source: ABdhPJxm1GZnWxs9t4NWbDZhnzdIu3NVmrmoUlBSEEghGLZIsg1R7SPXwZrZ4ZjilFnQLxb7iBQ9+Q==
X-Received: by 2002:a1c:2985:: with SMTP id p127mr21864320wmp.165.1623750566936;
        Tue, 15 Jun 2021 02:49:26 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id h11sm15018041wmq.34.2021.06.15.02.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 02:49:26 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] io-wq: remove header files not needed anymore
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e3b.1c69fb81.5479c.de27SMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <8e0c9485-441c-70be-7b03-b8dd15365555@gmail.com>
Date:   Tue, 15 Jun 2021 10:49:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60be7e3b.1c69fb81.5479c.de27SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/21 7:54 AM, Olivier Langlois wrote:
> mm related header files are not needed for io-wq module.
> remove them for a small clean-up.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io-wq.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index b3e8624a37d0..9fc89482f0de 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -9,8 +9,6 @@
>  #include <linux/init.h>
>  #include <linux/errno.h>
>  #include <linux/sched/signal.h>
> -#include <linux/mm.h>
> -#include <linux/sched/mm.h>
>  #include <linux/percpu.h>
>  #include <linux/slab.h>
>  #include <linux/rculist_nulls.h>
> 

-- 
Pavel Begunkov
