Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C711B94D
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2019 17:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfLKQ4r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Dec 2019 11:56:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43764 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfLKQ4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Dec 2019 11:56:46 -0500
Received: by mail-pl1-f193.google.com with SMTP id q16so1637031plr.10
        for <io-uring@vger.kernel.org>; Wed, 11 Dec 2019 08:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/d+yr7KgXhByLIpgiEXK6Nig0QpxVVQC2tZ5bF2Qi4=;
        b=HBOJcsNdTBlNX6VV247RVW5qKsZHF5VRW9GkWI2cfEQNZl0iQHXABCyKEYeryURNzj
         7tOK+ChcTVeCuqyS4wnIqFFDYqSF9Qr3nJB088cZ7viuZXEAKVKviEdG0IPtoyWoFQK/
         4behDRcRLfbTHFpCzY/5xPHUxQnrJhTOi9DDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/d+yr7KgXhByLIpgiEXK6Nig0QpxVVQC2tZ5bF2Qi4=;
        b=XX0l75czGppQpqVg3mSYTRaMHiJvyHC0UWIRvp0ix0LJRcDKx8KgMVAizfHFRswu45
         h4mKCmm6h5m6MyaCV5GuYp3Prma4FHYY1bc0wY5nvbSkVS71zS2ayTd8vUhN/tsoh1bL
         1ttek/kKzsSQPVdOAeqjjOZvWiwMUXS9FtXGzrebjKRgyB8r/8Tv5ZTVVdt84Unliwnt
         rTqYGza62bbmtF76Ve4VqmZuGAS930hOsZlJiSpCdhX8aD3PNzT0TT5PIMnvnSXDfy1o
         7P2c/+tM0Wq4BfqluI5duBN2n/7yqr6/Rv3z9K1MsWdb3rA87c3vOvslu3J1C/o2ERG2
         ZkzQ==
X-Gm-Message-State: APjAAAVKRoPNENf43gwFPJ3ijz4gwRhqLc7mcVo4nfuhs+5Ho8zBR+IP
        K5RBnqopehHXF8nNZC2R69TX/g==
X-Google-Smtp-Source: APXvYqxxqFgQ0KcWGPjJAFVZZdrg6lYFk8iN9apUOHaKqroVoJJoC93SAs2D/iq3g2HZJ6ssQx4S0A==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr4441253pjb.99.1576083406113;
        Wed, 11 Dec 2019 08:56:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 129sm3795781pfw.71.2019.12.11.08.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 08:56:45 -0800 (PST)
Date:   Wed, 11 Dec 2019 08:56:44 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Will Deacon <will@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
Message-ID: <201912110851.88536F3F@keescook>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
 <201912101445.CF208B717@keescook>
 <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
 <20191211102012.GA4123@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211102012.GA4123@willie-the-truck>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 11, 2019 at 10:20:13AM +0000, Will Deacon wrote:
> On Tue, Dec 10, 2019 at 03:55:05PM -0700, Jens Axboe wrote:
> > On 12/10/19 3:46 PM, Kees Cook wrote:
> > > On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
> > >> On 12/10/19 3:04 PM, Jann Horn wrote:
> > >>> [context preserved for additional CCs]
> > >>>
> > >>> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>> Recently had a regression that turned out to be because
> > >>>> CONFIG_REFCOUNT_FULL was set.
> > >>>
> > >>> I assume "regression" here refers to a performance regression? Do you
> > >>> have more concrete numbers on this? Is one of the refcounting calls
> > >>> particularly problematic compared to the others?
> > >>
> > >> Yes, a performance regression. io_uring is using io-wq now, which does
> > >> an extra get/put on the work item to make it safe against async cancel.
> > >> That get/put translates into a refcount_inc and refcount_dec per work
> > >> item, and meant that we went from 0.5% refcount CPU in the test case to
> > >> 1.5%. That's a pretty substantial increase.
> > >>
> > >>> I really don't like it when raw atomic_t is used for refcounting
> > >>> purposes - not only because that gets rid of the overflow checks, but
> > >>> also because it is less clear semantically.
> > >>
> > >> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
> > >> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
> > >> that's what I should do. But I'd prefer to just drop the refcount on the
> > >> io_uring side and keep it on for other potential useful cases.
> > > 
> > > There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
> > > out as nearly identical to the x86 asm version. Can you share the
> > > workload where you saw this? We really don't want to regression refcount
> > > protections, especially in the face of new APIs.
> > > 
> > > Will, do you have a moment to dig into this?
> > 
> > Ah, hopefully it'll work out ok, then. The patch came from testing the
> > full backport on 5.2.

Oh good! I thought we had some kind of impossible workload. :)

> > Do you have a link to the "nearly identical"? I can backport that
> > patch and try on 5.2.
> 
> You could try my refcount/full branch, which is what ended up getting merged
> during the merge window:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=refcount/full

Yeah, as you can see in the measured tight-loop timings in
https://git.kernel.org/linus/dcb786493f3e48da3272b710028d42ec608cfda1
there was 0.1% difference for Will's series compared to the x86 assembly
version, where as the old FULL was almost 70%.

-- 
Kees Cook
