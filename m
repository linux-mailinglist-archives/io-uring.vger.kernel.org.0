Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21E7D77D6
	for <lists+io-uring@lfdr.de>; Thu, 26 Oct 2023 00:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjJYW2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 18:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjJYW2f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 18:28:35 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04EAE5
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 15:28:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6bd96cfb99cso221136b3a.2
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 15:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698272912; x=1698877712; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a/zohdYHYB8xgSRg6885BBGHf24YwLAdAnopLL9bSYk=;
        b=Zf/ZLaJDofKdGB3ULX04n5wxgmY/ktCqghBvCEuJaPKJsNeCHRf14FLrikGcHKo17X
         blJ8tbhshAxm49xKnqcn2lNmYfPWAa8Mut9l+ueabIUg9ZVZyOtwI9XPZ8hKNm4uY1qG
         JT8bQ4yiOkXofJnioffd9m6uvI8Fej952h+2RwLPpEb0nZZPFqyaSXZMVKt9A0S+bFaX
         yrgz/ZHrBH9x2VKx5C5Ev8rv/803cSjJtdwqvUwEqXCBX3NYqHIIAkrVcfJOlXxSZMoN
         uSFucTnYcZooZhcJrH7HwH3rjBi4hDXFGsq5PSKCxetybXRD7RG0GW/qQ4M6ntmnLgXv
         R85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698272912; x=1698877712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/zohdYHYB8xgSRg6885BBGHf24YwLAdAnopLL9bSYk=;
        b=qovoR8+NcD58+1mPP+CyMcmUE4Ou/oyhkyO8vFTJYUnlH3TymB1wMnGDoprkwHjPu3
         M1Hzalhbia0i/fUyssCWOQCSfcof1+dMXS3xlAvX1zp6yMneJOuPtB30B8PpyjcAJPvA
         8Pts4bvr7y0O18uII/LapppAVOTDfJXxdqECjLr5UiFk5pmYhMeb3ap5g+5FiHBYXDpz
         DaOLRtGXI2bUAZlbWkDFi/5Mc2gCbnDSKc1v0mWnmEQ4OEHnmayJN9mpuh/HUONIMrUV
         qN2xcvdxNa+1sksG1t+7Gj5YPU+T0t4/7jzFjVzOpv6sw8CJuNadB8Fpe89QK8tc3iPk
         iIVQ==
X-Gm-Message-State: AOJu0Yw1+/qzfHfOjUM9tjSLGsOTTqA3bX2aQn6tFPZaAb7yMmyv9vRH
        0n5KXjC/MX+D6dQX7DJbAfvIrA==
X-Google-Smtp-Source: AGHT+IE5kNtbyYxea9Ya2MFjMHtE2mIq6uXnsSrALqEqZ2Kta9K4sQrMCR7le9WQ8lzn5OFVbfU2rQ==
X-Received: by 2002:a05:6a00:855:b0:690:2e46:aca3 with SMTP id q21-20020a056a00085500b006902e46aca3mr14596181pfk.25.1698272912282;
        Wed, 25 Oct 2023 15:28:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id q29-20020aa7983d000000b006bdb0f011e2sm9861014pfl.123.2023.10.25.15.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 15:28:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qvmMX-003vaO-03;
        Thu, 26 Oct 2023 09:28:29 +1100
Date:   Thu, 26 Oct 2023 09:28:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andres Freund <andres@anarazel.de>, Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        Ricardo =?iso-8859-1?Q?Ca=F1uelo?= 
        <ricardo.canuelo@collabora.com>, gustavo.padovan@collabora.com,
        zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
Subject: Re: task hung in ext4_fallocate #2
Message-ID: <ZTmWjWeNCgGcdIy+@dread.disaster.area>
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
 <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 24, 2023 at 06:34:05PM -0600, Jens Axboe wrote:
