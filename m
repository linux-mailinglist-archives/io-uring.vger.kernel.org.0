Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5CD4A880E
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 16:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbiBCPxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240748AbiBCPxD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:53:03 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE843C061714;
        Thu,  3 Feb 2022 07:53:02 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id e8so5974710wrc.0;
        Thu, 03 Feb 2022 07:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=L4MH3mEGIpUqAyk+yeIpQJQrYpBhpCsBQ0WbxAp18o0=;
        b=D4CZ7b5pktdL8Fq4Wy0IN9cCGEuDBAFbncb8snMSZ9ZJF1aaI6wO8aeofH0zzMPf0q
         cfPr5Sx2zFb9l3tiemZlKQL79SnKUxGXMKYpx2tNeZS92wEvAtI3h0FI2ReL7JtILk4K
         yG8C0lFZAN5002jQJjzdlJ77ba4v7zbevGYwQbtSpcDO69K5mwl/hHQbXFUSPU5TLMW/
         QQbcK5Xp9SfTCAEqhLSqX538NeglUw9BnWO1DhZ63Zi4lropWN6syOa+4biBE2f59gPy
         3p6dS2SXmY/s/8pEZqowM6ratizJ//nk8uggYtkhhoM+8yCbc8t73AFe801K0NQktiL5
         y/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L4MH3mEGIpUqAyk+yeIpQJQrYpBhpCsBQ0WbxAp18o0=;
        b=gCLadajg8SDHNdR81v1zSm5wTu0POHvKzEb/g6mpSkMH+/xvjW5e9QBOsmtGlZupox
         sWNCkXbU9WxRRs2tMTKQmcIYg65DaDfps3DUoiCSjheCyLaxjnl5pLxH+Xy12ZkM2Rrg
         ouIJ4RtrJB4bOsfEdKU5U0hrNjATduaLkFZYRz5BK+smvnAzl2vmiLUANjPGfk4wLsT/
         escKduPKMgcmGOVcVUnYtdTV3uzMOqdQfdAJf+tdUG7DlH9IAYJvERr3NAQ7QJZ/DuQg
         dWYVqV32bSBtVLrwSyoQhpSwOypSWnrt1rAmLV75KaYjd77OZn8S3cns3N3LaN+fQdQB
         hJOw==
X-Gm-Message-State: AOAM533Btsj+ygogKHwtOEtB5ZBxC5P8SzYNuVv4BfEJOSY9cFY+03ES
        DyFqli7ezb/Wkx6qdtsSH+x33E+Mxjo=
X-Google-Smtp-Source: ABdhPJxu0158ZLJZgaexjlGDyXNLWjuoedQvcQCXz5bXogN0zjC5jehel87iuPEmXXfQWmWL9trY4w==
X-Received: by 2002:a5d:64e5:: with SMTP id g5mr22342848wri.541.1643903581560;
        Thu, 03 Feb 2022 07:53:01 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id d2sm20240691wru.40.2022.02.03.07.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 07:53:01 -0800 (PST)
Message-ID: <f8ff62bf-4435-5da3-949a-fd337a9dfaf7@gmail.com>
Date:   Thu, 3 Feb 2022 15:48:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203151153.574032-1-usama.arif@bytedance.com>
 <20220203151153.574032-2-usama.arif@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220203151153.574032-2-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 15:11, Usama Arif wrote:
> This is done by creating a new RCU data structure (io_ev_fd) as part of
> io_ring_ctx that holds the eventfd_ctx.
> 
> The function io_eventfd_signal is executed under rcu_read_lock with a
> single rcu_dereference to io_ev_fd so that if another thread unregisters
> the eventfd while io_eventfd_signal is still being executed, the
> eventfd_signal for which io_eventfd_signal was called completes
> successfully.
> 
> The process of registering/unregistering eventfd is done under a lock
> so multiple threads don't enter a race condition while
> registering/unregistering eventfd.
> 
> With the above approach ring quiesce can be avoided which is much more
> expensive then using RCU lock. On the system tested, io_uring_reigster with
> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
> before with ring quiesce.
> 
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>   fs/io_uring.c | 103 +++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 80 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2e04f718319d..f07cfbb387a6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -326,6 +326,12 @@ struct io_submit_state {
>   	struct blk_plug		plug;
>   };
>   

> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
> +static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx, struct io_ev_fd *ev_fd)
>   {
> -	if (likely(!ctx->cq_ev_fd))
> +	if (likely(!ev_fd))
>   		return false;
>   	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>   		return false;
>   	return !ctx->eventfd_async || io_wq_current_is_worker();
>   }
>   
> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
> +{
> +	struct io_ev_fd *ev_fd;
> +
> +	rcu_read_lock();

Please always think about the fast path, which is not set eventfd.
We don't want extra overhead here.

if (ctx->ev_fd) {
	rcu_read_lock();
         ev_fd = rcu_deref(...);
         ...
         rcu_read_unlock();
}

-- 
Pavel Begunkov
