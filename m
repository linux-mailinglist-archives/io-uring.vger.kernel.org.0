Return-Path: <io-uring+bounces-10537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55315C524E9
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A2F8189EE5A
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA34328262;
	Wed, 12 Nov 2025 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pkk6MigY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CC6329E7D
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951578; cv=none; b=fW4GG48H+8+A3R2BvUsxXnirUsHRfr+aBqUpPDZw2qha/5NVVlF3X8ir7pwHsi028k2Pb5O6RjU4SEMihvzG9+35Ur9JqAwlMfFZLyNEiC2t41RlCnggWvVVUqG63elB2SdDKJ3OPqZTyfMa+zh4X6GsehufVjs+5xfOnqvRKgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951578; c=relaxed/simple;
	bh=XT9NRFwIU31uQNlDM0OHidhk4yrB4zicNTH2U9y9fdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdm3Rt8TsOftopszCvuZsTsnHp8p6x03UrEcW92aj7FnFygQNCYsJGb7tQjx6b5xnNaoy65d3kf3HbafX7s4tUwKfanbjMhwTEjBCGI5aXxPLDTn3nw36JZ2t045UbtB8AODDfcNQsG6fjf7Y/DigMjVRU7FHVWfB16yii78Ewk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pkk6MigY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477442b1de0so5614485e9.1
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951575; x=1763556375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEdNL1wRMeR9f+kbr2ahQzyEcFOSkWXdGrGD5yNcI98=;
        b=Pkk6MigYD67sJYmtAYx2Y85ZvHvjd+8G6lvumk+ZbUwPOgBtUrBurimfQL9ChiLPiN
         erV5MfGy1Jv9OCGMxqnaw1o8bcSFSqUxxh+JR/gv9AuEWrBYYDUTDdIGBDVkdg1F6YQo
         TM+MPTj6ke66tnJKHx9JBrmic0Bq9x9ocBaW34Vzhhyb7coW+UUOQ9pYCp5z7WApCL/y
         9sNrGOs44JoYdXtTIWXshW/in8iVWKCMZwsIFY4XUZKvZeUMz5FjmQjHYVPzs5OdbSk8
         gOOZ+5vKZdbOJWk96aCYMkMvk1WqWzQET0BFdP5KEk92zBi052kqqjziG/P6LBGpoa23
         mfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951575; x=1763556375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AEdNL1wRMeR9f+kbr2ahQzyEcFOSkWXdGrGD5yNcI98=;
        b=fpLmA84b5Z32CAtYt+tsE4ACvwRer7U8bDD6Z1yzTMnAzlhRJgKjypbAA6sbG/rAQX
         LDgZLS4jKmecD/VizgzmvODSyeJpNTaIwT9gDEa225O2uB4pFBxKIBCWvlKBx7aweRUA
         K3GWrjhXtJy1CjCK8dnmVMBbE5d4MlnBMkCzndjqImx0MHAlWf6vR3QUCmEykBRAzmfX
         A8LfnFjP5Xm0jigQzYiFaf4RXLrcmH+lnYfXE9AaeFm+nWrS3eNVTcUCwuaDP+in6sGU
         MdZurq3RpUYn43T4UbsCDG/4M/snXChGePTDSuViYUN3T8YE1Zn4PqMDPcsV7MDEexTt
         gsLQ==
X-Gm-Message-State: AOJu0YzWuX1rP/Ka8r3HvF5bVCDOKewyyfjb54NrOX7H8ELP8HQivCW3
	i6h7KxfVQgdKxtGcUUEuoUOb54+4OY0EgKg4+jLHRcZUCazY+kj+A/r/tP/xug==
X-Gm-Gg: ASbGncud6fhAwOtd9O5t7THI/XlRW3VoqXuBhcumVHluZUB78Lyu9apSLt/fBYcQ6uz
	F6vpx4PQ2Jt0d2RX8wREy+qbRE/0ru/qH0oFdfRbYetB2lSliX009hV6mA5emUruW6l6IuGUjqi
	xUMI5MHLBJuqu2InV3hj6/UY7cjZMrQFcBBCZv2GlHX5EbzMkx7nXYan1o82P7G1618jOCls4P+
	nszpxouCpB+N8XfHuZZAZwTYIozUIcczq1xW7D8e2ogebLltx4ObeznfeKSGiWbfGvPAqOEjyM3
	7X0/xX2JqYxRQq6fCu9tznS29PtzLw6w8ZjITAJBZyc6NwfRdRtCtXx+44XaHyndM5hf9we8iuJ
	Ek0PAh2njoVS79mfblr0xCPuf0gWWWpHAK0PhYmHuQbBjZHppkjY/wqn23LM=
X-Google-Smtp-Source: AGHT+IHJnNctZmYXDLhuZZxOFPe+FHCmV7dsJClseANjNyo4lrbDPMc7dVglpnYoSBYWMWxr9srO1A==
X-Received: by 2002:a7b:cb95:0:b0:477:8985:4036 with SMTP id 5b1f17b1804b1-477898540c2mr10358105e9.1.1762951574523;
        Wed, 12 Nov 2025 04:46:14 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring: refactor rings_size nosqarray handling
Date: Wed, 12 Nov 2025 12:45:53 +0000
Message-ID: <71bf483aa99d49a33981cbf4b0488f62f37f4ee3.1762947814.git.asml.silence@gmail.com>
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

A preparation patch inversing the IORING_SETUP_NO_SQARRAY check, this
way there is only one successful return path from the function, which
will be helpful later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7e069d56b8a1..b37beb1cfefe 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2761,7 +2761,9 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset)
 {
 	struct io_rings *rings;
-	size_t off, sq_array_size;
+	size_t off;
+
+	*sq_offset = SIZE_MAX;
 
 	off = struct_size(rings, cqes, cq_entries);
 	if (off == SIZE_MAX)
@@ -2785,19 +2787,17 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 		return SIZE_MAX;
 #endif
 
-	if (flags & IORING_SETUP_NO_SQARRAY) {
-		*sq_offset = SIZE_MAX;
-		return off;
-	}
-
-	*sq_offset = off;
+	if (!(flags & IORING_SETUP_NO_SQARRAY)) {
+		size_t sq_array_size;
 
-	sq_array_size = array_size(sizeof(u32), sq_entries);
-	if (sq_array_size == SIZE_MAX)
-		return SIZE_MAX;
+		*sq_offset = off;
 
-	if (check_add_overflow(off, sq_array_size, &off))
-		return SIZE_MAX;
+		sq_array_size = array_size(sizeof(u32), sq_entries);
+		if (sq_array_size == SIZE_MAX)
+			return SIZE_MAX;
+		if (check_add_overflow(off, sq_array_size, &off))
+			return SIZE_MAX;
+	}
 
 	return off;
 }
-- 
2.49.0


