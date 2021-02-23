Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560F23224F1
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 05:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhBWEmd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 23:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhBWEmc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 23:42:32 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75273C061574;
        Mon, 22 Feb 2021 20:41:52 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p3so1148161wmc.2;
        Mon, 22 Feb 2021 20:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=65uN+5+XK+EDD+UFbDWqQedCZGodZ0pM7BxCNYW6Fos=;
        b=Y2dhW8cTw++agpoFegKGMZyz1lMPOeYzlFiydu5D2FdbSyObouUiCTNc3tr4b1MHK6
         GWmgCon0QqOxbNw1D0SL8eQo0kmgU+hh382NJ5JD8XqNWwspiCMHWbt+Z4AsbD6f+ZYT
         65sVLyMMekPctnfeQszyVCm7hy+sJnYocOWaYKE/cAm0c8xO0/tdm/mVT9w9KLIJjdNj
         gu8Xg/Z1hk1+jaljFsL3Dy2FifFdOPq8tZrFkcYJYz7nW8HgmWzGIpqY6MDX8tI5ouum
         eMxccg8pZ+xQ5pwZu/52lYQ6Xhq2Zq/KLkPTsvzV/M5Wy3nnKxA4KICyMhPrkMPJXiZl
         jdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=65uN+5+XK+EDD+UFbDWqQedCZGodZ0pM7BxCNYW6Fos=;
        b=eDgQGSGTs7KHJTC2PMg4rxcJqwe63ejL7VXEUhTmFbWOeZWnE1BfiPnrOlLrs4siNn
         fbWtP2EmKRELc0SKKHbc7mpOgyIxzyyh155IdClKG8GmqdtokJ8EooH9hwJlRbqVHVZ7
         SJo8kIQh0Twnt3qXGsRTqZD+QZyXlvjyTkh5N+hGYBcO3y6GYA4sKL/QkMh/Q6h/PwCx
         5cYb5oMVj1oXGv4ih6Dgh43bJ7BvPKZchnP6QchoXBc3/Fz4iL5xi54kPLcm2orrxFtf
         sMpWSJe88mDrQlGyYW6jwnbwLI+G36r9mMeBAtKuCLSTkuBg+ihhnpROR9kAMSRMzRXj
         5iQg==
X-Gm-Message-State: AOAM530ZzmWK2HPwVjlVsUfGYKphR3GF7M+ESWhqlxbZ35Y/4ITytkvJ
        mGL/REcbcJrnnhxp4I8D6mVaeIqPij/srD24E6o=
X-Google-Smtp-Source: ABdhPJxI+7cMGj4HhavoKapixuOjQRwLO0qY1jT82zmd9qjLPXCIKEHW5AYieImdUa1qTlBL4tanZZQ8p93asTgDWrs=
X-Received: by 2002:a1c:f708:: with SMTP id v8mr22428483wmh.25.1614055311109;
 Mon, 22 Feb 2021 20:41:51 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com> <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
 <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com> <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
 <2d37d0ca-5853-4bb6-1582-551b9044040c@kernel.dk> <CA+1E3rKeqaLXBuvpMcjZ37XH9RqJHjPnTFObJj0T-u8K9Otw-w@mail.gmail.com>
 <dd0392a1-acfa-ef4d-5531-5f1dddc9efe7@kernel.dk> <CA+1E3rJqtpfDbKVGBjSYhX=WfzZ2bE8b0U3drUNz_=bp0u9Vuw@mail.gmail.com>
 <03c15e42-c10a-1f67-c60b-ddc11902f9c5@kernel.dk>
