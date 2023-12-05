Return-Path: <io-uring+bounces-234-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95638805883
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FD261F21810
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BAA68EA6;
	Tue,  5 Dec 2023 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXmIHF32"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FD910D3
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 07:24:06 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-54bfd4546fbso7121834a12.1
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 07:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701789844; x=1702394644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2QEtZM1ddOlob8bIMBELDAFyo8g74w6lP7y5ucd4Yz8=;
        b=iXmIHF32aGOyWyc4RMg63vM5l1+t2YDPmtvXxAlHobnPc817SVBAWv3jcP6bhcl53m
         unlYJqj3dyfM73h7sfmvLd9errVKHT1pt3FnaoRNprZY8+MMYvNJeHyKJ2pRMbouNYOD
         EJVoUQeTumWGZ4R2BOzkkhwxheOPSq+Anh6/QPol1d+xsZtOE9jumzxjY6NrPyUztPnQ
         rpBBDXU0IH5B3wReXvw6wZ3EUNc52GbDD3KNp0M/rAuDk98m/8DtxrbyWKtW3RvWPG4F
         rPr/810U05ZzgG41Qr81BYmJZrZVGESuvyacrqWWRoPbHJeCAMWpedarNLb6gUpuVOQp
         5JhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701789844; x=1702394644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2QEtZM1ddOlob8bIMBELDAFyo8g74w6lP7y5ucd4Yz8=;
        b=Hj/D7Nmt7ndhuov8WlUmzCK6BNfHtN2M4A7nSPL20KqyVxEcT6my9k4a9U1hMK3VuC
         1bgJkNjVTivUblmXKLBAmpUvzfheS8AHYM16/etUBsREed9HDBNIIm/OY4kk50xoF9WX
         yg9b170jPHDc4L+1RgVUsvfEesVtpFok0Y1Ysrl0txG/RyM0NC3fkA07Okdas9nQylGV
         9lsjObD3aqVRP7et4s94Wyjhm23EGU7fjoi1NcQLLEXOyVamJHTMBo5kd72rOQUTlW4y
         kkE0AHI55JdJCIkK78mLPJy5LtJTI7EUxldKSigrSfx0H/TThkXDdYWkGi32ADIxeuBu
         QRZQ==
X-Gm-Message-State: AOJu0YyrykQF3wHDh1bhlRkvjlOBAyoGnerYX5hBlA/Q2ZDYHM+IXcFT
	CVisjDujowbtFisiY0tPF+VZD0wylOA=
X-Google-Smtp-Source: AGHT+IECk9duWCK6ssEvu4Xn+aPbRY9N/O48x3TwjF5RnBijgVajr4mOCpU0D5K7dlgaXifTkntG6A==
X-Received: by 2002:a50:a404:0:b0:54c:6bce:375a with SMTP id u4-20020a50a404000000b0054c6bce375amr3680000edb.74.1701789844247;
        Tue, 05 Dec 2023 07:24:04 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:ebcf])
        by smtp.gmail.com with ESMTPSA id s24-20020aa7d798000000b0054c9211021csm1221591edq.69.2023.12.05.07.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:24:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 2/5] examples/sendzc: remove get time overhead
Date: Tue,  5 Dec 2023 15:22:21 +0000
Message-ID: <cd3e21635093662a4fdc579df047133fa50ccdf6.1701789563.git.asml.silence@gmail.com>
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

We call gettimeofday_ms() for each loop iteration, which annoyingly
adds ~2% of overhead. We don't want to see it there, it should only be
testing io_uring and the networking stack, so ammortise it to
nothingness.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 1f3b220..19cf961 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -52,6 +52,7 @@ struct thread_data {
 	int idx;
 	unsigned long long packets;
 	unsigned long long bytes;
+	unsigned long long dt_ms;
 	struct sockaddr_storage dst_addr;
 	int fd;
 };
@@ -315,10 +316,11 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 	const int notif_slack = 128;
 	struct io_uring ring;
 	struct iovec iov;
-	uint64_t tstop;
+	uint64_t tstart;
 	int i, fd, ret;
 	int compl_cqes = 0;
 	int ring_flags = IORING_SETUP_COOP_TASKRUN | IORING_SETUP_SINGLE_ISSUER;
+	unsigned loop = 0;
 
 	if (cfg_defer_taskrun)
 		ring_flags |= IORING_SETUP_DEFER_TASKRUN;
@@ -357,7 +359,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 
 	pthread_barrier_wait(&barrier);
 
-	tstop = gettimeofday_ms() + cfg_runtime_ms;
+	tstart = gettimeofday_ms();
 	do {
 		struct io_uring_sqe *sqe;
 		struct io_uring_cqe *cqe;
@@ -419,7 +421,9 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 			}
 			io_uring_cqe_seen(&ring, cqe);
 		}
-	} while (gettimeofday_ms() < tstop);
+	} while ((++loop % 16 != 0) || gettimeofday_ms() < tstart + cfg_runtime_ms);
+
+	td->dt_ms = gettimeofday_ms() - tstart;
 
 out_fail:
 	shutdown(fd, SHUT_RDWR);
@@ -536,6 +540,7 @@ static void parse_opts(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
+	unsigned long long tsum = 0;
 	unsigned long long packets = 0, bytes = 0;
 	struct thread_data *td;
 	const char *cfg_test;
@@ -586,13 +591,18 @@ int main(int argc, char **argv)
 		pthread_join(td->thread, &res);
 		packets += td->packets;
 		bytes += td->bytes;
+		tsum += td->dt_ms;
+	}
+	tsum = tsum / cfg_nr_threads;
+
+	if (!tsum) {
+		fprintf(stderr, "The run is too short, can't gather stats\n");
+	} else {
+		fprintf(stderr, "packets=%llu (MB=%llu), rps=%llu (MB/s=%llu)\n",
+			packets, bytes >> 20,
+			packets * 1000 / tsum,
+			(bytes >> 20) * 1000 / tsum);
 	}
-
-	fprintf(stderr, "packets=%llu (MB=%llu), rps=%llu (MB/s=%llu)\n",
-		packets, bytes >> 20,
-		packets / (cfg_runtime_ms / 1000),
-		(bytes >> 20) / (cfg_runtime_ms / 1000));
-
 	pthread_barrier_destroy(&barrier);
 	return 0;
 }
-- 
2.43.0


