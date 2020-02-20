Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B89E166744
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 20:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgBTTg2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 14:36:28 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39681 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgBTTg2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 14:36:28 -0500
Received: by mail-lj1-f193.google.com with SMTP id o15so5469505ljg.6
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 11:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNo3JlEcKHOF3x+YXHYCcVdK8JgpF7fHsnX7wwUfA2c=;
        b=G7A7a16z1/E7g02BRxg6QU2r32tW6hUogcp6wiiRCC26aA/ubWY5laF5bf7s+ibZkB
         Oui+CDOptU9UT9Mneh2TpkP0LPI/F+Yp9EAzQA77aY3D1Bn1cGJdkAHkveaSJmyGXxWa
         ArU2OxuAK0lfMprfkoBXdGNxAmTpa9GvN3klGhuYU6VZCbI+3mbjCSi69wiszyrLEtNo
         2msTrFjLlhwqeeOXJUJyML7Q5UynouD1vpXBDBCG3z/EhlEOznOx4XoKeTZ5xvuciZ7t
         c34rmOFzyks0z19VKfRCNFoc7zjZ6UdfCGw1IZG3yFB1MVs16R8kbxdGjgAsheMmlyoj
         aQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eNo3JlEcKHOF3x+YXHYCcVdK8JgpF7fHsnX7wwUfA2c=;
        b=oF5BYxPdClRUo9dsUy+eL75x/LOe+3uIoabsNcdwyfkNAhFfhJjEkiMImHptIHNb3C
         YY7qefWhOTqSro/vzFU+VB7cJsY+f+vKM5LQFB31h55aR4eArwKigqm2JGijw7nsolR9
         x4vdSCvqYdvFWDH7limHGXCdqgznDkJ0uM2pYvdkLuS89+LEiRVFsTNRC+dp86yTtmfk
         Q77sdLORorqLRytGwW4ZhjDEaFilMF1yy9jtByQLzyFHay1CupwQAzt1fZyFA60SW/Zk
         b7RNaxHJkkkiasaYUaqYMmxO+ciVEc6w/co6rbi6nIIA44Lfz53koYm2Hk3IMBKqZWGk
         XeDA==
X-Gm-Message-State: APjAAAWdqRYB5Lg6EaxQASyZtxRk+SixZa38fNPHMPCJG4DmF6+2yhkv
        JmRrBc8f0hOB9fmQYDYFbPOqL28jCPIbqqk6K8OhTw==
X-Google-Smtp-Source: APXvYqwZTULF+WxGGhrASlq9yAVhZMGBEgMdMfrtFPVpDJ7gSt+CLJfbHexo4k9jGFNst1Y3i+ryhgtPwJKBprJ32js=
X-Received: by 2002:a2e:3514:: with SMTP id z20mr19470868ljz.261.1582227385779;
 Thu, 20 Feb 2020 11:36:25 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk> <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
 <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk> <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
 <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk> <CAD-J=zbdrZJ2nKgH3Ob=QAAM9Ci439T9DduNxvetK9B_52LDOQ@mail.gmail.com>
 <2be9d30f-bbca-7aa6-3d8c-34e3fcf71067@kernel.dk> <CAD-J=zYKg7TZz2jz9O7eWH1gYkYbQV3-smb-XFOmWnp30cC_sQ@mail.gmail.com>
