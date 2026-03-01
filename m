Return-Path: <io-uring+bounces-12492-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KMu6Bvaqo2nfJQUAu9opvQ
	(envelope-from <io-uring+bounces-12492-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 03:56:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BE711CE144
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 03:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B405E33812DC
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 01:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E37D2FC876;
	Sun,  1 Mar 2026 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MisbyojQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEBB2EC083;
	Sun,  1 Mar 2026 01:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329639; cv=none; b=uWnW5GZ+xpLrHTSbneSbrS2EYtXZDxWuAqk9+L9pXlEQu254Hj3Lv2t7v+Gf12IZifu7eOq7avJ8D96SknRoPlcSwY5Kp2tsi9s35W7r1JR57ekm3CVCauhKGIPpg3AjRY1IC0Kvis5EKqfcKP3h5c1+KhSl4SHQPVONTn39gQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329639; c=relaxed/simple;
	bh=YpZgkIEmbHtyFjnohKy1J0DGRQewUn5724u575rm0U0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hnh6GstjNAJzB7SFibCgUaRxRQV6nfy6ewuOZpuB94bqMMeGdf+2E/UfW2VSmoA8Co2eXhOReYIh1yApCYq1Bb8TKZw36fR0mwRYwgEcavgjjriihEGgio25WNk1Evfrl85WNdsKhgouJVxD1Zl5movL6pTSe4YhKsD6cnNx7do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MisbyojQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A05AC19421;
	Sun,  1 Mar 2026 01:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329638;
	bh=YpZgkIEmbHtyFjnohKy1J0DGRQewUn5724u575rm0U0=;
	h=From:To:Cc:Subject:Date:From;
	b=MisbyojQ34DnvvXPZTqAFTcKbdkyiQ81pHg1ZqWjFOhKQinveIEx+0r+bkOea7XON
	 XckYip0eZv4U+1P2EiVyGW2hsbqpX4JENlyelRMMDA4PQhzFjjK9auWfy0FSmfFvyB
	 oBqCyiFGDdNk+GLHpx3cQbfK7HlPw1wnsYemVG+ZNdXcz7Ei1ljqFSew4b8GB2IT47
	 xGZZkD50ppS0E+O6vpcBxlPAuPk2WsCxYbikyiLygXhfT8Sm75lCzhfqUD69PjuQqQ
	 RSV9+4kMDxWvU6s31kzl2KsXELXZ4Ntb98gn25oztfkXfZ/16FCrZapV1GkHjFfYYX
	 uxzJmJtIEPdTg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the configured alloc range" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:47:16 -0500
Message-ID: <20260301014717.1711200-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-12492-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 6BE711CE144
X-Rspamd-Action: no action

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From a6bded921ed35f21b3f6bd8e629bf488499ca442 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 11 Feb 2026 15:12:03 -0700
Subject: [PATCH] io_uring/filetable: clamp alloc_hint to the configured alloc
 range

Explicit fixed file install/remove operations on slots outside the
configured alloc range can corrupt alloc_hint via io_file_bitmap_set()
and io_file_bitmap_clear(), which unconditionally update alloc_hint to
the bit position. This causes subsequent auto-allocations to fall
outside the configured range.

For example, if the alloc range is [10, 20) and a file is removed at
slot 2, alloc_hint gets set to 2. The next auto-alloc then starts
searching from slot 2, potentially returning a slot below the range.

Fix this by clamping alloc_hint to [file_alloc_start, file_alloc_end)
at the top of io_file_bitmap_get() before starting the search.

Cc: stable@vger.kernel.org
Fixes: 6e73dffbb93c ("io_uring: let to set a range for file slot allocation")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/filetable.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 794ef95df293c..cb1838c9fc377 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -22,6 +22,10 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	if (!table->bitmap)
 		return -ENFILE;
 
+	if (table->alloc_hint < ctx->file_alloc_start ||
+	    table->alloc_hint >= ctx->file_alloc_end)
+		table->alloc_hint = ctx->file_alloc_start;
+
 	do {
 		ret = find_next_zero_bit(table->bitmap, nr, table->alloc_hint);
 		if (ret != nr)
-- 
2.51.0





