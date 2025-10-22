Return-Path: <io-uring+bounces-10111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C146BFCCD2
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D442D3AE645
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 15:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987B132C954;
	Wed, 22 Oct 2025 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZH6rD+LG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614530AAC7
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145656; cv=none; b=PEgTLhQffxTBFCqucuWNbExHs/yiC1qaphXKLBATxyh3K+tDPAuJKNsjEXokeLKLhHy+tXNAYlrAVFwp/MuOObxO2jtxzY76BJoDpvJhYUl8ujnCLfk4o9UKUnmtbCkxQ9Zn2Tr2mngABaon3WdWdDNYnqar1fZY7qtw4Mzz7dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145656; c=relaxed/simple;
	bh=laoIWGu4p0dTammd2Nay5qWKbVIQdGqiuFOD52Zityg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PbflYsmSp3FtnRC38DhZQGoXruMgAtj1xDUAMpJDC/pN4FQBPl8G4dNW0feTXLzA6/YRtFkopdwU4HbPi6u8sGqCyym7soqV88GzpEhlEijhabquCqJM0Z1ziIzsnevJi+Ee+5w+1UUj5RSQOtib/vwjXT9q9mrFtJ/NePyHSa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZH6rD+LG; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-78f30dac856so92642306d6.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 08:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761145654; x=1761750454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LwzTm8USs1oolFR4WnnlWLIHx/1z1zWMBPnOEps6YoA=;
        b=ZH6rD+LGQdTAZgGs0I50PCHpiQ4FR+8W/ThEunCTK52ksJFo/4y6TLwy2WZdq7feq4
         YlGsTLEZzQ5K9U3cY6nShgaDK3F1be7wfKmhKIPOXFu45OjlhodwwZ34m1EEAmurzQDU
         tlm+9EPLvzvBHef1oxhDeRfFaEU4pb6JjFBqZVDwYzTLs4CFTlELCuF++wrVAUVZym55
         ywqv4cnncylC2vOSLEI9GRvTDqES1wtnW5GfQY1TXcoIDT5+Ul65ttS9X7rZ5xGc5kq+
         fHB/w+XrhbSPutrTAGWItrp1447gQPz1tM9vGxu+U57TeQ0Ouuez+PU96AWeaET2ZdqI
         yO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145654; x=1761750454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LwzTm8USs1oolFR4WnnlWLIHx/1z1zWMBPnOEps6YoA=;
        b=TJkYOOJk5md7P3Nr5pxIJxiuIde5p/VgnPrPfy0pyp7MZQrkCd0grzgEWr+39lr8QQ
         WDAmfQLloZptJAXjy2/QmWIT+l3UjEQq64WIuL6wrnQykkOPuNn4+hsYivJhsmyJNkoo
         OvFnhwWb+vhA0SDP2AQpZR8VRA0bPAKuQVL3ck54szleGGQfaFE3rP0NzzPfuuSy2ri2
         bgo5lQFNNWqhQ8PGuC4qskq1Jo9RCokEw+aJnQ+MHtg+3CjJxGMi8T/DpSMp0ZR8Diqq
         2h/Bu3tY8QfCVaAyVhWd8F5a2LLJDNcCHtfjmtT4ZITv9GFAkpXFg+Ws+z6kPPPCdEoe
         UBHg==
X-Gm-Message-State: AOJu0Yzc7em+lq3xnRjLF2N5zuczemyqv++DQxkECS9AvFXZyY5jsAFy
	m52K7fUl1j+Y+5Tz51uf8PG6ODs9fcbYv9Hw8dYFlBSed3t4PZ5sKZy7
X-Gm-Gg: ASbGnctoD8lAMcpaviKRe9sHOYi1y0GgnoN+dJLHydksy42TOawgb2VJDT0K5diMkaV
	aF/V2yrWH7EJVVM2b6WXfQMNZ+dAEnLX4uKUyu7Jv1g32iyDOdx6SuQDAKvOT+C/JZ/vKlaxcGm
	SC5tjzXNDS0PuyOURwes3pGuOzTYMd8qiGNQ2I13wrWqZQD0U/0LSOZ4P8wAEfgyRAmA9xFK2ZH
	m8xelN9WOe2fu2cDD5rgrbjRnfHQn+6VhACcwjwIPw8/o69PVHuQFK9HItY65EdODsQFypLqh+B
	Mw3xeEsFCnX+T0w/YchTOAN5sBlA9YMaXVhAf+HVV1awslpUknJuv6aFPrKE2jcaBw5YMD6rSGe
	WpQWH9YBQx0jhXCdFlkzgd3D0xplCdCQaksx7g3DQLhlpNCGPdnYfzjNoiGy4nHa1kH5icBt65l
	j8HyYa9El3mIOHmnviqLtNrsub/xSQ099Z83j8hZrgs+cJyKNFAfxb+W7URNxI9F1j4w1ad53IT
	KvSGGWAjFd7uSl5/odTPFkiVihRR/iaSETGdyIfveP0A6119lRnU8Dy6FKvvYEmgZni8KK3
X-Google-Smtp-Source: AGHT+IHsEoy9TxGzvUXGFHK7BCWyNK142Lft2EHU0bFZvJFw5sqf9x3YTrPE8ZGiTyyaXtUe0r/i+Q==
X-Received: by 2002:a05:6214:21e7:b0:7fa:3202:5261 with SMTP id 6a1803df08f44-87c20543291mr269537286d6.12.1761145653653;
        Wed, 22 Oct 2025 08:07:33 -0700 (PDT)
Received: from NEU1-L01066-Ubuntu-22.04-valeo-wsl2.vnet.valeo.com (ip1f10fd85.dynamic.kabel-deutschland.de. [31.16.253.133])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf521c2c7sm89448266d6.19.2025.10.22.08.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 08:07:33 -0700 (PDT)
From: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	Mallikarjun Thammanavar <mallikarjunst09@gmail.com>,
	"kernelci . org bot" <bot@kernelci.org>
Subject: [PATCH] io_uring: initialize vairable "sqe" to silence build warning
Date: Wed, 22 Oct 2025 17:07:16 +0200
Message-Id: <20251022150716.2157854-1-mallikarjunst09@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clang-17 compiler throws build error when [-Werror,-Wuninitialized] are enabled
error: variable 'sqe' is uninitialized when used here [-Werror,-Wuninitialized]

Initialize struct io_uring_sqe *sqe = NULL; to have clean build
Reported-by: kernelci.org bot <bot@kernelci.org>
Link: https://lore.kernel.org/regressions/176110914348.5309.724397608932251368@15dd6324cc71/

Signed-off-by: Mallikarjun Thammanavar <mallikarjunst09@gmail.com>
---
 io_uring/fdinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index d5aa64203de5..e5792b794f8b 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -89,7 +89,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "CachedCqTail:\t%u\n", data_race(ctx->cached_cq_tail));
 	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
 	while (sq_head < sq_tail) {
-		struct io_uring_sqe *sqe;
+		struct io_uring_sqe *sqe = NULL;
 		unsigned int sq_idx;
 		bool sqe128 = false;
 		u8 opcode;
-- 
2.34.1


