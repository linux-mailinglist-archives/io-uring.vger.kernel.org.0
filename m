Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E8B165542
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 03:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBTCwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 21:52:37 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:46803 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTCwh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 21:52:37 -0500
Received: by mail-lj1-f179.google.com with SMTP id x14so2527442ljd.13
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 18:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sp7RcpzxdlA/+BS+a82tmktRCmWRhiLczuAlDTuygRc=;
        b=sZICapM197OfM48piUh92LF4gurZGmot7MAZXjSagK2L2dDKLvp0ytlvSA65ODI0ry
         kv8E1kR/d7nBFvEV/OtYjuZiEHhsHJTUw6s8QvHhvPPNDlajQ6VOecVvsg7djfFefY4H
         bFFZbb/fRl0si9jOjMcMEc/QQhykRs1BsGhJdmrgzD+uauc99URO9si6uS6KEAlhlR/r
         eMhHqPQWiwQhsCXp0OKr7kkIz58DLZyDXpYrTZ+yZILBfxayRuCFuw0DbwOzrNbPtoWK
         Cw7c4kVBDfo/9gNIn5f9o0ZpOws9g5Mmbe4pS/BnRX1ColHCe7be1JvDBFKOlveKwqOM
         Pjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sp7RcpzxdlA/+BS+a82tmktRCmWRhiLczuAlDTuygRc=;
        b=aIQy8ausqJDYTGz9dJeXuLEyOZS9ESTibvCkToU3g12DIghWAvfC8sIKx2XN0qByPn
         DFgzBWLf9NYVj8K84a1eizV/L8pYlNXAfF2/71/wqCqPDiUMn+Tme+0IGvHXfvTb85Ln
         iJk+xQz/h53pxv+hHsz5DFMxSDSSe1K0h4SG6gfnEzg1xbYqPmlzq6aCpyQ6uVDo8YPD
         0w0NlTsUobMRmXXoJqwCnD72cwziChcXn42mbSoRPG3U9LJJwtuucrgfg7z9+mUCmIH0
         ULLh2+RQ8WBHLlcO9YYjymxfMmrEW1us15AL3IUWEUSj9heB7mbpDtf1mUWW2B89agj6
         imfw==
X-Gm-Message-State: APjAAAX7yJeY75mdFTvvl8Po+U5Pep2XK9lpwv0OpjuCvycjt8nFbwFP
        FbWfVvB7B6Fz290KBViCrW5CbeqCprD1xfRp/2C64vsD0Ng=
X-Google-Smtp-Source: APXvYqw5Tt4mun40K3ig5jXGEKDzBRSTz1qIG8IAGrokWXhzr3FL7RL9C9V45IKAbcYezBs/BVMtGKEeMH5zjhv4il8=
X-Received: by 2002:a2e:99c5:: with SMTP id l5mr16975729ljj.88.1582167153339;
 Wed, 19 Feb 2020 18:52:33 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk> <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
 <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk> <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
 <fba5b599-3e07-5e35-3d44-3018be19309f@scylladb.com> <20ab3016-9964-9811-c5b9-be848f072764@kernel.dk>
 <3e5c6df3-c4ab-1cd5-5bb1-e1a5d44180ad@kernel.dk>
In-Reply-To: <3e5c6df3-c4ab-1cd5-5bb1-e1a5d44180ad@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Wed, 19 Feb 2020 21:52:20 -0500
Message-ID: <CAD-J=zYcT6VSGhu81e=UJ3SrjfuPJLF9qB5T176OhZjfEpS26g@mail.gmail.com>
Subject: Re: crash on accept
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I don't see a crash now, thanks.

I can now go back to trying to figure out why the test is just hanging
forever, as I was doing earlier =)
(99.9% I broke something with the last rework).

Out of curiosity, as it may help me with the above: I notice you
didn't add a patch on top, but rather rebased the tree.

What was the problem leading to the crash ?

On Wed, Feb 19, 2020 at 8:37 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/19/20 4:09 PM, Jens Axboe wrote:
> > On 2/19/20 1:29 PM, Avi Kivity wrote:
> >> On 2/19/20 10:25 PM, Glauber Costa wrote:
> >>> On Wed, Feb 19, 2020 at 3:13 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 2/19/20 1:11 PM, Glauber Costa wrote:
> >>>>> On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>> On 2/19/20 9:23 AM, Glauber Costa wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
> >>>>>> Thanks for testing the new stuff! As always, would really appreciate a
> >>>>>> test case that I can run, makes my job so much easier.
> >>>>> Trigger warning:
> >>>>> It's in C++.
> >>>> As long as it reproduces, I don't really have to look at it :-)
> >>> Instructions:
> >>> 1. clone https://github.com/glommer/seastar.git, branch uring-accept-crash
> >>> 2. git submodule update --recursive --init, because we have a shit-ton
> >>> of submodules because why not.
> >>
> >>
> >> Actually, seastar has only one submodule (dpdk) and it is optional, so
> >> you need not clone it.
> >>
> >>
> >>> 3. install all dependencies with ./install-dependencies.sh
> >>>      note: that does not install liburing yet, you need to have at
> >>> least 0.4 (I trust you do), with the patch I just sent to add the fast
> >>> poll flag. It still fails sometimes in my system if liburing is
> >>> installed in /usr/lib instead of /usr/lib64 because cmake is made by
> >>> the devil.
> >>> 3. ./configure.py --mode=release
> >>
> >>
> >> --mode dev will compile many times faster
> >>
> >>
> >>> 4. ninja -C build/release tests/unit/unix_domain_test
> >>> 5. crash your system (hopefully) by executing
> >>> ./build/release/tests/unit/unix_domain_test -- -c1
> >>> --reactor-backend=uring
> >>>
> >> s/release/dev/ in steps 4, 5 if you use dev mode.
> >
> > Thanks, this is great, I can reproduce!
>
> Can you try the current branch? Should be 77aac7e7738 (or newer).
>
> --
> Jens Axboe
>
