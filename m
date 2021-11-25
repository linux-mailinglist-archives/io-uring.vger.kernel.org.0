Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1308F45DCB8
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 15:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355838AbhKYOyV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 09:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355859AbhKYOwV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 09:52:21 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75582C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:47:39 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id b12so12202210wrh.4
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ypFnZ9/MANQhwsLmJZWOieoDv6+6itZR1e9CfVQl7vo=;
        b=j8bD5Un147m2OyayKwh3r+k7qlRRgAooXv+11myoYCEsRDF0eswOSXNNrsM+qu93qL
         Bwa5idOgeekyQSHKoVF7Q2TmH+72WpoM2c12pQ1kDk0jdqoJLsnTyVUdguIu81cI+/Wz
         xBOrQq8UWA0j4/TzUidSM6sHEAiKoru5FD2ZWf0vgkzgrSpWp9YiPuBIgW80AztvNIaY
         NBPSqfoXl+3rB7ucLR0sPs+Nhiw40KFdW5iOcxXcJILd9Z5HnIuSDmLm5ORxUHuT0E1I
         oPn/e6SF6VGKSbMxDLbt4DZurXS2RQVPzokQb79LACFXO4HCo5OR7v33nfzHpszQsX9+
         wwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ypFnZ9/MANQhwsLmJZWOieoDv6+6itZR1e9CfVQl7vo=;
        b=JeJxYciEWxUVG69Ajl4ZxLA9kz8wpOcIVTpt+w3UnJqCdHyjEWBIel5L2WVVEVvmtJ
         hPy81aTcMV2ktewpw++0HU4+RdzZFMep5yQH4DjU5/RfGOPynxQGXac2RmR7czn9fThk
         ruyot9sqyTqMMlIjkLxiuq0hFDwYU/jIEu3pAQn6/iJWMLk5zTTpXb/L1Rhi3P+wcZTQ
         kJtU8tTzVIzmWGBbalcPv7O5t/kHZRdDe4kDcER/IOAXkiEqH+qxlVFhF0iqfOSiUSW0
         h1eyMppOGkZzPTIzP+Hf3DrflnmfUTbyRJtziZlIh/y9Pu0k0pdda7r5EN3KkK91XoO2
         3QWQ==
X-Gm-Message-State: AOAM531sPqn1oYY/FhmVtJEGD8WnyUxGwsMZH/qpdgJKQF5J/gL4wi5H
        MBTBS4Pi+USYPSzo0ttTuLc=
X-Google-Smtp-Source: ABdhPJx8f+YBji5EzSGQYwG3xc6d3eaPIE9QoGPyJ3tK0pzkdQSHwvg/q1aX7nOzDzSmtZy/4Ny6zw==
X-Received: by 2002:a5d:66cb:: with SMTP id k11mr7189357wrw.253.1637851658074;
        Thu, 25 Nov 2021 06:47:38 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id r83sm8171829wma.22.2021.11.25.06.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 06:47:37 -0800 (PST)
Message-ID: <6905b2e7-bd27-fb74-da64-ed02123e427d@gmail.com>
Date:   Thu, 25 Nov 2021 14:47:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 3/9] io-wq: update check condition for lock
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
 <20211124044648.142416-4-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211124044648.142416-4-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 04:46, Hao Xu wrote:
> Update sparse check since we changed the lock.

Shouldn't it be a part of one of the previous patches?

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io-wq.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 26ccc04797b7..443c34d9b326 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -378,7 +378,6 @@ static bool io_queue_worker_create(struct io_worker *worker,
>   }
>   
>   static void io_wqe_dec_running(struct io_worker *worker)
> -	__must_hold(wqe->lock)
>   {
>   	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>   	struct io_wqe *wqe = worker->wqe;
> @@ -449,7 +448,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
>   
>   static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
>   					   struct io_worker *worker)
> -	__must_hold(wqe->lock)
> +	__must_hold(acct->lock)
>   {
>   	struct io_wq_work_node *node, *prev;
>   	struct io_wq_work *work, *tail;
> @@ -523,7 +522,6 @@ static void io_assign_current_work(struct io_worker *worker,
>   static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
>   
>   static void io_worker_handle_work(struct io_worker *worker)
> -	__releases(wqe->lock)
>   {
>   	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
>   	struct io_wqe *wqe = worker->wqe;
> @@ -986,7 +984,6 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
>   static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
>   					struct io_wqe_acct *acct,
>   					struct io_cb_cancel_data *match)
> -	__releases(wqe->lock)
>   {
>   	struct io_wq_work_node *node, *prev;
>   	struct io_wq_work *work;
> 

-- 
Pavel Begunkov
