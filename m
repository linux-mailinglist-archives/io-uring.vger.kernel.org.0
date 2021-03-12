Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA6B339790
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 20:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhCLTkk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 14:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbhCLTk2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 14:40:28 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55860C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 11:40:28 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id s7so12407626plg.5
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 11:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QHph+XIQaS4grdUjhlakcrSu/7QgB06d9IZ0Bd4rKEM=;
        b=EXbVEcDZlMdOQraKqdCqchRyos+OW++GyRsXNpR3Y3RwNBM096G/fSpXslSd212wm+
         xn931ZMTQu75zZHie+VjiXH/5TgkQ7bQotQjKdQFnvZBQUkLq8ogy5QTKvj39KydXeXp
         1msRTmBg33XrZ0LQ81zAvfEXN+y1OfkuBFcWW/vJXKxEtuOEiYPtGfuG/UjgWto+6gvy
         dYLac5CCY6x0w8r0jQx716EaCXLBRbk0ZCJx0sGs4MN2bvM9tlJDQUm/CqGuMGQ0pgi2
         vI07cKNtemaxn/ikKP9Fc1AVfeOu6y9hoctNJO4XyE3azMUrGbdJcEgVl+aYcU8yaFc3
         5Wxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QHph+XIQaS4grdUjhlakcrSu/7QgB06d9IZ0Bd4rKEM=;
        b=r6JciqJ4nKQW0TlaOmag1/TdkSxLiifQWEnD/mSxRem4//Weti+XqlWQ7cXR0xWbOc
         Mcq229rlz77al04Gy2dPXZiDFE+f0W4aA+iXcVQ5biM5MONm/N21n1uxzLwcd3u3c8Jm
         BKY0JOExevE1P5QSTB/dl1PV+3AlqT+E7ihj2RUYsbxDT/JceSk/Zf/gTMBdg/4H8dD7
         0kmTpPG8PjRYo7/zBPBuNIUpox97oXuE842x5JmQ9WzR68LQG1J/Diug0WnQ6ycx7wtT
         aBdnIz4srxeQL9Z/nbLabeYz4SYGhMAV1cmcK66hcHRs4CZa+xdU3XxNTw2M5UuDrQTX
         svuw==
X-Gm-Message-State: AOAM531lzkIEE+5mBpBdaU8VdhVs6U+w17unS8a4/mW+R183xFY/sW5E
        aTpy3UxWzCZOEqQk72fI6W/C0qZ1uzCfWg==
X-Google-Smtp-Source: ABdhPJynFufq7fGcpCY4bqzxoSN3tqkKrQ+SsCq0IRTlHuFjAr8Z6iP3rL4GGMNEy5uVu5C/cWmjrw==
X-Received: by 2002:a17:90a:d41:: with SMTP id 1mr6801814pju.232.1615578027437;
        Fri, 12 Mar 2021 11:40:27 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x2sm211735pga.60.2021.03.12.11.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 11:40:27 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: cancel sqpoll via task_work
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615504663.git.asml.silence@gmail.com>
 <6501248c79d9c73e0424cb59b74c03d72b30be62.1615504663.git.asml.silence@gmail.com>
 <d7515d66-0ac7-ce48-7194-00e8bde0595b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86c120c4-cc2b-d19b-d0c9-42fc27aae749@kernel.dk>
Date:   Fri, 12 Mar 2021 12:40:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d7515d66-0ac7-ce48-7194-00e8bde0595b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 12:35 PM, Pavel Begunkov wrote:
> On 11/03/2021 23:29, Pavel Begunkov wrote:
>> 1) The first problem is io_uring_cancel_sqpoll() ->
>> io_uring_cancel_task_requests() basically doing park(); park(); and so
>> hanging.
>>
>> 2) Another one is more subtle, when the master task is doing cancellations,
>> but SQPOLL task submits in-between the end of the cancellation but
>> before finish() requests taking a ref to the ctx, and so eternally
>> locking it up.
>>
>> 3) Yet another is a dying SQPOLL task doing io_uring_cancel_sqpoll() and
>> same io_uring_cancel_sqpoll() from the owner task, they race for
>> tctx->wait events. And there probably more of them.
>>
>> Instead do SQPOLL cancellations from within SQPOLL task context via
>> task_work, see io_sqpoll_cancel_sync(). With that we don't need temporal
>> park()/unpark() during cancellation, which is ugly, subtle and anyway
>> doesn't allow to do io_run_task_work() properly.> 
>> io_uring_cancel_sqpoll() is called only from SQPOLL task context and
>> under sqd locking, so all parking is removed from there. And so,
>> io_sq_thread_[un]park() and io_sq_thread_stop() are not used now by
>> SQPOLL task, and that spare us from some headache.
>>
>> Also remove ctx->sqd_list early to avoid 2). And kill tctx->sqpoll,
>> which is not used anymore.
> 
> 
> Looks, the chunk below somehow slipped from the patch. Not important
> for 5.12, but can can be folded anyway
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 9761a0ec9f95..c24c62b47745 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -22,7 +22,6 @@ struct io_uring_task {
>  	void			*io_wq;
>  	struct percpu_counter	inflight;
>  	atomic_t		in_idle;
> -	bool			sqpoll;
>  
>  	spinlock_t		task_lock;
>  	struct io_wq_work_list	task_list;

Let's do it as a separate patch instead.

-- 
Jens Axboe

