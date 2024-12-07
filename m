Return-Path: <io-uring+bounces-5289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 572D49E7D92
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 01:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DC80284F3F
	for <lists+io-uring@lfdr.de>; Sat,  7 Dec 2024 00:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A27022C6C5;
	Sat,  7 Dec 2024 00:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ubjyqSf+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C07628F5
	for <io-uring@vger.kernel.org>; Sat,  7 Dec 2024 00:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733532115; cv=none; b=Z+VOZY3OSF7tQTCqxQ+zfJV3MS7dg+XJjoShQC69bz3JXyUcksUOeb2I2DQXnKk6lR0+2c5wr7ss7e5aOWaciOZn6y3GQwVNZFiJgMYTeRqXauHrtn9JmhiJzaqZCv8n5tfuwfudpDumNfbmsnP1teCiSnOr3OjoXiYCVCdMJYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733532115; c=relaxed/simple;
	bh=zP7ebWxe9g3DAiSxA5kkmZzp1hNsAkpYzbVcBZfZ0mI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g4VEjOW0ag6Y4iH6oycQJ8u47Pco+Ilg8vf3qLN3BSmMR1qgGhXGMWh8oYlLUoV87z6DEo8L14CxVUEldNQrWclrl1mhD+dtvCNagI4Lf+R+pafsiwRhGUeOqS6iHLRiNR1cxtzFYGMGrMRbvApsi83X0dFbXD3Rk2uFkQ+0Azw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ubjyqSf+; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-724e1742d0dso2453079b3a.0
        for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 16:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733532111; x=1734136911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j7mYa6jWU0GfQ3BnbC7hZLbjFgqXpblx7lc2NnYmzno=;
        b=ubjyqSf+ztAX69zwWFZfX8ITgY1dQWVo5DCnoBCFRYrNGZ75N7WkY6MJ1w+8njayZ1
         Z5VazBMD06JL1s2aimOuq43knFt9nVUNe9E3zm2AU/PVsC9ctQKGcaG2jRFeDspSdZIN
         OHcnMw9zb6L6tkiKwwsJDu/wDW3g/0gV9Aiqn1VhBdMX/0whsxyl+cbeADnl/2M7BTOT
         GSK+YIKAvvWfms+Q70PouiqIfVaury5uzbUBXDSP6QtjKfeh9VCap3+W2clZ9znTjaZQ
         nPGo/tb/VhQIED+b0NBG4lR8L5MT6dZq7afN1Kcu6DJ0nFigY2lEqCXAQGE16BtpFg3n
         HWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733532111; x=1734136911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7mYa6jWU0GfQ3BnbC7hZLbjFgqXpblx7lc2NnYmzno=;
        b=h8QFZIISnxle+JNDQumQGTS2ZgMzIag7EsPBGTgDEB+dqcYjJliZf76MYiYHn5W9GY
         i7D3Wb3+m3AZjeDpkaS3N49tffB9g0bSGRektP+5fmzWyVQf9L2qLjhYfgyLWCGKGvsl
         q94hcKL6AS81bEB3yekV56qg4RdklA91AjbcEsO2ObSAdgV2OQzEK8LfVLqA15th08wN
         WiQIIh3eAT2npG+0IY12VnRbBfieeJaNAIoH/oM9J3pL8QcJMT/7O1iyo2J4ViEcQBU6
         Ku7rGk4cgTKdY+kLqGHoEwDvGmBTxXOByLoT32R68hDYMxtSxIP+n7SIvrcf3VHQhXBQ
         tbkA==
X-Gm-Message-State: AOJu0YzMCqmxhVTs2lswEUcM4Z3RjZMyfT2e2ojDtyoR9qDniOVuSpBt
	Net06qNcwcGCFVOllBHYMJG+5VFDMmDyTat9FvKDIf7zSusmg2EydcCqrO0S9vYiMDRabvzS8m0
	m
X-Gm-Gg: ASbGnctDXliickUnv/FIVq0U61Ptd09aummyfL4Sxaee+Js30Av/r8z5AZjTvZ+O4MU
	pONGVyxpoHeKBUiwXcln4PiMPQ9nYBlzKZe4SrKsVObhLyL2kxMqVeozurts58nNDELn+iMpNcu
	t5ZUYTpKYheKVlB1Q83EUXuONLs7mzNT5z9fUa7NlBKbY6XNRLBqT5/vt5wovTNoAbwQYZUvXms
	2TaNFKtLkh4DiWmHCba4+udsANXdND8Rx8=
X-Google-Smtp-Source: AGHT+IF5kHLfiOPOn/SPhP9MsvkUlvrDDYhmZVwsYly887ajoNWj6CUVMkkqgJ0wa6mHH7j2chwsMA==
X-Received: by 2002:a05:6a00:17a9:b0:71d:fe64:e3fa with SMTP id d2e1a72fcca58-725b81f2514mr8838703b3a.19.1733532111462;
        Fri, 06 Dec 2024 16:41:51 -0800 (PST)
Received: from localhost ([2a03:2880:ff:14::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725a29eb432sm3523602b3a.72.2024.12.06.16.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 16:41:51 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next] io_uring: clean up io_prep_rw_setup()
Date: Fri,  6 Dec 2024 16:41:44 -0800
Message-ID: <20241207004144.783631-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unnecessary call to iov_iter_save_state() in io_prep_rw_setup()
as io_import_iovec() already does this. Then the result from
io_import_iovec() can be returned directly.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/rw.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 04e4467ab0ee..5b24fd8b69f6 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -240,7 +240,6 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 {
 	struct io_async_rw *rw;
-	int ret;
 
 	if (io_rw_alloc_async(req))
 		return -ENOMEM;
@@ -249,12 +248,7 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 		return 0;
 
 	rw = req->async_data;
-	ret = io_import_iovec(ddir, req, rw, 0);
-	if (unlikely(ret < 0))
-		return ret;
-
-	iov_iter_save_state(&rw->iter, &rw->iter_state);
-	return 0;
+	return io_import_iovec(ddir, req, rw, 0);
 }
 
 static inline void io_meta_save_state(struct io_async_rw *io)
-- 
2.43.5


