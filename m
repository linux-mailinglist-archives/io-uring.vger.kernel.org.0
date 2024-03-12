Return-Path: <io-uring+bounces-901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BFA879C5C
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 20:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3ACE28215C
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 19:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9357B1419B0;
	Tue, 12 Mar 2024 19:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/x0PZIn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F7D23A6;
	Tue, 12 Mar 2024 19:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710272721; cv=none; b=Yal+5euzcac4OluY8RpL9Y1QtGSbymVOZRUA9mTw84HXSXY9VZ4Cchqn0+c23s2UIhwlwx8XIgHITgeifwgTE3I/V63JAgojRj5XhlIR6rjV0Tb39twgGWbB3WZiAGnjgj/8l4wWuRdIGz8kyuv+0PznugVbOlJ8lcD0A70VOxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710272721; c=relaxed/simple;
	bh=0TEKOlWNIEoKVpumYhfkr3FEIYA30xUMyr8k+EIhB5U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O/cXr5OjBtLImwsb871duGhuAQbkpS4MyN350C1Ff7fZ7SgZMWeYs3BRZ42jb6VAwXdS2uvV1JbboFGtoFihcYGrL6qbN7KgtkEfKYxPEvQQKOEDhl54V2SiQEDDr56pH27w7IVxxOtYpIjRlzyQbVWfrLX9xK8BaP3ls+92ZZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/x0PZIn; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e62c65865cso4952893b3a.2;
        Tue, 12 Mar 2024 12:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710272719; x=1710877519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WtzYBJnsfJmGgU1D4uIQaSy3M2tP9MG6qmljkncxzVA=;
        b=Q/x0PZInGJcVmE9gBtDvG/xgk4Xcj2tzH5lpJyahJXIP+Ynh06kK1nmHiwW6SSYCHE
         M+Te2kDhNsJ/JbXXm4GYIbJHZgt+v8lIjmzF8/6VvDZo3TE2iTziJRN4KhuM32kszK/A
         Z5tilp+jUqJXd15gZUm2twnBpcuf5Ol5W1ohAKRGo8MYYEimOVi4IC/jbxUrsdmDFomR
         JtnsvyisoG1YEOQ8jcMFq/20fB/Ld7NHkJYiyrzsIkxN4IkBYs4rEj7CFRwvigrA/2xD
         F0lbBbKSXcYfd55yZ5bnXp39Quw/xazbbPI0GhrGykE7/+GE3GqUUYqwkuqgpoN1M4vQ
         T07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710272719; x=1710877519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WtzYBJnsfJmGgU1D4uIQaSy3M2tP9MG6qmljkncxzVA=;
        b=bW6n9+ukg7WA8b3JshOYBdImfke7O3fGrrDxyCSjuBsHWl2oa8eRpVB6ZNx88b4zNn
         5szQfnmQPOPlb/lB8ABzvGe0Ju4KXoYdJI4UaUlxYyzq50zL9Tk8FyTHT8QbnxWZ7NXs
         miwsvUJhq0q1zYZKyLvSObRbWpiK8qwfnjCcolFe+BxJKWz87G01hRe42wqE/QwiP9tb
         d9O0L3gst26wGanUBsR4FomvbYdjIIRdsMqd8oa42Cff/sDYff5PWuRrdsJ5ocCJJjPb
         nZYIt0k4j/MMNmpZE5oNR7lp80JigWpgpmgbNTbCspojZaNtQpU5j3z1QHJqDynoLR2C
         AZwA==
X-Forwarded-Encrypted: i=1; AJvYcCVhCMspGapyNwf+EBtHpcWCQT7syX1Y9kQkgSXp402l9qaN3O+74V0hEPn+LRoGbsdbF3TD6+/WsqpKj0FPJYFsvhU1D2Xv3zXm9wf2imbRr0y/ozUrm4LbPCm1SZ4+RC87iJGZalU=
X-Gm-Message-State: AOJu0YwTnjQSJQck0w4Z9gPzB8AkpA0tpfN/yS6QlRxjI3GCz8KwBnDe
	QFtU7s62B5EuHPyJpKBpR62/zf7bxy0WPgdEpqDJO5JGlINIdMu8
X-Google-Smtp-Source: AGHT+IFkylPPjxj57UvYUw8SxFXN0OslyT25c4hDJPBx7tYQg1zFyOpcTgZE5cToFg8KX4EAoeJKKQ==
X-Received: by 2002:a05:6a20:8411:b0:1a3:15e7:e563 with SMTP id c17-20020a056a20841100b001a315e7e563mr6983154pzd.14.1710272719373;
        Tue, 12 Mar 2024 12:45:19 -0700 (PDT)
Received: from localhost ([45.200.107.219])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b001db5fc51d71sm7142007plh.160.2024.03.12.12.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 12:45:19 -0700 (PDT)
From: Xin Wang <yw987194828@gmail.com>
X-Google-Original-From: Xin Wang <yw987194828@163.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xin Wang <yw987194828@163.com>,
	Xin Wang <yw987194828@gmail.com>
Subject: [PATCH] io_uring: extract the function that checks the legitimacy of sq/cq entries
Date: Wed, 13 Mar 2024 03:44:46 +0800
Message-Id: <20240312194446.114312-1-yw987194828@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the io_uring_create function, the sq_entries and cq_entries passed
in by the user are examined. The checking logic is the same for both, so
the common code can be extracted for reuse.

Extract the common code as io_validate_entries function.

Signed-off-by: Xin Wang <yw987194828@gmail.com>
---
 io_uring/io_uring.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cd9a137ad6ce..c51100f39cbf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3819,6 +3819,18 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
+static bool io_validate_entries(unsigned int *entries, unsigned int max_entries, __u32 flags)
+{
+	if (!(*entries))
+		return false;
+	if (*entries > max_entries) {
+		if (!(flags & IORING_SETUP_CLAMP))
+			return false;
+		*entries = max_entries;
+	}
+	return true;
+}
+
 static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 				  struct io_uring_params __user *params)
 {
@@ -3827,13 +3839,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	struct file *file;
 	int ret;
 
-	if (!entries)
+	if (!io_validate_entries(&entries, IORING_MAX_ENTRIES, p->flags))
 		return -EINVAL;
-	if (entries > IORING_MAX_ENTRIES) {
-		if (!(p->flags & IORING_SETUP_CLAMP))
-			return -EINVAL;
-		entries = IORING_MAX_ENTRIES;
-	}
 
 	if ((p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
 	    && !(p->flags & IORING_SETUP_NO_MMAP))
@@ -3854,13 +3861,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		 * to a power-of-two, if it isn't already. We do NOT impose
 		 * any cq vs sq ring sizing.
 		 */
-		if (!p->cq_entries)
+		if (!io_validate_entries(&(p->cq_entries), IORING_MAX_CQ_ENTRIES, p->flags))
 			return -EINVAL;
-		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
-			if (!(p->flags & IORING_SETUP_CLAMP))
-				return -EINVAL;
-			p->cq_entries = IORING_MAX_CQ_ENTRIES;
-		}
 		p->cq_entries = roundup_pow_of_two(p->cq_entries);
 		if (p->cq_entries < p->sq_entries)
 			return -EINVAL;
-- 
2.25.1


