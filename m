Return-Path: <io-uring+bounces-2177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 093DF90530D
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 14:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD3F2813C0
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 12:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C9A175552;
	Wed, 12 Jun 2024 12:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhtsnpXu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C89176242
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718197013; cv=none; b=MAxbxhQl49QJgGEWcsVRotJSDSjz7O/ezVzK2imneKZoFIKHLt0h2TkF5ee5HdTseMdGj4mTflxumLv+naeqxiWt31BVCFkVulgLWlzP2WUg9rZf21VG3piPpn1cGo4Nh7/OG0xlG48mDIAf/mvVbw7KDFv73C8cx74+4SjYRfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718197013; c=relaxed/simple;
	bh=CEur3wvU6QNmtGIb3He0HdL9zkuKHmDM3C8aWpqxMtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J/Z0eog3XJt2xApmFLisjT/dy/1xAw+UB/gOcVY4gOMFszOIrLn0qtXMOduGJGhqNB4JOIzZwx6khji6vpnr+4/1wg2srSf1p0HkP9S+z8Pkn5KTRAXT2P9M7cjH4zsWlqSDAJFDzwAxz2lqZnuQ4dGh+8iI/g32ucRckr5lYpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhtsnpXu; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57c61165af6so6322117a12.2
        for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 05:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718197010; x=1718801810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6q9pTSHawO1g4U4R+XQkGwkNWPTnwIMsTzabcgO/suM=;
        b=ZhtsnpXuNG2ZQSjSV7e2LbmHsGQJU1nFDx5sJKFIsbner6OGgDoEGZdApxIDFHZtrM
         Trg+A6kwwaOTC5VFsR8iGwdc/Ku3VNySgp0oJ0ydQfxF3squyyjcvyDNkUp7O0CiOYaM
         K9XxOZE5ZEDiW5MeVPqEdJET2Vc0+b7zOjiMZus/g/TjPMcACJMmYSYcBY7CF1zPtfFu
         AVH+FWeVAsOhQSW4y6frXk4iPxfI3Knyua1VkntavT++chGv9llOjNibzmzprueCnr9W
         wQaTgsCYW4pk9Ym6LCD0TKX6p2VC0rtvjgdWWUAjCO2xWilHbkiK6UlfwQ3qcp4ap8V6
         yKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718197010; x=1718801810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6q9pTSHawO1g4U4R+XQkGwkNWPTnwIMsTzabcgO/suM=;
        b=c1TVh5HSVGUhDcAPmskFat+1jnnP3RISbW3nwdNyZjgH4qmKwg0+HGLXBhFxMYY98p
         6d5xHw7+xnsIpJUEZftzxb5Axhwe06Ney21gTh5AxUzdFPhVGc17YUme1TLCGqAQ6eT5
         PlWJCtpjK30jrae4a0Jmx0q7rrxsk43CEu2Uko/EcCR7pthtqppvWsxBJc5J34NfIMAW
         cXuzALsyILeuDgbBijdEuweKcaEWwh55NU7NDjYCtpLY8tBwO17RtMnvyqXiNAgWv5sr
         7zdR9QvvsKhq7fDr0EFkqHLDy57QZ3BC1h1qUz2MpawmPjOT3xSxMQEJM2iEvS5xK8oY
         nU0Q==
X-Gm-Message-State: AOJu0YymviOWDIUySHWE/UQTxVYImR0wZZjE7FIedBraUMXvIZiZ5tPd
	0o3to6thaPHLMbENZ0EfIi1oEgB8CSO5R457unWWGEIVZXcrRWPeg0HclA==
X-Google-Smtp-Source: AGHT+IH8MP9R6VEdhXN14j9D+/g9FPPEhP6TbBlAVysI0W4Yxg1hN1Lpwjmrawhm5NgHWQZbMeDYdg==
X-Received: by 2002:a17:906:2c45:b0:a6f:1893:f549 with SMTP id a640c23a62f3a-a6f47f7ff70mr93338266b.28.1718197009844;
        Wed, 12 Jun 2024 05:56:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f1b2f674dsm431323266b.204.2024.06.12.05.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 05:56:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH] io_uring/rsrc: don't lock while !TASK_RUNNING
Date: Wed, 12 Jun 2024 13:56:38 +0100
Message-ID: <77966bc104e25b0534995d5dbb152332bc8f31c0.1718196953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a report of io_rsrc_ref_quiesce() locking a mutex while not
TASK_RUNNING, which is due to forgetting restoring the state back after
io_run_task_work_sig() and attempts to break out of the waiting loop.

do not call blocking ops when !TASK_RUNNING; state=1 set at
[<ffffffff815d2494>] prepare_to_wait+0xa4/0x380
kernel/sched/wait.c:237
WARNING: CPU: 2 PID: 397056 at kernel/sched/core.c:10099
__might_sleep+0x114/0x160 kernel/sched/core.c:10099
RIP: 0010:__might_sleep+0x114/0x160 kernel/sched/core.c:10099
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:585 [inline]
 __mutex_lock+0xb4/0x940 kernel/locking/mutex.c:752
 io_rsrc_ref_quiesce+0x590/0x940 io_uring/rsrc.c:253
 io_sqe_buffers_unregister+0xa2/0x340 io_uring/rsrc.c:799
 __io_uring_register io_uring/register.c:424 [inline]
 __do_sys_io_uring_register+0x5b9/0x2400 io_uring/register.c:613
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd8/0x270 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x6f/0x77

Fixes: 4ea15b56f0810 ("io_uring/rsrc: use wq for quiescing")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 65417c9553b1..edb9c5baf2e2 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -249,6 +249,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
+			__set_current_state(TASK_RUNNING);
 			mutex_lock(&ctx->uring_lock);
 			if (list_empty(&ctx->rsrc_ref_list))
 				ret = 0;
-- 
2.44.0


