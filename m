Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1EC353929
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhDDRZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 13:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhDDRZS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 13:25:18 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3BCC061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 10:25:11 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id l123so5285836pfl.8
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 10:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tavianator.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KAn3IqWtVuCmS61yGdEVkm4F7FdgX8PbDd4tjkt0V3g=;
        b=gyjhPZcscd20WKLrooyUmndDImENpWjJZBMPgLmys2FLZpGZMyVx4/yl/I4myZrVP5
         DbSFnFb/hqtlfTWVOv18muDFzcMauOd9Vh4zVKgqUDSrJHxUPcNJDmociw3fEkfM6VK+
         pTLlLEjlFnCSQxR9/HUPLFviV/JIzjB0JJDMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KAn3IqWtVuCmS61yGdEVkm4F7FdgX8PbDd4tjkt0V3g=;
        b=rjvGQHVCglyyBquKZUmkdV2P8MErQT6uGORBpINyNLeLFSxaasf5xAEOz7XQrx34kC
         J+62M5chaqH98NpvkMdhpk5ZlFFjkUorFxE/xLcky2RXdig15/8CVigTpftr7EkwhwDG
         0t5QGlyK4uchjXh4Kaj/DAbM5N0DItfWL+WeyBS53LhBEB9apfLiSAH1b4/qf7GdvtT/
         M1b+YLseWIv+aKT3EuEu+Tr1P476L7TscY/TrYyT/U76Y38J+m/jt0xdKVXkFLWs1j01
         3uKXcwf/ArbFFRYJLXMiM4pK/GL1sqtpbq3y22c8rm2CUAZ0aL2AK5H82iG7xoS2OfUb
         9W/A==
X-Gm-Message-State: AOAM531XN7jrxDC9GMaMNcgrCCEr9Iwo/vvxniI92MNXdJ3mHG44o2Y6
        cucbCcMB0yR5MLJsiZI+lah5/HwnI4X930F4oR5hIH3RDLlTTA==
X-Google-Smtp-Source: ABdhPJxKvv2z3Yndxt19Rn0rV9miB89zWfF8JaD+qoWse+wmnUDBhWNe5LdpPh+J6mWHkAkua4J9dHhiY1KHh2OlBeQ=
X-Received: by 2002:a63:d704:: with SMTP id d4mr19611625pgg.221.1617557111117;
 Sun, 04 Apr 2021 10:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <YGMIwcxAIJPAWGLu@wantstofly.org> <20210404044216.w7dqrioahqvbg4dz@ps29521.dreamhostps.com>
In-Reply-To: <20210404044216.w7dqrioahqvbg4dz@ps29521.dreamhostps.com>
From:   Tavian Barnes <tavianator@tavianator.com>
Date:   Sun, 4 Apr 2021 13:25:00 -0400
Message-ID: <CABg4E-keAb4b4BMQDbdyj16p8GTBQgc2ribSzJCGpY-SMnn9TA@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] io_uring: add support for IORING_OP_GETDENTS
To:     Clay Harris <bugs@claycon.org>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        io-uring@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 4 Apr 2021 at 00:42, Clay Harris <bugs@claycon.org> wrote:
> On Tue, Mar 30 2021 at 14:17:21 +0300, Lennert Buytenhek quoth thus:
>
> > ...
> >
> > - Make IORING_OP_GETDENTS read from the directory's current position
> >   if the specified offset value is -1 (IORING_FEAT_RW_CUR_POS).
> >   (Requested / pointed out by Tavian Barnes.)
>
> This seems like a good feature.  As I understand it, this would
> allow submitting pairs of IORING_OP_GETDENTS with IOSQE_IO_HARDLINK
> wherein the first specifies the current offset and the second specifies
> offset -1, thereby halfing the number of kernel round trips for N getdents64.

Yep, that was my main motivation for this suggestion.

> If the entire directory fits into the first buffer, the second would
> indicate EOF.  This would certainly seem like a win, but note there
> are diminishing returns as the directory size increases, versus just
> doubling the buffer size.

True, but most directories are small, so I expect it would be a
benefit most of the time.  Even for big directories you still get two
buffers filled with one syscall, same as if you did a conventional
getdents64() with twice as big a buffer.

> An alternate / additional idea you may wish to consider is changing
> getdents64 itself.
>
> Ordinary read functions must return 0 length to indicate EOF, because
> they can return arbitrary data.  This is not the case for getdents64.
>
> 1) Define a struct linux_dirent of minimum size containing an abnormal
> value as a sentinel.  d_off = 0 or -1 should work.
>
> 2) Implement a flag for getdents64.

Sadly getdents64() doesn't take a flags argument.  We'd probably need
a new syscall.

> IF
>         the flag is set AND
>         we are returning a non-zero length buffer AND
>         there is room in the buffer for the sentinel structure AND
>         a getdents64 call using the d_off of the last struct in the
>                 buffer would return EOF
> THEN
>         append the sentinel struct to the buffer.
>
>
> Using the arrangement, we would still handle a 0 length return as an
> EOF, but if we see the sentinel struct, we can skip the additional call
> altogether.  The saves all of the pairing of buffers and extra logic,
> and unless we're unlucky and the sentinel structure did not fit in
> the buffer at EOF, would always reduce the number of getdents64
> calls by one.
>
> Moreover, if the flag was available outside of io_uring, for smaller
> directories, this feature would cut the number of directory reads
> of readdir(3) by up to half.

If we need a new syscall anyway, the calling convention could be
adjusted to indicate EOF more easily than that, e.g.

int getdents2(int fd, void *buf, size_t *size, unsigned long flags);

With 0 being EOF, 1 being not-EOF, and -1 for error, or something.

-- 
Tavian Barnes
