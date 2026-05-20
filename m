Return-Path: <io-uring+bounces-13459-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONZBFBb7DWrO5AUAu9opvQ
	(envelope-from <io-uring+bounces-13459-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:19:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 11844595C9C
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 20:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 26E8430E9B84
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 18:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3842D3A3E79;
	Wed, 20 May 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b="n8X3g2ZU"
X-Original-To: io-uring@vger.kernel.org
Received: from mta.al2klimov.de (mta.al2klimov.de [162.55.223.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148E33F4DC0;
	Wed, 20 May 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.55.223.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300061; cv=none; b=QlFH0lUwWidef11hBKsTFfxV0pc98YFLxrgFqKiTxVY42IE5vBUAx40A8uc9Yk19jPcQLWmptc4WkvJeU06o8+u0xJ8t2IjV5kDQ5qVl638ySmo/8fOkxxD6xsoGn1fRkgrabflBI/Rm2yZcaJq8+vlpOz//PoW1hF45FBPKnWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300061; c=relaxed/simple;
	bh=6ecsCMsxlfuBrGJ9K/XozOYSjef/olTbV6t7984eiC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMuowoZIhI1fB1UXHBVNE4VrXg5oeYx7HKKo+UxFBJ2TBS5BHy/LeZRe9iPvJOrsR77pHek3hMBZKiZuj9nj2w6TFADan4NMDw3P5DCA0IqLDu4s23fRMZHHEDI3/agPn6dkr3/z6z82LjXPPet4yMjwo3wJzCdSROutjOtV7eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de; spf=pass smtp.mailfrom=al2klimov.de; dkim=pass (2048-bit key) header.d=al2klimov.de header.i=@al2klimov.de header.b=n8X3g2ZU; arc=none smtp.client-ip=162.55.223.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=al2klimov.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=al2klimov.de
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=default; bh=6ecsCMsxlfuB
	rGJ9K/XozOYSjef/olTbV6t7984eiC4=; h=date:subject:cc:to:from;
	d=al2klimov.de; b=n8X3g2ZUN8UseDwRo+dJSxMXJNzkImkJE6DpeUrwbJ2gRas8NQzR
	I98zPuUBUkfJpV3+Ta5Cf3SFnqOHDYiD36y0eYVxaCBJhCKaKzPLGrECd/DHiwkEBkC+EZ
	rF59l1WepAxflHZczveXp+xh5PnK/wH2N8NufnD/6o634EcQMv8TDDAcvUGOga9td04fr4
	fkU3QeymuRlD8TDstX+L8/UMHexIdrQs22J0nzlHU0LVCeDXEmdf+4dfICLdqjjNxlAUMy
	YWnhSvzfy9tb73lE7/OoKxKOCJa8dgAoI/3zbQeJBiBhTfEgrXLD/zLysUF0u4fnu2eQUf
	OfP1E0wByg==
Received: from cachy-ak (2a02-2455-18e9-e011-4d8a-aad2-c25c-50e5.dyn6.pyur.net [2a02:2455:18e9:e011:4d8a:aad2:c25c:50e5])
	by mta.al2klimov.de (OpenSMTPD) with ESMTPSA id d623d0dc (TLSv1.3:TLS_CHACHA20_POLY1305_SHA256:256:NO);
	Wed, 20 May 2026 18:00:57 +0000 (UTC)
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org (open list:IO_URING),
	linux-kernel@vger.kernel.org (open list)
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] io_uring/nop: pass all errors to userspace
Date: Wed, 20 May 2026 20:00:44 +0200
Message-ID: <20260520180045.538533-1-grandmaster@al2klimov.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[al2klimov.de,quarantine];
	R_DKIM_ALLOW(-0.20)[al2klimov.de:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13459-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[grandmaster@al2klimov.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[al2klimov.de:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[al2klimov.de:email,al2klimov.de:mid,al2klimov.de:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 11844595C9C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This fixes an inconsistency where io_nop() called req_set_fail()
based on ret, but passed just nop->result to userspace.
Originally, ret is a even copy of nop->result, but is set to an error
when such happens subsequently. Now that's also passed to userspace.

Fixes: a85f31052bce ("io_uring/nop: add support for testing registered files and buffers")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 io_uring/nop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/nop.c b/io_uring/nop.c
index 3caf07878f8a..f5c9969e7f64 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -79,9 +79,9 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	if (nop->flags & IORING_NOP_CQE32)
-		io_req_set_res32(req, nop->result, 0, nop->extra1, nop->extra2);
+		io_req_set_res32(req, ret, 0, nop->extra1, nop->extra2);
 	else
-		io_req_set_res(req, nop->result, 0);
+		io_req_set_res(req, ret, 0);
 	if (nop->flags & IORING_NOP_TW) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
-- 
2.54.0


