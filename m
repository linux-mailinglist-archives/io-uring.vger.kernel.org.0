Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A569145B7C
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAVSWp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 13:22:45 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36530 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSWp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 13:22:45 -0500
Received: by mail-qk1-f194.google.com with SMTP id a203so695386qkc.3
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 10:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=/d28B8yyvZAdMcA1SY8sdyiXZW+LLIU+XVej7Qh48tU=;
        b=erJ/uiZvSj0ZrgPRdm+V2UV0Ki7V8nyiGny9Xb941ajphOy2QNT5eepZ9DB8DSShiK
         Ppx6yLID0hihmkt5MwboPEP5ibzOEmFxMwLAoOHhadHVE0nBlI+myrRs9AJeQ/LC54mq
         ldahtkI4OHbB0Kugpu94KwbUbHyWUtqWRG+xaxygjL1IxDBCTb5WRL+nfX9QYIJflLv7
         q+aC+BCFiWd8eGr9qf2JFhqnwYmVMsedP74mwrXgB4qDdkmK0RMGf2BLOtqUUnKjlCO3
         /EQVGtOCO1wmOLDMFUlsg0pE8Laqt2EXrO7Mn0yMC9fcBHn3VW9TdmOIcgdx2rPle4zB
         0K3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=/d28B8yyvZAdMcA1SY8sdyiXZW+LLIU+XVej7Qh48tU=;
        b=FQI1b/LCumx4dCs4v4cQtvD7WAC5xBgPQ2TtmzaQROKl1l/B4BHXxxFI7Zd3ovGUWR
         vHWIn/Oz1jQNFiz2JqXV7fUTNgmAArFl6kKqoDujmaZTiiEOxcU7KHyJKOdW6nEnBzz8
         3DT7Kp7zDURDaXikFQXN6up1qWmjFV8F2oiDzC8G9yMB08oW1iGxg+Pyk18M/b3vxrN5
         lhGZeH3w6tJqYzm9WM41Oa2kIAN6M7Id5zdGkiM4c30NH0cWBk56GeDw86l12DDz4NVJ
         oEy3r8QaeH4RpgUrO8Aj/4+ygnkDq03P/zsXCwDIlbBJHkxprV9XR/Nz6RtX5bMb6Oo1
         Gj/Q==
X-Gm-Message-State: APjAAAXgiaBcUuWbcAjX9s3LsdOPDaVOXi1COyZH5cBt/WLuRoYKWoyU
        xXNZG+ul8U6BL34Md9yhGtg7HbIMtRVc+k3NK+jD863jaPixf2M=
X-Google-Smtp-Source: APXvYqwCXbsrTgTWggEPDfsl+wWczr+0Y7wAkdBQQgPh68ZOXS2ke3bpQrIKKzlVakywtB3G6SyJ9AQaQdxhHugl06o=
X-Received: by 2002:a05:620a:4db:: with SMTP id 27mr11920089qks.146.1579717364069;
 Wed, 22 Jan 2020 10:22:44 -0800 (PST)
MIME-Version: 1.0
References: <CADPKF+cOiZ9ydRVzpj1GN4amjzoyH1Y_NRA7PZ4CLPpb-FrYfQ@mail.gmail.com>
 <7a6ee3ab-6786-7fdd-05d4-a5ee9f078e6a@kernel.dk>
In-Reply-To: <7a6ee3ab-6786-7fdd-05d4-a5ee9f078e6a@kernel.dk>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 22 Jan 2020 21:22:12 +0300
Message-ID: <CADPKF+d_B=CqL1cYttB-8H2n5XTHth_auUMM3B+2yPuc3g9q4w@mail.gmail.com>
Subject: Re: First kernel version with uring sockets support
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> You mean the one in liburing?

I'am referring to
https://github.com/frevib/io_uring-echo-server/blob/master/src/include/liburing/io_uring.h
with sockets OPs as the latest interface reference, thinking it will
help the io_uring newcomers if
IORING_OP_* lines will have corresponding comments of the minimum
kernel requirement for now and the future.

For example I was almost totally sure that sockets were the first
uring-supported thing.

> Yeah, you'll need 5.5 for that.

I see, thanks :)

On Wed, Jan 22, 2020 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/22/20 11:08 AM, Dmitry Sychov wrote:
> > It's unclear starting from what version the kernel and headers
> > were updated with sockets support(IORING_OP_ACCEPT etc).
> >
> > I just checked today 2020/01/22 Focal Rossa Ubuntu and the last OP is
> > only IORING_OP_TIMEOUT (still on kernel 5.4.0-12) ;(
>
> Yeah, you'll need 5.5 for that.
>
> > So maybe it's a good idea to comment-update every io_uring.h OP with
> > minimum kernel version requirement...
>
> You mean the one in liburing?
>
> > p.s. Not every Linux user is a kernel hacker ;)
>
> Definitely! This will be solved with 5.6 that introduces a probe
> command, so you can query the running kernel for what opcodes it
> supports. For now, it's not that easy, unfortunately...
>
> --
> Jens Axboe
>
