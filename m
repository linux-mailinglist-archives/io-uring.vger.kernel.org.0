Return-Path: <io-uring+bounces-7663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C91CA988FE
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 13:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEC9B444A6C
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 11:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95266265CAD;
	Wed, 23 Apr 2025 11:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZnSMPzYB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD14262FF3
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 11:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745409460; cv=none; b=pbZM9oRMdG4cEiJrAZtyzvwTMTTpICPJzWpzApx8LangHA5A57U/yX6QXA3h76lYLtQW0yw3AgEzppLRQaLwpRJGBaOjxhwkcm54j250YwSdipvtN4bp2hRwFiTMltgIp+4IeppaAPv0N9VsBw8QltIdl0IBpSb3ifqbue2USkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745409460; c=relaxed/simple;
	bh=BPhBG9V6G93SS4l085tMMTA/8pBGp98MFJGIUQSbZEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svh0DZNlsKfGdJjNnz8N3ZvLctaNgrVzsLbpkNd9WUT8uJz2DR2ztBdT3nTYNv/FnQChVhpv6KF5CYxYoJ2c1iem1WHw/h5cNB+9C7AwKhEEuU1IcuM2ra86oeTh6BEU6aBwIibYbRh/sicxWZxbPpdUlSKp+haoFKspSAr2bIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZnSMPzYB; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e5e34f4e89so11521453a12.1
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 04:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745409457; x=1746014257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzCQKpjpJHbFOa7bzgduie47wi7lZJN85+qikFyRtjI=;
        b=ZnSMPzYB9BhzmpgZjHNv+FHiHJz0/Mc0ptqmHj8jRgnRc6n1mj/XpyziY3RXEL2+s8
         sK9W4iRNaAgwk5yxR7OEWuT9ktQGslOkDiFhtCWM0tx6x3Ho3tjecjHUAYZ6s+J92v8R
         RALpeEUwTB4h8l3W18GxAbU52op4wqYE0u5EI436FHhcfGPBtiNNg4u2OemFJwllH2kH
         EMa0GnyVnGugMHEaGeXph5wGZOMQNujvW7W0AzIMj3AtbQKEGKkTQRf2bc63tR13Zjb6
         Y5wmXwQzmtf2RE6minu7uXCIS8N1DoXtNHHPH4XeKOMtgzUUrYbBdRxjqNMWC5/bE5tQ
         K2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745409457; x=1746014257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzCQKpjpJHbFOa7bzgduie47wi7lZJN85+qikFyRtjI=;
        b=hQmgBgjJbSJYYiDRBiuNLMv89TQk2A2ExTnJ1E/M/YLp9FX15KRwq5+DkBrhNWzqXm
         5IS5zFL64OjLdgU7LYbQsJEw0HV2o+OD59Cm0QoT7e0llhlUsHjnlXtQrL/h2ubnhcxk
         PQxS8zTzgGQzA62yD6QlyUXTyXZIGsiHv6ctJNCXMIQrOE5mBegufigJEj/k2v45fovL
         tL09mZ7x6R/bBmUD5vZq8CR1QC1y+UnmxrGaEQVID7LChM92E7DM4UY2SzAx6IuO+md8
         xK/ap27Uv9OwQBtDjkFRaTXmXMnjHK4TnJ93W17wTfPLh7H6YYi+hXC2VvrEbemeMT3Y
         aRvA==
X-Gm-Message-State: AOJu0YzoK+2FrIz/2oPgoIJxzl0NQTTfHJzUTnfcQfU9i3urtQt33htZ
	2guOiLBQqaxse6DQCWKaEnKKBuj0XSSx50o6zdJah6Rv0NWV/SlNMMBoLw==
X-Gm-Gg: ASbGnctPSPCIstTUKE+uJ6NKqmiixmnVldat+EM7kQBowp7+uBLRAwkBP6t27acSLlo
	LwqCE6Dddm/LeTd+tJkfDBrnNdHT/Fomu3CsaOak8PY+WTLT/qOBfklqolzEuOUdXThc8KFY/K/
	Tkz/K881hhHcx6HongBRTe+Q9RzbrPZJkJZgsIugNpC8ZTaWiudO9lt6og7ART+vlz4xN64loPc
	flcsIlLPWiTsHLJvSxzWWez/djxfx4xmb8pJrfHQ1d6sZx8TBix9PV/Tc7feipidMHk22936afz
	NGQEsQFNqcSzmb4Xh0HEDgbTF+7EySBx+w14dH3rKHlOKZNY+reA5GU=
X-Google-Smtp-Source: AGHT+IGYItAWnu7npNTeBL76b6N3LF9HF1hkRe/Qa3SjaFuhpL1iPKV9AOdksTWp6STb0fixg1wIpQ==
X-Received: by 2002:a05:6402:d09:b0:5e0:82a0:50dd with SMTP id 4fb4d7f45d1cf-5f6285a9216mr17415380a12.27.1745409456236;
        Wed, 23 Apr 2025 04:57:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.217])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f6258340c8sm7350983a12.58.2025.04.23.04.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 04:57:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 2/2] examples/zcrx: add huge page backed areas
