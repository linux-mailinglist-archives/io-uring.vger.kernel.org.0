Return-Path: <io-uring+bounces-7308-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE99FA760A3
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 09:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 189233A380A
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 07:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E441E492;
	Mon, 31 Mar 2025 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkBGW2OK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732B741AAC
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743407708; cv=none; b=YnVhsoEZ/6hYUq80m5LMUtnTw9K4DHIfG7cLQ1YlF4WjwOpwC3SJFdglL15kFNS1hxua4TAo0bohb/bTHwHe/JJ4k5ebdx4kqgHQWl5z0KvLoA9Q8UbjYoEFszggBjuO7bmd+RAwFqYWQYow/MO5bN9FszLD2fUUCooaVeaQIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743407708; c=relaxed/simple;
	bh=l1IPvFEye9Au1dnrPjP+/fx9TMZqD5GkmDW1SyNJJbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NQs8GaczmyLcNlanLnQMzePhDtuGNC1dhe6QVtKqNoI1LyUtlJfeuY7BNyAyGDCwc6C0VLqMme4s83u+xIPi4h8szxOKmRd4y9Iou3oHobjEL+Sv/KxDmc0PH1dSOFSUwe0zxsYXZucwzszzHfx/zEUeRq1uzYQ9eMaQxvh7Wb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkBGW2OK; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac29fd22163so698600566b.3
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 00:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743407704; x=1744012504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N3MspWEFsnM1GmG1M2P+vwpoMwU4Yky9K0lHnbb1Qg4=;
        b=HkBGW2OK2/Gy1zkMVi1yliHUT2jNq7G+UJozykuSQgs6hcrbZ5PDjkIeA+SN4RvMH5
         WdHNkLoGFm7MPNmwCPQDr5r/KFbCbhOap4hKxxRusDRMm8PrUk97B7M8MQEPsd93NWiU
         xStslunDzhQNzpseniwxem9Zwl93Cl4WrIiiUrmT4cD2o2rYK9wtQWO9yIMIpkgcVIAN
         0jeGxkzRYtKTF3MB3FAiuKwJPqLbrcomZFo4T21nY3Ogj6sP0gDgCPrP4AyFaPGsp1TN
         obfsDRvVHfuca4C/9n5Ih+1rF3FKFA9GZJQK6qiD5Y4t2HPvLok/czBFcWlLCIaO8och
         KiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743407704; x=1744012504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N3MspWEFsnM1GmG1M2P+vwpoMwU4Yky9K0lHnbb1Qg4=;
        b=AVuab8RrhiIF5SaUhpXtqS2KQWymxzoK83OQhGDdCskBIulSkB3h8CRZE5u+b2rwXW
         w/UL4d0ud7pWDUcwcMcaQ4Bwgw4NVyUDFMXZcS1XbkwpBRGpiKzERHmS6YjIVlbJzrkz
         JzeaZzLjP0oHpJMLS+fY8mZ/ADDx/EYnNB1Vsp0Ndp9Rf5r8ZReX2Kuwo1vffIyYwk4y
         VDBUT8J69UxUHauVhlJwGddFGz2UdeHLR7C6RQPrCyL8Lv9jxTRudEnVxw+eNM2+Zj2D
         6sNashgw/zF67LKk+FbH6XXbkB36D9YuqogQYYgqyavH+1g1WPD8UJSeuErFNLVNxzSy
         x9dw==
X-Gm-Message-State: AOJu0YwH5jd2VjCtXwUPQuztGVQu32BhAiC94/VCMgNpqD0DgE+JD1YH
	SgXPxoVawgXIrzusoj4EcCmwS+zR+5FwgJe5Menne6G/oLtPkq3H4SLLiA==
X-Gm-Gg: ASbGncsx/0K0MjewWgad1Z+UgXwiNDo6atHzsY8RaVEDRy8Nnbm70cjtmTOHDeKpzpl
	uT2wyFRKUwsKFDYkIRZ+K+LoUj5cYJNZhoFRvdfUOaipc0jVc8KuLuhNBJpNdOCMt8cwDwg/VX+
	iy/rOLVodMtBE76PfSghwnVBX8yN/aQv1YSh1tDAPynH3I5YZp01lzC4y3W8HwcQB5l/597WWD7
	W5sQiZ9zr1jZ1bWqTjUpDzGxvxuHd05jYph0QV6iJwxBQ6lc66PGGINgDka14H/BN/uBknKfniA
	4cqCuaY/fXhfFezchCrWEHJ9feM=
X-Google-Smtp-Source: AGHT+IHkg4lfwgUoETwG5twvvK9TiOh4tkyAKKU31kCnhb8ZM1ErkW3AATNqlRtuxj4DA1Mzm6Nyfg==
X-Received: by 2002:a17:907:868a:b0:ac3:ad7b:5618 with SMTP id a640c23a62f3a-ac7389e6750mr863829566b.3.1743407703915;
        Mon, 31 Mar 2025 00:55:03 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:345])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71927b25csm597649866b.62.2025.03.31.00.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 00:55:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: hide caches sqes from drivers
Date: Mon, 31 Mar 2025 08:55:47 +0100
Message-ID: <ecbe078dd57acefdbc4366d083327086c0879378.1743357121.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is now an io_uring private part of cmd async_data, move saved sqe
into it. Drivers are accessing it via struct io_uring_cmd::cmd.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h | 1 -
 io_uring/uring_cmd.c         | 4 ++--
 io_uring/uring_cmd.h         | 1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index e6723fa95160..0634a3de1782 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -21,7 +21,6 @@ struct io_uring_cmd {
 
 struct io_uring_cmd_data {
 	void			*op_data;
-	struct io_uring_sqe	sqes[2];
 };
 
 static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f2cfc371f3d0..89cee2af0ec1 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -205,8 +205,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	 * that it doesn't read in per-op data, play it safe and ensure that
 	 * any SQE data is stable beyond prep. This can later get relaxed.
 	 */
-	memcpy(ac->data.sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = ac->data.sqes;
+	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = ac->sqes;
 	return 0;
 }
 
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 14e525255854..b04686b6b5d2 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -6,6 +6,7 @@
 struct io_async_cmd {
 	struct io_uring_cmd_data	data;
 	struct iou_vec			vec;
+	struct io_uring_sqe		sqes[2];
 };
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.48.1


