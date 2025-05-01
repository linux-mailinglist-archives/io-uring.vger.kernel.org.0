Return-Path: <io-uring+bounces-7802-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 886FDAA5E3D
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 14:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 608944C3B7A
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 12:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3BE264F96;
	Thu,  1 May 2025 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jG8AaBKE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81951F426C;
	Thu,  1 May 2025 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101804; cv=none; b=oCz9E8w1Jnef5khsZxwTxnEGNUfwp+EO/hvFNUIeStfl2TIEGzO0RFeENdmyHkMcQFOpM80bzR/WMIXYaoV8jEJTRLvdqcjlf9DbQo2Y1dsv5LyK5r0r10cu7MDF1p2B0bq2h+ZEcPmOoz/yoYK3ZaDhMMx7WQuOzzDbegC9+vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101804; c=relaxed/simple;
	bh=BQp7Z6he6yzDut6ABpRjpsDB9V4puFSAxtep+k5+pjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQB7dpRGeKj9Hisizrlbcfw9owDZOGSU5/aKAMqJBLB4Wv3S1m+qTmZI2pzIE7OJVR2mK92Fl/01eN5w2LKCCxJlbdG7az1/F1gotSl+cJj4VryzYMx72py+sxClNygNxxlr97bgzEoQgszUZAkFbZi09itMQlB9e44BYPwsPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jG8AaBKE; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f4d6d6aaabso1349939a12.2;
        Thu, 01 May 2025 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746101800; x=1746706600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uk1Eu6w1tRk1DI+vyAHnAlMNBYVNssFGOUQIxh4tGPk=;
        b=jG8AaBKEyPwDyOVOn6VsK664KxDFuHsFIACHZ0UEVpzCXmFy2srFSosCJbmnFEMQLv
         Wljqz+GUIUqEWEjF4Fy1W24GIBZ1VQM7cY5pzDQzPI8s2GFMagI0w6TgQK0CV53WbbWu
         bXRz1EmlXsYJl38dPBh4szdpPYekdw7RjNT6lz86Mvbh9X854bi+tXUIPV4PivMLskwv
         3z5Vn9YihmwXl9y0DePqFkZmF9hpsuqIW+Q68MmlqzADGYjSXl5ziyzw0LnpH/5sp8hq
         Pf03opWi0Zni6gBU0w554w3jdFZe1UNnuy+Fp3TTH9m4iqZ+jMf3RHGg8QczMJ+md2En
         4NtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746101800; x=1746706600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uk1Eu6w1tRk1DI+vyAHnAlMNBYVNssFGOUQIxh4tGPk=;
        b=ZlThpjK55DkvXO+ZMXyIcm8GGnSUImR4h9OE5mBhgyidK4qxpeZ4fp5mZzh8lKEYY0
         QZEIvqFjzvR9pNWT7d746ciCKNObaSgpDlDMiJyoabGMcLNq6sVBxuuZfce5Dvlh9TFh
         bV9QW4lLu6qYmOS3dzZIODWsv89mqjKjblahhm9PvEDGzRvcTFbAWPiiHOYx4D8+hete
         /CsBksFcAWyzmm9K45J7PM4R5/4wOSxAhtTfc5R+q9b8k+Am5UHZ0W0G7aeXzts5dBE2
         UPe6GC1H81c57JnPF58kvkNlrq1+FokBrGOScAFQQWC2aZw7Ti/WstxyAwC5boB1tx6C
         sWRA==
X-Forwarded-Encrypted: i=1; AJvYcCWnk2Md9kmS4emiI+zKQ95TywGWAHK3M62CLoBNJbrkJBzekUEcNCrGAJevaxnXTv8dhyXCAhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNkloWbgb4zgAWfM8voVs+ziYFwDYqhloGwE2Y+vWb20ztzppW
	wT02OZ6DzSbpY/EdSiQWtMdMWwGyL2tmXllTao7Xi5jEDKTlC8IA3JLLbw==
