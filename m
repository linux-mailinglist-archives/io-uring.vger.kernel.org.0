Return-Path: <io-uring+bounces-5571-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 891859F84C7
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 20:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FFE6188A523
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 19:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6155155342;
	Thu, 19 Dec 2024 19:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGKZuul0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE4F1A9B5C
	for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 19:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637940; cv=none; b=Wo1+xObQjru67aWfq654loLcBIbDI7wChfOVKxdEpEnML0w8xoz7WZugWoMB/kIa3dncXQPeBoaJIX+5OXFUGkJZmk3wHsXuYXARZK+zQwWpVhexyYSdmVn8EBBAxeW5yo1Orb8Q9xMu1176j43VM7Kk2PSaMPf4E832/LI9FxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637940; c=relaxed/simple;
	bh=eYPoe6bRvuvK9fExr6CqQfgY9XPPJ79zFKTSNatxDAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jcuzti30Xp2bEJAHjxElKH86Wa+lwnUn1zNq6P33ehERAAk8sKx/+c35ff0p865ntikl6npEIRrJ6LTl9oqId30shy+kdxs8VDivqoNGCL7r3jICH7gXN44wUst+qFVLdv26Li3D29NmcnEmBWLZRDJmOX9SzN7TaNXXcxHypk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DGKZuul0; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aab6fa3e20eso205192066b.2
        for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 11:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734637937; x=1735242737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eEL6QhhDvBg2JDf2OfFCcACORTnMNCBEAL0HeVkepP0=;
        b=DGKZuul0AbVYE1wrmAveUHXd9YkmwrO6oS44Rv8dTjl74gZ9tbciE8v/Cti58t2Jl/
         NNZ1GHUDtNRbWOVgFYfjA1UTYWzIG2JDYVhTu3d+OIdk+hr7Y4axE1UoHPsKbAvD7GeD
         b/krrM0ydpYfSPgqf2M8G5ZkrR2WrK7h2wmlByfc4OyQ527EruIIVaOBkka8sKeBv5Bw
         dXAiQBl2vvH5TPytGkStIdDRfo3QpgGRabVPdLyoXQsiZbYk79V+yEGmuD2B0HWCU4OB
         BdEflptkD/5Vv3cY/96lc/tUAVfPtiUy3cIlntb62ucfaXKi9nviQEN5KrQKOQ0Jub9j
         UFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734637937; x=1735242737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eEL6QhhDvBg2JDf2OfFCcACORTnMNCBEAL0HeVkepP0=;
        b=ZqbSkzSsGv9h3kcUhkjxXv6V9Vks+6AwRvO3sG0R5c1TU93WTMmJZZpa1a1Wd3O22u
         tTuyQnvzwZ2a9t6AXcV61Pwa2Yjunfjw4j/DxwALZtMNZQFFtiRPXIheRDFcFpjgvqy5
         n9XKKMrM1+8o9iQ7vrMel9xzykwKhn/mZI3ku4P20T813Ydbk3NBkL7+ZG/qtUKUBTPh
         fi0u0m9dJyMOKWDTuP4g4QGD9UQ+uHwG4C8uaN9bpTCYzrDdH2mfIdzEN11PuHNV3OtC
         C3rO3Tj/cH5/PzgMb1Q34L6S2oaD+fCeNfATWD+P4iqaOnC7zT90TrIvqhsPmCTpgkJL
         srPg==
X-Gm-Message-State: AOJu0Yw9m/e42JLDmuGYouvKyuS6tmTTJZd8I/bjvabIJoVD/Qrt9qy8
	boyHJzksBdymcD4qutWiAHfpKvoTdGnwXF27Kz7g/Daht0h2fSoaEsPnHQ==
X-Gm-Gg: ASbGnct3XEe9ijZb0iX4bN/zgls3ZYnZ5lVLzlRcJBgJ+mA5h51bZVrOXVRkxsCR0oW
	BnbZBpu3MI4RYNiy06k50C5NLfF6UE7E23U1xauuux0fmA+F0D5zw2Kdd748EgsWFZKij01/Nkt
	O0zCt9615SqNRPoA6IXhLwUislcM4qJD6BadKM9DuMKVXljc9X4HbSlbvtKU6op0gTzJtM+4mRJ
	Q4QadFFGB8LIDzttJzFcc3NJahpW3v9uuclgJpqIIuVHCog5CKg4pgAh8VO5cUxnyfe1Q==
X-Google-Smtp-Source: AGHT+IHUwKaXzTn32eSrGE8gUSaM4Ve7fkKhp4t0LN4g+i+v3HLFMDJVZ8a5wZhnESIxrL0EFBhjtA==
X-Received: by 2002:a17:906:c106:b0:aa6:7cae:db98 with SMTP id a640c23a62f3a-aac2d447333mr6153566b.10.1734637936816;
        Thu, 19 Dec 2024 11:52:16 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.148])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe49d7sm97707066b.92.2024.12.19.11.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 11:52:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Will <willsroot@protonmail.com>
Subject: [PATCH 1/1] io_uring: check if iowq is kileed before queuing
Date: Thu, 19 Dec 2024 19:52:58 +0000
Message-ID: <63312b4a2c2bb67ad67b857d17a300e1d3b078e8.1734637909.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

task works can be executed after the task has gone through io_uring
termination, whether it's the final task_work run or the fallback path.
In this case, task work will fined ->io_wq being already killed and
null'ed, which is a problem if it then tries to forward the request to
io_queue_iowq(). Make io_queue_iowq() to fail requests in this case.

Note that it also checks PF_KTHREAD, because the user can first close
a DEFER_TASKRUN ring and shortly after kill the task, in which case
->iowq check would race.

Cc: stable@vger.kernel.org
Fixes: 50c52250e2d74 ("block: implement async io_uring discard cmd")
Fixes: 773af69121ecc ("io_uring: always reissue from task_work context")
Reported-by: Will <willsroot@protonmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5535a72b0ce1..8353a113bcc0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -514,7 +514,11 @@ static void io_queue_iowq(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->tctx;
 
 	BUG_ON(!tctx);
-	BUG_ON(!tctx->io_wq);
+
+	if ((current->flags & PF_KTHREAD) || !tctx->io_wq) {
+		io_req_task_queue_fail(req, -ECANCELED);
+		return;
+	}
 
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
-- 
2.47.1


