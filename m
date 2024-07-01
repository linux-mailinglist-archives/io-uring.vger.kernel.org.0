Return-Path: <io-uring+bounces-2407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3286791EB5C
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 01:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1B891F22218
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 23:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FB3171E61;
	Mon,  1 Jul 2024 23:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoDh8gRj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA692F29;
	Mon,  1 Jul 2024 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719877052; cv=none; b=ohlmqbmeed1NFlvLSi7v1AMwkrC2PdNmJY1nH3hwh5gX/XTItWfWaxyi+SZTQHZoFYD71crMmzXgMosF9Ydp95DIYF6MRDD/T2+zu27CIccog//ZiyPsIRIuE/TIMu4Ah0oo16U6cXMc39Do0XBBfDBbdZvb9mBioaevxISWRAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719877052; c=relaxed/simple;
	bh=NGznw/6tk2MYwtODVXtZggmSjcbrwXeOl93HZH/3O7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QkO0rP74PoPVJbhWOSGy9Sj0hQGgJChEup/xeJq1RwyeOmXMrk1GkdawPz3+39w6eAGGHVqgd/ObjB8F+Y7BlKNccgrJNqbVYLjNh8eS7Kw12yvLfu8C1+xl5SI9pUKQdwZS2UnGZDF6ils2hhrZK/yAmJAbYL9tGeT7E3hXWNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoDh8gRj; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-361785bfa71so2535224f8f.2;
        Mon, 01 Jul 2024 16:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719877049; x=1720481849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xvmT3TNt0Fdhi+g+gPYTR6CsT3eiKiWqFKv2tpAFT5E=;
        b=FoDh8gRjvNa+xeME2hyPmSi//x1Ifh1qn4oGaGIBrMa19MqaM3JZP3OHoVIEv8caIR
         I21DF4LjbMAnoSdcb7pxzdgwLAUPuQMfWXJBkRLbqN7hHl9qLoMnYN4pytg65oPpszFw
         nGogBOsLq1mJP76j3Wrcp3pFWDWrTe02oQWhlH7mS4Vz2f/5w4TaQVcl9fWqxDjut+AS
         TAKeoIJl1NnS93RzE2gQOPVxwFPFqaB1BxfwdzLJ5FR8uv0mtaxAzDY0u3Qra0sApUns
         vZxi5dCnA8J1m+O2dQ3QTNgowKMHKy0kv3oOT8LP9coGj2wmdxmcbAwp0mzWSbF8ppZ5
         uKyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719877049; x=1720481849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xvmT3TNt0Fdhi+g+gPYTR6CsT3eiKiWqFKv2tpAFT5E=;
        b=QTERaqJzSTycZI5zWRm5H1yW0r+6fFUZg9k8AcYBwcuAIsQM7ltTybTQdue3roQsPW
         ZZ1F2XZr8Jk0bXtYn3sR374expMYEeho/tDJBmJssyu0JNCFU21pce3FsJyYDpODreep
         52egzepU9c3KmFkf7sMgp1H9SoAKm/oQn8mFZGLLI1a2WjR1KGD4FDcNyJvRa7xQcvRl
         m9LQf+VCG4NYu7aeWaCsdZpCxg1ZFQgNek7aZJFE/+omVwjXCDpg42u/EXZXTL/60E+R
         YEd4Rw9e6bcmvw4wREJE6zynZ4kr4sl26BK5xTtBvV2YuCCduSZu8N2yvtkDj+vt0ICG
         KkLw==
X-Forwarded-Encrypted: i=1; AJvYcCVsoHxJ88YDUYPKclpy4RmgI4WqhfE1IupZS3ZYxuhe/uEcKPvZ6pz0m/ctKv/wMW9k/1iP8sfPs1RLhndQXwn4hZHnfgbOE3+xuIj8rQxqx+zgxN3ZomBfcgSTLNg1zCkSNYiBCsw=
X-Gm-Message-State: AOJu0YwKSqIxSoCcllE3V94AQjsGjZWTywmWlDIVuWIpgZ86fKF3zYRW
	S8jEPBfkIH4E3Cz8FUcjLGDL58F79F/sDrwcCtf7GCUekqrnFUyZ
X-Google-Smtp-Source: AGHT+IHPFrvCMHljkF20XpweXAQN0HYEGI8aYZyCnYGxo76UEjRtnm8w5ItuLRMvPcn5FuLL6dlhKQ==
X-Received: by 2002:a5d:5f91:0:b0:367:83e9:b4a5 with SMTP id ffacd0b85a97d-36783e9b614mr103057f8f.49.1719877048504;
        Mon, 01 Jul 2024 16:37:28 -0700 (PDT)
Received: from [192.168.42.238] ([148.252.146.204])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a102fd4sm11302073f8f.90.2024.07.01.16.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jul 2024 16:37:28 -0700 (PDT)
Message-ID: <67dfe3c3-091e-4b8d-a817-3d3594b1f0ef@gmail.com>
Date: Tue, 2 Jul 2024 00:37:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in io_cqring_event_overflow (2)
To: syzbot <syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <000000000000d82187061c35bef8@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000d82187061c35bef8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/24 21:50, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    74564adfd352 Add linux-next specific files for 20240701
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=135c21d1980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=111e4e0e6fbde8f0
> dashboard link: https://syzkaller.appspot.com/bug?extid=f7f9c893345c5c615d34
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/04b8d7db78fb/disk-74564adf.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d996f4370003/vmlinux-74564adf.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6e7e630054e7/bzImage-74564adf.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f7f9c893345c5c615d34@syzkaller.appspotmail.com
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5145 at io_uring/io_uring.c:703 io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703

Makes sense, it needs locking around overflowing, will fix it


> Modules linked in:
> CPU: 0 UID: 0 PID: 5145 Comm: kworker/0:4 Not tainted 6.10.0-rc6-next-20240701-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
> Workqueue: events io_fallback_req_func
> RIP: 0010:io_cqring_event_overflow+0x442/0x660 io_uring/io_uring.c:703
> Code: 0f 95 c0 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 ed ae ed fc 90 0f 0b 90 e9 c5 fc ff ff e8 df ae ed fc 90 <0f> 0b 90 e9 6e fc ff ff e8 d1 ae ed fc c6 05 f6 ea f3 0a 01 90 48
> RSP: 0018:ffffc900040d7a08 EFLAGS: 00010293
> RAX: ffffffff84a5cf11 RBX: 0000000000000000 RCX: ffff8880299bbc00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff84a5cb74 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffffff84a9f5d0 R12: ffff888021d0a000
> R13: 0000000000000000 R14: ffff888021d0a000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4e669ff800 CR3: 000000002a360000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   __io_post_aux_cqe io_uring/io_uring.c:816 [inline]
>   io_add_aux_cqe+0x27c/0x320 io_uring/io_uring.c:837
>   io_msg_tw_complete+0x9d/0x4d0 io_uring/msg_ring.c:78
>   io_fallback_req_func+0xce/0x1c0 io_uring/io_uring.c:256
>   process_one_work kernel/workqueue.c:3224 [inline]
>   process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
>   worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
>   kthread+0x2f0/0x390 kernel/kthread.c:389
>   ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:144
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

-- 
Pavel Begunkov

