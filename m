Return-Path: <io-uring+bounces-5802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8EDA09316
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:14:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED77616A942
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C927221019D;
	Fri, 10 Jan 2025 14:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MMVk9mQ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1AE2101B1;
	Fri, 10 Jan 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736518441; cv=none; b=kpEdeSBRm5+/Fy9bMLu/jdK5+aYl7gIc9bmE52AYWnWs5c/Rr/Oz1RpNjbzJjQEbQpHiLicLD/cIWHm4qd+hCr3+kdU6MTV7IxY40Mi1cN6y1Ch/KCocE9N3D/8cE06o3Z4erTt2mXehBYhgEWwcroRwo2LA38/q2dymPozgX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736518441; c=relaxed/simple;
	bh=vp1CWEPS/9vtHHlnTRspu4y1W65Be03OrzSs0vjckmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NVV6mZbxnN6wy1O8b7E1o/R0+0vlhq036cE75iXYjaJJY8gPrLCKhBNsY17uXX9tjcXfQRtRSB05aZJX57mi6cYIOpz+5JaEdQgNSznrfia0GsbOqE+KkAeTsbD4ngkwJleBsgR6XOZiDtgKFxZM9vdWDEKs8h9edFjDwUlsW5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MMVk9mQ5; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa684b6d9c7so380755966b.2;
        Fri, 10 Jan 2025 06:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736518438; x=1737123238; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+oB2syyiiDQc+dvQYJfI/llaYQT3ACU+ZmTuES0C7M=;
        b=MMVk9mQ5U92PvNUktCiyu/HtJoCNVL+1gmoFXZFQoxw9pnc+ip4lhNb8czaCP4r6oN
         tufx7VsY702ThXoilY6TzuHbHGxMOumrSszZbmMSKcdQaWFmbUZpmQns3PqHoZ2vKo7D
         bIYR20HOm4ojcgRoo2R2A+3hsxWwIdHV4mHhUg2I+nb9XCRoOp013DbhPp2+Y+l6le2r
         6ipO0z18vFtzsFDj7doQKzDaANDhmlCJShfpZBUuLrTzoRCmXq66PAJOMx/DQiAJ6Ub5
         cVOA6GmhQVkKlRFNFRpeH+1U3+eTEYjd4c08BFU+MPRJeim+ib69oTOBXOOTMsel2Z9Y
         N44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736518438; x=1737123238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+oB2syyiiDQc+dvQYJfI/llaYQT3ACU+ZmTuES0C7M=;
        b=wsXopRYxP3I6gkPB6NHhfgvNc69lsNUhPUb7UUt2X+uTEl5GZmSXiiOYKLsYcSpC9B
         xAMzLzXHsCjsrA97RtqXRmjHyCOhZTLg5HZl5gMCUUPN+d205JN58sanpB7G5W7ithC5
         +eRbIe+ph7Pc21aK2fNxCxrG7N/detnvqtO4Dvbtc/rOXo73SDpz8/EvXaWTG31aiXnr
         LXH/w02lkghrqwEacFhGXG+8i9gacp0nTjBRgn51WZ+FlZ4VDVUvTl4huXq9ypjplvXk
         jqT4Lec11HNPOMbePxeoEWBHHpB/bgyfyZbzACPelXrLWQQhBoZmL7PXTHMRgbfzH2M3
         xp2Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6llvPFooulW3hbo1IFUatfjmxObGf/MgPFn3KkrI9Oh7+ntn3Btzi/tzYW6riYalFbpIlhW27iA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEDumuVD9ibhaC33QG5fgthrQKM93mv5pkwlwP3p6lIQT1XKg1
	pEoBF/2UqA27F/TsMGA1A5FqVprlS00+cRP8JK1mYls+I2HAfeyW
X-Gm-Gg: ASbGncuODRZuyLD5si2klPFknxZZh3xfEDtA5yo2eJW0SBscAXpJxtagvbqQImNybmy
	GDrSjQf3wWK0529KQbcOMQsGIglsvLtWnBqZABrhPWPF7j3E7auzEuKDdoKD/oyUiKFje7XEyaL
	rA9w5gf4JuvRL9Lo5E+IZW1tTvewFrSgQxZWDs6+BkW7r6nuhL/FoEpgjI23URDypepmSUxHrgD
	VhM8jNXe9CJQEnv68sDR4xjE0PtSSPRCCCR4d4YB/9XgDV+fEkje8+cc42bSSUQlw/d
X-Google-Smtp-Source: AGHT+IE2KJqlkXVzgAkS5l3pr9VSHrKvw84lqnPZP7f4xy+Gj5sK6wIV2zlCRsrjZis0OAzJCD57vg==
X-Received: by 2002:a17:907:3f1c:b0:aa6:6e41:ea53 with SMTP id a640c23a62f3a-ab2ab670761mr880200866b.7.1736518437839;
        Fri, 10 Jan 2025 06:13:57 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325::46? ([2620:10d:c092:600::1:1552])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95b0ab6sm168956866b.155.2025.01.10.06.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 06:13:57 -0800 (PST)
Message-ID: <ccecc088-087e-48fb-a963-e37b439597d1@gmail.com>
Date: Fri, 10 Jan 2025 14:14:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [kernel?] KASAN: slab-use-after-free Read in
 thread_group_cputime
To: Dmitry Vyukov <dvyukov@google.com>,
 syzbot <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <678125df.050a0220.216c54.0011.GAE@google.com>
 <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACT4Y+YKGy5a=8=HgyX38To+1yME59n9r=1pJahRVvx_n6F-Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/25 13:56, Dmitry Vyukov wrote:
> On Fri, 10 Jan 2025 at 14:51, syzbot
> <syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1377fac4580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3d92cfcfa84070b0a470
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/6e96673b1b94/disk-ccb98cce.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/528385411880/vmlinux-ccb98cce.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/b061a4d50538/bzImage-ccb98cce.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>> Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
>>
>> CPU: 1 UID: 0 PID: 27552 Comm: syz.2.3223 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:94 [inline]
>>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>>   print_address_description mm/kasan/report.c:378 [inline]
>>   print_report+0x169/0x550 mm/kasan/report.c:489
>>   kasan_report+0x143/0x180 mm/kasan/report.c:602
>>   thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
>>   thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
>>   getrusage+0x1000/0x1340 kernel/sys.c:1863
>>   io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197
> 
> This looks to be more likely an io-uring issue rather than cputime.c
> 
> #syz set subsystems: io-uring
> 
> +maintainers


Thanks. It probably needs something like below.

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 6df5e649c413..5768e31e99b1 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -268,8 +268,12 @@ static int io_sq_thread(void *data)
  	DEFINE_WAIT(wait);
  
  	/* offload context creation failed, just exit */
-	if (!current->io_uring)
+	if (!current->io_uring) {
+		mutex_lock(&sqd->lock);
+		sqd->thread = NULL;
+		mutex_unlock(&sqd->lock);
  		goto err_out;
+	}
  
  	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
  	set_task_comm(current, buf);

--
Pavel Begunkov


