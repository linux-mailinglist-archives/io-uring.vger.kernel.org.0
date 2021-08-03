Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DF93DF0DF
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 16:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235486AbhHCO53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 10:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbhHCO53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 10:57:29 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648E9C061757;
        Tue,  3 Aug 2021 07:57:17 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id a93so16123872ybi.1;
        Tue, 03 Aug 2021 07:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9IoTpQSoFN8X9feSI035kPuC1yq++XFdeyD5Oq4YGKU=;
        b=tfU660ceP9Cw9lVo5xVG4iqGiQldb5dnzTWtjqNPtgZ59X5oh/8gmpazWSHzOiYRHs
         4YPnjMgkpVunHrAZj+hd+fqCPVyGNFqT0oCt795YrACgmSxgu7d2SsSCoiz5H/HbBXEa
         mqZIagubbvvRpG3QhQXy0PMZY6fgAOnaqFt8i/z3YQYs2xdVnB0UrMpHzt8eEXUTQ8Jy
         IhiPfdb2rJirBFo3vDdH0lSO8nIfPqbZ6b7Sla5JZJoptP17RzqoLk+SAxwkBAkDZUv2
         Eb5RaXl6wj3rGr4Aso8br/GioipTt1kKzLXHTiaVcGeCymdzYPCCGKZS3ODB2xRkE9po
         2z6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9IoTpQSoFN8X9feSI035kPuC1yq++XFdeyD5Oq4YGKU=;
        b=A9HkzsNA0qaOIJmdkSEaZOXtZv6M0/M6vet31cUOszRXtgWciCVqfqaJUq9OMRmst3
         trFHwDGWHJYzGDOJ5lDQkZszIcSmxQQY8KD3NnPxl1AskeVluuAUN8rKW+nKW1/oeFhV
         MeH/Xv88CU62/xCPSH4Lo6jMrfG9tXZ3K+CDA2gl3a1SI4+NqGPOv409GWqw0HOs7tXL
         RgBIa5hxyXlvE2P46mAF9kpFTNvqbjUTYtqv6nXL4eySlSUsueo4bmxPfPB505CE2lHM
         tOTAFsfxWWZrXQUVV4w2qF9X71JUxj333Uq+KdmsBY1b2sim/mj0Gv9oWA3UgyGGXWZe
         Hcmg==
X-Gm-Message-State: AOAM530IkRVeX4ikxTc8omYbH9gfs3Bfr5uYv+PRmR3R9eM3k/tfRrUp
        337zDgsuvQSEtBLeiXcfUMJeLVBzksx++P7zh90=
X-Google-Smtp-Source: ABdhPJzznB420tcQq5+eEEI7CtIXVisjpepyS5Oyo434ofvSlrzRcz+2mrznrUI0oge3JgIa+IQmUWB6vwiOZr23O58=
X-Received: by 2002:a25:1546:: with SMTP id 67mr29005241ybv.331.1628002636674;
 Tue, 03 Aug 2021 07:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com> <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
 <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com>
 <8db71657-bd61-6b1f-035f-9a69221e7cb3@gmail.com> <CADVatmPPnAWyOmyqT3iggeO_hOuPpALF5hqAqbQkrdvCPB5UaQ@mail.gmail.com>
 <98f8ec51-9d84-0e74-4c1c-a463f2d69d9d@gmail.com>
In-Reply-To: <98f8ec51-9d84-0e74-4c1c-a463f2d69d9d@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 3 Aug 2021 15:56:40 +0100
Message-ID: <CADVatmPB79srVmtudV+r5dZKtRoo8ZHZ62r0uqQLFTH-1yi+7Q@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 3, 2021 at 11:34 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 8/3/21 8:47 AM, Sudip Mukherjee wrote:
> > On Mon, Aug 2, 2021 at 12:55 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 8/1/21 9:28 PM, Sudip Mukherjee wrote:
> >>> Hi Pavel,
> >>>
> >>> On Sun, Aug 1, 2021 at 9:52 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>>>
> >>>> On 8/1/21 1:10 AM, Pavel Begunkov wrote:
> >>>>> On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
> >>>>>> Hi Jens, Pavel,
> >>>>>>
> >>>>>> We had been running syzkaller on v5.10.y and a "KASAN:
> >>>>>> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
> >>>>>> got some time to check that today and have managed to get a syzkaller
> >>>>>> reproducer. I dont have a C reproducer which I can share but I can use
> >>>>>> the syz-reproducer to reproduce this with v5.14-rc3 and also with
> >>>>>> next-20210730.
> >>>>>
> >>>>> Can you try out the diff below? Not a full-fledged fix, but need to
> >>>>> check a hunch.
> >>>>>
> >>>>> If that's important, I was using this branch:
> >>>>> git://git.kernel.dk/linux-block io_uring-5.14
> >>>>
> >>>> Or better this one, just in case it ooopses on warnings.
> >>>
> >>> I tested this one on top of "git://git.kernel.dk/linux-block
> >>> io_uring-5.14" and the issue was still seen, but after the BUG trace I
> >>> got lots of "truncated wr" message. The trace is:
> >>
> >> That's interesting, thanks
> >> Can you share the syz reproducer?
> >
> > Unfortunately I dont have a C reproducer, but this is the reproducer
> > for syzkaller:
>
> Thanks. Maybe I'm not perfectly familiar with syz, but were there
> any options? Like threaded, collide, etc.?

Sorry, my  mistake. I am still learning how syzkaller works. And I
should have given the link to the report with my mail.
https://elisa-builder-00.iol.unh.edu/syzkaller/report?id=959057ecd2886ff0c38cc53fa9c8eae46c1d7496

And also, I now have a C reproducer also, if that helps.


-- 
Regards
Sudip
