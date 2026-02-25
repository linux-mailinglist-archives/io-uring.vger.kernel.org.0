Return-Path: <io-uring+bounces-12412-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cI1bM1fRnmnwXQQAu9opvQ
	(envelope-from <io-uring+bounces-12412-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:39:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 72C59195DEB
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B880730E0502
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D997392C40;
	Wed, 25 Feb 2026 10:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQpsWm2G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD06A392C34
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 10:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015768; cv=none; b=m446yCZOXY2N2cwsCs/4Wk5ANQX7YhxbmHD1pYa4B05b6BV+3wi0EG0MATDeWRjfzkGnfkjI91apJWni0BcITBohvOHbLpQwy/Ju4dUnAqFFMK0TH8GHEWjejB8QB11hUt6fFOoZ9rRPjQXIy0aOkDm7PFessxGSENKh8/JJyck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015768; c=relaxed/simple;
	bh=TiVjdH3gaVem5vX8PgQkWITG5CoEH+ZIusfPtdRCkFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zho/ZJybjiM5ICZwGvKt88EC7drTbFAlSHFF0Mu442fRdpDr6SgN1m6hKYO/0/MTOYxAVXNBobqZAqAQP/+Xjy7W89Enze7+3E6R29RiiAaFumG2sjpSpIKPQ4P4OJjjr08X3I+vkj7NKF4fCTXJsJa6Gwj7m8QtR1pa553V58w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQpsWm2G; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b8f96f6956aso907237166b.3
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 02:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772015765; x=1772620565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y8aia41outUalOPumlUtGdNVt4TcLt/bx4HqDuIDVLE=;
        b=IQpsWm2G9oveF8iZplxFq3E2HEnSk4qqaVJcLZ0fXUBTWRs/x+7cvMYP2ghHiWkvM6
         a7w2sp3qb7XjOOOnFIwH08Wk7WBIkX5wB7EPE5M2rmTPeBbh9bVvWxBY5hdJgiESJeGX
         oi18xhXYCuHQH0S8YvVxLmgW6pjF9yW3IWpj2+3WaFRXfGnEr4/cHmD0DZV2u7IN6dHC
         Vs4RqR9jiSmBI/TtQJmO7EPK9ags3iyN/xTdZ+dYIxlB4LCrC2hnKZW1mIXnq5rEoZK4
         jFYh/UxL8stMPdtvGEWIf7OYtjeaoYiXE0Z2IYw4DTfOdx9M+seBX2N7k3K+5ZT7F/Gc
         X27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772015765; x=1772620565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y8aia41outUalOPumlUtGdNVt4TcLt/bx4HqDuIDVLE=;
        b=axFYVqlbcRm5ldaVnW+UQPH8PPD+1sc1pt2nnAxJHNMp4M57PSMGGUb1DsCPO+itr5
         LZhiprdeF7W7W9H7Ib2eoBGD6V4fi+q085j59g/duuF1XuxUm/Pv7FONKbFfg2YuhH/l
         pnbg2z3TZ1VFTNq2sk4jGU8nACOEiQD5+1REbLg7czHORs5KaicJWSYn9ITgBE8dAh68
         ziiPDcyLdYYNi6uB5NNtfx80sk8/2knIJ936/tEe7D/IOpIjV5XFwEYc/+CEiK6z8HCi
         cNpmX0kuyG6LcZl6vgLI4oUAwAZTw+o0onL2tiWfK5AJDOC9tzpvP3FbVhoQvu7YiKDl
         GgKA==
X-Gm-Message-State: AOJu0YwKTtXxFtO9LjogJJ8my3iH355R/H/VumlE4BOiQu07rv0ApVZ2
	GWT7sifoFeMc3NAg7y0hC7U/+3TO1VZGI+niW5wgXCYYVmfp9buMtIQhAKGluw==
X-Gm-Gg: ATEYQzyjIBJIqHrefKCp1s6D95Y9DfbTN1PIxKV+08k86l8nnSJys2sNGHBUYILxxdj
	q6HbAFtflYiaUk4F/Gk/fAq3tL7bOX12ghdAgkx08lJIx8XKJn7ols1BzwquOIA3HuxnY7FZ6ty
	hQbmJJoxut+KvYFTaInhd61WP8Ph8d2BteAmEVWQMZXMsGgYUw1LgQAPABRgCy10LrOXAqknlf2
	p08Qk1f0nKDshVdCrQVLBBc4u7OHdNGhqJB2hAYLtVCPiTOyG2D42PIGb9sT3uA0uDBpuIca2yt
	qnmqsN/9QjIIj3n/SL19Hvqhz0S1ysvbCR4Srgnm7EDWaDE/Jp3Zo/K4Uu2gyEviiG8pDrDdgpi
	GRTVVjvjO8RLWV8kOvJud+eODSxyBGl/nSbz4+6r2xhyeYiJRvN+bjP1gTMoRuvBHeOd6nJuIQ6
	2tGigsnHk3gUFYa0epC3F2nFE5byHkAyEW23gPat3Tqm+wuX/4yAvgDpRVPMaHr6N1Ajkp1Q7nf
	p4VEplVe9tBp5SAecCYRKZ5cLJ0NUPTGiTbTic3RgkOJReKH8rSl6D5VRXH
X-Received: by 2002:a17:907:6eab:b0:b87:9d1d:ec6b with SMTP id a640c23a62f3a-b90816fd1famr970909966b.0.1772015764510;
        Wed, 25 Feb 2026 02:36:04 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-214-161.dab.02.net. [82.132.214.161])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c82495sm500530666b.20.2026.02.25.02.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 02:36:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 0/2] timeout immediate arg
Date: Wed, 25 Feb 2026 10:35:56 +0000
Message-ID: <cover.1772015321.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,kernel.org];
	TAGGED_FROM(0.00)[bounces-12412-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 72C59195DEB
X-Rspamd-Action: no action

Allow the user to pass the timeout value inside the SQE instead of
pointing to a timespec, people asked for it as it makes user space
simpler. More details description is in Patch 2.

v2: ditto for timeout updates

Pavel Begunkov (2):
  io_uring/timeout: READ_ONCE sqe->addr
  io_uring/timeout: immediate timeout arg

 include/uapi/linux/io_uring.h |  5 +++++
 io_uring/timeout.c            | 28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.53.0


