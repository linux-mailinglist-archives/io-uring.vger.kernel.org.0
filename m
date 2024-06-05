Return-Path: <io-uring+bounces-2117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0A68FD0B5
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01E641C23408
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680F71CD25;
	Wed,  5 Jun 2024 14:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="i0xNEMEx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A71C686
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597193; cv=none; b=u4QQOTWxMsN/2WUcgJHLW4ZV6AAaC2Eu7YFB+AOxlJKYoPt7zLlke29N8aNUlvSnxxwyKB+AxKy1m1r66tb2uJuf+hoVjk2ktETuYIz8eZluOfigBrkfrdJyqEvTq0jcT/Zdd3kwRJZm6O+3nacirzBQGxNWiO16ewkp7m4KUTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597193; c=relaxed/simple;
	bh=uwQF30IimSlEKlp8+Eiz1XztFwx4xSw6qoS56QzvNNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UE7mru5DbNlcU3BJo9OLWJw3vGEtUmknmjKNXmJ7El7E7WV5MD4zlgkstdhF84dCPPYEFczWuRRaiCGmLJ33MkY1W/mG21ky4Oxnl2DrlKpmE56aZL7c1Rjzg6p2VxuT5FHknIJCz3h7wm28CvaYGBS4scY+AzO2GNofLxusfwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=i0xNEMEx; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2511c3a4061so32107fac.3
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597190; x=1718201990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WgrIC9T62eJ/Kd42KI92TTHwOB/mMkk2A1Xe2LS7R8E=;
        b=i0xNEMExyu1ChRYOJCFdM0IYOefJ7Dr8QwNE+ENRu9AFMo4+Jy3RJ9Wnm/3KvQAAez
         e3gMuHX/ooTTtgelgS5HchAvr9vAhQYwQWM9J7e2EkdLt2hBhSyd9fNtphkChSZEBihh
         21yiN5gUfuv7F69cbNm/HkYOB2uHoPMXcLMyKNim2Y82df2b/m3J/vgQY4rerelA+Ezu
         LVLVw5rLuhzXp0lM/I0zBSGUqd5ddjjbzB67ddFt4Bb30m7fkljdo5bsTu+rLgHNxeKF
         AdpzOmQkbj9KnXIAL6cQkR/PIb1qye2rhJJSWqt/Y7z4SpKIx/AFHQ6WWoDKoXe5gDWd
         LlMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597190; x=1718201990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WgrIC9T62eJ/Kd42KI92TTHwOB/mMkk2A1Xe2LS7R8E=;
        b=KDdO7/SOp2cbwBLYdEM4rPZeBT1LuBgTxzmca7qmQPsGKYnZTLhzBX1N2RSaBOL1A0
         Xo9VKgBYmsdZIm4rL6P5+2Fo7ZLjV23hPwav1rfuyXcaj0A5HywBQt/RZW45seiYZa1H
         PheMRxHeQA6YGPhSYWERYDRsO2DAKvzeqA6AAiQptud0LktPEAD77tDRBOKE21GXmy9c
         k+b0cvmj7qYofuyWBjvyi3T7hKiYVIkx05UC5u7i/2TtVBwmvXlWnwi5iu0KA9u/bdal
         cjvqu4gQbYa/ooxbt3BNeGi//Tp3jJ52hrmybKh7j3ZHfFWA2YiGOjGRRQv1PQWHQZDI
         YgaA==
X-Gm-Message-State: AOJu0YyrYbF2TPF6dRw5N1ZrdrN/2DTqkz5skFCBkQ2mrtb2VrM4p8zB
	UBXhv/u9Ag4S1yop6psbATcrRVeeRf2TtSot5C551gC+KgLYFUXMLQ/ERGH5eMQQpjwd+wAYo1L
	N
X-Google-Smtp-Source: AGHT+IF/Y2vPLHKUd7t9OppUqhtnbutzFk+SFKeLZrG2Gw79sS0vj3+r/+BntSDB56v5T/SUzSeipQ==
X-Received: by 2002:a05:6870:a981:b0:24f:c055:fc52 with SMTP id 586e51a60fabf-25121856b56mr2879477fac.0.1717597190212;
        Wed, 05 Jun 2024 07:19:50 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring/msg_ring: remove callback_head from struct io_msg
Date: Wed,  5 Jun 2024 07:51:15 -0600
Message-ID: <20240605141933.11975-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is now unused, get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index a33228f8c364..9a7c63f38c46 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -22,7 +22,6 @@
 struct io_msg {
 	struct file			*file;
 	struct file			*src_file;
-	struct callback_head		tw;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
-- 
2.43.0


