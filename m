Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8D14EF8E
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgAaP2O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:28:14 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33255 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgAaP2O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:28:14 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so7539128lji.0
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r92wjDOXiwcz3Y2pJxc7TJujukW/5/2e2ye2R9cnhYQ=;
        b=azXsQwo1hwPA1bD8MJocXVqlocZ3wZt65jDjZBhwbVRbMZvZXZaOV1+uPor0zZS7Lj
         SWlEGW6Bfi7fmc+SHcUh8y7YyM2q8zOpNr8KcmdFD1Pk2FOpTZAT2630gMihWVDV28ND
         GUBSTlAnCDdkqs9QZLnEV4ifYQTMOTBdEbLko/R9c8laLfBm4BbdVIki1O0LsMvDrnWO
         IFeFGaLjatWuYhB/gzkQ7otIpf4dlFJS3XsPhKc+IExNpJ7w158BwFjqGPUbTu3DlRRS
         W3JT2wNDm0MvXaw4rC0aQ3Nj9YTc3t1ERsS6TfAOuEnXRtR0L66yWW6IE0hy+eDj3ppQ
         XMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r92wjDOXiwcz3Y2pJxc7TJujukW/5/2e2ye2R9cnhYQ=;
        b=rHbUEVPJLKFAg0te4WVwF5MtiCRYB36PcPS3TH/3F1Il8PA3W+86bb8bfIvxn/pgR9
         Zas7B1UgbPawl9NpP0jHwePrzZjrbdL4cDCF2HwC7Zp3FWyiB78F5A6D6e9xWhXs8YnR
         wPAA9v7nX52TgYa8HBvH9Dk/8HyHK/vXfffU3un2LR8vM1x78ykjWoUXhn83tdUlwvQN
         Qw4oXSFOj/9DaEcLGBFATQOc31OIBGmNWy/Lz/26hzfQYs8zJLyjNzv4GtbgrgRsl8g8
         CQpnLnUBZ44KnmbTfF/WoGNTTI4u7l9T3QJq0KYojLWDd1TjdNduQ9t4s5bq2aGpTr1T
         ynDg==
X-Gm-Message-State: APjAAAXnH6F5tMnbkIB2Z3Qr51K2AaNkd2rdsgq073llEr5tkJ7F5W2t
        7MsM0Y33VU64vrc4JLWTh+TYzgHlXVx7E1N2Q+Q39A==
X-Google-Smtp-Source: APXvYqyboQI74ChabIth+Eba7nttLS046MFm6QonAuZLeQJ48skuIaiOzQJbUY6hmcLiNOJFGQb6bzkM6VxSKTXHcYY=
X-Received: by 2002:a2e:b4e7:: with SMTP id s7mr6564955ljm.58.1580484492607;
 Fri, 31 Jan 2020 07:28:12 -0800 (PST)
MIME-Version: 1.0
References: <20200131150002.4191-1-glauber@scylladb.com> <d4cff1bf-bb75-e202-26c8-a6d82fae5737@kernel.dk>
In-Reply-To: <d4cff1bf-bb75-e202-26c8-a6d82fae5737@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Fri, 31 Jan 2020 10:28:01 -0500
Message-ID: <CAD-J=zYGOCSa34u6MCLOs+j9_Kc+C4AhMwdDh+WeK+qmE53ntQ@mail.gmail.com>
Subject: Re: [PATCH liburing] add another helper for probing existing opcodes
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 31, 2020 at 10:24 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/31/20 8:00 AM, Glauber Costa wrote:
> > There are situations where one does not have a ring initialized yet, and
> > yet they may want to know which opcodes are supported before doing so.
> >
> > We have recently introduced io_uring_get_probe(io_uring*) to do a
> > similar task when the ring already exists. Because this was committed
> > recently and this hasn't seen a release, I thought I would just go ahead
> > and change that to io_uring_get_probe_ring(io_uring*), because I suck at
> > finding another meaningful name for this case (io_uring_get_probe_noring
> > sounded way too ugly to me)
> >
> > A minimal ring is initialized and torn down inside the function.
> >
> > Signed-off-by: Glauber Costa <glauber@scylladb.com>
> > ---
> >  src/include/liburing.h |  4 +++-
> >  src/liburing.map       |  1 +
> >  src/setup.c            | 15 ++++++++++++++-
> >  test/probe.c           |  2 +-
> >  4 files changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/src/include/liburing.h b/src/include/liburing.h
> > index 39db902..aa11282 100644
> > --- a/src/include/liburing.h
> > +++ b/src/include/liburing.h
> > @@ -77,7 +77,9 @@ struct io_uring {
> >   * return an allocated io_uring_probe structure, or NULL if probe fails (for
> >   * example, if it is not available). The caller is responsible for freeing it
> >   */
> > -extern struct io_uring_probe *io_uring_get_probe(struct io_uring *ring);
> > +extern struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring);
> > +/* same as io_uring_get_probe_ring, but takes care of ring init and teardown */
> > +extern struct io_uring_probe *io_uring_get_probe();
>
> Include 'void' for no parameter.
>
> > @@ -186,3 +186,16 @@ fail:
> >       free(probe);
> >       return NULL;
> >  }
> > +
> > +struct io_uring_probe *io_uring_get_probe() {
>
> void here as well, and new line before the opening bracket.
>
> Minor stuff, rest looks fine to me.

What's next? tabs instead of spaces?
You monsters.
