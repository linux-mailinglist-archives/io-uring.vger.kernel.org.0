Return-Path: <io-uring+bounces-9114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A18CB2E4DE
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E50E83BCA42
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FC02773DC;
	Wed, 20 Aug 2025 18:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0s+oNCRM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2B23EA8D
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714369; cv=none; b=kXhyA4EOu4AX6ULeQEuKSxaSBCxNZHw6fAOQSaxK+ij8r4vvRn3VtpEsYC4ypH2b+HBYvYXQM7Do2fhhNnUaLJ7RdEbhv8bqDIk0RQvnCc+jOML30h1wahRXwnznE78xMZwSyR7qegJ7vgVzA155jnUJJ2dtde0+b64k6jOMVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714369; c=relaxed/simple;
	bh=Dgf2RelNQctI3tk9KmtEY+JoM0oxW5woDssvosNykK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0+QeHzWoUWsuTt1cupLJ/GgLGp2WOlJT0EuO/Af3jmhiHLPPETnuPqF45Wxl+AX6OvzZo7SOmU5QdU/IwBZdmFoA+8kOmbGBVgaqmcZlqPwvtbHB573h9vomHKqPtWCExsJop79iDxpNScq+EWbGPi2h2hTE/AAe1OK6gpYe7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0s+oNCRM; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3e57003ee3fso654885ab.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714365; x=1756319165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VoslwbdFVQXiJDiyxwT4S1VxnYxfPsPS8dyq9BswWwQ=;
        b=0s+oNCRMRYsDGPBhkQYV3xtCe2rVKBP0Q+QLDHpmk+2EM5Q4x1pSCH2zEuWW+qphDw
         ySmvXK/Y5wfPyUQaviwzgYxgoaeIBdG6NdAUlxidPXDXxJT5LXr7nBuXHyVAkAckkmwg
         3OY45h0K7atSeCuuk+Fk1p6RUzIB5rE/Vkyg9eG8/6qChgdqdWoyUxMxDGU7Y4zsAtPY
         vuJYq8aF5C1aPPOdSoRLrc9AwBeCn3QnB4ztOg5Dfub/6viuuyVhRAlCuoE8Sw/rVCaL
         SMrplsAOwG9AHMJvPgS1ngRHYLPBRZREKMF8y+7S2eAwcR0oQUZo88nt7jmswm31wZ8v
         4qgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714365; x=1756319165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VoslwbdFVQXiJDiyxwT4S1VxnYxfPsPS8dyq9BswWwQ=;
        b=t2rNdU/3opIcbOHvd7VXcHPpLBpv/chTv+zClW4Siwe0KFQqSx4CT4PCGA+tJWUnll
         5R0B0JUd+bMh4Lh7TxSql8B2qjbZdhD+QKjuRGFMPW4v0uCefC0B2kdpCBKno+Ct31N8
         9j8w/yMSfQZwL7cSXvf/zVLbDQImk4jbFectG4xwVl59xY3on1CNpGvLuzC33bYpDLeL
         bOpdZh+xiZSlahZOHelzo8SM0u33rXq550MAIPVfvpwxCYaF1SlXwLr9fuD3M83ulLw4
         f7n2fzmUzSGdHkfLq8+ud/QAwNjvoI6FRMAFnILr1/qUdDvIZkQAhn1t/xXSueNmytM6
         Hj4A==
X-Gm-Message-State: AOJu0YwrTLe/TTweJMEZ/B51IPPS+T6eo4Ce8qM6bjWNAlHl35hotg13
	OqAhHHoNOtNORC3aHmDPgeMDV+dWEQtfPavQztfnZ+QhP+ixcBlUijvn8x/B6vexztW7GEYUv6N
	2xHwY
X-Gm-Gg: ASbGncvH5UJtcyVwt+Ba+JSHHleCMk4m16LFrk28wlT1/xQTjatoIkctHnHTYJtMe6t
	9D0b6HIn2GlGZxshZObWd/SnJJmAlH3/7nZrOirY/bOcp7rHgdhQpa1QKJHJVJFixuGv/KEbnLe
	vHk8jvNA08ofVo/3X8j2c3DqvnlonOM73cyp8Mff0B5BrD57AVmA5ApFpin2eczw0ldbikPakDN
	FatqUDb1dcHPzEDhh6epIL7OVGUI7ACBrtaLHJIPJSyR3aCSOsDPsBJOdiz6c1gIYj5HsO9BNrY
	EeostMtzjuhL7+oz503a3asEiK5bHkUYkkYVNDDGv6d1m7rbuUt1n56OMTVNgsRjSQiSExDfS+h
	PGefu5mixNwCrCtb2
X-Google-Smtp-Source: AGHT+IGAb7JF2j4L5ARNFBAWOz8JhvzFum1S1UWUpo9nNFfZFNB+1Gpjv24egZBMEiLuLMCVHdhtaQ==
X-Received: by 2002:a05:6e02:1d89:b0:3e5:4821:1d43 with SMTP id e9e14a558f8ab-3e67ca39250mr69929515ab.21.1755714365457;
        Wed, 20 Aug 2025 11:26:05 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] io_uring/net: don't use io_net_kbuf_recyle() for non-provided cases
Date: Wed, 20 Aug 2025 12:22:47 -0600
Message-ID: <20250820182601.442933-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A previous commit used io_net_kbuf_recyle() for any network helper that
did IO and needed partial retry. However, that's only needed if the
opcode does buffer selection, which isnt support for sendzc, sendmsg_zc,
or sendmsg. Just remove them - they don't do any harm, but it is a bit
confusing when reading the code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d69f2afa4f7a..4e075f83b86b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -571,7 +571,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1505,7 +1505,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1575,7 +1575,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-- 
2.50.1


