Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDC13B0BE6
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFVR5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 13:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVR5W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 13:57:22 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225FCC061574;
        Tue, 22 Jun 2021 10:55:05 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nd37so35891332ejc.3;
        Tue, 22 Jun 2021 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KSXjx7PRiNt3XduVl93AmUJtxfhvnhuoaCB1HZWKmnc=;
        b=Bidbwj3CGzT5t2FWODJvbz2Y8P1Rupv5wK/arJZzZo9pgBxdFp53tchPoJ6GK3OgBC
         nyrcJGpuKeKNo9+t6HM0hLuPTyvBsafFwXIX6OkbcJwmRf3m7aKVDfDb8NVAxLQwt7Tq
         5gF+E0AFoJ9dVuzE6AGwQxjxBw0QdD779zz+T5ZhKLUhaD2FJljhY6tcQrhgo4gu/pUL
         AJDOPnL3rCvP8ja4ic2tkY127pXYlEIR+dxRqJfmVx4FzlExW8k/qhHcFVYfL1Z1iR3G
         8NqsVaI1ViliSE6//WBsmcupoBlmDj1HhvM+7HfXGUC4DQh422nG+pltVGaOYkmU8TT/
         vB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KSXjx7PRiNt3XduVl93AmUJtxfhvnhuoaCB1HZWKmnc=;
        b=m+DDkU+mCd38foSEGOXpK3E6hw2EftpF87cdIwEihSMW0VSi+I4BQFv+wPkyqmvkh3
         NjB7LNdgBbpt1t8GomyHEIo4pamWuHxBpj0wVyR1YqtQZ5lYts3+gcAy8WEjJ2Ajm8pO
         Iv7NxeIo2iLVbqMCw1iPRnwokc0p/sDJZvLp56XzKr/ZsoCB3ZYkryhKTzF0dr+QqXqe
         Le4fPwCtOApKRriwBEdDc3Tuj+3H0sJXnhfVbo64eL+eeaNLFxtkQD//SPE8/feDtCvI
         wH+C2MB8ZL2cDWws8Ikol1qOaWARSZTeMlVeNRCBA8wf2A3G7uRYZKSrmxPM38atnlxA
         R1MQ==
X-Gm-Message-State: AOAM531rkt9/IGxEHpuAOzJs7xQ8Ix9t/EHDRYyYMPj+VvT5HKvH1HJo
        kbhhNkyZPU7XRqPvcfJNUeWtoXgWKwcfg37w
X-Google-Smtp-Source: ABdhPJwquXT4sEhi2ldQxEu0urYrUs6HA3bcnq+Dd4KHDJkSLjr+dDdF19cqg3fylWYudAW8ZugFhg==
X-Received: by 2002:a17:907:d03:: with SMTP id gn3mr5378466ejc.516.1624384499159;
        Tue, 22 Jun 2021 10:54:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:9d6e])
        by smtp.gmail.com with ESMTPSA id w2sm6283394ejn.118.2021.06.22.10.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:54:58 -0700 (PDT)
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <678deb93-c4a5-5a14-9687-9e44f0f00b5a@gmail.com>
Date:   Tue, 22 Jun 2021 18:54:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 1:17 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.
> 
> Performance improvement testing has been performed with:
> Single thread, 1 TCP connection receiving a 5 Mbps stream, no sqpoll.
> 
> 4 measurements have been taken:
> 1. The time it takes to process a read request when data is already available
> 2. The time it takes to process by calling twice io_issue_sqe() after vfs_poll() indicated that data was available
> 3. The time it takes to execute io_queue_async_work()
> 4. The time it takes to complete a read request asynchronously
> 
> 2.25% of all the read operations did use the new path.
> 
> ready data (baseline)
> avg	3657.94182918628
> min	580
> max	20098
> stddev	1213.15975908162
> 
> reissue	completion
> average	7882.67567567568
> min	2316
> max	28811
> stddev	1982.79172973284
> 
> insert io-wq time
> average	8983.82276995305
> min	3324
> max	87816
> stddev	2551.60056552038
> 
> async time completion
> average	24670.4758861127
> min	10758
> max	102612
> stddev	3483.92416873804
> 
> Conclusion:
> On average reissuing the sqe with the patch code is 1.1uSec faster and
> in the worse case scenario 59uSec faster than placing the request on
> io-wq
> 
> On average completion time by reissuing the sqe with the patch code is
> 16.79uSec faster and in the worse case scenario 73.8uSec faster than
> async completion.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fc8637f591a6..5efa67c2f974 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c

[...]

>  static bool __io_poll_remove_one(struct io_kiocb *req,
> @@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>  	int ret;
>  
> +issue_sqe:
>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>  
>  	/*
> @@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  			io_put_req(req);
>  		}
>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
> -		if (!io_arm_poll_handler(req)) {
> +		switch (io_arm_poll_handler(req)) {
> +		case IO_APOLL_READY:
> +			goto issue_sqe;
> +		case IO_APOLL_ABORTED:
>  			/*
>  			 * Queued up for async execution, worker will release
>  			 * submit reference when the iocb is actually submitted.
>  			 */
>  			io_queue_async_work(req);
> +			break;

Hmm, why there is a new break here? It will miscount @linked_timeout
if you do that. Every io_prep_linked_timeout() should be matched with
io_queue_linked_timeout().


>  		}
>  	} else {
>  		io_req_complete_failed(req, ret);
> 

-- 
Pavel Begunkov
