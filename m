Return-Path: <io-uring+bounces-12018-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Mp0BJy3gGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12018-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:41:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA9ACD7C7
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:41:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 344493058A9B
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 14:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B9636CDE4;
	Mon,  2 Feb 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="PyzmL/6b"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F85636EA86;
	Mon,  2 Feb 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043101; cv=pass; b=sBE1yF4+WeLSfz42FU94IeUw8B07fIWKN0YBGe7TWbX9JxSMdJ43gXNDFTcBtr/bMh+RqsADXTqIdI/JnQaOZKAcJTiZ9R+NqXSYBmXwWBq3y8qI+3LSKJf6olCfROeyExSQHUammdn4ZrQXCz4EWQwYUaYIE+zHbwn6aZB5UeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043101; c=relaxed/simple;
	bh=QHouRrP6FFresoZbKFhCOEhUe0MrJjpP1pSNtu2pD6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mol1/8AKkmKrFLgvtiveyMlHxRLcocZve1ngfQed3qPklfie7Qu65wx5jHqPkVcnFlPP1fCqtE/Ja3E5K5tz0N1qahQUEtGGJi2rMjft8asVkRHyDv+GNDbHGw3pstd58MDbNQaLmtZ4H12JF42zc3K/v9Q8XHEK/onrsheyYmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=PyzmL/6b; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1770043093; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BS2tFstNwO/AaciPwzaIzxMtQKqoTYEAiGUaPDqIFoLqdKNHzGU/swbKGHWmqANgzzTK7xGz6wV3oYrNP0gvtU5uaNfMcWmDIdFdm32FJyHB/nhwOG+zS/eYEH/CbmrVTFZ5CqYCCVIJLdjKmBz5GE7YZbaFJaLcCS66ngrYg0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770043093; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=r4QVaXC5LH/PfYlCEDiQK9HiWvYlklg3FPXPzc5XPcs=; 
	b=G2l7dDSCJj28OSmZY90w3PcMzZKyZn4DPxBnWg/R3yijoss7ESgh4X/gz3J7FOY0KGueX8/HE8SbyjtLyDcM6nmkAVLbTZDvrbk4h1ogcXZSxtWyZW83g9zMJd6OgS4tZuYte2gzOzrs+EsDXAsmT5mmtZOSdvciX1GwVLhVySs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770043093;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=r4QVaXC5LH/PfYlCEDiQK9HiWvYlklg3FPXPzc5XPcs=;
	b=PyzmL/6bx1ffk1pOazIrIykYvpinmv2b8BuRgGAb9UjHifQDLiJgNCs9lcWlubZN
	fhsMN67+nUEfcTZ2CQwjkCyKSGkP2K/h4vO5y29u7xUm22r0DxRGiZazzLjonu+WNZo
	VfER6dAaeSTPtgS/efty8YKhE8dAi9JuuCYb1uwU=
Received: by mx.zohomail.com with SMTPS id 1770043091242433.6198300164226;
	Mon, 2 Feb 2026 06:38:11 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH v1 2/2] io_uring: allow io-wq workers to exit when unused
Date: Mon,  2 Feb 2026 22:37:54 +0800
Message-ID: <20260202143755.789114-3-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202143755.789114-1-me@linux.beauty>
References: <20260202143755.789114-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[linux.beauty];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12018-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[linux.beauty:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.beauty:email,linux.beauty:dkim,linux.beauty:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7AA9ACD7C7
X-Rspamd-Action: no action

io_uring keeps a per-task io-wq around, even when the task no longer has
any io_uring instances.

If the task previously used io_uring for file I/O, this can leave an
unrelated iou-wrk-* worker thread behind after the last io_uring instance
is gone.

When the last io_uring ctx is removed from the task context, mark the io-wq
exit-on-idle so workers can go away. Clear the flag on subsequent io_uring
usage.

Signed-off-by: Li Chen <me@linux.beauty>
---
 io_uring/tctx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index adc6e42c14df..8c6a4c56f5ec 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -124,6 +124,14 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 				return ret;
 		}
 	}
+
+	/*
+	 * Re-activate io-wq keepalive on any new io_uring usage. The wq may have
+	 * been marked for idle-exit when the task temporarily had no active
+	 * io_uring instances.
+	 */
+	if (tctx->io_wq)
+		io_wq_set_exit_on_idle(tctx->io_wq, false);
 	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
 		if (!node)
@@ -185,6 +193,9 @@ __cold void io_uring_del_tctx_node(unsigned long index)
 	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
+
+	if (xa_empty(&tctx->xa) && tctx->io_wq)
+		io_wq_set_exit_on_idle(tctx->io_wq, true);
 }
 
 __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
-- 
2.52.0


