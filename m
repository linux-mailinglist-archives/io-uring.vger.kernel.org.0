Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AFB166389
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 17:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgBTQws (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 11:52:48 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35610 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbgBTQwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 11:52:47 -0500
Received: by mail-lf1-f67.google.com with SMTP id l16so3670325lfg.2
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 08:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFeoybdgDY6YBJotI3ElL7gA5fSiwZMwTBuv2BBlYAs=;
        b=pR3GolRomLr03Y1M/h6g7vZP/ALd+yIahB8AKdWrPJCY1x8tqrdVIS6WcHLsnbVJrx
         C5w8cWATfppEjftzmfrCaQ0ZPSKbtkvZgvzmL5xg24gHhsupMJN6P2mwDeA1Z6Ziz3Hq
         HRVzsIxjfiA4Ah+In3XD2IVw314sIs/BvcmMTId2EL03Tmgfh0pXRqELfXqo1wWo5/B3
         tCIpLCk72uxng9iwgRfOBl0EUGpyqUDAKIco8s9WamiC7sNeMkRRzEa7Ij0FS3uTggXN
         0gnWSUH9jG/qc3T7SbTilgIIO0rwR14jnq7uSaG7qpItMs6kC9mgfIFal4NDwFnfzb25
         7HFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFeoybdgDY6YBJotI3ElL7gA5fSiwZMwTBuv2BBlYAs=;
        b=g48S4M0K1DV1r3yfKfHCCfKMcUPDXtwREHkyHhvnOI7zwo2En8tw+q4ZIU4zu0691E
         tiNV3rRPZS3e6mX5KzvR03IByQcy2SOIfJpeFhTdD5ZdA6lki0xIrn1g4AMABf8MCLyI
         O2F4YKCADAR4usfQYXiGXmKYIkKUWoYhtbwESRnxietKAifqqhyYr3gWyH0/2HQ8kDuR
         HRf/a9C3uDAJtq2Xe7zs1Fr73BctE7t+InXq5tM5zDG9oogU57iRSsexAoDEHuYUPAM4
         KEXA501kVQdnXOBtQciE9utQjpArY4cX7/nCnLZSGlbr0dBfGoeZSsZzC/S3gDRR8LxX
         nOxg==
X-Gm-Message-State: APjAAAXsv0VPm148gq1VsA5UnvVP1ZzhcBNScO4V2gTNDIps7/Oa/TAQ
        cC26+j+8yj6D28cIrMRPHrAlpECWKURp0RAuEqbrs2whnNJ3rw==
X-Google-Smtp-Source: APXvYqyRjuAcde/sEt6Le6KFEip+I77ur93K3q2sUdv1Tx1DgcmHWVQOcBLV6ZBlgHipyu+7ECjWm/5lchDyZSgcBkc=
X-Received: by 2002:ac2:5b0c:: with SMTP id v12mr17181317lfn.155.1582217566049;
 Thu, 20 Feb 2020 08:52:46 -0800 (PST)
MIME-Version: 1.0
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk> <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com> <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk>
In-Reply-To: <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk>
From:   Glauber Costa <glauber@scylladb.com>
Date:   Thu, 20 Feb 2020 11:52:34 -0500
Message-ID: <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
Subject: Re: crash on connect
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/20/20 9:34 AM, Glauber Costa wrote:
> > On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2/20/20 9:17 AM, Jens Axboe wrote:
> >>> On 2/20/20 7:19 AM, Glauber Costa wrote:
> >>>> Hi there, me again
> >>>>
> >>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
> >>>>
> >>>> This test is easier to explain: it essentially issues a connect and a
> >>>> shutdown right away.
> >>>>
> >>>> It currently fails due to no fault of io_uring. But every now and then
> >>>> it crashes (you may have to run more than once to get it to crash)
> >>>>
> >>>> Instructions are similar to my last test.
> >>>> Except the test to build is now "tests/unit/connect_test"
> >>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
> >>>>
> >>>> Run it with ./build/release/tests/unit/connect_test -- -c1
> >>>> --reactor-backend=uring
> >>>>
> >>>> Backtrace attached
> >>>
> >>> Perfect thanks, I'll take a look!
> >>
> >> Haven't managed to crash it yet, but every run complains:
> >>
> >> got to shutdown of 10 with refcnt: 2
> >> Refs being all dropped, calling forget for 10
> >> terminate called after throwing an instance of 'fmt::v6::format_error'
> >>   what():  argument index out of range
> >> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
> >>
> >> Not sure if that's causing it not to fail here.
> >
> > Ok, that means it "passed". (I was in the process of figuring out
> > where I got this wrong when I started seeing the crashes)
>
> Can you do, in your kernel dir:
>
> $ gdb vmlinux
> [...]
> (gdb) l *__io_queue_sqe+0x4a
>
> and see what it says?

0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
4809 struct io_kiocb *linked_timeout;
4810 struct io_kiocb *nxt = NULL;
4811 int ret;
4812
4813 again:
4814 linked_timeout = io_prep_linked_timeout(req);
4815
4816 ret = io_issue_sqe(req, sqe, &nxt, true);
4817
4818 /*

(I am not using timeouts, just async_cancel)
>
> --
> Jens Axboe
>
