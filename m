Return-Path: <io-uring+bounces-7837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F30AAA5B6
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 01:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7FE9188D777
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 23:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C637315FB1;
	Mon,  5 May 2025 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czGF6xSQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F848315FAB;
	Mon,  5 May 2025 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484251; cv=none; b=bToUXq+zftK3N5QhFaGANPlt+2bCKP0/+ivfsjEKrhc5tuvkB67kNPq8VnuodDrRPtbIM1vsFApV2Av4rN4YY0GURR7BMmOvQ7LrJ+/FUI87TaP7hpZrlFgwcVfl3dkdaxpkIuLYwwKmgUcrhzZ9VRck3YOrG5P66rPgeKuVwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484251; c=relaxed/simple;
	bh=loTJ5DJF4JJVQC8r51AXErWlY78aV8+JQ6HsvoiNgCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RrZ1WB+quIc0x5Pn8G/UKYuBFxN4Ahl7R0uMbQvW4d/MRmk2E7SqXd/45ROkPlJ7yUri2J6Cd5zN/B45rsOfsfZYutXZkm7FWRM49Wd8l5XE4k0M0I7D9R+Gbk8fEFZwqQdxHchiInI7MPrKpM9+y9Nec7EMNkHxguc6MwpunoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czGF6xSQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CB2C4CEED;
	Mon,  5 May 2025 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484251;
	bh=loTJ5DJF4JJVQC8r51AXErWlY78aV8+JQ6HsvoiNgCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czGF6xSQ8o6tz3XVy7oOmq9u/MhCsR2cYACqvwbLhpymxl/3gze4+7Pp/0OcIpbJD
	 9BNOqT4ulJM9epSOR9EK3yRYpdjk5cWX7MmHunqLaWY3vxY4Z/qOwD/XkUpUOv7PHb
	 5G3ip5pqVBC2/AAZN/my1w097N3ghXfDZMgWFNWexRl0/C1r5Y8q9SmSnYJOUxyFVL
	 dA454BQN7zUldmklA9mVd6OuXSgmBBOOSTdi2HTRb7o8Bb5Vqy7scUR9mbn/DM4jRU
	 VJVtFjlv1ltQ+snRy19hRk80++sg+WPBWiAtXuhAERdESsQgMuw9hzd9LGNpYqETYx
	 Tg+qed7VcwZ4Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 412/642] io_uring: use IO_REQ_LINK_FLAGS more
Date: Mon,  5 May 2025 18:10:28 -0400
Message-Id: <20250505221419.2672473-412-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 0e8934724f78602635d6e11c97ef48caa693cb65 ]

Replace the 2 instances of REQ_F_LINK | REQ_F_HARDLINK with
the more commonly used IO_REQ_LINK_FLAGS.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://lore.kernel.org/r/20250211202002.3316324-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 24b9e9a5105d4..96c660bf4ef59 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -110,11 +110,13 @@
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
+#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
+
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
 				REQ_F_ASYNC_DATA)
 
-#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
+#define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | IO_REQ_LINK_FLAGS | \
 				 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
@@ -131,7 +133,6 @@ struct io_defer_entry {
 
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
-#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
 /*
  * No waiters. It's larger than any valid value of the tw counter
@@ -1158,7 +1159,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	 * We don't know how many reuqests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
-	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+	if (req->flags & IO_REQ_LINK_FLAGS)
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
 	guard(rcu)();
-- 
2.39.5


