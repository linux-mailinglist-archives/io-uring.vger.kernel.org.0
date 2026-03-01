Return-Path: <io-uring+bounces-12488-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNcEFnqVo2l7HQUAu9opvQ
	(envelope-from <io-uring+bounces-12488-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:25:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D6E1CA7F2
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 547343022F7C
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 01:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84618274B42;
	Sun,  1 Mar 2026 01:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iURT7AFk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214813B7AE;
	Sun,  1 Mar 2026 01:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328251; cv=none; b=PDaTZy43zBN9KQzTi/Lhc1Llc7RW6h7padAq3lRxVTk9uXBz0gld/k1fXRohlCLVD77U68HNBUMsBOmgzdTITkGiJ/Lq4+/H21LY8hDoEh46TLxC6Gacl5sQ8OJQv1sACd3bvf0p2ZxW+JJArTOOYjrta7/gzvP0ms5Z4/XSy7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328251; c=relaxed/simple;
	bh=nBHyryKGDGsZacfYeyhHAa5VbbwgdXI6JjnY7WHB3y4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p7ygRy3heUpxkO30BsQb2YbxVLFRY2q2gFBTapeqmQ+1UH+hwdd6HtPzOuacpythwDpA0VfTOL2NdfQThiVVR6RpwRHtKGuwOlxGVTks7igQFhxDXVK8CYK1UFgVtPLUjpjuRHvXJCpzENd5x07SW68rmdLirPdxipGCzGO7/sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iURT7AFk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C49C19421;
	Sun,  1 Mar 2026 01:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328251;
	bh=nBHyryKGDGsZacfYeyhHAa5VbbwgdXI6JjnY7WHB3y4=;
	h=From:To:Cc:Subject:Date:From;
	b=iURT7AFkxYsImzDdMnjN1O4hKMKYV7GOs2WdeakO/cjEw63gNJUwthJQ0k95FPvjm
	 HvPSWw7J5eO70xjumVw+yBqWokzlPyAbk5ykJ5egfkFk+/boKYLyz1/ubzZqBAA1RL
	 OqeUfrbej5yec9Djx8kd16VITfUh8/JGa5PyJ5P3hq5nds5De5FMfaTz9oHoPFg7L6
	 DA9QOiSUdsZR+syFb1FBzPkJ4i6gS512P62gHY6hV3brdbK1QwbRC06slDZM/YF3OJ
	 lJtyyeYqCEZXM0gYa8JR0WxxhOVGRk04/h1n5/XbFT8LXGG/0rEjD3rNlcA/Kyd9Cp
	 QHpPDKEpSQ9bw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: FAILED: Patch "io_uring/net: don't continue send bundle if poll was required for retry" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:24:09 -0500
Message-ID: <20260301012409.1680931-1-sashal@kernel.org>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12488-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4D6E1CA7F2
X-Rspamd-Action: no action

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 806ae939c41e5da1d94a1e2b31f5702e96b6c3e3 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 27 Jan 2026 21:01:41 -0700
Subject: [PATCH] io_uring/net: don't continue send bundle if poll was required
 for retry

If a send bundle has picked a bunch of buffers, then it needs to send
all of those to be complete. This may require poll arming, if the send
buffer ends up being full. Once a send bundle has been poll armed, no
further bundles should be attempted.

This allows a current bundle to complete even though it needs to go
through polling to do so, but it will not allow another bundle to be
started once that has happened. Ideally we would abort a bundle if it
was only partially sent, but as some parts of it already went out on the
wire, this obviously isn't feasible. Not continuing more bundle attempts
post encountering a full socket buffer is the second best thing.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 519ea055b7619..d9a4b83804a25 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -515,7 +515,11 @@ static inline bool io_send_finish(struct io_kiocb *req,
 
 	cflags = io_put_kbufs(req, sel->val, sel->buf_list, io_bundle_nbufs(kmsg, sel->val));
 
-	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
+	/*
+	 * Don't start new bundles if the buffer list is empty, or if the
+	 * current operation needed to go through polling to complete.
+	 */
+	if (bundle_finished || req->flags & (REQ_F_BL_EMPTY | REQ_F_POLLED))
 		goto finish;
 
 	/*
-- 
2.51.0





