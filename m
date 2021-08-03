Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BD53DE773
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 09:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhHCHry (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 03:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbhHCHrx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 03:47:53 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56549C06175F;
        Tue,  3 Aug 2021 00:47:43 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id s48so9497555ybi.7;
        Tue, 03 Aug 2021 00:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uR3LWjGAL1MCDX9JwTGP/PowRtYOX1+NORzQOb7GgSk=;
        b=Pvrl/oKUqB8r3YC1wMA1FrkDeissaPwOXeZfhmyLtHnhUuDrCGkXqjvcfU19vDE9H9
         BsbNeBOqxtR0qAu7AY1a1dVg8KhDFthPLOUHxiaiQqiGgZMxeNyQNwRI7GOMe7cPh/oU
         Y/OiFXhhhHbSj3Umc7xxJzOk0kt0jRoAxF4t+yrO/Df1nRRgpkWmMEqVDvDUPlLZwzGe
         L6CRYFLMSc1z/rrIN2oSbVVBWrcgMImdTpBcPAANtsTJkhnxZ+z0Ef3rr4hyjWeE9InE
         KYHPZRhYyAlu07gXwKEgiF/rOR8Owec/KjHLVVtpHlK5IUq9N4xhWBi8wn+QAPMVNB7C
         aMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uR3LWjGAL1MCDX9JwTGP/PowRtYOX1+NORzQOb7GgSk=;
        b=tQllXVN9s9FDMGYmkEp8kM9ZqWTXNqA15cql6nf/vUwzHOZ4rh9b9bs+jKcAZ+BYJP
         wx6HvUkDQuluWRQj+WlNWsfo1sA1EBtYxyZKwPHCDsmLsBGGZvASW8r3siWsnlHogHqu
         D0i1F4GwIsjA7JDBpXPXah5xJ1LsAmP5xtR/ouDhtN4z/7P9VUueTVRxNvx47HH5gokd
         Avf1W8nSFXVbk7I4KeU2Cjq/vcPsPmpjdFbtwFkoy6wit+xc8tF+I/4BzlpUWlYeeUwy
         uc98mOjdlig2JN/I72lnjliVC0bmS2Ar0ZajJNugOF+MJjn7moDQPaK7UTECVjyL7rss
         q5nQ==
X-Gm-Message-State: AOAM530d1wH2f6M4TB/TrhMRe7fyxnAXYrcANOD9/+2rFHEOQ5C5oOAY
        VOYN+8t0atWl3F45kaavWk9YpcCXrmLhB+OE40g=
X-Google-Smtp-Source: ABdhPJz62VAj24HIFGhicDO7uNueQqGky9v9x+BD0sdP1E9Ya56dQb0nYDLYSt/pgCHb/vE3Jv09rH4ma2JexSe4yzE=
X-Received: by 2002:a25:aa94:: with SMTP id t20mr26258560ybi.127.1627976862676;
 Tue, 03 Aug 2021 00:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com> <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
 <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com> <8db71657-bd61-6b1f-035f-9a69221e7cb3@gmail.com>
In-Reply-To: <8db71657-bd61-6b1f-035f-9a69221e7cb3@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 3 Aug 2021 08:47:06 +0100
Message-ID: <CADVatmPPnAWyOmyqT3iggeO_hOuPpALF5hqAqbQkrdvCPB5UaQ@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 2, 2021 at 12:55 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 8/1/21 9:28 PM, Sudip Mukherjee wrote:
> > Hi Pavel,
> >
> > On Sun, Aug 1, 2021 at 9:52 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 8/1/21 1:10 AM, Pavel Begunkov wrote:
> >>> On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
> >>>> Hi Jens, Pavel,
> >>>>
> >>>> We had been running syzkaller on v5.10.y and a "KASAN:
> >>>> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
> >>>> got some time to check that today and have managed to get a syzkaller
> >>>> reproducer. I dont have a C reproducer which I can share but I can use
> >>>> the syz-reproducer to reproduce this with v5.14-rc3 and also with
> >>>> next-20210730.
> >>>
> >>> Can you try out the diff below? Not a full-fledged fix, but need to
> >>> check a hunch.
> >>>
> >>> If that's important, I was using this branch:
> >>> git://git.kernel.dk/linux-block io_uring-5.14
> >>
> >> Or better this one, just in case it ooopses on warnings.
> >
> > I tested this one on top of "git://git.kernel.dk/linux-block
> > io_uring-5.14" and the issue was still seen, but after the BUG trace I
> > got lots of "truncated wr" message. The trace is:
>
> That's interesting, thanks
> Can you share the syz reproducer?

Unfortunately I dont have a C reproducer, but this is the reproducer
for syzkaller:

r0 = syz_io_uring_setup(0x4d4f, &(0x7f0000000080)={0x0, 0x0, 0x1},
&(0x7f00000a0000)=nil, &(0x7f0000ffc000/0x1000)=nil,
&(0x7f0000000000)=<r1=>0x0, &(0x7f0000000140))
r2 = openat(0xffffffffffffff9c, &(0x7f0000000040)='./file0\x00', 0x46e2, 0x0)
syz_io_uring_setup(0x1, &(0x7f0000000080),
&(0x7f0000ffd000/0x2000)=nil, &(0x7f0000ffc000/0x2000)=nil,
&(0x7f0000000100), &(0x7f0000000140)=<r3=>0x0)
syz_io_uring_submit(r1, r3, &(0x7f0000000100)=@IORING_OP_WRITE={0x17,
0x0, 0x0, @fd=r2, 0x0, &(0x7f0000000200)="e2", 0xffffffffffffff98},
0x200)
io_uring_enter(r0, 0x58ab, 0x0, 0x0, 0x0, 0x0)


-- 
Regards
Sudip
