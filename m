Return-Path: <io-uring+bounces-8529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F017AEE563
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7171D3B848D
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF01293469;
	Mon, 30 Jun 2025 17:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvmpGjEj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD5228D822
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751303355; cv=none; b=TqKpar4O1ZWfvFrya7l2V3OQl97iHda47U+erbVDqqbkE1LVlN1trVnhjOFnbEXNqtm9hNZtp7zSs/UPgbPK1d7C9kgZcYi4c9e5+ey0Zxpw0+84x7IxOlwlCXsoVat0lAyKFrD3DQe11blNA1tnEay57WMfpsEOR7UfaW1tfug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751303355; c=relaxed/simple;
	bh=jAwMbpmnJhTBb5AOocOHMiEmXgVt3xEHqp1O+zu2aAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNrOXSuDh9yJssDiqpIo7d40dGklvKTrj6TWu2zKAidX1v5+crbzqLuKfhDadjaUR4TrwrzUIMCJmuQBN0QAjoUMRqJhM62IILvzhMRKN19Qsj6q640QGSE4Pjuy6X9lFiagibEtVY+aukUAyu3AdN1XPWFGZtkuEkBIJUBhy6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MvmpGjEj; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23508d30142so29460965ad.0
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751303353; x=1751908153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvkliDsW1PFgDSFmU5IBIY3ABVglLSbFpnuOzp0vuKg=;
        b=MvmpGjEjepz1RLjZO7bTbdOijUPk4EOsWNo7XWSwrJnXhSuw5meh7IGYU7s6mj7YQ2
         7FoIr7TiAznE7L1+XbqqtJkjK1QQV2ybznL+UYj6szysh5fwpo0DQnOnFQ+YdfHKSY1u
         41neQS98MIUl7kWVpZkRTORcv4+C/kRntXGMau3G98FOXqb45OMnQNEe+svpPS241feh
         b8GaXK4USYx/BgeEW0MMmAtOXmrIgYlfq6bnByXkUOUEGPDa14M2JvwN7LgN8UvH9Mki
         PUMcomRZyEd29OreMQhcOR46Z+Zgl0cTDJyYqQLAOQlTYfUlXGqDC8SIdirfQvC3eRGi
         PFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751303353; x=1751908153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvkliDsW1PFgDSFmU5IBIY3ABVglLSbFpnuOzp0vuKg=;
        b=BMOPTmBMXzIb2/LtC/2IG/Z9qsaTE/7fGj+Kp2Gzyt7VPm8ezre/lGLjSxP/0AnHsT
         ykn9LMK+XaaLx6kTIXPtEf9wyCaYvZ/Xc/tCW9444XNelSd2OwTnMI4XiKxuPnCRPE3E
         qG4ZJFsP8Ie77gI/rk4oYz4eqflpTwc0Am9woCVhhnxpYPHvaEJbr7ZB0ZoaaPdWqZbD
         MuGQXcypl6gTEpl7DlTjughL0iciQAZzhr/QlflezvlVbRLmQsKtQTDl7qbJxh9tF/En
         stkjjSq+XuejzJQJXbwTG6tM8Q4OjFH9XMdDBgxe33XCsJMNnmvg+Gzz0YeQaiYwxCPl
         RPow==
X-Gm-Message-State: AOJu0YztLgy+AZ0JseqLQwka0szEr9zThJTf1uLqCc+XaLSdbIGuf20m
	aNMc45/ubSlrEoClzWyG1hCbO9p/OZzMxiA6BInmh43IhQ/PK/mG9IeNk6nXBq7s
X-Gm-Gg: ASbGncuWG8UivR3S+cbvFlcIFDQTS3bjcwFQfPKYR50Z2+pxLcnUZkXtXHMdrv01lVN
	cJi46vT15O58SjgeNK/m4jDtGTXBf/rRqG5Q8cwkx+C0CLyYr8LjHF7UyNpJ9iP6Ieo+aKnWMrU
	b06HA9NhtF9SvHig+xkvoSyDn2/SSxmtsLjnD2dMF6+8N5DnS/uYkFeA7ufhQW71hN0enzAZv5C
	A9gOcDIki1//fSDuSJw781z2CBfIIxsWm1V+HkgFsusn6M/PmpXhzuoB0mgPIhf60QPvsVBk6gw
	cgmxsnFYD3GLH4C0h6uSyutqJvESWOqGKRtSp1zjjrsc+Q==
X-Google-Smtp-Source: AGHT+IHI21JqjfxIVUXKDUxfM4sJzGf2vfiThVsGWJeRUphYzxuD5ohb6X2O0NeivjtxUNliOyr5dQ==
X-Received: by 2002:a17:903:22cb:b0:234:d679:72e9 with SMTP id d9443c01a7336-23ac3deb511mr237753075ad.12.1751303353232;
        Mon, 30 Jun 2025 10:09:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f2239sm89182395ad.81.2025.06.30.10.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 10:09:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 1/2] Sync io_uring.h with tx timestamp api
Date: Mon, 30 Jun 2025 18:10:30 +0100
Message-ID: <52422aa12720f7e976e9fd6b32dc66b7dbdd5794.1751303417.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751303417.git.asml.silence@gmail.com>
References: <cover.1751303417.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 73d29976..94de038d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -915,6 +915,22 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
+	SOCKET_URING_OP_TX_TIMESTAMP,
+};
+
+/*
+ * SOCKET_URING_OP_TX_TIMESTAMP definitions
+ */
+
+#define IORING_TIMESTAMP_HW_SHIFT	16
+/* The cqe->flags bit from which the timestamp type is stored */
+#define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_TIMESTAMP_HW_SHIFT + 1)
+/* The cqe->flags flag signifying whether it's a hardware timestamp */
+#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT);
+
+struct io_timespec {
+	__u64		tv_sec;
+	__u64		tv_nsec;
 };
 
 /* Zero copy receive refill queue entry */
-- 
2.49.0


