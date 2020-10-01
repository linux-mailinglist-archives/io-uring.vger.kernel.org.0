Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293352804F4
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 19:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732507AbgJARRr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 13:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732274AbgJARRr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 13:17:47 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE88C0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 10:17:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j13so6934302ilc.4
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 10:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=26TNgPJnQ28vGxnL6uAXIiw6BivGl+AQcqdGkLAETno=;
        b=Vn/KaplLHlB4hObRWV9LvekIYidf0QcYnVlNVg165AcT/4WoGDV47plesoLDvcxZju
         02rPULrU2OoBO7/CrgujuBox0GYnRkjuqIxRA9keN0gckfGnFYwXsQhCbrdr1D99ukwU
         sdC0uQJnfKK9lnlPuHb9HvYUcoyltaYEUDJa76TAal4RyGmmfbNhabg7mSlh3CqtEfGq
         n8+j32SS6J3qi2yHxHISZPjnbZfmka7IZVDz7NYzcZAyLsP+jLptwDuNVk5fx6qsQfTr
         8KqzGBIln2TNqtViWTVzhubd7TGHRyrRq5Gzy8870cSXzuJlFCkvI0iy7IeqR5J7G2Sn
         QYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=26TNgPJnQ28vGxnL6uAXIiw6BivGl+AQcqdGkLAETno=;
        b=VtWR2yZng0pdI2KR5EVWSkF7tsw9XdzqLJsTYqrI8uba8mO+eWVJbpFXJqVMGS+wjZ
         dGbgQfiWY1kT3EaiePC5RV4T19/QOfq6iisQlRcC3ZNSzm1oxM3ICs9Y/cNfFXdwefy2
         E/mVII55MHo3HcDs3ElZErgC3Y8TrjS+mv7YSESI9sWnIjJpOseP4c+9Mm+Wk84VQWco
         Ab+BsQlXE3wpczbjf2nXJRNFm7JRpLF0+fskLoTJEcwdNfce6NYAL7TCepT2hKPjiwjq
         vq3il79Cn0O17wIIzH7bz7fS1ANPLKhjyVTrfVP9dQO1XnC1xnCTuRGoL0P9LKuF/1MB
         DB1Q==
X-Gm-Message-State: AOAM5338uU61nYetZBWbkOSQkeR3sAdaiNr6An4u5rJslRwOQgHXvo9u
        3ztbh1+MgnGf3kwh6lsRl5n6iw==
X-Google-Smtp-Source: ABdhPJx/BXfOX4dlbKL95gzD9sJfq8A2/6KT9dlmPRPH4D+xkRP5g1bqBRSViRs06RdSujRYHIIKJg==
X-Received: by 2002:a05:6e02:1411:: with SMTP id n17mr3303844ilo.211.1601572666281;
        Thu, 01 Oct 2020 10:17:46 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d8sm3229266ilu.2.2020.10.01.10.17.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 10:17:45 -0700 (PDT)
Subject: Re: [PATCH RFC] kernel: decouple TASK_WORK TWA_SIGNAL handling from
 signals
To:     Thomas Gleixner <tglx@linutronix.de>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <0b5336a7-c975-a8f8-e988-e983e2340d99@kernel.dk>
 <875z7uezys.fsf@nanos.tec.linutronix.de>
 <3eafe8ec-7d31-bd46-8641-2d26aca5420d@kernel.dk>
 <87362yeyku.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8a98b921-c1c6-c1b7-e0ff-e2179badda55@kernel.dk>
Date:   Thu, 1 Oct 2020 11:17:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87362yeyku.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/1/20 9:49 AM, Thomas Gleixner wrote:
>>> This is really a hack. TWA_SIGNAL is a misnomer with the new
>>> functionality and combined with the above
>>>
>>>          if (!ret && !notify)
>>>   		wake_up_process(tsk);
>>>
>>> there is not really a big difference between TWA_RESUME and TWA_SIGNAL
>>> anymore. Just the delivery mode and the syscall restart magic.
>>
>> Agree, maybe it'd make more sense to rename TWA_SIGNAL to TWA_RESTART or
>> something like that. The only user of this is io_uring, so it's not like
>> it's a lot of churn to do so.
> 
> I really hate that extra TIF flag just for this. We have way too many
> already and there is work in progress already to address that. I told
> other people already that new TIF flags are not going to happen unless
> the mess is cleaned up. There is work in progress to do so.

I'm open to alternatives, but it does seem like the best match for
something like this...

>>> This needs a lot more thoughts.
>>
>> Definitely, which is why I'm posting it as an RFC. It fixes a real
>> performance regression, and there's no reliable way to use TWA_RESUME
>> that I can tell.
> 
> It's not a performance regression simply because the stuff you had in
> the first place which had more performance was broken. We are not
> measuring broken vs. correct, really.
> 
> You are looking for a way to make stuff perform better and that's
> something totally different and does not need to be rushed. Especially
> rushing stuff into sensible areas like the entry code is not going to
> happen just because you screwed up your initial design.

Nobody is rushing anything - I noticed that I messed up the syscall
restart for task_work && signal, so I fixed it. I'm quite happy taking
my time getting this done the right way.

>> What kind of restart behavior do we need? Before this change, everytime
>> _TIF_SIGPENDING is set and we don't deliver a signal in the loop, we go
>> through the syscall restart code. After this change, we only do so at
>> the end. I'm assuming that's your objection?
> 
> No. That should work by some definition of work, but doing a restart
> while delivering a signal cannot work at all.

Right, this is what v2 fixes, and why I sent it out.

>> For _TIF_TASKWORK, we'll always want to restat the system call, if we
>> were currently doing one. For signals, only if we didn't deliver a
>> signal. So we'll want to retain the restart inside signal delivery?
> 
> No. This needs more thoughts about how restart handling is supposed to
> work in the bigger picture and I'm not going to look at new versions of
> this which are rushed out every half an hour unless there is a proper
> analysis of how all this should play together in a way which does not
> make an utter mess of everything.

Again, this is an RFC, I'm soliciting comments on how we can make this
work. I'd appreciate any hints and help in that regard of course.

Thanks,
-- 
Jens Axboe

