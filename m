Return-Path: <io-uring+bounces-13014-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFUwB/G912mdSQgAu9opvQ
	(envelope-from <io-uring+bounces-13014-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 16:55:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B3B3CC42B
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 16:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3F7B53004CB6
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 14:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0381133B6E3;
	Thu,  9 Apr 2026 14:55:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AED3603FA;
	Thu,  9 Apr 2026 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775746539; cv=none; b=m8mpq+36QK8mqdDDxaVzvo1uiR06PoYwTMdRShRcsQd/ISgPzvEJLQAK927JUUxR9ZPKX38nlAGTzt54G+2AkGl4iW6C27iyR9z68bdzpSW1w54KL/mppfMUTY0q5eFm8rhWN/Fi5WxFRQTD0zZHcEztcSFpc1XkoGGO62n4Yrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775746539; c=relaxed/simple;
	bh=WoBCfppSAFOZ0yDH1u9iL3Kt7YbV2XDhzHBJorHv0tU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QDKIiKiaEiOO25ye5xWV35E9s8GhAMPYLMv/YPjt5bLL14FsiHaZxawRSK53WRGogoLiTjfmRVFVWVN2AI9BzbREyrsLxJyFxTeVFYy5FK/2ELC1q9hGX/ZiV51/G2PX22Jraa0JkHaaTp1/ICan7s+4iYBwq63aylVv+R6MPDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.162.196.130])
	by mtasvr (Coremail) with SMTP id _____wBnqKTdvddpaj84AA--.4905S3;
	Thu, 09 Apr 2026 22:55:26 +0800 (CST)
Received: from LAPTOP-1HUHJV8R.localdomain (unknown [10.162.196.130])
	by mail-app3 (Coremail) with SMTP id zS_KCgBXb3HdvddpE91lAA--.53385S2;
	Thu, 09 Apr 2026 22:55:25 +0800 (CST)
From: l1zao@zju.edu.cn
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix null-ptr-deref in io_uring_poll
Date: Thu,  9 Apr 2026 22:55:25 +0800
Message-ID: <20260409145525.36194-1-l1zao@zju.edu.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgBXb3HdvddpE91lAA--.53385S2
X-CM-SenderInfo: qrsujiasvsq6lmxovvfxof0/1tbiBgwQDmnWr4xI6wAAsr
X-CM-DELIVERINFO: =?B?rS1BFwXKKxbFmtjJiESix3B1w3vHnlJbTzpjBiDNiSV1FaPW3jUfstcnhS8dxCjcBC
	0yFD4AuiNVYGoWqgKtcCQLTqyjh9TWB2DsEBSh+z2SA6JmzT7THpUoVhhJ23fnxR2kZzAf
	Fj3fZJ8pb+g9YgkYE4+pPM4SM+5f+iEIK/SI4rfyfDOMi90lYz/Tiewsgmo5xg==
X-Coremail-Antispam: 1Uk129KBj93XoW7KFy3uw1kGFW5ZF4rWw15GFX_yoW8WFy5pr
	y5K345Gry5uw1jy3Z8Jr48ur9rKa9FyrsrWr95uw1jyrnrZFn3Kr45KF13WF1jqr9rAry5
	ZFs2q398ur4DAagCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y48IcxkI7V
	AKI48G6xCjnVAKz4kxM4kE6xkIj40Ew7xC0wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE
	7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8hL05UUUUU==
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13014-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[l1zao@zju.edu.cn,io-uring@vger.kernel.org];
	DMARC_NA(0.00)[zju.edu.cn];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NO_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 15B3B3CC42B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Haocheng Yu <l1zao@zju.edu.cn>

A general protection fault in io_uring_poll is reported by a
modified Syzkaller-based kernel fuzzing tool we developed. The
crash occurs due to KASAN: null-ptr-deref.

This issue is likely caused by a race condition between 
`io_uring_register` and `poll`. Specifically, in 
io_uring/register.c/io_register_resize_rings(), ctx->rings is 
set to NULL. Although this step is protected by a mutex lock 
and a spin lock, io_uring/io_uring.c/io_uring_poll() calls 
io_sqring_full and __io_cqring_events_user without holding the 
lock, in which ctx->rings is accessed.

To fix this vulnerability, I moved the two function calls in
io_uring_poll() that might access ctx->rings under the protection
of spin_lock(&ctx->completion_lock).

Signed-off-by: Haocheng Yu <l1zao@zju.edu.cn>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 02339b74ba8d..6fdea9eb0b39 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2934,6 +2934,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 */
 	poll_wait(file, &ctx->poll_wq, wait);
 
+	spin_lock(&ctx->completion_lock);
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
@@ -2953,6 +2954,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 
 	if (__io_cqring_events_user(ctx) || io_has_work(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	spin_unlock(&ctx->completion_lock);
 
 	return mask;
 }

base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.51.0


