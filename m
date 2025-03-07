Return-Path: <io-uring+bounces-7005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C9DA56D78
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E38917033D
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987FD23A9A5;
	Fri,  7 Mar 2025 16:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mDKhVxvZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2302238179
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364522; cv=none; b=PhAiRUStOLel1vgMHWYu8rgKvjbWiQT9n15qmjqbLW7dt4gAmCdstWyYc9cR643TTZ7TyiK/tKbCGdhY9telqC7H9X3ePu5q0ubt/6KFD+kWGm6NVY+2g4h/NPUGsNQygw1N7quaQUZ/Mpar2DjtvDCU7oD9JKZDcsHDLyQ1W/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364522; c=relaxed/simple;
	bh=ekUvtFH/SfQXgIHgfIYiXK40M2zqG/dda6QIuokadQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMGpRYk8iw3OtbPXflGMOXKCdmZYg9JT3qql+/q0JT8Mxramx/xTZBDevoD8PNxMxncZ8U7JpivjFtFQfYZZhrGVej1eGiqWaTwKqZGri7aDgc2BoUYjZTSx2HBFue5p6ROQO1qMnWRMhv4n66dPUTO3IcmSigHr+Sm7HFqu9QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mDKhVxvZ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abf48293ad0so324388066b.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 08:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741364519; x=1741969319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rwjHxuGNfHhbmaESXrubOfAJtb+l3BJVFh0Fi9idhfo=;
        b=mDKhVxvZaoERSt3r0qD09i7dOns/P+jWTkkD95KEmEDY2WeoqzlLYFb0bwl0vBGHmN
         B97Br601Ja4MLAO901XKItn3lMGtYOW2tjRKpeWx5+t0baLwt7hCR5pGWlvXg838U01w
         S7/TT/NYxJYIUW4pZFjzX+i/wKlEwL+PIs6Ccn+VAbZbY5IsJ9RgVJx3jaKuss5HCUpL
         7Mep4+gBdJTD+j2DJm0mE6QhrGuhHQWMfiw1J/74+vMPrPMf6GjVIjvEE4ZXX1mYcarW
         jGfNL1cCoYt1LKyh6aCIZMqKMpB9DxKqHqPEBUSm2SuWXg+x59Am0VK2idGSJjcrBa+Z
         k/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364519; x=1741969319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rwjHxuGNfHhbmaESXrubOfAJtb+l3BJVFh0Fi9idhfo=;
        b=uqZYerOh44F8LIGdrTYmWBCRDXHHuIBl1kplv+BxI8I4GW2J0QReSZL7nlVV5AykkZ
         IEQRv9UzOlOI75Wxq+N/6SepC4clpZjzMzIu9dPHZ4bpmx7w6spvjRYXmen+ScjCtyrf
         1k528+54P1ymX9Mipa8TpPaV4fbDYi/XHLiiek2xLqU5GKoVudKrZiAKlapOmk5cxbSq
         XZemJbltTBWdETnlIe8cuZ32UH4gwi8Zc663j2IS89zzX4rqRWIFjgGm0Qkhu3J2dWXT
         QdzVv29agX8Jtz4F0/4vVYCXaro7Q66UFYJyUJ/DoyF3Mk3xXL5hzM9DewWMyBcgi3zb
         Lh0g==
X-Gm-Message-State: AOJu0YwQnqZ5dJvhB/6FagGI4aV3vQOhv5yTT0gao3xNqWQI07ztEXAy
	kwdILkQER1oV95ku6DhRGSG/LXsBDm7owctmv5vH/qMMqIuttR1Zr/GwCA==
X-Gm-Gg: ASbGncuPLHigeTCuJfsD2easC+TNfTrxiB5LoFx0BouUponiJ3l7Jnu1+F8E+i/GNXN
	/LJp5obE0LCNCR9DPKc50T2CPlYDkyQxSsoZFCFV3IJXPi8NozJsctZjfj3fHcrRoehWsOqRRpW
	euw7mblI727E8pym/SMs4OlYtxWNMsIwpE/S1iCcVwiZM1RhzFyW760gUtLI37lok3rFOTYtapp
	8nxQIh2Ew8r88pnbc2FOpxZ6VtjmsA3n8Zqq+1LbzoooVDCfdk+zQezjQVOXKk+vAnr24NxXN/8
	7ze6uzNVo9yCDbVIgnpTCdiGL7jJ
X-Google-Smtp-Source: AGHT+IG2COW4QwB1M301Y84BZByda+Ytc1fDRR3LsYgvr9WuNV+H5xXltgnHTi1rx6O+ztGmrjZ6QQ==
X-Received: by 2002:a17:907:3e23:b0:ac0:527c:9cd5 with SMTP id a640c23a62f3a-ac252fa204fmr383013066b.42.1741364518334;
        Fri, 07 Mar 2025 08:21:58 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac239438955sm300566166b.19.2025.03.07.08.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:21:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/4] test/sendzc: test registered vectored buffers
Date: Fri,  7 Mar 2025 16:22:44 +0000
Message-ID: <d56231867c95e9f9cc54981db6b636a70047571d.1741364284.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741364284.git.asml.silence@gmail.com>
References: <cover.1741364284.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index c8eafe28..680481a0 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -69,6 +69,7 @@ static size_t page_sz;
 static char *tx_buffer, *rx_buffer;
 static struct iovec buffers_iov[__BUF_NR];
 
+static bool has_regvec;
 static bool has_sendzc;
 static bool has_sendmsg;
 static bool hit_enomem;
@@ -96,6 +97,7 @@ static int probe_zc_support(void)
 
 	has_sendzc = p->ops_len > IORING_OP_SEND_ZC;
 	has_sendmsg = p->ops_len > IORING_OP_SENDMSG_ZC;
+	has_regvec = p->ops_len > IORING_OP_READV_FIXED;
 	io_uring_queue_exit(&ring);
 	free(p);
 	return 0;
@@ -448,6 +450,11 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			else
 				io_uring_prep_sendmsg(sqe, sock_client, &msghdr[i], msg_flags);
 
+			if (real_fixed_buf) {
+				sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+				sqe->buf_index = conf->buf_index;
+			}
+
 			if (!conf->iovec) {
 				io = &iov[i];
 				iov_len = 1;
@@ -619,7 +626,11 @@ static int test_inet_send(struct io_uring *ring)
 			conf.tcp = tcp;
 			regbuf = conf.mix_register || conf.fixed_buf;
 
-			if (conf.iovec && (!conf.use_sendmsg || regbuf || conf.cork))
+			if (!tcp && conf.long_iovec)
+				continue;
+			if (conf.use_sendmsg && regbuf && !has_regvec)
+				continue;
+			if (conf.iovec && (!conf.use_sendmsg || conf.cork))
 				continue;
 			if (!conf.zc) {
 				if (regbuf)
@@ -637,7 +648,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (!client_connect && conf.addr == NULL)
 				continue;
-			if (conf.use_sendmsg && (regbuf || !has_sendmsg))
+			if (conf.use_sendmsg && !has_sendmsg)
 				continue;
 			if (msg_zc_set && !conf.zc)
 				continue;
-- 
2.48.1


