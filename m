Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D618455067
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 23:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhKQW3c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 17:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241209AbhKQW31 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 17:29:27 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB94C061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 14:26:27 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id p4so4240384qkm.7
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 14:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fIFSYR5oDtZ1H7mQhwPY7SO4mu/8yyQ4jYLgc+T4ALA=;
        b=eSOuZnJjuMjK36y5fHVBBRDur2pOngcl3oSYSzJMrOHfXx6JnF3zo/hWBpR5MWuRfX
         VcLUVzEXV9XWMlXji0pDX4CugICZoX8ncXoqctAGFFO5fyZkXWaE+oa7U1TZ0p3xY4L2
         1iqQRXllHjS5NhjPpF2vGlFKm/F3YLUCGH0MrC+8XgPR/2asfBfKBMzRtbvZzIRqzAks
         nyvIlQKljHI8Tvl5rIUOWdfzoaseOW1DGzgUrCiNzbg2yCv1XvsII8zGgBObdWrlXRSR
         kefZpsRk2f7Kbec1QwfwtdCsCEk1jtOdUGiyyYx1UOu7wCg49/N0trID4GMq74oxrZFM
         RXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fIFSYR5oDtZ1H7mQhwPY7SO4mu/8yyQ4jYLgc+T4ALA=;
        b=uKwLTdc/N5skJObpAn4/pzI4jQJZB1mYYNosZCNfWJxtcowG6LPB1ruOTN5WjYzY5H
         dBOTRDveFmOIbLwFGbqBWWUkA7PpFn/4eE1FD8TANetcIuTa3HXBlsFE3SI8AgcenYoM
         //0vYEISgMcVpU28BhmN7/Bq2Qm5e5YcNdOwoiLbf1wBJ8WKYMp0wU4HaYJfawvF2ITB
         4WzlqDedLHvcKGJwizG2w0l3Ne266EepRqOHwVuOmbFJrPwSsKnOCABg9pmSR5/arkkQ
         A030ahIabEI+53+2LoP3kpigAtvlozIDJHizuRt8pcjvk7/avmsMOHIfrvR0avGxoQKV
         zffA==
X-Gm-Message-State: AOAM532hj4WiMd3KrOzl08/O69me3b4QJ6+h2X2Fcnzde3cohVg6v0uo
        5UBiynkYv/fY8Q0gVjTPM/amFA==
X-Google-Smtp-Source: ABdhPJwrJwV+j4r6Zh2jHJONUfkSMV0uwfBez4JbCEa+YqYEe6r92h01GGVXtnJ5TgtQ8o2dRre9Jw==
X-Received: by 2002:a05:620a:208c:: with SMTP id e12mr5459888qka.445.1637187987082;
        Wed, 17 Nov 2021 14:26:27 -0800 (PST)
Received: from localhost (cpe-98-15-154-102.hvc.res.rr.com. [98.15.154.102])
        by smtp.gmail.com with ESMTPSA id c24sm687479qkp.43.2021.11.17.14.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 14:26:26 -0800 (PST)
Date:   Wed, 17 Nov 2021 17:26:25 -0500
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Drew DeVault <sir@cmpwn.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <YZWBkZHdsh5LtWSG@cmpxchg.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 15, 2021 at 08:35:30PM -0800, Andrew Morton wrote:
> On Sat, 6 Nov 2021 14:12:45 +0700 Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
> 
> > On 11/6/21 2:05 PM, Drew DeVault wrote:
> > > Should I send a v2 or is this email sufficient:
> > > 
> > > Signed-off-by: Drew DeVault <sir@cmpwn.com>
> > 
> > Oops, I missed akpm from the CC list. Added Andrew.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Ref: https://lore.kernel.org/io-uring/CFII8LNSW5XH.3OTIVFYX8P65Y@taiga/
> 
> Let's cc linux-mm as well.
> 
> 
> Unfortunately I didn't know about this until Nov 4, which was formally
> too late for 5.16.  I guess I could try to sneak it past Linus if
> someone were to send me some sufficiently convincing words explaining
> the urgency.
> 
> I'd also be interested in seeing feedback from the MM developers.
> 
> And a question: rather than messing around with a constant which will
> need to be increased again in a couple of years, can we solve this one
> and for all?  For example, permit root to set the system-wide
> per-process max mlock size and depend upon initscripts to do this
> appropriately.

My take is that as long as the kernel sets some limit per default on
this at all, it should be one that works for common workloads. Today
this isn't the case.

We've recently switched our initscripts at FB to set the default to
0.1% of total RAM. The impetus for this was a subtle but widespread
issue where we failed to mmap the PERF_COUNT_SW_TASK_CLOCK event
counter (perf event mmap also uses RLIMIT_MEMLOCK!) and silently fell
back to the much less efficient clock_gettime() syscall.

Because the failure mode was subtle and annoying, we didn't just want
to raise the limit, but raise it so that no reasonable application
would run into it, and only buggy or malicious ones would.

And IMO, that's really what rlimits should be doing: catching clearly
bogus requests, not trying to do fine-grained resource control. For
more reasonable overuse that ends up causing memory pressure, the OOM
killer will do the right thing since the pages still belong to tasks.

So 0.1% of the machine seemed like a good default formula for
that. And it would be a bit more future proof too.

On my 32G desktop machine, that would be 32M. For comparison, the
default process rlimit on that machine is ~120k, which comes out to
~2G worth of kernel stack, which also isn't reclaimable without OOM...

> From: Drew DeVault <sir@cmpwn.com>
> Subject: Increase default MLOCK_LIMIT to 8 MiB
> 
> This limit has not been updated since 2008, when it was increased to 64
> KiB at the request of GnuPG.  Until recently, the main use-cases for this
> feature were (1) preventing sensitive memory from being swapped, as in
> GnuPG's use-case; and (2) real-time use-cases.  In the first case, little
> memory is called for, and in the second case, the user is generally in a
> position to increase it if they need more.
> 
> The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
> preparing fixed buffers for high-performance I/O.  This use-case will take
> as much of this memory as it can get, but is still limited to 64 KiB by
> default, which is very little.  This increases the limit to 8 MB, which
> was chosen fairly arbitrarily as a more generous, but still conservative,
> default value.
> 
> It is also possible to raise this limit in userspace.  This is easily
> done, for example, in the use-case of a network daemon: systemd, for
> instance, provides for this via LimitMEMLOCK in the service file; OpenRC
> via the rc_ulimit variables.  However, there is no established userspace
> facility for configuring this outside of daemons: end-user applications do
> not presently have access to a convenient means of raising their limits.
> 
> The buck, as it were, stops with the kernel.  It's much easier to address
> it here than it is to bring it to hundreds of distributions, and it can
> only realistically be relied upon to be high-enough by end-user software
> if it is more-or-less ubiquitous.  Most distros don't change this
> particular rlimit from the kernel-supplied default value, so a change here
> will easily provide that ubiquity.
> 
> Link: https://lkml.kernel.org/r/20211028080813.15966-1-sir@cmpwn.com
> Signed-off-by: Drew DeVault <sir@cmpwn.com>
> Acked-by: Jens Axboe <axboe@kernel.dk>
> Acked-by: Cyril Hrubis <chrubis@suse.cz>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

As per above, I think basing it off of RAM size would be better, but
this increase is overdue given all the new users beyond mlock(), and
8M is much better than the current value.
