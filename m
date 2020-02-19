Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6B8164FCE
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 21:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBSU0D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 15:26:03 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:37987 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSU0C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 15:26:02 -0500
Received: by mail-lj1-f171.google.com with SMTP id w1so1776504ljh.5
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 12:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sSeSv9Ta3azYnaa/hxYcKm0Odfpz8e7vzCbMdEJlpF8=;
        b=JigswocXGqJagSxPS15VF0LR+xo7xLrV6bD0k1VU1eRFxJqcwaMLLMx6a4MAPSG0kj
         mVjn7UIXs0fSISSjGaBvqpI3Fajp/jvfc+CZYuTlM8zOUTFod84PTihI8fcspbGgYjNr
         kEdbWF5z8ri65Z5X/J8l3ctkudfkaeyTOLSLozLJ1UtaQMq/mipyNkuzXh2y49Py+YPd
         7OhfHZZS87DWvGXlgHYHrVIA+9WxNu0h1kPiU5kfrHzTCQgcVGwXyg/GgoQeuBv4cEXK
         PLmLHfAslb0MxafJAO7oexiAmOhDEX4LVptP+1RkGjfx6dS14Li1vAiApYmTMkZ9dW10
         yw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sSeSv9Ta3azYnaa/hxYcKm0Odfpz8e7vzCbMdEJlpF8=;
        b=gx8Iig6k/DZ6/MOG1Uuarh/3/t+ZMrdnxZCFSdUqBtvDvO+Wc1a5ykqK+hwOq4eGWA
         kfbTlrDCtOqS9k6McsccitqZnNS3b1dW4SIdqRPicKLzpGKBnX36+Mn34dDK+S42qD5+
         WD3EsLX72qJqfEH15f/d6li4WaDHgZNsXPtDeaE1419cM4ikZqqqWQKuQ/hFmh9f7/eP
         AZn03fhK+Wf22eoaCfQrjvU+hZYaTFMJV2jjq3J/xTyAzztqU7R5/xWcs7dItDkBx9PZ
         2IDec/uW/qaVClcTBws4gPQAFZekmf4pEbxZc/Z/PyJ3EY91PQtxSm/FU5jpsOAOghm3
         G9jQ==
X-Gm-Message-State: APjAAAWnhTlmzqDdG7ncF0sgHC+d0pxMh+Wjba8NNqxVGH6dDZwxsf8b
        HQbUGE3JWz+SMiLqeXye72IKm85/OlBYRlvFJ5F2VbV976aiYg==
X-Google-Smtp-Source: APXvYqwsrkwUn+bh0EvuHUVSWZPfgqzELxtMBOqJCX/wGjGaEjZPr/TORfKceD6BHg47sF+JcPURGu6+7YlsU+986VA=
X-Received: by 2002:a2e:3514:: with SMTP id z20mr16558168ljz.261.1582143959259;
 Wed, 19 Feb 2020 12:25:59 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk> <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
 <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
In-Reply-To: <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Wed, 19 Feb 2020 15:25:48 -0500
Message-ID: <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
Subject: Re: crash on accept
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 19, 2020 at 3:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/19/20 1:11 PM, Glauber Costa wrote:
> > On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2/19/20 9:23 AM, Glauber Costa wrote:
> >>> Hi,
> >>>
> >>> I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
> >>
> >> Thanks for testing the new stuff! As always, would really appreciate a
> >> test case that I can run, makes my job so much easier.
> >
> > Trigger warning:
> > It's in C++.
>
> As long as it reproduces, I don't really have to look at it :-)

Instructions:
1. clone https://github.com/glommer/seastar.git, branch uring-accept-crash
2. git submodule update --recursive --init, because we have a shit-ton
of submodules because why not.
3. install all dependencies with ./install-dependencies.sh
    note: that does not install liburing yet, you need to have at
least 0.4 (I trust you do), with the patch I just sent to add the fast
poll flag. It still fails sometimes in my system if liburing is
installed in /usr/lib instead of /usr/lib64 because cmake is made by
the devil.
3. ./configure.py --mode=release
4. ninja -C build/release tests/unit/unix_domain_test
5. crash your system (hopefully) by executing
./build/release/tests/unit/unix_domain_test -- -c1
--reactor-backend=uring


>
> > I am finishing refactoring some of my code now. It's nothing
> > substantial so I am positive it will hit again. Once I re-reproduce
> > I'll send you instructions.
> >
> > Reading the code it's not obvious to me how it happens, so it'll be
> > harder for me to cook up a simple C reproducer ATM.
>
> I'll look here as well, as time permits.
>
>
> --
> Jens Axboe
>
