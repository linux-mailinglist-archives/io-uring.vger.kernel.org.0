Return-Path: <io-uring+bounces-6100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81769A1A9CE
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 19:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A220188E2FD
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 18:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFAB14BF87;
	Thu, 23 Jan 2025 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OC1cdH//"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF0A14D71A
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 18:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737658081; cv=none; b=n28Xgrk74sDgbMjTdhvs2khXt5e+AnHX14Jxua85TDcCyXyF65+eZSx82v6/ZnfR9I4czC2MsZo30LJ7aN/7M6AJ2zmicfoFE2AR1lvMoiJzRXGolCWodUX7NpE/uxoiCdpvoZOeQpqRZcQSd8gVlBF9cLdtEZeDKy931W++zlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737658081; c=relaxed/simple;
	bh=Xns51Vz6Rh7C1fPVD7AYCURfsXegQLXtQCL8ZmomcTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5COqkGrdPbc7hhc00Uyv6ZJfWXcryZH5itnoaQ2aQ9yhCOEUqPAKJAASa62kdwuUn9q6vc92EImSIY6hdw9G+zu/kiE2Xbyj/ukrKMEFAExP+A5j6k9+StoKDoz36BVw17lbCBPofHlnf85kHbE4lBB/yexHgBGUgRqI6E0Qg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OC1cdH//; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844e1eb50e2so34633339f.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 10:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737658078; x=1738262878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nsc4bN2nBFss96MyL7dPMTjUepgDcEWleenTGlQx2Lk=;
        b=OC1cdH//krQQC9FF4kEZJ1AMXFtNq0zf63ZPksDPTozDf1QUWOl47tPSLqq+pmd3RQ
         AJ8j5KSXATsvRhRY7bH8zVgx6s/eOTIjVe1b52+qlAY/8YwAOIcmBXkYSOmzUQbfSutu
         hV2HxdPst+mZft2kbRZP0RYgYA48mmy9eQyfWaOxI+3Z7bHChml3TPc/O7J8k6Jc6Iqd
         YIG7yhc+U7ZOIibbcVvqE0ZnKlspxuB9vHXr9Mm+rvUD8KyUNqwg+plssR3JR8P2c5bE
         se2rcrobCZA67TrP3qOZ0CZjZ6hcpFy5kPXQHgoyG9NZ9+HXML4Z7bDjZZkn2fDSv8oZ
         EU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737658078; x=1738262878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nsc4bN2nBFss96MyL7dPMTjUepgDcEWleenTGlQx2Lk=;
        b=wVR7wB5/xiaziXEtHABdvbvMVjtx9lVS2j74u+CmIkw3jyCYHW2/FlwLnZOfBlmxp2
         o8RdJM4enkJoX6Hkm8UXbrnpsSLlhc4QREcTRUeU4ukuCD/iR3+lL3hjAVgMdzG8KGBD
         /IkpU12hYwqbc8UormjeXLYM93L8Z0LoyQ0oyZJkOCpMf862IEvvxyQu92SqmjuvYmDR
         CDIYUFRJVa5EYpp9BL+oT6/COax9bJFtP9WRhBcIGV8qBXKT6D3sJfU5384RieumMbbE
         M5uBRvxP0gp57Q3S17uM5zgazH9bZxA44kyY0AYQH1ohEws1rFHr9qdxDfE5DWrtvO/c
         kYJw==
X-Gm-Message-State: AOJu0YyFB/dyrsCIDxZ+GLfBMbqZRXLiI4DjeNdY90HUxwEERqwEdmKz
	1kBJwPq4ftQyCMcL1OIVOVBlN/IKTlmo9m3QTceinqfzLWkHlL5SBTtTbki5vRjXPCr7/XuJH/B
	M
X-Gm-Gg: ASbGncvzLxRNAxqJS6HxewqNIjOgDB/C0YIaIqS9FKrC0BotgwrCndSpijz9iYuoW1p
	MlqHkWY/3Ti3fcPtTej8cQycnCGLH8GCwxu6jROftYyg6Is7MB87qCk2xP4eJ5Rv0e1GnYpLFgM
	Jwrftnen9c1zyiyMEXhe9RKUzEabfFwKC6gSAwLqITFlYhG8B0WTsJH2DIzPxs1DKkBjdfvRt0S
	Yw8xdavuVonaVlFBlng4EVp7/nbDSIu/usYXpYK7l4ELjj/ulAZhPv4a0HOGXqfrfkqeFptKsGX
	Az7E52jK
X-Google-Smtp-Source: AGHT+IFR2tUDARxV/jB6Y2WFP8GrKSgStKlllGEGUIMQz6MkSUpYFsNuHbdY4msVqRvA+cfYDS/z3A==
X-Received: by 2002:a05:6602:4186:b0:807:f0fb:1192 with SMTP id ca18e2360f4ac-851b6169a31mr2326943939f.1.1737658078053;
        Thu, 23 Jan 2025 10:47:58 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1db6c4b0sm53432173.89.2025.01.23.10.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 10:47:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/uring_cmd: cleanup struct io_uring_cmd_data layout
Date: Thu, 23 Jan 2025 11:45:25 -0700
Message-ID: <20250123184754.555270-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250123184754.555270-1-axboe@kernel.dk>
References: <20250123184754.555270-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few spots in uring_cmd assume that the SQEs copied are always at the
start of the structure, and hence mix req->async_data and the struct
itself.

Clean that up and use the proper indices.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 3993c9339ac7..6a63ec4b5445 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -192,8 +192,8 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 		return 0;
 	}
 
-	memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = req->async_data;
+	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
 	return 0;
 }
 
@@ -260,7 +260,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		struct io_uring_cmd_data *cache = req->async_data;
 
 		if (ioucmd->sqe != (void *) cache)
-			memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ctx));
+			memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 		return -EAGAIN;
 	} else if (ret == -EIOCBQUEUED) {
 		return -EIOCBQUEUED;
-- 
2.47.2


