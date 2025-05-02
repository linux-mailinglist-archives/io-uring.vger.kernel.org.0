Return-Path: <io-uring+bounces-7820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3CEAA77C5
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:53:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CD114E44CF
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AD0267B7D;
	Fri,  2 May 2025 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWswTun3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD425267B86
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746204786; cv=none; b=iMbhA2ioeO4cSZrSZAA5sMj0L1uBx4q63QA7td1okICfJ7tS/U3+CH/WnMr7okdDjRZBVH7zp2o4FqhW1KNt+jNpZ1X1jWBvL8Eu4qYOP2CD8r4ZkP4mC9H1zkYqPYfxvziODP6QPfdku1Xb0ErcWb0n90fPv9BwbDwX1LvPFzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746204786; c=relaxed/simple;
	bh=F49ISGofJF85HFx+HwwnrCpQzxQfdtS6hiU/pzUV+Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFIvMBST9z6eaq16Bw9ZnWTc+aCGrQuox2e1W9UH0SloyFkWY2WP3jesQiv0e4t8iygpTzkTS1I53btaERV727O1ZRuLG4quEEvJdYnHA6j9e9dGcjBPGVsIZxXWLJblMBSpGuDUZrV9d8IlSOYl9A1SlNu4hM7ne0WwVyZjHdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NWswTun3; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39ee682e0ddso1401813f8f.1
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 09:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746204782; x=1746809582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmDO2Bz4/uDV5I3K2aQxvv21a3+zV+31akwV8Qjk5AM=;
        b=NWswTun3S5VQpe/jRDMmQYMItruCmXry4w97+0PYKS2qYp3zD6Ac6fY+cPHEytCUfk
         EJRuSOiENt93q0cv8khNuAiaWYLPzcl/1J2GNbBU2V8jhhPUHwdzpswY4Uacsq2p7UkD
         MB8niuLDB2H47D4afxwGOVq5t1c2DSgxHd31/3kKZHIzgftShsnfw3bJrSoVhYED3q+2
         biKOUCWlIve+vk7WhOYBVZEynUMfsEdgpqa1cirT83yas6deaqZdI8BlpP5AmcrirXMR
         KdaSNT516+lKiZZAUVeQbsodvHuVw7VQcKLnqOYS1f282A/Hj/+PlODbF6v9bYDY4QKa
         dDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746204782; x=1746809582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MmDO2Bz4/uDV5I3K2aQxvv21a3+zV+31akwV8Qjk5AM=;
        b=B0AKRjq5IVoKBhfWoiIJMwNqerV+jx3kU5TP4UwC7zcmCGeFmNhmQK8VoJ1Eaf3mIe
         jSpG2xe2aVWDLtk48wiQ7dbS9XwAF8py7m5nub31T9RTpY4fh2XVqBmIW69B2C5tBu5f
         LZFM9LTXJsIfcsqLjPy6/e3aR2DMdoQs3MIBgZtV+CT0jDGFsFfQ+YJcrACmjW36/PAJ
         as+Rjgt/Bsl7RVBKZtL06XxQLrYLaiX69F32LVzebIs/K4KuRF4jfnA6edxatvYxBO1d
         kgAOoIyk4d70RCX3ndaOTVQlP/fqCzbAwsVHfPnCGjY2tMK0UImBilkElCi72SThITk0
         stPg==
X-Gm-Message-State: AOJu0YzBnRc3XmVNmM61L6uVFuXIYjAjVYQdYx1ubr4Xv3SXvnydwAH4
	VDGKaMBqd4aPRVlD+gbJ8Pedpm9OeEU+VfDyRXHFMl9iQhiTioL5hvxplA==
X-Gm-Gg: ASbGncuZonfbv5iwYm95MXswjp6giOBbGLlY+rgDLmsDo7bIR9E8ytiBGVpWAu1OHky
	Sah7K8tE/dh2qhWCZIw5EVdhSHOpm2FZTO8McYhcVJpMl3PtxaZ9Y74+EcTiVkSNByGdWYs3eQx
	IAfdMCSK2wNdyYFq0DdmtnRJYanQ/4hG7kdfKXPRDnNSSpROm3jBiUeMfmKhg/N5BnOpzaQ/Owh
	ZokcRmBqqBin4LQqjr+Z6JbktytGBuvsSyyn4hFSaP7ibI2Mqbc3sJIuY0mUCRgqJjcWw91ZxS4
	wzmgvRiv3WFAVwYH7RRxKfsADzzh8lpIqiww5wblJ4b35pUWouROGvs=
X-Google-Smtp-Source: AGHT+IEiF++Rccq2b9wIHz0DTq6FP4YH1ecYCERDvTkjsCs4sjZR8NaPzQWBxN/kpUkS7wQiK1UXtw==
X-Received: by 2002:a05:6000:420c:b0:39c:1257:c96f with SMTP id ffacd0b85a97d-3a099af37dbmr2692655f8f.59.1746204782298;
        Fri, 02 May 2025 09:53:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm2586013f8f.72.2025.05.02.09.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 09:53:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 2/5] examples/send-zc: option to bind socket to device
Date: Fri,  2 May 2025 17:53:59 +0100
Message-ID: <67b6be6a4aea6d47e00aa9fc9a959bf20ad5bf2b.1746204705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746204705.git.asml.silence@gmail.com>
References: <cover.1746204705.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let the user to specify the interface for tx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index c83ef4d9..b4721672 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -68,6 +68,7 @@ static bool cfg_defer_taskrun = 0;
 static int  cfg_cpu = -1;
 static bool cfg_rx = 0;
 static unsigned  cfg_nr_threads = 1;
+static const char *cfg_ifname;
 
 static int  cfg_family		= PF_UNSPEC;
 static int  cfg_type		= 0;
@@ -343,6 +344,16 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 	if (fd == -1)
 		t_error(1, errno, "socket t");
 
+	if (cfg_ifname) {
+		struct ifreq ifr;
+
+		memset(&ifr, 0, sizeof(ifr));
+		snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), cfg_ifname);
+
+		if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, &ifr, sizeof(ifr)) < 0)
+			t_error(1, errno, "Binding to device failed\n");
+	}
+
 	if (connect(fd, (void *)&td->dst_addr, cfg_alen))
 		t_error(1, errno, "connect, idx %i", td->idx);
 
@@ -516,7 +527,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:Ry")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:I:b:l:dC:T:Ry")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -530,6 +541,9 @@ static void parse_opts(int argc, char **argv)
 			cfg_family = PF_INET6;
 			cfg_alen = sizeof(struct sockaddr_in6);
 			break;
+		case 'I':
+			cfg_ifname = optarg;
+			break;
 		case 'D':
 			daddr = optarg;
 			break;
@@ -588,6 +602,8 @@ static void parse_opts(int argc, char **argv)
 		t_error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
 	if (!cfg_nr_reqs)
 		t_error(1, 0, "-n: submit batch can't be zero");
+	if (cfg_ifname && cfg_rx)
+		t_error(1, 0, "Interface can only be specified for tx");
 	if (cfg_nr_reqs > 1 && cfg_type == SOCK_STREAM)
 		printf("warning: submit batching >1 with TCP sockets will cause data reordering");
 
-- 
2.48.1


