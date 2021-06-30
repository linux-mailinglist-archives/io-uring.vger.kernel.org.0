Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DBC3B89A4
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhF3UVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhF3UVa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:21:30 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056DFC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:19:00 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bu19so7412726lfb.9
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uHCeNsWSpVWECrUi4Y/xqmo8wXTCMTkmLJbaCr3ZP4=;
        b=c+9SisOgxve77SCTD8wDP1XQlimGlwrqbzIth0TQ9nUGQ13OnSr5DTJ9SBwNyXtoSM
         WkGJ8uBAgc3dTuKsqSCZugu0zXrw/GhWX/xoXxqob1qrzhZgezaWUENc0axWV4ze+YP7
         TTgT0SyjbqYxKuNnzmAtp8k5ZVZx1H/PW1wic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uHCeNsWSpVWECrUi4Y/xqmo8wXTCMTkmLJbaCr3ZP4=;
        b=fRDYH38DPtwEFAEvt/o5YVQS060sdtLe4H6G64mUKa/KqumHIg15N7yQSBo+Iq84Sf
         X8T8YHnZJuYTGyCtj6+g1KEBmMtDYR2sOhgC4or0u0kQIND8M7rvpWaHimRRau0z9yUo
         T2WqYGnV6Dw9oXyCjGK6OWRJropPg8Xvx8Ff9D66tCX+IWtoEktxrOZHY4+KWjxnJ7Ex
         +upXjCG510VAnOUramP8pylwm5EdS6EqNgVEcp/N4xRHHVFVkHLCjoMVeF0wHSPduBg+
         v2NoNwJy8DPvUxC7UsZy0aQnIOFHV2wR8Asn6FYFHHo0Im5b3gEzVxyU8tDp+tp/mkdF
         6JEg==
X-Gm-Message-State: AOAM532m0WmncLWJ7bRy4XVFplWPR1tx3MyCsG952q/rE9wwLcAqnEfT
        b9D4Ps6asOh+XoN3GKeMPEQRp4cW+9cGcVxsiWQ=
X-Google-Smtp-Source: ABdhPJyMxeKRoYy2DMgnpfhSpVb4EEwXCl47SzuuXyEaYtUQjRqon93hos8HBDcXiEbjcxFJ8ARIhg==
X-Received: by 2002:a19:f505:: with SMTP id j5mr29375355lfb.126.1625084338054;
        Wed, 30 Jun 2021 13:18:58 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id q66sm2361988ljb.83.2021.06.30.13.18.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:18:57 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id c11so5036353ljd.6
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:18:57 -0700 (PDT)
X-Received: by 2002:a2e:9c58:: with SMTP id t24mr8974575ljj.411.1625084337277;
 Wed, 30 Jun 2021 13:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com> <00f21ea0-2f38-f554-63e9-ef07e806a0cd@kernel.dk>
In-Reply-To: <00f21ea0-2f38-f554-63e9-ef07e806a0cd@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Jun 2021 13:18:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi9TATc=n-zrGfkEPcr7+wXx8PHe7z9-TeOmJPbisss+Q@mail.gmail.com>
Message-ID: <CAHk-=wi9TATc=n-zrGfkEPcr7+wXx8PHe7z9-TeOmJPbisss+Q@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 30, 2021 at 1:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> I think you're being very unfair here, last release was pretty
> uneventful, and of course 5.12 was a bit too exciting with the
> thread changes, but that was both expected and a necessary evil.

The last one may have been uneventful, but I really want to keep it that way.

And the threading changes were an improvement overall, but they were
by no means the first time io_uring was flaky and had issues. It has
caused a _lot_ of churn over the years.

And I refuse to have that churn now affect fs/namei.c

This had better be done right, or not at all.

                 Linus
