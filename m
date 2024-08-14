Return-Path: <io-uring+bounces-2764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5305495194B
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 12:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F73F2851C2
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 10:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACB71AE867;
	Wed, 14 Aug 2024 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYb7WkV9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F63E1448D4;
	Wed, 14 Aug 2024 10:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632327; cv=none; b=ed+TT9i/xz0+sRmcJAcYPLagctFQC2+4VdjlT0m68fXuOqZK3hOPo7dHmqe2qDg1CdO61CHG0VMaSACwAQS2IyaV+gN/9uLK8UYzsgZP+sRFKC0FK7Emjr1PewQimWchdKprzHvdsAdrOGP3fUQiTTMbyXFf2j4ChnDDlaCmDSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632327; c=relaxed/simple;
	bh=xgZK/jw8ZlQXj8cIxR0W7ybGVnlcP1lJNS+9Q/l9a0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWn/Ya61A61X+tMxdjfTQV8buC8ewMq29qQmxnpMNppqR7I4UfWDeaDE8A0aEIIsY4a05L8JzBXLz8v+xyRnaZIfTK0zFYuqid/FMUKUUa//2E1rEwTQctK4POVzSkq1vMyzd66HZnD0IyXMint+GhT4F0j8f1aIe1YOCOk9rqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYb7WkV9; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5b01af9b0c9so6814695a12.3;
        Wed, 14 Aug 2024 03:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632324; x=1724237124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=MYb7WkV9t56ofqod+2slCDpOk8holAVgjR1BFVA6vgPnNPHvbK8wgKv7CLmw0L506G
         /KkJql3H0r/gOK/+bJXfBL9Vuwia9G8MkzIMd1UnhwWCpdBEtdk8Jg36xCETjo1fAzPx
         BeC2ocCpDtRp6oo0NWtrs4/pAWHDSEFB5UcGYazkGGGKQTFwxLz015FsEshzE1xSs8j4
         nQLueXHKvRFzpndqRluQtD0HNE/C6+g8DCP7rdeRp+uGekDpS0NdYTuymwybgDvOgegv
         7gy8h1IEakEvgaU5ATPSM0CHblXy/vdyJVpnHqAoRXq55QV67DIcp8qeCuh/u/9N/TY7
         dFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632324; x=1724237124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyZRXxiAI12SAMIbkwT8bn9l7S8e/TKEaLOeKBVDL1c=;
        b=I6JAM+wZY7/tqadQUOW1dK5lpWCKU6pAGscwQa8qHJU7SySBVC3rd0JQB6nD4DE7En
         ZVBGF7mzXbpr6FJDp5yBAfQdwnmmTM+BLXySCNSYcEj7PMvktWM5xLFF9jk2rf3U88Gs
         xQzKn+kbl5Pf1KE5PdS7272RdoUSY0xqRox1eXBMoz+U0BIqPNx88jLgw/5VyJG5fywa
         fSitsMq4vb7kpIROR22rhE+5NUjuWxV0u1dSelpyDiIOlYXd0pYBqIx7Y3RGzenxnQtK
         yrr0hl4IgXM+QuLhthb4mJfZGgVwcQb45/3dmRNMYPaVweHDt1XPEAYI8QW8C6dNTd53
         SJ9A==
X-Forwarded-Encrypted: i=1; AJvYcCW5mRbf3P2op8QmA24XJWC86dw/nBkCAZxkNHwuRUZn5QlIkvmJXM+Zo05O1wjuZx1Qq3YZxkl6Qcmp73LlKSznLS3ST+xICtnJUTo=
X-Gm-Message-State: AOJu0YzEStKKsPdLqxqzY9gF8EaeoTEscnJpRwzpt1eQ1ufUmp572avy
	rl8HRtD3etznQ9U7ZdgTkQRYgoPUcEHtRyhy2sNG4mVakXzart88it5lGbQa
X-Google-Smtp-Source: AGHT+IF0FJ+sTAvpOE9fJ0iyXXmALD7st6qSqWtNfVEYLYX577G+yNnVuj6lODfTWpASdYrnqFEhoA==
X-Received: by 2002:a17:907:e6d1:b0:a77:cf9d:f495 with SMTP id a640c23a62f3a-a8366d658cfmr180030066b.40.1723632324005;
        Wed, 14 Aug 2024 03:45:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f418692asm157212766b.224.2024.08.14.03.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:45:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 2/5] io_uring/cmd: give inline space in request to cmds
Date: Wed, 14 Aug 2024 11:45:51 +0100
Message-ID: <86ae0042c57c5904b40e19f6171f47fd3e8c6126.1723601134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723601133.git.asml.silence@gmail.com>
References: <cover.1723601133.git.asml.silence@gmail.com>
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


