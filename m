Return-Path: <io-uring+bounces-11600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E3BD15180
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 20:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A2FA302A79D
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 19:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66443246F3;
	Mon, 12 Jan 2026 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bZGwddgu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEAA314A7F
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 19:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246565; cv=none; b=cjIPQmLmOAc6+sNzAhgEvDGfjj0S9HtqkaV2YykNjr0HiXaurU3xMqUXzh8Y/Ouwg7fTRpWDexlHA84ZhzVidRcQg+aJdqOXZWI872jfDWkbLO9aORK5douuxZW7KassL5ZlP39cXuU9zjtJY+ScPB/aDu6qUTFtGy8Y/3Td7C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246565; c=relaxed/simple;
	bh=/I+DXVnibGo2EWk4txELNBsPVqrVws2tTRD91nJXFEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cJOD7Du9O2hU9r30aNxabqSCDbnoLdBldjLUNLcqIv5W97Lr+ONNQ/MTmsokihzZn7B/RJiqSaZZaQQ9M+cpry3CbEmHLhDBPErr//DTZTgxe9LRLN/kw1eGwO1SfATJx0O2BxANXstdm8Laoj9OWviYiglzOvZ6JMUOBJviKr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bZGwddgu; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-3e80c483a13so4151574fac.2
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 11:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768246562; x=1768851362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qU5qWkFGHT/LkCysy4zDcY3qSGPbGbM8aReytUCSEDM=;
        b=bZGwddguQH5LsYE++IsAXdoTnX+4IgbfRTQ4RlVN3S7Ci523/d264rI3qGBQyTtWyL
         w/54JCfP/4l+r4NseO8UV2yaowYJvz90K/sjshfdqEuMXdINe4C743ist9t2xXkuNAsX
         y+XdZ4UlAGKJKA8DgKWoA+1WWIp12b5CuRgNLW6xaPpIkOYhPDYiYftw8Sus2DgP4uxI
         EPErKZy/LplJ6+wBFC9+Q2INX9R9hk+b7u2vfU8ZyS6BBZe1tMtpz0HWCzt/O12xZ7vy
         sjkGGp3rkW3gpErtzJ+xSKksgPVQcf2jVt7WbZlWdAhzIYzham1nuK/st4Z8ksz/3kzM
         KhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246562; x=1768851362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qU5qWkFGHT/LkCysy4zDcY3qSGPbGbM8aReytUCSEDM=;
        b=k64PoQM2LyMlpnl3/t7G2DAYNfNpIqKbaOZLhx5Vu5NxQvB1BUDfdC1FzY0pzfvtFP
         Hcw4m+9ufe5/5XhKDDqFzq+/6cihhChc+wEDLESz4r69S8WVH3qJ9UbPsGq4KcXwR8lb
         aIz59frLUasK1p7DE92v/4IotIhF5jksijYdDwcQAmruErFJOHeHG16u++HqU4Dh6jhT
         oVd93o0Ax6FX2nCGOuzllnP0WMIYHXWqSZ4ywFK33DJd2nba0JlMf74T1YcVL1StRYsE
         lMkS40Xg2pWYfWNh2zdDG/fazp6OueNS6XWoP8B54AxJREdCKoGy94DwVzoL64Cztt4o
         m0VQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIl1ombIh7r5g3zWXcHoWs2JzZvrmC338HNBu8akh8w9wUUYigKY8FV9zNDBQ7AZU0hy1ioQqEDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzO1H2RK90OByCVPHbNCOASrgmCHTKHsI4YNw6yp3aNeAYZ85Vu
	0jxsJTyCb8uRQnS1gecmTgKJB5DA8M9SNjyPDnYtkwXahF5MBYPXVFiNrA4iFWp82qA=
