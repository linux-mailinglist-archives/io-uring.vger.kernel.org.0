Return-Path: <io-uring+bounces-12929-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CnQDdvLzWnihQYAu9opvQ
	(envelope-from <io-uring+bounces-12929-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 03:52:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 745623825F4
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 03:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 35B53306A89A
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 01:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81FB1EB5E3;
	Thu,  2 Apr 2026 01:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="qBbZy1cQ"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7826A2853EE
	for <io-uring@vger.kernel.org>; Thu,  2 Apr 2026 01:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775094628; cv=none; b=TFZFrPz+Rv1UaXc8fa1AyaqbI0QXAdTvGRARtbJfAsLpobMVARs10u1nmI6doLmeehjr+Ei1BxPQ5DhYnp199sRT82EDjrobR6riHM9mevD7I1vm1TlkgJ0tQYLAmhER8P1Ynyoy493UaKmuKvNRd1lijIraZnb3GSgvkIjqc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775094628; c=relaxed/simple;
	bh=PF/pDKqdZhqmFgXi0RVca9s/Q+51OaQTVMzhAx8M2Fg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tg4k2Dio2A32HHDOhYp11BrOg+y//8EfeqyKuWiTvrT0MGjVpflIt7wDSIZ41SdQCiPZp81YTEmV7dGaSUFalCrdtOpGpxnfCEJd/i6kqYHHyQAwF/DdwBQLDkIeo5QUzHJqRjS/k1UAYmggl6TRmpKzRO0wPMGcyJy9kwYbFwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=qBbZy1cQ; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cp
	0onq6ONLoqXpHrBAZQDCSNXuIZdMFQMxl0/1tQdi4=; b=qBbZy1cQH8Q/LwEB/o
	CxshcB0JiE70jsHBrRni9wm0qnS3sU74QfLgjLGSnCm5F8fohq4A6HZM8EMphGzz
	GyuW/5h9iRyHw0KFe3Q2E2KefBDyicoy7KLrvOtoB2kkZPPJ/SKOonztJYvdoZAM
	J3eOG+I1K0hiYlDB2iwmm+ryc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBXwglCy81peRQjCw--.21668S2;
	Thu, 02 Apr 2026 09:49:55 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2] io_uring/timeout: use 'ctx' consistently
Date: Thu,  2 Apr 2026 09:49:52 +0800
Message-Id: <20260402014952.260414-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXwglCy81peRQjCw--.21668S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF1rGw43Zr13urWDJFW3GFg_yoWDXrc_Wr
	ykt3s7WrW3Jr1q9r4UCw45Wwn0yw42kr48Ww47WFZxJ398Ja4UXr4vvw1kZF1DCw4UGFy3
	Ca95WryxJryavjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRMa0tUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgPQYWnNy0OsGQAA3p
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12929-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kylinos.cn];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kylinos.cn:email,kylinos.cn:mid]
X-Rspamd-Queue-Id: 745623825F4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

There's already a local ctx variable, yet cq_timeouts accounting uses
req->ctx. Use ctx consistently.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
v2: Drop kbuf/net hunks (already on for-7.1/io_uring); only io_timeout_fn() ctx cleanup remains.

 io_uring/timeout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 579fdddac71a..4cfdfc519770 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -284,8 +284,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 	raw_spin_lock_irqsave(&ctx->timeout_lock, flags);
 	list_del_init(&timeout->list);
-	atomic_set(&req->ctx->cq_timeouts,
-		atomic_read(&req->ctx->cq_timeouts) + 1);
+	atomic_set(&ctx->cq_timeouts,
+		atomic_read(&ctx->cq_timeouts) + 1);
 	raw_spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	if (!(data->flags & IORING_TIMEOUT_ETIME_SUCCESS))
-- 
2.25.1


