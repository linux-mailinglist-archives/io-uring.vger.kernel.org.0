Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55386241B5B
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 15:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgHKNGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 09:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgHKNGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 09:06:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47C0C061787
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 06:06:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q19so438259pll.0
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 06:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kqgrbgaDbYSWjzibEGpg4nka7M4G8sEc7lFMN/sJpKA=;
        b=TAj+vpG8IS8cYJZ+IAY60l/htOSbR/qIZUhksnHHgX1FY4pOQtEY6CFi3HC48NXtyS
         NjccgTp+0FfL6tKvJkV+CXOYGcPH1uJcAp87SthFqpFLosxVqQHGLOfYnP/9VmugagWs
         OoN7Rn9rlcwKOBvCXgkzaw/OZ/YyjaFTEyWEKcJJwRLl+TMddPW+JoZuIHTKgZ+wUbtT
         kjqbsdBzEAXN71Vj1po7VpOrS0qyftbn2GQ/WkVB2cjPfW+Bb2yU7YvfV0HVGzJrf4pE
         FYFhD8AlZ/wJPKWS5o4/a6rRnRxOYGyii5+f44/z38Qyi3zKFJWX7eHgT4OUnUUMF7Te
         oE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kqgrbgaDbYSWjzibEGpg4nka7M4G8sEc7lFMN/sJpKA=;
        b=D+/KWHqsK26h7hHgnMiHFho3bgDJVBYtirZ9W3sJTQS5vbIawN0rwfa7VAgGFop46N
         wbR/5XrWm6MXQ7lkfR5KVtvrSJFZikykdizXUxmaMwFrgscoECbVn7IO+OeJNQh5DHHr
         WAjBp99JNgAbBDFXR3UW6RXuQdJNyP3OhqU/M46XIMohiBC1xkoIztDpW0iHEhJ3W5+S
         nfqUDhBjGjRisx4viFxfc1JyQWedXqdJ15ZMt6bkHNP+k5GDstpBfx6EtFTjrpcDPFUr
         urdU8jupLwnxDNxjE+F3mRK9Ek914/NYtj7FfjHbHnVQW28ml0qJnTMbtf4kry4fqyau
         kf/A==
X-Gm-Message-State: AOAM531ZOqbZGmk9VZBc7Yba4q9ot3XgXc0v+l5IqGYxbs5YDQ7sN05Y
        p56MBOSHRq9HAqVnhLsQUXDOGA==
X-Google-Smtp-Source: ABdhPJwF+bHd6KY2p1P8e9lx9oFImI5KZZLHZ+E6L7JgNPeCpkJOeRRWvVQbICk8vNLW8FvDyRKtfg==
X-Received: by 2002:a17:902:6b0a:: with SMTP id o10mr761491plk.249.1597151184016;
        Tue, 11 Aug 2020 06:06:24 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c4sm22966780pfo.163.2020.08.11.06.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 06:06:23 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>
References: <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
 <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
 <dfc3bf88-39a3-bd38-b7b6-5435262013d5@kernel.dk>
 <CAG48ez2EzOpWZbhnuBxVBXjRbLZULJJeeTBsdbL6Hzh9-1YYhA@mail.gmail.com>
 <20200811064516.GA21797@redhat.com>
 <20200811065659.GQ3982@worktop.programming.kicks-ass.net>
 <20200811071401.GB21797@redhat.com>
 <20200811074538.GS3982@worktop.programming.kicks-ass.net>
 <20200811081033.GD21797@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <efc48e5e-d4fc-bbaf-467c-24210eb77d9b@kernel.dk>
Date:   Tue, 11 Aug 2020 07:06:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811081033.GD21797@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/20 2:10 AM, Oleg Nesterov wrote:
> On 08/11, Peter Zijlstra wrote:
>>
>> On Tue, Aug 11, 2020 at 09:14:02AM +0200, Oleg Nesterov wrote:
>>> On 08/11, Peter Zijlstra wrote:
>>>>
>>>> On Tue, Aug 11, 2020 at 08:45:16AM +0200, Oleg Nesterov wrote:
>>>>>
>>>>> ->jobctl is always modified with ->siglock held, do we really need
>>>>> WRITE_ONCE() ?
>>>>
>>>> In theory, yes. The compiler doesn't know about locks, it can tear
>>>> writes whenever it feels like it.
>>>
>>> Yes, but why does this matter? Could you spell please?
>>
>> Ah, well, that I don't konw. Why do we need the READ_ONCE() ?
>>
>> It does:
>>
>>> +               if (!(task->jobctl & JOBCTL_TASK_WORK) &&
>>> +                   lock_task_sighand(task, &flags)) {
>>
>> and the lock_task_sighand() implies barrier(), so I thought the reason
>> for the READ_ONCE() was load-tearing, and then we need WRITE_ONCE() to
>> avoid store-tearing.
> 
> I don't think we really need READ_ONCE() for correctness, compiler can't
> reorder this LOAD with cmpxchg() above, and I think we don't care about
> load-tearing.
> 
> But I guess we need READ_ONCE() or data_race() to shut kcsan up.

Thanks, reading through this thread makes me feel better. I agree that
we'll need READ_ONCE() just to shut up analyzers.

I'd really like to get this done at the same time as the io_uring
change. Are you open to doing the READ_ONCE() based JOBCTL_TASK_WORK
addition for 5.9? Alternatively we can retain the 1/2 patch from this
series and I'll open-code it in io_uring, but seems pointless as
io_uring is the only user of TWA_SIGNAL in the kernel anyway.

-- 
Jens Axboe

