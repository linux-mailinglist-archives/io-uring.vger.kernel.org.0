Return-Path: <io-uring+bounces-8462-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41FFFAE6288
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DE2C405FA7
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 10:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7932A27EC80;
	Tue, 24 Jun 2025 10:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAuGvOTA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8D8246BC9
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 10:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761252; cv=none; b=dcI2x6CVxY5lQNwTZLqzH4oKWyj26W9T7sEIdmnXWbmJ24YTXrMHjuTBm45yLHyvXV1podwCcHFGKsO8L9W+HwRI7NCqROcmOP0iPtfXvuaeF4LDfQf4yZT76ZX96MCUlmhgYpH4uAKkjYX+RIS7lcG8hx3oUtO3NqqZaEr0dvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761252; c=relaxed/simple;
	bh=36b8WkxIsvBTd96IzTtswtWguEK6oO5tlP2AyxVdQNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwJ7Rhin5duFcUYLIG74KCvurnnPw/sf9eA6KKcnujBOpt3aZzN12F8mdcEZuNxkCyOu54CAS9CdyZPH/4zfCYEMVULLurhVugmlcDZWtUcuuQs4hzeTX3r5joZtrQdJzPnaJ2rPsnbMcD01yekw0LZLusdMPKEP0XBbJNzXdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAuGvOTA; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so10260719a12.3
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 03:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750761247; x=1751366047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifnudvT5QKgubVfUjmEgaYlQlWiy/1gzOupemy+pjfo=;
        b=RAuGvOTALm3d0GhdpFO6U0xPh4FusL0ZH7RVW+KPOo0jvL83IQ7WUiGW9f7hXhhoyu
         c6hnmN62P3VYvr3V0Z3DUF2lLERw1Gi/Fvd6IbLvQhxxRMCo4iUbV5mnU65mKI9jP8YR
         PXnWRRwSfRYII0LOH4aG82gt7AHm6xFNR2LlmgjXO5BTi6555ej3tSYOa+9YLmyu8ARD
         L5ewkeTUtFw2PWGDgnexFZugO3ru6CHs+xJdwimj/dqFF4aSGPyPG7TOHtQkZ4JqsExP
         6DKIWu0OCwLhvXOnI5A0EIs82w0bAzsUONEdjXcyb6R7SIj228BabVAPYmuXlxEabQC9
         j7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750761247; x=1751366047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ifnudvT5QKgubVfUjmEgaYlQlWiy/1gzOupemy+pjfo=;
        b=XkOrRXKv8UCd9nL8lW2rFOyCP1MRjlOG3kKIYx4bLm1Hy/K4mudoa4mw8HO5HaCcFg
         cKlH7VgPAVA7SGNN0eVOzqughqfs+G0YsgTqZnk0FsvSKeoml+o0ykGCx0j/BPovNKgM
         vfIzyIkZ+4v2Db1J3+6b2NYc4nANa/5yQBkMdNqBJjPUiEj45FsnAm22y2kzO+1MDpoq
         9GXdblLuO/hC9zy15uwX8/yPb89vNM2wBO0jEwvNCZJTi7JhQ9Twgf7w8b3RUoXG7A/l
         Qo5MqtggsdjpR5B8qx5G/jEp05XEVqQ9zUxpKZAxb5fSncbH7SRz3zr8BT8zhgUJithh
         oN4w==
X-Gm-Message-State: AOJu0YwTy02Rsu+oluYsH1ymeP845JUchees4xBqvN5K+Be+CpGq1YyH
	SZ2CKtWJ05er1u9KhWPbh8GUoFX7AlcFqWucP2mUze0cItFgQrG09cYIep4hfg==
X-Gm-Gg: ASbGncsZYkbBK9qAarFs6+tUXJTCv29yiCpUPmU/mWW0yE2yD/vT4IC45LvhxHyJ0qN
	RGuvFRC4RwoXU2ZUeMcYZwNXClHB3AJgGZ3VcTSPBvDfbXVQ+FLTBQRuk9ua69qXC2YG4ad4uzQ
	hJWsjPbsfgGNeiJK8VmtNXQ21jMqcUpIIebP22xox6JvMPa5GNWYYSQc2tK8nVRhtwkyAjBWt6z
	Ij9sVJwGwQn21Y3/29eNI3oObZAn+kI0KPyAqUr9J0AWCKZWE4SvBbMSb9Im7/Yg+oy7qYN5xHh
	9tMGCKgOTiiI/aB3bLEkTn/gSienYi40yoLa4paPBs+qZA==
X-Google-Smtp-Source: AGHT+IGIXS3YwFCvvgCOwlVuiNV7o27odL0sY9KN0cPHmtsC85YKeEHKny0dTqOWBS2B05IsfwSH3g==
X-Received: by 2002:a05:6402:5241:b0:607:425c:3c23 with SMTP id 4fb4d7f45d1cf-60a1cd1ac35mr13709131a12.5.1750761247230;
        Tue, 24 Jun 2025 03:34:07 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c3c213b1dsm320999a12.54.2025.06.24.03.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 03:34:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 2/3] io_uring/rsrc: don't rely on user vaddr alignment
Date: Tue, 24 Jun 2025 11:35:20 +0100
Message-ID: <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750760501.git.asml.silence@gmail.com>
References: <cover.1750760501.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no guaranteed alignment for user pointers, however the
calculation of an offset of the first page into a folio after
coalescing uses some weird bit mask logic, get rid of it.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 8 +++++++-
 io_uring/rsrc.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e83a294c718b..5132f8df600f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -734,6 +734,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 
 	data->nr_pages_mid = folio_nr_pages(folio);
 	data->folio_shift = folio_shift(folio);
+	data->first_page_offset = page_array[0] - compound_head(page_array[0]);
+	data->first_page_offset <<= PAGE_SHIFT;
 
 	/*
 	 * Check if pages are contiguous inside a folio, and all folios have
@@ -830,7 +832,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
-	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
+
+	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	if (coalesced)
+		off += data.first_page_offset;
+
 	node->buf = imu;
 	ret = 0;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 0d2138f16322..d823554a8817 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -49,6 +49,7 @@ struct io_imu_folio_data {
 	unsigned int	nr_pages_mid;
 	unsigned int	folio_shift;
 	unsigned int	nr_folios;
+	unsigned long	first_page_offset;
 };
 
 bool io_rsrc_cache_init(struct io_ring_ctx *ctx);
-- 
2.49.0


