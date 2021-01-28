Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4383A307589
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 13:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhA1MGo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 07:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhA1MFz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 07:05:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FFBC061573;
        Thu, 28 Jan 2021 04:05:15 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c4so2424028wru.9;
        Thu, 28 Jan 2021 04:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FvPd5ifPVoBtRVnaGQOlqp/tByyxR4FiQHLJy7BycmA=;
        b=FxGiNKqvyueMB/lnAWyUND5sS13WlwGLefVHBucluxwpfTiLTiB/tqj2CEBOCAXLa6
         5z15i3J/sJAdQD0DyjNpqcBY+mfNIzkeryFwpejOq3p21irD1hy5eLoncofJX3N7VZyM
         qup1Glfv1Bohk6ivde403LQE10t2+FZy/qti/s/H+fqCeOO5XJj0eP0hiEzaets9d3oQ
         skh/3y7ZAX1y4BzRWT13oucubWLb6TgW0/dOt0m6MdEhok52ok0sbVAwq/ZX3eOL8jPw
         jKF+Ge1YdnFYtM9zRMxwUYAAyBeZow6YfMyrOAc8YGH5rVSvUe9r/AB/Eva+M0JGjGXN
         ZuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FvPd5ifPVoBtRVnaGQOlqp/tByyxR4FiQHLJy7BycmA=;
        b=O/DIa04k7pf+9jRM+2Q9jaJh4hK+ttv51ztizPBBdfTS7QQJwIuDg9YeaEZpvTPKh2
         xSVUFsCIBxaHaVrA1xLgjIdiw3XVXG1QstN6/+tyf8OaR7uIwO6u6G0lMytQv+jN9/KV
         Xi73IWgL2yQBCuQJyCxPqUJP9obeLMFQsXuAT2RDST5HcOdqvxwNAirRdV5PaOa5iESc
         jB8ZygL2QvnB5d1STAxka8Nn0/0p1GDzbMbHLlS6ehHZ0BqmbHqxEnygfF1Ilo4uRZAA
         J+VNXH3FQOX73Slzym+5gSQHQjiE+A6qw8QVQKu61CdmZ+82CUrnL53K735ZDwgKEDu+
         IG6w==
X-Gm-Message-State: AOAM531xlF5b+AA/GVAjcIxv4hbrAxg/lhFDSunsy1O9r/0PVSM8PXhv
        mVvzZxjf+Uj/iUwR+Xh+LdrGu+KkZ8HFq807mHI=
X-Google-Smtp-Source: ABdhPJwNKo9SgZ9Tw1csbr5dfyG4j+Gv4mh1lZYbpPwxkNVOWelF2qV1h2YZAKH8JyH5w+J7D7mZ0eXfhFXPOnnld+I=
X-Received: by 2002:adf:f182:: with SMTP id h2mr15937080wro.355.1611835513892;
 Thu, 28 Jan 2021 04:05:13 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com> <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
 <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com>
In-Reply-To: <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 28 Jan 2021 17:34:47 +0530
Message-ID: <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
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

On Wed, Jan 27, 2021 at 9:32 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 27/01/2021 15:42, Pavel Begunkov wrote:
> > On 27/01/2021 15:00, Kanchan Joshi wrote:
> >> This RFC patchset adds asynchronous ioctl capability for NVMe devices.
> >> Purpose of RFC is to get the feedback and optimize the path.
> >>
> >> At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
> >> presented to user-space applications. Like regular-ioctl, it takes
> >> ioctl opcode and an optional argument (ioctl-specific input/output
> >> parameter). Unlike regular-ioctl, it is made to skip the block-layer
> >> and reach directly to the underlying driver (nvme in the case of this
> >> patchset). This path between io-uring and nvme is via a newly
> >> introduced block-device operation "async_ioctl". This operation
> >> expects io-uring to supply a callback function which can be used to
> >> report completion at later stage.
> >>
> >> For a regular ioctl, NVMe driver submits the command to the device and
> >> the submitter (task) is made to wait until completion arrives. For
> >> async-ioctl, completion is decoupled from submission. Submitter goes
> >> back to its business without waiting for nvme-completion. When
> >> nvme-completion arrives, it informs io-uring via the registered
> >> completion-handler. But some ioctls may require updating certain
> >> ioctl-specific fields which can be accessed only in context of the
> >> submitter task. For that reason, NVMe driver uses task-work infra for
> >> that ioctl-specific update. Since task-work is not exported, it cannot
> >> be referenced when nvme is compiled as a module. Therefore, one of the
> >> patch exports task-work API.
> >>
> >> Here goes example of usage (pseudo-code).
> >> Actual nvme-cli source, modified to issue all ioctls via this opcode
> >> is present at-
> >> https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5
> >
> > see https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops
> >
> > Looks like good time to bring that branch/discussion back
>
> a bit more context:
> https://github.com/axboe/liburing/issues/270

Thanks, it looked good. It seems key differences (compared to
uring-patch that I posted) are -
1. using file-operation instead of block-dev operation.
2. repurpose the sqe memory for ioctl-cmd. If an application does
ioctl with <=40 bytes of cmd, it does not have to allocate ioctl-cmd.
That's nifty. We still need to support passing larger-cmd (e.g.
nvme-passthru ioctl takes 72 bytes) but that shouldn't get too
difficult I suppose.

And for some ioctls, driver may still need to use task-work to update
the user-space pointers (embedded in uring/ioctl cmd) during
completion.

@Jens - will it be fine if I start looking at plumbing nvme-part of
this series on top of your work?


Thanks,
