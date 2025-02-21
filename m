Return-Path: <io-uring+bounces-6623-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5969CA40157
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 21:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A12E219C68E2
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 20:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 311EB1EE028;
	Fri, 21 Feb 2025 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="rFq3kP6K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8336924FC1E
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 20:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740171120; cv=none; b=XXyp3buLQ2Z3YnWLZ4Ow2L8OAnEeRHbTPgPTqPOgIP3LWZDN14oEMsmBB+X15NAlGl8BNlJoES+NFHNm6AagLr2Jw6w6Rn2C3gb77iLjPiMNjodqj4BIT0KVB2UlzI7OPSzULIBiYaPaD9wKNmrr4E5gTViJZrSv9QRUVxbKRN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740171120; c=relaxed/simple;
	bh=pzqSPM3tw/32lZLEE/bLaFB53ixhTFPjORG2GisO8TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSU2N+w4FOQ7w6AwOSEUObpi3wGxZ10tjiMwWFYMJ330DX5ZeWR413YYoI5EB7B08FZq0BD9Au/oAL9saycuaPyjRXJpLwhYufGP7aFcQA66z3YZ6N8J8XDm1SuEbPM7mS0F3Sy/8XIio9qiY7pPtFrz16xkOonXPLBV8U/4VK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=rFq3kP6K; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22100006bc8so46718535ad.0
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 12:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740171118; x=1740775918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tHE+D40T7Z4k1UpWTvVTFBqJJLSESH4CAgBK/xYoWa4=;
        b=rFq3kP6K644HfMy+FXrtaRGpsDTFHk1OykJ0suxhPUZG4Ip3bBZ1QbKBxMdvP6uHxy
         zy8t4pkEWsRtwJb4losnefWZTQUU1THXQhNDf/Grd58txzZiUs4KwIzHfdUldQmEDC8z
         1RxxtxMul3n0/aU2x9zt09/JDDDoaLJDCvTbxhmzGMpvDuTsUN2REMtbnQuYE39f20PJ
         fof6TCGtcsns93J9AWgfbUxslMylQI27NluNew+PuW63gld9kwesI31Hb7Lf4ldwKRX1
         DRrhobEI6+11oCYEKY+eVbra+g4wneVXTYypljDZo8+dwsyQ9erC5H8rG5X/DzagmQcx
         dV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740171118; x=1740775918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tHE+D40T7Z4k1UpWTvVTFBqJJLSESH4CAgBK/xYoWa4=;
        b=dDYm3RLGEkY70nfR21GFErEuzrkCy7T/GE4u7YJbfdVoR8Pm+nmQ5xBQGsyydPoxWr
         Anv25TuYbnB6w7RWyDWlF7J5MZp2mVqBApmnC+mPSf109gvj7vcnRKnoZptTQ72FIPn6
         tBN3xQXldatMVDD7+fMcUllpC1E3o7F7qMgwiLDOGfSW9YoksJuu3msYjchVrcnoHOZ4
         K2+gtWMOPzgvEIr88qZY9GrFIIkMMK5ASE3EQwZCRU9BfLHqYLsrwYxypFRGFbX/5VLP
         kdpdzSldlJfa/cWUtSIlj06R2XdjmDKXczwuuD4hGTqYtpgnnMyBeWfRQsGzFiFpwYQR
         A6ww==
X-Gm-Message-State: AOJu0YzGvwLNxQLyQ+YCjQ2mXIgq5YLrLgkTNi08Gxl8HjfB13ZgAjjr
	x3pvsd97yVPrbbsrc0elxV2rAbIo8OS6TTWUtotxpx/dCj5vrgTAfwdGKt7JHRpLQWyDX1xsCAF
	4
X-Gm-Gg: ASbGncvpW5ZtYNY6aMPZCHj+yMUN7BtCuG7Qz/E45D7OP6+hSGQwoW3McTycG7dbf2V
	Co5kxYiC6hVG62MvPeybnrq+F//dkHPpQ76KQyMUbjvqhdUhy2elt3M74VIUvkF7aScCg6ZTO2Z
	nQXgeoeRVmPlK9UV6v4rsL5uyMWACq7L3XxiMs8DbmGnITFg+bB6KgzkjxpEws1h1l/ps6qY14N
	4XySjBVvX5D7BuL+Ttb14kwrSbV4QzPztiUcMvnVJjJKfWiO7lbWtImwUkmCgMKasGxOFnc+z0p
	OK02RSkm8Ds=
X-Google-Smtp-Source: AGHT+IF6L9LuQh7AE7DFNJ2JiwoCWvW7wssLRCoiN4H8fAelOK0Jfqgi5NBSHr/piv+JedHnLujJTw==
X-Received: by 2002:a17:902:d4d0:b0:220:c94f:eb28 with SMTP id d9443c01a7336-2219ff65636mr74648385ad.27.1740171117756;
        Fri, 21 Feb 2025 12:51:57 -0800 (PST)
Received: from localhost ([2a03:2880:ff:57::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545c897sm142847155ad.118.2025.02.21.12.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 12:51:57 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 0/2] io_uring zc rx fixed len recvzc
Date: Fri, 21 Feb 2025 12:51:44 -0800
Message-ID: <20250221205146.1210952-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently only multishot recvzc requests are supported in io_uring zc
rx, but sometimes there is a need to do a single recvzc e.g. peeking at
some data in the socket.

In this series, add single shot recvzc request and a selftest for the
feature.

Changes in v2:
--------------
* Consistently use u32/unsigned int for len
* Remove nowait semantics, request will not complete until requested len
  has been received
* Always set REQ_F_APOLL_MULTISHOT
* Fix return codes from io_recvzc request
* Fix changing len if set to UINT_MAX in io_zcrx_recv_skb()
* Use read_desc->count

David Wei (2):
  io_uring/zcrx: add single shot recvzc
  io_uring/zcrx: add selftest case for single shot recvzc

 io_uring/net.c                                | 19 +++++++-
 io_uring/zcrx.c                               | 17 +++++---
 io_uring/zcrx.h                               |  2 +-
 .../selftests/drivers/net/hw/iou-zcrx.c       | 43 ++++++++++++++++---
 .../selftests/drivers/net/hw/iou-zcrx.py      | 27 +++++++++++-
 5 files changed, 92 insertions(+), 16 deletions(-)

-- 
2.43.5


