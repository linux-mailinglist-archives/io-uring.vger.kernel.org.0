Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE513A1A11
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhFIPt2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbhFIPt1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:49:27 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E1CC061574
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 08:47:18 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a11so38466709ejf.3
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CRAGumk1bnm5D7AV+HjfW6B6RzbWt9ykVq61Cqkl6Ok=;
        b=ZQjXUVIjMJ27bhvjmiBc8uObSDBXakXtoGOyzIcc8bYDa3n3oFSHQ1S1Q8wzGCiQaV
         eX+oBzF1Er3ZY1MSugrpJVnjSR2U5izQzJsVKvso3zMxSjR6hHWE5rD5wvhOteKqmOlx
         yu2aGSqIVgkqnmjSSxKZMhSDDF2kyBJWjHNbIr8y1ZRjOkCywT2pGw6tsf1rUzYcWAMw
         f0jQ7yFgVY/g/DZMccCpiUySwRfB8oTvBJWOLCAtE+3IE7X/UNTActNj/zgS5gXVT/9L
         fhkUu0/0Zi2HVM8EyE3yTw9t/xgX04afqJVrwlqWhxfceuWURkmq3V2/qYxgjpOMiu+y
         eTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CRAGumk1bnm5D7AV+HjfW6B6RzbWt9ykVq61Cqkl6Ok=;
        b=rWeqzOWlhLIFbx4t5/uQ3peMnLcVC39A2IJ/ehb6oJq9D5DacePEncaIF97ZJzLjoj
         hCMynvTV7Xip8/IcwjeX0v9/QDSDJLxJXEuq9s8u16nA8sIRkfmEt1hlkPC2rm50sRBQ
         MS4tARksHgmRIiijIl0+SsABpHKSB2X5SaOJ7Ns+zfg9kQxqB4LoNurmHc1r67uUSCNC
         x1ioksOV/Oow0iYC0pbtXlDyPdNcuRn+oT8gEzhLBEs6GB49JSWblgV5KfGy4uYHYak3
         5mHri4quvzwbCutzGrzuOYQH6/5T1VhtzrGDdXrcPCfr+Up7mz4KxHAfSuwgTDJt0zOy
         QAGw==
X-Gm-Message-State: AOAM531wnQeiWgVQwjzWHhmWFNdv1YlxCjbotPygDEOTu28VnGbxMqbM
        AoDsI2eDP2zegxYQYmlapeQ=
X-Google-Smtp-Source: ABdhPJzqJQ0HAiILdJbTSkJb49pgNP1C5gvF0UOKpX2GfWThxH8vW1n1uQdlRGQvBvB/lPy7Nch//g==
X-Received: by 2002:a17:906:fa13:: with SMTP id lo19mr534002ejb.468.1623253637448;
        Wed, 09 Jun 2021 08:47:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:f1a2])
        by smtp.gmail.com with ESMTPSA id c13sm69446edv.27.2021.06.09.08.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:47:17 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix blocking inline submission
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     lonjil@gmail.com
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
 <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
 <cb972cf9-c35b-51f3-7216-13437285cda2@kernel.dk>
 <a61a3394-0e18-ec9a-5674-dd4439c6b041@gmail.com>
 <05dff9bd-a928-e49b-f1e1-945a1f513c37@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a396b8f6-d9d8-ef26-438f-2f67cc30dea0@gmail.com>
Date:   Wed, 9 Jun 2021 16:47:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <05dff9bd-a928-e49b-f1e1-945a1f513c37@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 4:43 PM, Jens Axboe wrote:
> On 6/9/21 9:41 AM, Pavel Begunkov wrote:
>> On 6/9/21 4:36 PM, Jens Axboe wrote:
>>> On 6/9/21 9:34 AM, Pavel Begunkov wrote:
>>>> On 6/9/21 4:07 PM, Jens Axboe wrote:
>>>>> On 6/9/21 5:07 AM, Pavel Begunkov wrote:
>>>>>> There is a complaint against sys_io_uring_enter() blocking if it submits
>>>>>> stdin reads. The problem is in __io_file_supports_async(), which
>>>>>> sees that it's a cdev and allows it to be processed inline.
>>>>>>
>>>>>> Punt char devices using generic rules of io_file_supports_async(),
>>>>>> including checking for presence of *_iter() versions of rw callbacks.
>>>>>> Apparently, it will affect most of cdevs with some exceptions like
>>>>>> null and zero devices.
>>>>>
>>>>> I don't like this, we really should fix the file types, they are
>>>>> broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
>>>>> the write equiv).
>>>>>
>>>>> For cases where there is no iter variant of the read/write handlers,
>>>>> then yes we should not return true from __io_file_supports_async().
>>>>
>>>> I'm confused. The patch doesn't punt them unconditionally, but make
>>>> it go through the generic path of __io_file_supports_async()
>>>> including checks for read_iter/write_iter. So if a chrdev has
>>>> *_iter() it should continue to work as before.
>>>
>>> Ah ok, yes then that is indeed fine.
>>>
>>>> It fixes the symptom that means the change punts it async, and so
>>>> I assume tty doesn't have _iter()s for some reason. Will take a
>>>> look at the tty driver soon to stop blind guessing.
>>>
>>> I think they do, but they don't honor IOCB_NOWAIT for example. I'd
>>> be curious if the patch actually fixes the reported case, even though
>>> it is most likely the right thing to do. If not, then the fops handler
>>> need fixing for that driver.
>>
>> Yep, weird, but fixes it for me. A simple repro was attached
>> to the issue.
>>
>> https://github.com/axboe/liburing/issues/354
> 
> Ah ok, all good then for now. I have applied the patch, and added
> the reported-by as well.

Great, thanks. Will check what's with the tty part

-- 
Pavel Begunkov
