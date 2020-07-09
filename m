Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672E721A780
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 21:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGITGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 15:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgGITGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 15:06:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ADBC08C5CE;
        Thu,  9 Jul 2020 12:06:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r12so3474489wrj.13;
        Thu, 09 Jul 2020 12:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z1gOyGKslSEgJ3uSJ29Ov3ex1KeLqnCoWQCiP6rXu5g=;
        b=h0ry14inpKQY/lgHJlfsRpCXkn6trDC9VWetEduPFj/XVI13O84Lfqc/nMYTQhh47Z
         3qddP59YfKyrznOyEQx2jyvWA81O8XFr7p7RoSxCbQ1GJxJ710rQSwpuabzwbnjquJvu
         vKTbqlCK41l/iCLzCusA1J3Dpu1Xxss1V5kTkq75L5cFmWojyG02o4VYvJnH5/GnVKJ+
         kNEUbLENHG1VLeAk6AFSlouAYUK2bLpIKhRDfkvCg4Kn0+tVhF5iDCVyh5kQuaQD8sav
         8VlIYTA0lpCIqBrcI+7aeW3zEPxT64K3a0M0gotyHnfWRAI6mNuy07OiLqyj7CWLJ6Ww
         G9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z1gOyGKslSEgJ3uSJ29Ov3ex1KeLqnCoWQCiP6rXu5g=;
        b=F/4Se9PUSbck1uygYBG+tGjVABHpyNOh0/tfWRSDbAQtEa96LMjdkUVMBLz1hpVQbT
         zk+R9kYsUgMZRroRDPRdUrXmBoeGLFtPPamS1K4ruUnJeuOwh0VPoOdlbGgt37oUn0IK
         D3+ooi1QGkhix/1K+ob14XSw+a/sI2J/wcQEdGLeTRTnPcYuyCpJzOZX/9+5uLZnSnc5
         O+IngaW35790MoK8PWCP3fJ7xkujp4v0YvxUou71O5Ssw8Ey2AB3WPj7JXk3gEn4MfVh
         UbNO38X57CoSDrCYih8Jlr/KdNEwg6rAAm6xOPhoeJftc4kftuZF6VI+Hh480/7Zwp3E
         djEg==
X-Gm-Message-State: AOAM532fPhcWdkDZ6WgJvYGU+qszLCF72Qlds09Bs5sHM/uEAgcyy3NA
        WPWGcyRxvPs4BaxwH276i1nsSg+sZYtnrPfpnek=
X-Google-Smtp-Source: ABdhPJwLNiWelIIW1U0lqwsr/Exp78LayRoHPkAYDJ3WdTDokbN20vizSsKcVJ7zA1RQDN2wjNC90ggUTGSyekhCbxA=
X-Received: by 2002:adf:8444:: with SMTP id 62mr61802850wrf.278.1594321570845;
 Thu, 09 Jul 2020 12:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com> <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com> <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
In-Reply-To: <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 10 Jul 2020 00:35:43 +0530
Message-ID: <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Matias_Bj=C3=B8rling?= <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 12:20 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/9/20 12:36 PM, Kanchan Joshi wrote:
> > On Thu, Jul 9, 2020 at 7:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 7/9/20 8:00 AM, Christoph Hellwig wrote:
> >>> On Thu, Jul 09, 2020 at 07:58:04AM -0600, Jens Axboe wrote:
> >>>>> We don't actually need any new field at all.  By the time the write
> >>>>> returned ki_pos contains the offset after the write, and the res
> >>>>> argument to ->ki_complete contains the amount of bytes written, which
> >>>>> allow us to trivially derive the starting position.
> >
> > Deriving starting position was not the purpose at all.
> > But yes, append-offset is not needed, for a different reason.
> > It was kept for uring specific handling. Completion-result from lower
> > layer was always coming to uring in ret2 via ki_complete(....,ret2).
> > And ret2 goes to CQE (and user-space) without any conversion in between.
> > For polled-completion, there is a short window when we get ret2 but cannot
> > write into CQE immediately, so thought of storing that in append_offset
> > (but should not have done, solving was possible without it).
> >
> > FWIW, if we move to indirect-offset approach, append_offset gets
> > eliminated automatically, because there is no need to write to CQE
> > itself.
> >
> >>>> Then let's just do that instead of jumping through hoops either
> >>>> justifying growing io_rw/io_kiocb or turning kiocb into a global
> >>>> completion thing.
> >>>
> >>> Unfortunately that is a totally separate issue - the in-kernel offset
> >>> can be trivially calculated.  But we still need to figure out a way to
> >>> pass it on to userspace.  The current patchset does that by abusing
> >>> the flags, which doesn't really work as the flags are way too small.
> >>> So we somewhere need to have an address to do the put_user to.
> >>
> >> Right, we're just trading the 'append_offset' for a 'copy_offset_here'
> >> pointer, which are stored in the same spot...
> >
> > The address needs to be stored somewhere. And there does not seem
> > other option but to use io_kiocb?
>
> That is where it belongs, not sure this was ever questioned. And inside
> io_rw at that.
>
> > The bigger problem with address/indirect-offset is to be able to write
> > to it during completion as process-context is different. Will that
> > require entering into task_work_add() world, and may make it costly
> > affair?
>
> It might, if you have IRQ context for the completion. task_work isn't
> expensive, however. It's not like a thread offload.
>
> > Using flags have not been liked here, but given the upheaval involved so
> > far I have begun to feel - it was keeping things simple. Should it be
> > reconsidered?
>
> It's definitely worth considering, especially since we can use cflags
> like Pavel suggested upfront and not need any extra storage. But it
> brings us back to the 32-bit vs 64-bit discussion, and then using blocks
> instead of bytes. Which isn't exactly super pretty.
>
I agree that what we had was not great.
Append required special treatment (conversion for sector to bytes) for io_uring.
And we were planning a user-space wrapper to abstract that.

But good part (as it seems now) was: append result went along with cflags at
virtually no additional cost. And uring code changes became super clean/minimal
with further revisions.
While indirect-offset requires doing allocation/mgmt in application,
io-uring submission
and in completion path (which seems trickier), and those CQE flags
still get written
user-space and serve no purpose for append-write.

-- 
Joshi
