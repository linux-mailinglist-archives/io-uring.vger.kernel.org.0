Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E500403206
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 03:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245379AbhIHBDS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 21:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbhIHBDS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 21:03:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5268FC061575;
        Tue,  7 Sep 2021 18:02:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x19so595211pfu.4;
        Tue, 07 Sep 2021 18:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pDeJ+ImvfyUW8iRlMB1BgxblOKPWqeMm95cLvzOnvLQ=;
        b=X/n2fvENXtyKuD++HXWb8VUFHFoAs5QEokF3VnxEYtdady9Xp6TQ8TKvDSPtyKP4pX
         nShX4IDjohovCGYJgJXX4G111NAtZePcHicljk6XZJ3Gw1ZAxEwopM3xuh09aj11yXUr
         eYeCWZuAGleDVa0JADpvKKpmQcTFX8+WiAG9Tr0uTgrsCVi5b6Wtr0mlbHXHZvc72vja
         j7tPwe9VguwDbIubzSy1e02RX8KgRXduUom1blOeufFgkrAfSf4ob3Wu4ag1y65HxFMd
         Kgpw4foJoFWsNVQrXCX84R8nCuR/zdcru5mhdL6oM/r90QnPFVTqU7P/zpcxidlraCQ2
         36aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pDeJ+ImvfyUW8iRlMB1BgxblOKPWqeMm95cLvzOnvLQ=;
        b=E5vykfKL4eoU3Sh94gF2U7WwDNSqVAwGzuno87oIJy5r0SmmmDUAUt7FOt/+2XkHyp
         QpU5xTrUqvmhGDuASRkLQOrKyV77ksG/PFjRBkwu37rudhWem9BOtq77N4+iue0WfmlL
         OUxelY+plWBkDFYNSeZqhECbHGexTY2TD7tXR0qyAbjHsKHqwHwkT4XM0zzE08qcIWlW
         dYHPrakPR6uY6h/IK2iZlVMpr6tNZ+X9U2zmUxsdg4lLop48CyRLixKtd/+GXvWRmgkB
         16xAE6NNuAHi9gLKQ/evKcO/EQ6wieKonFnbxLeHMRe9GG0nfJEshPgFzoKMViznIoy9
         dp8Q==
X-Gm-Message-State: AOAM530+CdI2hr9OI7F4bAHQSEdJ0zVXYLc2c89fTaHIuWnuI0f97qG+
        8hpLsHTVUOP4LXqrR0sPbIO6POfNFAEr9PxIF/lzwxVDGZY3
X-Google-Smtp-Source: ABdhPJwmw06Fb9TYgniH+bteM3MybbaR402maa6CcEWxUJBRAciFkOoef/R9o/rKKbY4Vhe2xe3bKf4wSPtLMj/vYX8=
X-Received: by 2002:a62:920b:0:b0:3ec:7912:82be with SMTP id
 o11-20020a62920b000000b003ec791282bemr1146623pfd.34.1631062930707; Tue, 07
 Sep 2021 18:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk> <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
In-Reply-To: <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 8 Sep 2021 09:01:59 +0800
Message-ID: <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=888=
=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=885:31=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On 9/7/21 8:30 PM, Jens Axboe wrote:
> > On 9/7/21 5:50 AM, Hao Sun wrote:
> >> Hello,
> >>
> >> When using Healer to fuzz the latest Linux kernel, the following crash
> >> was triggered.
> >>
> >> HEAD commit: 7d2a07b76933 Linux 5.14
> >> git tree: upstream
> >> console output:
> >> https://drive.google.com/file/d/1c8uRooM0TwJiTIwEviOCB4RC-hhOgGHR/view=
?usp=3Dsharing
> >> kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8AGG=
DvP9JvOghx/view?usp=3Dsharing
> >> Similar report:
> >> https://groups.google.com/u/1/g/syzkaller-bugs/c/FvdcTiJIGtY/m/PcXkoen=
UAAAJ
> >>
> >> Sorry, I don't have a reproducer for this crash, hope the symbolized
> >> report can help.
> >> If you fix this issue, please add the following tag to the commit:
> >> Reported-by: Hao Sun <sunhao.th@gmail.com>
> >
> > Would be great with a reproducer for this one, though...
>
> And syzbot usually sends an execution log with all syz programs
> it run, which may be helpful. Any chance you have anything similar
> left?
>

Yes, found it[1]. Here is an execution history with latest 1024
executed progs before crash saved.
Hope it can help. I'll also follow this crash closely, see if Healer
can find a reproducer and send it to you once it found.

[1] https://drive.google.com/file/d/14k8qOFeyKPD4HsqOpIjud3b9jsxFSo-u/view?=
usp=3Dsharing

> --
> Pavel Begunkov
