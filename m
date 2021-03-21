Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE6C343497
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 21:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhCUUPh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 16:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhCUUPU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 16:15:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF4C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 13:15:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f17so5461934plr.0
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 13:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NsX9GakXRd3y9pktZ+pFylFGRaP7s/pLt3YBAC4PcRM=;
        b=KPMj181omgYbmC11rELPdTFIwNOAFy4uG6EBows/Gb1v2DldTiRpOG5ZWIiegj9J3Q
         Q1IHFGe2C/2fFCptSRVOSSjG/fMURmBGJ5zYvFazzIdkrRsNfprnvkKfyweRCGvrT7g3
         pg+G0mwmytOjowDaVWaNUuyyAG5DprO5tw6HtdsXekqAYdLmjZI0qsadFRNdZftC/rNW
         luhVKF/YrehbO6VhCXgZvXY3ljCvJQDIHOjZH3jWfXsLWJbX6qhN4NZAX8HX0cfTIC6V
         0xmquWMenOmcE+BLDuhx/FEfAWb5cG0ypV7QsLVd+J1XlDneBx4Jjkd9ho3tkWrARXjR
         qlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NsX9GakXRd3y9pktZ+pFylFGRaP7s/pLt3YBAC4PcRM=;
        b=gwHIlS6jzY+aS08RtxIdSp/I9dxdADW6jKVdAGDFA7I1Kq0OCfMB/UovlkvHoDrzbW
         xY4tpcfIimYSRqlbTc2WQan5kzk383x5UdR34dWhg3NnUe89AG2BqUFzeiXC0lOQhptA
         l/dVAv1aJgVGdTeZTYslqnANIWDQTI3NR8ADX931C2zH5hEMfsSe3t75LAao3TmwGEoI
         5afLhL4AVs7DeVnTSqOkTslegyz/RskjKQcBxbF54OM0+x0Tl+VodeQqkutcbjDdLuLh
         fxDrIAMuXZwB1f55hHjLDRiI9T6WPfrph+nmKtKRCn8Ibdt7+bVR8t+cSFjjjKIvRBki
         5Sug==
X-Gm-Message-State: AOAM532i0oFLSwRwFOfF1KHsAoubMqmcdH5iv/SGnAXUAUy6JfKNS02w
        VGcdzzCTMu2ae9hbhukWRT9BYYuDig7DCQ==
X-Google-Smtp-Source: ABdhPJyE/fT6EkpTTUYCXUJuoCLM5ICzEzeEvHVkP4Uen1ZvcySoq3viS6rOxjObyg9uqmyrMBKxrA==
X-Received: by 2002:a17:902:ed0a:b029:e4:3589:e4f9 with SMTP id b10-20020a170902ed0ab02900e43589e4f9mr24222684pld.36.1616357719250;
        Sun, 21 Mar 2021 13:15:19 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c16sm10995479pfc.112.2021.03.21.13.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 13:15:18 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring followup fixes for 5.12-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ea7f768a-fd67-a265-9d90-27cd5aa26ac9@kernel.dk>
 <CAHk-=wgYhNck33YHKZ14mFB5MzTTk8gqXHcfj=RWTAXKwgQJgg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ce33b95a-1300-adc6-97de-0019a4273f3a@kernel.dk>
Date:   Sun, 21 Mar 2021 14:15:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgYhNck33YHKZ14mFB5MzTTk8gqXHcfj=RWTAXKwgQJgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 1:57 PM, Linus Torvalds wrote:
> On Sun, Mar 21, 2021 at 9:38 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Catch and loop when needing to run task_work before a PF_IO_WORKER
>>   threads goes to sleep.
> 
> Hmm. The patch looks fine, but it makes me wonder: why does that code
> use test_tsk_thread_flag() and clear_tsk_thread_flag() on current?
> 
> It should just use test_thread_flag() and clear_thread_flag().
> 
> Now it looks up "current" - which goes through the thread info - and
> then looks up the thread from that. It's all kinds of stupid.
> 
> It should just have used the thread_info from the beginning, which is
> what test_thread_flag() and clear_thread_flag() do.
> 
> I see the same broken pattern in both fs/io-wq.c (which is where I
> noticed it when looking at the patch) and in fs/io-uring.c.
> 
> Please don't do "*_tsk_thread_flag(current, x)", when just
> "*_thread_flag(x)" is simpler, and more efficient.
> 
> In fact, you should avoid *_tsk_thread_flag() as much as possible in general.
> 
> Thread flags should be considered mostly private to that thread - the
> exceptions are generally some very low-level system stuff, ie core
> signal handling and things like that.
> 
> So please change things like
> 
>         if (test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL))
> 
> to
> 
>         if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> 
> etc.
> 
> And yes, we have a design mistake in a closely related area:
> "signal_pending()" should *not* take the task pointer either, and we
> should have the "current thread" separate from "another thread".
> 
> Maybe the "signal_pending(current)" makes people think it's a good
> idea to pass in "current" to the thread flag checkers. We would have
> been better off with "{fatal_,}signal_pending(void)" for the current
> task, and "tsk_(fatal_,}signal_pending(tsk)" for the (very few) cases
> of checking another task.
> 
> Because it really is all kinds of stupid (yes, often historical -
> going all the way back to when 'current' was the main model - but now
> stupid) to look up "current" to then look up thread data, when these
> days, when the basic pattern is
> 
>   #define current get_current()
>   #define get_current() (current_thread_info()->task)
> 
> ioe, the *thread_info* is the primary and quick thing, and "current"
> is the indirection, and so if you see code that basically does
> "task_thread_info()" on "current", it is literally going back and
> forth between the two.
> 
> And yes, on architectures that use "THREAD_INFO_IN_TASK" (which does
> include x86), the back-and-forth ends up being a non-issue (because
> it's just offsets into containing structs) and it doesn't really
> matter. But conceptually, patterns like "test_tsk_thread_flag(current,
> x)" really are wrong, and on some architectures it generates
> potentially *much* worse code.

Thanks, that's useful information, I guess it just ended up being used
by chance and I didn't realize it made a difference for some archs. I'll
change these, and I also think that io-wq should be a bit nicer and use
tracehook_notify_signal() if TIF_NOTIFY_SIGNAL is set. Doesn't matter
now, but very well might in the future when TIF_NOTIFY_SIGNAL gets
used for more than just task_work notifications.

-- 
Jens Axboe

