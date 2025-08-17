Return-Path: <io-uring+bounces-8991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C4F4B29581
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14B3B1899FDA
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FAC721767C;
	Sun, 17 Aug 2025 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qsc6aJdb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6F6220F3F
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470560; cv=none; b=QoIupFIMUvMXHodSVc4InjbxjY+RhEQ4DaiGBeQsQQgv2UX5AzjWKRFoj2dRMhkjSOrcbTJPHL1Bsp3/57uLFSGVHK/kPQjo1B36tP6VY+dFftl6nooRlmYp18Faq2Og6AcqqMeXqoXNoX5dmG25ktHvE0pG7ctVGXsUmvbXc3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470560; c=relaxed/simple;
	bh=atAlYW0GLu3YcT3JbtWHs6gV+CUz587x9R/yaPIKJPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi0fJSVHRYqtGmtehybqjZVkHGn/Eov1HFIHQkeJyXlqna6RKO4nd94ObZQzTnoSwhMtXeX6XK4DDHHqvFHbBlSh9oDPgCZhw3H1sSnaqkZsNzHrXbqUfv4rDXGNSAOsIOo3U3p0anhpqRXiNSg5bw/0IggQPuuFgSuuZeXOpQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qsc6aJdb; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso3378146f8f.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470556; x=1756075356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8rvXZ2nXQY7zIofuuwn6fZo3rcBrSYpYitcjki0rGM=;
        b=Qsc6aJdb86mFw60Z5FV0wfbZbFjdtoq2UFG3uu3CT+D91NaNodq3jRaStH+JC6Rfom
         ZSdJVsyHfKFmrwOrQf3HovZQTQzIVAJdt3l7vmNy7LGbTN3KGBv/MTu6EsW9uJa4c5uE
         AzuFxofLsq0Nd8nfW5n+mf+Qdq4hQrfsv7CKpmqzd8cFLGpLvpINKtOUzPI3AVRIDTND
         MV/BRoQIcyP/h9CTQCg+k152HFNXygsXyXgN1opyPsOwr37bOkTogR/qcYpK1EvNj+ty
         8aok0hMDq3K+OnMWV0eFJaaJ+Qt5A26N76/z113QWDu9I5VB9qwMZanNtp/dFRw0OaTb
         tYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470556; x=1756075356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8rvXZ2nXQY7zIofuuwn6fZo3rcBrSYpYitcjki0rGM=;
        b=b+fSnoXrXo2UmyMuXVcR8iPmI6ahBCOrZeD/ujqLJmrRQEWePXvOx4cbsLwuYDq1Xe
         W4UZMHZGtpE+AcH2U0BdUDheh8jcXlAbsNq1+v3sm/XgYt+A0DAEetQuKLt8DOMDSJ01
         Fka4q/ichaylN4E2o1TvXKqbnXHrAzIx9njvo6kJWSc5BmXP5fI779xEOrqvr/eBkLVY
         eN9Orb9cHsoXhVeFn49Th8aNeBXB3/yUe+XJn8QdR3vAZ0k8XDoVDnhvYwciyu6x33+4
         WR7gwICA4qigqJhnnV1tixLWbvbUBzk62bcXtqDhmHJseU10KAIQxtZr97rZ8AJYm0u6
         QJ/w==
X-Gm-Message-State: AOJu0YzQ9l7lEblDV7CUD1pp+JgFs9a5cedBcTEVk/JH4nkYYJDzyIa7
	J3pWPYGRV1QqCrxbHmFcxOH+Vz/ceFZHRj5ReG00wcPPqzGTkp0x9YxjY/1Zzw==
X-Gm-Gg: ASbGncsXQrSTTYMcLI9cmRd/KNeA/ESmYS8x2mqocPKVf0Ln7r+A7kAvOyfkBC9Hzcq
	eZrszpkh2fphP6odwd3QP6khwKJVCdhJHHKM/iMYCwYKIKcd3cWT0ssvhy6W3pGhrmB8YuV0HLH
	RjFNWOLYJ14DVXS/1E1Hpf1PNSflH5C/zSnjjRdt0eL3PCROrSbUMwgitPF0MewIoq8mHtmBfQI
	yeWe3Xq9qPnZYqINZK+P/TyG/x0Z10f5V3BioJN+uzUvG7Az4Kt4YvUy3lYEqL9FXXaoOhYv+Kp
	18ThJVihk4BkHVYgFr/peW8RWLijQHaVJnnoGtf/FNbFoUJ9W5iVoh/VfLT19u9mVmjwRULgNkm
	Iiye0c7u+s16hAD/MqMDb4F1JUy3FBVkWW0Z3WRD5ae5J
X-Google-Smtp-Source: AGHT+IF44htEqqZ1GvyHvVQEhz8yHcKMxdeaXCyYureTSVZDeaK44oFlaEIuM6GhTB+Xa0pUJQZJgA==
X-Received: by 2002:a05:6000:2304:b0:3b8:fb9d:248a with SMTP id ffacd0b85a97d-3bb674db4ddmr8196846f8f.24.1755470556012;
        Sun, 17 Aug 2025 15:42:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 01/10] io_uring/zcrx: replace memchar_inv with is_zero
Date: Sun, 17 Aug 2025 23:43:27 +0100
Message-ID: <443aef75c919b66217d5f651718c95aaef28564e.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memchr_inv() is more ambiguous than mem_is_zero(), so use the latter
for zero checks.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..66bede4f8f44 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -561,7 +561,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
-	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)) ||
+	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
 	    reg.__resv2 || reg.zcrx_id)
 		return -EINVAL;
 	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
-- 
2.49.0


