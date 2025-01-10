Return-Path: <io-uring+bounces-5804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A792A0937A
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 15:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2747188B9AE
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 14:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E425B38DD6;
	Fri, 10 Jan 2025 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDDU/U8f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C23D20E325
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736519457; cv=none; b=P1YJQOW8mQKZCCPeyCVbyap/LXAfDXqZL4wNjFAav12Az40FnE0OmyAVeHYn42so+VL0j7w/+yYLZa3zVDEf/FbXCyAssGnmlwwNRGqycJ5TSJe6htsVwgSiNWgySYp72UFP6ZxPFq+5rPtPGUksG1XznCpgw0dkID5ZN28+iZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736519457; c=relaxed/simple;
	bh=i/QSiINbs+sGIa9xd3Si2hlrIRflkFkwPtZLuW58OMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J41HtsCYy7pmsLtoWc7ERyTUAXPDmfo5b+hY7CWRdLbg3THPO8WNDtfrEyAdJVQgjSKQqbBZ1GT7tqy7i8dZKIaMPcGKUwL+EK+zEbDCGBfZzwiWZBDxfJpZ8TSIxY4OwCr0bJp+l6teflPdmaI9CL9qY1KYQBlUIPl+WiSQEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDDU/U8f; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d982de9547so3977596a12.2
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 06:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736519454; x=1737124254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XbEpAt4wWf/4iOReg9XXgb66MtBgn2Ixmw3dVb1/GJ0=;
        b=CDDU/U8f5cQRRagDhroyCwk77mEW0BJbtJay0iASrsatI/qr7dui1jMOnj4UdY86jH
         beg5q4OFBUFRFP+pY7Ycl1mCgnQbKCJRtufwj/lqKYcSBsgT08KH7QyZK5FYtwOIZgXF
         /2SgoRsfOJ/K1x9SLAOlf8/2qTRTwyV2ghYcyav6PmTsHq2waYE4OCz2COR+UUJZYla4
         Szw0YlM8u5FAEFBOniZHy/0huqIHSHgryLEXibJVGIiM+vCEpXDtp6/vkSORaPuk2IIj
         2u5ex16dPQIsVojhPwu3uT8emmyLmIGuzAyjP74pO1O2QqzXdvaRTAf38wHNa6haTTDD
         tD3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736519454; x=1737124254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbEpAt4wWf/4iOReg9XXgb66MtBgn2Ixmw3dVb1/GJ0=;
        b=tzRCqr/R7un/sd6fx5VE0ZVs/vuaQKmlPjdrPgIUv3xr8Tiv9xfUdehzWxJXEMj5Nq
         BuszbrBnKWZGVugsv1tpjxXQSQkGTITlF90dAKKQOHNl0LvUeZ7TNphPOyNvQ8UuZFgL
         G7B9G1HWbjf9rBlmj3QkgCAUbOtTxwItxjL+AJ0lOayJpuCMIuVd6v41lUYg2dZGnVr7
         WfNg4YnxPhGmoHtxT0FP1EDrbcPQxsStVQ2pCjQX6uVSaS2BboRtvShQUSLgTL2YEc3k
         xw75G3RAr5PyArlFT4PhY0WmPuMKiKLS5FCCHnyvqtX2bn2r1g051QEHxgfyED4XQ27r
         Krww==
X-Gm-Message-State: AOJu0Yz7j+uch4jv+fwERfbmjz2gQKkdw/2wSPk4ZByWVMuUeEkneYiC
	oX5Zw9rw4bhxI2uAFXf9H+zMSSuyPSo/WSj1IUvcX5QC6LdP9c2I+vqpNvkY
X-Gm-Gg: ASbGnctqGgpNJvPXz62fuuRgcoagZHcarebI13EE5jKKNDF8W/osYcqP+CqoKPiXOVJ
	AeLFVQl2DSVhbkusE6bUnUH5UNsMGaI5mrSnOditV5Ar4dP/lZGayYVyaDOZ4QeIUp4igeX2hl8
	LcXnBdxJA7znfMpOOl33uhbgg+nmhDfmivA4UxKBr5w3Go0Lt9tsY0XigeekqmRZvQ8HrvXGqJ5
	ilqbJolKu2cFvsuPv0pzxZKgt+z6Icxk1rps/La
X-Google-Smtp-Source: AGHT+IFtuvuDjTf7CoIXpY/RlG9O3ptMxGEBWbvsV7R5nLlyz/RW1SSOuoNbT9Pct/eNubZFK9jV1Q==
X-Received: by 2002:a05:6402:194c:b0:5d4:3105:c929 with SMTP id 4fb4d7f45d1cf-5d972e4786fmr9118865a12.23.1736519453893;
        Fri, 10 Jan 2025 06:30:53 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1552])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d99091e9absm1746775a12.45.2025.01.10.06.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 06:30:53 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
Subject: [PATCH 1/1] io_uring: sqpoll: zero sqd->thread on tctx errors
Date: Fri, 10 Jan 2025 14:31:23 +0000
Message-ID: <efc7ec7010784463b2e7466d7b5c02c2cb381635.1736519461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzkeller reports:

BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
 Call Trace:
  <TASK>
  ...
  kasan_report+0x143/0x180 mm/kasan/report.c:602
  thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
  thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
  getrusage+0x1000/0x1340 kernel/sys.c:1863
  io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197
  seq_show+0x608/0x770 fs/proc/fd.c:68
  ...

That's due to sqd->task not being cleared properly in cases where
SQPOLL task tctx setup fails.

Cc: stable@vger.kernel.org
Fixes: 1251d2025c3e1 ("io_uring/sqpoll: early exit thread if task_context wasn't allocated")
Reported-by: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/sqpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 6df5e649c413..5768e31e99b1 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -268,8 +268,12 @@ static int io_sq_thread(void *data)
 	DEFINE_WAIT(wait);
 
 	/* offload context creation failed, just exit */
-	if (!current->io_uring)
+	if (!current->io_uring) {
+		mutex_lock(&sqd->lock);
+		sqd->thread = NULL;
+		mutex_unlock(&sqd->lock);
 		goto err_out;
+	}
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-- 
2.47.1


