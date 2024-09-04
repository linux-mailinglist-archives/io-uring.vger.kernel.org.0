Return-Path: <io-uring+bounces-3020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7FC96C003
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9DF31F25C5E
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3F21DC074;
	Wed,  4 Sep 2024 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ndUWntOq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E021DC061;
	Wed,  4 Sep 2024 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459469; cv=none; b=uQtEyH+9Zfk1oqk73puayT18SWv8KRA+8540zGJNsH8i2ynJw92fPj2pTqjhrMEwvQgBvKeEtTBF9YO+UJtLR2V0NoQg0tGak7lNuD1t9mXG94Y/jfCPBEAu7R+O0xIKtnJm/1oRnmxXNWPlmtOs9c1VANq4PE5blY3aFmDWsew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459469; c=relaxed/simple;
	bh=xgZK/jw8ZlQXj8cIxR0W7ybGVnlcP1lJNS+9Q/l9a0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh3EvDk3Lo25T1Ehc5JXhdQzNnJ7foPpANQOqYpIZRlq31RkvMD9fa3m1o3EiYtnCEaMMDZ6Brcfnh4gn2uSrVRPzqMOqGbSHkl7Yp/WAisKVqdxPI2bH7hDpUVfZpyxxMc7usHCnTBPtJemdnTh2io6YqoQpq41v9uUYFR/LZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ndUWntOq; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a86b46c4831so775420666b.1;
        Wed, 04 Sep 2024 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459466; x=1726064266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=ndUWntOq4XJuMpOUjj5eavzRr2ekQTut+8DfyAj0+sb33Es+BYAd6gWznWpmbnA4YN
         cpSuLENaxhzV90evVeXnKR+O7F5FfUroEZoZWAlXMizMbiaG20X9BvgwhQBAaXa2cRhd
         RoHjtjJd9xD7y+hPR6ij8pk8basOg80XDzXR4gkhq1VSV/YmWzoCLwtwg1IxXsvOn+Ch
         ngyWm3wZobfq5usju5jgMyzL1OIUS+rLj7+zGKV/hvTgYszIkbm84tbz/4YduStkhNei
         FBsi1qCSR4lPeVfMRJRakkIYcNGBAHDjuMTlez4hkiLAiRCC7brV2SUWi8F92d9J+ir6
         Qmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459466; x=1726064266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=IMJckxDeh7ps/PdQJ4ZWgnj/kRKIfvbuTjFp3xmZ7dVhophER5BGVG602Q48O9Ti6b
         f9F8PEoyYUAiuG150Iir9CPqd0tDZVzBu1xC2niv6NfARZMkm9fQ4zxW5NWxafN09ad2
         AV1guMHQZL5RWfqksW3cMogjEZKuXx5RAjxOwQB48LGO8yK9YHJh+CukOV/1qJLVpG3n
         rDMbOk8IDMlC2sc0T3BLgg221hu0gNiE3QHXc2GnxjEV62psLsHx8qW1yg13iH+LwrAc
         jXZFlN2D6G4gMthKbNYCadMwSUZAYdY2UxqzPIsI0RuONI1ObRfVvIf5BAVQTzdr7Fwr
         oXZA==
X-Forwarded-Encrypted: i=1; AJvYcCUZsMD+x/QaasOIIUC3GDqg46Vyo/GqaDVdSWw9cfmW+wK1YhFVPwLSnY0P9xMgni3cEkhBmWf8lW1rZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXYMlmTAQeyKuaxlqIA6Ji2z1+N/QCaiwGNfyxf1jSdiqWM6zQ
	aSlpzKgyzshjGsVIx9S4WYbXDO2bjW2UCs0aQC+BbbhLZ36ooeYtmlH6lw==
X-Google-Smtp-Source: AGHT+IElud/tGXrs7q4hPENcWMYIZSj7RTtRqWMNx0QoFf5mcRK9CPIkT2ZU7thyj+ZNDXYdgCuEaw==
X-Received: by 2002:a17:907:a07:b0:a7d:e84c:a9e7 with SMTP id a640c23a62f3a-a89d8848bd3mr1056922166b.53.1725459466090;
        Wed, 04 Sep 2024 07:17:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 2/8] io_uring/cmd: give inline space in request to cmds
Date: Wed,  4 Sep 2024 15:18:01 +0100
Message-ID: <7ca779a61ee5e166e535d70df9c7f07b15d8a0ce.1725459175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725459175.git.asml.silence@gmail.com>
References: <cover.1725459175.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some io_uring commands can use some inline space in io_kiocb. We have 32
bytes in struct io_uring_cmd, expose it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring/cmd.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 86ceb3383e49..c189d36ad55e 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -23,6 +23,15 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 	return sqe->cmd;
 }
 
+static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
+{
+	BUILD_BUG_ON(cmd_sz > sizeof_field(struct io_uring_cmd, pdu));
+}
+#define io_uring_cmd_to_pdu(cmd, pdu_type) ( \
+	io_uring_cmd_private_sz_check(sizeof(pdu_type)), \
+	((pdu_type *)&(cmd)->pdu) \
+)
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
-- 
2.45.2


