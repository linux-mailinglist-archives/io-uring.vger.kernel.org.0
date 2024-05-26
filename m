Return-Path: <io-uring+bounces-1967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C3B8CF365
	for <lists+io-uring@lfdr.de>; Sun, 26 May 2024 11:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A945D1F21B79
	for <lists+io-uring@lfdr.de>; Sun, 26 May 2024 09:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A73A3F9D4;
	Sun, 26 May 2024 09:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wco3Ll22"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213ED3F8F6;
	Sun, 26 May 2024 09:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716554; cv=none; b=q4s2vzCiQhtfJULvxtCOTYYAayxPVahSkTzynVCmjZ7zu8POCRh9Zda2x4fv7gOLmpXm9WPS632VsRzMJq5j2VtPG7SC/IqOlJCO3GAfisrTz8v6uhs1VGf5XYo8lkxyQhSi/DT/eg20lp/mOppzQYBiO+QEEaM1rIRqrJSoiMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716554; c=relaxed/simple;
	bh=JgenaFV+7nFpbALnZO+VIAqY0wsCGJI94ujw+zT+hmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUmQmv65L/uDkiftXq5q+QoLbdQMJmSOquu/l/UmEXjts0EkXsKi/YWC+5x3/2vZQADUoimDABEn/qCDxMW85hbqWQ618PqOHlnAke6Pi6USx8okgkwRgQuRKTTNQ+iXD8pxWgw3odG5eRODSCq1Huzk9rdxilLx9WAY4C7Nj+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wco3Ll22; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4E1C4AF09;
	Sun, 26 May 2024 09:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716553;
	bh=JgenaFV+7nFpbALnZO+VIAqY0wsCGJI94ujw+zT+hmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wco3Ll22w0jD5mIUiEXFb9ODC4O6ZlRPzWKQJD6LhVTWIMpLgM4ITvsXGrR4+73jw
	 55zaA38Oc5eAb5u/yYthVJi3cEnt85MVapzdIx9skRLI1spQ3LB7Ty8bNk2rld/R+3
	 7fTJdY3DlqHfBWj7cRg2rGilQS+iypsHs1XsH0/QCQRF9DrN0EJfvDo3bKVnLp/KC5
	 kgFSnLj76UppjWZIMIv0Y6Ik8z16NK+vQkJ5Gmxy5mL2zPtLjz4VJ6hM2qo4eRZ7Qm
	 zE4dVu5+/kxrfkdVwe1cUoFg+zZZzMan1Cdmpw85gBUmroTx6cfzWz4OHVG06oh8Dr
	 lpCGl5vhXqDcQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.8 06/14] io_uring/sqpoll: work around a potential audit memory leak
Date: Sun, 26 May 2024 05:42:11 -0400
Message-ID: <20240526094224.3412675-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094224.3412675-1-sashal@kernel.org>
References: <20240526094224.3412675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.10
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c4ce0ab27646f4206a9eb502d6fe45cb080e1cae ]

kmemleak complains that there's a memory leak related to connect
handling:

unreferenced object 0xffff0001093bdf00 (size 128):
comm "iou-sqp-455", pid 457, jiffies 4294894164
hex dump (first 32 bytes):
02 00 fa ea 7f 00 00 01 00 00 00 00 00 00 00 00  ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
backtrace (crc 2e481b1a):
[<00000000c0a26af4>] kmemleak_alloc+0x30/0x38
[<000000009c30bb45>] kmalloc_trace+0x228/0x358
[<000000009da9d39f>] __audit_sockaddr+0xd0/0x138
[<0000000089a93e34>] move_addr_to_kernel+0x1a0/0x1f8
[<000000000b4e80e6>] io_connect_prep+0x1ec/0x2d4
[<00000000abfbcd99>] io_submit_sqes+0x588/0x1e48
[<00000000e7c25e07>] io_sq_thread+0x8a4/0x10e4
[<00000000d999b491>] ret_from_fork+0x10/0x20

which can can happen if:

1) The command type does something on the prep side that triggers an
   audit call.
2) The thread hasn't done any operations before this that triggered
   an audit call inside ->issue(), where we have audit_uring_entry()
   and audit_uring_exit().

Work around this by issuing a blanket NOP operation before the SQPOLL
does anything.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 65b5dbe3c850e..350436e55aafe 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -240,6 +240,14 @@ static int io_sq_thread(void *data)
 		sqd->sq_cpu = raw_smp_processor_id();
 	}
 
+	/*
+	 * Force audit context to get setup, in case we do prep side async
+	 * operations that would trigger an audit call before any issue side
+	 * audit has been done.
+	 */
+	audit_uring_entry(IORING_OP_NOP);
+	audit_uring_exit(true, 0);
+
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
-- 
2.43.0


