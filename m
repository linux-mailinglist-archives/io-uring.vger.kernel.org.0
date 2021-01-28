Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0015307C09
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhA1RRG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhA1ROj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:14:39 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98780C06178A;
        Thu, 28 Jan 2021 09:13:55 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j18so4920615wmi.3;
        Thu, 28 Jan 2021 09:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7SlUdwnPEQ27NCqhpgbYeyZWdUr/hbFxWqlJ+t74Kk8=;
        b=ZC610tgYYf3cXDd+K9835SRwKWS9h9WUHGCpEUZ6linSddg1wSPgVUjUNMN6mpS1Xm
         c4RrThuc6ArJUvlpnCsDOLiTLXxwP4gT29yqtbht4QP3gi5mE1lN6atmRBYG5NOiIKd1
         UhbGMFx8WThSp9iqxgoxo/aLM4qGLH8FwsrhUGC7qHZZCD6xm1tQMuyj2HAydcxCz3uI
         zskopGXRLz1XCgVbA2eQnIP2B5tmj8BCKRe8kXTgUz3M5QuORrsxvnYibguygGOosJF4
         8a6/v6PxOY926xVk3IVjtF+tjo+vcHysccUiuGX/6NIZCEvi7yotZrDMKGZbLUbe4IFg
         I9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7SlUdwnPEQ27NCqhpgbYeyZWdUr/hbFxWqlJ+t74Kk8=;
        b=FDUgEWyyvfydp0FdVc+3MX2rp5wGM+BOfQLAvVfTI/t3ulYktL0RwFaOklv8m4dokA
         ldIRNngS2Jq86oi3jJS9aEt0Zi2r/x+NzvwTv4DyDuq5azv1UMPzYP+QJunWuagjn2zt
         b5oynm1l74gvSvX1/7cf3DXwf9d9e0LsRwBXnEFtAVN3AR4AwfSf4D8wEdWIXB5h1Ti5
         SAxWn6chQIH4ANaHd2sUaQkDYVsElxHgUgsxkmjqXxDmYz2fnoBXrkZl0ICz/sm0T7aX
         folWqigcFSRgNmdgm/6bbduEzT5UhEW8sE4AbRpaMC32tppaUfLz812vQ0IPQfKgVfW9
         V/qw==
X-Gm-Message-State: AOAM533VN/m670ub4v+5GrO9w6OAkhKLdCeJSpMKkm/JA5Bi2syhhrTc
        p+zqCZZ3+J4ZS/pRPDytFrQNC5adui4STnY8/JUvnGiIyIY=
X-Google-Smtp-Source: ABdhPJxXfXzFAr81U6woMH6ZlFCnx3rqdBDQvkZZfBp9Z6iPwsJ146GcYd//CXg+XfSzjLO8DPOg85PKnI4yVDcLSOo=
X-Received: by 2002:a1c:5f54:: with SMTP id t81mr233174wmb.25.1611854034115;
 Thu, 28 Jan 2021 09:13:54 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com> <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
 <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com> <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
 <2d37d0ca-5853-4bb6-1582-551b9044040c@kernel.dk>
In-Reply-To: <2d37d0ca-5853-4bb6-1582-551b9044040c@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 28 Jan 2021 22:43:26 +0530
Message-ID: <CA+1E3rKeqaLXBuvpMcjZ37XH9RqJHjPnTFObJj0T-u8K9Otw-w@mail.gmail.com>
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

On Thu, Jan 28, 2021 at 8:08 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/28/21 5:04 AM, Kanchan Joshi wrote:
> > On Wed, Jan 27, 2021 at 9:32 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 27/01/2021 15:42, Pavel Begunkov wrote:
> >>> On 27/01/2021 15:00, Kanchan Joshi wrote:
> >>>> This RFC patchset adds asynchronous ioctl capability for NVMe devices.
> >>>> Purpose of RFC is to get the feedback and optimize the path.
> >>>>
> >>>> At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
> >>>> presented to user-space applications. Like regular-ioctl, it takes
> >>>> ioctl opcode and an optional argument (ioctl-specific input/output
> >>>> parameter). Unlike regular-ioctl, it is made to skip the block-layer
> >>>> and reach directly to the underlying driver (nvme in the case of this
> >>>> patchset). This path between io-uring and nvme is via a newly
> >>>> introduced block-device operation "async_ioctl". This operation
> >>>> expects io-uring to supply a callback function which can be used to
> >>>> report completion at later stage.
> >>>>
> >>>> For a regular ioctl, NVMe driver submits the command to the device and
> >>>> the submitter (task) is made to wait until completion arrives. For
> >>>> async-ioctl, completion is decoupled from submission. Submitter goes
> >>>> back to its business without waiting for nvme-completion. When
> >>>> nvme-completion arrives, it informs io-uring via the registered
> >>>> completion-handler. But some ioctls may require updating certain
> >>>> ioctl-specific fields which can be accessed only in context of the
> >>>> submitter task. For that reason, NVMe driver uses task-work infra for
> >>>> that ioctl-specific update. Since task-work is not exported, it cannot
> >>>> be referenced when nvme is compiled as a module. Therefore, one of the
> >>>> patch exports task-work API.
> >>>>
> >>>> Here goes example of usage (pseudo-code).
> >>>> Actual nvme-cli source, modified to issue all ioctls via this opcode
> >>>> is present at-
> >>>> https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5
> >>>
> >>> see https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops
> >>>
> >>> Looks like good time to bring that branch/discussion back
> >>
> >> a bit more context:
> >> https://github.com/axboe/liburing/issues/270
> >
> > Thanks, it looked good. It seems key differences (compared to
> > uring-patch that I posted) are -
> > 1. using file-operation instead of block-dev operation.
>
> Right, it's meant to span wider than just block devices.
>
> > 2. repurpose the sqe memory for ioctl-cmd. If an application does
> > ioctl with <=40 bytes of cmd, it does not have to allocate ioctl-cmd.
> > That's nifty. We still need to support passing larger-cmd (e.g.
> > nvme-passthru ioctl takes 72 bytes) but that shouldn't get too
> > difficult I suppose.
>
> It's actually 48 bytes in the as-posted version, and I've bumped it to
> 56 bytes in the latest branch. So not quite enough for everything,
> nothing ever will be, but should work for a lot of cases without
> requiring per-command allocations just for the actual command.

Agreed. But if I got it right, you are open to support both in-the-sqe
command (<= 56 bytes) and out-of-sqe command (> 56 bytes) with this
interface.
Driver processing the ioctl can fetch the cmd from user-space in one
case (as it does now), and skips in another.

> > And for some ioctls, driver may still need to use task-work to update
> > the user-space pointers (embedded in uring/ioctl cmd) during
> > completion.
> >
> > @Jens - will it be fine if I start looking at plumbing nvme-part of
> > this series on top of your work?
>
> Sure, go ahead. Just beware that things are still changing, so you might
> have to adapt it a few times. It's still early days, but I do think
> that's the way forward in providing controlled access to what is
> basically async ioctls.

Sounds good, I will start with the latest branch that you posted. Thanks.

-- 
Kanchan
