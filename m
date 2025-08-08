Return-Path: <io-uring+bounces-8901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 367FFB1E868
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 14:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E12B63BAD36
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 12:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC07225413;
	Fri,  8 Aug 2025 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DgrEjQZF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AF51FBEB6
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 12:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656446; cv=none; b=FS1hmweMOSn7/m9Lvhjs23Tpl/N2rYXZaHEJ3/myUvZ3X+cXHWE8h9oiesCknsBHtagZdhhChEiyda127bM5yB8y2rSeJEGtGJLSGXquSjfduwXA/6x9DR0K9wcWjZd+7QYkBZI3ceW1xHTjDmeyTFrUh47NNKhlDjR0dHxkGR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656446; c=relaxed/simple;
	bh=/xkuneluVVx9fAsF8Zj89/WnnbURABxwxYJgT0D9YFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HCOGsfpamLjnsc8wtqHx00E/79MEB9tcZz58fWWAiuWXn+xAHQ4n3aNZwG6OQTbUEAV9r6b87dad/WHQXmDY56pYGSx/SQNYjgE0fydP39rGBzBnhwWffEGjb0xog6B2Nqa2cR0IjUh0q1GzUkt7n1xZ6zYT8VdsffIQf4N6fLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DgrEjQZF; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76bc61152d8so1961712b3a.2
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 05:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754656442; x=1755261242; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5oY5RPIvCXM/fVkS8LQFDoid0eM/3tQKi7MItp5JPAM=;
        b=DgrEjQZFLIjjJaGz0ljkM6iMAGok0BYRo4QAmOOYPqn4pdfyGAjXMY5OJ9Vf9dJdPa
         8F1aoHx4+30iEaD2Mo7Di9FZQ+pxMNzu77OcsDJK+0+hhgFrxnRiGoEW2TbrqUWf/rPb
         aWSCqMoTa+nYM/+qTWy09jC5qf9MfKgTqxgrGQQLpLPSzuaYx2620QU5RlZIBjaVpRmR
         dlvooXe1lYq08rLf2LMVk1abV0ocWjt2hOAQmB7KMsw9XXhqbHHpd6SsaO8MpEfEN449
         MiXvWxrz5X7HqRzHShX23I1JfBtod9yuzNw/7rwiY6Qherh8h37M5qzOpec58At3aki8
         JXzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656442; x=1755261242;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5oY5RPIvCXM/fVkS8LQFDoid0eM/3tQKi7MItp5JPAM=;
        b=kXwVCgjYQxuBwn9McMxlGKaj7RyA1Y+6hkEuz3DHbYCqB0PzAyDBZvyhesDx3L4V92
         YcGcdGGOO5NMvuV73wRIsgbz1WXf42H4ldf2SA29IVSOPA6cDuPe41mpH91azd0bIUlf
         tpYQSkUsjafuSrNvgCzvfNz+DDe/HuR4YPvATmZagVl/TZhRYSjt29bs8koempn9C851
         lIFOiRoOQcxIQMiQy79aaL1HokXnvaX/k3poGndXdVR1lOidIEaJoXNrt3PKV5aT4l3r
         Nlu3UCdWryHogb+aN8+ikDHceNcrKN4vwJo5AMB/MPlWrudWkPSRdc2/Xxs7CFlmZ++H
         wvGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5ROulBXkGD2apZTLi4DhNe4cAG4p+Zyw4GM6/k1y9ATh7iKnmfxaZUxmKS4D8eTrtosk9sKrOPg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg19alwEmwYn/zCZXp0YljHv3ydsUvw5o7b/oYR0QnhInNNZYp
	5+WSmwUW+4u+ekuvzQVrIWynoG7m2qakiGdLmy73bZuLVZjaHufXXfYWmHoENVekqeA=
X-Gm-Gg: ASbGncs0Qo8trEdEZfStMxKd8uB1myWeLgq2w3XF3kk5kPfIgcsJriDRdVU9EvFb8gP
	sM0xMx/mNJ5wnoWeiPwjlUPoNuQEkVDb/bArRm9oiFYC0kqqmxVJUopoOIinF+9AJyKvKvA4/5y
	mQ2j34u4fsf0OTUt2Ab52DhsYOJbziTMGUayUrE10LFc0uuG02BW4tmZ8c9p0xo1Yzpww9SsoQz
	TNyKo1DVll8d2jnicUKnm6V13Qh0z44+9c+y69AT1ZfrmlhHT2qOU0cD3zF7VKjGa6zQELeFr8Z
	CeD9bZUrm5j7owf9j6w0QTpdvDffoa3S1dw4RvigX3ZEUXg0vkyM69+4zykZQtd98U9S0ciHMYL
	eofvAOYqm148Q275Rr7OEMkbPcW2zQMY=
X-Google-Smtp-Source: AGHT+IGpiB4zOK6SXLQl2escTn7fOCLfI55rRpKX8NF0N0y4n0sgdGMyGxmyXX8twpyiEEUJ/ANfhQ==
X-Received: by 2002:a17:902:ec82:b0:240:8f4:b36e with SMTP id d9443c01a7336-242c2219e8emr45402115ad.34.1754656442435;
        Fri, 08 Aug 2025 05:34:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b7b2700sm17859310a12.15.2025.08.08.05.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 05:34:01 -0700 (PDT)
Message-ID: <af7cf1fe-3019-40f2-9650-d3e82c6c5294@kernel.dk>
Date: Fri, 8 Aug 2025 06:34:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
To: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6895b298.050a0220.7f033.0059.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6895b298.050a0220.7f033.0059.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/8/25 2:17 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=166ceea2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5549e3e577d8650d
> dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10202ea2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a9042580000

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git> 

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 725dc0bec24c..2e99dffddfc5 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -156,7 +156,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
 	unsigned long nr_allocated;
 	struct page **pages;
 	void *p;

-- 
Jens Axboe

