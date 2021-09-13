Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCC340831D
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 05:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbhIMDXY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 23:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238439AbhIMDXX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 23:23:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D38C061760;
        Sun, 12 Sep 2021 20:22:08 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso5452146pjb.3;
        Sun, 12 Sep 2021 20:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9Tt81VnxLpAm/FYmLBBYEcWxdp6PQAJapzbAtKFP83Q=;
        b=U2cM+uBnIL+ZzCX0wv8EJOuEtF4RGrmnmZHdALaw4MAD7eS5RBc5STm6peLFa6kFGn
         82PICzQ4unfMz06LklP/3xP3ZdCJybvcXXnKld3Q7avVdru/vtLyN3j/hRQmBWuw+2b8
         Yo31s6Wws8kZ+tyYYkZMveyGQpqUqcGidRHJs36L2YCnjQuDzwdbc0MkBftXK0YneeQa
         l3Z2XOTd2SKdjwZOkt6lkqstPTGtM0MEPLCisn0+/5tLCinx5L1aRaMjM0pHR47rMaHu
         +RT+DhvIjuWkJni17Nynz+lqr1GOFyWVtjnFasap6flvVof+gAq3G+/LqWUjLw+ERz/a
         L8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9Tt81VnxLpAm/FYmLBBYEcWxdp6PQAJapzbAtKFP83Q=;
        b=CNVJgC9vZkx8irtH02Ryp8Idyn+gq32GIEzMPaVuUUjFhUcrCtbErlxqCV3uH2orOa
         YWsHutPzsZRDyk4th3RaW+/REoXwnQJWS8ZBJeqWiKRDaOBkyrpfw6CI2/Jt7FEt7WAz
         CIxFRMTDuWrvBvuyzITMH0QrOM/2LI3GKMJuKSQvfN3GvK9BFlXA+j9xfokwMBcw3OwZ
         ozBbzCWzOIiKB0IBIvOKE/aEBZ+ROag848dYP2h4t/7EkCjFhAOT4qY4LMI+x3pwT0sP
         /zw8fUwRpjFLBPIgHt+/LOdSigUc7/3ithzTmO9J9WzZyakXaCO1ik8yMdRpN28ksohx
         dzTA==
X-Gm-Message-State: AOAM533yEDdcer3/6CRzZEsPm8Qqe/1Iy3EftynPX+4ThQzvIpQuPxR7
        sa8A48dmY3KZamOa8JEq1cFbcaaa5WJ2ce/NQg==
X-Google-Smtp-Source: ABdhPJwxSMPVZUnjLNxAIY0G6MWPtgHEnPCLvtssaFuWq7w8AOw3yMlo5pe3E3LGxIXLPewbjrPgbcnPMOcC69hiQT4=
X-Received: by 2002:a17:902:7b84:b0:13b:90a7:e270 with SMTP id
 w4-20020a1709027b8400b0013b90a7e270mr3992866pll.21.1631503328145; Sun, 12 Sep
 2021 20:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk> <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
 <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
 <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com>
 <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com> <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
 <9b5d8c00-0191-895b-0556-2f8167ab52bd@kernel.dk>
In-Reply-To: <9b5d8c00-0191-895b-0556-2f8167ab52bd@kernel.dk>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Mon, 13 Sep 2021 11:21:57 +0800
Message-ID: <CACkBjsYGnmLfCV2bNb45WhBiC-DqAvWjP1rb_6fxVZe5hqzOCw@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Jens Axboe <axboe@kernel.dk> =E4=BA=8E2021=E5=B9=B49=E6=9C=8813=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8810:50=E5=86=99=E9=81=93=EF=BC=9A
>
> On 9/12/21 8:26 PM, Hao Sun wrote:
> > Hi
> >
> > Healer found a C reproducer for this crash ("INFO: task hung in
> > io_ring_exit_work").
> >
> > HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
>
> Does this reproduce on 5.15-rc1? We had a few hang cases fixed for io-wq
> since that commit 6 days ago.

Just tried it. No, it did not crash the kernel on 5.15-rc1.
Following log was printed repeatedly:
[  647.478557][ T6807]  loop0: p1 p2 < > p3 p4
[  647.478922][ T6807] loop0: p1 size 11290111 extends beyond EOD, truncate=
d
[  647.481111][ T6807] loop0: p3 size 1914664839 extends beyond EOD, trunca=
ted
[  647.482512][ T6807] loop0: p4 size 3389030400 extends beyond EOD, trunca=
ted

It seems that this crash was fixed. Sorry for the dup report.

>
> --
> Jens Axboe
>
