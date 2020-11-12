Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0542B0964
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 17:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgKLQDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 11:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgKLQDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 11:03:05 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B64C0613D1
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 08:03:04 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id s24so6510368ioj.13
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 08:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x+21BSVBqYlcrUZe+IYRT9S03a9Y4yIXErcXm5ThrQo=;
        b=XzB8h/OaPMl2PrZyHYlPcZ1hFlrXIVD6jbC8jBn0Mhq3UjLPYqBYHuV6vhS9CA3lRk
         8nUlpS36BTOABGxV2Ia7uJmZ98lnbWO4XLsfNsbjJQqjrAo2Ds3rjCNRtBdV7SCM6eM1
         /xFsu2QMuG5K9HXEMYGqKlBi+VdU/rU9QOMvnvwyQlVOsYt7Vm3VN4FaVn0GReJnUc6K
         Pftk/xpSN384x0hxM4CVUrr5KfDJ0ivQckkE5DkRtpeOnEyrA9ixSLcIfO5J8vkJzXnD
         5ntV6pwEj0wYtuXyNoLiHEUvaiVfPwEQOYosslHJsiFVn2pjS3hRdrf+44mADeWAE3GE
         siaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x+21BSVBqYlcrUZe+IYRT9S03a9Y4yIXErcXm5ThrQo=;
        b=UKCGyn7zFpswltKczvWnaDy57EcfUXGtlqCH5xqOJoR2TPk4/XWhUs877ZSJ2aM0M7
         CzZYjmddUjd52La9Wg25r28wLiulMuMmfF9csFYpB3qCZeKDd1CpIwJdZ5sfEShtMS0G
         kHVY49Jxe/V6gter5Fe884e0dJu9r6KwlbRnhXKgq2ERQabpUXKArEFjfSXt15dk3QGj
         PTqPoxzoic8IAMcC6cg6N3wEi2H+XDcDv6ra1lWzXgO3swlcGIdYFnHz/MjXUaUiS80j
         lYDWPjBMm250mafqc00/mmqiy5vKJYuXePiExfNSBRAnyY3lIoO0hytHwKW51L/xNMMJ
         +1AQ==
X-Gm-Message-State: AOAM53301u9sl1JfFhAl+f+wdF3GRcUHvTtmmTY82Fcq+FpmTVVZFaFD
        KQnLUkxxaphZrjlDavqQiI2jWMzaLNhYaQ==
X-Google-Smtp-Source: ABdhPJxoq96wacWCV5ntuUjj096gIBH768mCLj2+GzcSNYF6s2FMzHYuQWFDDGKm28yPPvfHgM7fFw==
X-Received: by 2002:a5d:85ce:: with SMTP id e14mr1468944ios.166.1605196983718;
        Thu, 12 Nov 2020 08:03:03 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c3sm3373428ila.47.2020.11.12.08.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 08:03:03 -0800 (PST)
Subject: Re: [PATCH] io_uring: only wake up sq thread while current task is in
 io worker context
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201112115328.17185-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7c35efb-85d2-80e4-f834-b649b013cece@kernel.dk>
Date:   Thu, 12 Nov 2020 09:03:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112115328.17185-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/12/20 4:53 AM, Xiaoguang Wang wrote:
> When IORING_SETUP_SQPOLL is enabled, io_uring will always handle sqes
> in sq thread task context, so in io_iopoll_req_issued(), if we're not
> in io worker context, we don't need to check whether should wake up
> sq thread. io_iopoll_req_issued() calls wq_has_sleeper(), which has
> smp_mb() memory barrier, perf shows obvious overhead:
>   Samples: 481K of event 'cycles', Event count (approx.): 299807382878
>   Overhead  Comma  Shared Object     Symbol
>      3.69%  :9630  [kernel.vmlinux]  [k] io_issue_sqe
> 
> With this patch, perf shows:
>   Samples: 482K of event 'cycles', Event count (approx.): 299929547283
>   Overhead  Comma  Shared Object     Symbol
>      0.70%  :4015  [kernel.vmlinux]  [k] io_issue_sqe
> 
> It shows some obvious improvements.

Looks good to me, but:
  
> @@ -2761,7 +2761,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
>  	else
>  		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
>  
> -	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
> +	if (in_async && (ctx->flags & IORING_SETUP_SQPOLL) &&
>  	    wq_has_sleeper(&ctx->sq_data->wait))
>  		wake_up(&ctx->sq_data->wait);
>  }

This really needs a comment as to why we don't have to check and wake
from this path.

-- 
Jens Axboe