> On 10/24/23 6:06 PM, Dave Chinner wrote:
> > On Tue, Oct 24, 2023 at 12:35:26PM -0600, Jens Axboe wrote:
> >> On 10/24/23 8:30 AM, Jens Axboe wrote:
> >>> I don't think this is related to the io-wq workers doing non-blocking
> >>> IO.
> > 
> > The io-wq worker that has deadlocked _must_ be doing blocking IO. If
> > it was doing non-blocking IO (i.e. IOCB_NOWAIT) then it would have
> > done a trylock and returned -EAGAIN to the worker for it to try
> > again later. I'm not sure that would avoid the issue, however - it
> > seems to me like it might just turn it into a livelock rather than a
> > deadlock....
> 
> Sorry typo, yes they are doing blocking IO, that's all they ever do. My
> point is that it's not related to the issue.
> 
> >>> The callback is eventually executed by the task that originally
> >>> submitted the IO, which is the owner and not the async workers. But...
> >>> If that original task is blocked in eg fallocate, then I can see how
> >>> that would potentially be an issue.
> >>>
> >>> I'll take a closer look.
> >>
> >> I think the best way to fix this is likely to have inode_dio_wait() be
> >> interruptible, and return -ERESTARTSYS if it should be restarted. Now
> >> the below is obviously not a full patch, but I suspect it'll make ext4
> >> and xfs tick, because they should both be affected.
> > 
> > How does that solve the problem? Nothing will issue a signal to the
> > process that is waiting in inode_dio_wait() except userspace, so I
> > can't see how this does anything to solve the problem at hand...
> 
> Except task_work, which when it completes, will increment the i_dio
> count again. This is the whole point of the half assed patch I sent out.

What task_work is that?  When does that actually run?

Please don't assume that everyone is intimately familiar with the
subtle complexities of io_uring infrastructure - if the fix relies
on a signal from -somewhere- then you need to explain where
that signal comes from and why we should be able to rely on that...

> 
> > I'm also very leary of adding new error handling complexity to paths
> > like truncate, extent cloning, fallocate, etc which expect to block
> > on locks until they can perform the operation safely.
> 
> I actually looked at all of them, ext4 and xfs specifically. It really
> doesn't seem to bad.
> 
> > On further thinking, this could be a self deadlock with
> > just async direct IO submission - submit an async DIO with
> > IOCB_CALLER_COMP, then run an unaligned async DIO that attempts to
> > drain in-flight DIO before continuing. Then the thread waits in
> > inode_dio_wait() because it can't run the completion that will drop
> > the i_dio_count to zero.
> 
> No, because those will be non-blocking. Any blocking IO will go via
> io-wq, and that won't then hit the deadlock. If you're doing
> inode_dio_wait() from the task itself for a non-blocking issue, then
> that would surely be an issue. But we should not be doing that, and we
> are checking for it.

There's no documentation that says IO submission inside a
IOCB_DIO_CALLER_COMP context must be IOCB_NOWAIT.

I don't recall it being mentioned during patch submission or review,
and if it was ithe implications certainly didn't register with me -
I would not have given a rvb without such a landmine either being
removed or very well documented.

I don't see anywhere that is checked and I don't see how it can be,
because the filesystem IO submission path itself has no idea if the
caller is already has a IOCB_DIO_CALLER_COMP IO in flight and
pending completion.

> > Hence it appears to me that we've missed some critical constraints
> > around nesting IO submission and completion when using
> > IOCB_CALLER_COMP. Further, it really isn't clear to me how deep the
> > scope of this problem is yet, let alone what the solution might be.
> 
> I think you're missing exactly what the deadlock is.

Then you need to explain exactly what it is, not send undocumented
hacks that appear to do absolutely nothing to fix the problem.

> > With all this in mind, and how late this is in the 6.6 cycle, can we
> > just revert the IOCB_CALLER_COMP changes for now?
> 
> Yeah I'm going to do a revert of the io_uring side, which effectively
> disables it. Then a revised series can be done, and when done, we could
> bring it back.

Please revert the whole lot, I'm now unconvinced that this is
functionality we can sanely support at the filesystem level without
a whole lot more thought.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
