Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECAEF119E87
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 23:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLJWqm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 17:46:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37550 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfLJWql (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 17:46:41 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so586898pfn.4
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 14:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=akwsCw/gQkYRGNyKeKnVUbRCE2t9RGViqaa8+M90jU4=;
        b=WFPQ+kU3upEbn9U9V5SmauP8G7mOk2Pc3KP5kBQkrodfu7M5icvYyi8J7YITbJsvJ+
         7lMXGLDWo8RQEOp8aJOx6qsGL8egmL+e0g2cqA81QOjngarOsP0GLSCpC5vS9LDnKthj
         9ykXDjJsgNzQQ7lxH2Pesfigt5U6nK9Hg/uWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=akwsCw/gQkYRGNyKeKnVUbRCE2t9RGViqaa8+M90jU4=;
        b=nniDftvt2x603OxqNMBZr0p/GK8A+GmhaHD4VIIYj3bWiO/0p5iUv3KlcKEHA1eZ0J
         nCdYXhLjBrESKzgaZ7x27IhQVso5vRXsjIfdfwrQATMFtwxOh1VRgyIS2ve0qH5YHzI+
         WnIyU/D9BaJGeAzK6/JVuYa+DoidhFg+LzmIPJGKmI4EmbOwvDy7oMCm3QE1RXuYhvOp
         nRShoLwXpK6sN0gNCLNyFc+CNNv/nsWMt2UU6Xun4WJWkQ2JY26ZphYl3aJy6bWOTRSi
         LoGiMzkOLDjea76+Rv/lJyNxEUrBHZmi9DL8DY4RVu8xa/4uTmEXGKPLqg+vvj9AsDYS
         RXtA==
X-Gm-Message-State: APjAAAUzyNarlSuy9buCEZFZigAN9L1PvXCphAPYzVnMGXFRJuNjlmZ1
        antucXetp8DzcQLqclmh6ytC2g==
X-Google-Smtp-Source: APXvYqyCIdvMp0696hwDy8V9djBp4n3+60Ljr9uC+Leaj9YF5clUFpKrNGt4yLbrhaZEoqquXqY9ug==
X-Received: by 2002:a65:41cd:: with SMTP id b13mr501343pgq.385.1576018001276;
        Tue, 10 Dec 2019 14:46:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b98sm27493pjc.16.2019.12.10.14.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 14:46:40 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:46:39 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
Message-ID: <201912101445.CF208B717@keescook>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
> On 12/10/19 3:04 PM, Jann Horn wrote:
> > [context preserved for additional CCs]
> > 
> > On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> Recently had a regression that turned out to be because
> >> CONFIG_REFCOUNT_FULL was set.
> > 
> > I assume "regression" here refers to a performance regression? Do you
> > have more concrete numbers on this? Is one of the refcounting calls
> > particularly problematic compared to the others?
> 
> Yes, a performance regression. io_uring is using io-wq now, which does
> an extra get/put on the work item to make it safe against async cancel.
> That get/put translates into a refcount_inc and refcount_dec per work
> item, and meant that we went from 0.5% refcount CPU in the test case to
> 1.5%. That's a pretty substantial increase.
> 
> > I really don't like it when raw atomic_t is used for refcounting
> > purposes - not only because that gets rid of the overflow checks, but
> > also because it is less clear semantically.
> 
> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
> that's what I should do. But I'd prefer to just drop the refcount on the
> io_uring side and keep it on for other potential useful cases.

There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
out as nearly identical to the x86 asm version. Can you share the
workload where you saw this? We really don't want to regression refcount
protections, especially in the face of new APIs.

Will, do you have a moment to dig into this?

-Kees

> 
> >> Our ref count usage is really simple,
> > 
> > In my opinion, for a refcount to qualify as "really simple", it must
> > be possible to annotate each relevant struct member and local variable
> > with the (fixed) bias it carries when alive and non-NULL. This
> > refcount is more complicated than that.
> 
> :-(
> 
> -- 
> Jens Axboe
> 

-- 
Kees Cook
