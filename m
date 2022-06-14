Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7899854B823
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 19:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350909AbiFNRxG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 13:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241395AbiFNRxG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 13:53:06 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09D927FEE
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:53:05 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u8so12237359wrm.13
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 10:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OSUNYp7ttspaJlKT+BCRcjkFWYYl8Wc8ajn4RBJYKCg=;
        b=c6WGCRVUmhn5nHDAgdNxDKm2v61VLUKMC5b/Aec/+q7xEJ3dip3hzPtO7ip8Z86dvX
         xynGM5VjaxDOcrGzinU8e2CoDkC6nLiwYKnUcwXUD7z0dlc1nriUdSUd2Lt3KW9jUfn1
         1WGYZy6LzOragAej4Ru2JhvIuVClxLg46CpPqzcmHzrtwEDVL23E/t22BT5eKOkn0Z1t
         ySYv3Vmp6CZSn0B5eheIbRP6zaYL4gJGtubA2VflDM873zEP7phFRYh8NMEFuNse6S7d
         i0gsVH0zrBVjEVK7xGJKmxaFfrLZV4fB4S4tb0RLr65RaM/mTEniCyDuqNTK3DybGByn
         O6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OSUNYp7ttspaJlKT+BCRcjkFWYYl8Wc8ajn4RBJYKCg=;
        b=mTy11NgFpuuxklF2NuvaenIWVzg9kcJd+vH5/52Qv/ejviJyr9IGOSUkn0eYKK0flf
         RczlabEfTFCPH5G6Tv2VgaWa0zMX3qY1WC77CoFXcIDH8wtus6AxE88OS0UYf+uj7SRo
         VDKBJXVB8bamLqkWSMqgvkex9ibAIZxAC5ZzpnclljEInEwTKdNKxlPUNlJDz+yaEzWx
         AnAS3BU76uTYQby29Ga73pfoqSqhjUl5uxZ+pw5HAG1SOjuASal+8XHHAEOfHpixSjaK
         gQWmBJyzfitqTwo3CVW6L4+W3Rn9hyNcv4NgPqFKUwzsQeae8Qu7ObhUGCaX4tNSnwvh
         dOrA==
X-Gm-Message-State: AJIora9UpKIwqT2fUHZK4mslFOHoVgzJ0ZQ9sjlpHr5MKc/HWqsnH8cN
        L6MDocrEuVUa7m+z1UzuwJw=
X-Google-Smtp-Source: AGRyM1vZy0oB2T5dNq0aFF1LsYOiI5mxP4DfQ0FMU6moCb2maIV/U7x0Xn3NV0dglNanquIx7J7EIg==
X-Received: by 2002:a05:6000:242:b0:210:354e:c89a with SMTP id m2-20020a056000024200b00210354ec89amr5980748wrz.136.1655229184203;
        Tue, 14 Jun 2022 10:53:04 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b0039c5497deccsm4930609wmq.1.2022.06.14.10.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 10:53:03 -0700 (PDT)
Message-ID: <2dfc911a-7c13-6c0d-7a13-633ce3e95a0e@gmail.com>
Date:   Tue, 14 Jun 2022 18:52:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 11/25] io_uring: refactor
 io_req_task_complete()
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <60f4b51e219d1be0a390d53aae2e5a19b775ab69.1655213915.git.asml.silence@gmail.com>
 <4673dd1b-69ce-8028-6bbb-0120f73445ff@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4673dd1b-69ce-8028-6bbb-0120f73445ff@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 18:45, Hao Xu wrote:
> On 6/14/22 22:37, Pavel Begunkov wrote:
>> Clean up io_req_task_complete() and deduplicate io_put_kbuf() calls.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c | 16 ++++++++++------
>>   1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index fcee58c6c35e..0f6edf82f262 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1857,15 +1857,19 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>>       return ret;
>>   }
>> -inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
>> +
>> +void io_req_task_complete(struct io_kiocb *req, bool *locked)
>>   {
>> -    if (*locked) {
>> -        req->cqe.flags |= io_put_kbuf(req, 0);
>> +    if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
>> +        unsigned issue_flags = *locked ? IO_URING_F_UNLOCKED : 0;
> 
> should be *locked ? 0 : IO_URING_F_UNLOCKED; I think?. I haven't look
> into the whole series carefully, will do that tomorrow.

Yeah, it should... Thanks


>> +
>> +        req->cqe.flags |= io_put_kbuf(req, issue_flags);
>> +    }
>> +
>> +    if (*locked)
>>           io_req_add_compl_list(req);
>> -    } else {
>> -        req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
>> +    else
>>           io_req_complete_post(req);
>> -    }
>>   }
>>   /*
> 

-- 
Pavel Begunkov
