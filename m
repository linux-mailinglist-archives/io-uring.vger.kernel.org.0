Return-Path: <io-uring+bounces-7624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 589C3A96F2D
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C611817D078
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A294028A3E1;
	Tue, 22 Apr 2025 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8oM+hJh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EBB28C5B5
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333018; cv=none; b=Lk3COMHVDXON6k1Z8Z/qWqefVrWAhCMCL4o/PBycCFy6ZK6e3HusU5lia/VFu1yj2KN12u6n3DlNS/JetsSskaOqFHrXWC9jLVDEmbDqzHx1iaZ7cbk2JcRo+1cgQB6sD+ELxKgsb7vclk0A8Qsijs7NTkELSvGZ6W9zJIyzFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333018; c=relaxed/simple;
	bh=DtonLjPq4N31zC1+E/vn6jJI4cU7QWuIUf1Vh0AycqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWteOKs2RIKG3UmwmqJXsT/uN6vNJcZcjvVhkOQHYJcVI9Opt4o9x1zOGAp9jq4os0BHzXy6uFJ2mMKygvJuPK5Ac/cmmZ7VFs5h86StfpD+g+98s82eokGWvlhYjivc15lz+NE28+ERY88HEoFr6gRgEUfTKVoaTBHKJAbEv9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8oM+hJh; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5f6222c6c4cso7179165a12.1
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745333015; x=1745937815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6l2TdbAPBudxa+Y/qiohdoyXLjFPHXVgs+knxk+1E4=;
        b=i8oM+hJhzxq0Rw+xVoRXwxJXzFh/Dmzt6y2aTe/YMDZlhVlYIG9SlRZUc+sbmHIy2n
         UqgftXfczimltpZyB/cPWb6AcUoKKYdkBvuiR+rJIlLEoVDlDBHKkIZauOzAdrrE1qm0
         yxthHaLzoHjNaEGUGlm+twJWkPWE3haba8XjfLs01oOwYMnOq7u9YRhqwKPNe+muJ+E8
         tgtXXe/JRwCU61fkZAIzlXAErdJzZu3kJ2FcxUDkfwpXrk/7pnp/5HrefsZvf3+1BkQ7
         1VcwLdLNflcKpegQdS11ytiWB07u9t2EaHcvd2DWJGmdH0ZGkuzP9574gQsLZ6jQP4TV
         Dujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333015; x=1745937815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P6l2TdbAPBudxa+Y/qiohdoyXLjFPHXVgs+knxk+1E4=;
        b=YEBe7jsZUrjzDwJGeUj2yuH3xUauyYqQz1DTl448h8K095M1NXOTVcfyQKvHK3pKz4
         l5dBL0Yvsk7GdjYxG10F8XzO2DWV6KYSOGwewdZpXAsQ7TryvXG3YSR3WDamJ3KTdBQg
         y6Jh44Y4ZVXvU/P0vFMValakq3fSvPZ1/7IdKI4NBiSnjt14edA3mJCktwBOgU9q1LPf
         pZ3skF6ggjiQUekDggnB3sGnLnxx+ThgdWmdgvdRXks4A0JW/KfF7pTkK47NfPEUBIeq
         2/SABwRolIGMu6msCoiE0rY1Zmr18gci+ID/Zvne1x54iRlSjv/HdX+zTdpp4p8ujr7f
         11Cg==
X-Gm-Message-State: AOJu0YyvvhQL1r++/xksjtXzRaVCmYtak/YoQWSnNWYBr5wUlswX61y4
	XHTO33ddVcFAXwf9YPr/SRNRKULM/Z7X6vDarXRmjJCxKncGy+X87w4RAQ==
X-Gm-Gg: ASbGncvQliFDq8Cut0Vs783b9JaTLDvf5+kKTPBiYK3mRRSjiWnrXbYZxS8oZD6qtaZ
	5OJORO4u92PGLycfcmZ54+43+WIRLjAiifZ1yhvaDzRJp9++RQCb3by/6SCMaU7XPTUJLbNZIUr
	owO1OuB5PzRR8hr6MLJGta9utlR19M6uS66FgJ03WTKCzG25SNE9SsBIwThofm2aKW2lP4wj9K4
	bJ0H7cYwGWYLLO7BGsWxj0yUqkWpD64EEoG5oHMhxrPTXfuTyFak9Cl4rsCbvCXyoS4RnmOBkMe
	e/26Xrw1beKCMlIvWkHe4huq
X-Google-Smtp-Source: AGHT+IHEjuGGYTvWopZuA49viOtL2nnDoExRsAINZ0qy7mq/VhCvw9uvRgM5uSMTyLx9ARaOx6BY5g==
X-Received: by 2002:a17:906:7315:b0:ac7:d0fe:e9e4 with SMTP id a640c23a62f3a-acb74b2c99bmr1525343766b.19.1745333014478;
        Tue, 22 Apr 2025 07:43:34 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be5e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef475c1sm655374966b.126.2025.04.22.07.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 07:43:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 4/4] io_uring/zcrx: coalesce areas with huge pages
Date: Tue, 22 Apr 2025 15:44:44 +0100
Message-ID: <fc1d31b8927631319a29f2c20c2f6c11726136aa.1745328503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745328503.git.asml.silence@gmail.com>
References: <cover.1745328503.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Try to shrink the page array into fewer larger folios if possible. This
reduces the footprint for the array and prepares us for future huge page
optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 784c4ed6c780..fd0d97830854 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -219,6 +219,8 @@ static int io_import_area_memory(struct io_zcrx_ifq *ifq,
 				 struct io_zcrx_area *area,
 				 struct io_uring_zcrx_area_reg *area_reg)
 {
+	struct io_imu_folio_data data;
+	bool coalesced = false;
 	struct iovec iov;
 	int nr_pages;
 	int ret;
@@ -239,6 +241,21 @@ static int io_import_area_memory(struct io_zcrx_ifq *ifq,
 	area->nr_folios = nr_pages;
 	area->folio_shift = PAGE_SHIFT;
 	area->chunk_id_offset = 0;
+
+	if (nr_pages > 1 && io_check_coalesce_buffer(area->pages, nr_pages, &data)) {
+		if (data.nr_pages_mid != 1)
+			coalesced = io_coalesce_buffer(&area->pages, &nr_pages, &data);
+	}
+
+	if (coalesced) {
+		size_t folio_size = 1UL << data.folio_shift;
+		size_t offset = folio_size - (data.nr_pages_head << PAGE_SHIFT);
+
+		area->nr_folios = nr_pages;
+		area->folio_shift = data.folio_shift;
+		area->chunk_id_offset = offset >> PAGE_SHIFT;
+	}
+
 	return 0;
 }
 
-- 
2.48.1


