Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACE11A25B1
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgDHPlQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:41:16 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:32807 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgDHPlP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:41:15 -0400
Received: by mail-il1-f195.google.com with SMTP id k29so7152758ilg.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j4NV8UufY++k46oz8ZsvGL6sOBiCD+v0idEuvAu9sWY=;
        b=hfvkkrIfYeUOq582n24vl2gW2cejHGpaHFXfjfcovcmXMqtI/YZUglJmDmeGKvzwBN
         UNpeIwXFWCmY9ocpzW1TsvF2PYG22gMUxt8Ek5oDgNVVrDj+0600djRu823f1sw7Ebyf
         cB4PE3GmD0alp3liKxS9Mkc8YOtzI7QS4mKAWd65QzRsPz6znjhuBaz5YLVEkcwXIo37
         oKAOnY4ADrdhRNKgIIfIGvjitAnCPnKP0Yx2xGR7Pc4w3r6XLtKsPfNffJQ7n1x2hXdF
         lnJw/yUmkPtz8YOEdYAjPwGgfHcvN0inksj5EaTBgt46seKjArd5ZZ90e+32a8gyOWS0
         gm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4NV8UufY++k46oz8ZsvGL6sOBiCD+v0idEuvAu9sWY=;
        b=QQSlBRiCBxJBS8iMac77+TnHnNpAfOJz7Jr/w/AnzhBtha1TN56ZYVOTIdXvlx9P2z
         hUXRaCyd4jwPe808p9hR/5M8GUlu+egOzGPcgkK8rDC9kOCUa4/NPtS9N/DAorwckvwi
         sF1mmqoh3FEA+X9LA28VGTkUDrMSPO5gGPPIUcj+effPMuiww6rLmefSk6MYC5IlAXCL
         RsEcsA/PN7AZ5AfRL2qokjkgw6aGYuCShN4rMtZV8C4RgcWr+I1t8Q3eK528wA0qZnLL
         6I4U55l7QHZs9instOPLB39WOeqqjobdPF0JsO29YKZxhwn+3iLS+ZJAn8G63iqbKfRO
         PUbA==
X-Gm-Message-State: AGi0PuYGy+q1G4OJI5SlpLZ1C1svYFU6q7QjbpKcFaLq7Bg5CMslEjeg
        C8iIXMdWtAvrJpKN5kdBomeK/oSYhd+YgKunpTyp4BXy
X-Google-Smtp-Source: APiQypLHSHFrsz0LvOnrebqjeTvbI/gh85hPWrzh0KtQzVssQEjhTJGOHjTmOPrODHpqxYQEaSxASvfipQ4YdNTgF1o=
X-Received: by 2002:a92:3c4b:: with SMTP id j72mr355957ila.173.1586360475029;
 Wed, 08 Apr 2020 08:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk> <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
In-Reply-To: <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 8 Apr 2020 22:41:03 +0700
Message-ID: <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
> > On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
> >>> Hi,
> >>>
> >>> io_uring's openat seems to produce FDs that are incompatible with
> >>> large files (>2GB). If a file (smaller than 2GB) is opened using
> >>> io_uring's openat then writes -- both using io_uring and just sync
> >>> pwrite() -- past that threshold fail with EFBIG. If such a file is
> >>> opened with sync openat, then both io_uring's writes and sync writes
> >>> succeed. And if the file is larger than 2GB then io_uring's openat
> >>> fails right away, while the sync one works.
> >>>
> >>> Kernel versions: 5.6.0-rc2, 5.6.0.
> >>>
> >>> A couple of reproducers attached, one demos successful open with
> >>> failed writes afterwards, and another failing open (in comparison with
> >>> sync  calls).
> >>>
> >>> The output of the former one for example:
> >>>
> >>> *** sync openat
> >>> openat succeeded
> >>> sync write at offset 0
> >>> write succeeded
> >>> sync write at offset 4294967296
> >>> write succeeded
> >>>
> >>> *** sync openat
> >>> openat succeeded
> >>> io_uring write at offset 0
> >>> write succeeded
> >>> io_uring write at offset 4294967296
> >>> write succeeded
> >>>
> >>> *** io_uring openat
> >>> openat succeeded
> >>> sync write at offset 0
> >>> write succeeded
> >>> sync write at offset 4294967296
> >>> write failed: File too large
> >>>
> >>> *** io_uring openat
> >>> openat succeeded
> >>> io_uring write at offset 0
> >>> write succeeded
> >>> io_uring write at offset 4294967296
> >>> write failed: File too large
> >>
> >> Can you try with this one? Seems like only openat2 gets it set,
> >> not openat...
> >
> > I've tried specifying O_LARGEFILE explicitly, that did not change the
> > behavior. Is this good enough? Much faster for me to check this way
> > that rebuilding the kernel. But if necessary I can do that.
>
> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
> should fix it though. Might have worked on 32-bit, though.

OK, will test.

>
> > Also, forgot to mention, this is on x86_64, not sure if O_LARGEFILE is
> > necessary to do 2G+ files there?
>
> Internally, yes.
>
> --
> Jens Axboe
>

-- 
Dmitry
