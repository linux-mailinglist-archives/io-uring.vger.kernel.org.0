Return-Path: <io-uring+bounces-2526-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 013C3935172
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 20:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEE0D280DCC
	for <lists+io-uring@lfdr.de>; Thu, 18 Jul 2024 18:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22581459F8;
	Thu, 18 Jul 2024 18:03:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFBA13D8A2
	for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721325782; cv=none; b=Xz8+SebbNlkovW2BH1cMlL9JmwvYH6SGfHx1NnvBkFNk1IZMI2dwlLlPAyxM2y0szK50LnOW10cj1CeN/YGG0Z0v4xKI+4s4UQMvScgp9CTC+3HzqkWk1ZSacGL4zh+9fubWNNr8YMBi0KiK8Gfn/FtwzNMH0b0SAyUAlMcKnKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721325782; c=relaxed/simple;
	bh=FHxbrmTw0dVAEXbFDVKzZm8aVaVDeImqbXiH++lXSSQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=WNRQRaE6u/fVxztsJGN6a2oPHGzXdEab15ClzZ3prWmdctdYR3XWTsORPFTn4uqLmoSas78Alypx42mZ6Ern3VRxe94+xjLP4G/MS62DCj5lnOdqQ0aFwhi+ZZe952ugzsnWR9+tVMV0qPgJbLho/BIoyWDER1lWoJ+W3rkg/Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39794551bfbso3087215ab.1
        for <io-uring@vger.kernel.org>; Thu, 18 Jul 2024 11:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721325780; x=1721930580;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+aHBRBgAFqp3cCvMwZ5U6Apip/zL0Qr94huepps+kHc=;
        b=ur07+sW8h09D2rizO2qbCo5iWVM7IWLEkSVfJZoqO/LhzIazoULLcarAUluYYgDuCy
         lIfqhaxgn2NWkAdijlJWBG18JzUlFWhUBqYAir4VUHljnejj05vjV4xDPXu6HQDZB0Yj
         W53eZtY1Ucy92Mtz2VLsboFG7G8UnDSDooH09AP2vyvA2haMWV5SpRkTJr9o8QckQJ8s
         m9fSSYgUwyORq68jCj5ZFpc2uvtR/2wbnrXpDp6QuYkk8p6HXiSeUOLI5mkkhiWPXnh6
         FlM9lbyvr9O1hbpY5N9pfUMOclzgKo8OZBkKEkTcA//UDLZ6O0ldrUUCbhPWfYhJjqVW
         HlEg==
X-Forwarded-Encrypted: i=1; AJvYcCWaQfziMa9ddva0azNCc4N73bvgxL1YMhNilUX+Yex/K/2TS5z4V/B/vnA1MO5eg7zOmzqIAfm2SclsSsG8DvfLbGdpo1Qf7cw=
X-Gm-Message-State: AOJu0Yx6i10a5zuBq3yLr2KL5QoCHGizi/nfvFD0q1mjL77w1g1Hsl0l
	3AlZ62iOHmho1NOkcjKjGMTGqu9llLVRgwiVRlUgmC8QhME6Eju/wA7/zcW/PYuS3jz8YjARlY3
	zjdgOdvbP6zZONlGxAjmbJ+yLA0fyqaXFtR2gQBFKZ+8pXSoQ+aqnxDo=
X-Google-Smtp-Source: AGHT+IExARHtw36AbOYPYSIsGgc5K0wOTD02RYbjVVAoQu8sLTtcwoYcCjxmXZrNkOohFZJqGBunDLc9teTF8O5IYgUpF3+yHLro
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b24:b0:381:c14:70cf with SMTP id
 e9e14a558f8ab-3955523dd99mr5129945ab.1.1721325780368; Thu, 18 Jul 2024
 11:03:00 -0700 (PDT)
Date: Thu, 18 Jul 2024 11:03:00 -0700
In-Reply-To: <d848129a-ed5e-46f5-ac17-add37d7799fd@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae9198061d896312@google.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in __io_remove_buffers
From: syzbot <syzbot+2074b1a3d447915c6f1c@syzkaller.appspotmail.com>
To: asml.silence@gmail.com
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On 7/18/24 02:20, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    d67978318827 Merge tag 'x86_cpu_for_v6.11_rc1' of git://gi..
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1178e9e9980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e206d588252bd3ff
>> dashboard link: https://syzkaller.appspot.com/bug?extid=2074b1a3d447915c6f1c
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e07d9e980000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16adf045980000
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/f34b31760156/disk-d6797831.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/a92e51d8d32e/vmlinux-d6797831.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/000a6a162550/bzImage-d6797831.xz
>> 
>> The issue was bisected to:
>> 
>> commit 87585b05757dc70545efb434669708d276125559
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Mar 13 02:24:21 2024 +0000
>> 
>>      io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring
> Easily reproducible, the diff helps
>
> #syz test:

want either no args or 2 args (repo, branch), got 4

>
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index d2945c9c812b..c95dc1736dd9 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -657,8 +657,10 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
>   	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
>   
>   	bl->buf_ring = io_pages_map(&bl->buf_pages, &bl->buf_nr_pages, ring_size);
> -	if (!bl->buf_ring)
> +	if (IS_ERR(bl->buf_ring)) {
> +		bl->buf_ring = NULL;
>   		return -ENOMEM;
> +	}
>   
>   	bl->is_buf_ring = 1;
>   	bl->is_mmap = 1;
>

