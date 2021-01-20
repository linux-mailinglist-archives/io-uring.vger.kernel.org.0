Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812C32FCCA4
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 09:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbhATIYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jan 2021 03:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730705AbhATIWX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jan 2021 03:22:23 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A7C061757;
        Wed, 20 Jan 2021 00:21:42 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id e22so21542066iog.6;
        Wed, 20 Jan 2021 00:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ckod8j91Qi1DFD/kQoVWkbJoQXBZcjK1wtV0ATcUQS4=;
        b=X/rqTxDQ3/3/Mb+AyfVGzWo0uKr/8VwPBod5eEQ/3WzYj9LA9JkkP0s7efJWpyHJyv
         uGaDKod0AthztJ6VgM720hMH33rzYPfhWhqGoDprnTnGbpNt1nR0FvS3Y/eZvduYpWRd
         nQY2u5AIB0WcdJ6puc7KxZADEcDVQU+4tpvOFC9K1kvIFfBW77G0EXC2Be9azC40Lf2h
         pd/7ZzmNtitia9hdUN02iP2MLQo4UqPk/3hcwWRLGSClpRLqfgTSBlWPHY3T4121X537
         mxiRVYBgXBjOUoSRpZIlWYk9OrmHAotc77YQ0LKLbz6UWGnKl+/pa205AAjNi/Yo/PW2
         8fjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ckod8j91Qi1DFD/kQoVWkbJoQXBZcjK1wtV0ATcUQS4=;
        b=cfAwgT+3+JWDbkBJrkKQohr/I1OM/PrnqikspWNKi1mTReLNIIsL3D5K1OJhb8Py7o
         uuC0mzzlEeCD1qmv2R6gs8IdCPI4RlQd8brlA1lih/SgXXHn08P0bzSWwt0L+Cvmk/GQ
         mbdeHfc+ZBNhaIFJcuYA0Jqvj2azGvuDmlsg34y4ezuMwSgxOAb9Y+toXXmWqgDDXBko
         J+92VmK6Ja9Y4fGkOp7+UGKlTsQjAY0H4+TSAoa3yRAsTnFy11zlFRuPCUIiXceeUJMc
         IQ0PHV05+HzgzUWKm6MOzWpDBylyUfBI+OWLXNgKAKw6v9GN+RTY3EM13CWvxN3rmiE/
         dlWQ==
X-Gm-Message-State: AOAM531wwiCpZeUu0mwRzHsM15hQmTkM4EfCCjXbaJUe03WpxLG64yrZ
        cQCqgm0hx8jYa5Cfo+myGk6LDsGwrQeLxp32k1w=
X-Google-Smtp-Source: ABdhPJy/tIFj/SFzluX9jG+hsUT9Z9au+kFYwYw184+PdNOXw2/iycfQQO5TlTYjToFPhShbm/yKfUh6A4imPOSUvvc=
X-Received: by 2002:a05:6e02:5d1:: with SMTP id l17mr6776029ils.154.1611130901150;
 Wed, 20 Jan 2021 00:21:41 -0800 (PST)
MIME-Version: 1.0
References: <20201116044529.1028783-1-dkadashev@gmail.com> <X8oWEkb1Cb9ssxnx@carbon.v>
 <CAOKbgA7MdAF1+MQePoZHALxNC5ye207ET=4JCqvdNcrGTcrkpw@mail.gmail.com> <faf1a897-3acf-dd82-474d-dadd9fa9a752@kernel.dk>
In-Reply-To: <faf1a897-3acf-dd82-474d-dadd9fa9a752@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 20 Jan 2021 15:21:28 +0700
Message-ID: <CAOKbgA7wLAeNo_La=jjL8JtPz1FhvssLOgWb91T_PzP+c83h7A@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     viro@zeniv.linux.org.uk, io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 11:20 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/15/20 4:43 AM, Dmitry Kadashev wrote:
> > On Fri, Dec 4, 2020 at 5:57 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >>
> >> On Mon, Nov 16, 2020 at 11:45:27AM +0700, Dmitry Kadashev wrote:
> >>> This adds mkdirat support to io_uring and is heavily based on recently
> >>> added renameat() / unlinkat() support.
> >>>
> >>> The first patch is preparation with no functional changes, makes
> >>> do_mkdirat accept struct filename pointer rather than the user string.
> >>>
> >>> The second one leverages that to implement mkdirat in io_uring.
> >>>
> >>> Based on for-5.11/io_uring.
> >>>
> >>> Dmitry Kadashev (2):
> >>>   fs: make do_mkdirat() take struct filename
> >>>   io_uring: add support for IORING_OP_MKDIRAT
> >>>
> >>>  fs/internal.h                 |  1 +
> >>>  fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
> >>>  fs/namei.c                    | 20 ++++++++----
> >>>  include/uapi/linux/io_uring.h |  1 +
> >>>  4 files changed, 74 insertions(+), 6 deletions(-)
> >>>
> >>> --
> >>> 2.28.0
> >>>
> >>
> >> Hi Al Viro,
> >>
> >> Ping. Jens mentioned before that this looks fine by him, but you or
> >> someone from fsdevel should approve the namei.c part first.
> >
> > Another ping.
> >
> > Jens, you've mentioned the patch looks good to you, and with quite
> > similar changes (unlinkat, renameat) being sent for 5.11 is there
> > anything that I can do to help this to be accepted (not necessarily
> > for 5.11 at this point)?
>
> Since we're aiming for 5.12 at this point, let's just hold off a bit and
> see if Al gets time to ack/review the VFS side of things. There's no
> immediate rush.
>
> It's on my TODO list, so we'll get there eventually.

Another reminder, since afaict 5.12 stuff is being merged now.

-- 
Dmitry Kadashev
