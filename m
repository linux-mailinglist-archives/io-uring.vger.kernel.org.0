Return-Path: <io-uring+bounces-12489-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECrLJ5yXo2lIHwUAu9opvQ
	(envelope-from <io-uring+bounces-12489-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:34:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9795A1CAFE6
	for <lists+io-uring@lfdr.de>; Sun, 01 Mar 2026 02:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AB44C302FAA3
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2026 01:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA8E28851C;
	Sun,  1 Mar 2026 01:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcFAGKI/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98102877DE;
	Sun,  1 Mar 2026 01:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328489; cv=none; b=T8SPdbzBWgQDJ6AWXVcCq2cwrWCOy28J0hT/hAMI35Ga8pSet8RLPa25YaGCjHo7JXAmGsMet5taE0oTDJj+Y+bxbimUIj4Y3JtKBE6p8JTBYkA/F+7C74eCdo7P3wCgIiZcjxZPoyQ+I5zcx4/v1M7zAMQI+ZHNRvXYzn9y8z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328489; c=relaxed/simple;
	bh=2w0HPfexbY4dq5Qg3k8bdALRpWhha4BW8mi1TpCOj1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n3fkAUw1Nezh+23sVXvk0HDLGNx+O0CtkaDxKa578CbLFagUjyT27wBheipmBrXh0tUNxv1SKLoZs6gNncwqVjkB/zmdsuNaYEjghOXkeEWw54PsDzq2y1QJ700jpvBcYsoFEkH5ZI0R4FBSC/AFSee+BBJ5a5xGsayEnC4PMgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcFAGKI/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25907C19421;
	Sun,  1 Mar 2026 01:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328489;
	bh=2w0HPfexbY4dq5Qg3k8bdALRpWhha4BW8mi1TpCOj1g=;
	h=From:To:Cc:Subject:Date:From;
	b=YcFAGKI//IMAa+Pt7CI5Jz5KAwshnCjoj5H8F6ihG69VAW5q8Tze+HikWXIil/zgj
	 E8vzu29oOf98IbB9t9PT65zYMwNby6ERcLoTXwJFoySbFRHnNAbcP1df/4Sz96kIh7
	 HVlCI9kWYTF6mh9CHFkmOenko1GfO9pgOEJaC6UQkxT6iBPi4fdCuDi8ZaNAcjGz8h
	 2sjAELKwxNexnlJkn3MkPUB0RMyTFUHtsT8o0BbdiOZ2uu6Pce8fc7xjn4y7fFFgjl
	 4Ft6SwIv8IbndkVRt079E5lQRTu8aJkkD/W6ZbH+qPvMRqD2yk0cRWIw2/pjG4mYPj
	 kuysI3R+bWytA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the configured alloc range" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:28:07 -0500
Message-ID: <20260301012807.1685821-1-sashal@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-12489-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 9795A1CAFE6
X-Rspamd-Action: no action

The patch below does not apply to the 6.12-stable tree.
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





