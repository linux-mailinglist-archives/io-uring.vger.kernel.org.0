Return-Path: <io-uring+bounces-7569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC69DA944E5
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 19:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB6A73B8F1F
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 17:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6106F099;
	Sat, 19 Apr 2025 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mv/1bCMK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C73165F13
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745084769; cv=none; b=hhGhOoznM9+DfUyEmk5kkuq9OL1sO+My2jLP3u6uNK6e4mOQnO3faGBMNNNsQ1TiwQsiHtb+EbgU8ttu88N/STTAhYYaX4vc36yT5BB8rX2clFk/dorXtV2Uxxnpxci1NZSVn/y4/NyAi9575zo9aJjL5ccngB/JyaZ5jvjJtV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745084769; c=relaxed/simple;
	bh=ZgoIHnMhN7lDo1D28NkOdmb+3Hz/ivEb9c2wc5e5jE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF2YI4xj4wHFdJ+8jCndL9ioHiQ15q4eG0dnK6rqim/uxK/RX30DA/a3DTS+6sSxg4llAKSf0SHZHJ4V/egml8FrRj7NPR2ho9Q936jhOEzQu+3Jm3P42pyW5+F2zDRHZy13XqIc03poBI6Rq1e7QMhfjiw+z42kqsLaOeO2EDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mv/1bCMK; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3913b539aabso1674533f8f.2
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 10:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745084766; x=1745689566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9DHhrucDVczK/CzhBpG42sO9/PT06wZS8DQ8dBq+ys=;
        b=Mv/1bCMKKD7gw6UxxWZ05RwZQAl32z/KDfmOXWzF/u7GcEVrYrze09Rh/jnGZzw/uO
         PbKCa9+FeQ8dLmRL2iXtScr2s4ZzE0mYotpoe7XhyN8P00/Cj8PY4jE0XghdT9eSU1JX
         K/YXh1/l5fpNAEyj8bU04IZjtABnDrT/xptzMOYTYATv3Fo5W3UaM1MY1Heo0/ffDXmL
         c8Btya+QaKYfEhtAyhwDyZaiywXzk7brZN2y3rcO7k+eiijX0mHkLE31DaVoE9bGfi3O
         PL8/27P2KNfYmqU5WND8oWsIdrg4TtJpU0rkJAIGivAh/uogjLX6ALZlGezCoKR+jTEM
         imgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745084766; x=1745689566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9DHhrucDVczK/CzhBpG42sO9/PT06wZS8DQ8dBq+ys=;
        b=YGNL+YoW+80euHPU/bgrsZXFo7rqfUMi7MiH5/W91DiwZd+YI1SxUxIPZ56q6ZGv4z
         GnozaAwgciDtCZXszcpk8ObR8luJdhTQHKzZqPujhQ24l+1rfkCBgwSCh4cffBLmWBVr
         g06HSqEAFSrcvwpjQzejg3KO9BIyWrGiwmLA5hFyoAiepfuyO+YhJrTSZE7zrvVKr3+H
         s1o+xNKOlTFn4GS5GlUzTTkPTLkZ2BC4Txx78MXap6GaGYQUkG2EP46RAL+9kBtp7vIH
         J2F4uw1bCv0maT/YfUlhjCEbzXXGEmnUPZ4ghlmRdY0CRldMqpPy3wSmmwyznvwfDJ33
         q4xg==
X-Gm-Message-State: AOJu0Yzt+C/3cYWvwJZ/xdsx/02DZ72lLCk7GowEaluqxV6/1pOTMo6+
	9zED6iqRxu2EMy1nTraQdJxEDQWtLd7TXQdCHkRPGgtYuc6TCtgyN5/rsQ==
