Return-Path: <io-uring+bounces-2742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A33AE9504B5
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 14:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E0971F22EF0
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 12:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77781991C2;
	Tue, 13 Aug 2024 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jHrfDQ32"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C69199395
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551294; cv=none; b=XTxmGMBwbPe35YX443ekH5EswTrEOkl8gAZjJ7QGJolMrtr8b767ESnCKGGjNqpw0AiSsPHKUsHMzJ+4FTleVcS5Z/hdcOtQD/2e8IbjNlhPWkQNIYxsDTcl3Rl3n7DSld563dX0RV4Y/LnSxqsJEWJExg8JaXljnbDmLp8aYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551294; c=relaxed/simple;
	bh=7JED9j77PKutsGABbXNBQkcMJG/2imqFd4wNMLEJ8F8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SDJ0oXRXdCmc76iIQ87gqvWOY2fBPcP17gpsOE/UOzR67eDa8jQrZmYvzjEYgVFjYs8n1ZZR3RxlFMzEtRL2iDCk4e0f0hasYjkW7zS3e/u2FAL9+Xazg7/8N7rTG0yL1RfmlmsaaYt8EEmVrHo/z3xq328xnWoxMluwGLj3icI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jHrfDQ32; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70d2a6e31f1so227941b3a.3
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 05:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723551291; x=1724156091; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OOHfasRrYR/IurZgZK4bKz+ZtwqF3wUb8jW3AIXAOx4=;
        b=jHrfDQ32rBeLiUalhp0oCWrbxY1cWvrQ+332y40foRlXazFu26JcKfUzefDi0fwS1/
         h8DMyCM2PLifuekV9dCEfi3/gVEHuwcz5UkA1NXgELxkm64qIAl69qzlI32bGhWIDZZ9
         9HYKmxoqRXhi6G0w1qW6QGDp5KgwTdb1FKyGtD+5tukBcu/9flbDOEn0Ih/8fgpUddUq
         kn5YBtEn4hWFIngrfQ6Sg4d36hQZiHRr83qa9ovjMdhlDhFhEi45UXDgKQZDyfEaExoz
         sMdkMtVS8EFRKgukbKPkot/pRYaB6mRRaHTRe0fRZqWAr6g5BP5WM0iVTc1hLpQLvkiD
         aZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723551291; x=1724156091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OOHfasRrYR/IurZgZK4bKz+ZtwqF3wUb8jW3AIXAOx4=;
        b=r5oIm0twUkmm3w26k+4lJV7nHkFt26//EhD/NdGKsBgDzDtuKzd0UtM8Duamezs3ec
         MGCIOrBGNVqUTzP8B59S/3b5nSMlaMRCU5KfjIHsXJdaVCayl2uDLedSDxt2XRHVfHlt
         7Zs26ELN+2AL5eWKhi1+n+Qunk7ve18SrTHch23E1nlRLc8zFJlYeQpTqHUkca8Zc9ah
         d+t2jmQ/lYIzsKySqnJIcL/fPaWejW1bgd78oF71TOB+zxl3LqL40x77yAB3vJkLDSwn
         m+eMjDS6OawSKYjOycvkc+RUns42vGEF+LTzIOH5urxO3rVcMRpWJOcCtrWxjhqctrDN
         QTLQ==
X-Forwarded-Encrypted: i=1; AJvYcCV67RcpZz8i4CPpGTfq6vrk17HZdntucVdr5YrgUTI0JFKjA5PR7sgu6QOs2vGikmIKQnIBDXLp/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe5mEqoh/czP+Ekb4F2remu0nRTH/Sa+HIBr5Wr53QO4MpLcHu
	KLqzQjW+0ua2E+am1yU/roeyWMxQ4tOvl3fnIShLGEiRX/54IRh8K0UC23rBWu8=
X-Google-Smtp-Source: AGHT+IHhvtlPy5GSVWgMeqS8qWX78qZ4pIqMSOFlNGCfFcHZFx0tbT3MGHx/cq3MmeWdSwWeHozC9Q==
X-Received: by 2002:a05:6a00:91c7:b0:70d:140c:7369 with SMTP id d2e1a72fcca58-7125a26d0a4mr1269317b3a.3.1723551290669;
        Tue, 13 Aug 2024 05:14:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5a4357asm5600846b3a.133.2024.08.13.05.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 05:14:50 -0700 (PDT)
Message-ID: <43b7c2c4-9bba-444a-ba27-9a8f3623a953@kernel.dk>
Date: Tue, 13 Aug 2024 06:14:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_sq_thread /
 io_sq_thread_park (9)
To: syzbot <syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000065552a061f8cb396@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000065552a061f8cb396@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/24 2:50 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6a0e38264012 Merge tag 'for-6.11-rc2-tag' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1019759d980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb57e6ebf675f9d2
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b946a3fd80caf971b21
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/753a842a966b/disk-6a0e3826.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e12e23519777/vmlinux-6a0e3826.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/bce0584a8cb4/bzImage-6a0e3826.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2b946a3fd80caf971b21@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in io_sq_thread / io_sq_thread_park
> 
> write to 0xffff888111459638 of 8 bytes by task 10761 on cpu 1:
>  io_sq_thread+0xdab/0xff0 io_uring/sqpoll.c:383
>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> read to 0xffff888111459638 of 8 bytes by task 10329 on cpu 0:
>  io_sq_thread_park+0x1b/0x80 io_uring/sqpoll.c:47
>  io_ring_exit_work+0x197/0x500 io_uring/io_uring.c:2786
>  process_one_work kernel/workqueue.c:3231 [inline]
>  process_scheduled_works+0x483/0x9a0 kernel/workqueue.c:3312
>  worker_thread+0x526/0x700 kernel/workqueue.c:3390
>  kthread+0x1d1/0x210 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> value changed: 0xffff8881223d0000 -> 0x0000000000000000

It's just a debug check.

#syz test

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index b3722e5275e7..3b50dc9586d1 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -44,7 +44,7 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->lock)
 {
-	WARN_ON_ONCE(sqd->thread == current);
+	WARN_ON_ONCE(data_race(sqd->thread) == current);
 
 	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);

-- 
Jens Axboe


