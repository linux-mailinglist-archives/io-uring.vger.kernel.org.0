Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD651B5E14
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgDWOmg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 10:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726963AbgDWOmg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 10:42:36 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F3FC08E934
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 07:42:35 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id j3so6454547ljg.8
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 07:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P5+8uiPRj2yJOh8r/quIJtjK5761OVnYQDLHFXmy0Eg=;
        b=luqC+P1dmNjnskOpL42bZtyM+BEtz/lNi9pmpr/qxGtx9Mn/SiUTttdTee9zsvQ7L/
         ktH6lMLZUazgaCjz8xNgXN5aPUoYBw4kUsxhPvgGBVYgba/UtG6PBAlumLwRd/fWmfVU
         x9wJqRenfiSDhYLB4WYWx7EN2lNyjMKble1n0NfkgubD7pADsqpXVgLMeD1f9kU+lGtQ
         5G6505/ZRM5rGP1o2+WTkiSh84gDkFczP0AMz3DH3SvGR+4RNe29f97ay+psyjkD2Y/j
         nj/ONPijCjBkhWoJR/94SsoGb9ZjtPLjafq5RKRg3M/i44ybIKG4JOO8nhKgBJPFpLiy
         1W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P5+8uiPRj2yJOh8r/quIJtjK5761OVnYQDLHFXmy0Eg=;
        b=BGyaJAr1FboQ15G4a8Qq4jQC98cz4acf5TyWtkTjCbN8fXCqNUgkpNS2/fMVaRBq0L
         m49HgrGnp2IPTtn4JGx8CN/UbeYfz09jpNsXgwsnOkeQ7Y7ruh2IZ50aTdXeIo+gW450
         dgt+s8XBDjExN0m92Y9sBjROqWNQl61NRQDBubJyLdllUkMEghBnIHigdh7Zx1XbsFUe
         ErPYaoNkS0iR1Velgq0jx93SJZDfpr3OHYeOpBd1hyBo0Vm6GC87srkOxexaSkPwklYG
         +BIrnMNrrHPrfh5WQO2YTzj+vXjE8dJ/DPVjRd6MMGF4cZzTLB/PaxAArv2CTlj80hbO
         /8tQ==
X-Gm-Message-State: AGi0PuZr83VqhAxFePuClsR22IlgNhyKiqoCi1WTECCea/KbbnzzFtFP
        0+vlr5fxAsSQdCXduomwOYH8arlbPO6tQYHNYHvFY0VjOmo=
X-Google-Smtp-Source: APiQypKu7AFy7Sh4uRg6IER4gzfuMg/pjq+I0e32wubJA3/RSNf+529KQEgbm1qY7F3SjocOksJPHma9K3ZifK/O1xg=
X-Received: by 2002:a2e:700a:: with SMTP id l10mr2509856ljc.88.1587652953976;
 Thu, 23 Apr 2020 07:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200420162748.GA43918@dontpanic> <2e16eecf-9866-9730-ee06-c7d38ac85aa4@kernel.dk>
In-Reply-To: <2e16eecf-9866-9730-ee06-c7d38ac85aa4@kernel.dk>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Thu, 23 Apr 2020 16:42:21 +0200
Message-ID: <CAJ75kXY1VLoqab4quz8RykbFrbXNJVBSAf7jv4t+u0_OquE1cQ@mail.gmail.com>
Subject: Re: io_uring_peek_cqe and EAGAIN
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens,

Thank you for your answer on this newbie question :)

On Wed, Apr 22, 2020 at 10:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> I don't think the change is correct. That's not saying that the original
> code is necessarily correct, though! Basically there are two cases there:
>
> 1) We haven't gotten a completion yet, we'll wait for it.
> 2) We already found at least one completion. We don't want
>    to _wait_ for more, but we can peek and see if there are more.
>
> Hence we don't want to turn case 2 into a loop, we should just
> continue.

ok so in fact I think I understand that my usage is incorrect:
1- if I'm in the case of being able to do other things while waiting
for data available using `io_uring_peek_cqe`, I should use it and come
back later when getting a -EAGAIN.
2- it is useless to do a loop on `io_uring_peek_cqe` because in that
case, I should simply do a `io_uring_wait_cqe`

is that correct?

> How is it currently failing for you?

While trying to open/read/close multiple files, I first thought that,
because I had one successful `io_uring_wait_cqe`, I could then loop on
`io_uring_peek_cqe` and get all my data. I now realise my assumption
was completely wrong and this example was just written that way to
show two different possibilities of getting results.
-- 
William
