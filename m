Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC826357465
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 20:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhDGSdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 14:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbhDGSdA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 14:33:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED998C06175F
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 11:32:50 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id y18so2904765wrn.6
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 11:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xmr8NmDsLdw/GrOaZulE5xkj4xDATYZ8daZlxmnmSIY=;
        b=EmxD81md4mUv2yC5pzsFoAqbKjJ2W3gkfBy8CqJ/AtIgbCdf02WU4t/JphlnIAxafB
         Uh/s7dVYJ9HFbaN0GTpv1SPyI2xN7gUB76IlAsHnwZfsfGwgarjSZJxSLHZiwtM9tXmT
         qbMX75xS1z0CxzQETpznQZ3jL5tk2F5mVflgsdNbyhF7CErqzG+4L0G79FCXL1+cZ1g0
         xZdgBVXueH2/nUjCQPxIZtcO7rK7wX84ckBE6F88nmYk1GTbt/XZGO0r1RP+qrUCEA0x
         LCemjK2xAo2DUBTe7XSjPrLaVLc1YzTuih3G8WTWMPY0FmbS9YltB0TizLyH8L3XIZk/
         v2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Xmr8NmDsLdw/GrOaZulE5xkj4xDATYZ8daZlxmnmSIY=;
        b=ELKEbI48IDEhwSBu48UvuyHa6nBu4laBHcGqVfwbGYABoOUQaEcSz6JzDene3PhqSl
         8nivyhtov9eWztnTWWEetKAKc7DVQqNWUomH175SwqS+lXWyrzwgaN0Y2T/UyRL88TDN
         o1VRpbWUpgTByi0hUV2ORBzg+iieNc2pSsd8II+koL3zr3D+VUQVL14OTMcPudb8YwTB
         nJWonCV/gY11HKVycQB1/B+sPpSoCNeScWr6d3jJARWm3We6HfNL5cMULIfz0ynneyr/
         RtxN8XCKLtVBd6hZnzMGYX6Y7NCJdi6HQtxLcq5u7uLsDMrsZLQcRqCW5NV6iFAqAf3F
         Qbig==
X-Gm-Message-State: AOAM532ioXM3sQ4yol6P1cPUf/Z5EID0JlDij41wUzgsMPRGQIcHYN7E
        RkaMAg6tACdONSEP9Lw1fK4=
X-Google-Smtp-Source: ABdhPJxiECtot0AYPMmzfOuR5Fh+KqfH8d0XXuvkaY8UohdSF34i0KzdapKbPAG/F19rnNnnW6PM9w==
X-Received: by 2002:adf:c3c7:: with SMTP id d7mr5926581wrg.285.1617820369712;
        Wed, 07 Apr 2021 11:32:49 -0700 (PDT)
Received: from [192.168.8.146] ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id j30sm45101463wrj.62.2021.04.07.11.32.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 11:32:49 -0700 (PDT)
Subject: Re: [PATCH v4] io-wq: simplify code in __io_worker_busy
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
 <1617678525-3129-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a29b8d8a-6295-6c73-2cb9-0939a480be9e@gmail.com>
Date:   Wed, 7 Apr 2021 19:28:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1617678525-3129-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/04/2021 04:08, Hao Xu wrote:
> leverage xor to simplify code in __io_worker_busy
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Sorry, typo by mistake...
> 
>  fs/io-wq.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 2dd2d4b1e538..fa2383cb4d50 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -329,6 +329,8 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
>  {
>  	bool worker_bound, work_bound;
>  
> +	BUILD_BUG_ON((IO_WQ_ACCT_UNBOUND ^ IO_WQ_ACCT_BOUND) != 1);
> +
>  	if (worker->flags & IO_WORKER_F_FREE) {
>  		worker->flags &= ~IO_WORKER_F_FREE;
>  		hlist_nulls_del_init_rcu(&worker->nulls_node);
> @@ -341,16 +343,11 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
>  	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
>  	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
>  	if (worker_bound != work_bound) {
> +		int index = work_bound ? IO_WQ_ACCT_UNBOUND : IO_WQ_ACCT_BOUND;

Jens, if you'll be at it, can you fold in \n here?
Let's keep static analysis happy

>  		io_wqe_dec_running(worker);
> -		if (work_bound) {
> -			worker->flags |= IO_WORKER_F_BOUND;
> -			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers--;
> -			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers++;
> -		} else {
> -			worker->flags &= ~IO_WORKER_F_BOUND;
> -			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers++;
> -			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers--;
> -		}
> +		worker->flags ^= IO_WORKER_F_BOUND;
> +		wqe->acct[index].nr_workers--;
> +		wqe->acct[index ^ 1].nr_workers++;
>  		io_wqe_inc_running(worker);
>  	 }
>  }
> 

-- 
Pavel Begunkov
