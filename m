Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E34351FD58
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiEIMuR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiEIMuP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:50:15 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2DC200F7A
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:46:21 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k14so11970758pga.0
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LNs4ZsfWNedE2iz/866HZXgsI0n4lC0Z8e291syIwoU=;
        b=HA/Ck7CtmS6yN0yitIH7DQu3hzES8w1ODz+qaUE0l3QjHApaOqmCOaIUmeuszoOzMz
         p5WnHPMt7BdZ9HuwolCWo/xe1mDeYPv/CmU6XD11McOUT5+NSdVXuqPCU+CuW9flszTW
         ooBvkT/Wu1kG1ooRBYpz1MHY0ZPKEvhviWf2eXE66jz9pscN3srM/yJ7qQOjTIjAKPcl
         ZdnW2QzOenvalAaMGMYHfa2bM8ZCGNxaEHnXnOd4LIQdlmlHRO7Xq7B2hkhM8FRuJibU
         +PsmJ+zqg8C+MOoAfRkPYDkTkHmcmQwgdzP2GheZBgMkoNR1T5/qQ2cuSEIeZjt8a35J
         nUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LNs4ZsfWNedE2iz/866HZXgsI0n4lC0Z8e291syIwoU=;
        b=JUZ9QphCBq2V6FHLBUHnQIHwUQ14BRLI9VbfvB3nXgtCT/YErwTnkXLd/+W8vWfBdI
         um6r7zoIl07Mk/nFawudPy2W/4H1jve0RNCwOmouTORQ8a+uS5t6TcmxZqNwlUQ0S1VC
         ijnABFpe3JQZ9bNp5JcSi/m219tQG5vfR6tygUqzOY69ni+2wBRM/oCtB3hwSL2A8dyy
         /0M2pWOLqF+3rBwCsbF0adad5mk0/+983fB73sIsS594A8R9p+vHzoJuxdELaVNRsWsL
         QwKwr2thRGSLmEM4xbp4JK2wFRHgUCeF5CdgyDRWj3bgn80J9iPGIxaGrxup/EjmhBjg
         uwSQ==
X-Gm-Message-State: AOAM532+dyjDkcPyn/S97+9TdmeOTJV2AT96rlkOCfoZQmsaQGRGeHvf
        9Kia6ZRuOnH9t1r7gZilRme/KQL4pYXYXa7V
X-Google-Smtp-Source: ABdhPJxSDu3Zba+c80vJxWBnmeCN/WwOJl7XjRNobGmO/MEIliI+rBSOf6ffOsWQmEtm0cwJqFO/Tg==
X-Received: by 2002:a05:6a00:8c5:b0:510:6eae:6fa1 with SMTP id s5-20020a056a0008c500b005106eae6fa1mr15876065pfu.12.1652100380555;
        Mon, 09 May 2022 05:46:20 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kx7-20020a17090b228700b001dce819d6f6sm5413534pjb.13.2022.05.09.05.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:46:20 -0700 (PDT)
Message-ID: <55360450-691b-7345-2872-272f643314be@kernel.dk>
Date:   Mon, 9 May 2022 06:46:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <20220501205653.15775-1-axboe@kernel.dk>
 <20220501205653.15775-4-axboe@kernel.dk>
 <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
 <e5f792aaca511e477ceb25115c30b6b53abf5063.camel@fb.com>
 <2c63a534-d728-205a-9812-d12eb62c6d75@kernel.dk>
 <3b740d592d850593b5344b35bdc2e52399a008c3.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3b740d592d850593b5344b35bdc2e52399a008c3.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 6:43 AM, Dylan Yudaken wrote:
> On Mon, 2022-05-09 at 06:28 -0600, Jens Axboe wrote:
>> On 5/9/22 6:12 AM, Dylan Yudaken wrote:
>>> On Mon, 2022-05-09 at 12:06 +0000, Dylan Yudaken wrote:
>>>> On Sun, 2022-05-01 at 14:56 -0600, Jens Axboe wrote:
>>>>> There's no point in having callers provide a kbuf, we're just
>>>>> returning
>>>>> the address anyway.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>  fs/io_uring.c | 42 ++++++++++++++++++------------------------
>>>>>  1 file changed, 18 insertions(+), 24 deletions(-)
>>>>>
>>>>
>>>> ...
>>>>
>>>>> @@ -6013,10 +6006,11 @@ static int io_recv(struct io_kiocb
>>>>> *req,
>>>>> unsigned int issue_flags)
>>>>>                 return -ENOTSOCK;
>>>>>  
>>>>>         if (req->flags & REQ_F_BUFFER_SELECT) {
>>>>> -               kbuf = io_buffer_select(req, &sr->len, sr-
>>>>>> bgid,
>>>>> issue_flags);
>>>>> -               if (IS_ERR(kbuf))
>>>>> -                       return PTR_ERR(kbuf);
>>>>> -               buf = u64_to_user_ptr(kbuf->addr);
>>>>> +               void __user *buf;
>>>>
>>>> this now shadows the outer buf, and so does not work at all as
>>>> the buf
>>>> value is lost.
>>>> A bit surprised this did not show up in any tests.
>>>>
>>>>> +
>>>>> +               buf = io_buffer_select(req, &sr->len, sr->bgid,
>>>>> issue_flags);
>>>>> +               if (IS_ERR(buf))
>>>>> +                       return PTR_ERR(buf);
>>>>>         }
>>>>>  
>>>>>         ret = import_single_range(READ, buf, sr->len, &iov,
>>>>> &msg.msg_iter);
>>>>
>>>
>>> The following seems to fix it for me. I can submit it separately if
>>> you
>>> like.
>>
>> I think you want something like this:
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 19dd3ba92486..2b87c89d2375 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5599,7 +5599,6 @@ static int io_recv(struct io_kiocb *req,
>> unsigned int issue_flags)
>>  {
>>         struct io_sr_msg *sr = &req->sr_msg;
>>         struct msghdr msg;
>> -       void __user *buf = sr->buf;
>>         struct socket *sock;
>>         struct iovec iov;
>>         unsigned flags;
>> @@ -5620,9 +5619,10 @@ static int io_recv(struct io_kiocb *req,
>> unsigned int issue_flags)
>>                 buf = io_buffer_select(req, &sr->len, sr->bgid,
>> issue_flags);
>>                 if (IS_ERR(buf))
>>                         return PTR_ERR(buf);
>> +               sr->buf = buf;
> 
> this line I think was added later on anyway in "io_uring: never call
> io_buffer_select() for a buffer re-select"

OK good that makes sense for why the end result was ok, but it should be
added here to avoid breakage in the middle.

>> -       ret = import_single_range(READ, buf, sr->len, &iov,
>> &msg.msg_iter);
>> +       ret = import_single_range(READ, sr->buf, sr->len, &iov,
>> &msg.msg_iter);
>>         if (unlikely(ret))
>>                 goto out_free;
>>  
>>
> 
> I'll send a patch now.

I decided to just fold in the patch to avoid having a broken point in
the middle.

-- 
Jens Axboe

