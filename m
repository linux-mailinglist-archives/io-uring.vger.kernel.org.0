Return-Path: <io-uring+bounces-1485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7085C89E7C8
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 03:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE7551F23B48
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 01:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A58EC2;
	Wed, 10 Apr 2024 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LH8dTDMB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EDDEDE
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712434; cv=none; b=W12BK4a5dcOxsM/mIZDDLkhKJwcN2R7PN4T1akPwuDyrqDPqOeEjPmhTNYN5rp952AYNOZETW9gEBc+g5MQM6cJVLBW2osKUxloehHMg3BFB4Lkwv7Ka1FQASRp8F2BocfPpTECcVKkdVcGCFZ1pdroc1ym2XuoYsSIPVSkztng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712434; c=relaxed/simple;
	bh=+cFsA4uEa4mfUPDhX0Ql+HKvPY8/JsBHl53sJDVBfEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJRvaIHLbhtti3ue3nj6JgSvMMj42k1Jsl2HO2EPN4CoKO7iXZiH26lDsZz88E0+e70OiQTU4TjswvGlg9zBz60CypczXZo854fLuM8jrB8bXQjxOdAWnK5S4CT5eUGMmR1JO/m/Lk0j3I/rqY4fnxnsrl3voOD6CFH0MhoeSqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LH8dTDMB; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-343bccc0b2cso4520507f8f.1
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 18:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712712431; x=1713317231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/0EWDa/dNkvJHojCTHVu+tnL215oLyOWobFjajXkfk=;
        b=LH8dTDMBYbDDtGVzyJfEnsOw7jgyT1Vom0gPhlsCwgZ/h6m0X8K0CzKNiWvbd55wSu
         uDSC70sP4kM9NDqsgViX2dDDO/SBVmV0+DKaLmYQQ//Flg+mavv7j/XMlfZa9l0+9wK/
         D6JgtlFX663CfXIw/9Y3cLx6ipEfANoddgrv8gXijLcOAoBTGl/qU67YhfsC5Xxx+XGk
         LESTtpufRj6d4mTpzPPep+blqO53/GdB89Y+BGoztIXRoCmmaP8rtD9uaqj3P62Ac9bD
         +pf5iXI3F7jvCp95iUZdNfkGwXXl8k3wV59kub0rH0JwR4Lado1m2iHvZenTECpQOBqa
         EeKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712712431; x=1713317231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/0EWDa/dNkvJHojCTHVu+tnL215oLyOWobFjajXkfk=;
        b=u+kg0yAKI/fmWfH4lsyUWqipySyb/TP81MmP+LLCD8v6ifcuSzm1fsZ2ECOhQIRMPT
         5iijBb9NpPm2moyAo7rDvK3dJ9C8AroCSFYPF1/npSiPDRQ6gDBjIEPJA4B1GEuIq5ma
         skgJ5D+os8BGoBMWo1QaAGzewMCkK7VS1w+vBB+sQ8J/q0MZ/84Wd86PT6Tk6ZpoN7Vg
         /NmpVHS5LVKW0YLhOMo237BFDmvA0zmiwtgGjxj4mA2MB/RNEQAD0DnLGyn0OkB5qyqz
         drInvnXVWC26Pxk4Goe0R0DpGW0FXZtW71N72wqeRyC1zk9W4Y4+MebkhQjL7kWVHnfT
         DJZg==
X-Gm-Message-State: AOJu0YxMXMy+Pf4dLZ4S5KMSJzDL6KyeIGacqfmTZwMxx6WjMEpkJapW
	UIw3EsdwuCfxcCANwUTOorLe2NRwyKBdBZKHwlVbrdv0QIEf4LTS4WaQQqxg
X-Google-Smtp-Source: AGHT+IGuO2v6yRyy+yJzXofgxPkhktJQkszPpktp0NghMACcXHxSjxmfOFQfRC3f+elSzlnf6b3ISg==
X-Received: by 2002:a5d:4a45:0:b0:346:408d:4337 with SMTP id v5-20020a5d4a45000000b00346408d4337mr642488wrs.9.1712712431490;
        Tue, 09 Apr 2024 18:27:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6944000000b00343b09729easm12737693wrw.69.2024.04.09.18.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 18:27:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 3/5] io_uring: open code io_cqring_overflow_flush()
Date: Wed, 10 Apr 2024 02:26:53 +0100
Message-ID: <a1fecd56d9dba923ed8d4d159727fa939d3baa2a.1712708261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1712708261.git.asml.silence@gmail.com>
References: <cover.1712708261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is only one caller of io_cqring_overflow_flush(), open code it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 55838813ac3e..9424659c5856 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -726,12 +726,6 @@ static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 		mutex_unlock(&ctx->uring_lock);
 }
 
-static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
-{
-	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
-		io_cqring_do_overflow_flush(ctx);
-}
-
 /* can be called by any task */
 static void io_put_task_remote(struct task_struct *task)
 {
@@ -2452,8 +2446,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	if (!llist_empty(&ctx->work_llist))
 		io_run_local_work(ctx, min_events);
 	io_run_task_work();
-	io_cqring_overflow_flush(ctx);
-	/* if user messes with these they will just get an early return */
+
+	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
+		io_cqring_do_overflow_flush(ctx);
 	if (__io_cqring_events_user(ctx) >= min_events)
 		return 0;
 
-- 
2.44.0


