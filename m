Return-Path: <io-uring+bounces-10908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD711C9D6BB
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8AD73A9965
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE4623F431;
	Wed,  3 Dec 2025 00:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zp1u9c5Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1A21EEA5F
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722213; cv=none; b=FBxlJVvs8saqxXzY3VFZrhQD5NUSrh3JGTmrKMqDeH4/C4WyeUPRrm8Vs8ki2gPRZF/GLwHjBe9oBtJU1F7ad3QERKKvoi8z4qiv46jRlVvXtQ9aWCdDVtDWRgPlKHf37MYEdWZFUbWCN5muyOpkmGSosOX9Qe2QA9ckDlPK+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722213; c=relaxed/simple;
	bh=Gq4EohnDLiLhvA13waj017tjnt9miiS8JKFxzcQ91nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR8kr2ee4ui6WyIa36NntdaftqfIL8k5IG7n1p7sHLvEIzNS4GxDXoE+oxYeBgZdW045iJoOGI5AeeJPGYpRi84XabAyobMgHPXCqtCDfeJ5n1cWDheAr6NUzqiv1PFkXxA0W1gsLal6UIi2VfZBG1z9ULMHcG4yZYPUHJ1G1Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zp1u9c5Y; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297e264528aso64158005ad.2
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722211; x=1765327011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ovLoIp8wIOYRxKmLkTi+d+xL6weQO8L4UyvbcbaHcs=;
        b=Zp1u9c5YwLvY4kdSw1Y7bh0OcyOSIsdW56/xLYx0X3HVGUFvO3Uo7fGY3eYtS37iol
         MuvY2nS/gMSx8ksAR/xLoTTU33jbqsKb4ybXqs3u3vr1Tq55Sm4Iw7fXHFvls6H3hTX6
         c1MKjLOrjsWdNhKe4D3oEOe8eBj6m3wjf5RXO4WeAWCydFgCpzooYJbzaJPPgKtpufeo
         4LchgIJ/TJR9gYu4kVrScGvvQnkJB8uKlSZusrxs4sw4t+GJW4TvpWzG2KZDidLg+c4Y
         DCv6XwNIK4567RY7+sV6TDrVVeUW7yw7/vLOFfqRCwFs+WFs+ASq1A4DLGbYYgDCbPIW
         H+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722211; x=1765327011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ovLoIp8wIOYRxKmLkTi+d+xL6weQO8L4UyvbcbaHcs=;
        b=X5aVPU1QKf4Mj2/whJOeCkcX3tk6tWMgmsVZrtchuGdzqAKa3lsf+ohIoOuQfV3Zdh
         I6/bW3Ch8DENgq2rb6MA0qii+re0uzsQXZ1gqfNkzc3VwyK9HH9pnEH0AMcC6z6tcxMA
         GFoNjDOqis8NTK1c0q74b3CVTkDobT4Azlnf1COMzA4yPW5MSSnfy59WKTSvr731Y4go
         Z0A3S36yGYxG98QR4d/BhelF6DJmswDCj4MMQdvYJ1Ibz6Ij5go827a2x2u/UqZe81WL
         kBN3+pX7gBJv3PgE12e+viGnBTXTWobeJ3eUt0yuGKBxakJ6ju3/13RIRisHOFSXZqKl
         +xkw==
X-Forwarded-Encrypted: i=1; AJvYcCVaOt/J+XLiDoSKcn9DebnaCpaD3+HCB7paH1uF6BfT4mLu3Z3On240VGaJWf5jW716XIOlnhAKqA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3ovic6/WGnv04RAuCyjsly25poiJ8G40efTa5rKp+K1Wr0qz0
	0NtiyPhWCmcWhn476arSEHp/ERny3wJFm20fJaRAoy++YSR4+Fu1Dt8P
X-Gm-Gg: ASbGnctXKSll678cDeBRIrag68iPjHmJVdVyztc9t7PByeKhx4hCkYlgcVj2hEXZdut
	frux7mKC9Y/BGwM9LPlBltckl7WrLm+vh+NFxiZVpi/vXhObUlB7uV/7Ug8FzcOjANZkU3Rilmi
	kU9dUfYtxMdoOekMgYxuiKaSEk+g5HN4QLG8kxatMQ+TfPjcHuVe/bH4pO00GxHYQzlyr6GX8Bz
	E64dC6KTubyl8OT//IueFdPrzGhICz+f3HIdFd51vs2Ebz3x3KL3BllplCYPEtpj4mlBcNsA6VO
	mXxVi/L8Gx6+h+vrn0C2Ue+KEH0p3msODf/uyvwRjLdwvsyLNsnnNm0eKiSr51fJSLzChBPSmks
	t5nLIxrSg8tw03jdaddPd8orXgoJdq3pPG+f58/3XUs3DTOwdCsqeybl0Yu1/ToD0LI0KZU9gCk
	SfOO4qe9Qm3GbfohMjkt4Espyk86nV
X-Google-Smtp-Source: AGHT+IFfpQ3v4X7ooNfi/KRmj0N8M/KPvXG8PZVQg3QsGuOBdO1S8PqU7PdH79SLSdr56335gB+ZFQ==
X-Received: by 2002:a17:903:1b6f:b0:294:fcae:826 with SMTP id d9443c01a7336-29d684844bbmr4820335ad.59.1764722211461;
        Tue, 02 Dec 2025 16:36:51 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb27804sm166724115ad.54.2025.12.02.16.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:51 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 13/30] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
Date: Tue,  2 Dec 2025 16:35:08 -0800
Message-ID: <20251203003526.2889477-14-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When uring_cmd operations select a buffer, the completion queue entry
should indicate which buffer was selected.

Set IORING_CQE_F_BUFFER on the completed entry and encode the buffer
index if a buffer was selected.

This will be needed for fuse, which needs to relay to userspace which
selected buffer contains the data.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/uring_cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e077eba00efe..3eb10bbba177 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -142,6 +142,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		       unsigned issue_flags, bool is_cqe32)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	u32 cflags = 0;
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
@@ -151,7 +152,10 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	if (ret < 0)
 		req_set_fail(req);
 
-	io_req_set_res(req, ret, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_BUFFER_RING))
+		cflags |= IORING_CQE_F_BUFFER |
+			(req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	io_req_set_res(req, ret, cflags);
 	if (is_cqe32) {
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
-- 
2.47.3


