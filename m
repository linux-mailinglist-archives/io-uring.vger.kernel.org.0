Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7027A058A
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 15:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbjINN0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 09:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbjINN03 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 09:26:29 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7771BEB
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 06:26:25 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-502e385e33bso1621191e87.0
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 06:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694697983; x=1695302783; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I3lVrKOEFS16oa3zNmxYsrE3iBnyZ+tsV6wUnHz2diY=;
        b=nj++XJTKTIHaw4JcdNmZsRQBmxOuW8lRmFNuqaUrBwIa1UpDbEx+us2KobBHIzlozT
         MoiFZRLH7JGqFp7jzZMjib02oab+gV2gvAcDiOlAgxYCGa9I6Euy3haMjOqxO5ZOBzD6
         x9s+yDAPyP+jB6r6drEC5Sr7NzucvC77HkNAI7eiGnOe/rD1usCv2ij6fOFDIA9MiXD2
         CxoZB5eDE+H5l6//C4RdhSXIO8yC/Np46+EEC9hTTopONjyKWJxcakBq7WmK3jrOfpnQ
         nngkFQb5CSC0/T0rO3GxHRJjQYMCTVy6JdKAxuQ6yGAqAaXkMDxqMT4JG95YuxNXv2QY
         fOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694697983; x=1695302783;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3lVrKOEFS16oa3zNmxYsrE3iBnyZ+tsV6wUnHz2diY=;
        b=Ug5TOw8Ih86eF8LlY1ularnzLmCuzG5na/kJyWr72LAnyqWEoR9DTBaE7jbzuG/JHf
         pPYpSFBzH/zYejOfBY1mwC5vd5cz56waWS0VCmCSAD7h8WyD4i5Gp+WP87KxHEZEMOkj
         GjASuZhmY7uyqEqujt9yyDtM0k+Z6nfk5WjhJ06V46WA/paRXTYYpml31WQllx1pnz0X
         EP2wgJjrGr5SFPMrn5mPH9fBkkXwVRlIc+ulOhiM2JRgTKzW4dN2YeCSNXVAhJGffjIa
         7qxYf/5bdZnkp1ULjJ3PJNirjY/1rM3zrEPEXp/ScH7QPpTIExd8JjPBcVUSwufrEPxE
         NYpg==
X-Gm-Message-State: AOJu0YwYXHftEDs3Hk+cE2ECxsKNNe7cwyfuoLEGH4m4uEp2S0krr/hk
        H7UdMY6c/ainb3PEgPQH4vcIKUZT97l26KBkvo1WYg==
X-Google-Smtp-Source: AGHT+IF49bd8LoLkQvGNYwYeG1e7m3r9EqPwtu3FYVLct80z0LYTgYwKl+OlXahIey8ASkVPlUDxPdBIrIPyIg/9BEI=
X-Received: by 2002:a19:2d52:0:b0:500:aaea:1494 with SMTP id
 t18-20020a192d52000000b00500aaea1494mr3908045lft.41.1694697983468; Thu, 14
 Sep 2023 06:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fc6ba706053be013@google.com> <4e400095-7205-883b-c8fd-4aa95a1b6423@gmail.com>
 <CANpmjNPY7eD100LNcRJLocprTBuZrZ48hH6FPjMzhPSe6UMy0A@mail.gmail.com> <df1fbf71-f50d-c523-c9b2-e0f6ea011d61@gmail.com>
In-Reply-To: <df1fbf71-f50d-c523-c9b2-e0f6ea011d61@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 14 Sep 2023 15:25:45 +0200
Message-ID: <CANpmjNOL_YauUAxB_uEP-kHOJ5TyFOnZF26f5UhsLaq75mkKnA@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_wq_activate_free_worker
 / io_wq_worker_running
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot <syzbot+a36975231499dc24df44@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 14 Sept 2023 at 15:11, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 9/13/23 14:07, Marco Elver wrote:
> > On Wed, 13 Sept 2023 at 14:13, Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 9/13/23 12:29, syzbot wrote:
> >>> Hello,
> >>>
> >>> syzbot found the following issue on:
> >>>
> >>> HEAD commit:    f97e18a3f2fb Merge tag 'gpio-updates-for-v6.6' of git://gi..
> >>> git tree:       upstream
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=12864667a80000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fe440f256d065d3b
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=a36975231499dc24df44
> >>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> >>>
> >>> Unfortunately, I don't have any reproducer for this issue yet.
> >>>
> >>> Downloadable assets:
> >>> disk image: https://storage.googleapis.com/syzbot-assets/b1781aaff038/disk-f97e18a3.raw.xz
> >>> vmlinux: https://storage.googleapis.com/syzbot-assets/5b915468fd6d/vmlinux-f97e18a3.xz
> >>> kernel image: https://storage.googleapis.com/syzbot-assets/abc8ece931f3/bzImage-f97e18a3.xz
> >>>
> >>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >>> Reported-by: syzbot+a36975231499dc24df44@syzkaller.appspotmail.com
> >>>
> >>> ==================================================================
> >>> BUG: KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running
> >>>
> >>> write to 0xffff888127f736c4 of 4 bytes by task 4731 on cpu 1:
> >>>    io_wq_worker_running+0x64/0xa0 io_uring/io-wq.c:668
> >>>    schedule_timeout+0xcc/0x230 kernel/time/timer.c:2167
> >>>    io_wq_worker+0x4b2/0x840 io_uring/io-wq.c:633
> >>>    ret_from_fork+0x2e/0x40 arch/x86/kernel/process.c:145
> >>>    ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> >>>
> >>> read to 0xffff888127f736c4 of 4 bytes by task 4719 on cpu 0:
> >>>    io_wq_get_acct io_uring/io-wq.c:168 [inline]
> >>>    io_wq_activate_free_worker+0xfa/0x280 io_uring/io-wq.c:267
> >>>    io_wq_enqueue+0x262/0x450 io_uring/io-wq.c:914
> >>
> >> 1) the worst case scenario we'll choose a wrong type of
> >> worker, which is inconsequential.
> >>
> >> 2) we're changing the IO_WORKER_F_RUNNING bit, but checking
> >> for IO_WORKER_F_BOUND. The latter one is set at the very
> >> beginning, it would require compiler to be super inventive
> >> to actually hit the problem.
> >>
> >> I don't believe it's a problem, but it'll nice to attribute
> >> it properly, READ_ONCE?, or split IO_WORKER_F_BOUND out into
> >> a separate field.
> >
> > It's a simple bit flag set & read, I'd go for READ_ONCE() (and
> > WRITE_ONCE() - but up to you, these bitflag sets & reads have been ok
> > with just the READ_ONCE(), and KCSAN currently doesn't care if there's
> > a WRITE_ONCE() or not).
> >
> >> value changed: 0x0000000d -> 0x0000000b
> >
> > This is interesting though - it says that it observed 2 bits being
> > flipped. We don't see where IO_WORKER_F_FREE was unset though.
>
> __io_worker_busy() clears it, should be it. I assume syz just
> missed another false data race with this one. After init only
> the worker thread should be changing the flags AFAIR

The data races reported are very real, i.e. it only reports if it
actually observes _real_ concurrency. I guess the question is if these
are benign or not. If benign, you can choose to annotate with
READ/WRITE_ONCE [1], data_race, or leave as is (ignoring this report
should not make it re-report any time soon).

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/access-marking.txt
