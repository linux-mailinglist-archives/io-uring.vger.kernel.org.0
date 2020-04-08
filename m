Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94411A26F2
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 18:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgDHQMo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 12:12:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44218 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgDHQMo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 12:12:44 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so601324iok.11
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 09:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UeHvRZgHUoaBNGTkCp7AEmXDKHN9fduNv5LerfvrBk=;
        b=PlMdjefxxfmPTbYFmpyeI+ogOFyw83wJRhhIte5JXC2T80en4MujXn9u8lDoSOESfA
         B1Jtx6W6ze6J7gm/WF6mwbkHYrPQq7GOGy++s6+3YBdncBU8yqb28OBNgtRCvzQr8rhe
         BCWkhY+XeU94pPU+sEgotN1tw79sBbaOUvVM0G+tb2iZr5nJsNdpiAL1wKAqqS6gJD2q
         RZGA0YMXvQYAu+WWcdJ/dw/OwITrNJhpnzbmVnA9v4Y5IhLvYWK0WKTeP47XjOuZ36sF
         pgp4ny+R6ZUTMBRfoBZcSyd4X7i7Ni1qx+80LW2R620pnx2IarOJb/31gLF6xJjcu7lk
         /UUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UeHvRZgHUoaBNGTkCp7AEmXDKHN9fduNv5LerfvrBk=;
        b=A09gMNfex2PTfWZwzYUEcVyWwWabYlka8+APujDqzgpU0jJucx/bvNJJpQWeDcxBbw
         2DZlubmHzHuqXukryY2VTeDbwcEBJzmWGYxefgzUFBrvl9mIeGDhcv2Rex37J7yCL089
         jWvqijPF1AmamYrMLyuM9XGcbtZC4XQh8zhvrCR1pplv/0ryrgqnqC1wfNX+XQBQe8PA
         U/eYLpacakjDdsa6W4b0rBJrbXsgf/bEThzqI+RUH0up8NVhHjE5YcajnUS1R0o/BYCU
         YO/yB2BIk3bySC817t/uy8f675V6pSyL4ZdZxxyAABgrXXWKZWSFiwUGes5RVPWBMwQD
         6Nkg==
X-Gm-Message-State: AGi0PuYf9J8ckKNbLzYuD+bQcDIjQ+wuve+TVfDRZkeUYUWqcblAhpjT
        rfjFNaihYRXl6rC1M9LDszrP1mdbFt+f6+c2lAqTCPM4
X-Google-Smtp-Source: APiQypKdohiD0VDVA8iFJDOkRQy0zmDYk4Djkiqat+HEvXhx8g00Q3p/EZ5P1ha1SqGhXu6vZ8D4cSErzl/nyz0aPnI=
X-Received: by 2002:a02:a49a:: with SMTP id d26mr7487591jam.117.1586362363736;
 Wed, 08 Apr 2020 09:12:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk> <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk> <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk>
In-Reply-To: <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 8 Apr 2020 23:12:31 +0700
Message-ID: <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 8, 2020 at 10:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/8/20 8:41 AM, Dmitry Kadashev wrote:
> > On Wed, Apr 8, 2020 at 10:36 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 4/8/20 8:30 AM, Dmitry Kadashev wrote:
> >>> On Wed, Apr 8, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 4/8/20 7:51 AM, Dmitry Kadashev wrote:
> >>>>> Hi,
> >>>>>
> >>>>> io_uring's openat seems to produce FDs that are incompatible with
> >>>>> large files (>2GB). If a file (smaller than 2GB) is opened using
> >>>>> io_uring's openat then writes -- both using io_uring and just sync
> >>>>> pwrite() -- past that threshold fail with EFBIG. If such a file is
> >>>>> opened with sync openat, then both io_uring's writes and sync writes
> >>>>> succeed. And if the file is larger than 2GB then io_uring's openat
> >>>>> fails right away, while the sync one works.
> >>>>>
> >>>>> Kernel versions: 5.6.0-rc2, 5.6.0.
> >>>>>
> >>>>> A couple of reproducers attached, one demos successful open with
> >>>>> failed writes afterwards, and another failing open (in comparison with
> >>>>> sync  calls).
> >>>>>
> >>>>> The output of the former one for example:
> >>>>>
> >>>>> *** sync openat
> >>>>> openat succeeded
> >>>>> sync write at offset 0
> >>>>> write succeeded
> >>>>> sync write at offset 4294967296
> >>>>> write succeeded
> >>>>>
> >>>>> *** sync openat
> >>>>> openat succeeded
> >>>>> io_uring write at offset 0
> >>>>> write succeeded
> >>>>> io_uring write at offset 4294967296
> >>>>> write succeeded
> >>>>>
> >>>>> *** io_uring openat
> >>>>> openat succeeded
> >>>>> sync write at offset 0
> >>>>> write succeeded
> >>>>> sync write at offset 4294967296
> >>>>> write failed: File too large
> >>>>>
> >>>>> *** io_uring openat
> >>>>> openat succeeded
> >>>>> io_uring write at offset 0
> >>>>> write succeeded
> >>>>> io_uring write at offset 4294967296
> >>>>> write failed: File too large
> >>>>
> >>>> Can you try with this one? Seems like only openat2 gets it set,
> >>>> not openat...
> >>>
> >>> I've tried specifying O_LARGEFILE explicitly, that did not change the
> >>> behavior. Is this good enough? Much faster for me to check this way
> >>> that rebuilding the kernel. But if necessary I can do that.
> >>
> >> Not sure O_LARGEFILE settings is going to do it for x86-64, the patch
> >> should fix it though. Might have worked on 32-bit, though.
> >
> > OK, will test.
>
> Great, thanks. FWIW, tested here, and it works for me.

Great, will post results tomorrow.

>
> Any objection to adding your test cases to the liburing regression
> suite?

Feel free to!

>
> --
> Jens Axboe
>

-- 
Dmitry
