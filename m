Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E322280323
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 17:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgJAPtJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 11:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731917AbgJAPtJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 11:49:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C172DC0613D0;
        Thu,  1 Oct 2020 08:49:08 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601567346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UM0JZQ72FkjBPMNhFWZ2Two/L1BX9C8tgytDYVf/RhQ=;
        b=rqYFIwf3UxNUqitpDNZ3t/Z78J6IhNj6IZ4wQNTCc043ezyXQ6jDV1EQBXEzLfnRWTz8lU
        lB4/gNfxCpBrcRalduBnmHKcRAwkadJcjDcE+DAwtbwcBwNQCVScuctqbMHm9SMV6x/YCM
        gfmIQGyvV/XqOXDnEBXS5+S3Vt8vqSf8HK2bqasL2Jx/3OlwO2qkwg841GOhuETxYiymsb
        xeHJHgvJBlWqaURc6+pT1xJuLow0V76NzlDR+IMBlEShm2TmPq+o97cFPEZUB9XdOCFZH1
        Jfe4yVhGRd8fz6GCL2XdbmEKWbUJJeQZy3hdSF5+sSe5P9OrYMdsyyAiJ6Xf4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601567346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UM0JZQ72FkjBPMNhFWZ2Two/L1BX9C8tgytDYVf/RhQ=;
        b=N+Mm42UgmgrrnX+5c8fQc/8rqkv3rT/6SmljLmsVQR63Yq65LFEI43rWxqHAStuCweS3a2
        kkViMpxsDYiaR0Dw==
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] kernel: decouple TASK_WORK TWA_SIGNAL handling from signals
In-Reply-To: <3eafe8ec-7d31-bd46-8641-2d26aca5420d@kernel.dk>
References: <0b5336a7-c975-a8f8-e988-e983e2340d99@kernel.dk> <875z7uezys.fsf@nanos.tec.linutronix.de> <3eafe8ec-7d31-bd46-8641-2d26aca5420d@kernel.dk>
Date:   Thu, 01 Oct 2020 17:49:05 +0200
Message-ID: <87362yeyku.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 01 2020 at 09:26, Jens Axboe wrote:
> On 10/1/20 9:19 AM, Thomas Gleixner wrote:
>>>  	ret = task_work_add(tsk, cb, notify);
>>> -	if (!ret)
>>> +	if (!ret && !notify)
>> 
>> !notify assumes that TWA_RESUME == 0. Fun to debug if that ever changes.
>
> Agree, I'll make that
>
> 	if (!ret && notify != TWA_SIGNAL)
>
> instead, that's more sane.

It's not more sane. It's just more correct.

>> This is really a hack. TWA_SIGNAL is a misnomer with the new
>> functionality and combined with the above
>> 
>>          if (!ret && !notify)
>>   		wake_up_process(tsk);
>> 
>> there is not really a big difference between TWA_RESUME and TWA_SIGNAL
>> anymore. Just the delivery mode and the syscall restart magic.
>
> Agree, maybe it'd make more sense to rename TWA_SIGNAL to TWA_RESTART or
> something like that. The only user of this is io_uring, so it's not like
> it's a lot of churn to do so.

I really hate that extra TIF flag just for this. We have way too many
already and there is work in progress already to address that. I told
other people already that new TIF flags are not going to happen unless
the mess is cleaned up. There is work in progress to do so.

>> This needs a lot more thoughts.
>
> Definitely, which is why I'm posting it as an RFC. It fixes a real
> performance regression, and there's no reliable way to use TWA_RESUME
> that I can tell.

It's not a performance regression simply because the stuff you had in
the first place which had more performance was broken. We are not
measuring broken vs. correct, really.

You are looking for a way to make stuff perform better and that's
something totally different and does not need to be rushed. Especially
rushing stuff into sensible areas like the entry code is not going to
happen just because you screwed up your initial design.

> What kind of restart behavior do we need? Before this change, everytime
> _TIF_SIGPENDING is set and we don't deliver a signal in the loop, we go
> through the syscall restart code. After this change, we only do so at
> the end. I'm assuming that's your objection?

No. That should work by some definition of work, but doing a restart
while delivering a signal cannot work at all.

> For _TIF_TASKWORK, we'll always want to restat the system call, if we
> were currently doing one. For signals, only if we didn't deliver a
> signal. So we'll want to retain the restart inside signal delivery?

No. This needs more thoughts about how restart handling is supposed to
work in the bigger picture and I'm not going to look at new versions of
this which are rushed out every half an hour unless there is a proper
analysis of how all this should play together in a way which does not
make an utter mess of everything.

Thanks,

        tglx






