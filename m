Return-Path: <io-uring+bounces-3676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E33899D897
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 22:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4FA4B21CD8
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 20:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397D81D172B;
	Mon, 14 Oct 2024 20:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mDs5rEHC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA94A1D07B8
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 20:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728939270; cv=none; b=kIe1296s0xn9yeDmGlRybt/LleXyNo/dR2+t82k+MqNCbOmfRIpn5uu7slPlJFOwtivZd4TXHQP5IIsnXwxRCB9DQ7ZUu5mnwF0JpNK3irsne2/sS0LOtPoI6wxtAByPbjqQAewOJ1DutOVhr7GkmyWGp5JW7tJ+Ts/OgrFJAD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728939270; c=relaxed/simple;
	bh=ODSbDyCmnWf2+n/n5tqJDeqWl2buYBZm5bsrlsObWwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOGnwI0s9ZpgJhu4GQNnLQlNSj+k1a4w01EcUIGP14KxdGRfQxCHKp2chbkmZ/VP/ZV2Vd2BERe2DzbKZkC4xAAx7nh7HtwsnD5yWEGwZ4hVJ9zldu0skxsxabzowuNU4jRoJSbxUZuutJwFw2k29rcf/WVPyjIZBqL/+DI9wEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mDs5rEHC; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a3a5cd2a3bso26693105ab.3
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728939266; x=1729544066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EusEAECScs7P5s7DtUS2E5FvEVP9+InNt62nDGrPub0=;
        b=mDs5rEHCcjb3F929VjOuvhysXqYcHU8F171g0ThcZcMR+yz6rRSFA30rciIiK4Yhhy
         TnDvzhsm9sWHlOSO7ilqHcFk89zlLzmaLZE1DBbrZGU1+/3n6iE7MNBXW+iLoUqV8ani
         3SEoFWBCFwFBY14Wb4PwyvaR0nSXtcLfvEEPpMcrk7Pc9Aw5HfHpSTc15zgvzu6ZH1+M
         m4CHEjYd+uhwfawHfnYDYFQ/oXebn4swJmDFkrGzFfM5eibZXBicc8ZaCDM2dlWcgusl
         MI5I1PScAN+LFXwAhDtNsGX3AJIWBsWzdCCF748eOkXCK3UR0lm2x05ZE8qzdAWjnVH3
         wobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728939266; x=1729544066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EusEAECScs7P5s7DtUS2E5FvEVP9+InNt62nDGrPub0=;
        b=dNpHlpPWEFVkOjiWmua1qWijqgC6XSI6BjLLwbFrObHrM8w0k/yTtKxUa5h71BuNSr
         iAVQav4uesCAdXLduEhbBD78lwpKaqAxPjWjxwyH94a8ERnMr0ARyX+3qEkIuRlJ0agj
         4CVHSuCkZDXNXCevVbySj8Tbc272+JPykbwrMe+7EFhpOClp/bSwWPgww+ZYCqgJFLdu
         //0qoyRe46x6FUCGMK0GRpFaOdE/ZiLUH8Rzi5X+3Bd6Du6wL+89/mI3FiA0eatIYHsR
         KU5LZg3BAWB1y4fIiTXTTU+VhndyVFxRYbTQzAcjaXHvFTxKZizKAtAEE4krbtoNDubf
         utSw==
X-Gm-Message-State: AOJu0YwGpAIqV/rullmKmc/6JRAHUBMZNCP/LYSNQNjE9Bhq+ggY7j4h
	0c0VGk0GAYkWMmtvhNraaR/675+3AQfAyleCFWS+fzyI6nxO9lSftiboEeW1AIAuMZqanO7bFVL
	G
X-Google-Smtp-Source: AGHT+IH3Nesm57A05j40aHouwcgTf3EsWBk/ILh63b2xj9GgyOif5rjhnLlHGVucFjzugDtz+/GIXw==
X-Received: by 2002:a92:c544:0:b0:3a0:4e2b:9ab9 with SMTP id e9e14a558f8ab-3a3b5f7a9b9mr100211895ab.5.1728939266509;
        Mon, 14 Oct 2024 13:54:26 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afdb3629sm62644895ab.21.2024.10.14.13.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 13:54:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: add IORING_SEND_IGNORE_INLINE support to zerocopy send
Date: Mon, 14 Oct 2024 14:49:48 -0600
Message-ID: <20241014205416.456078-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014205416.456078-1-axboe@kernel.dk>
References: <20241014205416.456078-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If IORING_SEND_IGNORE_INLINE is set for a send zerocopy request, then a
successful inline completion of such a request will be ignored for a
submit_and_wait() type of submissions. In other words, if an application
submits a send for socketA with a recv for socketB, it can now do:

io_uring_submit_and_wait(ring, 1);

and have the inline send completion be ignored from the number of items
to wait for. Note that this only applies to the direct zerocopy send
completion, it does not include the notification when it's safe to reuse
the buffer. Those happen out-of-line anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 11ff58a5c145..79f980182a10 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1223,7 +1223,8 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 }
 
 #define IO_ZC_FLAGS_COMMON (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF)
-#define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE)
+#define IO_ZC_FLAGS_VALID  (IO_ZC_FLAGS_COMMON | IORING_SEND_ZC_REPORT_USAGE | \
+				IORING_SEND_IGNORE_INLINE)
 
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -1259,6 +1260,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			nd->zc_used = false;
 			nd->zc_copied = false;
 		}
+		if (zc->flags & IORING_SEND_IGNORE_INLINE)
+			req->flags |= REQ_F_IGNORE_INLINE;
 	}
 
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
@@ -1406,6 +1409,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_sendmsg(sock, &kmsg->msg);
 
 	if (unlikely(ret < min_ret)) {
+		req->flags &= ~REQ_F_IGNORE_INLINE;
+
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 
-- 
2.45.2


