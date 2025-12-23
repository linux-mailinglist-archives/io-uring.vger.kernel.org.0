Return-Path: <io-uring+bounces-11273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82558CD7842
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B0B2303B006
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3AA1FE47B;
	Tue, 23 Dec 2025 00:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RblAxF72"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798CB214A64
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450222; cv=none; b=g8xFA+l07nsDrvIGq7movcBHdjo+hPL+UjC8GkKBkQsgrmEs71HD34Uiyy4w9qXmGRyUWX9tBYXxcf/74YMVF0FXFQkFzAcDpe2LtmtqYKeZPt2IoJmOoaa3wXJABwh6CNNnSQM94/ORmmGxU6kLSbN1cT4yF+5DPosic+jAfLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450222; c=relaxed/simple;
	bh=UvxGykMLagJodFF82NAYTU28hUSWK6gDUTcLTRmQJ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9gveg23PihCYMI6cO0TpNN3Xi9h/aTvCfXapCRguLozcyNm/HuvYtu6U4rWh6OqczjyZMrUz+gVR9rzRHsaaD3F7ztgY0EhmRVlfGTPrY9Jm06qFFssaWdUPQzk2J+LAZvHflwVWPzFT7RyM40jOJnbOiYobQxZx6PEQsV/nJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RblAxF72; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0eaf55d58so32618255ad.1
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450219; x=1767055019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMsOqo9v937yP4fh4eba7UqfVJcPSIWogxrx4HYNtHk=;
        b=RblAxF72s/5y9FTxhHh5AtQDsZo4kRRQzWpDV/9Q+INC5GmKwhIDXF2yWgYqexbmBg
         VfDFMc/teI+O8dObTSfismhGcJ1k4tmlKuS9suBFWVkfi78mcQ4gPNEAisCgU7+v0vya
         efA3VscDiNqodCNViuXxlgx+jujWuqypq83cBEoSCD5B/EBQYR4PoeV3U/Hc4Wf0493S
         M45UaNlsIj+1uHFXa3w/Ow04zhULuS3iN1oA+ngoTT2YxGw1atewXiXu9Y5ziYffLwl1
         tQmTlCoLZaDG6EdfpEem7GwvisXB0E1GEQPLnxVsrKmMIldXK5xEa3bcUozwmzWjGo9S
         K+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450219; x=1767055019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jMsOqo9v937yP4fh4eba7UqfVJcPSIWogxrx4HYNtHk=;
        b=Rus7v4a5DNV4UUkx6vawI6Shba+h9h2Xtzh0Bvy6MlfbXhgklQ8d1USXM34kHzEaA6
         LqIscv0TzLdh/uV/tVodvOyUbGR7mvXSQiHu2DVxXlfUplX5IFh72f2x7SNqOiEzluu+
         zC+ajhml7XMdL4JSyt8XWKWvseJF1cvX687xQ1Wndf98LxlxzzaR8vGVjuaqqtk7LPzh
         pa+Ywu7TwQTiPCPkQIAMVC7U6ZEka3LHJElw00P/UMIYIFU3UJGsRDQCBIVDfiw8+sXr
         pH4fmOmgaoAYbKzPjIee+1FdoISvj0OyXK1lmNGToWTUa0fF2uLYw6H1FFQ5u6BPjvge
         teNA==
X-Forwarded-Encrypted: i=1; AJvYcCXdwXptSy8VSdmA2Al4q7u4mqKVe2BI3TjxIbgkuj3G5PyrjnE+mDj9mZ6NdmvnWeSRyv0BdcPfsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YywZS6Cd+5sgbRSXUZz8XDsl4mNh98uD0wHBPc3kLBfDxyWRI02
	Q2PPghZAhJpDYDlbUnjbKTEvzjCpZhjDjfHmUD8Gd8XAvoy0I4OoE+2r
X-Gm-Gg: AY/fxX55vB2VPoOEWmQQT8oRs+p/RsTfnIjCqG82wA0OBIYbCrn38Bc2uLSyAHlWspw
	xyDYJdGpPUX2Z7q3LYpq0EPkGofEeeO6hCi57PPYJT9F0IAoV+pRTfe3o5gsMw6rGAOoW0BpTqa
	9E12HPvmYv51iXhAKzP/sPkO96DeReAeVLwWbTJKx9i5ROuXG5C5OJMY2LzkAXqmAGtza8F1FXx
	3cBd1ikKoHQa1e9hx/6/T9J6hJwne0XZlxVytfkbZDJJ+ms+4Juy49fQtAZQVGdGae7SnWwgjR0
	+uWGBpftbOZSx6Vde1Z4we2/Kfd6K2B2NjMbkn2AZKLMV8EvR9H0XhnySRraQFrQ3BQu2r+JhhU
	0+N/oqyRorY+YBlvc97guB3eGfjUK3dnZU8nrridMR1OGxTtUFyseNNBT8xVXPTVdGm2eZdVG/s
	XM+wcO0qfDagk49Kjxwg==
X-Google-Smtp-Source: AGHT+IGS9kDV+zjcE7owjWevYZAaixuXB9xb7aXsVaiLybjoH20QmzQIGgkD14xrPgseN2OB0doXdw==
X-Received: by 2002:a17:902:e845:b0:2a0:7f8b:c0cb with SMTP id d9443c01a7336-2a2f0caa42amr147167365ad.4.1766450219528;
        Mon, 22 Dec 2025 16:36:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c82858sm107593345ad.29.2025.12.22.16.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:59 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 22/25] io_uring/rsrc: Allow buffer release callback to be optional
Date: Mon, 22 Dec 2025 16:35:19 -0800
Message-ID: <20251223003522.3055912-23-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which does not need a release callback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5fe2695dafb6..5a708cecba4a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -148,7 +148,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	imu->release(imu->priv);
+	if (imu->release)
+		imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
 
-- 
2.47.3


