Return-Path: <io-uring+bounces-7592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB47A94D12
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 09:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5179170594
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 07:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A760120E00C;
	Mon, 21 Apr 2025 07:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3Rd53b5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14E920CCC9
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745220272; cv=none; b=t8zfnMIWVTOkkETUVhsEcqtJ3sc6qo+Td7lMZ5AnF2JGJq2qvSEI8xvRw31i7VpN1HWQTXhpTs5Kr01No3jF8qUgc7Y5GVX5894gj4p4hSeQy6pVfT7sv6dmmgwK9wC0drkaNqjn+1/YZFds9uIIXGvrso8KRSWaqBQL88KdyQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745220272; c=relaxed/simple;
	bh=YnK3sovi5lWGgPd7Udet3N32bYwqenorofxycyJN1eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ner3+kV3IMwkzcbWaaBTKLeIdysgETEVnQATVKM6HSEJRC6FWko1wIPbO8PXKO3+LGeUm2kdFcOWIo8sy8ydxcpdWDT27BlqNwDj+j/moMBe16/D7qRr1EOfpmiQtTJbS+cuNya5mwhI5jdud/159lHj4A7NNFcuIvEadGPZ2T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3Rd53b5; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5f62d3ed994so4065467a12.2
        for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745220269; x=1745825069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TdVcR9rHe8HlgSUoNOWmuUc4BxwMtg2e8JOLTUt2wng=;
        b=P3Rd53b5C4rzbo2jkThOuPFmHx5jn8MWA87kkXKQwoi/fTyR87KeX5vKUr8YuXJYAI
         FEK6UlT7FDgI8IXPKW60dYnNO6D2qCdEEeUPpeH9jm60K4ICyrV/LTy1o6ytwrOJhv3X
         5CV4NbbCbXkc272cP2cVpTPyDokUl0ao3sz48HrzzQuiTaSfBMRBv29aqRK6+Ct3RKZ+
         tFSKzjcaxeMWItoTkUi9COSt00fL41zRwRHChMgKPGQjqKc7tY/M88OgfZdfhtKhyuLM
         XjNn1SXbjPGaT3sOxo7PgXc0SdhPx0eA0MbSc7+CgjXjiteVrBxrlLekTQ12hta3ZiCX
         lB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745220269; x=1745825069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TdVcR9rHe8HlgSUoNOWmuUc4BxwMtg2e8JOLTUt2wng=;
        b=vQPUgQm0B0QeJ2wOUMDbu1o+OqJfLekb+Z8b4oS2SAx4eDKzAEWaLciDWT5daitAL8
         hIM3tyMHAm8BGoAjLq9gM43m2t97tVKsnUQlpqfw81XyZtwiZ51dWnTN3joPIMGdlmRy
         TUODe7Hc8rXZlNc11VIHu8l0FlfGbw6n1ybjQ/SRcsPNqcyaGWlAtdnDJwMz2gbNpdeO
         TH0pw1vtNLOh/RWLi/K1wi7h09jeQ371T1C2qbTTylYitIKX0tAgHqImustGT29N/i93
         lW+Cg2lDN88Mofm9Yvftr2HhlLAhTf3ucwbdVGz/Q8pkPmnoCvC3oDZg3TYCAUf9is5q
         6qRQ==
X-Gm-Message-State: AOJu0Yws0W/XCEX5NlorDpuYTkLYNSAXWcLhAK2s6DKoOTa//mqs8Ade
	LjCv4M1jh8YV6bnSIsFJjZdj0QYoMO2LYj3Kqop8sK3XiZS6K85T85BJnw==
X-Gm-Gg: ASbGncvFF75s008ASfT9rc1UHmIIAKRkHeh3pjGXJx3vdSePL/opisXkRNDUM0NshZU
	6sTyDeRfGqZokvSxuX7pu52B2296Vxr1ac9KGCwr9KBx+o1fVS3CeUyOe5hXt6zKX8eH+0+ihBG
	E1iQ8tDtPcXTp2Ewm8QMEZ5K+0CYUNmQl/ehgHrjv90DyswwEglxTH/y1DwvGceh20V6pGPIG9L
	EetfYiiC6IPUadWbsL0w5ZRtI/g8+37gSs6EAuTbs91/HwqmYc0zHY7f17QWIk2HIA/X0kqadHY
	cMaP3wHWSVzKP+dTbItp12KCvNDX1EnwbZa+9gy0oFz3sdxAEmuACg==
