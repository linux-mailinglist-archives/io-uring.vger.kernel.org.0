Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AA8166707
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 20:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgBTTT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 14:19:26 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37623 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgBTTT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 14:19:26 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so4029382lfc.4
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 11:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YU89lMzGxcIbzKPaTKsE3gO8ptwbYaLmoaVYf2yXe5I=;
        b=ISSxbMwYaqCaB14tKUi0Voc0ctqhXFnln3hLZifvyDguawjuR22it2+uaWNDLeIcex
         dGFOYXBEFaS5cEVRcSu2KWclrFZmJi99gVgOHeJXJfMWiMHajUsO/LIVceOvJtnOGJCm
         2g2Lm/9pzojTuRjeg8kg41MiIEP/JemODd/DPVLo695GV75MYbn6FDHd8ruE3kK+wNdL
         B1gaDypdjxJCLIQkmLhJE40XUjOgjsIML4YfwWxgWSEM90TrlfDMtNFyHFdKFY3u8r8a
         ftSE0T9iLqxAUVyiVYbHNd4DAKYnK2zRgHqoJyDuDPipqG4MUYvzNxUmRzp055qdEJPb
         yQcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YU89lMzGxcIbzKPaTKsE3gO8ptwbYaLmoaVYf2yXe5I=;
        b=l/vIENFKnEyadybYk6hJqPKhr1YXZSCCm/+mJ3m3MADHzBeNCRPtknI+SynW279oDR
         5p8IUHgrk7XMPZLgO0hvuFyE/Rh7zB4WTn2VkvJN/k/+RkrLeCQB/6NpiO6X77v+h9r5
         i9H5SpkrJklS1bgMR7faHywInPqbviXjG2KMxkKCvRWm8QSIyT43lJ/O0uPie64m4sQg
         kMRPzlLbjp7ETaiOhEV2qQHBVmCxJZtXQ+0KVTYraPYGu4SlFz2f2+X/kxQcjlUmAVip
         huDdg5YAwxVsXZ7ZOsOm3VMDveHosJUUnBq+XTffQ+H2poxil6wZK60hEdMgfSQm+aOz
         zBPA==
X-Gm-Message-State: APjAAAWw76vRJ+neo6CSs/lQLfqbZk67icew7sBaRfFZ6inNVxzNCMPC
        U7qnJfJaYiB8SS+nmt8JrGWxX808x2CpFPajo3Y/8Q==
X-Google-Smtp-Source: APXvYqxhRxFDonifa+3wd2sHypiCIHTqx0nxDXQehEVBnz/iG1YxE9kQ5YH1vqFpzXUCPH0V4gOKIw9Fw3CHZQzgB0A=
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr17945655lfo.10.1582226363710;
 Thu, 20 Feb 2020 11:19:23 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk> <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
 <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk> <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
 <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk> <CAD-J=zbdrZJ2nKgH3Ob=QAAM9Ci439T9DduNxvetK9B_52LDOQ@mail.gmail.com>
 <2be9d30f-bbca-7aa6-3d8c-34e3fcf71067@kernel.dk>
In-Reply-To: <2be9d30f-bbca-7aa6-3d8c-34e3fcf71067@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Thu, 20 Feb 2020 14:19:12 -0500
Message-ID: <CAD-J=zYKg7TZz2jz9O7eWH1gYkYbQV3-smb-XFOmWnp30cC_sQ@mail.gmail.com>
Subject: Re: crash on connect
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 2:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/20/20 11:45 AM, Glauber Costa wrote:
> > On Thu, Feb 20, 2020 at 12:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2/20/20 9:52 AM, Glauber Costa wrote:
> >>> On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 2/20/20 9:34 AM, Glauber Costa wrote:
> >>>>> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 2/20/20 9:17 AM, Jens Axboe wrote:
> >>>>>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
> >>>>>>>> Hi there, me again
> >>>>>>>>
> >>>>>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
> >>>>>>>>
> >>>>>>>> This test is easier to explain: it essentially issues a connect and a
> >>>>>>>> shutdown right away.
> >>>>>>>>
> >>>>>>>> It currently fails due to no fault of io_uring. But every now and then
> >>>>>>>> it crashes (you may have to run more than once to get it to crash)
> >>>>>>>>
> >>>>>>>> Instructions are similar to my last test.
> >>>>>>>> Except the test to build is now "tests/unit/connect_test"
> >>>>>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
> >>>>>>>>
> >>>>>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
> >>>>>>>> --reactor-backend=uring
> >>>>>>>>
> >>>>>>>> Backtrace attached
> >>>>>>>
> >>>>>>> Perfect thanks, I'll take a look!
> >>>>>>
> >>>>>> Haven't managed to crash it yet, but every run complains:
> >>>>>>
> >>>>>> got to shutdown of 10 with refcnt: 2
> >>>>>> Refs being all dropped, calling forget for 10
> >>>>>> terminate called after throwing an instance of 'fmt::v6::format_error'
> >>>>>>   what():  argument index out of range
> >>>>>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
> >>>>>>
> >>>>>> Not sure if that's causing it not to fail here.
> >>>>>
> >>>>> Ok, that means it "passed". (I was in the process of figuring out
> >>>>> where I got this wrong when I started seeing the crashes)
> >>>>
> >>>> Can you do, in your kernel dir:
> >>>>
> >>>> $ gdb vmlinux
> >>>> [...]
> >>>> (gdb) l *__io_queue_sqe+0x4a
> >>>>
> >>>> and see what it says?
> >>>
> >>> 0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
> >>> 4809 struct io_kiocb *linked_timeout;
> >>> 4810 struct io_kiocb *nxt = NULL;
> >>> 4811 int ret;
> >>> 4812
> >>> 4813 again:
> >>> 4814 linked_timeout = io_prep_linked_timeout(req);
> >>> 4815
> >>> 4816 ret = io_issue_sqe(req, sqe, &nxt, true);
> >>> 4817
> >>> 4818 /*
> >>>
> >>> (I am not using timeouts, just async_cancel)
> >>
> >> Can't seem to hit it here, went through thousands of iterations...
> >> I'll keep trying.
> >>
> >> If you have time, you can try and enable CONFIG_KASAN=y and see if
> >> you can hit it with that.
> >
> > I can
> >
> > Attaching full dmesg
>
> Can you try the latest? It's sha d8154e605f84. Before you do, can you
> do the lookup on __io_queue_sqe+0x639 with gdb?

Moving to that hash now. In the meantime, so I don't delay your fun:

) l *__io_queue_sqe+0x639
0xffffffff81566c19 is in __io_queue_sqe (./include/linux/compiler.h:226).
221 {
222 switch (size) {
223 case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
224 case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
225 case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
226 case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
227 default:
228 barrier();
229 __builtin_memcpy((void *)p, (const void *)res, size);
230 barrier();


>
> --
> Jens Axboe
>
