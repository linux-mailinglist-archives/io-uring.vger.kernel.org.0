Return-Path: <io-uring+bounces-237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFF3805886
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB83E1C210DB
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE4068E9C;
	Tue,  5 Dec 2023 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mT7pK6SI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304DD19B1
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 07:24:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-54c7744a93fso4389409a12.2
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 07:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701789846; x=1702394646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tC4ZuU4FwCpLW3ILkOiQ3z01qz2B/fhVJo40MJ+SuLw=;
        b=mT7pK6SIZVrrwSv13Iyko3BWIODHlaeGQQCQ5w+ILHYY1MOKY53fZ6JpJlPx7PBX5Q
         JEB4PRLmIXuSfhlfSSaL0aum5YS28CE7hVITMPCjZXj+Te+AQDnTVto3hPlS1GzeH5Om
         O6N6iZnt+saRVwMBzj9TkeokjERxL1VWcbWWtZRUvxDAWcDNgmqb5+laDZ8mRwEp1Fon
         7BzbfIepUDoZzkrbtMga7h2+VbcRUqR7iizyB/ULyoGqnb53PFYM1ua2q8Co7LmfCL+S
         7o3F97H22LADvM9DKQKnOsISByTPUn5zGS2tHRcttan5QkksW2BxNH07QNT2zcLJTsad
         2+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701789846; x=1702394646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tC4ZuU4FwCpLW3ILkOiQ3z01qz2B/fhVJo40MJ+SuLw=;
        b=Rw5r03Je9yhenk6ygSnj2szzuu6Gn7NrNHrB9dPynNkuYh1tNisme88SHGqYDZD3G2
         2VIdReXGQiSsZxMx56PJMcC8T773eiw+brE9Nw667RbbJQxWuTMU01gQ7Ic+jJA+KYJc
         hl/gcojAJgPGVLVT+tw5KVz2hsvBsSDPYqBjm4H0FWKTxQMTOOCKurQXGdqplroAKFdi
         SCPi+NOG/Iyuan1L84R5+KzaiSnSb3EVy67BSoQ92y+CxqqSMNkns0BwgQBVJ+Z+3+9o
         RnLRzYUZ7zki4IEIGHbRmSirylt7oyAyQSxPSWvuZGfeHJAObaT/rJN7tXNxq/WyjAKf
         k4oA==
X-Gm-Message-State: AOJu0YzQw/HZYbEVqrAilIAo57TcozN/e68J5/FfTR1mL92h6LKJ+TGZ
	CyzGq9tG1TzmuA1JbJ3vrBMbfy0qlB4=
X-Google-Smtp-Source: AGHT+IFM4n5eIPpHlsOxA4LI/s7NoAhTdYEQb4JrKnzIX1p3/ZEgxiwtMMd+r44lUM/Uh+jBhQ5nqw==
X-Received: by 2002:a50:9344:0:b0:54a:f1db:c2b3 with SMTP id n4-20020a509344000000b0054af1dbc2b3mr4354916eda.0.1701789846094;
        Tue, 05 Dec 2023 07:24:06 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:ebcf])
        by smtp.gmail.com with ESMTPSA id s24-20020aa7d798000000b0054c9211021csm1221591edq.69.2023.12.05.07.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:24:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 5/5] examples/sendzc: improve help message
Date: Tue,  5 Dec 2023 15:22:24 +0000
Message-ID: <ad98aebae94800b9d749bc82e6ceee04511e2c0b.1701789563.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701789563.git.asml.silence@gmail.com>
References: <cover.1701789563.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 84d2323..d7eb46a 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -452,7 +452,6 @@ out_fail:
 	io_uring_queue_exit(&ring);
 }
 
-
 static void *do_test(void *arg)
 {
 	struct thread_data *td = arg;
@@ -467,8 +466,24 @@ static void *do_test(void *arg)
 
 static void usage(const char *filepath)
 {
-	t_error(1, 0, "Usage: %s [-n<N>] [-z<val>] [-s<payload size>] "
-		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);
+	printf("Usage:\t%s <protocol> <ip-version> -D<addr> [options]\n", filepath);
+	printf("\t%s <protocol> <ip-version> -R [options]\n\n", filepath);
+
+	printf("  -4\t\tUse IPv4\n");
+	printf("  -6\t\tUse IPv4\n");
+	printf("  -D <address>\tDestination address\n");
+	printf("  -p <port>\tServer port to listen on/connect to\n");
+	printf("  -s <size>\tBytes per request\n");
+	printf("  -s <size>\tBytes per request\n");
+	printf("  -n <nr>\tNumber of parallel requests\n");
+	printf("  -z <mode>\tZerocopy mode, 0 to disable, enabled otherwise\n");
+	printf("  -b <mode>\tUse registered buffers\n");
+	printf("  -l <mode>\tUse huge pages\n");
+	printf("  -d\t\tUse defer taskrun\n");
+	printf("  -C <cpu>\tPin to the specified CPU\n");
+	printf("  -T <nr>\tNumber of threads to use for sending\n");
+	printf("  -R\t\tPlay the server role\n");
+	printf("  -t <seconds>\tTime in seconds\n");
 }
 
 static void parse_opts(int argc, char **argv)
@@ -480,8 +495,10 @@ static void parse_opts(int argc, char **argv)
 	int c;
 	char *daddr = NULL;
 
-	if (argc <= 1)
+	if (argc <= 1) {
 		usage(argv[0]);
+		exit(0);
+	}
 
 	cfg_payload_len = max_payload_len;
 
-- 
2.43.0


