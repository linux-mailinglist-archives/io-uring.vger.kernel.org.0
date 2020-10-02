Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AB92818DA
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 19:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbgJBRJg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 13:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJBRJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 13:09:36 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CC1C0613E2
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 10:09:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m17so2321093ioo.1
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 10:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RnaSoFXkr8UhsiVSHQ/qydPiswK4rYK+rRXpbHo2YkM=;
        b=KKOtBaEQ19rU/LDfiKUGRjdjsU34Ny2Jt1euc6Egf4gUrdGpteNqPTau5+HteHnyON
         RgQTSyCsT8j+LfozOpJ9EI8mEXXlQn7Y2xjZQO2xlGEhb3L1HTZN6UpnI96p3MNegaDK
         TsBRhPLzro9GwpKKhgyZf+T3ykIxepsTfhRP68xU++AP0S/eeJXQ5CYIr6zWcM6+clNW
         4n8Ffcwc/PMbC9LKVc0SrdpkUkiAIwlMQQJKxggDEs7c6UzhDZlxny4yADTl/qADnumW
         nhq4OniZtPSNB7cS0kp/qPKQ6lZtDJY5s4WOzS9afcVeHKr2tnPyfB+sXOhIQLrXssJ1
         DeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RnaSoFXkr8UhsiVSHQ/qydPiswK4rYK+rRXpbHo2YkM=;
        b=dxjzpUMTWfHHTRLkF1EQ3fRJdYVk0IcensOhdXpNC1ldSvc82M0ul80wpkYdCXesBt
         ohIWDTaH5hd9QIZmhOvzhZQ+OeG4ynwERhDC0VYCIoMSt9KcrZx/DESVF+TrnBvBs8ho
         o0DxX+oDldpwBeNtwT9BZLoVkXmRQgBSuOipnosBZ1pzu4FKiCCTlhC44sGbyXGu7YMV
         xB0pKdD/k7b4+O3k4e1O+eWu3Vi7+Q6hx380QrBBRyCfm9vw6T7JOuSkJPnyUxNuvPQ+
         wCm7HE8lekiu/QpF2X2BdaZLM+GQOcYN7j9/ua/0dTSkx4pP7esnfkETI7i5qx9zEnNL
         60hw==
X-Gm-Message-State: AOAM5328KAvSfmTVlJxt8PXh4NVSdysOTox8bSwg7/DrB1d5dUpuQ3kI
        n5c9mVeI3JjSeVxU2iUdfIkGPGmSkoy4cQ==
X-Google-Smtp-Source: ABdhPJyeNqfNZZ2Kx/yzqiuUdQruU29DGEPZT3KlHQg53B5wbwSNKZZMK0JihV6G3NZ21sUAfkr4JA==
X-Received: by 2002:a5e:9e45:: with SMTP id j5mr2690098ioq.201.1601658574972;
        Fri, 02 Oct 2020 10:09:34 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a6sm1038928ilq.29.2020.10.02.10.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 10:09:34 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: grab any needed state during defer prep
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20200914162555.1502094-1-axboe@kernel.dk>
 <20200914162555.1502094-2-axboe@kernel.dk>
 <77283ddd-77d9-41e1-31d2-2b9734ee2388@gmail.com>
 <79e9d619-882b-8915-32df-ced1886e1eb3@gmail.com>
 <f61a349a-8348-04a3-fc4d-0a15344664fd@gmail.com>
 <6f514236-a584-e333-3ce2-8fd63c69c9c3@gmail.com>
 <f95eb757-795a-adcc-e4ea-e0a783d62a29@kernel.dk>
Message-ID: <d389c8bc-8257-cafa-6f85-7dc82d22773f@kernel.dk>
Date:   Fri, 2 Oct 2020 11:09:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f95eb757-795a-adcc-e4ea-e0a783d62a29@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 11:01 AM, Jens Axboe wrote:
> On 10/2/20 10:34 AM, Pavel Begunkov wrote:
>> On 02/10/2020 19:14, Pavel Begunkov wrote:
>>> On 19/09/2020 19:56, Pavel Begunkov wrote:
>>>> On 19/09/2020 18:27, Pavel Begunkov wrote:
>>>>> On 14/09/2020 19:25, Jens Axboe wrote:
>>>>>> Always grab work environment for deferred links. The assumption that we
>>>>>> will be running it always from the task in question is false, as exiting
>>>>>> tasks may mean that we're deferring this one to a thread helper. And at
>>>>>> that point it's too late to grab the work environment.
>>>> Forgot that they will be cancelled there. So, how it could happen?
>>>> Is that the initial thread will run task_work but loosing
>>>> some resources like mm prior to that? e.g. in do_exit()
>>>
>>> Jens, please let me know when you get time for that. I was thinking that
>>> you were meaning do_exit(), which does task_work_run() after killing mm,
>>> etc., but you mentioned a thread helper in the description... Which one
>>> do you mean?
>>
>> Either it refers to stuff after io_ring_ctx_wait_and_kill(), which
>> delegates the rest to io_ring_exit_work() via @system_unbound_wq.
> 
> We punt the request to task_work. task_work is run, we're still in the
> right context. We fail with -EAGAIN, and then call io_queue_async_work()
> and we're not doing async prep at that point.

BTW, I think we can improve on this for 5.10, on top of your cleanups.
So that would certainly be welcome!

-- 
Jens Axboe