X-Gm-Gg: AY/fxX4zocQhGfpkqMT98Vkx8yZ5iAqxDRtxvQPIWxe51EtPq/fyyoLClBqzjVJuue/
	PT7B+FNnHA1EglrzqMIrIQIdwIvvubWh/xMStJbQ4mVGu5KT/B/n34nnwgtCjYTuKkdH2b3w68W
	PoVyX2mfS9cM6sowYIbYDm4N+wonV2FSGM2aaHo7FaG6UfkQm4IJCGHciEawg4HmdQov6jXEIhl
	UkDreUx+2Cwh/iGNlmG7FdddU4ia2e9c6KgFISpseBPJQGA1sGRteoF1lGNar3Q1w27jmtrE0A7
	6whvDhhh/ejtDF6b6CQtuqMEklAIam5FzS16B8Yu2GPnVq7G836J2YjZ8A5IcxhVL9xe9TxgE6A
	3rTCTtz7U3/NyeyrXDkFWeZYXT3kL10qA1iCJGSxZ5Jy5w3eITU6qXfduUF0gufd8TQ1lO6Mm42
	KefKNVojY=
X-Google-Smtp-Source: AGHT+IGWPAsN8xd3qUtrWzs5Ia2qHgxSYfEP2B8vP4XKk2knF8QO4yft+EBiyHeBrm2YfDrO66kXaA==
X-Received: by 2002:a05:6871:2eaa:b0:3e9:7744:1d4b with SMTP id 586e51a60fabf-3ffc08fe0afmr10323954fac.4.1768246561597;
        Mon, 12 Jan 2026 11:36:01 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e3a7bfsm12420279fac.8.2026.01.12.11.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 11:36:01 -0800 (PST)
Message-ID: <cda9eb1a-9902-4961-aed0-66b5e94dd3f6@kernel.dk>
Date: Mon, 12 Jan 2026 12:36:00 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (3)
To: syzbot <syzbot+abecd272a5e56fcef099@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69653c1e.050a0220.eaf7.00c9.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69653c1e.050a0220.eaf7.00c9.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 11:23 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    7143203341dc Merge tag 'libcrypto-for-linus' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=177fd9fc580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=87bc41cae23d2144
> dashboard link: https://syzkaller.appspot.com/bug?extid=abecd272a5e56fcef099
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f4399a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ab3c3a580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1efe18c6d01c/disk-71432033.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a5a0b8a88b2b/vmlinux-71432033.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5bd4c64b0a42/bzImage-71432033.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+abecd272a5e56fcef099@syzkaller.appspotmail.com

I can't reproduce this, and I have a sneaking suspicion that this is mostly
just timing on kmemleak scanning. I've seen that a few times. Just running
your reproducer and I see:

root@debian:~# cat /sys/kernel/debug/kmemleak 
unreferenced object 0xff110000964a6200 (size 200):
  comm "kworker/u32:7", pid 1149, jiffies 4294971353
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 92 73 00 01 00 11 ff  ..........s.....
    01 30 90 00 00 05 04 40 00 00 00 00 01 00 00 00  .0.....@........
  backtrace (crc 38936ccb):
    kmem_cache_alloc_noprof+0x3fe/0x580
    mempool_alloc_noprof+0xb9/0x190
    bio_alloc_bioset+0x561/0x760
    submit_bh_wbc+0x130/0x250
    __block_write_full_folio+0x3ad/0x720
    block_write_full_folio+0x14c/0x180
    blkdev_writepages+0x6c/0xd0
    do_writepages+0xe9/0x1f0
    __writeback_single_inode+0x5e/0x600
    writeback_sb_inodes+0x2ea/0x850
    __writeback_inodes_wb+0x5c/0x150
    wb_writeback+0x382/0x4d0
    wb_workfn+0x4d2/0x640
    process_one_work+0x260/0x580
    worker_thread+0x2b3/0x4e0
    kthread+0x161/0x310

which are obviously temporal, and a whole bunch of the same reports, in
fact there is:

root@debian:~# cat /sys/kernel/debug/kmemleak | wc -l
264

lines in there. Then let's trigger a new scan:

root@debian:~# echo scan > /sys/kernel/debug/kmemleak 
root@debian:~# cat /sys/kernel/debug/kmemleak | wc -l
0

and they are all gone.

#syz invalid

-- 
Jens Axboe

