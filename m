Return-Path: <io-uring+bounces-1446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A21F689B4EA
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 02:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30B09B20DCB
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 00:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C26B1851;
	Mon,  8 Apr 2024 00:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3gKlUt2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2681860
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 00:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712535251; cv=none; b=Xw/cpuJGDaTU1SwUPAZEo+K6Www3sRl4qKBQSi2LcQRAf8Wtu5hSw3Gx1BPV5JC+/MjJt0d03JDCKIpMKvb1a2nj/vQKwtv5MLGaBzGyGoLD/YimtGMYUS43YVChtncdE9wFPhePJqL402JYm38dgkQepPyggppIYCyeAtNyJQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712535251; c=relaxed/simple;
	bh=YtqqXokpqAHvaPXzAGr1DtJYL51HqKhV8BizoiRfBe0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G/70iv2ksxJd8bsoRUMN2bphe1Dj7q1cf1h49CaI8KGg9yuog2K92Nw9bNKrFSEuYaBNyErAfs/1zUBSh7g7BznFQkZIAk8VCvBfBMtkCVoxE8SEUsAWSb8Fkx29RNL1PC19aS/TXexvweXt6kbqh07xPN6X7lqNokrz5BRmM8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M3gKlUt2; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-345b857d7adso258707f8f.1
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 17:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712535247; x=1713140047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qiNy6VVSaVB2U7/NeTiq6zmuGXX6Z6QZnMSg99wZFWM=;
        b=M3gKlUt2jEDn5d2Uv7ObcBcT6GbIOimktzzwNq3rgcljF8IEt/Fytut7/HlQZtlxgr
         QK27MMrg8k90DYsHEPFacqgk0q/laJzPwKZuHbM8vdM7q7evWnhsA5gqk9YOinaLoz8u
         9PkzX/xGODd93QFz9P7tqBB26Te2GJEcu1GSvDiAXntuojIJ7NP3djpT2dNgYXodI3cj
         eKYDKuLx4NylferIO6wGVJA9U38T9H3CgZJgVouO8GOFT+00aAFBHBC4BXNhu5opcil/
         N2zckMUfLYca81G2X1BHO4Oj05x92Uo8VZxmUYAOSgCm26BFkDcFDFZauu6us77ktBeM
         nrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712535247; x=1713140047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiNy6VVSaVB2U7/NeTiq6zmuGXX6Z6QZnMSg99wZFWM=;
        b=mz0yFmw8GMaOylOosukCAYnZmafFzlRw5be2uyFyg3xrXopbFSd8kdK1VChiWmcTGt
         n8FlK4RPQC6+ULKPHaAGueG8Mhf+qB8ovS7vOYpWtd6Hgrm//12DUAKFYpoLEFd7EAPD
         gMKoNFyENHm8PTCxYpGxPeT3NP+XdZfbwfmqaqIsDS7T6xFj4woBIMkSmtDo51h4EGyv
         cca0KOgnmbwE+EUZzzmxRK5aUaQdBUdQZqoru1Fi7Z0vrOU/J5E4VmALYfdRFUefg7N3
         WeZa3tGg9KFkagGwjaRSWrZtyK+uWB+wT5MhnTcxPfhv8u7VF7ow6LiSjH1PosvocA20
         nwVw==
X-Gm-Message-State: AOJu0YzJrawSL/8CJGVAOx8dj8U0DxcuFCnNvv7B6LIbco8VOrp6RvRa
	S6aM6ZOdY+EqjCOpNJsBZq3ydM7LdwUDfiKL03RsMwU7o2GBkEZ7m7DjrOWj
X-Google-Smtp-Source: AGHT+IF8+TFw6XAb48PQatYc6k8Vib9VjpxNWt+nAVshNKOI68nAAzKFuIS/TpynW3V5c03PtDmRlg==
X-Received: by 2002:a05:6000:1e81:b0:343:b1a4:eeeb with SMTP id dd1-20020a0560001e8100b00343b1a4eeebmr5173532wrb.0.1712535247488;
        Sun, 07 Apr 2024 17:14:07 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id n6-20020a5d6606000000b0033e745b8bcfsm7600548wru.88.2024.04.07.17.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 17:14:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/1] examples/sendzc: test background polling
Date: Mon,  8 Apr 2024 01:14:00 +0100
Message-ID: <152a9e0773920d0affd675d1e75983271bcd6732.1712535205.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are some performance effects depending on whether the sock is
polled or not even when it never actually triggers. That applies to
non-zerocopy as well. Add a flag to test it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 7ab58d7..691a0cc 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -74,6 +74,7 @@ static int  cfg_type		= 0;
 static int  cfg_payload_len;
 static int  cfg_port		= 8000;
 static int  cfg_runtime_ms	= 4200;
+static bool cfg_rx_poll		= false;
 
 static socklen_t cfg_alen;
 static char *str_addr = NULL;
@@ -370,6 +371,17 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 	if (ret)
 		t_error(1, ret, "io_uring: buffer registration");
 
+	if (cfg_rx_poll) {
+		struct io_uring_sqe *sqe;
+
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_poll_add(sqe, fd, POLLIN);
+
+		ret = io_uring_submit(&ring);
+		if (ret != 1)
+			t_error(1, ret, "submit poll");
+	}
+
 	pthread_barrier_wait(&barrier);
 
 	tstart = gettimeofday_ms();
@@ -504,7 +516,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:R")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:Ry")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -556,6 +568,9 @@ static void parse_opts(int argc, char **argv)
 		case 'R':
 			cfg_rx = 1;
 			break;
+		case 'y':
+			cfg_rx_poll = 1;
+			break;
 		}
 	}
 
-- 
2.44.0


