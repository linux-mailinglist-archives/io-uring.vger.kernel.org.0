Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF140A40E
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 05:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbhINDCa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 23:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237213AbhINDCa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 23:02:30 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ECBC061574;
        Mon, 13 Sep 2021 20:01:13 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k24so11327548pgh.8;
        Mon, 13 Sep 2021 20:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DsCe+BZFESkDZsqe6u7iZYz+EpftXxtavi4h72VzJL0=;
        b=VnhszOGJWKfWQf+O+OGEpQ1hmHGptjgf9GZCa88torTr+PLjyUoOSD5z2fKqOK+4/B
         ZSu4hk5lKgKvx8ric1377rvyrZnEZAl2JQvlWYdwlcr8DA9rFIPzcNIxtt0GFAYrPnyA
         Qf0fNGNSMSPYKIbUTYbCszYvQak+CKNWuRrtg665fqQxZzmei0Tpe1rtZxLAkYMUizXg
         68V8QQJe8mfsPsHz/3o6Lu7+9r4AE+CH49ki2sXDa09osFn5damngbMiHKK0fBHKJ3dD
         rl8oEJWW9unmoIZkxWv2g9qROeqgRzZRpaps+pQ6WPe0rbKCDY0cXaBNZDOszURs8gCF
         NTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DsCe+BZFESkDZsqe6u7iZYz+EpftXxtavi4h72VzJL0=;
        b=AyFAOF/2yBidcc/jNDqoN5CuzVBb5OOOjhH8uePopkAzx6CXrv92uV3kvTxvZfPQC2
         LQY/V0TaH12E9sdEePcEKqwHBd07gJknw71tdlQBud2lXoaW1le4fWfq2q8K5HQ7tl3K
         4166cDFPfqJsm0ODXR/YUYB6ERhz3z1FIJj/gskD+W9v+8hHD5SKEEFA59BVnEDI+zsm
         097neu6hUM+ScxV52v5A5ORsc5llDdRYLnrnwB8GcATWSPnW3N5UjeVS1J269Rl9bhkA
         BYSwQ9C+uIZyEQKGOL30yDxDxNob19JnPom65GYq3sd75VJ+7NCC2TMahpKVcps3Exff
         Vmqg==
X-Gm-Message-State: AOAM530fM/k+P+f7hQFr2kCZ8UkXd30miCc8ZJxR2l2k2KqPiwbbYqfE
        KhDlsBj87RScLNrq236AK9+5aOeSvx2M7o4x1g==
X-Google-Smtp-Source: ABdhPJzqV2Mb1jqk9XIRMDrDzBl3o2KWNgVs9r4EafBsHrqUtaSwvYdUqcPtToLOnV1C3sAxFLcqdLaw7BV7NRq65Bo=
X-Received: by 2002:a05:6a00:2449:b0:43c:4a5e:55a6 with SMTP id
 d9-20020a056a00244900b0043c4a5e55a6mr2581819pfj.43.1631588473158; Mon, 13 Sep
 2021 20:01:13 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk> <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
 <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
 <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com>
 <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com> <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
 <7faa04f8-cd98-7d8a-2e54-e84e1fe742f7@gmail.com>
In-Reply-To: <7faa04f8-cd98-7d8a-2e54-e84e1fe742f7@gmail.com>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Tue, 14 Sep 2021 11:01:02 +0800
Message-ID: <CACkBjsZE4=ErfsT7z=MDfCKEsafZ23BG-uCST1bT_HT_3NSMLA@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:30=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On 9/13/21 3:26 AM, Hao Sun wrote:
> > Hi
> >
> > Healer found a C reproducer for this crash ("INFO: task hung in
> > io_ring_exit_work").
> >
> > HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
> > git tree: upstream
> > console output:
> > https://drive.google.com/file/d/1NswMU2yMRTc8-EqbZcVvcJejV92cuZIk/view?=
usp=3Dsharing
> > kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvA=
tJd6kfg-p/view?usp=3Dsharing
> > C reproducer: https://drive.google.com/file/d/170wk5_T8mYDaAtDcrdVi2UU9=
_dW1894s/view?usp=3Dsharing
> > Syzlang reproducer:
> > https://drive.google.com/file/d/1eo-jAS9lncm4i-1kaCBkexrjpQHXboBq/view?=
usp=3Dsharing
> >
> > If you fix this issue, please add the following tag to the commit:
> > Reported-by: Hao Sun <sunhao.th@gmail.com>
>
> I don't see the repro using io_uring at all. Can it be because of
> the delay before the warning shows itself? 120 secs, this appeared
> after 143.
>

I think the crash was most likely fixed. Here is what I've done.
First, I re-run the whole execution history
(https://drive.google.com/file/d/1NswMU2yMRTc8-EqbZcVvcJejV92cuZIk/view?usp=
=3Dsharing)
with `syz-repro` on  latest kernel (6880fa6c5660 Linux 5.15-rc1). The
kernel did not crash at all.
Then, I re-run the history on the original version of the kernel
(4b93c544e90e-thunderbolt: test: split up test cases). It crashed and
task hang happened but with a different location
("io_wq_submit_work").
Since `syz-repro` is smart enough and will give prog enough timeout to
be executed when the crash type is `Hang` (see
https://github.com/google/syzkaller/blob/master/pkg/repro/repro.go#L98),
the delay before a warning can be handled properly.

However, I'll still keep track of this crash since it was still not
reproduced yet.

> [...]

>
> --
> Pavel Begunkov