In-Reply-To: <03c15e42-c10a-1f67-c60b-ddc11902f9c5@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 23 Feb 2021 10:11:25 +0530
Message-ID: <CA+1E3r+e8FgiHVA4OB_igUBboJH9iMrh+Fm1E5RoEs+o1ryCwg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 22, 2021 at 8:03 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/22/21 6:42 AM, Kanchan Joshi wrote:
> > On Thu, Jan 28, 2021 at 10:54 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 1/28/21 10:13 AM, Kanchan Joshi wrote:
> >>> On Thu, Jan 28, 2021 at 8:08 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 1/28/21 5:04 AM, Kanchan Joshi wrote:
> >>>>> On Wed, Jan 27, 2021 at 9:32 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>>>>>
> >>>>>> On 27/01/2021 15:42, Pavel Begunkov wrote:
> >>>>>>> On 27/01/2021 15:00, Kanchan Joshi wrote:
> >>>>>>>> This RFC patchset adds asynchronous ioctl capability for NVMe devices.
> >>>>>>>> Purpose of RFC is to get the feedback and optimize the path.
> >>>>>>>>
> >>>>>>>> At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
> >>>>>>>> presented to user-space applications. Like regular-ioctl, it takes
> >>>>>>>> ioctl opcode and an optional argument (ioctl-specific input/output
> >>>>>>>> parameter). Unlike regular-ioctl, it is made to skip the block-layer
> >>>>>>>> and reach directly to the underlying driver (nvme in the case of this
> >>>>>>>> patchset). This path between io-uring and nvme is via a newly
> >>>>>>>> introduced block-device operation "async_ioctl". This operation
> >>>>>>>> expects io-uring to supply a callback function which can be used to
> >>>>>>>> report completion at later stage.
> >>>>>>>>
> >>>>>>>> For a regular ioctl, NVMe driver submits the command to the device and
> >>>>>>>> the submitter (task) is made to wait until completion arrives. For
> >>>>>>>> async-ioctl, completion is decoupled from submission. Submitter goes
> >>>>>>>> back to its business without waiting for nvme-completion. When
> >>>>>>>> nvme-completion arrives, it informs io-uring via the registered
> >>>>>>>> completion-handler. But some ioctls may require updating certain
> >>>>>>>> ioctl-specific fields which can be accessed only in context of the
> >>>>>>>> submitter task. For that reason, NVMe driver uses task-work infra for
> >>>>>>>> that ioctl-specific update. Since task-work is not exported, it cannot
> >>>>>>>> be referenced when nvme is compiled as a module. Therefore, one of the
> >>>>>>>> patch exports task-work API.
> >>>>>>>>
> >>>>>>>> Here goes example of usage (pseudo-code).
> >>>>>>>> Actual nvme-cli source, modified to issue all ioctls via this opcode
> >>>>>>>> is present at-
> >>>>>>>> https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5
> >>>>>>>
> >>>>>>> see https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops
> >>>>>>>
> >>>>>>> Looks like good time to bring that branch/discussion back
> >>>>>>
> >>>>>> a bit more context:
> >>>>>> https://github.com/axboe/liburing/issues/270
> >>>>>
> >>>>> Thanks, it looked good. It seems key differences (compared to
> >>>>> uring-patch that I posted) are -
> >>>>> 1. using file-operation instead of block-dev operation.
> >>>>
> >>>> Right, it's meant to span wider than just block devices.
> >>>>
> >>>>> 2. repurpose the sqe memory for ioctl-cmd. If an application does
> >>>>> ioctl with <=40 bytes of cmd, it does not have to allocate ioctl-cmd.
> >>>>> That's nifty. We still need to support passing larger-cmd (e.g.
> >>>>> nvme-passthru ioctl takes 72 bytes) but that shouldn't get too
> >>>>> difficult I suppose.
> >>>>
> >>>> It's actually 48 bytes in the as-posted version, and I've bumped it to
> >>>> 56 bytes in the latest branch. So not quite enough for everything,
> >>>> nothing ever will be, but should work for a lot of cases without
> >>>> requiring per-command allocations just for the actual command.
> >>>
> >>> Agreed. But if I got it right, you are open to support both in-the-sqe
> >>> command (<= 56 bytes) and out-of-sqe command (> 56 bytes) with this
> >>> interface.
> >>> Driver processing the ioctl can fetch the cmd from user-space in one
> >>> case (as it does now), and skips in another.
> >>
> >> Your out-of-seq command would be none of io_urings business, outside of
> >> the fact that we'd need to ensure it's stable if we need to postpone
> >> it. So yes, that would be fine, it just means your actual command is
> >> passed in as a pointer, and you would be responsible for copying it
> >> in for execution
> >>
> >> We're going to need something to handle postponing, and something
> >> for ensuring that eg cancelations free the allocated memory.
> >
> > I have few doubts about allocation/postponing. Are you referring to
> > uring allocating memory for this case, similar to the way
> > "req->async_data" is managed for few other opcodes?
> > Or can it (i.e. larger cmd) remain a user-space pointer, and the
> > underlying driver fetches the command in.
> > If submission context changes (for sqo/io-wq case), uring seemed to
> > apply context-grabbing techniques to make that work.
>
> There are two concerns here:
>
> 1) We need more space than the 48 bytes, which means we need to allocate
>    the command or part of the command when get the sqe, and of course
>    free that when the command is done.
>
> 2) When io_uring_enter() returns and has consumed N commands, the state
>    for those commands must be stable. Hence if you're passing in a
>    pointer to a struct, that struct will have been read and store
>    safely. This prevents things like on-stack structures from being an
>    issue.
>
> ->async_data deals with #2 here, it's used when a command needs to store
> data because we're switching to an async context to execute the command
> (or the command is otherwise deferred, eg links and such). You can
> always rely on the context being sane, it's either the task itself or
> equivalent.

Thanks for sorting this out.

> >>>>> And for some ioctls, driver may still need to use task-work to update
> >>>>> the user-space pointers (embedded in uring/ioctl cmd) during
> >>>>> completion.
> >>>>>
> >>>>> @Jens - will it be fine if I start looking at plumbing nvme-part of
> >>>>> this series on top of your work?
> >>>>
> >>>> Sure, go ahead. Just beware that things are still changing, so you might
> >>>> have to adapt it a few times. It's still early days, but I do think
> >>>> that's the way forward in providing controlled access to what is
> >>>> basically async ioctls.
> >>>
> >>> Sounds good, I will start with the latest branch that you posted. Thanks.
> >>
> >> It's io_uring-fops.v2 for now, use that one.
> >
> > Moved to v3 now.
> > nvme_user_io is 48 bytes, while nvme passthrough requires 72 or 80
> > bytes (passthru with 64 bit result).
> > The block_uring_cmd has 32 bytes of available space. If NVMe defines
> > its own "nvme_uring_cmd" (which can be used for nvme char interface)
> > that will buy some more space, but still won't be enough for passthru
> > command.
> >
> > So I am looking at adding support for large-cmd in uring. And felt the
> > need to clear those doubts I mentioned above.
>
> The simple solution is to just keep the command type the same on the
> NVMe side, and just pass in a pointer to it. Then API could then be
> nr_commands and **commands, for example.
>
> But I think we're getting to the point where it'd be easier to just
> discuss actual code. So if you rebase on top of the v3 code, then send
> out those patches and we can discuss the most convenient API to present
> for nvme passthrough and friends. Does that work?

Yes, perfect. I will go about that.
