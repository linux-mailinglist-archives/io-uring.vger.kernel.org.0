Return-Path: <io-uring+bounces-10543-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AFD2C5254C
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:52:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F32C3AE771
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05181330B3A;
	Wed, 12 Nov 2025 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcobe1rk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC94335563
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951583; cv=none; b=eXF/oUlpf5VRuPT8RnXV9tJlqFf6Mvnj6/b/EzisKqZlzpP730eUHvqozu/ysDwPk50EG0r58wYkk/Be/YaR3nxwU2X+6utsr+XEpEkDHlA3JgLHSmqtRgkQiHRfyRovIsyAZCT6yFrhCVMMS2cpvbVnRCEPEPk7KcJtkvxzDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951583; c=relaxed/simple;
	bh=sbQ1roAYr6OTtjfWWLDTuh15RL/qbSqWcBp9DgeZ5v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH+KLhbvNVWveEnDxNmQdtjrNfzxEAJw7ZUJfDA+aVTEkp2QDtQCcPj52c4l5djpadXjNzb3aVhXdhwEX5GX+kWxx+8TqLWBvlrIo7G0QTqAcybIVinsiao+2BCK1Fsuazi0BaPhzimn4SBQ/suMHZFeyAyF/Y95lG42LThau+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jcobe1rk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so4174245e9.0
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951580; x=1763556380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCxu0ha4GX+w9oTpK9m167fwXC2/9O1yyAzG/yXgPLQ=;
        b=jcobe1rkvJyeCCqIRyx+51Ji+jF2XsHaO4vjAHHEilzQXkXXJ7gF35LSc+nUNMS6BJ
         ZIX6brGvWp8KckcGWK/zIte4+NhBenZpgmt9vxm18KK9EwhsteQqo4AKsMnGTycj+tn4
         tAGRReo65+YZ7SstppNXcC9H5VrCjxil1CJfjzAYs3jqwFSlLVJ9wWJSrqFh0bpRLYkL
         U0C2anh3LAz88bE8hsIAD4pJz+SB4ixRIhlfJIsh5KCTRns4tv/H7UZxeoGjjRrQXQUf
         PXpiqetoC8q6ZfCb7sapP5UWZECJrI52hNh7QjJ6cvT45poVNUVb8kS8+Yy58k/d7Wcl
         wIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951580; x=1763556380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rCxu0ha4GX+w9oTpK9m167fwXC2/9O1yyAzG/yXgPLQ=;
        b=WCNT/xR9in7S7oy8SL/5KufMlFM4CfZyR8q89mV8ySIwZwxdbkUi0L7DREuj1vH02c
         mvacEvNnQQ80H984bh+JzSXD6V7SUtaSsrc0+pmdFBtgK3fk0WdCpOUzuLybIhi4Z7SG
         nq5FxMExKyy/T9/5eBZ3W+n3WtMs4ElA//nuIAHCnj3DJUxvvG5xnAV8LD9qcphddWTz
         wMGCXiwm3RZJk+pRDUh/tMZMpKymg4yKDZbmCUeOAwubmhAXXcUB4ux6H0gx7wySZzFI
         InMYJG/rp48u9sWG9KVqpgREI6JEkqVMkSYcVUEIR7dUhgOw8t1ee5fB0x4SBRMyckCu
         WVng==
X-Gm-Message-State: AOJu0Yyy72GLJBX7+URnmObZdvvf5XzZJGtoqeePYL3OKWeocIVEOmm9
	52oPHwBejcBe/5xgZH3NMrnw2CTRwIzYjjqn7noDCy6ebkJaHie7GdH4TYng+A==
X-Gm-Gg: ASbGncvxPvc82ChzPdWCQpEvSoHg1mQhatR0X3WQlVJyn8FT5ZUd3CB42JSFQdf3kMv
	E1m2opIrvwa4p0H4AkFQ/QFsML56wBHp5jHT09gZ4mUbNaO2WVKNKEDGRibkufwsEPGIbm2UHyP
	1JqG2I7P35QrWtQ5RVOC5NE9nP+sHcm7WsuGAQAIJI4WMqho9KCeC0ofrurEhv7pJ781tOEZwmF
	CmVvom9g0UsZ6FCh6bP5+Of2vUHW+enrx3YXkbQpcYKV7p6qCqtA1S+885VXZ+choSuSRHVjfvp
	PJpp41RmvTEnTsVNxXosQCvVcGkZzLGlcdHs74j3s+VWawJFsMLGtcfE3sSHlch6qe5itwoXfjD
	Uf51c5wDnMxrcdMAKGDERZLHwv6z5PE8cvyxrefGJH4zohypkRYzZd+O/aV4=
X-Google-Smtp-Source: AGHT+IG/KmtIakuNYd4hDjUVTa5V259yUsDsXrnQh3Ae9a5SZEbVG1/A0UU0F6jYLPoGDAoNbIcCoA==
X-Received: by 2002:a05:600c:1d0f:b0:477:55ce:f3c3 with SMTP id 5b1f17b1804b1-4778703d822mr27099695e9.5.1762951579958;
        Wed, 12 Nov 2025 04:46:19 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring: move cq/sq user offset init around
Date: Wed, 12 Nov 2025 12:45:59 +0000
Message-ID: <434c0422c934744a829fb6eb8a6a9f59a95dc0ef.1762947814.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
References: <cover.1762947814.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move user SQ/CQ offset initialisation at the end of io_prepare_config()
where it already calculated all information to set it properly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d286118dcd9d..c1c923d19cc3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3519,27 +3519,6 @@ static int io_uring_fill_params(struct io_uring_params *p)
 		p->cq_entries = 2 * p->sq_entries;
 	}
 
-	p->sq_off.head = offsetof(struct io_rings, sq.head);
-	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
-	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
-	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
-	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
-	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	p->sq_off.resv1 = 0;
-	if (!(p->flags & IORING_SETUP_NO_MMAP))
-		p->sq_off.user_addr = 0;
-
-	p->cq_off.head = offsetof(struct io_rings, cq.head);
-	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
-	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
-	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
-	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
-	p->cq_off.cqes = offsetof(struct io_rings, cqes);
-	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
-	p->cq_off.resv1 = 0;
-	if (!(p->flags & IORING_SETUP_NO_MMAP))
-		p->cq_off.user_addr = 0;
-
 	return 0;
 }
 
@@ -3561,6 +3540,26 @@ int io_prepare_config(struct io_ctx_config *config)
 	if (ret)
 		return ret;
 
+	p->sq_off.head = offsetof(struct io_rings, sq.head);
+	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
+	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
+	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
+	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
+	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
+	p->sq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->sq_off.user_addr = 0;
+
+	p->cq_off.head = offsetof(struct io_rings, cq.head);
+	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
+	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
+	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
+	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
+	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->cq_off.user_addr = 0;
 	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
 		p->sq_off.array = config->layout.sq_array_offset;
 
-- 
2.49.0


