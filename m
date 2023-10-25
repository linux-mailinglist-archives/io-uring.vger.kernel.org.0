Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F437D5EF0
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 02:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344714AbjJYAGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Oct 2023 20:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344663AbjJYAGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Oct 2023 20:06:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDB510CF
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 17:06:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-27d45f5658fso4020941a91.3
        for <io-uring@vger.kernel.org>; Tue, 24 Oct 2023 17:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698192389; x=1698797189; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9cuh9pnEhjPE9K0Glopq/FvywTEeksxy32LVZfdqmQU=;
        b=It68cFMDDobg3AcgynMInXvOe8BYNj7Txn1HGrjQIbtVjlJvfO1IbT9dkjQ65tCLbz
         1lK2GYe0U6NxcLPacJmcRONNZ1u+wxgXgPLM0qY2Y3uaB4rLkhUbm3v8YsA2rsTPQjpX
         neN7TYxy5dtQLrNBusW+3991fM1HBtqWVKyCShPC5kfl51n+9kTsWXCsnO9Qvqvs83+l
         bHpvuGOBqMHr1mS9MI7vJK4Nc4WCkz/gO4Z0fSc1Hr7oACjbDdRKy3rfhxOiNvN/PBSc
         XSehuM1hZIAqPQxNWAz4AYaIawVWJkjVyBWgNXVmK66icDxpPYZsRwmxD+FJp5Jsf7X4
         vkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698192389; x=1698797189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cuh9pnEhjPE9K0Glopq/FvywTEeksxy32LVZfdqmQU=;
        b=EO2Izb8BrqtkFI4n473uV4fubv3RjafuJP0m6CC3gby1+S4ZRJCBafJp/gLHWfBhhl
         RmC1gkaK9Qu8/YlR7Uh/dMnUi6xoiv4Z6Dho2UcGRr7B/7cmTJIh7QxWyRszEY7Klu/y
         sjVhV+3H/xaWzBTH72CYH93QKSwqgKlJnbdCfj2Dzr6TGd9J/dqUGKQ4s0XGBWI9IHL4
         pA+i2whCrgtXVSknaqz+dlVeYJ1GnqPiivy+VFYIM2wX+grpLkXu+EHqrzr9p7Lg2oU5
         D22f5C6S6DwllVFBECejSzpwNkKyxbve4XCiermOlKrNbBvwsVSxXRp1CfwUZC/Ug7Qc
         5f9Q==
X-Gm-Message-State: AOJu0Yzeqc2NgmLUoMk5u4ILJjBr3eznURg6jhinWoB5HB0rTqAgOJD+
        Z4UnPntLFGd5knVg87abzAM6BA==
X-Google-Smtp-Source: AGHT+IGSZwJ0taLJbzZLoOLZipUFJapJ0Aw/EtOpCWXjmdi7fPpKB8dPeh4YhevyeutE/Ky3HymhDA==
X-Received: by 2002:a17:90b:3d8a:b0:27d:b87b:a9d4 with SMTP id pq10-20020a17090b3d8a00b0027db87ba9d4mr13144116pjb.7.1698192389083;
        Tue, 24 Oct 2023 17:06:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id l21-20020a17090a599500b00277560ecd5dsm9144553pji.46.2023.10.24.17.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 17:06:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qvRPl-003WMY-2O;
        Wed, 25 Oct 2023 11:06:25 +1100
Date:   Wed, 25 Oct 2023 11:06:25 +1100
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
Message-ID: <ZThcATP9zOoxb4Ec@dread.disaster.area>
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Oct 24, 2023 at 12:35:26PM -0600, Jens Axboe wrote:
> On 10/24/23 8:30 AM, Jens Axboe wrote:
> > I don't think this is related to the io-wq workers doing non-blocking
> > IO.

The io-wq worker that has deadlocked _must_ be doing blocking IO. If
it was doing non-blocking IO (i.e. IOCB_NOWAIT) then it would have
done a trylock and returned -EAGAIN to the worker for it to try
again later. I'm not sure that would avoid the issue, however - it
seems to me like it might just turn it into a livelock rather than a
deadlock....

> > The callback is eventually executed by the task that originally
> > submitted the IO, which is the owner and not the async workers. But...
> > If that original task is blocked in eg fallocate, then I can see how
> > that would potentially be an issue.
> > 
> > I'll take a closer look.
> 
> I think the best way to fix this is likely to have inode_dio_wait() be
> interruptible, and return -ERESTARTSYS if it should be restarted. Now
> the below is obviously not a full patch, but I suspect it'll make ext4
> and xfs tick, because they should both be affected.

How does that solve the problem? Nothing will issue a signal to the
process that is waiting in inode_dio_wait() except userspace, so I
can't see how this does anything to solve the problem at hand...

I'm also very leary of adding new error handling complexity to paths
like truncate, extent cloning, fallocate, etc which expect to block
on locks until they can perform the operation safely.

On further thinking, this could be a self deadlock with
just async direct IO submission - submit an async DIO with
IOCB_CALLER_COMP, then run an unaligned async DIO that attempts to
drain in-flight DIO before continuing. Then the thread waits in
inode_dio_wait() because it can't run the completion that will drop
the i_dio_count to zero.

Hence it appears to me that we've missed some critical constraints
around nesting IO submission and completion when using
IOCB_CALLER_COMP. Further, it really isn't clear to me how deep the
scope of this problem is yet, let alone what the solution might be.

With all this in mind, and how late this is in the 6.6 cycle, can we
just revert the IOCB_CALLER_COMP changes for now?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
