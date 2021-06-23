Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4153B1350
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 07:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFWFjr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 01:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWFjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 01:39:47 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9580EC061574;
        Tue, 22 Jun 2021 22:37:30 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id c138so2235754qkg.5;
        Tue, 22 Jun 2021 22:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mr/IgEBLP15TolRhyGX93EDzDXsga4V1H704WDpWF2E=;
        b=EfLFCDLgBIjcVxkS04mp1NF0/F9DBCd6gY5/jK7/Q6QobMTUeowWZmM6rqQWFrHNJ4
         nvnYCg1yReAKj5cKKEjGr3s3WXKv6k0SR5lAVVpMyPdSMKb4cz3KfOTdkNpP+XjYH4xt
         1v5Fbi0GOBZtt/L8cwZu/ReANPAz51VeKMYCuqlvQJYpoTpQUzynvKuKIXY/VqTvRO4c
         7ZNpIXDRKX+V58MHefqdjrH6OUom1kIavSy3yEhcXmQQLQg6QZ3QBD14CxlB9XZ6X/RJ
         HMsCV/KyYWbfjjgYYhkechEsSdK4Gt6fVzQ3fyAperUHSUYslx0etCMbWGNabbWUKjyD
         FJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mr/IgEBLP15TolRhyGX93EDzDXsga4V1H704WDpWF2E=;
        b=fM+GQUBl9IA29lIQb+TdFmVVRC8GBUXyMCyzs1nV3aW0B8jgLChANXdj+db9CUdN7m
         kq2R8L7Vt2TRPhHhQr86p8KEQYO/s8xhrw585x2b6BIUJbUtt6UhOKySE8VkTUqljUxU
         Aco0grkOx6vRXrUui3+yvfD3TJ63iY1c3jmNIEbLaSu32jqk4ts2DRGSTouD9Ic5CGy6
         fCkcXyDbbYxepoIJb230aaSeX2lJWWA4Ja8j/jmaJuPVCzkIqd2XTlpM4RT8jQiCLNsM
         o7ouYJ3m1y0OmkRHJffKih8eZf0GNUJfxq6YOhMZnB6equ0Fq9AVaOqMBLVMqfmvDT3h
         25bQ==
X-Gm-Message-State: AOAM533PaWTVgDD+4CZGdNP1Cce5NDf7NEfNvd9SToILd5gAtxfE1Xe6
        FyDh/py/nylyMPBRoHBg3iCDb3p1wK+oOXpFR88=
X-Google-Smtp-Source: ABdhPJxAtgPDOQwqLuYtJ4ja0+OWw7BFrlEGHn8tkAVemj2bLYPUVI4zzk2nOGYbCfTPl/a8SL4KioKSoXseeaNjWbU=
X-Received: by 2002:a5b:ac1:: with SMTP id a1mr10315800ybr.289.1624426649871;
 Tue, 22 Jun 2021 22:37:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210603051836.2614535-1-dkadashev@gmail.com> <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk> <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
 <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk>
In-Reply-To: <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 23 Jun 2021 12:37:19 +0700
Message-ID: <CAOKbgA69BZ5nGBi-OdcgngXN8G45Tfhn1QYY9hJehO1tPkh0ZA@mail.gmail.com>
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

Thanks Jens and Pavel, I'll process the comments and will send a follow-up
patchset.

-- 
Dmitry Kadashev
