Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1579E8AC
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 15:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbjIMNIB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 09:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240743AbjIMNIA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 09:08:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C1819B6
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 06:07:55 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-402d0eda361so79274035e9.0
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 06:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694610474; x=1695215274; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nzBzuf6LZxvtpnAI8wecn9jFiyl9Zko7Y9Xwbf3eRWY=;
        b=tfOIOL5JYGPzw5EGyEFk4IKpeFcycASB27c7NiyPgD30M5DgOvIvoy1lhe7cPbnv15
         8WYqChwsdWQ3c5gEu9iD/9plnWJPdRXylZ4VLAlROdDGii/ZmmRHzmCILm5l08VvNHWC
         hHWuXlELKV6WTaQKXb2QnVJItniLvVD5ZLxbW+B3ncESDlwhLboCtEkDoIqoq1NeHxPI
         zXRoZL40++ntDrJtSZ7FC/LGOEF66iqwOsyb/nUSZC2JrUGGRRdbSxOgSSFaBXYaiOom
         2smu9lQdMrpl50rYrqfp2uqiqmJAzYaGUPhoLUSJeamT3aOyMjlKbgeniPLARtbd/UL+
         0bfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694610474; x=1695215274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nzBzuf6LZxvtpnAI8wecn9jFiyl9Zko7Y9Xwbf3eRWY=;
        b=xJk6YcYWViMuzGFSVCOMT/9vBhr0BrJc1+vkhatmmqgh1LwlHfxl1pGI1r83XxfSVa
         vvVRejGgDvoTJXAkoyTjestsxVgof6Bge6j6OSCi/wa+bIdVCyuOBhVxrmFjCuwzpO5k
         AYoQ4EUipJD4pdHzipQOcKAoTVZPKWihZ9kRHkairfm0+WAd9bfloXRCZxogqXxum0AG
         Qus7y58tKAVh620rUrbqObc4v12UmkXGHtQeDUSpWe1EuBWHdrMcaVYWCdCmmzsQAHOh
         L8koI0PlBndAu5jZmnQXD3EFhAJjtJoT9QekpbRXlx0LXTEEpR6FrTMzmLnig/6wcVpR
         v83g==
X-Gm-Message-State: AOJu0YwpmqxqKhPLnTe9YsRCmUaPGlXEYYOUrHxq9n8wvV32/VZRMMGV
        qW7RdsL6UWaak0DpVPvP0FQqLz2JCUM27IGw2GF6rg==
X-Google-Smtp-Source: AGHT+IEavyoLFycfTD/7cvjDsZ8SgcJkuLwQCv9ZCCzkk1PYhVhOzDZCKuVayZ/OAS4swCRCMMrJqfnYGSZw6eaIS3g=
X-Received: by 2002:a05:600c:2205:b0:3fa:97ad:2ba5 with SMTP id
 z5-20020a05600c220500b003fa97ad2ba5mr2078275wml.31.1694610474088; Wed, 13 Sep
 2023 06:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fc6ba706053be013@google.com> <4e400095-7205-883b-c8fd-4aa95a1b6423@gmail.com>
In-Reply-To: <4e400095-7205-883b-c8fd-4aa95a1b6423@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 13 Sep 2023 15:07:15 +0200
Message-ID: <CANpmjNPY7eD100LNcRJLocprTBuZrZ48hH6FPjMzhPSe6UMy0A@mail.gmail.com>
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

On Wed, 13 Sept 2023 at 14:13, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 9/13/23 12:29, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    f97e18a3f2fb Merge tag 'gpio-updates-for-v6.6' of git://gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=12864667a80000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=fe440f256d065d3b
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a36975231499dc24df44
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/b1781aaff038/disk-f97e18a3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/5b915468fd6d/vmlinux-f97e18a3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/abc8ece931f3/bzImage-f97e18a3.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+a36975231499dc24df44@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running
> >
> > write to 0xffff888127f736c4 of 4 bytes by task 4731 on cpu 1:
> >   io_wq_worker_running+0x64/0xa0 io_uring/io-wq.c:668
> >   schedule_timeout+0xcc/0x230 kernel/time/timer.c:2167
> >   io_wq_worker+0x4b2/0x840 io_uring/io-wq.c:633
> >   ret_from_fork+0x2e/0x40 arch/x86/kernel/process.c:145
> >   ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> >
> > read to 0xffff888127f736c4 of 4 bytes by task 4719 on cpu 0:
> >   io_wq_get_acct io_uring/io-wq.c:168 [inline]
> >   io_wq_activate_free_worker+0xfa/0x280 io_uring/io-wq.c:267
> >   io_wq_enqueue+0x262/0x450 io_uring/io-wq.c:914
>
> 1) the worst case scenario we'll choose a wrong type of
> worker, which is inconsequential.
>
> 2) we're changing the IO_WORKER_F_RUNNING bit, but checking
> for IO_WORKER_F_BOUND. The latter one is set at the very
> beginning, it would require compiler to be super inventive
> to actually hit the problem.
>
> I don't believe it's a problem, but it'll nice to attribute
> it properly, READ_ONCE?, or split IO_WORKER_F_BOUND out into
> a separate field.

It's a simple bit flag set & read, I'd go for READ_ONCE() (and
WRITE_ONCE() - but up to you, these bitflag sets & reads have been ok
with just the READ_ONCE(), and KCSAN currently doesn't care if there's
a WRITE_ONCE() or not).

> value changed: 0x0000000d -> 0x0000000b

This is interesting though - it says that it observed 2 bits being
flipped. We don't see where IO_WORKER_F_FREE was unset though.
