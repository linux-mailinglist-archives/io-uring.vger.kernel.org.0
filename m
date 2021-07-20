Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57D93CF4D0
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 08:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhGTGMT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 02:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhGTGMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 02:12:18 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAA7C061574;
        Mon, 19 Jul 2021 23:52:55 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id b13so31423262ybk.4;
        Mon, 19 Jul 2021 23:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3P8iElB5BGBQz2BogP4lQASid2sQ5rb3EtbxDtbWs4=;
        b=AtS0wxaS1Bj9E3TmY9c1facqtAUt9c2uSz/5v+5sacTMFNZVLJ7Vu5fQyxbN/57CqK
         VjGx/q3n+fhPovMQqwjwUQvv0e2b2Pc7UDROeWsYtFitDoDNs+rVA1bZjAEurNx4bXCK
         gzIt8XolsduvStf4dLN2kKRhssAUCJRcFzSz1bQhksTA+AmtKkkbCbO7cNyB6wAUtMEE
         hwXa5yj7r7ICD32Q89WMxQEfUNMGoiLmuRLnI2mj7JhnOdwe1UjZWR9opuut2u/cVGBX
         qILOfUOmB46REpiydvC0cz79BJZjKa/kYHrtwLqvjQXQ8q2E+E0CYoe497cs6giTUgxM
         aJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3P8iElB5BGBQz2BogP4lQASid2sQ5rb3EtbxDtbWs4=;
        b=JqqF8thsdowOMRM2FwVIV4ACRiPWZuB/4H8E27GdGJ+1tIQzpZF968n8vAOi3nb8ic
         r2Pt8N+1wdwNArOGfTWcjlo74uWuszsSqpykCJF3gVBWKq8KvTb92D65puUHJfMJMF1F
         uevgRb55PUVMnb7+cAiL6T+FQwVI41qpj85v/2uy1pnFLoZVs792HLC16FI8f5fV1tpU
         9o9eBwLrFfbDxlGFeoXA4sLXK8t+SmJdjOxucFIzGJk+Zj3lHv4JikCKDxAI8WrumlSn
         2IDriVJAhZplm9EpgrpY+rXN4uvPz3CiUn6ic7TURJ8TaUC8Y0uMtNBkFtMfihEUzMd0
         95bg==
X-Gm-Message-State: AOAM531FVfxVvVv4/5S3/1hxTULSzILthS/Tk3htSmzP1E0PUzNyO+nf
        iuuoBXF9h2mt5qNtB3wW2dQ+YT4rho/sJFp10FE=
X-Google-Smtp-Source: ABdhPJzeoi9+3uEXJ5VJ1NSLe9UYlkcdyqgQ9slWkEEBGjlwjq+9o5zNkLIc6Mqx+mAcOtAcslDhMkfOL3I7w+kJcG4=
X-Received: by 2002:a25:e08a:: with SMTP id x132mr37315083ybg.511.1626763975019;
 Mon, 19 Jul 2021 23:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210715103600.3570667-1-dkadashev@gmail.com> <20210715103600.3570667-2-dkadashev@gmail.com>
 <YPCRQo3vsSgBwzCN@zeniv-ca.linux.org.uk>
In-Reply-To: <YPCRQo3vsSgBwzCN@zeniv-ca.linux.org.uk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Tue, 20 Jul 2021 13:52:43 +0700
Message-ID: <CAOKbgA68Oa_vrD4nZw0puCiqHFFA_8PrkADrRmWgt=4WE6Wfqw@mail.gmail.com>
Subject: Re: [PATCH 01/14] namei: prepare do_rmdir for refactoring
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 16, 2021 at 2:49 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Jul 15, 2021 at 05:35:47PM +0700, Dmitry Kadashev wrote:
> > This is just a preparation for the move of the main rmdir logic to a
> > separate function to make the logic easier to follow.  This change
> > contains the flow changes so that the actual change to move the main
> > logic to a separate function does no change the flow at all.
> >
> > Two changes here:
> >
> > 1. Previously on filename_parentat() error the function used to exit
> > immediately, and now it will check the return code to see if ESTALE
> > retry is appropriate. The filename_parentat() does its own retries on
> > ESTALE, but this extra check should be completely fine.
> >
> > 2. The retry_estale() check is wrapped in unlikely(). Some other places
> > already have that and overall it seems to make sense.
>
> That's not the way to do it.
>
> static inline bool
> retry_estale(const long error, const unsigned int flags)
> {
>         return unlikely(error == -ESTALE && !(flags & LOOKUP_REVAL));
> }
>
> And strip the redundant unlikely in the callers.  Having that markup
> in callers makes sense only when different callers have different
> odds of positive result, which is very much not the case here.

Yeah, I thought about this, but wasn't sure about interplay of
inline+[un]likely(). But I see that it's used quite a bit throughout the
kernel code so I suppose it's fine. I'll use that next time, thanks.


--
Dmitry Kadashev
