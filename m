Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EBF1F84D6
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2020 21:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgFMTNg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Jun 2020 15:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgFMTNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Jun 2020 15:13:35 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350EFC03E96F
        for <io-uring@vger.kernel.org>; Sat, 13 Jun 2020 12:13:35 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id b82so2311475wmb.1
        for <io-uring@vger.kernel.org>; Sat, 13 Jun 2020 12:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LXYUSBt8eYtW9dBlnbfkUKeFbY0ZJQAOGarGhy+WsNY=;
        b=jiVRd2AQcavHDZBZAEU//Btr4icOq1PFtyL4M7f1Go8ra0k8UqpunMsIy1pn9L4J6b
         oT4HMZOTeqGIDe8L/NxsX2qS13LIZ0lka+WNbYmjGgarvzIfkB5mndgHKu22uERxy6ex
         qfg2gAY0IRHrN+ulxLMA4vbFWkiyjrC2yYeQvfKxGcSTyyPapT4eFRYJuDO9mky+m7Pt
         JszGjwHdKmWHXe1TVkCxRA71nIDbTLbRtyiS5AeODFyV//ypMdiYTgvy+VwtugxUh8kU
         LHXsBlNm06LqWhCwnxEaZmugWJeroUHlRB2j8DE/7yafzkkxLhRKidtusw0f79HePwZD
         OLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LXYUSBt8eYtW9dBlnbfkUKeFbY0ZJQAOGarGhy+WsNY=;
        b=s8oT7hqxw6DhS9x3gdOK0OLa9iHkR8PbjHwojQfoNOvxzW6iPg3YfGdvjDCoNgNalh
         3daSi18hju94CaJou0ZRT4ue2MAntnYD5V7DZWx4T+5LfOOAWggOkW8TqNd4oWrRexPb
         iamciJSa6zYA609XqkjdM5k+kpcHxcyf1XZHN2MhSIo/tsjbDOWGPccTsmPwF2dhWq+M
         Q0QIICbvPo8CBqmYYlhYWJyldzzXV4UulRDwDpIJvdxDL2feb2a1Z6ooqS/1b1Qp/uLg
         v71+C0BnV4lvhqk8SZYN8WrSo8+7pELsgxFDKx8fPTzdJNSclP8K/QB6ItPb0lR+kgpP
         U6UQ==
X-Gm-Message-State: AOAM530CrQrmpj26/p0FWMVRi0c9TIG8Rdi7e6/naeKo8TwTBbJMlAAh
        8euZ59jqL2m2Cip9Br5EZovHDtU9
X-Google-Smtp-Source: ABdhPJxGKUaS8870lBUo5Xv/Nb8GQwXcLJQCxq3M6gnEY7ezHdtObRbFwdo+/aW4E1U7PUwae3+qEA==
X-Received: by 2002:a7b:cb4c:: with SMTP id v12mr4932165wmj.43.1592075610670;
        Sat, 13 Jun 2020 12:13:30 -0700 (PDT)
Received: from [192.168.43.130] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id s2sm13985504wmh.11.2020.06.13.12.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2020 12:13:30 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
 <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
 <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
 <868c9ef4-ab31-8c63-cace-9fd99c58cbb2@kernel.dk>
 <3688a25e-c405-309f-cc87-96596a5d0ed2@gmail.com>
 <3f78d6a2-f589-d3b1-3816-30de6e9b71df@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] do_iopoll() and *grab_env()
Message-ID: <e5bc2ba0-ee0c-ac0c-1cdb-16d8a9132b3b@gmail.com>
Date:   Sat, 13 Jun 2020 22:12:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3f78d6a2-f589-d3b1-3816-30de6e9b71df@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/06/2020 22:42, Jens Axboe wrote:
> On 6/12/20 12:33 PM, Pavel Begunkov wrote:
>> On 12/06/2020 21:02, Jens Axboe wrote:
>>> On 6/12/20 11:55 AM, Jens Axboe wrote:
>>>> On 6/12/20 11:30 AM, Pavel Begunkov wrote:
>>>>> On 12/06/2020 20:02, Jens Axboe wrote:
>>>>>> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>>>>>>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>>>>>>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>>>>>>> be called from who knows what context, e.g. from a completely
>>>>>>> different process with its own memory space, creds, etc.
>>>>>>>
>>>>>>> io_do_iopoll() {
>>>>>>> 	ret = req->poll();
>>>>>>> 	if (ret == -EAGAIN)
>>>>>>> 		io_queue_async_work()
>>>>>>> 	...
>>>>>>> }
>>>>>>>
>>>>>>>
>>>>>>> I can't find it handled in io_uring. Can this even happen?
>>>>>>> Wouldn't it be better to complete them with -EAGAIN?
>>>>>>
>>>>>> I don't think a plain -EAGAIN complete would be very useful, it's kind
>>>>>> of a shitty thing to pass back to userspace when it can be avoided. For
>>>>>> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
>>>>>> latter, there's no problem in retrying, regardless of context. For the
>>>>>> former, I think we'd get -EFAULT mapping the IO at that point, which is
>>>>>> probably reasonable. I'd need to double check, though.
>>>>>
>>>>> It's shitty, but -EFAULT is the best outcome. I care more about not
>>>>> corrupting another process' memory if addresses coincide. AFAIK it can
>>>>> happen because io_{read,write} will use iovecs for punted re-submission.
>>>>>
>>>>>
>>>>> Unconditional in advance async_prep() is too heavy to be good. I'd love to
>>>>> see something more clever, but with -EAGAIN users at least can handle it.
>>>>
>>>> So how about we just grab ->task for the initial issue, and retry if we
>>>> find it through -EAGAIN and ->task == current. That'll be the most
>>>> common case, by far, and it'll prevent passes back -EAGAIN when we
>>>> really don't have to. If the task is different, then -EAGAIN makes more
>>>> sense, because at that point we're passing back -EAGAIN because we
>>>> really cannot feasibly handle it rather than just as a convenience.
>>
>> Yeah, I was even thinking to drag it through task_work just to call
>> *grab_env() there. Looks reasonable to me.
>>
>>> Something like this, totally untested. And wants a comment too.
>>
>> Looks like it. Would you leave this to me? There is another issue with
>> cancellation requiring ->task, It'd be easier to keep them together.
> 
> Guess this ties into the next email, on using task_work? I actually
> don't think that's a bad idea. If you have a low(er) queue depth device,
> the -EAGAIN path is not necessarily that common. And task_work is a lot
> more efficient for re-submittal than async work, plus needs to grab less
> resources.
> 
> So I think you should still run with it...

Ok, I'll look into this then


-- 
Pavel Begunkov
