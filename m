Return-Path: <io-uring+bounces-7806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38923AA633F
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 20:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0AA63B9357
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 18:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D035D223DF4;
	Thu,  1 May 2025 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIF+OMJ8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133C32236FC
	for <io-uring@vger.kernel.org>; Thu,  1 May 2025 18:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746125747; cv=none; b=kZDSXnVgtkZzkdYKh9s6rOnyVPNYqHnNbP+beaht3R0AeRPmVAHTEBJ+z98j1cnBz+y3wgroWjiwlz7QyClvmxaneACeiaOFJKeCOgDRQS3WJimPcId+vXKrg2fwV7lzyKYdFPqR598aKLpI6PgZKoSQBDlWuMuDexGskY1BDjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746125747; c=relaxed/simple;
	bh=F49ISGofJF85HFx+HwwnrCpQzxQfdtS6hiU/pzUV+Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWXxPl9oXv3bymlQYbNY5BMB+oSUw/QxjGT893ko5h2C0TS1D0HoPktm8h4n4jPdWG/0Js6IOnRD3Irf5e0BZNHbPV9759Biq4gEDQESZul8zF0g4+mhv6eaTgRnhoCGWCwN71wzTc/+HUHr67rFidrBtgIztm/eA0gbippiCzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIF+OMJ8; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ace98258d4dso167386666b.2
        for <io-uring@vger.kernel.org>; Thu, 01 May 2025 11:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746125744; x=1746730544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmDO2Bz4/uDV5I3K2aQxvv21a3+zV+31akwV8Qjk5AM=;
        b=hIF+OMJ8Y2Q5Uc8JvXO1Tn4qnUHLPUCc6YyZbke8uUkMlAxjvDHR2FPfP31OPhzRB2
         QohrWKJiC7N07JrakzUn0cGWwqGTgKAphb/MFeuHdu1oJqMdkHbuxbQ9CHCYH+oHCVO7
         +LM2dwwdPiqYdZuCiDPPdhb/0+OnkL/LOedBkUuF3LMwWyqfRXUY2dG+P3Uq8CnJSgc7
         qu5e137zVr55SoF0rybDuT4zH09mVlsLINsJV+fXzDEtCfXIJSe6IKyaCzel7wexf6od
         A/Y8S5bFNQQEbEDhTOkpy08jdZVH508SIj2UyJOWqqKFa0OedTZqgFBzSqzovBEg7V6t
         obHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746125744; x=1746730544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MmDO2Bz4/uDV5I3K2aQxvv21a3+zV+31akwV8Qjk5AM=;
        b=f/AxvKPCIEvHxqReXUTFqe6TbyS4ug9TlURmx6I3hfZZjdd/TQHSNFeKgqjmiA+9Ge
         OfgKyXThjgZB9d8OwsG6ZN46lkH2cLED6sAMoUytlCcwJNAkxV77BK57Alm+cHNrYik2
         dnYiHUZx9rfVR/QshXqENR0IBngKCSFGAdXOqx4hjnDIisRcGLqA/vGyBgG9rUJIWUz9
         aoDuuD0r9S163TYuhkh8aO7SLPyNxpPgfw54GfS+1SHsAFXMoSN4jMwdeZRs5biMTybM
         VtcY25lUAvc6850sZDD5Jybj0eL4iV1R5R0wHGU0LjmSDOQ2o94WC0MdonYIVgFWVm5x
         /olg==
X-Gm-Message-State: AOJu0YxxrJk3OgUMgiI2kxex57nii69qWJybj7ZYZ/Tr0Eo3rknD7MYZ
	iXo0w+s6femEfDBLDolCa6Z9zrnErh6Mu24E3owN7txniuGK2OWVqHec8w==
X-Gm-Gg: ASbGncv8RM02YsY7UlWLP81EcyweC99lvDC3EXHATIKxWsE0fArPk8quZYtI2lB8QBB
	nwgJm3NAw1tj6Vf0/z/CKCicgzWkOANqlWdtHtOP/95sLt37971Yot903jVfjd2WDWZAAMttCBh
	Gy58pisQJWZOYWOT0EOg7Mx5LpNN9yAtwnGQIOvTJCt7a9Z34VI2BgcXBzvzfkWCB5pqQtdMsUG
	wuLu0tIsaGs3kGAxQy4VkjYBF1vXyYh8GR8vU4pFXeJl7FgJg+90sw1v1snH+/jUcnur6xUJh/g
	x6oppVPsKds9A7kZMBw1ITlta/oisxTsD8ai+5TxdmwEPuD1o/AJA2IlrGfwgHni
X-Google-Smtp-Source: AGHT+IHSbh0orMZ53Q+ouG4sfeZpVu6zOM9n6uirhqKHf6AHwmpQmvTWOjECv+zSEa9kNJ7Xa63AuA==
X-Received: by 2002:a17:907:a60a:b0:ace:9d3e:1502 with SMTP id a640c23a62f3a-ad17ad1a22fmr30281666b.4.1746125743785;
        Thu, 01 May 2025 11:55:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70d3955sm79059566b.7.2025.05.01.11.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:55:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 2/4] examples/send-zc: option to bind socket to device
Date: Thu,  1 May 2025 19:56:36 +0100
Message-ID: <67b6be6a4aea6d47e00aa9fc9a959bf20ad5bf2b.1746125619.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746125619.git.asml.silence@gmail.com>
References: <cover.1746125619.git.asml.silence@gmail.com>
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


