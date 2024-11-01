Return-Path: <io-uring+bounces-4336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B12B9B99B3
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50516282CD4
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB731E2606;
	Fri,  1 Nov 2024 20:54:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6991D5AA3
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730494446; cv=none; b=mpjZ5uFY/x7Yk1NEFU0VZsMVPhwJVJ5ULek6Vb4l/Wj6885pfRwEmdPAgXi3UoU1Ayydv8pl60PtMHYj369KwYecVKiKiRxCs/mvdb17veDEF4wMcBGbYiWNU2pUstn9HDcLYUFs20bA2VIC6ZDzhSahAv3wlFusZPv8VQsiDbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730494446; c=relaxed/simple;
	bh=kZJMeUwq6BfXnNDCNqrO6cUSq0z1D/YwlmwI2+6lKN4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=K14oNyUSrBjIYcBzHfR5n9JV8FmQR8KKNmuSnnQTdkL1/UWoGYYgaUxTogC/zY0na3uMDwdwlZCh+qhixXpqrNssSCUgUOQpN6kCqbRR3mMXTcXm369bi3QdPcGfpjj24J2i79R2pquUNxBqxVTKTw42N92o+wmljG/KaOOtLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4f32b0007so21759655ab.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730494444; x=1731099244;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4zYGTXETVjU1EyAT+YMEHC6pldiUtC2fofBVRE3p8Ho=;
        b=V/X+aHBm5kzasCdjntDGHROJJTlTghNexYtbQZi1VJ6GTT4OWcRAznaZD+6ixKUUj2
         okHag6roNUaAJvRWaTbXKpnh8EG6iN/LmjyxxO3lkzg7ix1blRgx3E+pogxxkwailA99
         Ry0nwEreKkVy+2c8oQ/Eu0bq+DrGzMiMasOoaQnhvcdygeCN95OHoynP7avNiHUX9NdC
         1jUV6w/Qncjl9txi0Ei81ZkI/zmm3ybP56cEnoq3AFghdnMltlu9VTHqZ6yQUupCp34d
         SQ2z6rjudNJ0zOXXdVs3DbJKWrnjiRenI9Mf2rf740FmQcGpubtZHhRr8UmDWdsS5+wG
         CMmA==
X-Forwarded-Encrypted: i=1; AJvYcCWA1R3a9rGBOoCXyUcvfmacXC2aiyoTu6MsPXsDEBu03VJhHBn5wE7UHTVrnKSTwLANpp7AzFH8cA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+FCJdVM4T/WMTBeN96tIovTnR4osS8l6RWRbCANR9qnD7rn+i
	6Owpf6FfOozIbT7uqP8da6qai18htQaZZZ9RAmMFBT9iJk/nWKxi/u1TjoLKBrSYtOc++fWfS9n
	3tRz6g0kzX/dai2jv5ZOJ2q02i6soFjfUjB8ltL104BG5PIfbUcW0Roo=
X-Google-Smtp-Source: AGHT+IF835Gf8jxK9c9oKhwRcXBUKFFOJdDs3mVGGOLi0NDw7H0LxUhGG3Fpy1L/PIKJqsTCFX4oAls524+fI6LsjYVb1nKSreBW
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:b11:0:b0:3a6:ab82:db58 with SMTP id
 e9e14a558f8ab-3a6ab82dfcbmr54224685ab.23.1730494443762; Fri, 01 Nov 2024
 13:54:03 -0700 (PDT)
Date: Fri, 01 Nov 2024 13:54:03 -0700
In-Reply-To: <8fb2e8a3-c46c-4116-9f5e-0ab826ec9d22@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67253feb.050a0220.35b515.017a.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in io_sqe_buffer_register
From: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com
Tested-by: syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com

Tested on:

commit:         6b1c1819 io_uring/rsrc: fix headpage checking for spar..
git tree:       git://git.kernel.dk/linux for-6.13/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=10ced340580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37061a3807403bdc
dashboard link: https://syzkaller.appspot.com/bug?extid=05c0f12a4d43d656817e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

