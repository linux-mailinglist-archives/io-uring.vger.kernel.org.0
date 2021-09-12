Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D2B408250
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 01:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhILXWD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhILXWD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 19:22:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F917C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 16:20:48 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o20so6260981ejd.7
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 16:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QGAHUKasIKirxgGAjgYFlOM6v/XB5vj3ySB77IU8Wts=;
        b=jTv32x0yn6qQaaIshDttTRFuqvsqCsZdaOILI2j+754h8bairF4xOohtrvSxOTxeu4
         0Beh0PRkkBNSjducf4H/1QXfb9ufI2WBnxdfGiWMS9seZvsic2nFWJr92OWre74SSVCn
         9/EP7/ZJZSz779sRIg+CwlQnydywB/TcW8Ropc6xXiPNRAYfftpuhnaRRLCUK+/g73w9
         U1gtBzb3McCJJBai56BudEwsFcE8CWq41fcEnLufPQEhOgrKYSf8AoOB8etc4k5yyC0M
         N/izMf0V99h8ldylx0otg9lSCWg0sZ32AfJtbAS1eAdWF3M0Du5YxPQyD1fLQiJRbcIH
         Dxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QGAHUKasIKirxgGAjgYFlOM6v/XB5vj3ySB77IU8Wts=;
        b=lqfLT2v3U+ZSF8PZxeIyWClgCGlUkHp6cVcsj19NYii0xUqarZXtXYBYpahWSbI37d
         6mJNz0cXl3U/HlsQaIi8/Wazvy+5wdI6Bz6+Hemx8+USUAX0qu0sVDo7UDtOgfsc+Ie9
         9XXWmd7gLpWefoKT/cAnIJ29F3+4ZScSR4qbaZzmz6N8FFq86sVi45+sh8LAMdVO5PLW
         uR9e7wrRHoyod+aljpPOZAY2IqQfppDct6jQRwYQkR4ayJrwzta+WDiQgh1Scyx+WOKO
         Jg82y6wV9H8O6McQP8TReMaI4fSmm/g1RahyfRAf1ecWCfrnycaV+aBJkq97TF0BQEKe
         zprg==
X-Gm-Message-State: AOAM531Mkuo8fP9mHk+ahl66loz/TRo1xVgR1Mzn/8qsuVNFZtt2oQ47
        VKberykEtJT4b1GE5qIvnjs=
X-Google-Smtp-Source: ABdhPJzbmaTMNDvE3xQTp2ozKiemK6HnKf9hDIslzxhViNMe6UIiwh8ba0TEZM3pW86LwVJl+9gaYw==
X-Received: by 2002:a17:906:5586:: with SMTP id y6mr9457209ejp.189.1631488846709;
        Sun, 12 Sep 2021 16:20:46 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id q11sm2954549edv.73.2021.09.12.16.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 16:20:46 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Joseph Qi <joseph.qi@linux.alibaba.com>
References: <cover.1631367587.git.asml.silence@gmail.com>
 <c1c50ac6b6badf319006f580715b8da6438e8e23.1631367587.git.asml.silence@gmail.com>
 <3099ae18-5e15-eb7d-b9b8-ddd1217f1a04@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: clean cqe filling functions
Message-ID: <57f85479-1fd5-a079-3f21-c640e0f94e0e@gmail.com>
Date:   Mon, 13 Sep 2021 00:20:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3099ae18-5e15-eb7d-b9b8-ddd1217f1a04@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 7:24 PM, Hao Xu wrote:
> 在 2021/9/11 下午9:52, Pavel Begunkov 写道:
>> Split io_cqring_fill_event() into a couple of more targeted functions.
>> The first on is io_fill_cqe_aux() for completions that are not
>> associated with request completions and doing the ->cq_extra accounting.
>> Examples are additional CQEs from multishot poll and rsrc notifications.
>>
>> The second is io_fill_cqe_req(), should be called when it's a normal
>> request completion. Nothing more to it at the moment, will be used in
>> later patches.
>>
>> The last one is inlined __io_fill_cqe() for a finer grained control,
>> should be used with caution and in hottest places.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
[...]
>> @@ -5293,13 +5297,12 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
>>       }
>>       if (req->poll.events & EPOLLONESHOT)
>>           flags = 0;
>> -    if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
>> +    if (!(flags & IORING_CQE_F_MORE)) {
>> +        io_fill_cqe_req(req, error, flags);
> We should check the return value of io_fill_cqe_req() and do
> req->poll.done = true if the return value is false, which means ocqe
> allocation failed. Though I think the current poll.done logic itself
> is not right.(I've changed it in another patch)

.done was serving a purpose for cancellations and some other places of
convenience. There is not much difference for the machinery whether we
set it here or not, because the success case doesn't do it, and in both
cases requests will be put to end. If there is a bug it will be just
triggerable with successfully emitting a CQE.

I saw the poll fixes, will be reading through later unless Jens beats
me on that and will keep them in mind when rebasing the series.


>> +    } else if (!io_fill_cqe_aux(ctx, req->user_data, error, flags)) {
>>           req->poll.done = true;
>>           flags = 0;
>>       }
>> -    if (flags & IORING_CQE_F_MORE)
>> -        ctx->cq_extra++;
>> -
>>       return !(flags & IORING_CQE_F_MORE);
>>   }

-- 
Pavel Begunkov
