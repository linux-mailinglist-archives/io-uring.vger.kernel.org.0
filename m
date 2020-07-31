Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870952340A3
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 09:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbgGaH6x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 03:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgGaH6w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 03:58:52 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B01BC061574;
        Fri, 31 Jul 2020 00:58:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g8so7782904wmk.3;
        Fri, 31 Jul 2020 00:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTyazyYhJvUjN7a2Z4vhY4OPwuV7RiSwhqqKSl6uwS4=;
        b=cqcr9/BGTVGV5eLNZYxJLpiQ9zQ9uUBx0U9phhALKfBmj3H1Ly5IjBDuCR8W6fB43t
         Z/+OylPZCJR+MuNTHsIH2hggC/RuHaGQ6B0nlf/ZI0AcnhG1twITAS4fET/myTe8HQ9c
         l33p4GTO7epKW9P+rpzY85naKonMEwkUBVbxsuQ4TQVmlJaGYBj3cjymi5aglGlEPS4Q
         6scVBWiakVdV5WPNCQ8JNjoiQQFRRTfxiIyP/1DmUnZn4f93aE0oR8gSLGC5s79KaOYD
         s1aXsGM6/VUA6w8NHWBfjIjWPFWhxFPsIq5yNMQqlyXoH/cmzyoPY1mKaOlwAzpuXNAN
         BXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTyazyYhJvUjN7a2Z4vhY4OPwuV7RiSwhqqKSl6uwS4=;
        b=rosesuFqrodKRlgvhlzq4nhl8nWOnv+CQYPAaflh7RWZWLCgCs3L3IyAeYKlCKVq6z
         RSZR7jLjsJ8tiABwovNJOTX/wWM7n66DGZrZDhxo9xlSeS8Ni6iqy8zX46MG4s3yyfLE
         LkXKSG9qg7gq8Pfr4Dr72E/JsB7aBQ3lbBRm5QLh3QF/zAPhAKikOZJ3wWoaFyEvhczX
         LzRAW12y/LzS7freXEOl0YPwaei2nN7lRMB/dKCkC+AakWGu/9xAxpZQTNAjy8pVS6z9
         Tior3FCvb1+RpCIV6JI5KBrCqoGGfVASSkdQWRzeLzaojhfuWI1ttE0k7n+5IdduhLvX
         eI/w==
X-Gm-Message-State: AOAM533sIU6CM9qFHWx/jshyL7IyyNqvYFqi62+Xovv3iy49rf4xmrVu
        NJeDLAu0a6ILRzC633d1CtEXSJT1g2im+T9WWpA=
X-Google-Smtp-Source: ABdhPJxNw7Svuw5TllltfhvwrWmcKb/9/XdA7oHnRTAloSkB3rov2jCYV3IjcA5AbRGDfz1qzi3lBfppauTNKt8MG64=
X-Received: by 2002:a05:600c:21cd:: with SMTP id x13mr2898582wmj.155.1596182331066;
 Fri, 31 Jul 2020 00:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
 <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com> <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com> <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com> <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk> <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org> <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 31 Jul 2020 13:28:24 +0530
Message-ID: <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
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
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 12:29 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/07/31 15:45, hch@infradead.org wrote:
> > On Fri, Jul 31, 2020 at 06:42:10AM +0000, Damien Le Moal wrote:
> >>> - We may not be able to use RWF_APPEND, and need exposing a new
> >>> type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this
> >>> sounds outrageous, but is it OK to have uring-only flag which can be
> >>> combined with RWF_APPEND?
> >>
> >> Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningless for
> >> raw block device accesses. We could certainly define a meaning for these in the
> >> context of zoned block devices.
> >
> > We can't just add a meaning for O_APPEND on block devices now,
> > as it was previously silently ignored.  I also really don't think any
> > of these semantics even fit the block device to start with.  If you
> > want to work on raw zones use zonefs, that's what is exists for.
>
> Which is fine with me. Just trying to say that I think this is exactly the
> discussion we need to start with. What interface do we implement...
>
> Allowing zone append only through zonefs as the raw block device equivalent, all
> the O_APPEND/RWF_APPEND semantic is defined and the "return written offset"
> implementation in VFS would be common for all file systems, including regular
> ones. Beside that, there is I think the question of short writes... Not sure if
> short writes can currently happen with async RWF_APPEND writes to regular files.
> I think not but that may depend on the FS.

generic_write_check_limits (called by generic_write_checks, used by
most FS) may make it short, and AFAIK it does not depend on
async/sync.
This was one of the reason why we chose to isolate the operation by a
different IOCB flag and not by IOCB_APPEND alone.

For block-device these checks are not done, but there is another place
when it receives writes spanning beyond EOF and iov_iter_truncate()
adjusts it before sending it down.
And we return failure for that case in V4-  "Ref: [PATCH v4 3/6] uio:
return status with iov truncation"


-- 
Joshi
