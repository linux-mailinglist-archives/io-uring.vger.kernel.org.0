Return-Path: <io-uring+bounces-6822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD6EA46C86
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 458563ADD10
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B668B1E1DE7;
	Wed, 26 Feb 2025 20:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGzMNATk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093E12755FD
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 20:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740602130; cv=none; b=TZU6FH9q2jJzR3fh+sRrsvwYG/e8iMq4Y+kqdV3RKmOuCRTIyyFeJj3ldzroP6Iuz5B2rHopI7MYbE8qc/r1yteKhV/QaNdFQ8e2/X3Ok1BPU+nQSIg28UcroBK89BXCSuLwqxi0U15CUjATyvfT0jDEi9bmWYjELdXbuz47Db4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740602130; c=relaxed/simple;
	bh=k+/mf0Ke/9caeU94urH6uJJzbl20lNFagF35hCU1yPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KBQglgg3QhkAvdd8D1jlnTTJZ6TM5ueIej9WTfNfoyzXl5DhBJD4OLg7Y4t7wgXNyFDLTdjt4V94ChCKuN2tSRFjIXyX4O+D4+8LNv6rPWSj6f1J6ZTs7BESQq3HTunI6xDIR8VguCIA61/I7wY8OljisRxPP/RSL6lIYIGoebY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGzMNATk; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab771575040so236636366b.1
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 12:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740602127; x=1741206927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tDxxqhrZdvdGgk4uAfOkfCZ1hI0TZ27DIS134xcwkxc=;
        b=cGzMNATkixPVhkszYu9fMT2QivbGXYzJmj2j6XLFg4IfJGsWhnUOXQsTcYyQNQq0L4
         vjK6+evBuk8SwEoImHe6D/NoGysxIYsn+e0T7r8GQVPm2xtgsKGZ4kDR3lYjpiPU2GXM
         MFVxRFWyZVFva06w6DPEIIXwlyL8G6j/QQlc+00BO5KoREyuyiKPqOcyjaWcvOYsE5GV
         Z8IWnX2b04HKpuqNFKctGIGagr4BoE0ZI3DOORxOlLSahO4sDzFGWb17r19w2ArWn3Z0
         qNuTlmeNjrIwWaQSlCo1on+CE25TUCEW067J/rsAlOTIfR6nDpY2G4tuX+WGFMN51O8r
         uRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740602127; x=1741206927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDxxqhrZdvdGgk4uAfOkfCZ1hI0TZ27DIS134xcwkxc=;
        b=wfAeJhO8of4dZF2ZFhDWEmk8REyyjXPyXajEypFsx8571362+o1GmbU+xrsaqyHtdY
         CltlmZMMc97g2c/YNzigygtnLw0YIdQU4FlQTCmEjNQd8Ne8sb8Wv/sLscux8Fukf6w3
         QSM5hkLRu99XnUAq/cBBT1xP3DYGVD1FecUdce81gMBcfOZfS4tkeZ3UN133EfFT8ORy
         ZVOVqj1/tOcfPFF9RNi4DoR/dugS351w2zB/zUSt2qy9lXaF5B8QF+B4kKHmRd2Puvep
         qKF1jXMl5vyjEFBdkxs6REInt8Adix66X/k4AXJs4BQa/kDrW7qXSjmjRH+ahUpc2p89
         e2WA==
X-Gm-Message-State: AOJu0YwwV3O3gwz+TIyqnCtUId7T+8s+2CwTJOG7WeZjagBDEzI3RjOH
	XL9wegCNthLAVVzeIzjXoQ8uq91oV3G/adRVl7+hlZmufc5yX2Pfe9vmOw==
