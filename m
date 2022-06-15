Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA6754C5D2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346695AbiFOKTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346820AbiFOKTk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:19:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77A642A1E
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:19:34 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so850914wma.4
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=YO8vfWa4qVR21LcbNRJn7f6Or5IsrVOvfHxeYZjUbSU=;
        b=CqTulZPb7wO9aj2gfLojac4YO2mq8LJKsilEocp1fOUMVwNVpjkmG/mNsWaZHMpEnS
         PHuIKQ1lgpPJ3d9k5a8PHm8j59nvYQsHUwjG1VQW2Mtbs556cM5pjpvFi0I/egvNSG2T
         SfAwppLV+NTFNO/xlpLBKz69rZZEssaPZKHmaeSKnKNWfQI3mO3cFfy/HeOBd5Z3TLrs
         WkmXtBnlWkHNXegTQxA72EcC6MEC8orfBjlei8nuYUPW5qwGkui8fh6piBtFesgXaXlo
         i1qIVEv2zhQ/NOY/alJ9rvqL0rPF18tOMGBLiN8XpQyrs/L1DFn249YDY1s/7vz4+cJe
         9e3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YO8vfWa4qVR21LcbNRJn7f6Or5IsrVOvfHxeYZjUbSU=;
        b=woAMJC2G7nNLoTViixoKQbY6rHd8vS5TpvFUALY6yxVpiMh9EMksxoboRCe8DNwc5J
         woc/J757IXLujXcSk0M5zW6HO4Ed9mV4gbpywW3bQvQ76kVLDy9AayZLwe5u3L0uxam9
         /AFDnlGr5ghfR+lO3AtJl9VG7gPEbIUxUVLqyL7BdnfiUtZsDE+nS/qYjuNLjgNTmfgC
         Dp1ktZP+Qsfqjr/XzAFZ8iJxq2hMoJu9FZ+8fGCY/eVWgzsU1+ukbakiIgo+zEf7LfvL
         Q+PBNe+UTZnH2e22G3D0KdWkN4zILmpvmLxswFVx8uIlAU5fYn5aMA2vaCIovMdK3VfQ
         QKHg==
X-Gm-Message-State: AOAM531xje/lEvwrLeeLCg1Q0FReq6I2D7U4ljHnGLfUXhHViyCkm96o
        h7ZEwHBcFYSpmV9VH8DuIRk=
X-Google-Smtp-Source: ABdhPJzzPvR4C+DWNfxFhCcZc2jWxaq9AVbUs3EjCaBFjpuLMwl8SBHlNoINgs3B7Pf/m1tto+D0IQ==
X-Received: by 2002:a05:600c:4fd0:b0:39c:6565:31a0 with SMTP id o16-20020a05600c4fd000b0039c656531a0mr9009600wmq.142.1655288373231;
        Wed, 15 Jun 2022 03:19:33 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id az42-20020a05600c602a00b0039db500714fsm1951573wmb.6.2022.06.15.03.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:19:32 -0700 (PDT)
Message-ID: <cd37cace-247a-ce97-7af8-b0337b3684cb@gmail.com>
Date:   Wed, 15 Jun 2022 11:19:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 10/25] io_uring: kill REQ_F_COMPLETE_INLINE
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <378d3aba69ea2b6a8b14624810a551c2ae011791.1655213915.git.asml.silence@gmail.com>
 <172baf20-e6d1-9098-187d-a2970885338b@linux.dev>
 <91f3d0d4-9d37-8ec8-dcde-97b3351eb765@gmail.com>
In-Reply-To: <91f3d0d4-9d37-8ec8-dcde-97b3351eb765@gmail.com>
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

On 6/15/22 11:18, Pavel Begunkov wrote:
> On 6/15/22 09:20, Hao Xu wrote:
>> On 6/14/22 22:37, Pavel Begunkov wrote:
>>> REQ_F_COMPLETE_INLINE is only needed to delay queueing into the
>>> completion list to io_queue_sqe() as __io_req_complete() is inlined and
>>> we don't want to bloat the kernel.
>>>
>>> As now we complete in a more centralised fashion in io_issue_sqe() we
>>> can get rid of the flag and queue to the list directly.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/io_uring.c       | 20 ++++++++------------
>>>   io_uring/io_uring.h       |  5 -----
>>>   io_uring/io_uring_types.h |  3 ---
>>>   3 files changed, 8 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 1fb93fdcfbab..fcee58c6c35e 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1278,17 +1278,14 @@ static void io_req_complete_post32(struct io_kiocb *req, u64 extra1, u64 extra2)
>>>   inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
>>>   {
>>> -    if (issue_flags & IO_URING_F_COMPLETE_DEFER)
>>> -        io_req_complete_state(req);
>>> -    else
>>> -        io_req_complete_post(req);
>>> +    io_req_complete_post(req);
>>>   }
>>
>> io_read/write and provide_buffers/remove_buffers are still using
>> io_req_complete() in their own function. By removing the
>> IO_URING_F_COMPLETE_DEFER branch they will end in complete_post path
>> 100% which we shouldn't.
> 
> Old provided buffers are such a useful feature that Jens adds
> a new ring-based version of it, so I couldn't care less about
> those two.
> 
> I any case, let's leave it to follow ups. Those locking is a
> weird construct and shouldn't be done this ad-hook way, it's
> a potential bug nest

Ok, missed io_read/write part, that's a problem, agree

-- 
Pavel Begunkov
