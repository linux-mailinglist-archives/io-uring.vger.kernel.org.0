Return-Path: <io-uring+bounces-9138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9EAB2EB1E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 384B8A24A2B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDA72D8798;
	Thu, 21 Aug 2025 02:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f85FGvZv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF602D94AD
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742116; cv=none; b=YCqD09dwdmZJkLS80rez7V4zJ5O9BzaKlxa28Epa9ctu2kYCNUAGHz8WLLLbFwAwA3Ib8mHhj1srQIojbirFGSsbLR5KtMEjojiBVjv+j65qvVPgiIdAVpi4elp5IaD4biX9Fax+4fLwlsFMz9O/V95tIst+urgBpkz+0dB2Q9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742116; c=relaxed/simple;
	bh=ZVl6yVCUyGpTpS9JPkkTqd6LfGp299sCervzVLMY+Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGUkQo4u0sEl1NIL1MpLDoV4sonKAAaxNem5CHI/gn/BL70sZElCRs0Urlu2h11S9YJKiZ30f+EFounji8Oio7FXMU9xaPWkcLxrg/HuOEX+mtlTjYQ+DG8TR898d7vbXAHPkiYX6dvRuYuFul/hrrsNaNmw6DDtQGxIHxpgtIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f85FGvZv; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2e8aff06so408037b3a.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742113; x=1756346913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRV6D7pnxaRrYKCb10lofxYfpn+GiM8WKsH9FCl8DJM=;
        b=f85FGvZvE4mCubYo6bWg0bNElgqmVpgYT7VFz9m7KIbTM8Zt9/uybFV+CosJDhiQi5
         cLmUCk3tx4PfKVWpEwB8bJKj39W0iUvdK4mJWrc4wgvkAeYNUJ2SdZtQ+wUzswjo6m/g
         Gp4JtypenPtrT91Zb7Ys96uogXEFy2aW2K+P2FxLKlqsoDDoz3ErDzKourw/J3jTVV8T
         RVnoXL3Vc3T68oOAeXAVeSuZ7tQPHTr5p7S9cJgRCy3uCUjiWpjbSgddsInWHVFFi+Un
         2wtDtbJCKDsF3+rQl1PgPDrqLZyu6tCXSncjTPKO3gGA+OlsT8LEUWyvYEKR2M8B2Y8b
         wh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742113; x=1756346913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lRV6D7pnxaRrYKCb10lofxYfpn+GiM8WKsH9FCl8DJM=;
        b=mAqX9Qh/+aZXmuwfrU4piTrs6VqEVV+NeuSYVkddKpPnr2Uf8dss3jTbhSf4D/lbM9
         vDUdvr2DPrSbAUOrJWgt3X0/EDcFtSrcPrtbvUrmTZhT0tiUoh2287OQNnxEQHAHt5HH
         q4K9bTDDt6otSgb1IwDxMvRhWjztjpPGME0BSDFA2hBMrfVZ7yozuy620PBLK+nal6bw
         E8UD5sJ1h6IxVysesiw4L3N1we532eI0kwS9GLtvHQWsXMcTdjHq3yIz5e6PlNRDBymr
         7NBfkfx8LU3ryFjBMZ+Vr1BVyTEDXexfGJ3mYmbUN1n6FE7yodJfwC6mTO/e8Cim8ME4
         4ILw==
X-Gm-Message-State: AOJu0YyUaTkScsh1f6OjKv5n0e2sRXBsWC4yIoFcioD1NuudiEa7syzj
	cmpXDwNpk/VUuoWxwxjKqLvX3AbGFjlMWnG6wE7IzW4PPBsl/vzB07ZIF0FMOz03tNmJShfxCDJ
	297BF
X-Gm-Gg: ASbGnct80IjH5SCdGfH5JNq/AmL65FHo25/wlyilrxfQKZJuSKAJB0SSh4BWhv/ZLNP
	K4IFs1ucAY38krOz/DK2uR2cxyiSY6ydXoEuLy8oUgKXI3OhXWcomw+gjiGY2VU5xjJZ2il+1Q9
	AlRdHrDT374mTwSSgr9GQBL3L9Uf45x5ZToCsTewEkh/WsB4y6KnME6bh/wgE/nUGPP271XWcIo
	EFpARfxhNzhHglm6kvhzJzzDpDOkOFO+S5IqlHmK3mHeISjqd2ZMFF5MGAPOxjF/s+uKizSFH6c
	1/dbu8fyFsaujRp9ngXhvUpY8NnddtyXL/LSaCPhYbmOkbNTU+8mVVhfD81qL1uXdtqtXwZ60Cy
	Y29sBsjXB5ZIggxBhgA==
X-Google-Smtp-Source: AGHT+IEQCCLVe++qauEbJXyxXjOW+Np6UV5Fpf+R5K1OG6UH1BORmdKDFpPHOPQuB9o3dsZ9lZCyUA==
X-Received: by 2002:a05:6a20:9183:b0:23d:67f9:5c3d with SMTP id adf61e73a8af0-243309b5bc5mr920405637.19.1755742113090;
        Wed, 20 Aug 2025 19:08:33 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/12] io_uring/net: clarify io_recv_buf_select() return value
Date: Wed, 20 Aug 2025 20:03:32 -0600
Message-ID: <20250821020750.598432-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It returns 0 on success, less than zero on error.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a8a6586bc416..381454ed41c0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1197,7 +1197,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			kmsg->msg.msg_inq = -1;
 			goto out_free;
 		}
-- 
2.50.1


