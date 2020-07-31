Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BDB234365
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732204AbgGaJjD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 05:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732110AbgGaJjD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 05:39:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26D5C061574;
        Fri, 31 Jul 2020 02:39:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p14so8032396wmg.1;
        Fri, 31 Jul 2020 02:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1w/of8ZlYRk9ugq4qMwBl1GQ4reDEWsPjXKoxsmxWRQ=;
        b=TG+7iCM5H5RU/WHaLCqzBi67//MYgY3g+ksq8nIRjlq0WBWUdAmD5GYYAS7Xn7Ad3H
         4jHUFyTaxxUkfGZssR2ZgaTEs8y9LpVLU577CAqMdRyk2O9J/kb8sBDKftNmcpjBiz48
         6mb8bIVd6Lb7VwqqZnhZDbC5t0sUAbb4ABBN8SjUbEb8HscFuGsEMKYVcgqJ0d01VvMa
         4v2KHr/WBStns3BiRLunjBDoT3hf/iXlGbZg9lr/CRuJ1P1oC29v+LU0RH8Vqa2xBCtB
         zc3Ilf1xHwFpKehrjACLIhM/XGv4nona8ObQ3mS78VRsY8ZtBAElQbSioJY/tu4QcSB2
         qC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1w/of8ZlYRk9ugq4qMwBl1GQ4reDEWsPjXKoxsmxWRQ=;
        b=R24u3ga0zEMc1Xw3aN0QqAnsJwW9OmikHxwS4CELNK/Dkrm188w3LzmG2W3hBTKHZk
         IkTKpsN3b820LlGqL4DCgl3304NFafCDAR7H7+J15AYGLm24BuBPhCnuMXpEDdGeVj5r
         6np78PdTexekEDLeJ5rScv8g4zFOKw82W0HjXy1FSfPZUrjjVabPjwnNEXfUcOrl6t2K
         ouVHVFrorYHE6/K+pVzXXL3S1OYcr2mUHCRj6uEp2omJxibvP/7xyuE029zxzcGibDq4
         1xxu9eN+ID7DN0W0myM6hjpbSiooofbOi6mjVG/ZlYArVDbPwcY6ZFCMqZib3qriBgJz
         5fMg==
X-Gm-Message-State: AOAM53172nxdIY0VDsXM7qBQe/WPc21nyEOzL+QyglNiSNmlmRpvkTPm
        VhCSmkfiyuBdLMt92fsCNKly2m96quvqE/nslz4=
X-Google-Smtp-Source: ABdhPJwb6uEWAAlpHrCaqfpQvpw9AKSziF8K6/uF3TzM0sbzpImikm9+rmCwa4yxBjQSYhXVZZnoA7UwVgmBxZU3B9M=
X-Received: by 2002:a1c:32c3:: with SMTP id y186mr3027201wmy.15.1596188341428;
 Fri, 31 Jul 2020 02:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
 <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com> <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com> <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com> <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk> <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org> <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com> <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 31 Jul 2020 15:08:34 +0530
Message-ID: <CA+1E3rJasyUAcDZZFPjFSckUuLKu7rMkn0bmLJWdywxTC0u-7w@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 1:44 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/07/31 16:59, Kanchan Joshi wrote:
> > On Fri, Jul 31, 2020 at 12:29 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> >>
> >> On 2020/07/31 15:45, hch@infradead.org wrote:
> >>> On Fri, Jul 31, 2020 at 06:42:10AM +0000, Damien Le Moal wrote:
> >>>>> - We may not be able to use RWF_APPEND, and need exposing a new
> >>>>> type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this
> >>>>> sounds outrageous, but is it OK to have uring-only flag which can be
> >>>>> combined with RWF_APPEND?
> >>>>
> >>>> Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningless for
> >>>> raw block device accesses. We could certainly define a meaning for these in the
> >>>> context of zoned block devices.
> >>>
> >>> We can't just add a meaning for O_APPEND on block devices now,
> >>> as it was previously silently ignored.  I also really don't think any
> >>> of these semantics even fit the block device to start with.  If you
> >>> want to work on raw zones use zonefs, that's what is exists for.
> >>
> >> Which is fine with me. Just trying to say that I think this is exactly the
> >> discussion we need to start with. What interface do we implement...
> >>
> >> Allowing zone append only through zonefs as the raw block device equivalent, all
> >> the O_APPEND/RWF_APPEND semantic is defined and the "return written offset"
> >> implementation in VFS would be common for all file systems, including regular
> >> ones. Beside that, there is I think the question of short writes... Not sure if
> >> short writes can currently happen with async RWF_APPEND writes to regular files.
> >> I think not but that may depend on the FS.
> >
> > generic_write_check_limits (called by generic_write_checks, used by
> > most FS) may make it short, and AFAIK it does not depend on
> > async/sync.
>
> Johannes has a patch (not posted yet) fixing all this for zonefs,
> differentiating sync and async cases, allow short writes or not, etc. This was
> done by not using generic_write_check_limits() and instead writing a
> zonefs_check_write() function that is zone append friendly.
>
> We can post that as a base for the discussion on semantic if you want...

There is no problem in about how-to-do-it. That part is simple - we
have the iocb, and sync/async can be known whether ki_complete
callback is set.
This point to be discussed was whether-to-allow-short-write-or-not if
we are talking about a generic file-append-returning-location.

That said, since we are talking about moving to indirect-offset in
io-uring, short-write is not an issue anymore I suppose (it goes back
to how it was).
But the unsettled thing is -  whether we can use O/RWF_APPEND with
indirect-offset (pointer) scheme.

> > This was one of the reason why we chose to isolate the operation by a
> > different IOCB flag and not by IOCB_APPEND alone.
>
> For zonefs, the plan is:
> * For the sync write case, zone append is always used.
> * For the async write case, if we see IOCB_APPEND, then zone append BIOs are
> used. If not, regular write BIOs are used.
>
> Simple enough I think. No need for a new flag.

Maybe simple if we only think of ZoneFS (how user-space sends
async-append and gets result is a common problem).
Add Block I/O in scope -  it gets slightly more complicated because it
has to cater to non-zoned devices. And there already is a
well-established understanding that append does nothing...so  code
like "if (flags & IOCB_APPEND) { do something; }" in block I/O path
may surprise someone resuming after a hiatus.
Add File I/O in scope - It gets further complicated. I think it would
make sense to make it opt-in rather than compulsory, but most of them
already implement a behavior for IOCB_APPEND. How to make it opt-in
without new flags.

New flags (FMODE_SOME_NAME, IOCB_SOME_NAME) serve that purpose.
Please assess the need (for isolation) considering all three cases.
