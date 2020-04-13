Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E491A64B0
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 11:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgDMJ3o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 05:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727886AbgDMJ3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 05:29:42 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE544C008616
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 02:20:29 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id o11so7946036ilq.7
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9xom6G9l6Hr/TnFvdaHGmDWT9C55GEgS2Bi2QnGbik=;
        b=LKfIO8e5j0YMrVjGCUJL1fHTl+4eAap85blYSAbHcON+pq/ZWxm5KTURX9OnXnMVZB
         Ppk6J+qVip1fhsnBmL2n4qs/aZN9i1LxYL66jPzbXMd361Lck75DwL60mz5HAlVho7a1
         ayr87J6SCVDYVCZ8heaeW3ff8v9IXCLSDok3jXnf5oLpSYpW3sPLTlWziXMBFKnn/+hh
         zdVKmgHotnbGiG/lUTUiBOakj9Akx+aadonREQ5nfmqK9M0e22TF5zqG6Po65OuYAL4X
         P5iL8cAa5qNS3tc7cTIgzaZSyivxdpGrzTtPxcReHdQnwaUuW27MpN6EaR29+mXgYY7i
         6P5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9xom6G9l6Hr/TnFvdaHGmDWT9C55GEgS2Bi2QnGbik=;
        b=NQXxRmZFUA3ktUW+BbEFnGzpOm0Vz1jIv87NF3IbUUw/qz3gNj4vS4MgaBMeh50Q1h
         1HLs719l6rXW4oj/vkxTt3QHrPbUVgWkc0Oiws6xgXa3jiV2Azgm/S6E3v8zQlbBB2sE
         JeIfByhtd64o29xAFih0HYhzwVQDjDqciseL6lBtQjU34KZklIjjJ8kranZmBk1lKYO/
         +TIQ7POyw15PiSF/AxhYsiA4FH9eo3p/yuknnnspgvv+3usXrCT3JIuMrmiDK60jY34y
         GzusUcGENAtpViF1suwXAEX88tcXSKlYK0p7UTk7SfoNWwq8tFazgMTaz30OGrlTs5CK
         Z+Vw==
X-Gm-Message-State: AGi0PuZiNivrg2spagSPI1YQ6G2OXyR4/DIVTiDY5EdAJxbTA25dnk+I
        4V48wCZyeX9+Cr1f2frSA4Uh0pIFRQdU5QGp1c43YQCK
X-Google-Smtp-Source: APiQypLHR/SC/lJ1Slym05yPVbGM3jbxINxQUj8+3g7QjdL8AXeeTcDwd72OVKBRVWxp3WcuiNuYnZWsIjd+2xUb5rQ=
X-Received: by 2002:a92:3c4b:: with SMTP id j72mr16301622ila.173.1586769629223;
 Mon, 13 Apr 2020 02:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk> <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk> <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk> <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
 <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk> <CAOKbgA7KYWE485vAY2iLOjb4Ve-yLCTsTADqce-77a0CQxnszg@mail.gmail.com>
 <d55af7f3-711b-23b9-2ea3-00d600731453@kernel.dk>
In-Reply-To: <d55af7f3-711b-23b9-2ea3-00d600731453@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 13 Apr 2020 16:20:15 +0700
Message-ID: <CAOKbgA6JN4oQzyUo0_2y2KUKGX_xuwmDnQsCCABPq_nxms12Aw@mail.gmail.com>
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 9, 2020 at 10:29 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/8/20 8:50 PM, Dmitry Kadashev wrote:
> > On Wed, Apr 8, 2020 at 11:26 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/8/20 9:12 AM, Dmitry Kadashev wrote:
> >>> On Wed, Apr 8, 2020 at 10:49 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/8/20 8:41 AM, Dmitry Kadashev wrote:
> >>>>> On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
> >>>>>>> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>>>
> >>>>>>>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
> >>>>>>>>> Hi,
> >>>>>>>>>
> >>>>>>>>> io_uring's openat seems to produce FDs that are incompatible with
> >>>>>>>>> large files (>2GB). If a file (smaller than 2GB) is opened using
> >>>>>>>>> io_uring's openat then writes -- both using io_uring and just sync
> >>>>>>>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
> >>>>>>>>> opened with sync openat, then both io_uring's writes and sync writes
> >>>>>>>>> succeed. And if the file is larger than 2GB then io_uring's openat
> >>>>>>>>> fails right away, while the sync one works.
> >>>>>>>>>
> >>>>>>>>> Kernel versions: 5.6.0-rc2, 5.6.0.
> >>>>>>>>>
> >>>>>>>>> A couple of reproducers attached, one demos successful open with
> >>>>>>>>> failed writes afterwards, and another failing open (in comparison with
> >>>>>>>>> sync  calls).
> >>>>>>>>>
> >>>>>>>>> The output of the former one for example:
> >>>>>>>>>
> >>>>>>>>> *** sync openat
> >>>>>>>>> openat succeeded
> >>>>>>>>> sync write at offset 0
> >>>>>>>>> write succeeded
> >>>>>>>>> sync write at offset 4294967296
> >>>>>>>>> write succeeded
> >>>>>>>>>
> >>>>>>>>> *** sync openat
> >>>>>>>>> openat succeeded
> >>>>>>>>> io_uring write at offset 0
> >>>>>>>>> write succeeded
> >>>>>>>>> io_uring write at offset 4294967296
> >>>>>>>>> write succeeded
> >>>>>>>>>
> >>>>>>>>> *** io_uring openat
> >>>>>>>>> openat succeeded
> >>>>>>>>> sync write at offset 0
> >>>>>>>>> write succeeded
> >>>>>>>>> sync write at offset 4294967296
> >>>>>>>>> write failed: File too large
> >>>>>>>>>
> >>>>>>>>> *** io_uring openat
> >>>>>>>>> openat succeeded
> >>>>>>>>> io_uring write at offset 0
> >>>>>>>>> write succeeded
> >>>>>>>>> io_uring write at offset 4294967296
> >>>>>>>>> write failed: File too large
> >>>>>>>>
> >>>>>>>> Can you try with this one? Seems like only openat2 gets it set,
> >>>>>>>> not openat...
> >>>>>>>
> >>>>>>> I've tried specifying O_LARGEFILE explicitly, that did not change the
> >>>>>>> behavior. Is this good enough? Much faster for me to check this way
> >>>>>>> that rebuilding the kernel. But if necessary I can do that.
> >>>>>>
> >>>>>> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
> >>>>>> should fix it though. Might have worked on 32-bit, though.
> >>>>>
> >>>>> OK, will test.
> >>>>
> >>>> Great, thanks. FWIW, tested here, and it works for me.
> >>>
> >>> Great, will post results tomorrow.
> >>
> >> Thanks!
> >
> > With the patch applied it works perfectly, thanks.
>
> Thanks for testing!

Can I ask if this is going to be merged into 5.6? Since it's a bug
(important enough from my perspective) in existing logic. Thanks.

-- 
Dmitry
