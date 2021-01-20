Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7602FC915
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbhATDfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731932AbhATC3a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:29:30 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3644BC06179B
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:29:01 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 7so14348427wrz.0
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6/HUceZM/wHwYiRM0HAS3aBL/W3aTdMl0firuskkEbA=;
        b=N6ABEn1/6LJbwJwuXhmMy9GwwO6zj2bJcmzGzypln9rA1Jyoc+0QQF3No1hG0F+Y1L
         TcIgqs/Y69NhptXki/AIpEg1bIKSNs6ZpOoYRNjFqGkSVHim2EFFAWbn1DHDNHIS5yxn
         CFjlh9wkWzOsxVzrmsQsFZYjAEpjD6uxtHWCa8zPv9pNK6NTVWZ9ymD+BhmE9DRh75U8
         7Wyjk6qHqHJHdylx3tYUEjAT7s+G3WX+5sdJ4/VthtV/wA9tHYvUJrom0ldwuMtjnLL8
         IYKhiU2+5yO8p1MUkqObYWuaKr9mbGcA1OlI8v0l1WkOgAAcQelkW0SXcNZ/sQOoMK1k
         9kiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6/HUceZM/wHwYiRM0HAS3aBL/W3aTdMl0firuskkEbA=;
        b=jfcyFORIkh3asDXA1knfBezuzAxxucdAYjSZQOKAQ9TAG/pEw1erc7rAAWWkZs9deJ
         pAfjUDmXNDXK24toNIBG+pgykWPsPm5CrV0rGo7eEScGrwY81UEfxRbEx2+J51kituNd
         zoq5Zhml4P4euNDpctvMfcowbTnlEKKoQbzF6Gy6tAjhriIAkN532FsPwM2ZE27rhiq0
         f+9GO+cdjrxUk4WVHBX1MjEzOnhZsL/LEs+d0bEwY/F9U/C14AFLWQhj7D3tTfj2X0JP
         HtQm0MlEovq1hum/zdwJITyyBGDhxhVFwoiyyx8ejclouJEX2jmM5ZihTaNgs1TPpmHV
         +qjQ==
X-Gm-Message-State: AOAM5304YDCDtqeADYx7kf7UayB/wnAEpsBeG4yRUzQlj165pvJ90oZc
        rQpWdr93ioL6KE44wCKQh7yNepBbFv0Zuw==
X-Google-Smtp-Source: ABdhPJzj/xqODvIzJy3/GiQr4fsRmCwf2VBkHOvXLAgrEYRFaTsMWw8rRpzgccrV5UyKUdVRPOOqNg==
X-Received: by 2002:adf:9b92:: with SMTP id d18mr734797wrc.170.1611109740009;
        Tue, 19 Jan 2021 18:29:00 -0800 (PST)
Received: from [192.168.8.137] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id n9sm988755wrq.41.2021.01.19.18.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 18:28:59 -0800 (PST)
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <e1617bdf-3b4f-f598-a0ad-13ad68bb1e42@kernel.dk>
 <7c176c50-0f62-6753-eeef-bbb7a803febf@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state
Message-ID: <6faaeee6-c8f1-b0c4-ef07-fc1bd8b9d87f@gmail.com>
Date:   Wed, 20 Jan 2021 02:25:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7c176c50-0f62-6753-eeef-bbb7a803febf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/01/2021 02:07, Joseph Qi wrote:
[...]
>> Fix this by moving the IO_WQ_WORK_NO_CANCEL until _after_ we've modified
>> the fdtable. Canceling before this point is totally fine, and running
>> it in the io-wq context _after_ that point is also fine.
>>
>> For 5.12, we'll handle this internally and get rid of the no-cancel
>> flag, as IORING_OP_CLOSE is the only user of it.
>>
>> Fixes: 14587a46646d ("io_uring: enable file table usage for SQPOLL rings")
> 
> As discussed with Pavel, this can not only happen in case sqpoll, but
> also in case async cancel is from io-wq.

Right, and it's handled because execution-during-cancellation can't
anymore get into close_fd_get_file(), either it was already done or
we didn't yet set IO_WQ_WORK_NO_CANCEL. And blkcg is not a problem.

> 
>> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> In fact, it is reported by "Abaci <abaci@linux.alibaba.com>"
> 
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Reviewed-and-tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks!

>>
>> ---
>>
>> Joseph, can you test this patch and see if this fixes it for you?
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b76bb50f18c7..5f6f1e48954e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4472,7 +4472,6 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  	 * io_wq_work.flags, so initialize io_wq_work firstly.
>>  	 */
>>  	io_req_init_async(req);
>> -	req->work.flags |= IO_WQ_WORK_NO_CANCEL;
>>  
>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>  		return -EINVAL;
>> @@ -4505,6 +4504,8 @@ static int io_close(struct io_kiocb *req, bool force_nonblock,
>>  
>>  	/* if the file has a flush method, be safe and punt to async */
>>  	if (close->put_file->f_op->flush && force_nonblock) {
>> +		/* not safe to cancel at this point */
>> +		req->work.flags |= IO_WQ_WORK_NO_CANCEL;
>>  		/* was never set, but play safe */
>>  		req->flags &= ~REQ_F_NOWAIT;
>>  		/* avoid grabbing files - we don't need the files */
>>

-- 
Pavel Begunkov
