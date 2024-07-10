Return-Path: <io-uring+bounces-2483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA0892C7BE
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 03:06:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 589B9283A6A
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 01:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CD753AC;
	Wed, 10 Jul 2024 01:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="VkkZlJLj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1971392
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 01:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720573556; cv=none; b=TahKNqFfnnftOLH6g9g05Z2GRjwMd2O7PAUMIaEicxLYGJMy4EwaqlzPUXjLU4pLpBOVxwoAGgRobdQL+IVT6u4846LZelThWp6v+rM8DF1wIJsN3qh/+uvGpxfnP9nxEWNrcvIqitvRhX/3t6E60xYvEtHauDaB9YSpbNlPDrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720573556; c=relaxed/simple;
	bh=I1f4+j4VisWyCO8PAlPOE6YvEt3S5WJBq4/Lkq0Ma0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LAoQQAwkJphqBMHFOuclUeclhhT2EF658tJw/vx98otgC1QZ3jtUHwhoW1GIr1P28NWTbGk/XBzUBin2xCUVbFUSPRCNnpsUYLpD6YkHRcwG1HS+n9pZ+6pe/Mg/3Ecd5tVCDckK7F6ap7rHJHHJIBe8WfrNrXN3idfpgMiaReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=VkkZlJLj; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-58be2b8b6b2so7229700a12.3
        for <io-uring@vger.kernel.org>; Tue, 09 Jul 2024 18:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1720573553; x=1721178353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wZBbgYfrOWaQkS2J4LZroamEeK4UJ6L3MdngZigAzGk=;
        b=VkkZlJLj0PmMz0GvhHFYhXMc1kV1BF5S6SOhDwEsFpeQx9/cbWsNwLwpREerx0xwqs
         v0iKQiySkxmISN6ZrFgDDA0d7VWNySpt3Tq7UuAPqXI5Po0ktWD5uCZUJG+J/TTH1ddw
         j64DElYMUmtASBZ95QOSaMofpT0iHU0YzXlf3XcpXmMfvbdm38yycfKVf48m/Fy0utYE
         qmI1t3KsNUN5nIG5UMm7FLbSA5QvLHLwKIUtDL9ZHljM4/PK+ZIwqUM9jnuwRpr953p0
         bTsRyli3dZZJYuZ4KzNLP46E7VPMV/RRjER9qcBYm9p/Zfz/QtBY6XMQ3JnAikd//cLh
         L0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720573553; x=1721178353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wZBbgYfrOWaQkS2J4LZroamEeK4UJ6L3MdngZigAzGk=;
        b=HU4mIgbAXLZbMTrvFUGVebppAstmwNJFJK/l2RU9C+N66SNQXH9hbKkryY3kHjaWw8
         Ebn3fBwAFfbOQS3Z3R1bcEgZWx/avIfYjwcuXeQRX941gzhfg69Cy2DkzTS8BuF34rBS
         PCUxAoETvBRE3M70jATCYC3pNDNPLYUHyZ2h0RNRkcoRdBU0Midrr1yB9KFUJPUNWlAW
         Gq/X3D5IllOFxMoqFPswN/N0VpxZC/WFeTfguKl5COBpLO7wkDO865HdHjT2cSZwn2/A
         68x1RARypBq7hB2WLLjril94eTFou5wINO7c8F/vNIfWVJFfbEEK0d8nbvTX9+mgCk1m
         /jgA==
X-Gm-Message-State: AOJu0YydWHgebThW6mtWN5Ks7Kg/YhzGQ6GM2RBkx+NSbgOBuwthFZ5W
	bnMCmiK0YN+WjDpI5nNEQcJAIw7OzuTIduJl3DdVmG2QBlfi3vWxv/r20j9F8r0=
X-Google-Smtp-Source: AGHT+IEUZiU9U3tjKwZHU6jK9LXVcFiV2eMAM+tftl8C+0qpsA+pViZFKnH+2vEYoDdFVGAkUjkINA==
X-Received: by 2002:a05:6402:288d:b0:58e:2f0a:d5c8 with SMTP id 4fb4d7f45d1cf-594bcab1593mr2124090a12.38.1720573552910;
        Tue, 09 Jul 2024 18:05:52 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-224.dynamic.mnet-online.de. [82.135.80.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bd459aafsm1625844a12.78.2024.07.09.18.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 18:05:52 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] io_uring/napi: Remove unnecessary s64 cast
Date: Wed, 10 Jul 2024 03:05:21 +0200
Message-ID: <20240710010520.384009-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the do_div() macro casts the divisor to u32 anyway, remove the
unnecessary s64 cast and fix the following Coccinelle/coccicheck
warning reported by do_div.cocci:

  WARNING: do_div() does a 64-by-32 division, please consider using div64_s64 instead

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 io_uring/napi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 8c18ede595c4..762254a7ff3f 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -283,7 +283,7 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
 			s64 poll_to_ns = timespec64_to_ns(ts);
 			if (poll_to_ns > 0) {
 				u64 val = poll_to_ns + 999;
-				do_div(val, (s64) 1000);
+				do_div(val, 1000);
 				poll_to = val;
 			}
 		}
-- 
2.45.2


