Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827A92F8FCB
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 00:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbhAPXGM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 18:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbhAPXGL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 18:06:11 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5EEC061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:05:30 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id a12so18690878lfl.6
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5QEre34oG1StFb7o7AzShkuA5ElWCt9T6npI6p16IpQ=;
        b=XIwLJTXJS/KgCGzbas0AclyFR4TZRpji2BJwYX3wuqbwEX9ux6PrGZQHblD7osQEyy
         R7z5E2S/+tJiz4sddzGRSyE/5OLvpEni6KqBGuVa8yHM4A2tjelp6bFlw5RcKpu5kCeT
         r6SZgdOvfWMWgIy4ztvazM2Z9DMBZDD6NhfDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5QEre34oG1StFb7o7AzShkuA5ElWCt9T6npI6p16IpQ=;
        b=IGthYQk9oRMYsoiVoDIkwWKDHDYj2drWSj8iG0NYKavoqQ4GBjcZPE7PgW9IOcs5Y6
         EGCOMqDJ/uPjfQ3lYCnGFY7S1RcfxQvADe0kra/IEq3Rzugo+VNBmI8U2/k8/D8rJCgT
         si8vdLsyszLKM7Bj7uGpOshMk1az8UbHiCpZerMPjBMMaYQkCrxldrMyn1gAY1Hro9Pk
         qfZpUJfOjvDktZnQ+ps1Q0GhtNDDzNTDOP3hO3MMv3+zIQLgLnRMWFzjU/ZrirdwPyQ0
         jeEARpl2P0kU/GXADPCc5iQHPqLNm7G72QFe/0d0dH5WAQufIKGSgWw6Up/jGccjbFq5
         oKZA==
X-Gm-Message-State: AOAM5337paxEVC9EtaiGF6Gd0VXYziwQUPBg6em9esALvWQpxNkK9kmg
        hvjcReRzeY1N+8sq2IWfw9+BmOXzZFjYHA==
X-Google-Smtp-Source: ABdhPJwrJK2vfevN+8P9nLc8GhQre5XU/uk//pojsV6c3B4mqxhOr0S0G4vXv0/MnR9w9CPh3c2N7w==
X-Received: by 2002:a05:6512:695:: with SMTP id t21mr6365530lfe.61.1610838327877;
        Sat, 16 Jan 2021 15:05:27 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id 192sm1402545lfa.219.2021.01.16.15.05.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 15:05:27 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id f17so14322641ljg.12
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:05:26 -0800 (PST)
X-Received: by 2002:a2e:6f17:: with SMTP id k23mr7706687ljc.411.1610838326498;
 Sat, 16 Jan 2021 15:05:26 -0800 (PST)
MIME-Version: 1.0
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk> <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com> <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
 <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
 <61566b44-fe88-03b0-fd94-70acfc82c093@kernel.dk>
In-Reply-To: <61566b44-fe88-03b0-fd94-70acfc82c093@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 16 Jan 2021 15:05:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh3Agdy3h+rsx5HTOWt6dS-jN9THBqNhk=mWG4KnCK0tw@mail.gmail.com>
Message-ID: <CAHk-=wh3Agdy3h+rsx5HTOWt6dS-jN9THBqNhk=mWG4KnCK0tw@mail.gmail.com>
Subject: Re: Fixed buffers have out-dated content
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Martin Raiber <martin@urbackup.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jan 16, 2021 at 2:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Linus, I'm looking into the above report, all of it should still be
> intact in the quoted section. Figured it would not hurt to loop you in,
> in case this is a generic problem and since Martin identified that
> reverting the above changes on the mm side makes it go away. Maybe
> there's already some discussion elsewhere about it that I'm not privy
> to.

Ok, that commit clearly ended up more painful that it should have been.

The problem is that with it, if we revert it, then we'd have to also
revert  a308c71bf1e6 ("mm/gup: Remove enfornced COW mechanism"). which
depends on it.

And that fixed its own set of problems.

Darn.

I'll go think about this.

Martin, since you can apparently trigger the problem easily, hopefully
you're willing to try a couple of patches?

           Linus
