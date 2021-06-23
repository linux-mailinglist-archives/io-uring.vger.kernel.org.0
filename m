Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC583B1362
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 07:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFWFv5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 01:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhFWFv5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 01:51:57 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B15C061574;
        Tue, 22 Jun 2021 22:49:39 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id q64so2270829qke.7;
        Tue, 22 Jun 2021 22:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5wLTG4Vp95UI5Q5Z0gkPAGNaWrHWZDHwLFs+T3shnhA=;
        b=toXJgydzzdke7Xc5dqYBIY81IcXsxA/idZzZPcAg0m0jTTlak4vtEm47a81NcIsl7/
         cFiDqagqY7bYGH/Bt7pdzfkfm1y46Z7Iyqxh3HRPgOYrwGXcquaR1FX7WKbjYdSvrsDY
         Y81VpHa2th/xd8sbpzu4xbgBtCX7eVKeRdw7/h8Ci8+F2rf/ikllAT3/mkGHNBvYF5We
         EpmLWdlYpFZDhS8XH4Oyc4EKNdDBN8F9XKMmOBwgb2xCN2IimireVf+r3dytyKCZPChG
         bsoHGkEQ3XSn56uIpzpKYz+F488qtYsQIwXwiM90lpCB4PODBzm6t1KbtaNpuL7tvk4e
         3kww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wLTG4Vp95UI5Q5Z0gkPAGNaWrHWZDHwLFs+T3shnhA=;
        b=Mhm1zmX/YbG2QAjBTg40wEops5D4YLwGKGIxmJavbamn6v4+2qmTZfz6D/njYpp+RL
         YTsSyHkpM/iza8xhfUkz/MY8pZniyivKNHRg3nxmXWiz04UwSzf/vpHqcD/dXnvdq98s
         vgQkixjxf8tQrD8dPDqHGCfJPzlEObL0gPUsRMKK0Pph4MY2EujE9H4wJe2FO5Bdeqee
         Z6S+RnrtiTyy9TfUdGb+9t0NPPcsLfON8CibL6jB9FT9mUC1fhHxMAM8EOmsF1mRW+AQ
         1PGLozmZ6BWLxhte4/eURWtXEkrvdctDwBVVKKPAH+7pVyuhSG+k2i++AQebVNLuhyHm
         lp6Q==
X-Gm-Message-State: AOAM532EWTqd7H6tV6/UYqP/cOl2wn0mZ4coaju6eBqDQSIVhUYIm714
        kYW2MolzoJW5gd6kpUxbamSDtghm17k0hNkTVZw=
X-Google-Smtp-Source: ABdhPJx+/8O1jP8MbFob62aQTGBQd+swB/8+LHEMKc+JhF6yPJxJl0SZeUrTLvJdiJJTFPfBffd7JsSMyXrOon8glkQ=
X-Received: by 2002:a25:5048:: with SMTP id e69mr9632830ybb.511.1624427378837;
 Tue, 22 Jun 2021 22:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk> <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
 <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk>
In-Reply-To: <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 12:49:28 +0700
Message-ID: <CAOKbgA4POGxPdB02NsCac4p6MtC97q6M3pT09_FWWj41Uf3K2A@mail.gmail.com>
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 23, 2021 at 12:32 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/22/21 11:28 AM, Pavel Begunkov wrote:
> > On 6/22/21 6:26 PM, Jens Axboe wrote:
> >> On 6/22/21 5:56 AM, Pavel Begunkov wrote:
> >>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> >>>> This started out as an attempt to add mkdirat support to io_uring which
> >>>> is heavily based on renameat() / unlinkat() support.
> >>>>
> >>>> During the review process more operations were added (linkat, symlinkat,
> >>>> mknodat) mainly to keep things uniform internally (in namei.c), and
> >>>> with things changed in namei.c adding support for these operations to
> >>>> io_uring is trivial, so that was done too. See
> >>>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> >>>
> >>> io_uring part looks good in general, just small comments. However, I
> >>> believe we should respin it, because there should be build problems
> >>> in the middle.
> >>
> >> I can drop it, if Dmitry wants to respin. I do think that we could
> >> easily drop mknodat and not really lose anything there, better to
> >> reserve the op for something a bit more useful.
> >
> > I can try it and send a fold in, if you want.
> > Other changes may be on top
>
> Sure that works too, will rebase in any case, and I'd like to add
> Christian's ack as well. I'll just re-apply with the fold-ins.

Jens, it seems that during this rebase you've accidentally squashed the
"fs: update do_*() helpers to return ints" and
"io_uring: add support for IORING_OP_SYMLINKAT" commits, so there is only the
former one in your tree, but it actually adds the SYMLINKAT opcode to io uring
(in addition to changing the helpers return types).

-- 
Dmitry Kadashev
