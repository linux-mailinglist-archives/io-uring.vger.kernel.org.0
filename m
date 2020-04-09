Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E851A2E14
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 05:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgDIDuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 23:50:32 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44521 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgDIDuc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 23:50:32 -0400
Received: by mail-il1-f194.google.com with SMTP id i14so3868361ilr.11
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 20:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPlpuRIVrdVWxRm++IHc8ufrC20hulhZfWn9Om/tK/8=;
        b=kl7UY0VyKeDW/rZYA6m26Hoy10paw3VPx/hJ5H6Rd9k1lSTYuYPO7lohd1ZtlNQxFG
         6mesB+SwOdrdhvHwO4raFxJwtmNEyx7CBDSYJsaLUn/JNrLqM5p1xk/bU/8fGKA3VaYO
         M8QA63Chimrk/PKoGqXehDoF/fFAq2gMTlhqECMYd/QHgNdOJbOUhDoOG7wxOtKCNkLm
         DKRIO19yRD19m/wJGRISSSYAbBcHSRtyKdugZH3n5DHnvy+B5m5SkO7eYjNQdcqjDzsi
         7eMBcgnnd550MgfHriMQEt9H3w3o3tXTThB2q8RUNOgXYR71L8fMnKzJN6jpuB+vV5SB
         IiQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPlpuRIVrdVWxRm++IHc8ufrC20hulhZfWn9Om/tK/8=;
        b=GUwT+pAvG/pHX7fyhimCBAaY4Heb3tiUARQdlP3f6MeoNs9ZpGVu0VI7wmxU9gg7F/
         tYElog8wUqz6WmyBnqpaLXgRZfclB8SAWCzmrUkC8/uaHB/BJhTlPONP500RaHOQZwhc
         qBxoqRGY1W/6nYKvY/JE/Q9sxAa9xXeQggF671EF4Hp+9koLgPR7gKJtLa/9FgyVC0V+
         ddDecFi0XCG63IQ8u6upcPYFb35EkZoHdz11npvBbxqeIA+6gEuzjxOEzUJ6C2wXL/sR
         KoRfEQ1jc4l/AfSv/f2w3l/7RXIE/2I+9Z7EsEVH1RaLAFX4P+jn/Mg/tyrhEAAa2ZSJ
         LDyw==
X-Gm-Message-State: AGi0Pubvc2QlxI9Ef3zxn2Lfz/KOGmc+GanFZg9wjV6r1t8mZXzE8RdK
        zhPnIb2vpPzJ9cOLJHMVh56Jqb7Gwsx57oq3mbc=
X-Google-Smtp-Source: APiQypIxjJcDiccGn88NbLyyIpw9IG3BiS+Q+5vQcw+s23h+SwXcTguJ0e5kUcqkw25dlim5/MjkeRsoSzK5ju1gQQc=
X-Received: by 2002:a05:6e02:de8:: with SMTP id m8mr3018049ilj.92.1586404231784;
 Wed, 08 Apr 2020 20:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk> <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk> <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk> <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
 <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk>
In-Reply-To: <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 9 Apr 2020 10:50:19 +0700
Message-ID: <CAOKbgA7KYWE485vAY2iLOjb4Ve-yLCTsTADqce-77a0CQxnszg@mail.gmail.com>
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 8, 2020 at 11:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/8/20 9:12 AM, Dmitry Kadashev wrote:
> > On Wed, Apr 8, 2020 at 10:49 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/8/20 8:41 AM, Dmitry Kadashev wrote:
> >>> On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
> >>>>> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> io_uring's openat seems to produce FDs that are incompatible with
> >>>>>>> large files (>2GB). If a file (smaller than 2GB) is opened using
> >>>>>>> io_uring's openat then writes -- both using io_uring and just sync
> >>>>>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
> >>>>>>> opened with sync openat, then both io_uring's writes and sync writes
> >>>>>>> succeed. And if the file is larger than 2GB then io_uring's openat
> >>>>>>> fails right away, while the sync one works.
> >>>>>>>
> >>>>>>> Kernel versions: 5.6.0-rc2, 5.6.0.
> >>>>>>>
> >>>>>>> A couple of reproducers attached, one demos successful open with
> >>>>>>> failed writes afterwards, and another failing open (in comparison with
> >>>>>>> sync  calls).
> >>>>>>>
> >>>>>>> The output of the former one for example:
> >>>>>>>
> >>>>>>> *** sync openat
> >>>>>>> openat succeeded
> >>>>>>> sync write at offset 0
> >>>>>>> write succeeded
> >>>>>>> sync write at offset 4294967296
> >>>>>>> write succeeded
> >>>>>>>
> >>>>>>> *** sync openat
> >>>>>>> openat succeeded
> >>>>>>> io_uring write at offset 0
> >>>>>>> write succeeded
> >>>>>>> io_uring write at offset 4294967296
> >>>>>>> write succeeded
> >>>>>>>
> >>>>>>> *** io_uring openat
> >>>>>>> openat succeeded
> >>>>>>> sync write at offset 0
> >>>>>>> write succeeded
> >>>>>>> sync write at offset 4294967296
> >>>>>>> write failed: File too large
> >>>>>>>
> >>>>>>> *** io_uring openat
> >>>>>>> openat succeeded
> >>>>>>> io_uring write at offset 0
> >>>>>>> write succeeded
> >>>>>>> io_uring write at offset 4294967296
> >>>>>>> write failed: File too large
> >>>>>>
> >>>>>> Can you try with this one? Seems like only openat2 gets it set,
> >>>>>> not openat...
> >>>>>
> >>>>> I've tried specifying O_LARGEFILE explicitly, that did not change the
> >>>>> behavior. Is this good enough? Much faster for me to check this way
> >>>>> that rebuilding the kernel. But if necessary I can do that.
> >>>>
> >>>> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
> >>>> should fix it though. Might have worked on 32-bit, though.
> >>>
> >>> OK, will test.
> >>
> >> Great, thanks. FWIW, tested here, and it works for me.
> >
> > Great, will post results tomorrow.
>
> Thanks!

With the patch applied it works perfectly, thanks.

>
> >> Any objection to adding your test cases to the liburing regression
> >> suite?
> >
> > Feel free to!
>
> Great, done!
>

-- 
Dmitry
