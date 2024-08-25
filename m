Return-Path: <io-uring+bounces-2951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D7295E3F6
	for <lists+io-uring@lfdr.de>; Sun, 25 Aug 2024 16:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A6351C2082F
	for <lists+io-uring@lfdr.de>; Sun, 25 Aug 2024 14:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB79D13D28F;
	Sun, 25 Aug 2024 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A9xP9UGA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D8EAD2
	for <io-uring@vger.kernel.org>; Sun, 25 Aug 2024 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724596855; cv=none; b=rS5I93RCAtPHPscr42CFMnudJL/bNrBObrj18caGZ36PH+5tj/GmaovOWbIWiltP8WQwfu+7IXCVHV8FRk9AMtMs7Rg/+VjAFmHl2wMY+vwIo1evMTtPSJKyAZ9ecbjR4K6uKe2OGOdMKG2IAXypa4dBsiIAYxwSsH3P9SrUb84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724596855; c=relaxed/simple;
	bh=10MkRKmKKW4Sruv9vrMgYF2z5VuL21Xk6jq4tURXoDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mSB3pzdyIBcBSZDcAgnKNCoUqWZDs5CH4Pciyx21QpewUZOTafTKM6QSIwBiUP6M4cjrHsUUtBpGBKsutnhcPAI/tT/Jx0Y02y4Rk1MW4b0k12w2ciiL/xpDE4LlVuACZmfIhz+mWuVdXUckASs8VX0K35Wc4BkdgBxaIcIU6DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A9xP9UGA; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-76cb5b6b3e4so2174341a12.1
        for <io-uring@vger.kernel.org>; Sun, 25 Aug 2024 07:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724596852; x=1725201652; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yw9jk5TjmUChhFAY8V11/5PWzPNq5KzoBrg61+ZS9nw=;
        b=A9xP9UGAGAg9yT/5qRlpVPzPvyM8aVgdQ/uTCzpUr9XPTyA0/QHz8fyWfETRiERosc
         rylVECFxh5UKe2iTOMNC9rurPRccFzE8D+f0Xg8LiqB+LCnCM5obwRi8llE9OXAYKvjH
         U1HbSnNUVHWq/dhdnRPSm3k7Pa8QpvfJLHHr2m+REvCtdYZcKqZbyO8FBy9Lep/pGqpq
         5fK8tUHXwQQHQHIanlbvc4jMydZc1eN1JxmalRmOtGkoC2GFTrNULtoSqt0IqA8j6/2A
         qZW5xcXHi/W6rljyL1h+XLtqzoW909m5zfM+Ol2gp5+DqhTQHEXuN8OYwAjw6z2guFS2
         dZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724596852; x=1725201652;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yw9jk5TjmUChhFAY8V11/5PWzPNq5KzoBrg61+ZS9nw=;
        b=cMD6FgvToSj8/mcTPIwbPgiGxo3kSEmVTRXRf8Yfg5/O2tJ3IJcvPi5/IN4wVBhUWq
         KaZTDz5wn0BnyZjQ42mvN9KQBQPblUmpAhkQDdY207c16S9vqzU/kqKnlYhGQEJB6ep7
         nZeaM1GYJUU3zYeyOtNRH7/MoWQ/c5tcMW1oQdb59qsTqFHKGeoM4SLr6GHYHDTWNNEy
         DjmbhuhvBniOFjkhmPLt/tI0tlUT9WPqOXTxHqy3pjD6HLhP6pVpyDYVEPP2T2/ETsyq
         Ba0N85hkDNFi+sv4d21O6mT8e6VYSNoic1QQVQF6dVKaIySt2E6s531ujk0k88sSK9ix
         oj0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUr+dO5yq1wUxolZ+cHkA/CVJdkzktABZTLSdcPizD4qk2vxEVfh+TyqXu9P75xt0SGvQA9G35nMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyprQ0AzgdApKVn+yTqB7BfTMdBxszngMvg67UL7eWEzY0e3r1B
	k/fdoNZw5cqUKF3MFmgpvP5PO62GNaJL44dmaDSr2npvw8HYSNQD4KnYbTNakYc=
X-Google-Smtp-Source: AGHT+IEui5tqTKrX9jWvtOyymBygudoz9I+mdkopr9lkl2faiFKdqJLOrGkbBjz/TWXowqxVJ21sOQ==
X-Received: by 2002:a05:6a20:4311:b0:1c4:87b9:7ef9 with SMTP id adf61e73a8af0-1cc8b59171emr8833961637.42.1724596852078;
        Sun, 25 Aug 2024 07:40:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d613a3f2dfsm7953804a91.27.2024.08.25.07.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Aug 2024 07:40:51 -0700 (PDT)
Message-ID: <5886f3c8-f417-481e-9726-f5ebe1e013fc@kernel.dk>
Date: Sun, 25 Aug 2024 08:40:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_sq_thread
To: syzbot <syzbot+82e078bac56cae572bce@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000003a7ed0620796b9d@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000003a7ed0620796b9d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/24/24 9:15 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    bb1b0acdcd66 Add linux-next specific files for 20240820
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1363f893980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=49406de25a441ccf
> dashboard link: https://syzkaller.appspot.com/bug?extid=82e078bac56cae572bce
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ebc2ae824293/disk-bb1b0acd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5f62bd0c0e25/vmlinux-bb1b0acd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ddf6d0bc053d/bzImage-bb1b0acd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+82e078bac56cae572bce@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff816d32e6>] prepare_to_wait+0x186/0x210 kernel/sched/wait.c:237
> WARNING: CPU: 1 PID: 5335 at kernel/sched/core.c:8556 __might_sleep+0xb9/0xe0 kernel/sched/core.c:8552
> Modules linked in:
> CPU: 1 UID: 0 PID: 5335 Comm: iou-sqp-5333 Not tainted 6.11.0-rc4-next-20240820-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
> RIP: 0010:__might_sleep+0xb9/0xe0 kernel/sched/core.c:8552
> Code: 9d 0e 01 90 42 80 3c 23 00 74 08 48 89 ef e8 3e 9d 97 00 48 8b 4d 00 48 c7 c7 c0 60 0a 8c 44 89 ee 48 89 ca e8 b8 01 f1 ff 90 <0f> 0b 90 90 eb b5 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 70 ff ff ff
> RSP: 0018:ffffc900041e7968 EFLAGS: 00010246
> RAX: 11f47f6d1cba3d00 RBX: 1ffff110040802ec RCX: ffff888020400000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffff888020401760 R08: ffffffff8155acc2 R09: fffffbfff1cfa354
> R10: dffffc0000000000 R11: fffffbfff1cfa354 R12: dffffc0000000000
> R13: 0000000000000001 R14: 0000000000000249 R15: ffffffff8c0ab880
> FS:  00007ffbe99d66c0(0000) GS:ffff8880b9100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffed4fbfdec CR3: 0000000024c2c000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __mutex_lock_common kernel/locking/mutex.c:585 [inline]
>  __mutex_lock+0xc1/0xd70 kernel/locking/mutex.c:752
>  io_sq_thread+0x1310/0x1c40 io_uring/sqpoll.c:367
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>

For this to hit, we'd need to come out of schedule() without having set
the task state back to TASK_RUNNING. That should not be possible, so
unsure what is going on there... But does not look like an io_uring
issue.

-- 
Jens Axboe


