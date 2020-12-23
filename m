Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5A52E1A94
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 10:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgLWJjb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 04:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgLWJja (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 04:39:30 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022A5C0613D3
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 01:38:50 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id 81so14515152ioc.13
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 01:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A/qRZOYvil/OfQID7knKziejOUC7nS8m86zDH/2y1TA=;
        b=sc63tThJ1JI+ul8DrGG/i9RFG5D/INFlYHhASI0+Rv8nOUHNqc5SZIr4SGr0helqms
         IZhz8XqvgL49gMqENY7MMASxACdWwtC/xMnAo4zP7qP3U329yoJHhmVTUVKCiaQm46pR
         DeskksX9/TUjQPnx3T552q10ORw4FZa7BOnPsFFjw8YXN6sAjqg1mozDE4M611BJDBeJ
         d9gaYl0WeuA7kXbWw9vKFyCcVfenPAAxsHL5nboCig3cOXXwmgL16K+IcgJkCUhqchkf
         3cz91TirsBk3AtKYiVlTnWj2Ddd43xv3NFOIweiAA5snIoNlPdpcEWIjiaUY9NJYak2J
         z/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/qRZOYvil/OfQID7knKziejOUC7nS8m86zDH/2y1TA=;
        b=t/aENsODc3EdpvNOa3VCqtlmh01qcOLICKNtFLN8WAaGy7an/FyIuk6MJyOqK+ohKo
         H+phhrRwvoOxx+Q5NNe6pHoSwlrM8pQdyeMAerKoU+FE8aICPVoGakVmne9VlbMEoiWq
         yuATyyjbS+yzyJxnEBOKdPirieSycU08qhnhxukMGkppxhU/rJ5Apa3F7pR7pYjKZX3E
         UIKWB//OrHfo1xc82lLjxIrMh3hYzp5qKBdlDAwMqb8VAJcZNM2JoibVf+c+/Jfxm5A8
         ZT57f5+A04+Oqef6tGMr5sasw02OYZe9tqfOZ8aTGWryEcMUs4wIuJDvHQHR3fvWjbHX
         oGGQ==
X-Gm-Message-State: AOAM533qYgEyr7zDJI4KwqjEQYcSNHMh9uCSQa53zUgaKD+r9Q8ak2Qt
        CPxqI0ui2nm+5oi+1jQMjq+Iu1npklVUheGjXwI=
X-Google-Smtp-Source: ABdhPJxdni1/TkOrJKCSn9fN48Om8b1IpYF9WqUAx4jIjB16W0rVc4/90XK3g5rPHZkYL8stY8GPA1WWup7BTeoYYLE=
X-Received: by 2002:a05:6602:29cf:: with SMTP id z15mr21543603ioq.39.1608716329236;
 Wed, 23 Dec 2020 01:38:49 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com> <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
 <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
 <58bd0583-5135-56a1-23e2-971df835824c@gmail.com> <da4f2ac2-e9e0-b0c2-1f0a-be650f68b173@gmail.com>
 <CAOKbgA7shBKAnVKXQxd6PadiZi0O7UZZBZ6rHnr3HnuDdtx3ng@mail.gmail.com>
 <c4837bd0-5f19-a94d-5ffb-e59ae17fd095@gmail.com> <CAOKbgA5=Z+6Z-GqrYFBV5T_uqkVU0oSqKhf6C37MkruBCKTcow@mail.gmail.com>
In-Reply-To: <CAOKbgA5=Z+6Z-GqrYFBV5T_uqkVU0oSqKhf6C37MkruBCKTcow@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Dec 2020 16:38:38 +0700
Message-ID: <CAOKbgA70CtfmM7-yFRcGTzJdgoF41MQt7mLC7L_s8jcnrtkB=Q@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23, 2020 at 3:39 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Tue, Dec 22, 2020 at 11:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >
> > On 22/12/2020 11:04, Dmitry Kadashev wrote:
> > > On Tue, Dec 22, 2020 at 11:11 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > [...]
> > >>> What about smaller rings? Can you check io_uring of what SQ size it can allocate?
> > >>> That can be a different program, e.g. modify a bit liburing/test/nop.
> > > Unfortunately I've rebooted the box I've used for tests yesterday, so I can't
> > > try this there. Also I was not able to come up with an isolated reproducer for
> > > this yet.
> > >
> > > The good news is I've found a relatively easy way to provoke this on a test VM
> > > using our software. Our app runs with "admin" user perms (plus some
> > > capabilities), it bumps RLIMIT_MEMLOCK to infinity on start. I've also created
> > > an user called 'ioutest' to run the check for ring sizes using a different user.
> > >
> > > I've modified the test program slightly, to show the number of rings
> > > successfully
> > > created on each iteration and the actual error message (to debug a problem I was
> > > having with it, but I've kept this after that). Here is the output:
> > >
> > > # sudo -u admin bash -c 'ulimit -a' | grep locked
> > > max locked memory       (kbytes, -l) 1024
> > >
> > > # sudo -u ioutest bash -c 'ulimit -a' | grep locked
> > > max locked memory       (kbytes, -l) 1024
> > >
> > > # sudo -u admin ./iou-test1
> > > Failed after 0 rings with 1024 size: Cannot allocate memory
> > > Failed after 0 rings with 512 size: Cannot allocate memory
> > > Failed after 0 rings with 256 size: Cannot allocate memory
> > > Failed after 0 rings with 128 size: Cannot allocate memory
> > > Failed after 0 rings with 64 size: Cannot allocate memory
> > > Failed after 0 rings with 32 size: Cannot allocate memory
> > > Failed after 0 rings with 16 size: Cannot allocate memory
> > > Failed after 0 rings with 8 size: Cannot allocate memory
> > > Failed after 0 rings with 4 size: Cannot allocate memory
> > > Failed after 0 rings with 2 size: Cannot allocate memory
> > > can't allocate 1
> > >
> > > # sudo -u ioutest ./iou-test1
> > > max size 1024
> >
> > Then we screw that specific user. Interestingly, if it has CAP_IPC_LOCK
> > capability we don't even account locked memory.
>
> We do have some capabilities, but not CAP_IPC_LOCK. Ours are:
>
> CAP_NET_ADMIN, CAP_NET_BIND_SERVICE, CAP_SYS_RESOURCE, CAP_KILL,
> CAP_DAC_READ_SEARCH.
>
> The latter was necessary for integration with some third-party thing that we do
> not really use anymore, so we can try building without it, but it'd require some
> time, mostly because I'm not sure how quickly I'd be able to provoke the issue.
>
> > btw, do you use registered buffers?
>
> No, we do not use neither registered buffers nor registered files (nor anything
> else).
>
> Also, I just tried the test program on a real box (this time one instance of our
> program is still running - can repeat the check with it dead, but I expect the
> results to be pretty much the same, at least after a few more restarts). This
> box runs 5.9.5.
>
> # sudo -u admin bash -c 'ulimit -l'
> 1024
>
> # sudo -u admin ./iou-test1
> Failed after 0 rings with 1024 size: Cannot allocate memory
> Failed after 0 rings with 512 size: Cannot allocate memory
> Failed after 0 rings with 256 size: Cannot allocate memory
> Failed after 0 rings with 128 size: Cannot allocate memory
> Failed after 0 rings with 64 size: Cannot allocate memory
> Failed after 0 rings with 32 size: Cannot allocate memory
> Failed after 0 rings with 16 size: Cannot allocate memory
> Failed after 0 rings with 8 size: Cannot allocate memory
> Failed after 0 rings with 4 size: Cannot allocate memory
> Failed after 0 rings with 2 size: Cannot allocate memory
> can't allocate 1
>
> # sudo -u dmitry bash -c 'ulimit -l'
> 1024
>
> # sudo -u dmitry ./iou-test1
> max size 1024

Please ignore the results from the real box above (5.9.5). The memlock limit
interfered with this, since our app was running in the background and it had a
few rings running (most failed to be created, but not all). I'll try to make it
fully stuck and repeat the test with the app dead.

-- 
Dmitry Kadashev
