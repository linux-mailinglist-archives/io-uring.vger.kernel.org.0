Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6AD76A40E
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 00:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGaWSe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 18:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjGaWSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 18:18:32 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91181173F
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 15:18:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686f0d66652so4804860b3a.2
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 15:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690841911; x=1691446711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2wPP8AERrRDTQNX+1JFvaoC91KrJbsyPkwsxQgRGRP0=;
        b=dHd5S+DORKaIaY6KeyMSnMGCs/qrQtn0ib3Y2/dlqnTKK2Nz0QhvrcQr2ig92PK+T4
         JV2EM3qn5oSLYjbUajziu9Gh2n9PH5WpOtNgxFFR+RpQHgJON9LYsX3YmLEL8kMnXK8x
         81Un6fu/ud2ojtanuPfrADAvwb0cwujtxrvijehsl3os0mus3h/bWYMEvXhYpiwIBH8t
         A2RZUFjcL9hu1d+KCvvdW61+MsvVuwEAIm1cIcp94X8FuwLZdTXY1EthDEm7nO/yr//M
         yyL02c/l/5MQiC6NjlRh22Yn+vcs6ekxuwjKZsG0JqWEQH5N5VDdfKO6BcFV1Wwm3bjI
         mmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690841911; x=1691446711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wPP8AERrRDTQNX+1JFvaoC91KrJbsyPkwsxQgRGRP0=;
        b=BaKRYnbtSL1bM/Imo2cnixnE/eDX1GODb3i8jueGSDRU9EBcY9H8TVAnMDj/aeUWES
         Doc8KB16L3J4b7jYiWgox1sP6kpi1YM9GxgvHICiuvkXgMRs3pNd+9JLpjV0cutqjOYG
         bjqVuwW+mDkBeNqkEuwaYQ2XhFSK7UT7dOhOw7+jTQ4fBQSBziIeRwsPHr0CjYVmi8jK
         /U9BA6MhY84GKwAz2VO1eioaU3ER+YHrpyxHOfgsVWXAh7poTAjU4LLQmhkXcKyni5XV
         5ESGLQ9/2iAfsWco1GVVRGczb+5f0+yhFvTrGXFAPZKPwgII5yW2ZieVu7bdOlZ/aIKW
         4WLQ==
X-Gm-Message-State: ABy/qLaaUzk+pyp7ehXqaj34Ha6qhBavdY+JAllyUQWaGQMR9yaKGeBk
        cksl+uKPwcbDnVFDeLkOV/IBZA==
X-Google-Smtp-Source: APBJJlFfpcPpWzqKCTJ7zGsK85j44O0xi2O4EFPIVYf+G6mAf7euEqGKl+PKcnkdMjGYbpaIXCAQvw==
X-Received: by 2002:a05:6a21:66cb:b0:138:1c:a242 with SMTP id ze11-20020a056a2166cb00b00138001ca242mr11246683pzb.23.1690841911063;
        Mon, 31 Jul 2023 15:18:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id c5-20020aa78c05000000b00682562b1549sm8006873pfd.24.2023.07.31.15.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 15:18:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qQbDf-00CtkE-0o;
        Tue, 01 Aug 2023 08:18:27 +1000
Date:   Tue, 1 Aug 2023 08:18:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>, Hao Xu <hao.xu@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Message-ID: <ZMgzM9YF1WyJBOd/@dread.disaster.area>
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
 <ZMcPUX0lYC2nscAm@dread.disaster.area>
 <20230731-gezeugt-tierwelt-f3d6a900c262@brauner>
 <20230731152623.GC11336@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731152623.GC11336@frogsfrogsfrogs>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 31, 2023 at 08:26:23AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 31, 2023 at 10:13:21AM +0200, Christian Brauner wrote:
> > On Mon, Jul 31, 2023 at 11:33:05AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 27, 2023 at 04:27:30PM +0200, Christian Brauner wrote:
> > > But as I said in the "llseek for io-uring" thread, we need to stop
> > > the game of whack-a-mole passing random nowait boolean flags to VFS
> > > operations before it starts in earnest.  We really need a common
> > > context structure (like we have a kiocb for IO operations) that
> > > holds per operation control state so we have consistency across all
> > > the operations that we need different behaviours for.
> > 
> > Yes, I tend to agree and thought about the same. But right now we don't
> > have a lot of context. So I would lean towards a flag argument at most.
> > 
> > But I also wouldn't consider it necessarily wrong to start with booleans
> > or a flag first and in a couple of months if the need for more context
> > arises we know what kind of struct we want or need.
> 
> I'm probably missing a ton of context (because at the end of the day I
> don't care all that much about NOWAIT and still have never installed
> liburing) but AFAICT the goal seems to be that for a given io request,
> uring tries to execute it with trylocks in the originating process
> context.  If that attempt fails, it'll punt the io to a workqueue and
> rerun the request with blocking locks.  Right?

Yes, that might be the case for the VFS level code we are talking
about right now....

... but, for example, I have no clue what task context
nvmet_file_execute_rw() runs in but it definitely issues file IO
with IOCB_NOWAIT...

> I've watched quite a bit of NOWAIT whackamole going on over the past few
> years (i_rwsem, the ILOCK, the IO layer, memory allocations...).  IIRC
> these filesystem ios all have to run in process context, right?  If so,
> why don't we capture the NOWAIT state in a PF flag?  We already do that
> for NOFS/NOIO memory allocations to make sure that /all/ reclaim
> attempts cannot recurse into the fs/io stacks.

Interesting idea.

That would mean the high level code would have to toggle the task
flags before calling into the VFS, which means we'd have to capture
RWF_NOWAIT flags at the syscall level rather than propagating them
into the iocb. That may impact speed racers, because the RWF flag
propagation has been a target of significant micro-optimisation
since io_uring came along....

> "I prefer EAGAIN errors to this process blocking" doesn't seem all that
> much different.  But, what do I know...

Yeah, I can see how that might be advantageous from an API
persepective, though my gut says "that's a can of worms" but I
haven't spent enough time thinking about it to work out why I feel
that way.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
