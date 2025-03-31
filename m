Return-Path: <io-uring+bounces-7318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB5FA76BC1
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A1543A3852
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11E51DD877;
	Mon, 31 Mar 2025 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PuR7lcZi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6108214809
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 16:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437812; cv=none; b=KPX7wXFdy0tXfjl1LL/lGvSSVm1mv9vjxn20HBpEbCvB49/X07XwHPHoGxoewY/UKB+vYTu8ownjC0Zeb/tXEBOzQcvWHkFLX/82BcSzFA6KEWMErsCI7dO29et7n2Ru4peD4ns5eW9gHhs1j1KZ1rG1KOhp1p24+g9ahHi+2uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437812; c=relaxed/simple;
	bh=O9OcVpRkwtaQb5i2fQKOi+Ap+7qSN7RgiQmkYm8aVas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVYcxAWFt5etBD23cF7af0cyPkl8CMVWHTNwepVEK59GyqJTKJ3imJUrYI3sg2IoY7FMmU08xsBaJrp0qxN19pmKkTg/CoC9vGQzIVlej1WhdQtZRw09m3EuO0HssGHA8osPglsbkF2k8G+2GZIvMeig3P/S0DmT+meQTH0jpXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PuR7lcZi; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e5e0caa151so8776467a12.0
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743437809; x=1744042609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xnik5nEQo/hSKmSxOe0oLEBGTZnLEE+g6/iiD2tX6mk=;
        b=PuR7lcZi+StyfzrMxDI8ic3dAtEFSME1GQShk6opbdnRQkqe6kYxBQNdaKBFCliSM9
         69cJqTzWdBbTxg/yVxbdlKUwptxms+eUSDKEC/frVx8dQFYFX5Zd6RriD13+KNQEg2fB
         nXs8dfCoJ6UHd24rAuOScM+DNWUOKide+ad4i16Jn2xNKIBFWc0NnX9DxCviw8s/OYSs
         90pG8LTaUQqVjE19tWH8MUvDVEVv6vD8gK+b0zL2A1eH4w5lbEIypTaJqVX1lud2gi99
         l2p0z8WTjlZdP3jedAmlfdXGogzAoPb61Re7pwAMjOsoTzNrBqZu6DSqQwElRZm2nr5a
         z8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437809; x=1744042609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xnik5nEQo/hSKmSxOe0oLEBGTZnLEE+g6/iiD2tX6mk=;
        b=bkiSzBZMWkdNhY1FyUDHtX2UpI41FaTR/UrCE4sywld+v/CIvTUrMRwNTBe3j9H6KN
         9BvLgG95TPjGprWUXIv6FiEwhMlJmfcuVixqkQVh3YP4yciAzpW+WeORe/foEQvQHwl5
         DB/eoh/jJaQxeSftDLy46kzPb27g6XBsu+kU5eD1CwuHBByI4RJnU4Y2xslZo0cZTsnB
         5iRydvJldkVQSoxZol0HmZnDTCNBl89VhBQ/fx0s5MOBUw2IIxiOSY+3mbdOSQD716u/
         a++NmrUFuH93HFdNdiOFeRyQSzvHI6VdZkZk+LEQqQwv9KopQlr6EyLYtArI57moTQZn
         Rl/A==
X-Gm-Message-State: AOJu0Yz2Lx81WNwIuDZipR+RzIAyZ1pEzkqfpdDM3pr18+O8WpwfysXY
	OCoD5Y1osp2U9KrcMXKDxCt4EzNuPNtQi3MVAXvMUJeuV6kiW/JGRfxhlg==
X-Gm-Gg: ASbGncv05Tzl35DfXWNzm7Go9uhahE0GLbjEYqDCcELIGdjb2HVZNktAPKCGi6I68gO
	r0HJi38NpJKOc0R3KApncvf0jKgNmHUM5vA8/Do7PGQxDQztW9AaGlHPm96RkBvWcpFMHMtTY9t
	qzSV4TUmYwGcQY7QfLD6v2+xr/dmfAMGnFy0POaqESR8sMAID/j5KmPhV0Gg4KvH2lWbF9YMY78
	+SxQPiiCSoMC9G7r+jQ/8vp2BDCvGa0QogjUIHndcGKED6jYHPVWHkNMtjjiKlnYSr5rqWHvV84
	MtZkms+BcyuaGr+dWSJXiseedY19
X-Google-Smtp-Source: AGHT+IE4BCtN7JvSK1XqZoGuhHhmUS4wSeuUmc4rUIvmRllEElpXkDuQX41j1PxVZLaulu4BBzo5zQ==
X-Received: by 2002:a05:6402:34d4:b0:5e6:1352:c53d with SMTP id 4fb4d7f45d1cf-5edfdd15461mr10184645a12.28.1743437808613;
        Mon, 31 Mar 2025 09:16:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f457])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d2dd0sm5861458a12.21.2025.03.31.09.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:16:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/5] io_uring: set IMPORT_BUFFER in generic send setup
Date: Mon, 31 Mar 2025 17:18:00 +0100
Message-ID: <18b74edfc61d8a1b6c9fed3b78a9276fe80f8ced.1743437358.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743437358.git.asml.silence@gmail.com>
References: <cover.1743437358.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move REQ_F_IMPORT_BUFFER to the common send setup. Currently, the only
user is send zc, but we'll want for normal sends to support that in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f0809102cdf4..bddf41cdd2b3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -359,8 +359,10 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kmsg->msg.msg_name = &kmsg->addr;
 		kmsg->msg.msg_namelen = addr_len;
 	}
-	if (sr->flags & IORING_RECVSEND_FIXED_BUF)
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		req->flags |= REQ_F_IMPORT_BUFFER;
 		return 0;
+	}
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		return 0;
 	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
@@ -1314,8 +1316,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 
 	if (req->opcode == IORING_OP_SEND_ZC) {
-		if (zc->flags & IORING_RECVSEND_FIXED_BUF)
-			req->flags |= REQ_F_IMPORT_BUFFER;
 		ret = io_send_setup(req, sqe);
 	} else {
 		if (unlikely(sqe->addr2 || sqe->file_index))
-- 
2.48.1