X-Gm-Gg: ASbGncv8OpkMisVd6wT/ssNqu3nyaQZejV+xooTcnQkGhgUPwFNxpc/zXFPa7IHQTxg
	V7smnkjmfRVoMvz4++aFRrBACTj/L7Ml5Cuhjxcw+62YpjuEzcztLrw8yHw7flojzhWpNKJd2WW
	3qrXvAoW3M0ex2YzymLI7pfk5XyJrhlKEcn+fr1gRhRGSQiOfLNE1v/j+kZeCAG3O6k0PgHQKoG
	rrJdjZ60thqFENBDKv/X/6wI9LQVeLO6uZJhOjcgMzo/Dufmq/BredL7uIOVNcmtYIhzns13jLA
	seLhovo3oNS6jLqDkygd9iaG
X-Google-Smtp-Source: AGHT+IG95usLCyvXHsoJhbFX04aOPQ/6YehP1uEkwu5S7AOEz1ivXgdWezcb3PRQHRhe7om6k2HlHQ==
X-Received: by 2002:a05:6402:845:b0:5f7:2852:2046 with SMTP id 4fb4d7f45d1cf-5f9193bc231mr2022341a12.12.1746101800354;
        Thu, 01 May 2025 05:16:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9c32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f930010655sm346146a12.73.2025.05.01.05.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 05:16:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	netdev@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH io_uring 4/5] io_uring/zcrx: split common area map/unmap parts
Date: Thu,  1 May 2025 13:17:17 +0100
Message-ID: <50f6e893e2d20f937e628196cbf528d15f81c289.1746097431.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746097431.git.asml.silence@gmail.com>
References: <cover.1746097431.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract area type depedent parts of io_zcrx_[un]map_area from the
generic path. It'll be helpful once there are more area memory types
and not only user pages.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8d4cfd957e38..34b09beba992 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -82,22 +82,31 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 	return 0;
 }
 
-static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
-				 struct io_zcrx_area *area, int nr_mapped)
+static void io_zcrx_unmap_umem(struct io_zcrx_ifq *ifq,
+				struct io_zcrx_area *area, int nr_mapped)
 {
 	int i;
 
 	for (i = 0; i < nr_mapped; i++) {
-		struct net_iov *niov = &area->nia.niovs[i];
-		dma_addr_t dma;
+		netmem_ref netmem = net_iov_to_netmem(&area->nia.niovs[i]);
+		dma_addr_t dma = page_pool_get_dma_addr_netmem(netmem);
 
-		dma = page_pool_get_dma_addr_netmem(net_iov_to_netmem(niov));
 		dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
 				     DMA_FROM_DEVICE, IO_DMA_ATTR);
-		net_mp_niov_set_dma_addr(niov, 0);
 	}
 }
 
+static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
+				 struct io_zcrx_area *area, int nr_mapped)
+{
+	int i;
+
+	io_zcrx_unmap_umem(ifq, area, nr_mapped);
+
+	for (i = 0; i < area->nia.num_niovs; i++)
+		net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
+}
+
 static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
 	guard(mutex)(&ifq->dma_lock);
@@ -107,14 +116,10 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *are
 	area->is_mapped = false;
 }
 
-static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
+static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
 	int i;
 
-	guard(mutex)(&ifq->dma_lock);
-	if (area->is_mapped)
-		return 0;
-
 	for (i = 0; i < area->nia.num_niovs; i++) {
 		struct net_iov *niov = &area->nia.niovs[i];
 		dma_addr_t dma;
@@ -129,9 +134,20 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 			break;
 		}
 	}
+	return i;
+}
+
+static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
+{
+	unsigned nr;
+
+	guard(mutex)(&ifq->dma_lock);
+	if (area->is_mapped)
+		return 0;
 
-	if (i != area->nia.num_niovs) {
-		__io_zcrx_unmap_area(ifq, area, i);
+	nr = io_zcrx_map_area_umem(ifq, area);
+	if (nr != area->nia.num_niovs) {
+		__io_zcrx_unmap_area(ifq, area, nr);
 		return -EINVAL;
 	}
 
-- 
2.48.1


