Return-Path: <io-uring+bounces-9803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A1E8B59A32
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 169CF188CE0A
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20CB31A05B;
	Tue, 16 Sep 2025 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+5t/qJm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444EB321F3A
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032813; cv=none; b=mu5/Z9nFE4g/V5s5nasfrixwhbx/6gNRK0E6deajw9R/M6Nzoc8gAh4BNmwV/1BuBwT8UwnIRX+qjAEf4dNE1lmHCqnNoneAGNRPJa8He6Z6geBG2su8Eyg2Fv2z1VdwP2YSd7SeYxHCE6iRDVu4kn9cT2AvK728oTcIMBOZZ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032813; c=relaxed/simple;
	bh=8kXZ8mustuOts6fjWYk4d+cBP0Antdmx6EdQY14uoc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGqQttX3MxVhL4nBnJ+qJ33lql2IK6sY5oTy2hV6Grfm3cAUqIiENDFEK7dDS9TbdndQXFPiXm75Dafyp8OOWfeLjH2oHsjLTXZfuswp1ckL1QnR0D3ANCsp/N8yfMcOozwkaxyNzt3jqO5V/Lm/qBk/vl5M/rcsao6ZY2pI2+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+5t/qJm; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ec4d6ba0c7so949071f8f.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032810; x=1758637610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWyjAQAw6oOR0hQA+TLJZa+oJDeTMkDdqD6GFlMZ74A=;
        b=J+5t/qJmndB5aSrHhKdeLYotFK/Ivb+QzXDO77ePMtV6c5U9AGjzMUuKqr9j8mWKNM
         uqq3LM27tsVBsvwftk6LGhBpU4yW/gdhcRt2anJzVuwUG3PEPkQgymDTgRQdepC2PuOB
         UAHYACGBysxVGnQcif+l/DPhVGWws7wNuQpP4cjEQFUnNXh5Omkp1dXrdlw+hIK36KkH
         DrhIEaNAR3j8B16KQL4RTAP1CWZY55uHk2tPSw4wIiAwoD9/3ZUUlnDsPVOJvAqUjs28
         JfjdCYmoT87SKuFD/k6ssNkoHtxTKT4a5zw1OXb8U4HCm+JP0k5U/cgNDitxc3zcGypG
         HYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032810; x=1758637610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWyjAQAw6oOR0hQA+TLJZa+oJDeTMkDdqD6GFlMZ74A=;
        b=A1xaMTbzV9XAVD27hKZRmfEISkYdlwqSEEtspSUtkr3eSPETCBztDwRM1z4vto1Qje
         +Azj/Ghy+u2u0+lk1m9adBKpxd1fSe3lw5u3gmiHeO9e8GDjLIJkC6QtJqx30hlbHjNO
         T+L8BrThFugQ4Kb4elDgApsDdc+RhQCmjDkBYvShNqNMs7IUhhTxqxY1y+6edemydavQ
         rGNj8E5PaqQovdLe1d405tTjhsaDuRBJRZ8kMOEMzzVynjZW27jpwbHuUfqfzsFU3KBG
         SJsZ/K1Cy5m6cVj2zG1iUk19cysc2iTQjkXNBDZFs4ynGYL5CyDiqNSgE7qIRhpjhk2r
         oLhw==
X-Gm-Message-State: AOJu0Yyx9w0J4WDya1USJYmOq5WGnrjNUZc+SK2fprUPEwWIUXya986/
	lUIGIkm/41boNcYM2S30EccRASaIj+srsJpaB4MeYuMNkopIz7TxOnWcUjU7Ig==
X-Gm-Gg: ASbGncvrErS2SUf/qFL9j579LQ2HXLz6y6LnH/LaZ78UhQhwpGW0Ake+AU+Pkj6ix8O
	OEKJxKGS3DQ3YPqgMqLjR0gH7MaPsV3bNsVFphgDRwbowGgXXSjKzoF6lLyrKWVY0zOXdw1eYra
	Lvx0uc8FFuEgBcrD36G7uz+cYfpLkREQQJJbNTNFDo48JevHFXHS+sbzyWUYWjip4D2yDPiB3k6
	4n8odwNrrMK/1XpJyCB7nU0jSumb/+AbLsPXt3e+YpdW35Ml+jxhnq33Q+niF5JLQefyIDoLzRG
	RkBBWzZCPXMHO/HpXMfCxcIh8fGx5YK3Y4ogEpN3U3gAKS1KjhVinefVFsho4xD3Dr+zHp6g6hr
	lEL+HObkFIQWE4ueJ
X-Google-Smtp-Source: AGHT+IHU3hfW06HfZ4bVkA+LwufnCWKFWTyfWtrSce2tsCNJo1ucNKPVnm/IBbCLweCaWzu3mzRnuw==
X-Received: by 2002:a05:6000:4287:b0:3ea:80ec:855d with SMTP id ffacd0b85a97d-3ea80ec89f6mr6940248f8f.19.1758032809733;
        Tue, 16 Sep 2025 07:26:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 03/20] io_uring/zcrx: use page_pool_unref_and_test()
Date: Tue, 16 Sep 2025 15:27:46 +0100
Message-ID: <5d7e0f7c0dd6da6df218b5ac249fa0e1a053f4c4.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

page_pool_unref_and_test() tries to better follow usuall refcount
semantics, use it instead of page_pool_unref_netmem().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a4a0560e8269..bd2fb3688432 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -787,7 +787,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 
 		netmem = net_iov_to_netmem(niov);
-		if (page_pool_unref_netmem(netmem, 1) != 0)
+		if (!page_pool_unref_and_test(netmem))
 			continue;
 
 		if (unlikely(niov->pp != pp)) {
-- 
2.49.0


