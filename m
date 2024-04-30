Return-Path: <io-uring+bounces-1691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CBCB8B7BFE
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 17:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D01481F23262
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 15:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F20173323;
	Tue, 30 Apr 2024 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYXXZOoY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F154173322
	for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491743; cv=none; b=sWucxSYqJns4e5Dqt1XoInthEPTJNBM1fvAlL2bHJGS9+ccMkRYeTALALtVGcQNnvizQ0lAZCz1+z6t3JZiCczjtclGWmOiLZy0JImGb4sPqFsBnWZ4qELH5EjKkBi5yAJm4M8ZEomq6p4RNp/sdVwk8MZCOpK/m3A2tbqfCbLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491743; c=relaxed/simple;
	bh=Uf+YzQnxRQiBzc6SWP15OqG3Xu/BoGG2ZK2FkO2kLrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsZY8+mPCKsGdOu4wwEm77jeD5S2by3dHEYCvQJK4PvrveBWgnT9ZVUiuL+GCfc95lyJflbDzyhloAyZN7XnIgZVseja1hSSsHx/DqbWcgIsdx2Q6hJTP1ZBYSg1bs+ZzhBRfYoFV3ySPhoq4LyeocCZ96E3LdSP7p8yqiJ0Fp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYXXZOoY; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56c5d05128dso5311784a12.0
        for <io-uring@vger.kernel.org>; Tue, 30 Apr 2024 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714491739; x=1715096539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9xDfjdYIHN2uBhWU3bX363wFy33L9fUZ53OUgymdnU=;
        b=EYXXZOoYVpyBLUAe18PnZCWKwx4Iy63sMAFjNuaDdDWLZmOkk9PIjbz2nE+gaRl2E/
         vMlbfbsIE4TW4dPag+iOKBpyYq2s07lzGZH3V/BrR7OU7CdL0SLgd/CSEOVxBeBQ+2b+
         x+tHWlcD1zEiXg08f98BpgqGMGIRGJrXqmIu2Fl1j1QRJx8B/wzbTNecxCFrXRcUDPIF
         +RdpufqwsfOPTRVeNj9m9oe/lQEwHl27qd93XHLItODs7Ty8jMzJpavpBB9EIKJW7oAE
         Ilc4Jm0P/JOOGDa2qIjIZ1GX82v7XRKvX9kyM0vT7QNebTubLctoFMzXaXKvM2q13sPm
         bXKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714491739; x=1715096539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9xDfjdYIHN2uBhWU3bX363wFy33L9fUZ53OUgymdnU=;
        b=AI/SfCaTRYXN88nuTDjdv78VhpuQtOIaxB1OGx2xphqt4/8LGDUYg1fkDNZe89OPSJ
         X8JXuqRkp0jg6quZLprfQq0mzp3IFkjALUbhhxKauCgok4P/XoMuxKq/RlPhG9R4T31o
         zfkwKZTrMr1jWv6R5O4/NUKvYnxpLXThgaFzOIqCg4sgtYbIvN1hsUbGpOSUw0reuL5j
         feOIhEDNzyBjSwXratkoyJvVuZSkuicUT6ERBjyCEuxRzJkwlRSRYp0RmxKbvpTwpeYE
         9nKEBsb/fzzrpPLIt/LxcL6msU96qekFf4FcAMQii3t5K0Yc1TFwzwa0h01G+gEO27D4
         WCKQ==
X-Gm-Message-State: AOJu0YwYxKCRDq/XwcN+Iuag+82jpcEU1H4B1fGQDd8DXx+xB3AF+GNx
	BuxlDGagQO8OlGkPTBoIvA5vlhYIymM4m5c7h7zIH9WRp408vponxEPhe0DF
X-Google-Smtp-Source: AGHT+IEQ1cR3acCcI/aqwuE+fM5LF1BRkbAtLXS+zX1zx0p6CaafpQbQSv21m6NSIVTRW7ODRnGZ2g==
X-Received: by 2002:a17:906:f214:b0:a55:63d3:7499 with SMTP id gt20-20020a170906f21400b00a5563d37499mr55825ejb.59.1714491738946;
        Tue, 30 Apr 2024 08:42:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090653c800b00a51a259fa60sm15201465ejo.118.2024.04.30.08.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 08:42:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring/net: fix sendzc lazy wake polling
Date: Tue, 30 Apr 2024 16:42:30 +0100
Message-ID: <5b360fb352d91e3aec751d75c87dfb4753a084ee.1714488419.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1714488419.git.asml.silence@gmail.com>
References: <cover.1714488419.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SEND[MSG]_ZC produces multiple CQEs via notifications, LAZY_WAKE doesn't
handle it and so disable LAZY_WAKE for sendzc polling. It should be
fine, sends are not likely to be polled in the first place.

Fixes: 6ce4a93dbb5b ("io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 51c41d771c50..503debecad32 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1198,6 +1198,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
+	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
-- 
2.44.0


