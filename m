Return-Path: <io-uring+bounces-5596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5759FB560
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 21:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A9F11666F9
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 20:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85CC91CDA05;
	Mon, 23 Dec 2024 20:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dHx+h9De"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFBF185935
	for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 20:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734986021; cv=none; b=p0u3HBKHsZOey2kEbaxpRDkwZ+r2dtC3YO6NVemxwthHKMgKuLt34t05OAe9aWnAu8Wtda3VyNNGs9TlXMbHNYqZ+YZ0fB4NKso40TZ8h2IC4RQcQhS51DTPrJjzM+MarzyQGiz3chAqIWltghAum7m5NBYgHIgl3F8u+yT4NME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734986021; c=relaxed/simple;
	bh=paYbRHz9wCSacYfcA9Ewxfv/yPUqXBhojlhc0yO1JHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IH3otf78SOclI9qBVpj19XChKz4g4sq56yK94kWsFgJrX7R719izESYPTqLiuCJoYa2UkXlCvjUhtXpIV8ar4bpNnmWN/W8UjBeEy+Q6S/cC6xxHZD/0/PNbRfwYPqM2TMFWb4lpTlVncuSPfZKgx3L+hiBr0IWsxSjbd1wRUfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dHx+h9De; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21649a7bcdcso43381605ad.1
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 12:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734986017; x=1735590817; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X5xB/lPzXkSANJaPVnqHd+ZSXf5Kcq85JyVswTMNoro=;
        b=dHx+h9DeoPzHKikZ5M2rqVa8emXIVDmXOoILJELLbaPZXvt+emT7JHxvT/Hva63P5D
         e0v/J5RhXXKLunjn+w3esdBurhWv3gq6x2e+eYOy8KxdSjmbwc7dt6FR0xgeYWTc41Ow
         IpVUgP2eXaqM2AGSlzB7ymNbLWZMNN+XofZyRbfMn2vraK1FkbisECYMWA9e83ps3SdK
         3pCEhSjm64XSVcYa4Vo1FZghuMX/Ka/xgQ/bJRoeEosNiXYq+Ag3LYwk3C/27OoK24fJ
         AYzMG94/U1w82VUZYiOsEJZHcu+UzLusKabqkHZUAPwfPoLTTa3QpG1C/g4IpUPZFuFJ
         aTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734986017; x=1735590817;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X5xB/lPzXkSANJaPVnqHd+ZSXf5Kcq85JyVswTMNoro=;
        b=ihzwpfemYX9nKGEBBPdcygVNBUf6RmblE18ndbvbuP/cvY1X0u09wqyMEfn1CSwQPA
         vUX3YwAyekJt5BlnbtrIt7JxoLoJzQVZAVsAFQJ4EeIcQHBg5R7248qkx8D1E82LyXTy
         catfTfKSMxZlTEb7L+BAU8ImaP79hEzKu8VLM6YWawh/Sjw49RDtcFg8lJ5yNZpAE2q6
         rQYsl4uVMfxTFcyzQW9/BtjskEdxhSlyCIG3GzkPHjbJiU9k54RO1phJQFuOyIhXN/aR
         ZjDN99gNxjbTqoDVqjp81VjCpNVll9OKSzLmz7hj3gZw7U4JUWZ79RAvsybF0cw9Vh7f
         6FTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpDDFyMzKQOZokQKeesSkpnFYt8PnHdjW7dEZS7OEC9oYNEsMlKs/4mWHdeADQQHDDjvH7SpiGUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5oKQV2cvv1l/lvpVAWMAEN6AFE9PsCOOM71UeAdrDMEDVH7tv
	FdVJCQLaf0qyehI34Jb6gNwxgsVLmg/Z+/xGMVIiDs/BuJYUu8W3dbnYepw2XzI=
X-Gm-Gg: ASbGncvWnqNLmUHc10LwH5TdLKP5z+4YIJPefwwiwVFgofouPCMcIfWn4Hj2R7kAnex
	mJSWN1E2XSzJ/hzXbtiWuN8C+JHyBv0BEn5NDUsa1ZLHy2EorDQPaU/7Yga1Y/TYkxoeYDqmSOW
	GV0nDnpvxS9fozd9SuD6f4Ju+CyiWqJYWficgrRRSarwGUYKduqLw8zGuBl1mTQpnxIRzMsPK5u
	EDq7giO+VNs8nfefgn5BS/EA0xzll4utyfjrWYNa16220pmP7cpWA==
