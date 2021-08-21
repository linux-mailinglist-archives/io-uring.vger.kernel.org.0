Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579303F3844
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 05:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhHUDLH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 23:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhHUDLH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 23:11:07 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985AEC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 20:10:28 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id j18so11427328ile.8
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qYPcPwp2mfD4T8Nhjx/auL0EL1dA6CfxRu+vKvSFvik=;
        b=mG7lH6PpOcNB5gKw/XsghAM/aPVpE2BhMiqpDde05ccD1t3GKE6qjzhEAyS7AjBlMd
         51kIPIco7lptcW3HQbVsbTFzzhj/+8BQcfLVPGExKY9yw2u5nWRsLwrezHqjoOQvkvJk
         QJgRKmMs+nU42khBmodnT2pZNjHA3vdrwl5NhMwzOmmFOim43HRgUdKjZA/CpU36ypYj
         dDWHn6WdiPb0MBGRzoEulQj+FmSyTjjMXUBGq1oXtB1/n4HkcuxqKXUVJX5eirGHVMcp
         YJXc1/JLUcJRz7MjjKm2jQk1K8Otcp2LNIvvmvE+6nZ+3crEUb6jQrnO0tE6DlfgY2fd
         gW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qYPcPwp2mfD4T8Nhjx/auL0EL1dA6CfxRu+vKvSFvik=;
        b=PhThUjWWYF/MfajaQEMFsFDwY9p6Lh6Q3a84jiZY3Td2MDyGrdUIFpND9kYew+HMqA
         fLLIE9siN8pS6bPRrN2mz/nRdq7jc+i5B7NizXtBkFciaX+NzMZrw+avrT85ftdXWyQg
         AofR9/U61b3nU6MrTtpH8IjDZurBlbniHOrxlm13zbOpPXb95KKh3IjfsSDatKhtatbQ
         u2aKCigjuDXgjH9p+I/cOxgPnAMlcZP0vPxZkGL/WN+WRQPs0HHCmbYFPlVu2qRSjHgb
         EUdG0xVD3Vsi4OPTBvtIFkPm4yvfkkcq+pOhSiWDNEULJONETgBMgaZcZgD5HdmGVl6n
         yNMg==
X-Gm-Message-State: AOAM530CempSUzGYt5T+BrcyE6swAZBYK4jhzlnb0GpEmTa5QoOuLws9
        HQfYkbmrr4/67akLxifYxrZ+IA==
X-Google-Smtp-Source: ABdhPJyVN+fcuG65osClnzNLauMtyCJr1IEclARrT+2S+BRynxT8azq5GjV9m0/fnxbueZXePzPmjw==
X-Received: by 2002:a05:6e02:1044:: with SMTP id p4mr15572753ilj.227.1629515427919;
        Fri, 20 Aug 2021 20:10:27 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id k14sm4253155ili.19.2021.08.20.20.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 20:10:27 -0700 (PDT)
Subject: Re: [PATCH for-5.15] io_uring: fix lacking of protection for compl_nr
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210820184013.195812-1-haoxu@linux.alibaba.com>
 <c2e5476e-86b8-a45f-642e-6a3c2449bfa2@gmail.com>
 <4b6d903b-09ec-0fca-fa70-4c6c32a0f5cb@linux.alibaba.com>
 <68755d6f-8049-463f-f372-0ddc978a963e@gmail.com>
 <77a44fce-c831-16a6-8e80-9aee77f496a2@kernel.dk>
 <8ab470e7-83f1-a0ef-f43b-29af8f84d229@gmail.com>
 <3cae21c2-5db7-add1-1587-c87e22e726dc@kernel.dk>
 <34b4d60a-d3c5-bb7d-80c9-d90a98f8632d@gmail.com>
 <5900a96e-541c-4dba-eb42-dc8c30f6d5ea@kernel.dk>
 <a9f1d79b-9aa8-ea22-691e-5676230f7563@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ba80d3c-a92e-90cf-37f4-ff5c146e7753@kernel.dk>
