Return-Path: <io-uring+bounces-8346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52864ADA20E
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 16:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50833189111D
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 14:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC9171F91F6;
	Sun, 15 Jun 2025 14:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nPmML8Uo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4288CF4ED
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749996820; cv=none; b=YysMTF7OWM1mxwf6cgnTF/tqV556+Yp53f/wkPMaa+/B2eJGKOakOJZGBQw+bY+UiZszrNV3VgKtf3TBgRK77Pf1vcdmTabxNfuuKWdAdZsLPzTJLX8ea7jmIsXRixGsasdGla7DzZmHkIfVCTHcmv5WHhusxghkAMlWzrELPgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749996820; c=relaxed/simple;
	bh=eNoSGRFzHq9a4RmIuX4mO4avI9DuGNFvkqvF2ktlHyQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=jppDlQLB+JvN8rmjewuBf/U2isgA68k0kUeGBvscoGFmlOzJnAaN3fJAQlHw2+gXLRy6q8GY0CO0Bdkf+SKNFfEX/tSNxtvl2L15WI690LwQSfA05r+fWOhPRy/jJPnRRl+2mcrhN/ra+aQmDWXv7dJ4tsH7UqbQIqb0xVfx0BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nPmML8Uo; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8723a232750so370501839f.1
        for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 07:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749996817; x=1750601617; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFeDB6BUUVpAB3nU/K4NEb+iI9ezzDty3C1aBZSDpi8=;
        b=nPmML8Uo9vdz90YV+bomU27+W9hn34Kwg3ui9JG8ad71xthu/VkMmPXcaYWm6cyOkU
         IPnhm2DpYLoc2bHM8sHtU4kjjg7K3TDeFGbNlq3L8n+W5wwAZtWNP38Lq3eh0sbBV7OI
         xndwiJB1xfWBXwZUI1dKp0rEyVSZI+GaUjxCQcQeW4MdXRWjwMgf6OPOA8tbVk2glLr+
         Qos6AQ2qQW8LfuiYWkCU3tY+y2OoBLS2Hq7IDEaSl2xLEYfokXJvbGBwQMGFEfDCvwJ4
         pQmjraCxARCcRX9U9qhLw1Fw7tKtw4ZI0RNqyherud/kgS0/PTQrnh26CXo/JM8ILgo/
         36wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749996817; x=1750601617;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GFeDB6BUUVpAB3nU/K4NEb+iI9ezzDty3C1aBZSDpi8=;
        b=Jj5E23dzIGedPJ0s5SJbKXc/CDNTElvf5Q7X6rSJEazWAAoYM7ETI/tm5+/4qbKWPs
         3JFCiOpey9qpIpC6idt2uFpFmnWrKHIviuvj19YJQgkMewPeVEBU1HKSGYdg6RT7SOUf
         m+m1q7yOyhvinpLGObAX2V9IXIZdcrgTiMIvG1BRp68cWhLGXUFDo5wFqAv+WeK1b7dx
         bA6AtOELqZFG1wpH6AETeJEox3reGqav7HXJX+Fh5al45tpxRSze1Vi0sfduboeKMFmG
         TTY8i9Kp3tCEBeRn5hktRuP2BkSVuNdG03hm6dHECT4x2lL3DD/1ZftLxLoZnq6fHof9
         MX+w==
X-Gm-Message-State: AOJu0YwIfm9D/IQbs5ilw7Hdchfc07Q3FEINbOSjHlf95JmLj15dBj+Q
	qR83/vmbufXvVDbxXG5sidKrM5E4egnKxUHE96s6eyt3RaQiWW7rIm1ytCxfL99R75XEK/nzCVC
	YBgoD
X-Gm-Gg: ASbGncsc4Qw3mrb0oD+J9tQ3vvRo4tEvcK1E9F5FkvKtezgEG2mzsMeqSnwnUcqSbZu
	SdK4Ke7HPjiuiyKEwm4eeV3BLTHiLkb0CmM2o/Z6Eq6TcGBzMovCugKZyhF784aZt5mkzc3CAiu
	iJuIdt13/idF6Mj6gfafi3Wa01jEbATlT04+6h5s06+p2MZezqASGi0uxPzp0ZBKY8muUmTKGop
	s/JST+pH2uDSFNBOYgpZqArpubBde90u10FVX55/5C019BrDrZYiba3QXLW9IAbuY/Ibbc/eD9D
	96y7vv0DvEj8hbuFEsCJdSQNKBCo1J3i7LXMhBF0nfRQ8kgQtedanNyWo/E=
