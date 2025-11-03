Return-Path: <io-uring+bounces-10349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DFFB0C2E713
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C585B4F0A74
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E02314D1A;
	Mon,  3 Nov 2025 23:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="P21xn0uz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D82F313523
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213288; cv=none; b=UT/F9aGyi/Te4HrA3DJSUEtVennEy/Dgz37PfrP59bJyGZEZXcmWIkyEM+2IW3eKZTDD2lzcKyQNl/USse28zkoX79UkXqXXXzvW2bHKbJeYDxOGteZQ6HnGtu5QfDNOWzYZybG93ZF4tC4ceY2Zh2uln8Z1P8bj6RbmkNLlYgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213288; c=relaxed/simple;
	bh=ghVssMHpC0oIaoHxmpGAC4MvW7BGjfefvp/Kx9Ztgyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJfQu5HwG0Up3Z2pNYYYcDKFAY60NNi/E5FswkBNr4eRG1TBOB8j9hCfr89q5LzI1lYrHbAhwEU19ELboMk4kGQdOXd7F3TDp9PD3ZetHZROLZLzUzbecX0zt5VPZJds1VBCMcRIGH++eIE9VNdj5s+RAyez2FQVsGmJFwNlFYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=P21xn0uz; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c68bfe1719so1227101a34.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213286; x=1762818086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJZomHf0c02I8GzHr7Yy4RcFy4+yacK3SUBYlgxmabs=;
        b=P21xn0uzF4ija33YFqzrjY6gZpjlBuIm0Yd3WeLMNEu8MDclaoDV463ZIPjwHgolT/
         G9jVKT2uY5QmdEFw/EVwHyaRJIKVPoZ6MdG6ljCkwAOFqh2EzrHWB19rxmV8rA1atz+3
         1fhqxyYlCtyTCyNCXFxDZtm1z4oIK4mTY6rDhOqXc1L1WXCdu3Ua+wj6wzQtp/nEI2R1
         SgmGYOe6ugzdprZVOMGMoRtUJoOGjRKX0ZoIxx8IKnKrskUhPgp/MU1139p+xUcf0gXH
         F9rWV7jO2Ld0WNOrSz7MuoFg2ghaBshu6dOY3X2sexDFcwhOXguyM9PZktYr0M3VOWzs
         sw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213286; x=1762818086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJZomHf0c02I8GzHr7Yy4RcFy4+yacK3SUBYlgxmabs=;
        b=CJRmm5NhXg3Bfb4TNHtM0ElE/s+QiNJbZ9bvkIM+M0CEUAXCJnpJpZE1Yca5Kj5ph+
         r1P4Wdu+Z2OnYPeMBQmOdDry5ZJIul61MSVGXgScZockygpEbcB7QOCg3/Hnao0F3auz
         WyBVfvT6Pvnr1gvyfitnRHXz3AB/vSrBHKDObcGNV3lX0zbilAatCh/5YGptGxsdu7zw
         sBFP50hbAaCHJ2GcnVILP4v8WxIu7xFOv6XVnW2Tiy+GfA9qwmTS4Lh48jSdYsr5iTDA
         I0t+tg7LJW4rKjvBx0C82G57dBK4GMvc/iL7KC3/jV8YY+K3AEQOjV9sCjOwrEP3oy8a
         b23A==
X-Gm-Message-State: AOJu0Yxypn51bXJuDQ5aV0oaN2QwNLnApD560Qi1X9YbJlp4oGo6oYNl
	IVD1nQCYBxc/uZVAm4ON5d3ww+/qRX3EGc2/X7vH3VtyKXvvpW8hRKz6IN87Y1LaZVK0gnzL4UP
	lt0vm
X-Gm-Gg: ASbGnctfPRPjbcxAJefQdNsr8Gzuw5kB94drexj4s2hfdSMj3VdMbvr28jOK1bn+rek
	kJrDEcyIOWza7xIfvbvL/LR2UIkhWDB2uOHWow5r7jTTHBSXB8sxmOIfB/gb/omfJdp3yOb/bUE
	0n92xe0hE7gnvkl3lNdirw7pzbR9aoEjhTxelfgP24RCtpvgIaQgEHmM0dB0bJGY1dwsMUMhPV4
	CWnGQybFmzdNtHtV30d/KvSQUxBOuAB0FiZ6BiZFbR+ohkVSxtehJIRxv5mtIzqC+biIls5VVXH
	kvvDY0uX1+MBYJn8eSidqBiNVSxgSgj95iSZWuNNNnzpLd5yax/w2xD1bwuFEmuPLYg4bvOsfLW
	DJmj2fIRxQMPwvD1LZiM0CyrBj9mGQ9DMs+EkInZ1d48u9LHsdaq44S0Kf01EclTzJ9wAoIfVTM
	KJFH84uPhEc6G1WvLBjrPcBujVm1exjw==
X-Google-Smtp-Source: AGHT+IEiZd3I0fAenzcHsaLz76lpEyfCzW4bC9sOkV7QwBXstFUq7jyruycEvC0760mGwh724CLJDw==
X-Received: by 2002:a05:6808:c2a6:b0:44d:ba18:2d26 with SMTP id 5614622812f47-44f95f357c4mr6113457b6e.43.1762213285942;
        Mon, 03 Nov 2025 15:41:25 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:73::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff46fa5afsm536183fac.5.2025.11.03.15.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:25 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 06/12] io_uring/zcrx: add io_zcrx_ifq arg to io_zcrx_free_area()
Date: Mon,  3 Nov 2025 15:41:04 -0800
Message-ID: <20251103234110.127790-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103234110.127790-1-dw@davidwei.uk>
References: <20251103234110.127790-1-dw@davidwei.uk>
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
index ac9abfd54799..5dd93e4e0ee7 100644
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


