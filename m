Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063DE32F4CC
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 21:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbhCEUyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 15:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhCEUyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 15:54:23 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A55C06175F
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 12:54:22 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m22so5870740lfg.5
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 12:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZP4hyboKl3heE24qyYr3BH6vy2xp/uei9rYx0xHCAvE=;
        b=EapOfQYqO9x7CBSqb/pSTa3wTO+EOLj7cjCF/pssByNxERV34/kjhZYh73tPVFvf2A
         3UA1sJL4XHqqqf6koCyyNiEgXKZHe7t6jKsL8I/YoFakvWvBVz4/WqvbDRZzZkuO+OoI
         +CkCgG73HpLRyZepLnbJBxaU2gdKXfO1XQUns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZP4hyboKl3heE24qyYr3BH6vy2xp/uei9rYx0xHCAvE=;
        b=A7bV9fNzYn0FUrBxihm23sPXsSCHQjD4tC4Q/r9kKJRHcyQAsMpSQlo1Dbf9BLeNg3
         d6hdjaG0XHxg8O6HDzYmv5QMQ+Qnsgz0MxcLr4BLHE9dIruCHmoHLuIRVmIUb98B9RYk
         Av5xq49yzc94yn6STD/3XRmcXL2wsJhiaDtuxh8KepIy9c5r+Zz1PASADJ5tz8qSNV22
         vnFdkcYow1WRqii1qZyduoKorWd4goKD+/R4FiWwJPO3nUPfR2JNQ4nfdba+CkI8p4Xb
         CGnSx/Qs219Oaa/N+gAFH9x7jV56mFtJa6nTYTwwECuQV6M8Ftm+6KndjhU4Q9NSY8eh
         4FZw==
X-Gm-Message-State: AOAM530OM7PJseOqOm0MjtJY+PN/P0Hk+VJnEAd/LZhKLQeTFS5EokTG
        g1BQQlwbk1cySjnp9s+VWAwvWYl3kPaIDw==
X-Google-Smtp-Source: ABdhPJwOa2Mwdy/di3kRmkhe/tzDz+h3p1GxZyQeurqmpNT+3RZCTiBoAINaFmAJTmKMiHgJdkQTlw==
X-Received: by 2002:a19:44:: with SMTP id 65mr6987372lfa.104.1614977660968;
        Fri, 05 Mar 2021 12:54:20 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id r16sm434111lfr.223.2021.03.05.12.54.19
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 12:54:19 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id z11so5840669lfb.9
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 12:54:19 -0800 (PST)
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr6493237lfu.41.1614977659404;
 Fri, 05 Mar 2021 12:54:19 -0800 (PST)
MIME-Version: 1.0
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
In-Reply-To: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Mar 2021 12:54:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
Message-ID: <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 5, 2021 at 10:09 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> - Implement unshare. Used for when the original task does unshare(2) or
>   setuid/seteuid and friends, drops the original workers and forks new
>   ones.

This explanation makes no sense to me, and I don't see any commit that
would remotely do what I parse that as doing.

I left it in the merge message, but would like you to explain what you
actually meant...

                Linus
