Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E426C47C1A1
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 15:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238547AbhLUOgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 09:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbhLUOgh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 09:36:37 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B60C061574;
        Tue, 21 Dec 2021 06:36:37 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id a203-20020a1c7fd4000000b003457874263aso1847333wmd.2;
        Tue, 21 Dec 2021 06:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F8jE341W1QQCF0BMQ3eJhnwqfyppjUpPG3Qf5Do/V8U=;
        b=aMMNumUWJ2GspzR9H7HL8OHX24m3PjWiiZALtkmyuV/NwBwPeJkiabZTjAJFa8Jts1
         Y6XRpXOtkdLVwWHz4Ulr3ADIFYuguTyxgv0U1XEcJpbfIye8rChxOrKdgQqwsMTZIquc
         1qdz1uGtMxcNegoJX93OpE2evYKgj/4McOKPfDEEWDzSXI7HkSuFEptssWPy19stcsEV
         l1VwxE2FqbxK928T0q1VLmKIjJOPmlkypOdVnDcQ7k642w0vUjn1fsET/Pt/LFjm4jTk
         wbScW/6FXQXnwnC6ImLa27KPTyMhuMfnk2HMmoPDyNvaLIMbOWsn5R1f209OWa9NIlVR
         kBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F8jE341W1QQCF0BMQ3eJhnwqfyppjUpPG3Qf5Do/V8U=;
        b=jRmZHS5/IhKCe7HU1/ikFwaoSJBXkw2Af/OyXIyQY9gxh/hDGqyD57WdjJGAMcmnFp
         AD9xG5HaDFWd4Onb8lG2YgvycItywZvKSgRxqDDUfIJzJxjcxmTMUnnDTS8f5Gk1UH7a
         Fi0w3VFi3GVj8/Qf36WndPI7UmhoeiHw2eRM2rWjmzgmZqzFTZyFx4DrqJermTZRfQj3
         lBJuHe/phGK2frjDHcU+UAERfk+xIhLTDcGYrTI+/xdoWe6s99qA1O99rQM2YsL+elot
         evHJ2dvlEyIMeD2XnSMn10ZbVJu6jESBoU0oG1eN9v+a3OVEVQC65ziWEnEhWoOGRy+E
         25qw==
X-Gm-Message-State: AOAM533TlBjx2ppPGlFD2jFL8HGc1XGEzUGj6zL6vx+fvkY816dsjq25
        oZr9Yu2MuVdgUypeKwK2wyQsnx5coB47ViYpwV0=
X-Google-Smtp-Source: ABdhPJw2ot3ksVw/7/w8W0CmFimLGIIVFfgp6GBeisB2DF0ZfUzjgRLBY9u+5+T45uafnTRz85S/Cih44Yemw+cl5Tw=
X-Received: by 2002:a05:600c:34c1:: with SMTP id d1mr3060392wmq.139.1640097395684;
 Tue, 21 Dec 2021 06:36:35 -0800 (PST)
MIME-Version: 1.0
References: <CGME20211220142227epcas5p280851b0a62baa78379979eb81af7a096@epcas5p2.samsung.com>
 <20211220141734.12206-1-joshi.k@samsung.com> <fca4042f-6f44-62e2-0110-89c752ee71ea@kernel.dk>
In-Reply-To: <fca4042f-6f44-62e2-0110-89c752ee71ea@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 21 Dec 2021 20:06:10 +0530
Message-ID: <CA+1E3rKozJSTx1e6arz28VfqUkDJzy4dA+todrYrSZpCV2-Q4Q@mail.gmail.com>
Subject: Re: [RFC 00/13] uring-passthru for nvme
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        anuj20.g@samsung.com, pankydev8@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 9:15 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/20/21 7:17 AM, Kanchan Joshi wrote:
> > Here is a revamped series on uring-passthru which is on top of Jens
> > "nvme-passthru-wip.2" branch.
> > https://git.kernel.dk/cgit/linux-block/commit/?h=nvme-passthru-wip.2
> >
> > This scales much better than before with the addition of following:
> > - plugging
> > - passthru polling (sync and async; sync part comes from a patch that
> >   Keith did earlier)
> > - bio-cache (this is regardless of irq/polling since we submit/complete in
> >   task-contex anyway. Currently kicks in when fixed-buffer option is
> > also passed, but that's primarily to keep the plumbing simple)
> >
> > Also the feedback from Christoph (previous fixed-buffer series) is in
> > which has streamlined the plumbing.
> >
> > I look forward to further feedback/comments.
> >
> > KIOPS(512b) on P5800x looked like this:
> >
> > QD    uring    pt    uring-poll    pt-poll
> > 8      538     589      831         902
> > 64     967     1131     1351        1378
> > 256    1043    1230     1376        1429
>
> These are nice results! Can you share all the job files or fio
> invocations for each of these? I guess it's just two variants, with QD
> varied between them?

Yes, just two variants with three QD/batch combinations.
Here are all the job files for the above data:
https://github.com/joshkan/fio/tree/nvme-passthru-wip-polling/pt-perf-jobs

> We really (REALLY) should turn the nvme-wip branch into something
> coherent, but at least with this we have some idea of an end result and
> something that is testable. This looks so much better from the
> performance POV than the earlier versions, passthrough _should_ be
> faster than non-pt.
>
It'd be great to know how it performs in your setup.
And please let me know how I can help in making things more coherent.

-- 
Joshi
