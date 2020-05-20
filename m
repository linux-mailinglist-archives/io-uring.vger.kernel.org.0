Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C32C1DC24C
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 00:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgETWnE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 18:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgETWnD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 18:43:03 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6464AC05BD43
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 15:43:02 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci23so2046317pjb.5
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 15:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yMGpmOi06kg2NChC86QhG6ArrmXyNvKLzVNTDjcsEps=;
        b=vKa2BtqrwpJ2OIAQQiMoagOexaRtHBqLXqhqej/7l3qmBBYVeoWMZTcIVYtRZx0OZU
         dIwu56erl+1x9/ORSBOK0HHu7b6vCMX/SosRtSHNiZ49Czx6qo9aaemFyPqsU42NAwSE
         RkQef1RkljNxjemjRFk9u5xuP5zY2a6nrOOdRBNkxony0DK61xYrA1lTjjp0DbmOK8vd
         IrnxRt0iU05o2gvTZkg7yHTiYTcSutL10Rt7vBm0VgWtuJS3tInaFolESh/nbgjgAo3q
         T2JN3mGN5CFn370kCWp+Ig8YQN/JorJLte/+gwRZ4JyXyWXsehdJZO9q5U+BJKJVZv7i
         JHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yMGpmOi06kg2NChC86QhG6ArrmXyNvKLzVNTDjcsEps=;
        b=ahhSrjJXKSXWiStAsTomOnAxeord8hkPM2eJND6q2sP5VbhQDHc8yQ/WgUS/deIQDH
         fW4k36lT6OdaL3OhY8ZnbVzCJ1RBy5TMf3hOfJURrIfTMVb014+dECtGIoRborlqUye+
         vcC15CRGkAIGWrh+baCMYX/QTVXNSAcCcRHDAavyGuAOZ62GoF9FZRRF3XUiIUvdnacC
         RB0YADlvCJlQQoWq01f9eWExqnXCOrSv+H4AXAlK8DGy+H0hHQwuWb/j3IGWG/9IKSqh
         GB8+I2gRJMK4gbQ1NqGIgsm/rYhIq1TfmEGd0bxUZIQCh+rDIXHeHSLf0n1vPcJ/Ex9Y
         497A==
X-Gm-Message-State: AOAM531mPTh/b+XoGkWb9F/T/+2Cw6JYNo2b7AueG7M6qLbJgHxxfwC9
        V3DoTW0gRXd3ocXBF9PnBl0TDg==
X-Google-Smtp-Source: ABdhPJw1yt/LZP+T6QbQZs6rvn+mGFCHg+0h5jTdbQVLg9NIUcO/ofxkJDW1YP+tB5GHirKM+s0+6Q==
X-Received: by 2002:a17:90b:1101:: with SMTP id gi1mr8195787pjb.117.1590014581794;
        Wed, 20 May 2020 15:43:01 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id w21sm3152642pfu.47.2020.05.20.15.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 15:43:01 -0700 (PDT)
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set
 data->ctx and data->hctx in blk_mq_alloc_request_hctx
To:     Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
References: <20200518093155.GB35380@T590>
 <87imgty15d.fsf@nanos.tec.linutronix.de> <20200518115454.GA46364@T590>
 <20200518131634.GA645@lst.de> <20200518141107.GA50374@T590>
 <20200518165619.GA17465@lst.de> <20200519015420.GA70957@T590>
 <20200519153000.GB22286@lst.de> <20200520011823.GA415158@T590>
 <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de>
 <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
 <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
 <87tv0av1gu.fsf@nanos.tec.linutronix.de>
 <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk>
 <87eereuudh.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ff46486-7d78-cec4-351e-749447f587e9@kernel.dk>
Date:   Wed, 20 May 2020 16:40:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87eereuudh.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 4:14 PM, Thomas Gleixner wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 5/20/20 1:41 PM, Thomas Gleixner wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>> On 5/20/20 8:45 AM, Jens Axboe wrote:
>>>>> It just uses kthread_create_on_cpu(), nothing home grown. Pretty sure
>>>>> they just break affinity if that CPU goes offline.
>>>>
>>>> Just checked, and it works fine for me. If I create an SQPOLL ring with
>>>> SQ_AFF set and bound to CPU 3, if CPU 3 goes offline, then the kthread
>>>> just appears unbound but runs just fine. When CPU 3 comes online again,
>>>> the mask appears correct.
>>>
>>> When exactly during the unplug operation is it unbound?
>>
>> When the CPU has been fully offlined. I check the affinity mask, it
>> reports 0. But it's still being scheduled, and it's processing work.
>> Here's an example, PID 420 is the thread in question:
>>
>> [root@archlinux cpu3]# taskset -p 420
>> pid 420's current affinity mask: 8
>> [root@archlinux cpu3]# echo 0 > online 
>> [root@archlinux cpu3]# taskset -p 420
>> pid 420's current affinity mask: 0
>> [root@archlinux cpu3]# echo 1 > online 
>> [root@archlinux cpu3]# taskset -p 420
>> pid 420's current affinity mask: 8
>>
>> So as far as I can tell, it's working fine for me with the goals
>> I have for that kthread.
> 
> Works for me is not really useful information and does not answer my
> question:
> 
>>> When exactly during the unplug operation is it unbound?

I agree, and that question is relevant to the block side of things. What
Christoph asked in this particular sub-thread was specifically for the
io_uring sqpoll thread, and that's what I was adressing. For that, it
doesn't matter _when_ it becomes unbound. All that matters it that it
breaks affinity and keeps working.

> The problem Ming and Christoph are trying to solve requires that the
> thread is migrated _before_ the hardware queue is shut down and
> drained. That's why I asked for the exact point where this happens.

Right, and I haven't looked into that at all, so don't know the answer
to that question.

> When the CPU is finally offlined, i.e. the CPU cleared the online bit in
> the online mask is definitely too late simply because it still runs on
> that outgoing CPU _after_ the hardware queue is shut down and drained.
> 
> This needs more thought and changes to sched and kthread so that the
> kthread breaks affinity once the CPU goes offline. Too tired to figure
> that out right now.

Yes, to provide the needed guarantees for the block ctx and hctx
mappings we'll need to know exactly at what stage it ceases to run on
that CPU.

-- 
Jens Axboe

