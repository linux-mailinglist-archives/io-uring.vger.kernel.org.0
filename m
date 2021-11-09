Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C31044B041
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 16:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhKIPYB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 10:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbhKIPYA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 10:24:00 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7773DC061764
        for <io-uring@vger.kernel.org>; Tue,  9 Nov 2021 07:21:14 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id m14so77556496edd.0
        for <io-uring@vger.kernel.org>; Tue, 09 Nov 2021 07:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSAmVjecAs4aWelAXrtkIs6b9BVOwi2l13IK5xollCE=;
        b=ZD1ackSCiC5YEHZhA0RHDq/u0iXXsEINuyKzgs1Jex4OyZ31UwpPLiWOE+qvis/9bi
         T6oFp+Osi3es52KYjcwMmPtjgmhZBI0PRA69yVUnKUCajpybxgEfu8BPedP3IBn24Kwb
         aMYWASRB4aMSRJLBzNhxVlWD/EY4tbW80yQdbJxc0IGmEoM14/cIVJTDwEc81Q+tESyX
         r7uhijBa/D0678pPxfMsgC+Yq4Uiyagjrqr8HBX5EERAXM5XrybcAVs+mGZmmh1vfC7S
         Ev/n8E0NHrI0sUWDLRt6NqJ3FoMFVyKvL0W3qvTnP81me+SsF4wU7Zj5b+i8seof5Lcv
         tErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSAmVjecAs4aWelAXrtkIs6b9BVOwi2l13IK5xollCE=;
        b=4QeKcHtZU9wNCPKgKPpqsdpSZX+82naXPl9dzCLLfAR8x3AaL4YYtGbcYJ0a13meWZ
         YCOz6XCRpZ/9j0MaiyBTuvhkVEgPCRj0FvpjPPSmfJm2cIVUk6o47TJbcgeLRG2jZrfO
         WRht/PN70l5Ci97rpGTvioCHv0PsZMQ88zQ/M2WrS4z7OlaSg5+PgyeljhEQp9BDZ8GW
         LIVsjddgwETEISsc3vPgH4FtXoN7m6hJfN17pkAyxiW07PtChZ7A/P2k9jkD3j07uwEx
         fKDhyiA/2AB8N4D/5MvlTFvdjOphc85t2YadDyKAe28IfvET8p5S+9YMKL2lCUKsV7lh
         1zjA==
X-Gm-Message-State: AOAM533RqEYvwnFAFUEHYnZ6vIhyF7kmMWCm+G6dbWTmXJMA6frHbqCN
        t2AZmm3R1Gh2aEJT47mBMXBPIBqZeLD7xd044O3+6lH94cnblw==
X-Google-Smtp-Source: ABdhPJz8M3x6uPv2PuNXzcdPxsLCWRf3Ib0esfulecePfFtSdLPUsA0IWwmWyXD3vQ8tdpVO6q4HfXibWexn16BNHd8=
X-Received: by 2002:a17:907:a414:: with SMTP id sg20mr10540736ejc.183.1636471273023;
 Tue, 09 Nov 2021 07:21:13 -0800 (PST)
MIME-Version: 1.0
References: <20211106113506.457208-1-ammar.faizi@intel.com>
 <20211106114758.458535-1-ammar.faizi@intel.com> <CAGzmLMWsFYe3VJLonr7dc6Z3qe7YoB8b1meX6hyiHQdacpzBtw@mail.gmail.com>
 <ede7d490-4e48-7acf-725a-161e350e39a0@kernel.dk>
In-Reply-To: <ede7d490-4e48-7acf-725a-161e350e39a0@kernel.dk>
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Date:   Tue, 9 Nov 2021 22:21:00 +0700
Message-ID: <CAGzmLMVNE=YO3ygR_0wrTNzTj+hum+uANqvzVNDmMCsxBarLDw@mail.gmail.com>
Subject: Re: [PATCH v6 liburing] test: Add kworker-hang test
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 9, 2021 at 9:47 PM Jens Axboe wrote:
> On 11/8/21 10:44 PM, Ammar Faizi wrote:
>> On Sat, Nov 6, 2021 at 6:49 PM Ammar Faizi wrote:
>>>
>>> This is the reproducer for the kworker hang bug.
>>>
>>> Reproduction Steps:
>>>   1) A user task calls io_uring_queue_exit().
>>>
>>>   2) Suspend the task with SIGSTOP / SIGTRAP before the ring exit is
>>>      finished (do it as soon as step (1) is done).
>>>
>>>   3) Wait for `/proc/sys/kernel/hung_task_timeout_secs` seconds
>>>      elapsed.
>>>
>>>   4) We get a complaint from the khungtaskd because the kworker is
>>>      stuck in an uninterruptible state (D).
>>>
>>> The kworkers waiting on ring exit are not progressing as the task
>>> cannot proceed. When the user task is continued (e.g. get SIGCONT
>>> after SIGSTOP, or continue after SIGTRAP breakpoint), the kworkers
>>> then can finish the ring exit.
>>>
>>> We need a special handling for this case to avoid khungtaskd
>>> complaint. Currently we don't have the fix for this.
>> [...]
>>> Cc: Pavel Begunkov <asml.silence@gmail.com>
>>> Link: https://github.com/axboe/liburing/issues/448
>>> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
>>> ---
>>>
>>>  v6:
>>>    - Fix missing call to restore_hung_entries() when fork() fails.
>>>
>>>  .gitignore          |   1 +
>>>  test/Makefile       |   1 +
>>>  test/kworker-hang.c | 323 ++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 325 insertions(+)
>>>  create mode 100644 test/kworker-hang.c
>>
>> It's ready for review.
>
> This one is still triggering in the current tree, I'd prefer waiting with
> queueing it up until it's fixed. I can park it in another branch until
> that happens.
>

Understand, thanks!

-- 
Ammar Faizi
