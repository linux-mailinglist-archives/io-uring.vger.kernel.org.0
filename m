Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693032DAC3F
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 12:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgLOLo3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 06:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbgLOLoY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 06:44:24 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115A4C0617A7;
        Tue, 15 Dec 2020 03:43:38 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id t8so20160973iov.8;
        Tue, 15 Dec 2020 03:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMo9XuSTjILRHHigARWnLV+jQvujRXgJrJYMA0vFnik=;
        b=N/gq/xV3EECJ07lIB0nomSFcD+FV3xDjikTXQLZzVRC95W38jLTltsk92Ov3U1lreP
         dy7bgDTbRZQhzgBBEBcaOX14y1DmYa3TBI5l6YWDaFvMUIg7diLjNkSTKIHzR6AGXVa9
         yqEBM35tvQZ3U6OmQ/HL2MhUcGMv8+dZqzYHhoE4iwOD/TtRIsErG6m5e+Hhyq+YVDOP
         /D+1ocZPZArVfuh4LnLM4HGw18AX8/G3Qlon+r2YGAuIXcCSxzuYUEc7/aQFHTx0ua0b
         MuM8xYDg5zPndCsIPBXOH70q9LuwzO5NN9LMv4MylSaWitymlB0WXp9IOrtDl0uSjIah
         TMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMo9XuSTjILRHHigARWnLV+jQvujRXgJrJYMA0vFnik=;
        b=hZFv3tN4oRXSO7FGthEbzjAJKyQHGx5dvH6DU7UlD8qwd7BM4MK0/dsK6xZK1E4Dli
         aHH51LCbBlaU7v0xB0GaLGwtTBYzN3lZeRb6qjggKgPwiuQyE00TMSmBuzhvQkTk42mF
         8OGHftRhpmItzYhyNiJkSGE7C1fm0pgCjgQxU16D6c2AkuaA9EcZZOEABudgOsm9/4+e
         rHr7bQiALlmX2BwDL0FoPfNcork0lcDnX2cX6at7LsI5LznMvZmybRX0fzSI8xvWHmMX
         TWN9luyhj5DMMlR3LqTBdtQXqt+/Qt827E7VrzohuJA8okSuPt1wVWpIExu09vVih3Pz
         mRfQ==
X-Gm-Message-State: AOAM533Kg/y8ZnhnhmWUENfZ9hvWZRN6n0ZklTlBef0N0dePrhEy+AeF
        P2dsgdITJw3PduXg6qvYpaM/o5MiSTxNAXW2g0Q=
X-Google-Smtp-Source: ABdhPJzuAfiHLGn2wHe3f3FxC222TCAUjTW69SKlyt69AeDpPA981mvB5Fxg/+6jnmsKfQ04595czBEzHcpxkv+qyso=
X-Received: by 2002:a05:6602:387:: with SMTP id f7mr14071104iov.209.1608032617498;
 Tue, 15 Dec 2020 03:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20201116044529.1028783-1-dkadashev@gmail.com> <X8oWEkb1Cb9ssxnx@carbon.v>
In-Reply-To: <X8oWEkb1Cb9ssxnx@carbon.v>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 15 Dec 2020 18:43:26 +0700
Message-ID: <CAOKbgA7MdAF1+MQePoZHALxNC5ye207ET=4JCqvdNcrGTcrkpw@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     viro@zeniv.linux.org.uk
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Dec 4, 2020 at 5:57 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Mon, Nov 16, 2020 at 11:45:27AM +0700, Dmitry Kadashev wrote:
> > This adds mkdirat support to io_uring and is heavily based on recently
> > added renameat() / unlinkat() support.
> >
> > The first patch is preparation with no functional changes, makes
> > do_mkdirat accept struct filename pointer rather than the user string.
> >
> > The second one leverages that to implement mkdirat in io_uring.
> >
> > Based on for-5.11/io_uring.
> >
> > Dmitry Kadashev (2):
> >   fs: make do_mkdirat() take struct filename
> >   io_uring: add support for IORING_OP_MKDIRAT
> >
> >  fs/internal.h                 |  1 +
> >  fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
> >  fs/namei.c                    | 20 ++++++++----
> >  include/uapi/linux/io_uring.h |  1 +
> >  4 files changed, 74 insertions(+), 6 deletions(-)
> >
> > --
> > 2.28.0
> >
>
> Hi Al Viro,
>
> Ping. Jens mentioned before that this looks fine by him, but you or
> someone from fsdevel should approve the namei.c part first.

Another ping.

Jens, you've mentioned the patch looks good to you, and with quite similar
changes (unlinkat, renameat) being sent for 5.11 is there anything that I can do
to help this to be accepted (not necessarily for 5.11 at this point)?
