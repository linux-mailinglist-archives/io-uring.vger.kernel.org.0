Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6949F31A60E
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBLUaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhBLUaP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:30:15 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34813C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:29:35 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id w36so1293616lfu.4
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZByJQbmwTuAqXq5c1dsYYUiIXM260ajjCuESSowVX4=;
        b=Qv2UWUVg+7VM6BmC8rNnxC8ORlrCFUG6cIsNR1qV6ubFfEAe7CsFjN0xSFPlUVQQHK
         8712jVG3D0s/W1IVwpmYEh0NsF/2KAoVI8gCI9Ejsg9ERAOYqKvpEcLv74fgXBRbcXPS
         pae00rhWob2jZhwatUiXvWnKvl3hUfvgwG5pY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZByJQbmwTuAqXq5c1dsYYUiIXM260ajjCuESSowVX4=;
        b=R+VMoDKBFzDOnRuPHOkee3m7fqWjrXQZXtvH1qxwID3OOuBXxgk8KwKtTLUoX9WT6A
         7pfxRG62GGQBcRtpYazClk0ZaHGANIvreNkQ9izC1aWRIDCttKuy/SW0SpwzUy2kBheD
         Q7mXwLauWVxPVEngPbUDiznxcwmI2d9+zRyCJL1r5MzVoNlHAU1zMaO9CEf0qhfDoWGH
         E9kqyNTL+zFYUHjNgftRiKTKmpnMG04xzwCr7LIkSQzeY5hfwyeEQIXwYlgzb25QOtMt
         EZ9V2ozaYg6h0V7GWEN3RUDkHTdzC6Ecg31fhvNwkhchJ577bOlHVkkKXblSqg5NQPhe
         VfgQ==
X-Gm-Message-State: AOAM530Dkbl50nisTZKe5kV0OB7D4cu1Z/ia7LimxPPInZIT4xRRUlyp
        I7je3t1I7GeloFiFG5Paje+cdGRYUncbjw==
X-Google-Smtp-Source: ABdhPJwsU4wx1e0PCabg5S+O/6IF3KeAeQABXndHcVQgy/F6IeThPw/Geg3zhStujl0i1fcSYlJbjQ==
X-Received: by 2002:a19:385b:: with SMTP id d27mr2582265lfj.22.1613161773232;
        Fri, 12 Feb 2021 12:29:33 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id n20sm677684lfe.89.2021.02.12.12.29.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:29:32 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id j19so1208541lfr.12
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:29:32 -0800 (PST)
X-Received: by 2002:a19:7f44:: with SMTP id a65mr2339937lfd.41.1613161770078;
 Fri, 12 Feb 2021 12:29:30 -0800 (PST)
MIME-Version: 1.0
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
 <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk> <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
 <0c813cc8-142e-15a4-de6a-ebdcf1f03b13@kernel.dk> <CAHk-=whB_gY_ex5CKXeVU28V-EajfRSWpAJ4aFQWrQBAC+Lc0w@mail.gmail.com>
 <bb978a7b-bf38-b03f-506a-c0a80f192cad@kernel.dk>
In-Reply-To: <bb978a7b-bf38-b03f-506a-c0a80f192cad@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 12:29:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgK+8CbxbHKxcJop2sq634mZYUhMeNXLUN6fGnrrKeXbg@mail.gmail.com>
Message-ID: <CAHk-=wgK+8CbxbHKxcJop2sq634mZYUhMeNXLUN6fGnrrKeXbg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 12, 2021 at 12:22 PM Jens Axboe <axboe@kernel.dk> wrote:
>
>   My other idea was
> to add a check in path resolution that catches it, for future safe
> guards outside of send/recvmsg. That's obviously a separate change
> from the comment, but would be nice to have.

I wonder how painful it would be to just make sure that kernel threads
have a NULL ->fs and ->files by default.

But maybe the oops in a kernel thread ends up being too painful and
harder to debug and deal with, and a special check is preferred just
because a WARN_ON_ONCE() wouldn't cause any other downstream issues.

Yes, some kernel threads do need to do pathname lookups (and io_uring
isn't the only such thing), but I think they are generally fairly
special cases (ie things like usermode helper, firmware loaders, etc).

           Linus
