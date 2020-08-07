Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D311323E569
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 03:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGBK5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 21:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgHGBK4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 21:10:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DB5C061574
        for <io-uring@vger.kernel.org>; Thu,  6 Aug 2020 18:10:54 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u20so123158pfn.0
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 18:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cIChvgSDGQaVJbzf09N56DpWhJywloTN/Xqk5nTQlH8=;
        b=uCuFt6LxXX8Z8p6sffyh/tpsfwuyO9oOtPmbBMnKMjFfHS1uNtfkz8FjP3AxSw3RiY
         NDWK6FLfUJk7vKOmSBofxI4XL1CFGH9HI32k13bMGwl75X58UE223/W6dYZiz7gTlfDX
         CiLPIS8a+o5v3qa4HTzoS0GpWHOH7r1+tfHjOoRCRotwDqZ4J+j9d6tp9sPhnuO9ACGI
         AnmvH7bQtlqEkZiw63RgiBlZsFWOXVrBrgsrW4T1DBCj8+M3DaMda3ez/6zG3tpoXyto
         y6OPdPmIicdXuAeinBgAcSYGH9LJM6HvRInN+RKgEwUZ6GQ8oOlZPfugaqtegTjqpDxJ
         uD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIChvgSDGQaVJbzf09N56DpWhJywloTN/Xqk5nTQlH8=;
        b=nHgyPYTMqb4EZSEric8p6kb1iHTQpQKwWjc2LheX5HX3PCeIPe/ozGbjrlscIF0Zt8
         90Mzycu8uPquyrFJFhtNErfgTi8zotwRyURwZLwhgvJaZCD9f2BuL9tAnNvh8X4yApuZ
         qW3ZWUCn9WLZb4IG8pebrf7U4uv2tDSPOMv5kDYCBHDOF8vGlQ7aPa1y6/mvjwVHQYXP
         WzuJ0JZp00l+kKzIdfMLl6mLvwgS8LOxwd+IA1++DRQXLdUB87X0yIqxxnmRzJowpVkj
         sZLAhbUAMqwCMdpZoTSmcm+oa4kX/Eg0xd4V8zbQfJ3LnFCyVc7qjmYHLXCGQi5XS6xs
         WYLA==
X-Gm-Message-State: AOAM530/v0tO7Tt3r/ytUArcXp2pdtDZ4dTMmGUO/wv3iVVZnWqrrIv5
        elhYhIWe0fvLs9gE+ivQTcut0z/LiWE=
X-Google-Smtp-Source: ABdhPJw05WpbmUN4HZYBGK/97da+KKc64rlVWNX2VvntT6nhPbAlE/Tm9/UntXfy3Y6GVXhbo6zPrg==
X-Received: by 2002:a62:4e86:: with SMTP id c128mr10208417pfb.315.1596762653505;
        Thu, 06 Aug 2020 18:10:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o134sm10100514pfg.200.2020.08.06.18.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 18:10:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use TWA_SIGNAL for task_work related to eventfd
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <d6e647c8-5448-e496-10c0-3c319b0f4a03@kernel.dk>
 <CAG48ez0QE3+a1Gb8ovEv_54wG-HA=Ph7fM4MT8EU8Exti0c_SQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <98be7507-cfa8-56b4-11c3-67a6aea9f684@kernel.dk>
Date:   Thu, 6 Aug 2020 19:10:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0QE3+a1Gb8ovEv_54wG-HA=Ph7fM4MT8EU8Exti0c_SQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/20 7:00 PM, Jann Horn wrote:
> On Fri, Aug 7, 2020 at 1:57 AM Jens Axboe <axboe@kernel.dk> wrote:
>> An earlier commit:
>>
>> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>>
>> ensured that we didn't get stuck waiting for eventfd reads when it's
>> registered with the io_uring ring for event notification, but that didn't
>> cover the general case of waiting on eventfd and having that dependency
>> between io_uring and eventfd.
>>
>> Ensure that we use signaled notification for anything related to eventfd.
> [...]
>> @@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>          */
>>         if (ctx->flags & IORING_SETUP_SQPOLL)
>>                 notify = 0;
>> -       else if (ctx->cq_ev_fd)
>> +       else if (ctx->cq_ev_fd || (req->file && eventfd_file(req->file)))
>>                 notify = TWA_SIGNAL;
> 
> Is the idea here that you want "polling an eventfd" to have different
> UAPI semantics compared to e.g. "polling a pipe"? Or is there
> something in-kernel that makes eventfds special?

I looked more at this after sending it out, and I actually think we want
the logic to be something ala:

else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
        notify = TWA_SIGNAL;

instead, or something like that. Basically if the task is currently
waiting in the kernel, then the wakeup logic isn't enough, while
TWA_SIGNAL will do the right thing.

Looking into if we have a better way to tell if that's the case outside
of checking the targeted task state (and even if TASK_RUNNING is the
right one, vs checking if it's TASK_INTERRUPTIBLE/TASK_UNINTERRUPTIBLE
specifically).

-- 
Jens Axboe

