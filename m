Return-Path: <io-uring+bounces-8993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE248B29584
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7117A1899FB2
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC1D2253E0;
	Sun, 17 Aug 2025 22:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EheC4+19"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A891C21D3E4
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470563; cv=none; b=X2T7kgr7nKGxT1lSDJgUzCFyLkQpsRs/c8SOOVkTyvuF3FWBtF6QSyOnQN1G+3FCDtYr/MyiGXYLoYTjiCuNynrP3nYiJ942ZCiqh7Ildmko3OXa94NbR6+/aXjMEFjT1IDqmwuIomCfZSgAOyMVx9x/vYYX2ZTmlK3bRM4w9Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470563; c=relaxed/simple;
	bh=bziUqKWEjTWjiOtPsBzjoY/7X5iBFWDjsXzOkH0M8C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcaEJ0Hji2ghx8RWTpXB9pAhwenOyEHQQASGPwmhJC9ORnNRM4V7iSO89tY9LutcDpubcOIh7+fsXNiasnaSNqxLEeBhft55n4QzqQugo8wUanTAzMjrSLL54JRQIYBrDYDfOm1wBIOFws46hvJh4Gy2kPAW5XBW9x8gdDqZIew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EheC4+19; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45a1b0becf5so17272375e9.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470559; x=1756075359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xDSF/G1Ex+5lKvISRp1QLrksuWEfKXb97nSFcDX21E=;
        b=EheC4+192FRtZ8NjwmyoyzTULlA4yQ54VVNCQorEkB4gFuKOmcu8xb4/uvnaRiUGvK
         BL3Rx68LYkNKZ/nZvwCYX4xDXpzGu19fbzfZsL6yFqxXuNXnnFLhB72cwYxjp9SSpyOS
         AN+qATDJl6SaJOSsPJ9XgVdWJnNskGq2DJMDoHGcF1ux0O9HKWnlEX4Vhafb9u4mbl5a
         sQdYyk6zpepa221Vi20oPNoGEwMUOhpQbXuTXBHP2yUhrRwxKcR/vikQNiJvcDYYHC0B
         GMuk0MopphbEX2DUKZ5gV5FiuRYpL6LObEQoG7uaQ8NCw4jBPcWmBCwJS9LzCoq7he75
         O1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470559; x=1756075359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xDSF/G1Ex+5lKvISRp1QLrksuWEfKXb97nSFcDX21E=;
        b=v4hnisCn7Jou1vGP7KEiyopcM5N+7gx6cBkCY0YAKBOfrATHtz//i320+Q6bN3qqnj
         3br0iQN4RdH0gkPZG/paEQHPrd8mDC05QSc5tIurza+UngH9tn6jyV0FFshearIyrjmh
         MQ+OI/CG/muH3pZGsmpn+f+1x+8efRtdCLim1NTmr0dnnjuffMp5xAiE1kJc83j/OUwJ
         Frnkwil8VKL/KALj9zGF/k36rHy9T02D+6lMWzzG6K8+OG4sxGJk9hwECXT5Q1/vZcm0
         7stdgXuY6JmrJJcv2a8IlL1nu1L1eMpUnURMj+beMqkybnTQq6a5bCAra0cuaU+kyv5T
         jOzw==
X-Gm-Message-State: AOJu0Yzr3JiAA9VkbzFnC/0Zn+ai+A8Tuuw6JPXFu2Q8wiLOIxvwUrNh
	MeuSE7sl87e6dTyUxMfZ2dwnrC2UwMnKVtg4ysvq9vB1bdLCRs/UWn42s6Mziw==
X-Gm-Gg: ASbGnctg05oW42qqC2jmbUmJsAc05CHuwqPm8fw+eDaPk5XZCzIDtxqfeaI1g1zEVU6
	54nb55tDH8p3w7+weGXG7EXIIMfzKFhJmfDaWwWM/9VqdtpLAVE3CKo9ecTbnu2SH5hjX42zM+j
	Wm8+rFFf69+MNs91P1twuNxcnSjLU6tbRl36wb2ykBlraWWXM9x2Y80q7a9XhRHMrGfqpxIJGZw
	8mZwbf0OSoTFDcNKULym1bQCfPc/4OEIKSCoD1TDhIdE3aXAYFlEl6YuuyLNaQrudBGL6nletu+
	s6MLnM4X87/so+7aMxIaif5P4fQyOEz3lMhwPLtm6t0odMhDpf8ZcNw0avYPt7vSW8azH2O5l6O
	kiglRPQ0+Jq1OMHd7XumojJZEtcvLhY6mjA==
X-Google-Smtp-Source: AGHT+IGCOC1yvqqMHB7KfsWKDaDZE0kQdy++r3nN/ylsz5NQaz4SOvgujMftb52sNs1ces7Dsj/JUg==
X-Received: by 2002:a05:600c:1f1a:b0:458:f70d:ebd7 with SMTP id 5b1f17b1804b1-45a2183d439mr71869755e9.20.1755470559355;
        Sun, 17 Aug 2025 15:42:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 03/10] io_uring/zcrx: remove extra io_zcrx_drop_netdev
Date: Sun, 17 Aug 2025 23:43:29 +0100
Message-ID: <beb96e1b6c12a69a355a36e084f95131a856e4fc.1755467432.git.asml.silence@gmail.com>
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

io_close_queue() already detaches the netdev, don't unnecessary call
io_zcrx_drop_netdev() right after.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index bd8b3ce7d589..ba0c51feb126 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -513,7 +513,6 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
 	io_close_queue(ifq);
-	io_zcrx_drop_netdev(ifq);
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
-- 
2.49.0


