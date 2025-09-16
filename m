Return-Path: <io-uring+bounces-9808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5C3B59A34
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05C904E4533
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4323081BB;
	Tue, 16 Sep 2025 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUD7jNXo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABBC3203B4
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032820; cv=none; b=U9iveyjVbuOPS0/308ZvMMx9uTKcQFJY3WSLjVs4+Vo/riCDpp+xeB4Rxq7NEWDlvdsdl/5NCaiOLijy3ZfKOuv62Gqb6b6+PsU+knZ8HIHOEErRQ7/EGVUTACtMiHXl3+SJyKHdfoxSAlA9hUVKNuoe4XCPFi2CIi3CSFwo+ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032820; c=relaxed/simple;
	bh=3oAnw+Kx3yZiQGRnIZr9OT4m3/TzESRv8vUMXi/3SFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txo1dgKvHj8JgZkWPfVbB35ZK5LYq3jPZHGzE6BEbc/4rPHWHeSlDOZUD8Ew6dIKzmEAscaRyLzhhIa4uwQcfgzBeViYXX/VQS2Ihw2aoi4ogMKB4Tokhj69mugIvSv9xBGeBrz+o/5PdTbGUc027rR6Wh8zkAhzP5uvqi58tO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUD7jNXo; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ec44b601b8so805655f8f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032817; x=1758637617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eF6kXF1E0XRtF4S52DShOyVQLXdtBC0BIsVHwqFjBIk=;
        b=OUD7jNXow1txA8VuI7lIS2EgZG+E0ojPd7jD/8HVEyzuR/E+spOxS6qmLCWVbXed0y
         lqw1YSKK7UymGpPzJiaxerlPE/yGJzlZaS5zXE9FXwpF6agiORcP2lWpJPEdAZZx/ym7
         7zxlfA4sDHgLzLdom92TGvXqKV86BWSlZu9d3H1EIima+LJkN5O2UlpBXIBHFxHVD0VG
         NvIp26Bz25y+jo2DAPFcLmSs/P9GkvqnvJJqjwwWmFMJtllH/MejekMp3H3oy4lTp3T8
         du2yeEtJztmVGZ5JQrnj31XG+RW13tgNzCUWv2wVFCaSgLy9NOLAn1wF9TgoxnqNqZ2k
         NrJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032817; x=1758637617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eF6kXF1E0XRtF4S52DShOyVQLXdtBC0BIsVHwqFjBIk=;
        b=RReRA/TdO3O/O0mvgYcteJvx9tfhYtJe7WH1M9hV3kckGVx/HaefAH9VSPgD3hiJ2x
         JfC82dKldYJEj8rH7tpOmDsYmYpLUkIO2hQN4B+EuS2VVx/+P/3wjsHZ0vbFSxw+eOip
         yPMuAUH7hwDCO3IVvEHaaEK2EWfR9JXsYN3I/ELk8S+kATrvLQdlQv7M/DRel7Eh/E23
         Um78F8b3X9yVIIF20UFkRpL5NBM3u1OnUwBaNoEds9nPB1dnpN/nX3Q6p36sGIEQXQjo
         n30kVn9YElGi0dMLTLcDYG0izX1ktSyFd9zsa8K0w9aFaWPToImoKe+gRRY4G9LBSCwk
         AzKA==
X-Gm-Message-State: AOJu0YzY1b4nfJrVlgd7gLiktOIMx57llSC0AJ0HatkVs1f+fTFegPo7
	74acLOyWuJwBVr+Jb4msqjGJCLOpN/KWjck0jfB+N057yBc0K6ncOgn3T+o7AA==
X-Gm-Gg: ASbGnctqJ003qlyROnOowAAgaCWg5bHgIfgz1W7LYU8yU7LwmyGvz3VorFnVvGtUYvl
	DNrSPvyJ/wvZrFEh7Ec2eIveE7+9I9hBoYS7+MJDV4cxBAgLaHNYzowuwTjVAwJdYLyUSyj4RyF
	5GtC4mdnLl7HXNlNBQf8848IQqBm08DosCjeWigt/mVI8BhGwRpqkPwcvjAg2Ep67WbKL1HclLJ
	gIece4cMS7d64YdGkj9EHnDeD76htFtjAHyJ7BdM80r9zEx6o8tm4dwFiQIHHk6thSdv+q7SNr8
	ffUmgyyx/yV7Ttk5sWSLkHzsD250HsXTEXagYSqiZZe+jR19SVJjKc0rQP2x2kQakz52Cjk/Ny9
	xCCHwOxVi+nWIs2SV
X-Google-Smtp-Source: AGHT+IHxq8cUoJ43lmvYc/97ACj7/JnIjgZNOSTPJfTL8MfH+JIuch7cTrC34p+rWalwouWBxnrjww==
X-Received: by 2002:a5d:588d:0:b0:3eb:feb2:a72 with SMTP id ffacd0b85a97d-3ebfeb20d7fmr4390398f8f.57.1758032816707;
        Tue, 16 Sep 2025 07:26:56 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:55 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 08/20] io_uring/zcrx: pass ifq to io_zcrx_alloc_fallback()
Date: Tue, 16 Sep 2025 15:27:51 +0100
Message-ID: <6b8c59fc12ec3ced31a8e51d1a8b5f5f4ac724a9.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_zcrx_copy_chunk() doesn't and shouldn't care from which area the
buffer is allocated, don't try to resolve the area in it but pass the
ifq to io_zcrx_alloc_fallback() and let it handle it. Also rename it for
more clarity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0f15e0fa5467..16bf036c7b24 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -957,10 +957,14 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	return true;
 }
 
-static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
+static struct net_iov *io_alloc_fallback_niov(struct io_zcrx_ifq *ifq)
 {
+	struct io_zcrx_area *area = ifq->area;
 	struct net_iov *niov = NULL;
 
+	if (area->mem.is_dmabuf)
+		return NULL;
+
 	spin_lock_bh(&area->freelist_lock);
 	if (area->free_count)
 		niov = __io_zcrx_get_free_niov(area);
@@ -1020,19 +1024,15 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				  struct page *src_page, unsigned int src_offset,
 				  size_t len)
 {
-	struct io_zcrx_area *area = ifq->area;
 	size_t copied = 0;
 	int ret = 0;
 
-	if (area->mem.is_dmabuf)
-		return -EFAULT;
-
 	while (len) {
 		struct io_copy_cache cc;
 		struct net_iov *niov;
 		size_t n;
 
-		niov = io_zcrx_alloc_fallback(area);
+		niov = io_alloc_fallback_niov(ifq);
 		if (!niov) {
 			ret = -ENOMEM;
 			break;
-- 
2.49.0