X-Google-Smtp-Source: AGHT+IHaFdays9RXREEEDCfAaL8teCy/+zUd0KEVM6S/k27HSoqEO73HnZDOE3trJWcT5fTNMqS16A==
X-Received: by 2002:a05:6602:1550:b0:875:b8b7:7864 with SMTP id ca18e2360f4ac-875ded91a2fmr673008939f.6.1749996816652;
        Sun, 15 Jun 2025 07:13:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d57100a2sm131165139f.8.2025.06.15.07.13.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jun 2025 07:13:36 -0700 (PDT)
Message-ID: <ca1dd406-0927-44f3-bfd7-a120ef04cbf6@kernel.dk>
Date: Sun, 15 Jun 2025 08:13:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rsrc: validate buffer count with offset for cloning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot reports that it can trigger a WARN_ON() for kmalloc() attempt
that's too big:

WARNING: CPU: 0 PID: 6488 at mm/slub.c:5024 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
Modules linked in:
CPU: 0 UID: 0 PID: 6488 Comm: syz-executor312 Not tainted 6.15.0-rc7-syzkaller-gd7fa1af5b33e #0 PREEMPT
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
lr : __do_kmalloc_node mm/slub.c:-1 [inline]
lr : __kvmalloc_node_noprof+0x3b4/0x640 mm/slub.c:5012
sp : ffff80009cfd7a90
x29: ffff80009cfd7ac0 x28: ffff0000dd52a120 x27: 0000000000412dc0
x26: 0000000000000178 x25: ffff7000139faf70 x24: 0000000000000000
x23: ffff800082f4cea8 x22: 00000000ffffffff x21: 000000010cd004a8
x20: ffff0000d75816c0 x19: ffff0000dd52a000 x18: 00000000ffffffff
x17: ffff800092f39000 x16: ffff80008adbe9e4 x15: 0000000000000005
x14: 1ffff000139faf1c x13: 0000000000000000 x12: 0000000000000000
x11: ffff7000139faf21 x10: 0000000000000003 x9 : ffff80008f27b938
x8 : 0000000000000002 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 00000000ffffffff x4 : 0000000000400dc0 x3 : 0000000200000000
x2 : 000000010cd004a8 x1 : ffff80008b3ebc40 x0 : 0000000000000001
Call trace:
 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024 (P)
 kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
 io_rsrc_data_alloc io_uring/rsrc.c:206 [inline]
 io_clone_buffers io_uring/rsrc.c:1178 [inline]
 io_register_clone_buffers+0x484/0xa14 io_uring/rsrc.c:1287
 __io_uring_register io_uring/register.c:815 [inline]
 __do_sys_io_uring_register io_uring/register.c:926 [inline]
 __se_sys_io_uring_register io_uring/register.c:903 [inline]
 __arm64_sys_io_uring_register+0x42c/0xea8 io_uring/register.c:903
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

which is due to offset + buffer_count being too large. The registration
code checks only the total count of buffers, but given that the indexing
is an array, it should also check offset + count. That can't exceed
IORING_MAX_REG_BUFFERS either, as there's no way to reach buffers beyond
that limit.

There's no issue with registrering a table this large, outside of the
fact that it's pointless to register buffers that cannot be reached, and
that it can trigger this kmalloc() warning for attempting an allocation
that is too large.

Cc: stable@vger.kernel.org
Fixes: b16e920a1909 ("io_uring/rsrc: allow cloning at an offset")
Reported-by: syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/684e77bd.a00a0220.279073.0029.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c592ceace97d..94a9db030e0e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1177,6 +1177,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		return -EINVAL;
 	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
 		return -EOVERFLOW;
+	if (nbufs > IORING_MAX_REG_BUFFERS)
+		return -EINVAL;
 
 	ret = io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.nr));
 	if (ret)

-- 
Jens Axboe