X-Google-Smtp-Source: AGHT+IHGYcuol5GMzFgqthuEkvn8dIoHkxN+FCdc/UHskfjdNzQqU1/gPkchKziCqpvJ34swTSx2oA==
X-Received: by 2002:a05:6402:5193:b0:5dc:c943:7b6 with SMTP id 4fb4d7f45d1cf-5f628219f12mr10302164a12.3.1745220268565;
        Mon, 21 Apr 2025 00:24:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f625a5ec5bsm4175562a12.81.2025.04.21.00.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 00:24:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing v2 2/4] examples/zcrx: rework size limiting
Date: Mon, 21 Apr 2025 08:25:30 +0100
Message-ID: <236d055a6864ba1dc57f62727be36ca985da9e4e.1745220124.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745220124.git.asml.silence@gmail.com>
References: <cover.1745220124.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx doesn't work in a single shot mode, we can limit the number of
bytes it processes but not the number of cqes. Replace cfg_oneshot with
total byte size limiting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 727943c4..5b06bb4c 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -46,9 +46,8 @@ static long page_size;
 static int cfg_port = 8000;
 static const char *cfg_ifname;
 static int cfg_queue_id = -1;
-static bool cfg_oneshot;
-static int cfg_oneshot_recvs;
 static bool cfg_verify_data = false;
+static size_t cfg_size = 0;
 static struct sockaddr_in6 cfg_addr;
 
 static void *area_ptr;
@@ -158,7 +157,7 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 		t_error(1, 0, "Unexpected second connection");
 
 	connfd = cqe->res;
-	add_recvzc(ring, connfd, cfg_oneshot ? page_size : 0);
+	add_recvzc(ring, connfd, cfg_size);
 }
 
 static void verify_data(char *data, size_t size, unsigned long seq)
@@ -176,7 +175,8 @@ static void verify_data(char *data, size_t size, unsigned long seq)
 	}
 }
 
-static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
+static void process_recvzc(struct io_uring __attribute__((unused)) *ring,
+			   struct io_uring_cqe *cqe)
 {
 	unsigned rq_mask = rq_ring.ring_entries - 1;
 	struct io_uring_zcrx_cqe *rcqe;
@@ -184,22 +184,16 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 	uint64_t mask;
 	char *data;
 
-	if (cqe->res < 0)
-		t_error(1, 0, "recvzc(): %d", cqe->res);
-
-	if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs == 0) {
+	if (!(cqe->flags & IORING_CQE_F_MORE)) {
+		if (!cfg_size || cqe->res != 0)
+			t_error(1, 0, "invalid final recvzc ret %i", cqe->res);
+		if (received != cfg_size)
+			t_error(1, 0, "total receive size mismatch %lu / %lu",
+				received, cfg_size);
 		stop = true;
-		return;
-	}
-
-	if (cfg_oneshot) {
-		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
-			add_recvzc(ring, connfd, page_size);
-			cfg_oneshot_recvs--;
-		}
-	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
-		add_recvzc(ring, connfd, 0);
 	}
+	if (cqe->res < 0)
+		t_error(1, 0, "recvzc(): %d", cqe->res);
 
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 	mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
@@ -286,7 +280,7 @@ static void parse_opts(int argc, char **argv)
 	if (argc <= 1)
 		usage(argv[0]);
 
-	while ((c = getopt(argc, argv, "vp:i:q:o:")) != -1) {
+	while ((c = getopt(argc, argv, "vp:i:q:s:")) != -1) {
 		switch (c) {
 		case 'p':
 			cfg_port = strtoul(optarg, NULL, 0);
@@ -294,11 +288,9 @@ static void parse_opts(int argc, char **argv)
 		case 'i':
 			cfg_ifname = optarg;
 			break;
-		case 'o': {
-			cfg_oneshot = true;
-			cfg_oneshot_recvs = strtoul(optarg, NULL, 0);
+		case 's':
+			cfg_size = strtoul(optarg, NULL, 0);
 			break;
-		}
 		case 'q':
 			cfg_queue_id = strtoul(optarg, NULL, 0);
 			break;
-- 
2.48.1


