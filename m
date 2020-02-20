Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F931664EC
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 18:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgBTRdN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 12:33:13 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:45983 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbgBTRdN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 12:33:13 -0500
Received: by mail-qv1-f68.google.com with SMTP id l14so2247236qvu.12
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 09:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVcoJA5RTYNWkaeT0cf9x/vASdt6eCdl2mVwmgezWm0=;
        b=lAnYye/mXNH+iX4SCX+yOJ3wAvMWb23g/3hWKo93DOpktZmk5IqQxY4EvHnT9aSZ7U
         uYsvtd+X01ov/PkWViyYXKkyjZZ88ykSA1P+DUe/1G+ADTRZXF1KSaP5e0nYZ06m9Lju
         iJsPdelM6xBwjICaOHxSeeivrD+aguXG3z2Sl9UdL+VJrbXWAKIfUStO/d36TUxa7AoA
         F/i7YxFfeoaL03VSV+F/Z3ddxXr26UyN/1uhIm06MHl0AdfpIUGEgYIU8Cqfcv9+fhWc
         xIhcd93pDjlAls8CDFUGbxaDgAecDN2UdmWM4kRxZD5g4/Ci0tcTuO4Vt4JB5h9Opm5e
         JkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVcoJA5RTYNWkaeT0cf9x/vASdt6eCdl2mVwmgezWm0=;
        b=TIrmuKFOEoydSQ80rIqggG/Dw1S4SzWLIPblepf81jhc8x0J7DXfuw60zt9IT2pT8q
         8+ZtA1fGkopBCJ4iUjgd/EOwfuOuK0zjVWtjjnGUvOBhaVtnE+/OzgxSDaOUKBYSJfSv
         RaN4qNz6rBZ8bGvVaaSp+FpwWkLO1byOKyf98Q/++qxWtzNYVD+BJCP62Vi6bLUb60d0
         Mp3DJZJqxDxBH+Wj6TnTIX/MIQ5Drk/Bt6m5fE8feJwp8zMBIAnd424URd7V6QQd/aGF
         kx3yHztEgiLcT2NXByH6NBgkg5JcstcssALBYdtiSTiyI6St1QzrGZ7knKYZwv28EjsJ
         mnqw==
X-Gm-Message-State: APjAAAXJV0nnS7LJrE2uOj3y4z6w0po8zxFxvNUX2O1f1E+tBgIv+WUv
        7Ig5pAIKUHrIM1xQU4fMcQ9M8ZmvrtIbSJDpqp5zfk/FHB4=
X-Google-Smtp-Source: APXvYqyaOU2qZWdgf122ifeUZy3+B388FzeZCwIuE5lAXNOAuiInkdb05vQx2kaEFDD2thjHzFYdfUP2U0CrNDP0YKg=
X-Received: by 2002:a0c:e1cd:: with SMTP id v13mr25784106qvl.115.1582219992685;
 Thu, 20 Feb 2020 09:33:12 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk> <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
 <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk> <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
 <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk>
In-Reply-To: <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Thu, 20 Feb 2020 12:33:01 -0500
Message-ID: <CAD-J=zbO__XOVd+xX2Xr0UOL=wO5VHqAfXDCmqeDafE6BJYMyw@mail.gmail.com>
Subject: Re: crash on connect
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 12:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/20/20 9:52 AM, Glauber Costa wrote:
> > On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2/20/20 9:34 AM, Glauber Costa wrote:
> >>> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 2/20/20 9:17 AM, Jens Axboe wrote:
> >>>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
> >>>>>> Hi there, me again
> >>>>>>
> >>>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
> >>>>>>
> >>>>>> This test is easier to explain: it essentially issues a connect and a
> >>>>>> shutdown right away.
> >>>>>>
> >>>>>> It currently fails due to no fault of io_uring. But every now and then
> >>>>>> it crashes (you may have to run more than once to get it to crash)
> >>>>>>
> >>>>>> Instructions are similar to my last test.
> >>>>>> Except the test to build is now "tests/unit/connect_test"
> >>>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
> >>>>>>
> >>>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
> >>>>>> --reactor-backend=uring
> >>>>>>
> >>>>>> Backtrace attached
> >>>>>
> >>>>> Perfect thanks, I'll take a look!
> >>>>
> >>>> Haven't managed to crash it yet, but every run complains:
> >>>>
> >>>> got to shutdown of 10 with refcnt: 2
> >>>> Refs being all dropped, calling forget for 10
> >>>> terminate called after throwing an instance of 'fmt::v6::format_error'
> >>>>   what():  argument index out of range
> >>>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
> >>>>
> >>>> Not sure if that's causing it not to fail here.
> >>>
> >>> Ok, that means it "passed". (I was in the process of figuring out
> >>> where I got this wrong when I started seeing the crashes)
> >>
> >> Can you do, in your kernel dir:
> >>
> >> $ gdb vmlinux
> >> [...]
> >> (gdb) l *__io_queue_sqe+0x4a
> >>
> >> and see what it says?
> >
> > 0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
> > 4809 struct io_kiocb *linked_timeout;
> > 4810 struct io_kiocb *nxt = NULL;
> > 4811 int ret;
> > 4812
> > 4813 again:
> > 4814 linked_timeout = io_prep_linked_timeout(req);
> > 4815
> > 4816 ret = io_issue_sqe(req, sqe, &nxt, true);
> > 4817
> > 4818 /*
> >
> > (I am not using timeouts, just async_cancel)
>
> Can't seem to hit it here, went through thousands of iterations...
> I'll keep trying.
>
> If you have time, you can try and enable CONFIG_KASAN=y and see if
> you can hit it with that.

sure thing. will let you know

>
> --
> Jens Axboe
>
