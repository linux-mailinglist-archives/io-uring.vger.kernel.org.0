Return-Path: <io-uring+bounces-6781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 454E4A45D5F
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2022B3AA92C
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 11:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FE121578F;
	Wed, 26 Feb 2025 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mnngzc8r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42538215779
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740570040; cv=none; b=HjKXwPyZ1qaHTtKfrUqtTp2beeVcLHNzMwZTCHPuWBxxajPuOrs8y5TjO4TZPWnDDYfmjO3TWeawaZ7hEUkapZjJVXRXXN4kAdZy53+t/dYjxpkxHb4+1DE7ZkF7C70FlWXfyg9IsZk9lMkLplmrMofkIT/By24dTN/GCh/plY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740570040; c=relaxed/simple;
	bh=gI4Cwarylx1yMPDotLehl7ONUnkOPP1wwRmj3p7vbm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVjMHQYD3Vj/j5SpixyCweg03tpmXQNB6GPm7TTDoA1n2vesMh9akThwk7Tb3JAGkPZgYj4Vd2wpIbsQ3uHzR9ybZjfzWVfVVFbbYY02/UhJFZswZnFJP13qihQOAGguo1dOa1PvtFewfwNKP+JHwTnK94uyKm/j75+m2e2mOhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mnngzc8r; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abb7520028bso902489566b.3
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 03:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740570037; x=1741174837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTrmXxEi4oVTAINbO/NnDUch5MwURBjaWqrxGV0Cbeo=;
        b=Mnngzc8rRAeMNG7zhaZiDOSdQkIjdK654rQWzG0eY1596TP2yHOaMD//1tnxBQQdYn
         GgU9xug9WN00JkKU7ZNsJ9wsfiBHtiaJzRS1BD4n/BLOyc0oJM9+7dDozWSZB+8NWv0y
         5sBt6E4Evx9OX/eMa5/cqV2WR90+vdGVNMbMLbMzw8TZYaz2ZFaH7SDok5Lw7vq/wCJC
         AT3iCbStTvg5r2ugs+sCCai5dCv13ToxbBOFq7fgFoVofEmR2btBc0aImnI+aREZnLDE
         EwR7k+6xtla76rkkaanrHh0dCXt2evTPGg4WMXTbEVGSfxWXrVFhO6OEhHxkeyGQQiw6
         5tqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740570037; x=1741174837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TTrmXxEi4oVTAINbO/NnDUch5MwURBjaWqrxGV0Cbeo=;
        b=wTQE0IjUKbvccmQTRtvqI4ckpN0EnxKQWIdEJXNOYQ32eEHAD0CYx4GKRqqMhcZ2Jh
         jEHDb8VVd9LcjYLZgm4NGti+Y+g7T3qKcEJT8ZlZEqZkLwEjtj+qs9jROKHNKlO9Qk29
         P1zJTh/ZO7p1WTepMz5ZfypuZK0wOxIPNCmCvjE697Y2LcwWbVb8/HZt33dTPlx2V0Ta
         6Dz6v8rfKTfzwUlXEyeLYauA/RDo/gCVAjOvA9iJ2pzPR8uwlEuBYGy2UHfumouFzxjx
         0D6GQRG2L7xjoi3alaV37sOWiX8cc2CUqP0SWagmAAwhd+H0Jv+1Bq+b49zWusMs9VMv
         tC0A==
X-Gm-Message-State: AOJu0Yws6K1qzNE+NK6eR9FNlYVdU8YOe8KflUs97nk3nmYItGIZ8Lc/
	+Bw8xKYc40R3IspId/QpUd4fzP5nVmIGoTHAAf3Bms9g8X4duk+a3BdWqA==
X-Gm-Gg: ASbGnctQHOM8/O/feIms1tNcXwUhBdnvKTtIvzhhK3cp/yrNHmqdQJBOINW7vV3SI/R
	nTiygsGla2WoDxntMyLX/lX6J0CglMC4Jfhf+F8dj8HxUJkUAH3q03Vi8xyRKdjR1MuyxNng81O
	WNwXROB/yRWBw2jIEsIv0fXMpg7zb4V5hSTAMBIzo8uKg3y96CFVGDjU+AL7dBrP16YaO+kqI1f
	OlYv12VCpNhcowpR8ro0gecXqaCH0dvywNBWXDu8wvKMAGuGAVdlJisRloijKkWp2BbwVV41v6B
	x0RUUjSjMA==
X-Google-Smtp-Source: AGHT+IFmR+5lx0KGwG8rdTtZ0PW70ry+iJUXIaLZRq9btbUnT0lDOlmxaWXct+KpbRGSHXOCjQOVmw==
X-Received: by 2002:a17:906:308c:b0:abe:ce46:6231 with SMTP id a640c23a62f3a-abeeed5b40cmr326641366b.16.1740570035339;
        Wed, 26 Feb 2025 03:40:35 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e45b80b935sm2692418a12.41.2025.02.26.03.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 03:40:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring/net: simplify compat selbuf iov parsing
Date: Wed, 26 Feb 2025 11:41:16 +0000
Message-ID: <e51f9c323a3cd4ad7c8da656559bdf6237f052fb.1740569495.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740569495.git.asml.silence@gmail.com>
References: <cover.1740569495.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use copy_from_user() instead of open coded access_ok() + get_user(),
that's simpler and we don't care about compat that much.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index c78edfd5085e..0013a7169d10 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -215,21 +215,19 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 
 	uiov = compat_ptr(msg->msg_iov);
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		compat_ssize_t clen;
-
 		if (msg->msg_iovlen == 0) {
 			sr->len = iov->iov_len = 0;
 			iov->iov_base = NULL;
 		} else if (msg->msg_iovlen > 1) {
 			return -EINVAL;
 		} else {
-			if (!access_ok(uiov, sizeof(*uiov)))
-				return -EFAULT;
-			if (__get_user(clen, &uiov->iov_len))
+			struct compat_iovec tmp_iov;
+
+			if (copy_from_user(&tmp_iov, uiov, sizeof(tmp_iov)))
 				return -EFAULT;
-			if (clen < 0)
+			if (tmp_iov.iov_len < 0)
 				return -EINVAL;
-			sr->len = clen;
+			sr->len = tmp_iov.iov_len;
 		}
 
 		return 0;
-- 
2.48.1


