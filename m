Return-Path: <io-uring+bounces-5670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C97A01650
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 19:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DA743A3597
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2025 18:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9C51D14EC;
	Sat,  4 Jan 2025 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QotNwiAs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5123B1D0E36
	for <io-uring@vger.kernel.org>; Sat,  4 Jan 2025 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736015290; cv=none; b=Ds6EhOV4Ed04jhY/Qi7hCaZZqVIBLL1sI8CDxHtmTR2dsPpRC+FKaJ0gbH1cRafUtA0zpWtEVa/ZwvDD6xycTJQramtNrskw6m3ZD0wcKsgwa6VFlpwWVuoTPabxMVWUz8nLpmVChz17UhXwlr5vdjTHBy2LNsufFeS69mzJIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736015290; c=relaxed/simple;
	bh=oCfQ4vx9VsCP17tH6R3cMapsPcgEpO4bIBdxaor+Bxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n+a/vdWTc2QfYQcqEQDWdFYvISyxWBr8Wfp2xPluG1pHTHUJ9FOMa7iu24uxyOfytgYGUUPSJqIpP1sfJxZt9KAip9W9OyMFmuQfpESCbvjmfW6Cee1L6QWx+pBZhzD7HedcEfo6BsIcpg10pRfWBaTb9/whvT3OpmU9gAxR1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QotNwiAs; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so24994656a12.1
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2025 10:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736015287; x=1736620087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lW9cL34XZkJZgmk4tfNM5mryt2h1iqxkJ9lOLIaUzAo=;
        b=QotNwiAsOaVrRVlJ2FZdQrcAi5lRsnr+cTQoL3CnceI/sJPQXrFVikNWGNXpz2xco4
         C/RXx7ZYmfkDmUYR7owo6HxiK301f1Xw0R6qW2hSddy+V5BrZCi1jY5T2DOCqKAtkPX3
         kmAXmcMB1jZ9qk5llS927yW9vC0U6QMcbiy7iALSQZ320loWONbKS6iMzN34dUQnrk4p
         +QOZ8ZT1TGsL2FBuFnZVP0TvbchqjQg7p7oDOd7gUTCQqDEHs8GDf4WZrx+q57H502S4
         PQ69XGBX7rPLBgVuK2dp050QzgD6zCi3i27/RbZR2toeghQXMIthzKkxP8ljHAedenfc
         o9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736015287; x=1736620087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lW9cL34XZkJZgmk4tfNM5mryt2h1iqxkJ9lOLIaUzAo=;
        b=fWaHP5mEEHuIxHb+ZqVSalFAWJ7BLbvK2HZGnU387PDbNb38In50yA9RjjF+6bpx3b
         zz9o9ZBRKjR3AUMYmA76/2BxFw43bf7+/JkrGP625d0A5iTQsN8tgUZ5+pnSVk/vBPOR
         TR0yIeGMd62gmxz+v1xOpa/Geebmcrfsae3dba8JLRcf+VBybN+VcOT5w9woTP2wkN3n
         X07cv7DnMAjyrk4zzECg+AC4T18P2lC6J15kz4VkvV0KeSWlZHWX1Y28RULLUTw8Xo/H
         5gglXhVVRySUOfTdV6git3qeneb3o3h5jxg0VhCSWOgKP/Evv1Ec01CWGM1KAEeqP25h
         ykJA==
X-Gm-Message-State: AOJu0YypjBIISVwIgUvp/ihpUkq02Uuiw3eQEzIMgctkUs3CHRyOMxiy
	ww/8HtYYJOqPOkg4gLwqVYAI+v7oXPUWUrh+bGiBhtWoIfhYAlPQj1Kc+w==
X-Gm-Gg: ASbGncvFK6jo6uJZQMCzYIIPk/Qb+zBVfxIuqwNyYw+1BOArlqmzDUH0tL52T9Xzhlc
	ezOza6S+QNThIb89eQ5B4KjRf5Wy80l5OPlUTI2HDAvBFZPFXbP9dtoOuWRPEhO6tN2v3e+etxo
	Wi0eo+Bwm/IvkrBlJMY72/YAbe0eu7FIFjD8wZC34PjIAFjny9aGhsCFbKlq3/KB8iv4OY1fHd+
	EATBcR19w81F6dodZ5nW2QgAjeXTLtX7QTQyDlSHrvZRviefyzWMNZKe0zwAYzmQNk+VQ==
X-Google-Smtp-Source: AGHT+IG8mEdWe/Rgh1SIZfmuxmYlzzfQTRzbTR4OGoZQo/lkYrYs9EsR3SCBCSMvRWg/1//3DFXdvg==
X-Received: by 2002:a17:907:7207:b0:aa6:112f:50ba with SMTP id a640c23a62f3a-aac0815366cmr5280097166b.13.1736015287221;
        Sat, 04 Jan 2025 10:28:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.144.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80701c9d7sm20843287a12.87.2025.01.04.10.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 10:28:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Christian Mazakas <christian.mazakas@gmail.com>
Subject: [PATCH 1/1] io_uring/timeout: fix multishot updates
Date: Sat,  4 Jan 2025 18:29:02 +0000
Message-ID: <e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After update only the first shot of a multishot timeout request adheres
to the new timeout value while all subsequent retries continue to use
the old value. Don't forget to update the timeout stored in struct
io_timeout_data.

Cc: stable@vger.kernel.org
Fixes: ea97f6c8558e8 ("io_uring: add support for multishot timeouts")
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index f55e25338b23..dd719e3ca870 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -410,10 +410,12 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 
 	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	data->ts = *ts;
+
 	list_add_tail(&timeout->list, &ctx->timeout_list);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), mode);
 	data->timer.function = io_timeout_fn;
-	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
+	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
 	return 0;
 }
 
-- 
2.47.1


