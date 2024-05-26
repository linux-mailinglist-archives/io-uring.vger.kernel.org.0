Return-Path: <io-uring+bounces-1966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E55EA8CF33E
	for <lists+io-uring@lfdr.de>; Sun, 26 May 2024 11:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 218FA1C21238
	for <lists+io-uring@lfdr.de>; Sun, 26 May 2024 09:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC6B8F77;
	Sun, 26 May 2024 09:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhqicgXN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8142115AF9;
	Sun, 26 May 2024 09:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716522; cv=none; b=XlFflFUyv3pt8OjiIe9KFgH0j/7mQCtvPfitwqS/V6AtVpi9NJMAiLtqfcvy28MXHgHGHih3oKgDoakuvd/ONRavNu9uWtRSOCDL2KMw7bjlUh1ZtOzP5k9N4v6PG/hiQ4z5HFnvYMDYB9y6s3tKJJmBzR/28RsDfCAU22Kprxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716522; c=relaxed/simple;
	bh=sPOMEAkL3Aby6H8ykdeGQpllNQzYaZBxOLlMe/5uBD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwQY6m4zMPpCptjNtKq4lfE/xzh2shXYDHpnTJC82THsH9sn5LGVIlTgPppKxMD4gKPUZwAn78WNvpiiUCF/ZR80bavTpnhdSH27W8iXYfKxULrb/g1No555C8Ml/vU7zcIjt1IH/ENFnfpeYdTMajSLy2NqtBw4nAY1Vbxj1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhqicgXN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610EFC4AF13;
	Sun, 26 May 2024 09:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716522;
	bh=sPOMEAkL3Aby6H8ykdeGQpllNQzYaZBxOLlMe/5uBD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhqicgXNlaS5s+qjh6lGsFS2LyrULmUZ2tyQGFQ5La7SwuiphrTEt02E6oNuA3Yfv
	 g3uI9kJc6sY6zYvzYgAR0/AKSqrxESlS4Gu46UFtQYQiVJIU8+zO7/kTYnrM59f3UR
	 SQaS/Rzqj9X69cZZxNHczfQyWSQxe9uxWgNRMATIelu7tQAMwBOViy0Qlw41Or4mNi
	 7/EahQZnhsf/Vs5bRluU2KYqksevPnCsC9RlhSdWptrda86gJgO40GxexzRcGbA1mV
	 5/WxzctkTh+EC1kC700w11dWLdHKWX7x0ezYN4S/fInkpBG91Oc5sXvSFtGGnkdMe7
	 UkWZtY6hFk4AA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 06/15] io_uring/sqpoll: work around a potential audit memory leak
Date: Sun, 26 May 2024 05:41:38 -0400
Message-ID: <20240526094152.3412316-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094152.3412316-1-sashal@kernel.org>
References: <20240526094152.3412316-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.1
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
index 3983708cef5b4..554c7212aa463 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -291,6 +291,14 @@ static int io_sq_thread(void *data)
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


