Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717C22453C3
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 00:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgHOWFD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 18:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbgHOVux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:50:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC90C0A3BF9
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 09:50:19 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 185so13054325ljj.7
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bdFhSLGglju4On2BtF9tSLZyst85ogdNfLCq3eLdvug=;
        b=K1/7hhJlu+tWGI48EpIv0vuGMDjhQghC7vuMDYrl6VW4FsEltFlcw7aSv1wTmsUiG0
         mvZ8rVYuQqv5bnn4mS1RzecYQZom2X79y6izHRZSzqKbfnk/1+Ned/xDk5phpOsMvvW8
         zjqjAiA9Wtmm3iAYlOApMqmyyUzNpgr30ITvG4/1KHOElYrRG9p4+j+Q9WnfgetD2+SO
         PIYfo4E7pZ1HdglwnkoefZAhU8/jju5S+5z3uawrG+eiikZdun25Q/jvXmINrYgmXyh/
         d3wnc5ig9VnqPI19sqNHYOdbxguo9EjEYzvRlXnDEk611TJHSswYezN90yGctgDiYDSb
         LJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bdFhSLGglju4On2BtF9tSLZyst85ogdNfLCq3eLdvug=;
        b=o3YglfHnMSsmD4ntsH4NHQ9I2DitiGsogwbTtNoN223aQUMDVJMazJmmdf5SPHdUk3
         5TqE0fehgygCH+nT2yCacrflWv+4k+qQd3RV0u9l0TToQB9cFg1nEDyk/HYs9yb++HO0
         Jgf5ORG0W4R+azTt1P+7pL88FAlSlTYL4bSA7oJ5rknStLRGpbQF06AB19UwOEpKdsxf
         lqiQg9wIGL2sKvSj1d8EgU8PDfGnTuzy5sJsmkRf4CzXskmcDoai0L9ApK/FEENGRXN2
         KVGRs8cNWIf1NF4LPivxXogLm7NJdjw5B7dj5KqG8nH4aaBcEWV9DO93y/3mAz9Gc+gp
         f/3w==
X-Gm-Message-State: AOAM530JyqDN0CSyeZrlAj74YEDPFZkZaZ1LmJW3XcISPLm4VZY2NE15
        3FTBUU81zSEhawa8EhK3ExL65V8E4rTdcw==
X-Google-Smtp-Source: ABdhPJxoDEoHp4cXfT/TPLPmWFyrAXtdpw8Z8WjGnaDenNM5W2yimhJVzJEs98fsYbjSrMUVw6viaA==
X-Received: by 2002:a2e:9cd2:: with SMTP id g18mr3557597ljj.448.1597510217087;
        Sat, 15 Aug 2020 09:50:17 -0700 (PDT)
Received: from [192.168.200.116] ([176.99.130.43])
        by smtp.gmail.com with ESMTPSA id l10sm893153ljc.65.2020.08.15.09.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 09:50:16 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_uring process termination/killing is not working
Message-ID: <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
Date:   Sat, 15 Aug 2020 19:48:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/08/2020 18:12, Jens Axboe wrote:
> On 8/15/20 12:45 AM, Pavel Begunkov wrote:
>> On 13/08/2020 02:32, Jens Axboe wrote:
>>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>>>> works
>>>>>>>>
>>>>>>>> I've attached a file to reproduce it
>>>>>>>> or here
>>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>>>
>>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>>>> state, which is why you can't kill it.
>>>>>>
>>>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>>>> in a link.
>>>>>
>>>>> BTW, I described it a month ago, there were more details.
>>>>
>>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>>>
>>> Yeah I think you're right. How about something like the below? That'll
>>> potentially cancel more than just the one we're looking for, but seems
>>> kind of silly to only cancel from the file table holding request and to
>>> the end.
>>
>> The bug is not poll/t-out related, IIRC my test reproduces it with
>> read(pipe)->open(). See the previously sent link.
> 
> Right, but in this context for poll, I just mean any request that has a
> poll handler armed. Not necessarily only a pure poll. The patch should
> fix your case, too.

Ok. I was thinking about sleeping in io_read(), etc. from io-wq context.
That should have the same effect.

> 
>> As mentioned, I'm going to patch that up, if you won't beat me on that.
> 
> Please test and send a fix if you find something! I'm going to ship what
> I have this weekend, but we can always add a fix on top if we need
> anything.

Sure

-- 
Pavel Begunkov