In-Reply-To: <CAD-J=zYKg7TZz2jz9O7eWH1gYkYbQV3-smb-XFOmWnp30cC_sQ@mail.gmail.com>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Thu, 20 Feb 2020 14:36:14 -0500
Message-ID: <CAD-J=zYKcp_NMVC8K3bzen-hcGMN-OuYqMNtD1E8tEyqPhwGMA@mail.gmail.com>
Subject: Re: crash on connect
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 2:19 PM Glauber Costa <glauber@scylladb.com> wrote:
>
> On Thu, Feb 20, 2020 at 2:12 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 2/20/20 11:45 AM, Glauber Costa wrote:
> > > On Thu, Feb 20, 2020 at 12:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> On 2/20/20 9:52 AM, Glauber Costa wrote:
> > >>> On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>>
> > >>>> On 2/20/20 9:34 AM, Glauber Costa wrote:
> > >>>>> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>>>>
> > >>>>>> On 2/20/20 9:17 AM, Jens Axboe wrote:
> > >>>>>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
> > >>>>>>>> Hi there, me again
> > >>>>>>>>
> > >>>>>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
> > >>>>>>>>
> > >>>>>>>> This test is easier to explain: it essentially issues a connect and a
> > >>>>>>>> shutdown right away.
> > >>>>>>>>
> > >>>>>>>> It currently fails due to no fault of io_uring. But every now and then
> > >>>>>>>> it crashes (you may have to run more than once to get it to crash)
> > >>>>>>>>
> > >>>>>>>> Instructions are similar to my last test.
> > >>>>>>>> Except the test to build is now "tests/unit/connect_test"
> > >>>>>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
> > >>>>>>>>
> > >>>>>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
> > >>>>>>>> --reactor-backend=uring
> > >>>>>>>>
> > >>>>>>>> Backtrace attached
> > >>>>>>>
> > >>>>>>> Perfect thanks, I'll take a look!
> > >>>>>>
> > >>>>>> Haven't managed to crash it yet, but every run complains:
> > >>>>>>
> > >>>>>> got to shutdown of 10 with refcnt: 2
> > >>>>>> Refs being all dropped, calling forget for 10
> > >>>>>> terminate called after throwing an instance of 'fmt::v6::format_error'
> > >>>>>>   what():  argument index out of range
> > >>>>>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
> > >>>>>>
> > >>>>>> Not sure if that's causing it not to fail here.
> > >>>>>
> > >>>>> Ok, that means it "passed". (I was in the process of figuring out
> > >>>>> where I got this wrong when I started seeing the crashes)
> > >>>>
> > >>>> Can you do, in your kernel dir:
> > >>>>
> > >>>> $ gdb vmlinux
> > >>>> [...]
> > >>>> (gdb) l *__io_queue_sqe+0x4a
> > >>>>
> > >>>> and see what it says?
> > >>>
> > >>> 0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
> > >>> 4809 struct io_kiocb *linked_timeout;
> > >>> 4810 struct io_kiocb *nxt = NULL;
> > >>> 4811 int ret;
> > >>> 4812
> > >>> 4813 again:
> > >>> 4814 linked_timeout = io_prep_linked_timeout(req);
> > >>> 4815
> > >>> 4816 ret = io_issue_sqe(req, sqe, &nxt, true);
> > >>> 4817
> > >>> 4818 /*
> > >>>
> > >>> (I am not using timeouts, just async_cancel)
> > >>
> > >> Can't seem to hit it here, went through thousands of iterations...
> > >> I'll keep trying.
> > >>
> > >> If you have time, you can try and enable CONFIG_KASAN=y and see if
> > >> you can hit it with that.
> > >
> > > I can
> > >
> > > Attaching full dmesg
> >
> > Can you try the latest? It's sha d8154e605f84.

10 runs, no crashes.

Thanks!

>> Before you do, can you
> > do the lookup on __io_queue_sqe+0x639 with gdb?
>
> Moving to that hash now. In the meantime, so I don't delay your fun:
>
> ) l *__io_queue_sqe+0x639
> 0xffffffff81566c19 is in __io_queue_sqe (./include/linux/compiler.h:226).
> 221 {
> 222 switch (size) {
> 223 case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
> 224 case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
> 225 case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
> 226 case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
> 227 default:
> 228 barrier();
> 229 __builtin_memcpy((void *)p, (const void *)res, size);
> 230 barrier();
>
>
> >
> > --
> > Jens Axboe
> >
