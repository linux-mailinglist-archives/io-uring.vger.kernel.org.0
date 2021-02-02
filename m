Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17F330C873
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 18:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbhBBRue (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 12:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbhBBRp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 12:45:56 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007A2C06178C
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 09:45:14 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y18so6572000edw.13
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 09:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WbFmGTnrxBJNCCauQQKDevM3dgTzqjXTq2+Nr98IxRc=;
        b=DmQk7W3FUbV3DjrUbXgnM9lb6t53/liiza8pdtZWfrMSK6M2gk4I5BLYI1TqLk8v/4
         6raIWH/h8xZ0p2hhcw/aSeEMez9InxWtnmqdm2JKpouGS/IO4HQDDaXw22jhOba9NpUV
         zcuOtSa9xhInyXKwdsW7kNFkpaADAI4C8awNHgqpKZce4XS9UhOTR0cYTvyrK5BA3rUR
         441d259eHkbFo8EPFvQiqZr6TwL/U89ssqMWaQi59PNynR4sOb8/jCsh6HXEFrjjB8BU
         AEa9PH/DJUmKSSC7yt/mg+Q8rUfYv15lfrnDi85DsUE6UsceTLph984cNMtglA7beHxF
         GpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WbFmGTnrxBJNCCauQQKDevM3dgTzqjXTq2+Nr98IxRc=;
        b=CHN8l9Smpc+7eIJbKDZV43kDgMd7cK/u6G82X1iPRsIjo+0fWDfxPsziHS0fbF3qnS
         q/6KfJeun87pQEHSR2qQQ/vmuzjpWgtF8Yf4xc7sb6zDRNRegpsARX92zD5AXkGESa21
         g1O366NOJ/cszfcBdBWKoSMibuUbCp/e2WMBpHoxqDL0mxTHehuQz4EG4cUrdkD6c4MI
         3YJMCtfFG5Et15S5ycHSBqt8XC/8ftHBz/B4pMaMWVVYZWJIT4GKj4gLuqOuT0IKu6h/
         uo68CwXQ8Pvw9m3xMymn05DGPaMJI1BVs+T+LzzWtkvSYU4vrc49iCNXNbk94MVzmcyX
         2yQA==
X-Gm-Message-State: AOAM533VzcR71d7o9KVJe3QPL+cumLmyUYOyJJPf3CQJqXBSN2y0MWt8
        GJzqioRzsY8FYstS2vna8bJJ6uezWbvKnlYa6ZmIqaKEALg=
X-Google-Smtp-Source: ABdhPJxKF319zvcxIud8NisE6jUoEAGeIck0tTAzhpqfcxG7t8skEP2Pb0dhshmJFzA7jLYakC8LXAj00OF7FagOYT8=
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr58271edb.181.1612287913725;
 Tue, 02 Feb 2021 09:45:13 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <8a3ba4fc-6e60-a3e7-69f4-0394799e7fd7@gmail.com> <CAM1kxwgOwWhv=O_vOpyQfca-9Vjo4+SrmxPR5MxTGf_9pE4_Gg@mail.gmail.com>
In-Reply-To: <CAM1kxwgOwWhv=O_vOpyQfca-9Vjo4+SrmxPR5MxTGf_9pE4_Gg@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 12:45:02 -0500
Message-ID: <CAM1kxwhDyU3u-j8KB+GfTBhi8cKxxaQ9-bb_6uMOQR0B7YR9UQ@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

side note question on optimal sqpoll topology, assume a single
threaded application, if you're going to pin the application thread
and the sqpoll thread to the same logical cpu... is that stupid? maybe
they'll just back and forth preempt each other? because either your
application is doing work, or you're waiting on io_uring in the kernel
to deliver it more work to do, not a scenario where there's idleness
to be exploited with parallelism.

the only advantage that comes to my mind would be, take a network
server example, reducing the latency of submitted packets getting out
by time sharing the work of pushing those packets out with application
work constructing the next ones.

On Tue, Feb 2, 2021 at 12:30 PM Victor Stewart <v@nametag.social> wrote:
>
> > There is a change of behaviour, if IORING_FEAT_EXT_ARG is set it
> > won't submit (IIRC, since 5.12) -- it's pretty important for some
> > multi-threaded cases.
> >
> > So... where in particular does it say that? In case your liburing
> > is up to date and we forgot to remove such a comment.
>
> https://github.com/axboe/liburing/blob/c96202546bd9d7420d97bc05e73c7144d0924e8a/src/queue.c#L269
>
> "For kernels without IORING_FEAT_EXT_ARG (5.10 and older), if 'ts' is
> specified, the application need not call io_uring_submit() before
> calling this function, as we will do that on its behalf."
>
> and I'm using the latest Clear Linux kernel which is 5.10, so that's
> why I wasn't submitting.