X-Gm-Gg: ASbGncv5bDAJ8wyR9CgxpVJmAhW2iaStx716Tqo4U9Ryk5ykLUNNykB9d481vZdAWcG
	+HcMEO9gY0XZJ8QbaUJSdQH+3ERZPpA+jvQTkvFtuE+dIoB+cIwRKoN654/1vqrqzQsSxZGdPhm
	a+DFP6Goo4u0qt9k5siZ5WBzhJgWTR5WBCH/dnx+P4PqklWiZQNOL0m5Wiepc0sfvBGv1g0zsra
	YmyJKhE53W0Kh0owAZS1A0Jwtg6R0xSC6dF+9YCxBhuRFLinRkiiSSetTZbMLHWrDDUrP3/wPeC
	Bx6JcY3ibqXOrgeC4WqvHCgmXAEiMmpmkINLkEAKyfKC1s7xlRwx1w==
X-Google-Smtp-Source: AGHT+IEH/U1z1WOlsZdK0Isx5JP/H57NSsgPpsF+2kdtJVINuEf+KrOC6YgVx0ZFzXfOeZQnsUyv7A==
X-Received: by 2002:a05:6000:20c6:b0:391:3915:cfea with SMTP id ffacd0b85a97d-39efbae06b8mr2741295f8f.38.1745084765891;
        Sat, 19 Apr 2025 10:46:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d6dfe2esm69632785e9.34.2025.04.19.10.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 10:46:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring/rsrc: clean up io_coalesce_buffer()
Date: Sat, 19 Apr 2025 18:47:05 +0100
Message-ID: <ad698cddc1eadb3d92a7515e95bb13f79420323d.1745083025.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745083025.git.asml.silence@gmail.com>
References: <cover.1745083025.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't need special handling for the first page in
io_coalesce_buffer(), move it inside the loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 40061a31cc1f..21613e6074d4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -685,37 +685,34 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 				struct io_imu_folio_data *data)
 {
 	struct page **page_array = *pages, **new_array = NULL;
-	int nr_pages_left = *nr_pages, i, j;
-	int nr_folios = data->nr_folios;
+	unsigned nr_pages_left = *nr_pages;
+	unsigned nr_folios = data->nr_folios;
+	unsigned i, j;
 
 	/* Store head pages only*/
-	new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
-					GFP_KERNEL);
+	new_array = kvmalloc_array(nr_folios, sizeof(struct page *), GFP_KERNEL);
 	if (!new_array)
 		return false;
 
-	new_array[0] = compound_head(page_array[0]);
-	/*
-	 * The pages are bound to the folio, it doesn't
-	 * actually unpin them but drops all but one reference,
-	 * which is usually put down by io_buffer_unmap().
-	 */
-	if (data->nr_pages_head > 1)
-		unpin_user_folio(page_folio(new_array[0]), data->nr_pages_head - 1);
-
-	j = data->nr_pages_head;
-	nr_pages_left -= data->nr_pages_head;
-	for (i = 1; i < nr_folios; i++) {
-		unsigned int nr_unpin;
-
-		new_array[i] = page_array[j];
-		nr_unpin = min_t(unsigned int, nr_pages_left - 1,
-					data->nr_pages_mid - 1);
-		if (nr_unpin)
-			unpin_user_folio(page_folio(new_array[i]), nr_unpin);
-		j += data->nr_pages_mid;
-		nr_pages_left -= data->nr_pages_mid;
+	for (i = 0, j = 0; i < nr_folios; i++) {
+		struct page *p = compound_head(page_array[j]);
+		struct folio *folio = page_folio(p);
+		unsigned int nr;
+
+		WARN_ON_ONCE(i > 0 && p != page_array[j]);
+
+		nr = i ? data->nr_pages_mid : data->nr_pages_head;
+		nr = min(nr, nr_pages_left);
+		/* Drop all but one ref, the entire folio will remain pinned. */
+		if (nr > 1)
+			unpin_user_folio(folio, nr - 1);
+		j += nr;
+		nr_pages_left -= nr;
+		new_array[i] = p;
 	}
+
+	WARN_ON_ONCE(j != *nr_pages);
+
 	kvfree(page_array);
 	*pages = new_array;
 	*nr_pages = nr_folios;
-- 
2.48.1


