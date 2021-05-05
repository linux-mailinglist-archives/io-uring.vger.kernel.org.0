Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6437D374BFA
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 01:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhEEXgU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 19:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhEEXgT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 19:36:19 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B080CC06174A
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 16:35:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id e15so3493006pfv.10
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 16:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=926cAGvfUgvmtC8pdeJ7FxZmXpISXd5xiZDilkdp/Wg=;
        b=rIHZValSBd+t1BgZ2OSP/xJZ10TMnVGal1r+/yi5a609d7m2DmHcNITOwbOb0Wb5zd
         vfrn238jpQq5UgnFr4AVlBrHcX2ijgxjKbewbzz0xUI5hEtkvwp1DaPWkYaJ4DQw/tiF
         vdk37LSH0WNrDlQWW9N8lRFXVwVNASLp1ilgArxRXWAvoYCQ4710JiyURetvKXpqpNUB
         KjFPQqob5AHwCcwO7fUVWP132fLCBFuE7F5pmTg0ceC35VOjXKQEE6Qe2pA1x14IksHy
         UrM28wmnYkbJjtA/JIZOqaqxFppR4WNkDixrHQoDfnrU2v6rZw3lEjFtrJK9Z/G5+Q1I
         mFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=926cAGvfUgvmtC8pdeJ7FxZmXpISXd5xiZDilkdp/Wg=;
        b=mJIfDFGhXnlTTYpBL+TJy9hp3LFzz+dOAeCCiDIRk6+GwTpb7eqqGKLOH2QcOiB3FU
         q4C7dIU/8yahrgzjsM+X+TjV/JJg9Pf66QPVPV9vEslCovL+7bXYJ7pXw0B6LJYRDlij
         hDVOfznt1f5Tyf45B8NOFGPwwiBAdC2P9D+UWpJxFDRJqi7BD339kBp6pDRTg2UqpxrP
         ArEi27mKlFaaQrzZR4j1UwK0RWRTCdasrxFgRfoSCtqHhOmyau4NpyZTMJNbi366tuUM
         Yz2KLfOxnKgGVpmogSEmAlnrcvx9irFwF2felp+3bOCoRRoIsUOrD+PXGnRmfwTt57l4
         D77Q==
X-Gm-Message-State: AOAM5327+LC1Ehhcu7TvL4jf4pQX1uPnGq84RJkqZEtf2Nf/RNr/egse
        tR1ft5VDiORjqfuFrxkbhu3XWA==
X-Google-Smtp-Source: ABdhPJyZ+bOFrOh2PvNWL+GEGQRsxCp6ZkSSjIz0iIqR4GDHW9pR/j90bCvjg0gbyLQ/9p+4anBz6Q==
X-Received: by 2002:a63:4607:: with SMTP id t7mr1240499pga.269.1620257721047;
        Wed, 05 May 2021 16:35:21 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d18sm244862pgo.66.2021.05.05.16.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 16:35:20 -0700 (PDT)
Subject: Re: [PATCH v2] io_thread/x86: setup io_threads more like normal user
 space threads
To:     Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, x86@kernel.org
References: <20210411152705.2448053-1-metze@samba.org>
 <20210505110310.237537-1-metze@samba.org>
 <df4b116a-3324-87b7-ff40-67d134b4e55c@kernel.dk>
 <878s4soncx.ffs@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4d79811e-7b71-009d-ef31-d6af045b25fd@kernel.dk>
Date:   Wed, 5 May 2021 17:35:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <878s4soncx.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 3:57 PM, Thomas Gleixner wrote:
> On Wed, May 05 2021 at 15:24, Jens Axboe wrote:
>> On 5/5/21 5:03 AM, Stefan Metzmacher wrote:
>>> As io_threads are fully set up USER threads it's clearer to
>>> separate the code path from the KTHREAD logic.
>>>
>>> The only remaining difference to user space threads is that
>>> io_threads never return to user space again.
>>> Instead they loop within the given worker function.
>>>
>>> The fact that they never return to user space means they
>>> don't have an user space thread stack. In order to
>>> indicate that to tools like gdb we reset the stack and instruction
>>> pointers to 0.
>>>
>>> This allows gdb attach to user space processes using io-uring,
>>> which like means that they have io_threads, without printing worrying
>>> message like this:
>>>
>>>   warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
>>>
>>>   warning: Architecture rejected target-supplied description
>>>
>>> The output will be something like this:
>>>
>>>   (gdb) info threads
>>>     Id   Target Id                  Frame
>>>   * 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
>>>     2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
>>>     3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
>>>   (gdb) thread 3
>>>   [Switching to thread 3 (LWP 4865)]
>>>   #0  0x0000000000000000 in ?? ()
>>>   (gdb) bt
>>>   #0  0x0000000000000000 in ?? ()
>>>   Backtrace stopped: Cannot access memory at address 0x0
>>
>> I have queued this one up in the io_uring branch, also happy to drop it if
>> the x86 folks want to take it instead. Let me know!
> 
> I have no objections, but heck what's the rush here?
> 
> Waiting a day for the x86 people to respond it not too much asked for
> right?

There's no rush. I just said I've queued it up, and to object if you
want to take it through the tip tree. It's not going out before end of
week anyway, so there's plenty of time. Then I know I won't forget...

-- 
Jens Axboe

