Return-Path: <io-uring+bounces-2001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE888D4F0F
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16D1AB26FE6
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695A6145A01;
	Thu, 30 May 2024 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gqrqgqQr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A892187557
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082917; cv=none; b=s/KKuFdrkcFinAAWZN92BpFa7e4J8SKpmPDXxEMdcmpj77PbulXTIBKg/WK9rO4lQAVrdp5s/5++ID1JpBCTvTuD1Bd9sGWzdDHEWVUmkPRxXJn7/MsfaGlzOZ9xZNQWs1W9xPzErHSfRJDYX2Lx5By3jYU7YhvmWM+jSxeC9E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082917; c=relaxed/simple;
	bh=Bzw+1ef5Mh8ObwnWlppRYxQO77xq9J6Rrwtc5pjBRlI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pdH7BV3McAyKu/1I/u90wbeC4pIwHcwgV0U9dkfjFE+pcajL4NWbbYA84kCxb6nCKfm2VPv4e00qvCyD03+W29Lr26z4oKEYLZ6YCwKwrJH6s7UBaXcbVccWonabkLMny/wpA6tcRocFOwzDGhesRUjF1pbV20ED7cEOQgUnYZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gqrqgqQr; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3d1dbf0d2deso114929b6e.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082912; x=1717687712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=UNEpPUJON9r97TZDZaAzApbJJXL4Csu94XMczxbyzY8=;
        b=gqrqgqQrukOk8l08LddNbA9Yfx5dEWV/vTFHnK3WFPSGewQvC1tVoXWukSLrQPN/ds
         r6bBbdkO3Lt9ARV+STh96Zbqk/XgfeKECL6/8CXvfcJjS+W/l7j5G8iRDP6DMRudHBrT
         mTeKd+BtYO1JoD28+HUjDchqh0JeWDYsW1gvv6DHI5QQq1omHTfSKtm6hICbmkeal+9g
         Qk6HdY9vrJVtrZTYKWMo1renpruCUC83u7/IQN4x8ZbF3zs43zKtfN+a7qKGeYGolyco
         d1ulvBNEovfcYywM2uE823jeX/16eIzL+kFs6zhrFxoUj8XeFDMnnwrYd1mZfd9AUaiP
         l2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082912; x=1717687712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNEpPUJON9r97TZDZaAzApbJJXL4Csu94XMczxbyzY8=;
        b=grJc4y2R39hlZ50TQttpzyQf+4tm5l17WW7p4mPGRG2QSUgIa1mu4iixC9jFRojiUM
         hWRQx4gSfuaPWdhqHBd+SRaLjJTHdAnDVDakzy34TY0dGoIUSKTVBqadpz4fS1N8/l89
         qHQDwmDl9w9bdPLBT7EkD/n3B+2oNv4AJw7QunDm/tg5+6FGtjdSIPa8gWKKl9aMiL2c
         pngFZStpYQ9Wes4/Ff3eRc5G1yruusBOkwLzcAkxiwqZmmvE2dfgqhlJGCWIFlD7nVPR
         mOwlczbv6yes1WqZ3f9rhxHhQ/Z/58puNSIbX1e+PT5H3O66rkFfa3eBoe43eTj7S4g/
         /5rQ==
X-Gm-Message-State: AOJu0YzKcdqLyKKL4R9TUB5FCxz9qVr7UQU0/R6DD8cwe9nf8FLegfKw
	MgC2UVv5qtbura0XybmYXp/fl7UeR8tAtOuZduY7pk6CZBBX5vReUBHCns9KEpFv9BNRReQiaVh
	u
X-Google-Smtp-Source: AGHT+IGVHo+H7IWL7BBBeFZOaKxgyTy1OzOL7t8ck0826jpuhoIyd2eUHlRT9EpwUWedr3gEZ/F02w==
X-Received: by 2002:a05:6808:1788:b0:3c8:49ef:cdf0 with SMTP id 5614622812f47-3d1dcca28ebmr2867723b6e.2.1717082912301;
        Thu, 30 May 2024 08:28:32 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
Date: Thu, 30 May 2024 09:23:37 -0600
Message-ID: <20240530152822.535791-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

For v1 and replies to that and tons of perf measurements, go here:

https://lore.kernel.org/io-uring/3d553205-0fe2-482e-8d4c-a4a1ad278893@kernel.dk/T/#m12f44c0a9ee40a59b0dcc226e22a0d031903aa73

as I won't duplicate them in here. Performance has been improved since
v1 as well, as the slab accounting is gone and we now rely soly on
the completion_lock on the issuer side.

Changes since v1:
- Change commit messages to reflect it's DEFER_TASKRUN, not SINGLE_ISSUER
- Get rid of the need to double lock on the target uring_lock
- Relax the check for needing remote posting, and then finally kill it
- Unify it across ring types
- Kill (now) unused callback_head in io_msg
- Add overflow caching to avoid __GFP_ACCOUNT overhead
- Rebase on current git master with 6.9 and 6.10 fixes pulled in

-- 
Jens Axboe