Date: Wed, 23 Apr 2025 12:58:38 +0100
Message-ID: <e856b4e6ac2fc1bee54e66ee0130743097d67099.1745409376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745409376.git.asml.silence@gmail.com>
References: <cover.1745409376.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 57 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 3073c4c5..d31c5b36 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -35,6 +35,7 @@
 #include <sys/types.h>
 #include <sys/un.h>
 #include <sys/wait.h>
+#include <linux/mman.h>
 
 #include "liburing.h"
 #include "helpers.h"
@@ -48,12 +49,17 @@ enum {
 
 static long page_size;
 #define AREA_SIZE (8192 * page_size)
-#define SEND_SIZE (512 * 4096)
 
 #define REQ_TYPE_SHIFT	3
 #define REQ_TYPE_MASK	((1UL << REQ_TYPE_SHIFT) - 1)
 
-enum request_type {
+enum {
+	AREA_TYPE_NORMAL,
+	AREA_TYPE_HUGE_PAGES,
+	__AREA_TYPE_MAX,
+};
+
+enum {
 	REQ_TYPE_ACCEPT		= 1,
 	REQ_TYPE_RX		= 2,
 };
@@ -64,6 +70,7 @@ static int cfg_queue_id = -1;
 static bool cfg_verify_data = false;
 static size_t cfg_size = 0;
 static unsigned cfg_rq_alloc_mode = RQ_ALLOC_USER;
+static unsigned cfg_area_type = AREA_TYPE_NORMAL;
 static struct sockaddr_in6 cfg_addr;
 
 static void *area_ptr;
@@ -84,8 +91,31 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 	return T_ALIGN_UP(ring_size, page_size);
 }
 
+static void zcrx_populate_area(struct io_uring_zcrx_area_reg *area_reg)
+{
+	unsigned flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	unsigned prot = PROT_READ | PROT_WRITE;
+
+	if (cfg_area_type == AREA_TYPE_NORMAL) {
+		area_ptr = mmap(NULL, AREA_SIZE, prot,
+				flags, 0, 0);
+	} else if (cfg_area_type == AREA_TYPE_HUGE_PAGES) {
+		area_ptr = mmap(NULL, AREA_SIZE, prot,
+				flags | MAP_HUGETLB | MAP_HUGE_2MB, -1, 0);
+	}
+
+	if (area_ptr == MAP_FAILED)
+		t_error(1, 0, "mmap(): area allocation failed");
+
+	memset(area_reg, 0, sizeof(*area_reg));
+	area_reg->addr = (__u64)(unsigned long)area_ptr;
+	area_reg->len = AREA_SIZE;
+	area_reg->flags = 0;
+}
+
 static void setup_zcrx(struct io_uring *ring)
 {
+	struct io_uring_zcrx_area_reg area_reg;
 	unsigned int ifindex;
 	unsigned int rq_entries = 4096;
 	unsigned rq_flags = 0;
@@ -95,17 +125,7 @@ static void setup_zcrx(struct io_uring *ring)
 	if (!ifindex)
 		t_error(1, 0, "bad interface name: %s", cfg_ifname);
 
-	area_ptr = mmap(NULL,
-			AREA_SIZE,
-			PROT_READ | PROT_WRITE,
-			MAP_ANONYMOUS | MAP_PRIVATE,
-			0,
-			0);
-	if (area_ptr == MAP_FAILED)
-		t_error(1, 0, "mmap(): zero copy area");
-
 	ring_size = get_refill_ring_size(rq_entries);
-
 	ring_ptr = NULL;
 	if (cfg_rq_alloc_mode == RQ_ALLOC_USER) {
 		ring_ptr = mmap(NULL, ring_size,
@@ -123,11 +143,7 @@ static void setup_zcrx(struct io_uring *ring)
 		.flags = rq_flags,
 	};
 
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area_ptr,
-		.len = AREA_SIZE,
-		.flags = 0,
-	};
+	zcrx_populate_area(&area_reg);
 
 	struct io_uring_zcrx_ifq_reg reg = {
 		.if_idx = ifindex,
@@ -314,7 +330,7 @@ static void parse_opts(int argc, char **argv)
 	if (argc <= 1)
 		usage(argv[0]);
 
-	while ((c = getopt(argc, argv, "vp:i:q:s:r:")) != -1) {
+	while ((c = getopt(argc, argv, "vp:i:q:s:r:A:")) != -1) {
 		switch (c) {
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
@@ -336,6 +352,11 @@ static void parse_opts(int argc, char **argv)
 			if (cfg_rq_alloc_mode >= __RQ_ALLOC_MAX)
 				t_error(1, 0, "invalid RQ allocation mode");
 			break;
+		case 'A':
+			cfg_area_type = strtoul(optarg, NULL, 0);
+			if (cfg_area_type >= __AREA_TYPE_MAX)
+				t_error(1, 0, "Invalid area type");
+			break;
 		}
 	}
 
-- 
2.48.1


