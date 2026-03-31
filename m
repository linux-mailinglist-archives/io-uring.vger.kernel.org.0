Return-Path: <io-uring+bounces-12893-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gN80ILuny2nJJwYAu9opvQ
	(envelope-from <io-uring+bounces-12893-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 12:53:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3573685F1
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 12:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 06AED30D7B1E
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 10:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924673A6F17;
	Tue, 31 Mar 2026 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KVdS+nve"
X-Original-To: io-uring@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6AE3A75B9
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774953955; cv=none; b=jZZzwP/CD3hN5QIVQthILEUKAtYNnw9q9tzv5SxZ6kImNv22kNc1h/13G45kd10UHW8QXKa+fb4Aic6Z110CuAq6isMXsVOihLUXbrfzNYiKebpPb5RxKRm3BbiX0QkgWcQPOoU5jV5cxhfl0OemWDDymm9MFamBSt6ilMc5pEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774953955; c=relaxed/simple;
	bh=E1Gl6Yl49L0nKHAgwB93XTG1rpwOhkzmXiKkNK5fiXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GKyS6lnqd2qK84Oc/NGVgT4VcBoMRG7Z8GVjaKHsDGjmSqoJ4JZjfkdA4RsWwJU8bO2QsUT57D40cQxBG+DzJUnKmApCPubadHZLofQXzQiCNVK61g7FmQsAekETucUVqBtMfeKTp4hJyhcG1tZtiPiWGbXAIpyjOt5p3+CFgo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KVdS+nve; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774953951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ozmKvfV5MwKH+2q2ONSWKSmXsp4MUdjhhmL+DEGfOLM=;
	b=KVdS+nvetoON3RJc8N2gCtFkt81YK0xBarU6T+cp7yt31fPDs///uCnfQABIHj9+0N+Omn
	FcjGV5EiOpDlkIGH8GzTNepu2q9mxmwg5ltrrSH3K/yo19uKGEQRa6z07GhVK2DK2wOVsq
	j18QOLpCVOO7HfYRX96y4sMCa2p9V3Q=
From: Jackie Liu <liu.yun@linux.dev>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: use io_cache_free() to free node allocated by io_rsrc_node_alloc()
Date: Tue, 31 Mar 2026 18:45:09 +0800
Message-ID: <20260331104509.7055-1-liu.yun@linux.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12893-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[linux.dev:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liu.yun@linux.dev,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DF3573685F1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Jackie Liu <liuyun01@kylinos.cn>

Replace kfree(node) with io_cache_free() in io_buffer_register_bvec()
to match all other error paths that free nodes allocated via
io_rsrc_node_alloc(). The node is allocated through io_cache_alloc()
internally, so it should be returned to the cache via io_cache_free()
for proper object reuse.

Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4fa59bf89bba..c4a7b29a327c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -961,7 +961,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	 */
 	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
 	if (!imu) {
-		kfree(node);
+		io_cache_free(&ctx->node_cache, node);
 		ret = -ENOMEM;
 		goto unlock;
 	}
-- 
2.51.1


