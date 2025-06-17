Return-Path: <io-uring+bounces-8396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03C5ADD095
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BCBF401167
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516DB2264DD;
	Tue, 17 Jun 2025 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8MCQxG2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827792DF3F7
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171650; cv=none; b=ExNaZJlOrItuB8kCJv+IAPKTHC0ovvuuSVcw5F2w38zYSy6Z84LOv+eP+DpUlu2vKPWYTrTQHgye7GcbfMX3jJsLrkTIrETzHj8CSKFlpdn/OFxtlexqL1H0snoM5l4MM3NRsOSBn7wmnlw33bcTcbqGzMX/RRHw0c+XUR52OOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171650; c=relaxed/simple;
	bh=kVnbc5pailjio1TdNpuhfET4Hq01WiNozr++KC24oBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw5ZlwjX241qCisyvjEYHUC3EAmHYi0Fp78MPI64Ko1zfGhAcnKMeUGwb8iU5VMu9kOkqBSDTg7f3u6BA9b7mbS6lCydNJ78slj/vfTYRAL8BqPsg9o4lNm7PFCpocamxzRSd3eYxIz3XRsTRy7JXSPsgol3zAoDUKOQEgoUfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N8MCQxG2; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so12914000a12.3
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171646; x=1750776446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnTzHXGn3vdkLTabUOvrX6T3UlcvEvRZuRABJLfXEhI=;
        b=N8MCQxG2nUWRAcnYrlR5Hsj0NdbuNhyIK0xdRhQRqiWUy81BCT9I8VsCyM94apyjyh
         6zG5XXvXvMG/tDtYb07DTpuck0HHBqO0sPGrPw7PZVNvISwke3Av4EWK1oN0Vqgb7m8C
         sE2vQmnwjxRk9loB06w7SN9FAiEl6qHLRAr4N5SR0AfoUW8IYFw9hvzmhcDAs9ILcFqZ
         Q+EwE8DCQibDOsw87Mz8MXfPD54tUO7v7+S1cm/AVhnTlDoUFxaAs3q6kqoj7tiXbbLB
         ZytEuOw9wcM9YcM0/KoIYz1/Ty+MTfeMFXReBMdnh9do6f3WfTcLdt9bEC/FbJ/2hZ7b
         SdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171646; x=1750776446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnTzHXGn3vdkLTabUOvrX6T3UlcvEvRZuRABJLfXEhI=;
        b=BMZSo9AIgEBH63xAY75Lg6lR/zqdhpyG2DxMYxWg1ft4Zg26MX+l4iTaQeK+te85gq
         Xv0W5SM+GTHSe0qOLKTBF693j9p8aSBxM6GCQJDvTP/UeYfOOSVJo5dRI4u8KyTs9Glb
         7XdQ2s3K69RPKBAfivBncMFyXs14elv7um9wzlqK3oCr8YCTrOGHvIZQqSOOiOl4bDvX
         LK5U65qKdriJwxbjHHTAMMOF6K7NWWdxipwxDrZtys/LyX8sls6vw0CJ3HjPaGuE3Dd3
         I54cBvKTkMUkLzycaAHw2mWqeyvT+2sPfDo8LZbKAvjNROIl9iSnt8U11uu10+n/6FBc
         tITw==
X-Gm-Message-State: AOJu0YxutdGNxOq4wz+fKdqPo2kDs4vWOsGLJT43O3KVrsrxaWQOgIVX
	bd/S1hVIlRF7dtbEHdKgbBQkn4sra/JvMu5FntCurAUFoMSzLnrsKBl/Tydz6A==
X-Gm-Gg: ASbGncsYMmLeAfcj4UCJhhHgacwmY2MLoyXdIOmk6ZM6DLm4Z079KUxJotnirXqYBpO
	x0BvKhLuuQxjE8W+bhBTHDxyc8AeO3FMIiQue79vKQbts+Tn6313GBdhZnu+VAwQKNsmvKEinqv
	3Yf9i7WjBo5Nf1T5bmGyiu+4n3KuFNYZ8grmNIqm80PsZT68Fo7ar2zyIupytGwf3T9vIt/F1z0
	EAFSVlkfU0/nnYga3DQPpZLRA0gBGFfWWTQhSh0d4owKzZP8gE56y7STdHrHdwcOLrRAKx71CLj
	r3QHoGV2UEMm6H0xI8S6uONigdpCKvxN6YQzdBH1OCwlBg==
X-Google-Smtp-Source: AGHT+IGYlpS7ui/w444OdlN2xZLCAYJ567plXIXOYk0yAL/tywMFXecAAqQokCXXLUXYRsBO6zgo6w==
X-Received: by 2002:a05:6402:430e:b0:607:eb04:72f0 with SMTP id 4fb4d7f45d1cf-608d0834a3fmr12159927a12.4.1750171645590;
        Tue, 17 Jun 2025 07:47:25 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 5/8] io_uring/zcrx: convert io_zcrx_iov_page to use folios
Date: Tue, 17 Jun 2025 15:48:23 +0100
Message-ID: <257d703425d454ce1154c73ed998c758e9b01a07.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modernise io_zcrx_iov_page() and make it return folios + offset. That
will be used for the next patches implementing area's page coalescing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a2493798e6f8..a83b80c16491 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -40,13 +40,17 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
-static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+static inline struct folio *io_niov_folio(const struct net_iov *niov,
+					  unsigned long *off)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+	struct page *page;
 
 	lockdep_assert(!area->mem.is_dmabuf);
 
-	return area->mem.pages[net_iov_idx(niov)];
+	page = area->mem.pages[net_iov_idx(niov)];
+	*off = (page - compound_head(page)) << PAGE_SHIFT;
+	return page_folio(page);
 }
 
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
@@ -944,7 +948,8 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		size_t copy_size = min_t(size_t, PAGE_SIZE, len);
 		const int dst_off = 0;
 		struct net_iov *niov;
-		struct page *dst_page;
+		struct folio *dst_folio;
+		unsigned long dst_folio_off;
 		void *dst_addr;
 
 		niov = io_zcrx_alloc_fallback(area);
@@ -953,8 +958,8 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			break;
 		}
 
-		dst_page = io_zcrx_iov_page(niov);
-		dst_addr = kmap_local_page(dst_page);
+		dst_folio = io_niov_folio(niov, &dst_folio_off);
+		dst_addr = kmap_local_folio(dst_folio, dst_folio_off);
 		if (src_page)
 			src_base = kmap_local_page(src_page);
 
-- 
2.49.0