X-Gm-Gg: ASbGnctEadD1yM0iPmEhpLdmNYX4UWRWdkb2rfSOhQiyv/OHm5qwA/XtvwaDo+JwCQ6
	XlmnKFqgwGxiU0H4S7PVo1ItGwgT6cTIktwaP+BjwVawGrimaS9WX/Ib0iNpD06onxy456PCngg
	A4mkz4pNPbGQdj1seiXBMK/SYQxp3n+Vm5B7iESTclNT9cDnNTzhRIljUT8hvZfsQQafBOLZpxZ
	UmxCVHOB3EdRnsFCLvKtI80/e6DiO6jZMHO4m30day0MxukgX+lHCq2V0x82OH05LlyR6Y7VyST
	3UyXlGE8nRdyOLNnZqXgRLTKgNJLYs3rlPNf1g==
X-Google-Smtp-Source: AGHT+IEqVgH7oFcSwFKWSxb7gau2qOo2AbvMAPKkPKWaZDgrL/Xs++SuFYhF71tmms2iUnh8fAZxNA==
X-Received: by 2002:a17:907:2d0b:b0:ab7:f92c:8fde with SMTP id a640c23a62f3a-abf06260abamr111920666b.30.1740602126759;
        Wed, 26 Feb 2025 12:35:26 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed2054d65sm387912266b.138.2025.02.26.12.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:35:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] tests/send-zerocopy: add flag to disable huge pages
Date: Wed, 26 Feb 2025 20:36:15 +0000
Message-ID: <5748afaecdf24e8ca1f1c9d407e809e8a485fe16.1740601594.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Huge page test is too heavy for low powered setups, so add a convenient
way to disable them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 7135f57c..c8eafe28 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -72,6 +72,7 @@ static struct iovec buffers_iov[__BUF_NR];
 static bool has_sendzc;
 static bool has_sendmsg;
 static bool hit_enomem;
+static bool try_hugepages = 1;
 
 static int probe_zc_support(void)
 {
@@ -900,6 +901,15 @@ static int run_basic_tests(void)
 	return 0;
 }
 
+static void free_buffers(void)
+{
+	if (tx_buffer)
+		free(tx_buffer);
+	if (rx_buffer)
+		free(rx_buffer);
+	tx_buffer = rx_buffer = NULL;
+}
+
 int main(int argc, char *argv[])
 {
 	size_t len;
@@ -920,27 +930,29 @@ int main(int argc, char *argv[])
 
 	page_sz = sysconf(_SC_PAGESIZE);
 
-	len = LARGE_BUF_SIZE;
-	tx_buffer = aligned_alloc(page_sz, len);
-	rx_buffer = aligned_alloc(page_sz, len);
-	if (tx_buffer && rx_buffer) {
-		buffers_iov[BUF_T_LARGE].iov_base = tx_buffer;
-		buffers_iov[BUF_T_LARGE].iov_len = len;
-	} else {
-		if (tx_buffer)
-			free(tx_buffer);
-		if (rx_buffer)
-			free(rx_buffer);
+	if (try_hugepages) {
+		len = LARGE_BUF_SIZE;
+		tx_buffer = aligned_alloc(page_sz, len);
+		rx_buffer = aligned_alloc(page_sz, len);
 
-		printf("skip large buffer tests, can't alloc\n");
+		if (tx_buffer && rx_buffer) {
+			buffers_iov[BUF_T_LARGE].iov_base = tx_buffer;
+			buffers_iov[BUF_T_LARGE].iov_len = len;
+		} else {
+			printf("skip large buffer tests, can't alloc\n");
+			free_buffers();
+		}
+	}
 
+	if (!tx_buffer) {
 		len = 2 * page_sz;
 		tx_buffer = aligned_alloc(page_sz, len);
 		rx_buffer = aligned_alloc(page_sz, len);
-	}
-	if (!tx_buffer || !rx_buffer) {
-		fprintf(stderr, "can't allocate buffers\n");
-		return T_EXIT_FAIL;
+
+		if (!tx_buffer || !rx_buffer) {
+			fprintf(stderr, "can't allocate buffers\n");
+			return T_EXIT_FAIL;
+		}
 	}
 
 	srand((unsigned)time(NULL));
-- 
2.48.1


