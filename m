Return-Path: <io-uring+bounces-2745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0F59504C1
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 14:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7F17281759
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 12:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB12B1CF9A;
	Tue, 13 Aug 2024 12:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2+T+IJ1v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5D92557F
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551459; cv=none; b=BCemSgGcSTAXWlXt9UdJHDM0GgRDO0TMXPrBQ6QBSe3Ynx1pXZCSkYvrxBZHkvMIv8ubeVFb8JB8n5yVdfhRVNlio1e3FxnND0vTfjmAEsiI++EDdMgHKFwotZlg7ZDZhiz8Wp3BafbcXxDc4Ot2GM8IFATTzUJpmKv8UJWY1wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551459; c=relaxed/simple;
	bh=20FuJZqZU0Ph8ExU2jUwYBH21k+3ur7ISxJL49WUtxE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=FJ6BoBK/5KcqDoDp+l5bWq/N6xpqD4iBtVEZyAkZKFo9A1nX/q1jJl/4D87u+NhZgIb6lFPKHLM3OvjI95sRwGAwVSPmRQyKeZMiZ+t+O3ppG0IWJrscK49F1+NkP9iBnJw6wurxslbAxDchgnS7KwOjvChzYqi4csl0zQQD+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2+T+IJ1v; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70d1876e748so270884b3a.1
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 05:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723551457; x=1724156257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J8RqIpTGrf2gyiod7MNhBZs1nyq4ZQwSLchxqQSof6s=;
        b=2+T+IJ1vMDPHQ5V5+nPa8LM3R8oVE3e6HmBT/Q/pvkMb8psY5xETpcE8eSzHiCqzWq
         r8D7eBlEw7uaK76KIim26Pcmi0BMdote6B4a5O8y3vZ1wL2LnhfXEqJQiG3q9wQ7Q1cV
         0oLEC+ns/aHuGDinn07nPpALanaZeGpcJ6JC245if1itwGTuDTtb7MLWz1QzkJ7CLLOb
         IT8JCMSVAd+6jD+zAUiV7AutExcXgOoYAjH6b+vNuF3YRJ51fnZMNBMzHbdnWnwrJCF2
         tPWuZb/i7id76wK7lOWniDS/k8MxpA3EQO8as8WU2BArpibEJlkpthy9SOdApBWYfV9e
         3UBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723551457; x=1724156257;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8RqIpTGrf2gyiod7MNhBZs1nyq4ZQwSLchxqQSof6s=;
        b=twordek/1h8IKHDooPjGbSjIxDdhe6bHbV4ojmLBqYNvvh6v+5o5XeaW6lr4+M5+Nw
         STqqD1Ov63CobvnLpKxbcOHiBJYdj8+OMNyaZtf/h3Ht1Mu09ge3MVt0k6CAUzdcXWOY
         ZYy7xFhUcoz1ls8W2yn6jXTvv8e+CXPJ0aMhjrfE7ajPoqTB/F0FzCMJmOYnh6P99LAq
         S74FF3+sISXLu+gEe7liZEmgTARxnSdR/RtMDLPKEw30O08WXC9+zc87c/lMiL6Hl0Dc
         oRWibHr40ad7gV7KEqpNDbpLuEzC/VjjLaoTb3Iy4QgJLQ/jcDyH67ce31YAs95fS6vU
         G1Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVb6j3AxHb7vsaSi+JW1ArCBKkRxt1is0kjdwz4NyUodq7l7ngPMwKa+yx/onf5wV+ScSNJCzkHrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVh/Vrk1yX1YGDj4xF+j0BzBt7luc9Djvi91iYwyvDIEKk5h5t
	IZVKpXu4vVP687x/nAaOrSvqEar5I29ubLWga8um/Sa+9uP1dVxkhEVYFmrnPJs=
X-Google-Smtp-Source: AGHT+IGlebUB9AQq9a/zXCjz7V8Rarc7LS76Mgpv5RIaUd+rYf6nEOYx9bh/ZXMiGo+wk09qxWqkLA==
X-Received: by 2002:a05:6a00:6f25:b0:70d:2c09:45ff with SMTP id d2e1a72fcca58-71258cea2afmr1550111b3a.4.1723551457205;
        Tue, 13 Aug 2024 05:17:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58ca6a3sm5743352b3a.90.2024.08.13.05.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 05:17:36 -0700 (PDT)
Message-ID: <d3cc7fd4-b787-457a-9d90-7db14700a319@kernel.dk>
Date: Tue, 13 Aug 2024 06:17:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_sq_thread /
 io_sq_thread_park (9)
To: syzbot <syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <43b7c2c4-9bba-444a-ba27-9a8f3623a953@kernel.dk>
 <0000000000009063fb061f8f8e5c@google.com>
Content-Language: en-US
In-Reply-To: <0000000000009063fb061f8f8e5c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Tue, Aug 13, 2024 at 6:14?AM syzbot <syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com> wrote:
>
> > On 8/13/24 2:50 AM, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    6a0e38264012 Merge tag 'for-6.11-rc2-tag' of git://git.ker..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=1019759d980000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb57e6ebf675f9d2
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=2b946a3fd80caf971b21
> >> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/753a842a966b/disk-6a0e3826.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/e12e23519777/vmlinux-6a0e3826.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/bce0584a8cb4/bzImage-6a0e3826.xz
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com
> >>
> >> ==================================================================
> >> BUG: KCSAN: data-race in io_sq_thread / io_sq_thread_park
> >>
> >> write to 0xffff888111459638 of 8 bytes by task 10761 on cpu 1:
> >>  io_sq_thread+0xdab/0xff0 io_uring/sqpoll.c:383
> >>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
> >>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >>
> >> read to 0xffff888111459638 of 8 bytes by task 10329 on cpu 0:
> >>  io_sq_thread_park+0x1b/0x80 io_uring/sqpoll.c:47
> >>  io_ring_exit_work+0x197/0x500 io_uring/io_uring.c:2786
> >>  process_one_work kernel/workqueue.c:3231 [inline]
> >>  process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
> >>  worker_thread+0x526/0x700 kernel/workqueue.c:3390
> >>  kthread+0x1d1/0x210 kernel/kthread.c:389
> >>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
> >>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> >>
> >> value changed: 0xffff8881223d0000 -> 0x0000000000000000
> >
> > It's just a debug check.
> >
> > #syz test
>
> This crash does not have a reproducer. I cannot test it.

#syz fix: io_uring/sqpoll: annotate debug task == current with data_race()

-- 
Jens Axboe


