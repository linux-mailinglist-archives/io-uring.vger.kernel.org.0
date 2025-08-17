Return-Path: <io-uring+bounces-9002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA10BB2958D
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FDF7202602
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89951D8A10;
	Sun, 17 Aug 2025 22:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkiW6zwP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC561DD877
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470594; cv=none; b=tZT1fET7E0yAI7yGS+Sn335A0pgv+8lpM+FhxFa//gTOijc3o61HK/2Dc5XIMG61qo8kf6gEuJzPWOPylHU6azyEIe8vZvHsfyLhjWvhYk2Xw/V9aDiBwy3zi5FplGQIfWlvaNQ8L8tjDHnniuO4LKKZZSkQ4ztxkiLcOugoxTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470594; c=relaxed/simple;
	bh=fEsvGL8TZoYz0wwpKcT9Cs/oxAEPRa81xkRVUOJ4qzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7N545QvC8SFYeeK42s5hySJsgo9FxBOEau26D3h3+eGWTvVkFiRwEcp3+eUVN1VaGqlGzTacikLc/BEPrhYN48Lxvt/4Uofk5RvUYY+XxYcZ/IE/1buQKrNFLNriz9iSmqrYxa9mzBGqN/HKzXsez1jtGjeYujCk1eXofBEjqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jkiW6zwP; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a1b0bd237so27924165e9.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470591; x=1756075391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grCokv79LkzIRZonxhUEsZ9pRyqqug+M26iA6yIJLmw=;
        b=jkiW6zwPop3c42PrGQQEjr+MbDwkB1yhy+ZvXz3i+Ojh6azEQvUGUHxv4KJp4jQaeY
         lMGhVlNf3TroFU+IFEnv7ayBZy9WQN99Mm0KO5jfx8jNkOBPtwq9MTAnVM1E20Ex/1iT
         Og7fFfPA+3vgvCFAmddSDvGbH6S+b6OG+ZXWW7BYfTGUxrpoaaDoW65RwVDI4WXOBB5k
         hTGyWceTVBuOa/13IvJUNihfSEaamm8JeW0BBafc2hI9/kWFFxHFkFrfB+XyBoFlYRLE
         RX7OVENCkPpk7PSsUX+Tmr1VtI6zp5Y4Uxa94H6r6FRmYkZTLWAd9wY2irgvNpblGT6K
         rl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470591; x=1756075391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=grCokv79LkzIRZonxhUEsZ9pRyqqug+M26iA6yIJLmw=;
        b=rDY8Tt3R2IBQMh5fgRxe0fNv46aDkpPAYNVE1G0Tdc2M8tSAfP5jej0Pyf5iXARKl1
         G7APgRJ+Fhj5MjC5TMY4HNVViBE/PVp2nJoiU0KSc2ibfCznqlm5EF+PMcfI/f8LtzbJ
         8SyzYmzvwxynrXXAGaPrFI+S7h5LHWc12wv+hPCY8nYGfbPv+VGA5Q1IfSGsBPZzRPag
         CzDHgBs8XGKWrgRlTOSkrEvveRKiC7yY4S6CpuTwC/yAehoKTGZoR7wWnYic3QsrMKN+
         LsSrzYCyAgn7D4C9Q1RKHoyPD0UaB/e6QWv4oxCLXEZNPs7b2owkkVx8TrB3ecihUGeT
         Nutw==
X-Gm-Message-State: AOJu0Yx4vzDO553IhrpUdJrPM1innowJuX+BIT9z0+b9tVL7hsYqRApD
	awef2tPHxp8TGM11MUE8U2sgvIw31JcTNBY/LM0wjNDngT5gM109tS5fyrBQbA==
X-Gm-Gg: ASbGnctFtBFwp8F64EWtsaaktJiNY4IGM8Hdr82rJYxrdEAodR45tOZZgQSO1D7yhay
	J2YVbmiO69xHDzTOrDvZ1m22ulDVxIutdo/E9yEO9q0wTFIaAnCkta6KXgKCyw0lteUw/I1fHRo
	xXXcGn/tLnNYk8jXwdZGjB8ilPSeNUbSBOt/PQ527k9TmaLEdHUbJefJ3ctTlQ8SW/Cvi2Ztnoq
	UPmHqC6cdAGGflX2ZMd3A+3ol+sVWYXLupBnJ2OICZ5fVN32WR1KY0VJqTSNuWQJwMsn/oR5gkW
	oVbNlqK0Hin7RwYy/LdplPyjZkXa1JPJXSxnGBPCD695NH/Py6Qa6/AmaPf84LUc5futrw9qjxm
	NBeBL0SEsB6x5b4oJA+RvOJffP0/A4UGFBw==
X-Google-Smtp-Source: AGHT+IELrDQE/cuy7ml725mYZArJnaNQzSZIomR5s/+tXpZXd14UEafuw4rIEZCoR66YfGR7ooL1JA==
X-Received: by 2002:a05:600c:468e:b0:458:caec:a741 with SMTP id 5b1f17b1804b1-45a21e9f09bmr78597995e9.24.1755470591034;
        Sun, 17 Aug 2025 15:43:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 1/8] io_uring/zcrx: don't pass slot to io_zcrx_create_area
Date: Sun, 17 Aug 2025 23:44:12 +0100
Message-ID: <b1eb7ace15d227850751029b90fbca0782aba504.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't pass a pointer to a pointer where an area should be stored to
io_zcrx_create_area(), and let it handle finding the right place for a
new area. It's more straightforward and will be needed to support
multiple areas.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 859bb5f54892..1c69c8c8e509 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -378,8 +378,16 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 
 #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
 
+static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
+				struct io_zcrx_area *area)
+{
+	if (ifq->area)
+		return -EINVAL;
+	ifq->area = area;
+	return 0;
+}
+
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
-			       struct io_zcrx_area **res,
 			       struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct io_zcrx_area *area;
@@ -436,8 +444,10 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	area->area_id = 0;
 	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
 	spin_lock_init(&area->freelist_lock);
-	*res = area;
-	return 0;
+
+	ret = io_zcrx_append_area(ifq, area);
+	if (!ret)
+		return 0;
 err:
 	if (area)
 		io_zcrx_free_area(area);
@@ -589,7 +599,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	get_device(ifq->dev);
 
-	ret = io_zcrx_create_area(ifq, &ifq->area, &area);
+	ret = io_zcrx_create_area(ifq, &area);
 	if (ret)
 		goto err;
 
-- 
2.49.0


