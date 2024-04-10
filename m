Return-Path: <io-uring+bounces-1482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 016A089E7C5
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 03:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AA6F1C214E7
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 01:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41288A55;
	Wed, 10 Apr 2024 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoDAFIXm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8B2391
	for <io-uring@vger.kernel.org>; Wed, 10 Apr 2024 01:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712712432; cv=none; b=TibjcQcuQhxDcquaJj/4LMlD4sNwzYAaH0/XCRLjNH7cZ3aF97zkBcf4aIKUzbyD6hcK3yvaxKXhBaBnu2cMrRv6G1yTY/JDx535DAmisMXBcQsQJm9h7Pr1CC4dw20Qfxbq1aXsMv3AzDJ71VmjMPBw68LPcQuBX+3saB9IWs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712712432; c=relaxed/simple;
	bh=3Dzb4eW1A07KwqFlAbgsH1FHC+WelK919iJO+FVQ0fs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HFBRnrP7+neio5sbWJmr4EWo0l6V2RLfyKqL6yhBjGOKxKyvhQH1pISvNwn0WHrt4AXiBEl5wyf5TgLR1VXMMxfiEWCzNec0tvu1BuBKQQYB1DEGz3EpXWKbUMLP8+HvkhYy/8+afVX6XBoc+3oWIMG31GEiPCLT6KyuOKqUb6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoDAFIXm; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-415515178ceso40361125e9.0
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 18:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712712428; x=1713317228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8s+lr8nSLFoLTYAFurdC4ChBfl6ZpM4wRQ2XWRyoXs=;
        b=NoDAFIXm4Pt/nzKjsrA3htq2P3u9ekyWqQ54kTOl4gm5GCJbJ1I/pBDZALTmf+M/Lq
         Fx4zNvYpTdM5wqcQEWnmB/bqqxfEXUXd0SKrZOCatBu6jiLeAz0PhY3RuvMtSRHSyzNH
         lEXz/WP1UkqCJG55BvY4kHqow33K4LkVk9aein9g8QNjx4ssbxB028el6xQOrm5l9gs9
         n8yHkZHDoQsxZ0AtyqgJ9+ZKud3grH0szVmJjXX5HmagaWFRZXgkyOQGRW2zaV7JhCC3
         W02E5sQgF++eFrT11ZbxaPkmKwYUB9PbIv+Amd+E8oQVvH9CO6rboqK6jISY3ihtrFNi
         ZkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712712428; x=1713317228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8s+lr8nSLFoLTYAFurdC4ChBfl6ZpM4wRQ2XWRyoXs=;
        b=SuCeT8/T/aWWR+90DELM/sL+W9rElKv6iZoD3g6gOrjfInWbQ3BLxWUdUO4w/nNVcZ
         NnEwKNFqMA7nbQSNrHgrZBOcN2r4p/2QVJKYaq1yn9unTvr5ug/JHL4bgIIrVn8beUcP
         jwaV4ulbZEecEgWMso/zONQFTuP/Gnz+5dSxjNx48xIAe/ZRVavRTELvVrJV4vEudKY/
         EAU75ZjaHJbNqu6RuPxpgtxH0Gv1W5GGi92sgL4Lytca/Vnm/w0STDPgxlAOOkk+VmRw
         Rjnq4KmJTtNRlMzLn3BC69r8UhWf7wczY/ZDgI4jUcnsdLWtdX5W+SfHWWPSJQKmltiw
         YzIQ==
X-Gm-Message-State: AOJu0Yzc8EqXBg9QKmW/s3P63Vo8xZ1tl1amkQ0iPrrG/vESI51PFFLH
	sNQFOoSATz/bSj1Vy3wzsGf4ysApAmPMkP/iD9QKP/Zf0fPgFnjDOopEVZER
X-Google-Smtp-Source: AGHT+IG0UKyKN0wPpJIf2mkQdPX+0uBkJMmyepjPMiod7chSKY+TnINDi1hqCGqsBZs5ImhAGA0ALQ==
X-Received: by 2002:adf:e541:0:b0:343:9b68:d9a3 with SMTP id z1-20020adfe541000000b003439b68d9a3mr767309wrm.64.1712712428223;
        Tue, 09 Apr 2024 18:27:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d6944000000b00343b09729easm12737693wrw.69.2024.04.09.18.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 18:27:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next 0/5] overflow CQE cleanups
Date: Wed, 10 Apr 2024 02:26:50 +0100
Message-ID: <cover.1712708261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactoring for overflow CQE flushing and posting. The next related
problem would be to make io_cqring_event_overflow()'s locking saner.

Pavel Begunkov (5):
  io_uring: unexport io_req_cqe_overflow()
  io_uring: remove extra SQPOLL overflow flush
  io_uring: open code io_cqring_overflow_flush()
  io_uring: always lock __io_cqring_overflow_flush
  io_uring: consolidate overflow flushing

 io_uring/io_uring.c | 60 +++++++++++++++++----------------------------
 io_uring/io_uring.h |  1 -
 2 files changed, 23 insertions(+), 38 deletions(-)

-- 
2.44.0


