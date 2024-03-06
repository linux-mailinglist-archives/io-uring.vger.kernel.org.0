Return-Path: <io-uring+bounces-834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E506D87325E
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 10:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F3782915DC
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 09:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303085D91F;
	Wed,  6 Mar 2024 09:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1QU0lc4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5A1426B;
	Wed,  6 Mar 2024 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716781; cv=none; b=X/KQLWYZ0PMHNQ4lapEGJR3Jrd1b1Z8xYvR5CeTWGw+CumH+8gBzWJb+24b7bqZQWFfT8qJF6XLuTKQ4/cZaMZ8QBxyJ4gnOUldQLok49m+JsafmmsQ5eBip0iIihauaBoaHvHjopQEbM+mkIyIGbRFjlx79tfD20Ww5cwsE3bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716781; c=relaxed/simple;
	bh=P/9E+9Wao7oLG3ZlbYvcTCGHeDQh/bPyn+jnVILfdGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3Df2JKGtEH45F0pHpoU5r+crq1HSUCAEjT2I93Fg+4JyOuExb2g5+MhxOYamg7HrYS6/v8Exqk8mB+00iYyOypKi2yCuHGzIi1bQODVmCHsZVdVlSEXMGVJ6FZM2o2ffQjhaOiFSAeevZ13aVtxnT6JNXZkafkNyqW9Z64SkJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1QU0lc4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC659C433F1;
	Wed,  6 Mar 2024 09:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709716780;
	bh=P/9E+9Wao7oLG3ZlbYvcTCGHeDQh/bPyn+jnVILfdGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1QU0lc405a2IlXgbXGhhwkpo1Ev0xUHOwNgeY/d1Nf/mApwFcdQxpRrHdGvwqC4r
	 9KpUk9IJDzXU3dt7PuFxNBhM56CS0a5ctbNLSD19ZtFDLhhsQJzKBdVbBOaf6G5mWu
	 NJrFca/PaAoFTjUW256n+VwOwMwsEBT5ikBhbw4ym6ZG7GbRHmY3vKWyeQpHaXb6m0
	 NFebnh8Kr5tklt81XXK2AHnztoAXbD0OoFl7zdr3SAvmX3v/v3CUZQUyL7z3f2N7e/
	 MYZhRXXAjX/3aCeoZ+mCnYJrZwdAcei+PSx3k2RgmZl0PgvdxYNP70FFTDm6BySDA/
	 QYMYovR1bVZ7Q==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: io-uring@vger.kernel.org
Subject: [PATCH 2/3] fsstress: bypass io_uring testing if io_uring_queue_init returns EPERM
Date: Wed,  6 Mar 2024 17:19:34 +0800
Message-ID: <20240306091935.4090399-3-zlang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240306091935.4090399-1-zlang@kernel.org>
References: <20240306091935.4090399-1-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I found the io_uring testing still fails as:
  io_uring_queue_init failed
even if kernel supports io_uring feature.

That because of the /proc/sys/kernel/io_uring_disabled isn't 0.

Different value means:
  0 All processes can create io_uring instances as normal.
  1 io_uring creation is disabled (io_uring_setup() will fail with
    -EPERM) for unprivileged processes not in the io_uring_group
    group. Existing io_uring instances can still be used.  See the
    documentation for io_uring_group for more information.
  2 io_uring creation is disabled for all processes. io_uring_setup()
    always fails with -EPERM. Existing io_uring instances can still
    be used.

So besides the CONFIG_IO_URING kernel config, there's another switch
can on or off the io_uring supporting. And the "2" or "1" might be
the default on some systems.

On this situation the io_uring_queue_init returns -EPERM, so I change
the fsstress to ignore io_uring testing if io_uring_queue_init returns
-ENOSYS or -EPERM. And print different verbose message for debug.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 ltp/fsstress.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 482395c4..9c75f27b 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -762,12 +762,23 @@ int main(int argc, char **argv)
 #endif
 #ifdef URING
 			have_io_uring = true;
-			/* If ENOSYS, just ignore uring, other errors are fatal. */
+			/*
+			 * If ENOSYS, just ignore uring, due to kernel doesn't support it.
+			 * If EPERM, might due to sysctl kernel.io_uring_disabled isn't 0,
+			 *           or some selinux policies, etc.
+			 * Other errors are fatal.
+			 */
 			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
 				if (c == -ENOSYS) {
 					have_io_uring = false;
+					if (verbose)
+						printf("io_uring isn't supported by kernel\n");
+				} else if (c == -EPERM) {
+					have_io_uring = false;
+					if (verbose)
+						printf("io_uring isn't allowed, check io_uring_disabled sysctl or selinux policy\n");
 				} else {
-					fprintf(stderr, "io_uring_queue_init failed\n");
+					fprintf(stderr, "io_uring_queue_init failed, errno=%d\n", c);
 					exit(1);
 				}
 			}
-- 
2.43.0


