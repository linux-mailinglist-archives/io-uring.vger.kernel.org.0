Return-Path: <io-uring+bounces-12582-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAWlL+hormmEDwIAu9opvQ
	(envelope-from <io-uring+bounces-12582-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 07:30:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E09234309
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 07:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D898301F9FC
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 06:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE427359705;
	Mon,  9 Mar 2026 06:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CP/8EtOB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618803D6F
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 06:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773037790; cv=none; b=o8PbytYqiOBK6e96mv1nZQYqU0g6Xuzdji0BU5mxKPXveRPlU1FmyEX3Xl3BLSyESQz7wcCSEXNFwSEDT8fGpcYUxuFcroLBk1jWpL97AoPnN3iI+wRTuQHKcpfgCbJVyYOa5HdzIUlcXRtR52rypbQWz/LubprJ6TsNfrOzEMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773037790; c=relaxed/simple;
	bh=YmSaYkXI/krJqYJU24FmR6U2p3xKP7WLxMGtQn2Edkc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k+DZzsp1zJq84oEOaX+apjn5kINQftl3PJRmZjefBtfgO8XWpPulH/lB6Jb/M0vf5f0ys1pYtf9dR/QUjWZB2n71sOn1JjgkKJX+m6aUT13GOZa06pbdn8gWt0O+vb1ztvcN2LJcbZOzteSc/ndZ8+n9f63mWar/CJNQcPmcRGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CP/8EtOB; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82990763921so3508113b3a.1
        for <io-uring@vger.kernel.org>; Sun, 08 Mar 2026 23:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773037788; x=1773642588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bjNCRGDdNSAhVIPSG6qBbdiy5yBmSFwtP/A60KKXtlY=;
        b=CP/8EtOB17TWaQIgU117IjxyScUI6zCM5+bA2w7IQbKiQDGAM8Q/DP3asSJ1bnT3Pg
         4aOL25feurO0W38ONsqnMTOCqAK/dRiP+axFW9lgvbVC9S+XWU5XKDvB0CZqdA2OJXaQ
         vNj1n645mHcDoFWHA7nbo5w7XTbglQxt5pqusz4zrwqEc1r3kBKiVaMcEd9z2skd4EEi
         Jtooaiz5S8V5PzGEIBJP6SyxiyCnpQbubGsbkZvpwrBTn3qyI9/DRpEo/4MZqg5+/ww+
         AK75/I1qoOEm3jLzdqr2Xt4UE3tJ9sJAxhqfvKOR+Os+7LnstLFmAUNuPAS+/4aNOLk3
         At5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773037788; x=1773642588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjNCRGDdNSAhVIPSG6qBbdiy5yBmSFwtP/A60KKXtlY=;
        b=l9LOctdMU2mZYyxypSWQDwQ5uXOdoRXa66blXJMYigOhSkyNb1PSLV1xXv2J0rb+CC
         yT+vgA3N8TqggJO7UO/N0jkCbhXKLoWXrabODCYkX4u8IJVDr8CnXU5+QpWJpibD8u8t
         yXSvQqyR7JUWlJUbabM5rTULgSviXsidQt/aqTb+RxCRmlcP7XQlrrYML2V59YM/kTHG
         jI0Ey1EmjxNIkuihKMDWA0Yd+PtyyzWepk+nw0p2JH4cWEOOHGfbwfqOuX0Bd91NvjLb
         3agRhsXe+KZrgcNBX+cJJr8AUTM7y8IUaFrjA8/4+ubbVZ7BNgDUVP3QfGvSXM2WD9ni
         754g==
X-Forwarded-Encrypted: i=1; AJvYcCX9oZFw7j++pg5mkjHPBFpH2vXo7+M3E1jk6nJR4NOmK8Y8lDidekq1C3kve0fhHDcTUWMMe0/sQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs25p0BKiFzRLN43vlOyK8vXBWeB9PYPozrarXEqk4QlabfNHu
	ZDG9jJ50ep3NaD+PVrdYA9kBx+xfO7yU5TE0ga88TisC9TVLXbUqm3wB
X-Gm-Gg: ATEYQzxVJ4SSTYgSPCcfxVzCmBD1QUT+rR40hMS1q1tcEZi7fEVhCamVLFUlAtSI+cv
	QQUFPCQqmnmEfznLOXlOpXAugjZLKOI/zsiijN8uICEkBWAv3RFQ4nof6wVj954gVv4K/h9oAZx
	pGrmfLBmGnC9FDm/7x4ZThcCV+Ohwkg+bIcms9i/ZBIbbRV64Da/9qjtwqwLyveDMAW//b3QOW4
	TDrNDZuM7bfkxkv8flQ9oIjnOLrW3gdY3ZGiOKhWCVdNMoW0uCnNJMnvLjmMCwtjuYgmXP5Xi9+
	zRIqMcdxayc/4RkLjhOv5EIHkIAgAcROGGsep/6+e467ZhuWgb8hPJVSvirDUx7Pw3yICNfIU+X
	Oaue+/CgLFIycQuOXkFR1wC1LGuDGqtoYK7jItzCcG3qjO7lfmwwiYJ91pp7Nm61gApR/Y0C8zi
	Jt3pzIwt55zv6SQ5H0yHWGFrUV68mtVMEx24z7RraJHQnRE7wqotNSZS/alUlRyVHSLA==
X-Received: by 2002:a05:6a00:4650:b0:829:7a2d:71b2 with SMTP id d2e1a72fcca58-829a30dfad6mr9754835b3a.57.1773037787550;
        Sun, 08 Mar 2026 23:29:47 -0700 (PDT)
Received: from naup-virtual-machine.localdomain ([140.113.136.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48a20c0sm10878180b3a.43.2026.03.08.23.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 23:29:47 -0700 (PDT)
From: Hao-Yu Yang <naup96721@gmail.com>
To: security@kernel.org
Cc: naxboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao-Yu Yang <naup96721@gmail.com>
Subject: [PATCH v1] io_uring/register.c: fix NULL pointer dereference in io_register_resize_rings
Date: Mon,  9 Mar 2026 14:27:59 +0800
Message-Id: <20260309062759.482210-1-naup96721@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66E09234309
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12582-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.984];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

During io_register_resize_rings execution, ctx->rings is temporarily
set to NULL before new ring memory is allocated. If a timer interrupt
fires during this window, the interrupt handler (via timerfd_tmrproc
-> io_poll_wake -> __io_req_task_work_add -> io_req_local_work_add)
attempts to access ctx->rings->sq_flags, causing race condition and
a NULL pointer dereference.

BUG: kernel NULL pointer dereference, address: 0000000000000024
PF: supervisor read access in kernel mode
PF: error_code(0x0000) - not-present page
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <IRQ>
 __io_poll_execute (io_uring/poll.c:223)
 io_poll_wake (io_uring/poll.c:426)
 __wake_up_common (kernel/sched/wait.c:109)
 __wake_up_locked_key (kernel/sched/wait.c:167)
 timerfd_tmrproc (./include/linux/spinlock.h:407 fs/timerfd.c:71 fs/timerfd.c:78)
 ? __pfx_timerfd_tmrproc (fs/timerfd.c:75)
 __hrtimer_run_queues (kernel/time/hrtimer.c:1785 kernel/time/hrtimer.c:1849)
 hrtimer_interrupt (kernel/time/hrtimer.c:1914)
 __sysvec_apic_timer_interrupt (./arch/x86/include/asm/jump_label.h:37 ./arch/x86/include/asm/trace/irq_vectors.h:40 arch/x86/kernel/apic/apic.c:1063)
 sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1056 arch/x86/kernel/apic/apic.c:1056)
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt (./arch/x86/include/asm/idtentry.h:697)
 RIP: 0010:io_register_resize_rings (io_uring/register.c:593)
 ? io_register_resize_rings (io_uring/register.c:580)
 __io_uring_register (io_uring/register.c:898)
 ? fget (fs/file.c:1114)
 __x64_sys_io_uring_register (io_uring/register.c:1026 io_uring/register.c:1001 io_uring/register.c:1001)
 x64_sys_call (arch/x86/entry/syscall_64.c:41)
 do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
 </TASK>

Fix by using spin_lock_irq/spin_unlock_irq instead of spin_lock/spin_unlock
in io_register_resize_rings. This disables IRQs while ctx->rings is set to
NULL, preventing interrupt handlers from executing during the window when
ctx->rings is NULL.

Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reported-by: Hao-Yu Yang <naup96721@gmail.com>
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
---
 io_uring/register.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 6015a3e9ce69..0526301f7a25 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -576,7 +576,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 * duration of the actual swap.
 	 */
 	mutex_lock(&ctx->mmap_lock);
-	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->completion_lock);
 	o.rings = ctx->rings;
 	ctx->rings = NULL;
 	o.sq_sqes = ctx->sq_sqes;
@@ -640,7 +640,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	to_free = &o;
 	ret = 0;
 out:
-	spin_unlock(&ctx->completion_lock);
+	spin_unlock_irq(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
 	io_register_free_rings(ctx, to_free);
 
-- 
2.34.1


