Return-Path: <io-uring+bounces-1349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59402894483
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DF122812BA
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD9C4DA05;
	Mon,  1 Apr 2024 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tzDeCbPU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765B54D59E
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711993994; cv=none; b=DscLrI2062D833uymDf3pjJzr/mqwLmbNqMPDUJUt5iceKt/pmQrwv39HnjJBDDHZRNg9+W8WYyve0hGLGQ9+ll27N8LZBxpr/my+rM3c32CC2cNnyUMFSZMgyIzwJsbTPBkFGtfgKEpK72cHPs7+r+n5HWHj5k/pYs7OpHi/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711993994; c=relaxed/simple;
	bh=6eg0n59KBs0zRUKBf6SOF/jApkG2l9N6XA2aasOeg+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtHO6sm1SbcbFyboHkfaEh2Bv3dShNCO6Ll2WEEFeYOxFUf42HaxlimqCl42rMo1WzC3sIYbvFOIvLZlmOe+9odIv62BMCX6/HlDxJuAAnDgXjwiTQOEWIg8gZ+WQMHhrv2jPHSoa8YV03v+r6rc7UNhu+6BSgJOzgdn3YN/Z3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tzDeCbPU; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3688dcc5055so1645885ab.1
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711993992; x=1712598792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T8W3ugZY2UxWd610/Dfdbazi+rTB2V6f48BemOSZe18=;
        b=tzDeCbPUpU2iTXqs+sjR0S16Rj57eDA4pM0UKcTeKBq9itVhBS0eBCoJTvhmqB3FlK
         EE2C266gTqOfPA9ZA0fZ1tOE1tVEyZRLfGgiSBN0PUAx+Sn2bUmspX4Ss3WZMaakvQSw
         EzFHXYAoIWREcQ01QLF2X6kkzEISL1QuM84wX+ZgELyjv0PdXgje2PL2e0UTBLNnkWj4
         it/vY0njyKvhG0Ak17hLcoGmy/qWTkygxz2nFQjXiubsX51sB6yray26ajBXfWrqiSWa
         JRJq5oiYor7CqgqTPKgN3EzZPBsKBgGyoZwp2MgkT4gz80wAXq+K8wDwkyxaQvkIzSzX
         BdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711993992; x=1712598792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T8W3ugZY2UxWd610/Dfdbazi+rTB2V6f48BemOSZe18=;
        b=NpT+sgHoLDaB0NOjBHFwslQ+xNosMvJvwhaJ+ym3b8frUJWCa0szC40SA6t07EgOzh
         jbab+VYNsm1p7vPqKCCWC0WMkFXgC6q5Nm7uvrEXoZCInd8qGnMEMjdcsUhjYxZyK9VZ
         jPehfPO1aS8Ka9yy/BbsXLxR8/rHSiFxR+Y0RM1iPZhN41bOjj5iR+zFnDP9IYuPlviz
         moWP4NynVUgtxfelsfoGC+j+/Fjfcz7jBP3Trq6rcT135IRu6wacPazK0zNy7rnAEWrB
         GKXADwgg7v4x6IhRF34lzzDzKP2mnJtRBNDmvtakK9eraQlu/Qzp8SR9i7cu/kK4OyGu
         SsCg==
X-Gm-Message-State: AOJu0YwB3PKCisfabocA19mqwMe+DkPez0Ij9LU9/NhDKxTR8/FF49lw
	huW4ulZiZiWKYIlnEOCaAw7+AjPyxDMX3ObIhgq3AweCNUmmIcGVLB1A2dgbVhuN8WtyoRlApqn
	M
X-Google-Smtp-Source: AGHT+IHS+PG6hIvtQRPJ9iRsByiCDr4J6r5jhTZPO8kgLm1EJHahQtiOqlIXUZ7gcNZIXIzUO6SPTg==
X-Received: by 2002:a6b:f118:0:b0:7d0:c4db:39f2 with SMTP id e24-20020a6bf118000000b007d0c4db39f2mr3860239iog.2.1711993992249;
        Mon, 01 Apr 2024 10:53:12 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gm14-20020a0566382b8e00b004773d7a010dsm2663829jab.76.2024.04.01.10.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:53:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: disable io-wq execution of multishot NOWAIT requests
Date: Mon,  1 Apr 2024 11:49:16 -0600
Message-ID: <20240401175306.1051122-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240401175306.1051122-1-axboe@kernel.dk>
References: <20240401175306.1051122-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do the same check for direct io-wq execution for multishot requests that
commit 2a975d426c82 did for the inline execution, and disable multishot
mode (and revert to single shot) if the file type doesn't support NOWAIT,
and isn't opened in O_NONBLOCK mode. For multishot to work properly, it's
a requirement that nonblocking read attempts can be done.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..8baf8afb79c2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1982,10 +1982,15 @@ void io_wq_submit_work(struct io_wq_work *work)
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
-		err = -ECANCELED;
-		if (io_arm_poll_handler(req, issue_flags) != IO_APOLL_OK)
-			goto fail;
-		return;
+		if (req->file->f_flags & O_NONBLOCK ||
+		    req->file->f_mode & FMODE_NOWAIT) {
+			err = -ECANCELED;
+			if (io_arm_poll_handler(req, issue_flags) != IO_APOLL_OK)
+				goto fail;
+			return;
+		} else {
+			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+		}
 	}
 
 	if (req->flags & REQ_F_FORCE_ASYNC) {
-- 
2.43.0