Date:   Fri, 20 Aug 2021 21:10:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a9f1d79b-9aa8-ea22-691e-5676230f7563@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 4:59 PM, Pavel Begunkov wrote:
> On 8/20/21 11:46 PM, Jens Axboe wrote:
>> On 8/20/21 4:41 PM, Pavel Begunkov wrote:
>>> On 8/20/21 11:30 PM, Jens Axboe wrote:
>>>> On 8/20/21 4:28 PM, Pavel Begunkov wrote:
>>>>> On 8/20/21 11:09 PM, Jens Axboe wrote:
>>>>>> On 8/20/21 3:32 PM, Pavel Begunkov wrote:
>>>>>>> On 8/20/21 9:39 PM, Hao Xu wrote:
>>>>>>>> 在 2021/8/21 上午2:59, Pavel Begunkov 写道:
>>>>>>>>> On 8/20/21 7:40 PM, Hao Xu wrote:
>>>>>>>>>> coml_nr in ctx_flush_and_put() is not protected by uring_lock, this
>>>>>>>>>> may cause problems when accessing it parallelly.
>>>>>>>>>
>>>>>>>>> Did you hit any problem? It sounds like it should be fine as is:
>>>>>>>>>
>>>>>>>>> The trick is that it's only responsible to flush requests added
>>>>>>>>> during execution of current call to tctx_task_work(), and those
>>>>>>>>> naturally synchronised with the current task. All other potentially
>>>>>>>>> enqueued requests will be of someone else's responsibility.
>>>>>>>>>
>>>>>>>>> So, if nobody flushed requests, we're finely in-sync. If we see
>>>>>>>>> 0 there, but actually enqueued a request, it means someone
>>>>>>>>> actually flushed it after the request had been added.
>>>>>>>>>
>>>>>>>>> Probably, needs a more formal explanation with happens-before
>>>>>>>>> and so.
>>>>>>>> I should put more detail in the commit message, the thing is:
>>>>>>>> say coml_nr > 0
>>>>>>>>
>>>>>>>>   ctx_flush_and put                  other context
>>>>>>>>    if (compl_nr)                      get mutex
>>>>>>>>                                       coml_nr > 0
>>>>>>>>                                       do flush
>>>>>>>>                                           coml_nr = 0
>>>>>>>>                                       release mutex
>>>>>>>>         get mutex
>>>>>>>>            do flush (*)
>>>>>>>>         release mutex
>>>>>>>>
>>>>>>>> in (*) place, we do a bunch of unnecessary works, moreover, we
>>>>>>>
>>>>>>> I wouldn't care about overhead, that shouldn't be much
>>>>>>>
>>>>>>>> call io_cqring_ev_posted() which I think we shouldn't.
>>>>>>>
>>>>>>> IMHO, users should expect spurious io_cqring_ev_posted(),
>>>>>>> though there were some eventfd users complaining before, so
>>>>>>> for them we can do
>>>>>>
>>>>>> It does sometimes cause issues, see:
>>>>>
>>>>> I'm used that locking may end up in spurious wakeups. May be
>>>>> different for eventfd, but considering that we do batch
>>>>> completions and so might be calling it only once per multiple
>>>>> CQEs, it shouldn't be.
>>>>
>>>> The wakeups are fine, it's the ev increment that's causing some issues.
>>>
>>> If userspace doesn't expect that eventfd may get diverged from the
>>> number of posted CQEs, we need something like below. The weird part
>>> is that it looks nobody complained about this one, even though it
>>> should be happening pretty often. 
>>
>> That wasn't the issue we ran into, it was more the fact that eventfd
>> would indicate that something had been posted, when nothing had.
>> We don't need eventfd notifications to be == number of posted events,
>> just if the eventfd notification is inremented, there should be new
>> events there.
> 
> It's just so commonly mentioned, that for me expecting spurious
> events/wakeups is a default. Do we have it documented anywhere?

Not documented to my knowledge, and I wasn't really aware of this being
a problem until it was reported and that above referenced commit was
done to fix it. Might be worthwhile to put a comment in ev_posted() to
detail this, I'll do that for 5.15.

-- 
Jens Axboe

