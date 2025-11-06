Return-Path: <io-uring+bounces-10419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D880DC3CAE2
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D567618966A1
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E3534D4F9;
	Thu,  6 Nov 2025 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XU1F4JP6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3A134D906
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448536; cv=none; b=Gl/eI2fAdjNYVlHK4MfWfRZOsOUZKwuzpaarA5zedXes6bTWXC5lXqoa+7iBYU//0z737qTjIYaeyyEsDzue5oyfra1XOJG/AoYRnwc4STBwzjKKU31DdkU5gaaH+OiBQs+Wvk5TIeXzBeyYWCDvktVO6henJKTSL7DaatPBAQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448536; c=relaxed/simple;
	bh=U2myZZQLhx1wnISk7UEIP0bdxDd6ffiyfw/sprZqZUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpq9d4cKVDoySROkz24OZROdB1DGQeDKHQcpkpjBY5lgXF4GqCi3GJMo1sITf6veyfyNk9nrnFrIf3NGPYvbp8MENSxJ9kGPnjVEyqRVb0g8qLpD/EKxmcDKJm0nkpv9PcMZvwDE87xxiLEh8Ibz9815KkLQv/5LBgOA2LmSo1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XU1F4JP6; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-429eb7fafc7so858562f8f.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448531; x=1763053331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RFFlaQ3tpn2Vfsq4UdJaonS6DwaCd341okxAhKLak8g=;
        b=XU1F4JP6xkl8iZAD275EfnisuB4KkW1IOdWsx2IyL1mczcqOKQejzudFjna5MNSZfz
         PcAC/mqDoHazFD5mRU4UoA116YGWVfgH/FQk1kIQRv97CuW4GZ59+TXNHISo3SU8nX7T
         4Lwj9gd52mdCHsXJgU6+Oi113ri6dSLs7d/DXLqd1ls1DCtQHjj2bbWe0bUt2kPyFLHE
         k9nDKKhKAOi0IIy15J0DJq1JN/YvqgNE9sjxgqonTpaa3RBRCKI48oT3EoAiZsQ525yV
         6KOCShic6iuhPh8DCvH1oqYCGCZQJ+CAUxOhPstf6K4y0u/CgyW/8pqYbrCkW4m6sG5v
         e33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448531; x=1763053331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RFFlaQ3tpn2Vfsq4UdJaonS6DwaCd341okxAhKLak8g=;
        b=GOaDDgeOHtjm6qn35DZMX40xyhm3WztqW/uHhVA+Gdnflp/Gj9vArvrsrNFF1GWxLz
         +lK+RDRUSHEmkiCn1xQbY8mXdZ1b7P5Fw3OhS68lGgHUmJeMAXkMnQUe+ZMrNHWEYUlu
         g5Gsy8xYTNrsoVF1kKPF+gLh4AyyDLxs197vRYD2o0yAVyjjk85UFopaJXmZPi5zQMoG
         pWm6TtTDXcYmaoXsy0cg50qqjvPwClC081xFJd5AeLaoUUdzS0PxbvLP8bvWXjFyhwW5
         F1/m7VCzqI3/N+i2+8+0Hz/tT0k9tIleQrsRtzTd+YzrHpiyoHpkziu4RpA3jPwgLh/4
         g7ew==
X-Gm-Message-State: AOJu0YzlVXwsOPzY82BWx5eZfaE8H77Rr2t+ZzOu+9h9NcUwo0FZSsov
	GprKZxw6mKtl+JuWcPATUvgd5mFAoxMUTsJCygGV7ny0qB5TVtCrYt8q3u/22A==
X-Gm-Gg: ASbGnctbTfV19tfdwtr7YV26AftueFtcOEnWF///gdPvij/hzx+vZ2y1kO4BeboDUL4
	+sQs83dVMq4M0Uzk+xx25iDnaTL+SeljTV/CbH+jf8+ozKae+ARZumx0X64E9VTPYgVS+ux9+9m
	60vDa+n9wnIw1gUjlDeMjOqmu8b9uzrJbzvWUbuCG+HeAQKMqxFJ1Jb59cLHvjagprSCGNx+2/T
	Lmu+WyXXLrM50LP58bDTC2Y+WRn3xyJVh9bmKYKifENQTMArk2oal3ERA+RZHBMQ7cNvz3JvM3B
	dBBsH1Z+BEusoStELONfsdQhIsHFCgi5+v2K4P1Ew9eix2fF3bDUnvbwF0FN8DJBAtKiHao3wTW
	9l1PQCmOHMVkBFnNTcess/vgi1o5vHHwWbnrKP4RRpw6TbvfXFwGfk0YWChg0eX7wMzGnHEg7DN
	qS0kU=
X-Google-Smtp-Source: AGHT+IH/vqgb6eEZ8d/H4/4GVzWnaIjWkeoFbiqNX6rAplbD/lW+tspBFjtgZbwjI+4GDmJs4W6N1Q==
X-Received: by 2002:a05:6000:26c1:b0:426:d81f:483c with SMTP id ffacd0b85a97d-429e33088ddmr7634427f8f.33.1762448530843;
        Thu, 06 Nov 2025 09:02:10 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 11/16] io_uring/region: introduce io_region_slice
Date: Thu,  6 Nov 2025 17:01:50 +0000
Message-ID: <6f31836010ab784d57dc5056b7cf821a99e47df1.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new helper function that returns a sub-slice of a region memory
from an {offset,size} pair and performs a bunch of extra sanitisation.
It'll be used later for (slow path) ring setup.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 12 ++++++++++++
 io_uring/memmap.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index b329cee8d6e8..83faef350b9d 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -232,6 +232,18 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	return ret;
 }
 
+void *io_region_slice(struct io_mapped_region *mr, size_t off, size_t size)
+{
+	if (WARN_ON_ONCE(!size) || !io_region_is_set(mr))
+		return NULL;
+
+	size = size_add(off, size);
+	if (size == SIZE_MAX || size > io_region_size(mr))
+		return NULL;
+
+	return io_region_get_ptr(mr) + off;
+}
+
 static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 						   loff_t pgoff)
 {
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index d4b8b6363a7d..fa7a45cdb6dd 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -21,6 +21,8 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset);
 
+void *io_region_slice(struct io_mapped_region *mr, size_t off, size_t size);
+
 static inline void *io_region_get_ptr(struct io_mapped_region *mr)
 {
 	return mr->ptr;
-- 
2.49.0


