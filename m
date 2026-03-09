Return-Path: <io-uring+bounces-12597-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJEuBcbtrmkWKQIAu9opvQ
	(envelope-from <io-uring+bounces-12597-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 16:56:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AD523C3A4
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 16:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 094B13118293
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 15:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B8953DBD6F;
	Mon,  9 Mar 2026 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ok2+lwoQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6C83D6660
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 15:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071190; cv=none; b=cqHKeUvqiwZA/iBAhI1B5KNiOqHIElFcRrHbfTUVeGoPlopNFMYc4aGZydRdU2gjQk+RGkZYAcGWm5TndmCKd5k7aQwI+xA8jVR8xEHz4IXA1MS0jCw6oYN62NtbX3UuLpP0bSmbSYlGjNXCK+WU6GA0nxRgj8sXuhDn5YB920A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071190; c=relaxed/simple;
	bh=xldjzhJFCzzxVyt+4OynXPA50FgEvwM+E0rHMTc2UIA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZT23BgDIkvIXnCmOyhpslAgAE/9ZVymO77w46ss3h1evPJGPWv8VvhxrE/cAVYS4XVMwoiZMoAJyJm1eM0WXVafU9LCZjL8/plL2/EcCkFeDzBe+Z2ruRNqUtku3wFZpQ/xt4hlchOcY1kLH3wOvlBz9F83PrGtriK5IYyNK0DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ok2+lwoQ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ae41544dcfso97627485ad.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 08:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773071189; x=1773675989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7uMpO77lspwa+WHWBcoopjvWx4xr8G4N2UzbA4hFLw4=;
        b=Ok2+lwoQhlhgi1ipmwTXsw3E42S5xZd6xH3Q4UyUPHB+WS5xBF+ON96Nmbw+Omwiyu
         d4I317/nLIkhXJSSb71KpnIg+jh+kIzSnX7/IQDOzbGwp4SIW+d3nNgLBzFnwC3fGKdi
         cm+esxrjcDW53EdWLwP4t33wHoqfwinLBpBp6gFQvwIKPf0yJj5uAtqsH/IewqqAf2oL
         Z0sQ0iJi6a9qxHtta0OW4xMNd+EcmPfgqGH+6LjRiX+04OlO6roKVsZe6CGZGYntyYub
         QOQpoeL1tQD8PVzEjbNQ1misRbLkcdWjsg5DPeYE2pEQLdDsOfWaf+bDwippliAC6ooo
         uhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071189; x=1773675989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uMpO77lspwa+WHWBcoopjvWx4xr8G4N2UzbA4hFLw4=;
        b=ZM0p/Tc3+vrYp+T6Lb8WX+PfL9rG68RqFOXJZMiTOiLmtKOX12nAE1sfiFvZUCMnVX
         +5CJk0Y49cjuvXFGazhtswjlawsL1UQYYUfNzJxtWgk+J/adgTAxP2FAsZ31VYZxShWm
         0yyAxe20Ui6jRQ9gvRIoD1tzdvaj6NTfYihMEqrAxw4O3MaRqIOcDp9skCtyeD//jcAh
         /YpxNomBJEYO6zhYZ9n+BiYIF0HVh0JlW29deVTcSuZ0BcFaewQ7T2GxYclQKGmH99lj
         s/WUumj7LISayUa/P5Qf+C5GLidUhFu3h1YaXZiuMdBu51R35tQuGTDZCh+SQIF1yHb0
         Yaqg==
X-Forwarded-Encrypted: i=1; AJvYcCWPIWjhDYmUTthQeIyuV52YOrwrd/xbI15Ra0ad7E/bB6SyMENVlPerjLgrtLXMj0lQjxiHwk8zgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLRNxvUk/LTitXVHbSuCQ0xrunwwUzeP2Oxf8eBBsmA7FhSdMF
	pA4SWF0xOqwRkcJwb4TWHQ8bm68zHL0C5NSmLOSHNnhw/bEDKWi4TGWcbHyoGx76
X-Gm-Gg: ATEYQzx0pjmb+1PeC5lKKb1f0h8+i2B+EzwUBNDxAIGIrEnZPqsdJh1/MkZ7DO9TUjf
	rO33JCYNCwWimbsdNx3R47ycblDOKIWeHZASQ9itNEEX3ocGxo1b6tCW+2kQAP1kVaC8TwNIrrD
	IAeW0u9gjMqlWBB3pPngl7O/zEwE76Beoge8AHTvRljCFFnpcKhn5UAKFoHq7A476eSTkGCbNEk
	VXniuemeK8HJUZ8VaNAHvvOJ98Dc7LJRk52EXczB2itnGsT7btI4hA1JOsUf3TgBtvTcTKGZUQG
	vx6o4rmxTsBnrvu3mK2DF7+NerGC9EXidmXtSTY3IS9tFHS2BotH1WWWbZp02Z0cxrcX16ZB/JZ
	MPu0vxwfLVcnzv13T0VeJi9Iyn/ODneYk32/OVjz4QHyhomKz7fNbXK2JzO8quniJ3Kydjx4sdJ
	I24A5plXFa9KyfWJqQQ70OF29kJzZ1aWT5VGqo7Jppa+XpepymxhM1h7PGsTrtRlDi
X-Received: by 2002:a17:903:388f:b0:2ae:593c:48fc with SMTP id d9443c01a7336-2ae82488649mr121853435ad.53.1773071188851;
        Mon, 09 Mar 2026 08:46:28 -0700 (PDT)
Received: from naup-virtual-machine.localdomain ([140.113.92.221])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f77350sm134496675ad.51.2026.03.09.08.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:46:28 -0700 (PDT)
From: Hao-Yu Yang <naup96721@gmail.com>
To: security@kernel.org
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao-Yu Yang <naup96721@gmail.com>
Subject: [PATCH v2] io_uring/register.c: fix NULL pointer dereference in io_register_resize_rings
Date: Mon,  9 Mar 2026 23:44:38 +0800
Message-Id: <20260309154438.28376-1-naup96721@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82AD523C3A4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12597-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
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

Fix by disabling IRQs while ctx->rings is set to NULL. Disable IRQs to
prevent any IRQ/bottom half from triggering task work additions that attempt
to access ctx->rings to set the IORING_SQ_TASKRUN flag.

Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reported-by: Hao-Yu Yang <naup96721@gmail.com>
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
---
 io_uring/register.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/io_uring/register.c b/io_uring/register.c
index 6015a3e9ce692..9898598dd46b1 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -577,6 +577,14 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 */
 	mutex_lock(&ctx->mmap_lock);
 	spin_lock(&ctx->completion_lock);
+	/*
+	 * Disable IRQs to prevent any IRQ/bottom half execution from triggering
+	 * task work additions that attempt to access ctx->rings to set the
+	 * IORING_SQ_TASKRUN flag. This prevents NULL pointer dereference when
+	 * ctx->rings is temporarily NULL during the ring resize.
+	 */
+	local_irq_disable();
+
 	o.rings = ctx->rings;
 	ctx->rings = NULL;
 	o.sq_sqes = ctx->sq_sqes;
@@ -640,6 +648,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	to_free = &o;
 	ret = 0;
 out:
+	local_irq_enable();
 	spin_unlock(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
 	io_register_free_rings(ctx, to_free);
-- 
2.34.1


