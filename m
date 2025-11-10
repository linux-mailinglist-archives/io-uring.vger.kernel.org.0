Return-Path: <io-uring+bounces-10498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C12C46C2C
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 14:05:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC32E3BACD1
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F040A1CAA79;
	Mon, 10 Nov 2025 13:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVo/0q5B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B911A704B
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779903; cv=none; b=uJrcp5MOE3/K1BcglZcsKiYpvLI4ZqkCcL+t0HXsO4JkPdGD3+Wyy3nL8YU/MfIzXaphkW/aR5vpssMq63yJ5XWY8xcdoBL2IBj918FozhXtJBsIHehSTHIN8lt8fyvLG9a/k6X7H1UMAlk7+gsToIoSExdrhN/5dKuENDeDrXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779903; c=relaxed/simple;
	bh=E+7UXx7aUN+EyklhEBv8XILvRjuqAvrdEvyV/JnKG9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ae52Df5mkLwea2qiCFcpCCUktQ4NbVTDiIHaSmBGL3UEq0/KXfFEMj1ikw04QIhT/Yx2g8OtXbdATdyI+r0uim9Z0HDwq/Lbb6pxe9vXrrbouui8z9FeYYlkNd/YwnqTSDVxmAr2Y8RzL0XIsxhanE2XsAswm4oZPYbOZIOJpRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVo/0q5B; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42b3c965ca9so352776f8f.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 05:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762779900; x=1763384700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/pow1sNG3x4WRw1BC6p/RJNyY/W/YxF5LhMaSAcius=;
        b=RVo/0q5BbBBYaXXRaDh6u9vvo2C4m0XTnsr63IojnlVXbaeoFWxmsTRyP6qDBSiChi
         ra9SSqwu+QBrik4AT0GOtC/4+Log6+7RsDJPqckGGqoEQK+BbDb/uirRSG22NmDhxtE5
         2ffjsGYTOQ95s0Xpj1Vl1SuXhUbuRd9F2f2508QDMFzWu4/lvjhnMnI6ZExJ5SXmkS1z
         N+T30NXXlILbWvwxKVw984dP5iki7bRP4fyeRPYqYajmAm89ZfS902I7k0UimA7Xd26d
         lULGN+1lwiab0R87sD8shQVHbXO9pnCExPqb2AS1345LYKO3RcUdzUDVjhn4LAPV9ulg
         hMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762779900; x=1763384700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S/pow1sNG3x4WRw1BC6p/RJNyY/W/YxF5LhMaSAcius=;
        b=WQhT2KM59dWO6tGwNKoy/HsjwEsdYYM2WvWFPvUwGqM2SoWHGRzsCqHhHBKqE1Rf1K
         Bwf/AxuFWT7SUF2dl9rmAgFbzkfmGuCFAwzmHyeHgiGqC71rylHIBu++h9QJey2SStsb
         ptcN0ueMA1LLcxJ3zZF0p7/Bd3CdNsilanHzf37deH/GYCi5kqqvoF+e/d8SXMh8p7vP
         uKtqwPrpcEI4ql2GhbpnWLLk9NELq2d5jEI//M4vxYSre/+qjj74FucSpCFSfGSS3X82
         Vd0d7uqPFlmiHtC4Ibx+HP/ErJx9bLKrfMcfeiy7WFZdMPuPN84Mj30W/r0W8AM2PtCH
         Vr1w==
X-Gm-Message-State: AOJu0Yw99pcHxhOxx53udULLl+ifEjEStv/cTdBDiPDR7g8T628doDVu
	7N27aTSLESkpFkCEvIND2QIrnv9YX4Bee3/3nWcqgJdRcvOs6g/N/m2aUFAyDQ==
X-Gm-Gg: ASbGnctc6P2Ip1h2Sx3x6ZrtGoggMv5LG71bpOge3920i98qQc24XXHeF3kxT49KE5h
	ccbQtE8Lo6yINwKx9XbRu559jzVVaPa0eNt+UmUYNYLbLkMObmC17cBGaMoTJuOClqfGo4sTGs+
	SWcLvLjpHgZ+OmuY6Vai8ctULChhUsa79XukMw24pzWlWgmnybPnFuSdsmQtGncBXi1UgBieUKc
	BmlGjyKRVLxiKxhNn3zt+UtIDwRldUgvg4vA66NKdTyTGW9ol1j5W5JzMyungGaJQEtRlwFugYC
	Rous3LbwHDdHXkYuUxhF01klH+QdkM3ybokiABzq0xpH/RvCLZuL60CAuA+aL1JRACq+gRo4gcd
	hmUvoY8CfEDIEaJkVKtRBsQHKTXP5CMQR60hntVW9xvn7JMXy9B/rMlcxfdKgQJskiDCogdZ7jO
	HHw0foP0ZJwD+vXA==
X-Google-Smtp-Source: AGHT+IEE5FxzDcBc+TjBOM79fdGWwtB5hkwX0A3yZ8I1Ru392v7yUc+xNw9r8Icg4mN7R7w1o/Oa+Q==
X-Received: by 2002:a5d:588a:0:b0:42b:3e20:f1b4 with SMTP id ffacd0b85a97d-42b3e20f5bdmr1618094f8f.5.1762779899699;
        Mon, 10 Nov 2025 05:04:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b330f6899sm10584648f8f.21.2025.11.10.05.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:04:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: use mem_is_zero to check ring params
Date: Mon, 10 Nov 2025 13:04:51 +0000
Message-ID: <82dc25501d04bfc6d59bd674e13eec23ad30afd4.1762701490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762701490.git.asml.silence@gmail.com>
References: <cover.1762701490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mem_is_zero() does the job without hand rolled loops, use that to verify
reserved fields of ring params.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 023b0e3a829c..af7b4cbe9850 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3684,14 +3684,12 @@ static __cold int io_uring_create(struct io_uring_params *p,
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
 	struct io_uring_params p;
-	int i;
 
 	if (copy_from_user(&p, params, sizeof(p)))
 		return -EFAULT;
-	for (i = 0; i < ARRAY_SIZE(p.resv); i++) {
-		if (p.resv[i])
-			return -EINVAL;
-	}
+
+	if (!mem_is_zero(&p.resv, sizeof(p.resv)))
+		return -EINVAL;
 
 	if (p.flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
-- 
2.49.0


