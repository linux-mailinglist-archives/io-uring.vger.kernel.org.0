Return-Path: <io-uring+bounces-13147-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBNrKC6W72lyDAEAu9opvQ
	(envelope-from <io-uring+bounces-13147-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 19:00:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3FC476C1E
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 19:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD22C303F7C1
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 16:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F4C3ACF0C;
	Mon, 27 Apr 2026 16:59:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36B5202F71;
	Mon, 27 Apr 2026 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777309165; cv=none; b=M4Sir6Y+IdXdg7MRsH9UhvDUNUUXwopbn3fgk/ktK/ANwxYNI6e1aVhiW1o2DuKxCoLo622jrH05W3gDLhpokE0OkUWiriK6Tu8PCNdK69/Z4jG5eQ6VZsZUrKTvjMTf/s83OpDvg4UBcJAmASQNt8p/pX5qjNSus/id//wv0bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777309165; c=relaxed/simple;
	bh=aw+fq0Zozzvh1eMl1V8KLqFVvenFKuQ48rCw8Zm6nIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FThCRNQjYiQMIIb01DOmYg0BKfwvnn9hUsHCYdUm+nrpcKCeZwpcvyCUT5XfaPD2o2zANQmUzCeNnttMQ68g7d7gG2yUVciHVwXb0Uyxo0LKz0/Q+YjZWAbhnDRoVez2VU0S1PrkiXNgDyw+HX9ptfE4ZkIrOtVnZzLcRLtW73U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 18EA34B4C4;
	Mon, 27 Apr 2026 18:59:15 +0200 (CEST)
From: Fiona Ebner <f.ebner@proxmox.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	linux-kernel@vger.kernel.org,
	t.lamprecht@proxmox.com
Subject: [PATCH] io_uring/wait: make check for pending io consider cached task references
Date: Mon, 27 Apr 2026 18:58:49 +0200
Message-ID: <20260427165910.683941-1-f.ebner@proxmox.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1777309059520
X-Rspamd-Queue-Id: 2B3FC476C1E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13147-lists,io-uring=lfdr.de];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[proxmox.com];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.929];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FROM_NEQ_ENVFROM(0.00)[f.ebner@proxmox.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,proxmox.com:mid,proxmox.com:email]

The io_uring task's inflight count also includes the reservations for
task references from io_task_refs_refill(), not just in-flight
requests. Thus, pending requests are present if the inflight count is
larger than the number of cached references.

Co-developed-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
---
 io_uring/wait.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/wait.c b/io_uring/wait.c
index 91df86ce0d18c..d9d4fe3b0f40c 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -48,7 +48,13 @@ static bool current_pending_io(void)
 
 	if (!tctx)
 		return false;
-	return percpu_counter_read_positive(&tctx->inflight);
+	/*
+	 * tctx->inflight also includes the reservations for task references
+	 * from io_task_refs_refill(), not just in-flight requests. Thus,
+	 * pending requests are present if the inflight count is larger than the
+	 * number of cached references.
+	 */
+	return percpu_counter_read_positive(&tctx->inflight) > tctx->cached_refs;
 }
 
 static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
-- 
2.47.3



