Return-Path: <io-uring+bounces-10373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A55C2C334A6
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 23:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33D403BFBC2
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 22:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C93346E6D;
	Tue,  4 Nov 2025 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="n6fua2qd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9E5346A06
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 22:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296308; cv=none; b=bQBMI5snBuPjLPy+rgRQbxTW3+5NPA/8XgjGFdSuujYXWc6Z8oAasiIeymN8baqcoP576Ax7xxnq1/hBUtg8yBoqFClBHre5uQ/boX9gjUntICDIM6TOXb+309/F3w5Y6wSnDYvZrkhsbFnDn7ldkzhm10xr2WBoCk1XnJnEsHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296308; c=relaxed/simple;
	bh=OnQwrnQwwUqEblqMRbXwbgusXkiUsVAwoIi0re25Rj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB6AyRUEejqMCRhCJ66acI8Re49LuguYD2FPf+L+lye37T/9rFjyMskLV0i2jjzpN4IYVNrX4KOEwf8FtNHvgeMoqmJClEpfQ4j13XURzMA24NBpjL23PTDtSYkO2tm6FEPRGgVRdGP4iKzj+uKn+ThGgqpgkpNlPVpZ8hOqbrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=n6fua2qd; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c67d9577b3so4149071a34.2
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 14:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762296305; x=1762901105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zl5AueX9y69Syh0VRS3pOT1pG6hKOR/QkhQ5Z2KXFk0=;
        b=n6fua2qdPMePrSMETl+0pyKhGQtzDbZAhBhhUzOoO3PxhhkOAWeT7vfv8pOGHxWNZ+
         gX+3yNWiKldPknFpMEk88M+y4uXEXidqOOf+qBcXj8V4nI/BLjga7S7jw85CTkySgInX
         7xPO6e50SWHnUznT0uhadKJd+AEaaXMhRoY4TvGrBSowvt7FErFW9qhKxfMThwAo1YX6
         z2KPSgr34iKBsAdTe6MuJfvPxqKVk0z0OU58tns8IH3q3RYVbFokugFvT8L3Nbnd+psH
         hIuz18lA0OoM0D8N+TwpZVN3DlYViJL38WV2Fz7htcXE/ETd3/6XURzzA8evqYPM0Ldd
         xMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296305; x=1762901105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zl5AueX9y69Syh0VRS3pOT1pG6hKOR/QkhQ5Z2KXFk0=;
        b=qrqFkxnHdtA1SAQDX6jMN6znWbGsvvuUDY5u/v1Z6UGN+47KyARcS96uwwgAIFwMia
         UwXeAljUwkg/zZs3RQI74y5+KvsQyFA/5plwpuIVpAhxip1IQ7pEYGZaNLuo9v8Vu7N0
         eriAfckHbWIxwukAojha6O5kzGKa3ZLCuEEjF37Kz3Gs//D99H4rTf3qSI78d+Ow7JfO
         2ArIB4j0tqQkL51L9h3d5YFOsxgb37oHtSlyabWDMYmnPpgrfRK8cxiiuJyc7cIKK20h
         8y0WHN9TENc115dr2OPvJNWHzH+pvy9L3v7haE1C26Drz5buqco+HOS2K9bo829nkrhJ
         Ak5A==
X-Gm-Message-State: AOJu0YxsJD5BoICe/ccQz8HUODf2bukkWm2olEfqm8utyKZd1cStm0Vw
	nFlkcJd434MRhhRjnPIDmyyfVL5aw+Xw5U254B79YlNhV41dJ55cTQOcu8m95ghMgoh42MYZeZ6
	DA1qm
X-Gm-Gg: ASbGncuu2KW8Zqf1HmW/Ps+Eq5WUi8M46gE79ADVC7496NwgLaZKWwfqC55JVgVrqEb
	i7CsuVI7eHaGUjAVrTAanOVyHlQfuSKzAWGDzMFmDGa96DNnbht+fs+ZuCepKEWcXasbCrrdskL
	4S8WZb1YOp6bC9VaxE+portQr3DgIcXC5nIxbkQgrUHwp5poqdkYeZJSl+yF+t0hX4BOlM3dOOe
	NHnSCm5tNQMxqMXtti5fuMTKMPvyTzURg/tPUASeWxZaJK3cENjMK4A7KO7AtwtwC9hdbwh4B6P
	m4PagG5mWMir6NDG6+acY/7t4P7Q31wPbXyvJEvw/3rN2WKZEmdJABevbaG8PVTukmvlhoJZl9N
	S6a8VdSsR6aFQ4H4gA3yYPktqBj+tVS0AGoQG1qNGwY7WyyalgwEKjQQ9Jq2EtjZWhIOMDkNqEp
	JFsqUrJoaFcECOXrSyVeQ2nBKLTA78
X-Google-Smtp-Source: AGHT+IE/DBRm5OHGWWjbYLKj6mdBAxyGMMh2zA8n7j+rXhr6B7ohAUBtqlksw8SOgxmuDEfolKE1eg==
X-Received: by 2002:a05:6830:314e:b0:7c5:3da7:e03d with SMTP id 46e09a7af769-7c6d13cf146mr540976a34.7.1762296305095;
        Tue, 04 Nov 2025 14:45:05 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:3::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-656ad07ec83sm1194655eaf.7.2025.11.04.14.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:45:04 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 4/7] io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
Date: Tue,  4 Nov 2025 14:44:55 -0800
Message-ID: <20251104224458.1683606-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251104224458.1683606-1-dw@davidwei.uk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_zcrx_ifq arg to io_zcrx_free_area(). A QOL change to reduce line
widths.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 30d3a7b3c407..5c90404283ff 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -383,9 +383,10 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 	ifq->rqes = NULL;
 }
 
-static void io_zcrx_free_area(struct io_zcrx_area *area)
+static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
+			      struct io_zcrx_area *area)
 {
-	io_zcrx_unmap_area(area->ifq, area);
+	io_zcrx_unmap_area(ifq, area);
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
@@ -464,7 +465,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		return 0;
 err:
 	if (area)
-		io_zcrx_free_area(area);
+		io_zcrx_free_area(ifq, area);
 	return ret;
 }
 
@@ -523,7 +524,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	io_close_queue(ifq);
 
 	if (ifq->area)
-		io_zcrx_free_area(ifq->area);
+		io_zcrx_free_area(ifq, ifq->area);
 	if (ifq->dev)
 		put_device(ifq->dev);
 
-- 
2.47.3


