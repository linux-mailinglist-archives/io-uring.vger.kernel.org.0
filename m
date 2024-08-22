Return-Path: <io-uring+bounces-2881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1495895ABFB
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B68CA1F21B0B
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0C039FEB;
	Thu, 22 Aug 2024 03:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvJ7vKGk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02F5364A4;
	Thu, 22 Aug 2024 03:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297741; cv=none; b=H5+dO3NX5rUzm07zOMVKvjYWemHhYsy8isRDuipEQvsJcspdnPEHFc1/K5b6orF/537PI40IpTaJriBv6p5uCnRao/WtGF60/4q33/avr8NmCtFff5tiKgXIH/z9mC/NP+2AAkJ812ha/npUSVyXnp+tf6nNFrgg07VkrtCqnW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297741; c=relaxed/simple;
	bh=xgZK/jw8ZlQXj8cIxR0W7ybGVnlcP1lJNS+9Q/l9a0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srd/86hSJC6CH93D7J02oGR8iEeRmy5FyqnQxqyvd39FPe1/muHmmuIG0UIZzQFX7iXAL8d/SSlENPLuVy6sUZH7FE/yVYBWL0CYxlpa1q8wF+KzNXcuL2MWp1wr6Uw3NBk0AvUj/lFX05BWcq07w0bKK++pM7+b0luRAEguuI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvJ7vKGk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4280ee5f1e3so2096315e9.0;
        Wed, 21 Aug 2024 20:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297738; x=1724902538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=hvJ7vKGk4ZpP6Bs7IeSiD16vSHOOntiAyv2KLQxnC4dHCJny/wQ4JjOSGZiLA6soXB
         54DhrDODRDlhpu4mWBRzRSByI87qBkA1EjQoVNBtJ19TtJPexNS9bpGASefvPLovvV0H
         /d0EG5pfSiI5fKTj26QqQMc+/HOcGjfXII5tMAoAYGZTzOrq3zP4YPBXIGMFv9wM8P4O
         OZjp3FvhcvcKsMpwZCrUXWPhyGF+9PumTq/Wm+Rk+CHV6ez8d4sqA2PZ7KFi1s6e4U2S
         fboKVd7pBOMrM7gJUcqFR4c3wSzo+QNxX8lJDgZFXIEmKBjjYocog/LUN7NVlYrP/D0o
         1FZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297738; x=1724902538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=jd7qnnBhqYOtTVusmKO5Jo6bppMVyjtQLSwhsPZ1uualrSlzUVpvjWBmBR6SQoaawD
         nMMEgso6iEL7SeSaCOEO0iZPAxJoeWzaFf4sbiUuMu14mY4Cfq5EPpxdJI/WmfUsiw3U
         BpwZdArJf2dv1qMVb85m17YKaWMHA0bE3yufrmClnvzMb2tCcDDczBRZHg2DA2WOxaol
         cOlYzFlHTa3tr638F08ss2lJfi/HzGVUjSmVQAluvpyMajZK8zOIq1Ey5C7FrIShf8+7
         cd+e4iqRiNpSlfwtsnjr0ugVTPXUnYaklLVlMH3cT0TTe5iJ9MpHlGKimvdSO5mUdPRl
         0qhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUghpOCW+Ma2yQKLmW3qUmM4sYQ25F77urGfpetu2Bg8YC/ErFT7hzXLKQf491qCYNBrsersxId/iMpAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf76i/gpH6Pr54S/P55Gs/pT7iCff5FeZ2OpZkXtwCyaKch4eo
	d3EVOXxpc7W6F6ovalN6+ec/p++G4RZbXWKx8Qghn3MNrVxX8uuKl34SRQ==
X-Google-Smtp-Source: AGHT+IHDULdLquHnuYJwxgO4fQ1bzZiZlm+YOsZaNNDGdxrpbgmJfo4P3H5hO/VE8ik0Fzd4TfAAUQ==
X-Received: by 2002:a05:600c:45cf:b0:428:fb7f:c831 with SMTP id 5b1f17b1804b1-42abd253e34mr32708315e9.32.1724297737617;
        Wed, 21 Aug 2024 20:35:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/7] io_uring/cmd: give inline space in request to cmds
Date: Thu, 22 Aug 2024 04:35:52 +0100
Message-ID: <54b2273600884f077b1564d4353c77ce2d9b1051.1724297388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724297388.git.asml.silence@gmail.com>
References: <cover.1724297388.git.asml.silence@gmail.com>
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


