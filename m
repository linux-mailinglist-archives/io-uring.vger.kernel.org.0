Return-Path: <io-uring+bounces-7346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3960BA77F42
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 17:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37A8C189023F
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 15:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38A420C03E;
	Tue,  1 Apr 2025 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOOlMsmR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB1420C027
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522303; cv=none; b=bRxmsj4ayMSUhns8qp92oOrQeKz3vEf2eCO8OM34zlNgly4JAbJHaudVSiwxuYKhLit6+G2llO76KsWv8ztlgK907z+CCPzMqFYsXQJuNnNvmuQ21hvqdJI/Vzp3JltjcvC5RWDbQjsepBF3yjNCUIPP8EtfF6dDcJDAcQ9kaRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522303; c=relaxed/simple;
	bh=To+ZIS6y9amnx3D3q0apiArudSLor6epXqAOZ5i6dpc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u/MgeYXSRDTYwH4+k6h8g2A5NbqYhDKoCYo7QFclifb/O1i1e5AKaokxqCVeq+nVeXFQwgJTytnFgYsQ/EzhASG1qEVLpaxNdTogeUAYCphETeKe8hE8Q0qYnRT/ckSDzVU/tMAXxrpuJLpXZ6PdSmUvvuw5yWdCXEIx75/imOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOOlMsmR; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so908169766b.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 08:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743522300; x=1744127100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xqbS7ka2VHAGeI0eMEemx5lSh/7rv/QDT3KYEcCNgxA=;
        b=YOOlMsmR0v6ODmUGwBy+oA2o76vwdawXqUdVfogl/ohVo9/BNQhZPl0kgpraXii20x
         FkeOd8OAYZFuzzo0kAH9u2wTwY/gLAkGlZHuDL2KrVZ37Ymfu9szStXGDGIE+E+7bEQO
         QQ2Y28ElRk17d3ZxBuoFbfrHAk1WGVy/hsEqyUM/GHj/5NNaQBG4liVjLfCDdhOYYSLD
         /v61RwaYBjnOHNDKnIrXYHgY8r4OJNvDqMIL6QEw4bvdeW2tuVP8RHbpxuOKdPIAYhvc
         cl1zyNL2xqKfmjZwlk/298LRZ2myZ9U/hbMRo8JYmLByMPWANKwwuCCs4cNd3Pnsu8nb
         TFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743522300; x=1744127100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqbS7ka2VHAGeI0eMEemx5lSh/7rv/QDT3KYEcCNgxA=;
        b=uoR+ZkBnCAfJcbWjmhUfsE7ynu79niiE6G2gTI+5VkW+0s/LXhzLfTWNgUe5QPsb4e
         TqaT3plj3jrAgCk5Az9fW3OBXtHxd0jTUuBR+19cnsBbfeEhNhMiLvHW0N013NrmSdHn
         1gk+g11S1BpdCAXKwGLLVtN150J3bj8bGMn5KDEhMRmLfo2eMWmh7XzJl2+8CpicMzaD
         DSX+zCT+hW3FRNLnb6917FELrEjfJz9TPkB3slCiDOHeA7onEwSpbhX9u0L0upu7qpZw
         WxJYjQeDFEZrdFMsu2YDqvYQeWxTbe8SxDY3BfQfjTEErXpXzSDjz53jdInHDJK+aLpD
         pX8Q==
X-Gm-Message-State: AOJu0Yz5mw7TGjEbh9rphx8taHiOqjZCdD8JC0dmk1Vnh9CUTOyj30Va
	QO0QNqPGdEEVmoUnZj2GV6YUrmnrRGelyWlTiSBp1LyT80MxdeaWLrC4gw==
X-Gm-Gg: ASbGncsQeKADDBgnXOniy4EAcRvKjQ0z+twj4PxbBLWYtbySnZJ48Ms5hEHDQwU/N6r
	/hxonkp9Ww9MQdOIzKKCl2rl5/hnsDU3ImSGKA4uTCevC/89C5C6/FClrTW5d4tXjekYbv5sTjv
	P4/PGEb69y6xWoE6egdexOphXQjZSg+eqDKzdWWs4PzdGuyTto61qKFi2aVUdOiXspcWXk84pwy
	tfMi7rbTWL5xm76fBwC4npVH/krp+mfQcO0yQy0Dw9lUVt31jzJQg8eGDNMllxDoPcQB7YpnLv+
	odbbaHErfR6wj6UnFC/mk+mPPIESRV2B5CPJio7dxvpZOo83ZTjKR8G9TSg=
X-Google-Smtp-Source: AGHT+IHveVmmj7p/32fQC6MMJdYC5AgC9TFZ58CZQH4axmy8EPevmDh2/dDO93qvb3TNCbcXv6nkGA==
X-Received: by 2002:a17:906:f58f:b0:ac3:1763:cc32 with SMTP id a640c23a62f3a-ac738b37e88mr1309921966b.29.1743522299613;
        Tue, 01 Apr 2025 08:44:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.143])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922bf43sm776731466b.6.2025.04.01.08.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:44:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: add lockdep checks for io_handle_tw_list
Date: Tue,  1 Apr 2025 16:46:16 +0100
Message-ID: <ffd30102aee729e48911f595d1c05804e59b0403.1743522348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a lockdep check to io_handle_tw_list() verifying that the context is
locked and no task work drops it by accident.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6df996d01ccf..13e0b48d1aac 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1054,6 +1054,10 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 			mutex_lock(&ctx->uring_lock);
 			percpu_ref_get(&ctx->refs);
 		}
+
+		lockdep_assert(req->ctx == ctx);
+		lockdep_assert_held(&ctx->uring_lock);
+
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				req, ts);
-- 
2.48.1