X-Google-Smtp-Source: AGHT+IHHPgNkcEyopkQEOR5NoyLQMpPpv1BV3Gs14V00OVQd+cDI1fAJi1/NVwhH43JVvC0b92EMuA==
X-Received: by 2002:a17:903:32c5:b0:215:bb50:6a05 with SMTP id d9443c01a7336-219e6e894f4mr208295875ad.9.1734986017134;
        Mon, 23 Dec 2024 12:33:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b229c48fsm6462928a12.26.2024.12.23.12.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 12:33:36 -0800 (PST)
Message-ID: <2f80272f-6cab-489d-ba2b-c1d545ac3485@kernel.dk>
Date: Mon, 23 Dec 2024 13:33:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in percpu_ref_put_many
To: syzbot <syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
References: <6769bf7b.050a0220.226966.0041.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6769bf7b.050a0220.226966.0041.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/23/24 12:52 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10871f44580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c22efbd20f8da769
> dashboard link: https://syzkaller.appspot.com/bug?extid=3dcac84cc1d50f43ed31
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141bccf8580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=135f7730580000

I ran this one but his this instead:

==================================================================
BUG: KASAN: slab-out-of-bounds in nvmet_root_discovery_nqn_store+0x110/0x180
Write of size 256 at addr ffff000009e71180 by task refcrash/775

CPU: 0 UID: 0 PID: 775 Comm: refcrash Not tainted 6.13.0-rc4 #2
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x1c/0x30 (C)
 __dump_stack+0x24/0x30
 dump_stack_lvl+0x60/0x80
 print_address_description+0x88/0x220
 print_report+0x4c/0x60
 kasan_report+0x94/0xf0
 kasan_check_range+0x248/0x288
 __asan_memset+0x30/0x60
 nvmet_root_discovery_nqn_store+0x110/0x180
 configfs_write_iter+0x220/0x2e8
 do_iter_readv_writev+0x2e0/0x458
 vfs_writev+0x220/0x728
 do_writev+0xf8/0x1a8
 __arm64_sys_writev+0x80/0x98
 invoke_syscall+0x7c/0x258
 el0_svc_common+0x108/0x1d0
 do_el0_svc+0x4c/0x60
 el0_svc+0x4c/0xa0
 el0t_64_sync_handler+0x70/0x100
 el0t_64_sync+0x170/0x178

Allocated by task 1:
 kasan_save_track+0x2c/0x60
 kasan_save_alloc_info+0x3c/0x48
 __kasan_kmalloc+0x80/0x98
 __kmalloc_node_track_caller_noprof+0x2f0/0x590
 kstrndup+0x4c/0xb8
 nvmet_subsys_alloc+0x1c4/0x498
 nvmet_init_discovery+0x20/0x48
 nvmet_init+0x18c/0x1c0
 do_one_initcall+0x1a4/0x718
 do_initcall_level+0x178/0x348
 do_initcalls+0x58/0xa0
 do_basic_setup+0x7c/0x98
 kernel_init_freeable+0x268/0x380
 kernel_init+0x24/0x148
 ret_from_fork+0x10/0x20

The buggy address belongs to the object at ffff000009e71180
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 allocated 37-byte region [ffff000009e71180, ffff000009e711a5)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x49e71
anon flags: 0x3ffe00000000000(node=0|zone=0|lastcpupid=0x1fff)
page_type: f5(slab)
raw: 03ffe00000000000 ffff0000070028c0 fffffdffc0523d80 dead000000000005
raw: 0000000000000000 0000000000200020 00000001f5000000 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff000009e71080: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff000009e71100: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>ffff000009e71180: 00 00 00 00 05 fc fc fc fc fc fc fc fc fc fc fc
Zero length message leads to an empty skb
                               ^
 ffff000009e71200: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff000009e71280: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

which makes me think something else is the culprit here. The test case
doesn't do much outside of creating two rings, it doesn't actually use
them.

CC'ing likely suspects on the nvme front. This is on 6.13-rc4 fwiw.

-- 
Jens Axboe

