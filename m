Return-Path: <io-uring+bounces-8906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E96B1E88F
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 14:43:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5DAC17846A
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 12:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035952797AD;
	Fri,  8 Aug 2025 12:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="esySw1Iu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8C21CAB3
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 12:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754657014; cv=none; b=udbtzjtJsHtP/7sIM/Hw6H0e8uyaChEHm5amMLMppboaCdQyv2tbjm2e4Nk0yhcBDVsdz6AFzxgPXPYCkiXZAG09IolMO9lmlq37yeRWup+e3m2YzrMaU+bksOEKjNdzXMigo/gVeRet/jrUGwtrkU5SPqpZIGZcz9PbbClCG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754657014; c=relaxed/simple;
	bh=VANEhYXdK7z6r1QBNfY24wJzFaLuZiCTdqphI1a9F28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odHmSmhdbLAtZrPd9Xlwn1hgn2H03ZaUS1bcukPULtYX476gYvf+tmCaMnqQOwaOMuzRAr4Uh8+yrMBKlLmXOgLa2fjYKD92KkDD9CZwUTDyAVnwOOQQE2feTm+d2DuB3r6AmeFKKML479fVBpoVH99rgruf7EiGdFQIrrUmYoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=esySw1Iu; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2401b855635so15471945ad.2
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 05:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754657013; x=1755261813; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TzfYUds3DmIRafs7qlzh+1ZOiNQM8kLprH6mSCrSkSU=;
        b=esySw1IuHODhdbB+knTLr6Xo0AyqhCSuz1NWeJfw4WOLi9i8iqXrSgKt8yzMyLtCyU
         82+bDLZSpeIsnmxh3zr7ZfWs/+rkj9IZD3s4frM2gJWsdtKexiY1EkybNnIhnP4IFDZ+
         ai3AJe0ES/NXD1q1CymC6Ss3AfDNOfzuUi1/eCtKaVWCUssW5OZ0xjs2MSNCPyyL8GNj
         pbbnRMRKDF+KdX/ykL9UZgtpeB0C/cSYMe5PjxFAt7Q38Gk4xh+xUohMJRYnMz9Zbn9J
         1cwc5N39pUYKWMf2nTOhvcVD88nCqWseeP0k/6AGqPEdXdfA8tUyByFNsToQAMOXuuI1
         dDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754657013; x=1755261813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzfYUds3DmIRafs7qlzh+1ZOiNQM8kLprH6mSCrSkSU=;
        b=W95WYSwwRTpSETn+Po7gN4Vt9NB7A4qMW700yrPO0GXXa5D7SZYOij+D834JF2XovM
         XxHhqt9O03XMI+Ertd5mIs20N5aZBW9ekoglkRBWayeS6fXhWZqHNTWC18vlMxI+WwEb
         TqcAgopRCKpRtjawvKVh7bED34sDVTOSpE0sGnyr0eQTMWdqnhiUTas4hO/wtUqcJojK
         oM/zwM3psSUOjnT1gdQ5/ArNxNuNpNXBYRAd2AITpCuW8XRdRUcWHqnh7agXtYB35xQ8
         9GcnAaxoD889XTqIkbsQV11gdWzmz4pG/NK8LcSYhCfCIYLOb1vu4BXPwEUMkDaiS4Ib
         VXCQ==
X-Forwarded-Encrypted: i=1; AJvYcCURQ9dssESO9ucZPaUIK8xDBlBX1E9D5rbeO23z4+TBSQv5Bo3UWBiTTzhqabhrYrGAS4Cx8VfEGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWia3irVgRCbzC9gy2GaWa/J1aKcwBxffI8J1KA6KJ7IKVypAt
	F08wk/2PftcfRqaJ5afLmDOiOTzHf/2OBfRxSEgXHeFkr+spT1w+6dx0kqJWX0Gv3+o=
X-Gm-Gg: ASbGncvIkTV4DVkOhBBs7hRGMFf8F5Z5nA3dwJ2jmSOqls2ldJrGiSsa5QO+1esQiTd
	5boJ0QdAtSsbVOv9f/Mfx9s2tqRtCbeNZ5MrUPzVYvXkTCIjr2PGB5oQli6FhbEbxLxXuLYqCn8
	kokoWDY0mkMS9x+YIcWu5WFHVxNXgyLVRz65hJGg0hg1bqRTsM010tDsVqjosuGRVIzpYNuvlZv
	GUWbeuIgcIYIo3dFUyrbQjoRd2w5CnY7X9A5XP14sYfylr/4AbC7fGWCaR0CVG3q1wX3JOn5VOf
	zCCT87xCDG4wcwt5deH34KkylppcwWNVl+vlNX9Yow5GvPcPS8b8YERg7//6JJgCFEDm6J88WwU
	wnCLkEtp3EBTO/jyD/WWL
X-Google-Smtp-Source: AGHT+IH77juZHYvpbBvBj4d6mlnGHzX46aU2nCAYzGX2bkq06/Kiwu4f2rf7icXIg7ROhv/Y0Kr5Dg==
X-Received: by 2002:a17:902:c94d:b0:240:10dc:b7c9 with SMTP id d9443c01a7336-242c1fd9612mr43013765ad.9.1754657012608;
        Fri, 08 Aug 2025 05:43:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89a6ec2sm208348225ad.145.2025.08.08.05.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 05:43:32 -0700 (PDT)
Message-ID: <05795247-a9c4-40ba-b213-c2b4370f86a7@kernel.dk>
Date: Fri, 8 Aug 2025 06:43:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
To: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6895efab.050a0220.7f033.0063.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6895efab.050a0220.7f033.0063.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/8/25 6:38 AM, syzbot wrote:
>> On 8/8/25 6:34 AM, syzbot wrote:
>>>> On 8/8/25 2:17 AM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
>>>>> git tree:       upstream
>>>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=166ceea2580000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5549e3e577d8650d
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
>>>>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10202ea2580000
>>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a9042580000
>>>>
>>>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git> 
>>>
>>> want either no args or 2 args (repo, branch), got 5
>>
>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> want either no args or 2 args (repo, branch), got 5

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

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

