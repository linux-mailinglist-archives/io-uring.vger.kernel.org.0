Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6811F7DBB
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 21:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgFLTmN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 15:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgFLTmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 15:42:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2595FC03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 12:42:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i4so4287407pjd.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 12:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=E2uSaq3WfWzijKh2p0u/crjYmlSr87AtAybdbMV3eLM=;
        b=P0kr656gghrCJvEbMBD9g+iR/0VCtfLI9xOUGXJMbsxuDmF7VWOtiFIxulCPu2cpiu
         Ji08YVoSkoblb158wBvFKAeLggkLbOlWIcYox16SrqUOX34Wm05vQmUWq7Z8M6Ru+Oix
         lXjP7VK7OVD0FCZ/KGHtC66JDrpIo0xbsHx/Szh54Apxzs7QEKbPp2i2BVkpzk3pqNWy
         1WvriE75KVP+ay6CpxMSr3vCivXMo0iqQb/rViU8xHPTv9ectxlRHYrxXVCO34VKEAB6
         +C1dIYrq+XoxUo3jY9Ups380FjlP2biLyBHQ+4KEyxcTjYKQjdeQURMdiE3c7OA9WItQ
         BrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E2uSaq3WfWzijKh2p0u/crjYmlSr87AtAybdbMV3eLM=;
        b=ij+gqWku2BYDQJu1w7DZvgWA7/WInPE18q7jHJ4ndV4M+tk35qTW8Q8/USuHpNkNqQ
         HFYYXJ93FJS77MnCWkJCVH9ixwNQ9AGAMJHncidBSLgXXraMNEK7bCP5AF8cYtezZjzn
         SQfKPPZYIb84AlNfwwT8C3RcThYfNTV0nuqhOiE/wlXpuCjPUpHDp+WcZh/jS96vOGPY
         howmNhktVjUTe+YEc0nVMeKMc1Z/4/er++TnC7Ad/q82VoDZzZ8r35WxtoEbHWExGdei
         mTd53sUODYSzJSSSjIIBy1J1D7QsKLltE5kB7bqRKu2ktDPQyTJbPR6D0TfN8tcoOMjA
         iLhQ==
X-Gm-Message-State: AOAM530hfKHGptlMqIz2GgWUW993ig0TN/zOFzEsQBoKK6jDO7FdJZ/j
        eXA6pUHzhzE0mQPMJ77RTJZxDrKQZbTixQ==
X-Google-Smtp-Source: ABdhPJz2uWWRN0CrmAiD8v+V/VpzbMQpLyOpZBFR1QppQ/PnCZlCYZ/GnG8FGj4/JNraD2Iv1jyc0g==
X-Received: by 2002:a17:90b:30d8:: with SMTP id hi24mr494339pjb.78.1591990932354;
        Fri, 12 Jun 2020 12:42:12 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q145sm6863932pfq.128.2020.06.12.12.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 12:42:11 -0700 (PDT)
Subject: Re: [RFC] do_iopoll() and *grab_env()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
 <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
 <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
 <868c9ef4-ab31-8c63-cace-9fd99c58cbb2@kernel.dk>
 <3688a25e-c405-309f-cc87-96596a5d0ed2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f78d6a2-f589-d3b1-3816-30de6e9b71df@kernel.dk>
Date:   Fri, 12 Jun 2020 13:42:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3688a25e-c405-309f-cc87-96596a5d0ed2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 12:33 PM, Pavel Begunkov wrote:
> On 12/06/2020 21:02, Jens Axboe wrote:
>> On 6/12/20 11:55 AM, Jens Axboe wrote:
>>> On 6/12/20 11:30 AM, Pavel Begunkov wrote:
>>>> On 12/06/2020 20:02, Jens Axboe wrote:
>>>>> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>>>>>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>>>>>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>>>>>> be called from who knows what context, e.g. from a completely
>>>>>> different process with its own memory space, creds, etc.
>>>>>>
>>>>>> io_do_iopoll() {
>>>>>> 	ret = req->poll();
>>>>>> 	if (ret == -EAGAIN)
>>>>>> 		io_queue_async_work()
>>>>>> 	...
>>>>>> }
>>>>>>
>>>>>>
>>>>>> I can't find it handled in io_uring. Can this even happen?
>>>>>> Wouldn't it be better to complete them with -EAGAIN?
>>>>>
>>>>> I don't think a plain -EAGAIN complete would be very useful, it's kind
>>>>> of a shitty thing to pass back to userspace when it can be avoided. For
>>>>> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
>>>>> latter, there's no problem in retrying, regardless of context. For the
>>>>> former, I think we'd get -EFAULT mapping the IO at that point, which is
>>>>> probably reasonable. I'd need to double check, though.
>>>>
>>>> It's shitty, but -EFAULT is the best outcome. I care more about not
>>>> corrupting another process' memory if addresses coincide. AFAIK it can
>>>> happen because io_{read,write} will use iovecs for punted re-submission.
>>>>
>>>>
>>>> Unconditional in advance async_prep() is too heavy to be good. I'd love to
>>>> see something more clever, but with -EAGAIN users at least can handle it.
>>>
>>> So how about we just grab ->task for the initial issue, and retry if we
>>> find it through -EAGAIN and ->task == current. That'll be the most
>>> common case, by far, and it'll prevent passes back -EAGAIN when we
>>> really don't have to. If the task is different, then -EAGAIN makes more
>>> sense, because at that point we're passing back -EAGAIN because we
>>> really cannot feasibly handle it rather than just as a convenience.
> 
> Yeah, I was even thinking to drag it through task_work just to call
> *grab_env() there. Looks reasonable to me.
> 
>> Something like this, totally untested. And wants a comment too.
> 
> Looks like it. Would you leave this to me? There is another issue with
> cancellation requiring ->task, It'd be easier to keep them together.

Guess this ties into the next email, on using task_work? I actually
don't think that's a bad idea. If you have a low(er) queue depth device,
the -EAGAIN path is not necessarily that common. And task_work is a lot
more efficient for re-submittal than async work, plus needs to grab less
resources.

So I think you should still run with it...

-- 
Jens Axboe

