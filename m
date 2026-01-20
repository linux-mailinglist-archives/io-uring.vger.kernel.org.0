Return-Path: <io-uring+bounces-11855-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eESKLILxb2m+UQAAu9opvQ
	(envelope-from <io-uring+bounces-11855-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 22:20:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AC84C229
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 22:20:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8B5A9925DD5
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CE53A4F5B;
	Tue, 20 Jan 2026 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Digd72Xx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FD43A1CFC
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768943523; cv=none; b=e9YE9sm3UEw3PqnPg+hNHs464aRTl152EgPl6nC6stLRbBBau7vtvc7FsIVzInYrQlvsz5nN8HJlB+GwnaPuQZPwpX0S41vJSCsARGJOwgda+iWv6Vox74wAZHqm7nHAtjRif5EVL5l2m/HNgn18/6Aj3i5OqyY04ZChy49tFEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768943523; c=relaxed/simple;
	bh=Zp8JMDQvRN6O4UNuokMG7wIGoT2r4+8PR+jrUBswiE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DunbREIpU8EoCxcHJps085hjPtYECbZ9lXMLhMKC7fcvKCzGcpL52L48mrQN1HdYgP/d58kyFBQedcEdbejQLc7SPrpHz873cwIDFYpMvOYtHoGRelahF/P13Ro3DT+K/7aikWloCHCS0HRiPdm0YJ7EA61njyDzgRJIXKEq4o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Digd72Xx; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47ee9817a35so34041785e9.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 13:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768943519; x=1769548319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAbnw/pQBl0tmWiw9M01W7QXNL5/ELktSDvQVrlIMwM=;
        b=Digd72XxuwyeQ1XGzlEwMZoKIb9Wfauv8V3eTwkddPLf2sibTd+VokDbZrbggNMLyh
         /WQbGXNcyzINzqnxffRo/4SKAmDcwS/dMR5JS9C+Czh5bQNRFXzBrs1ZvQx9tkfUQafz
         SCA6ajdBLxG+znIuipCRr7Q/xKmheAAQIGgtX+/BV993JBG+QXE8pltCPvK+9X18817B
         I4LKnFsCm5O/VmUvs2auC8tE7EYvFtdDmckvalEP/mVrj6tat7laN+3lYWEqgPNRUX8l
         LyfCYlEliBSsKUxwXL4gad+r9sA11TvhGARzHop4hj9m4UOpHY5hIhqvb5rQWORDqVZ5
         S0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768943519; x=1769548319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uAbnw/pQBl0tmWiw9M01W7QXNL5/ELktSDvQVrlIMwM=;
        b=e28pd2+urDOvGg/Aqhu8tXm5b4Lpyqq1o4orVDI2XIQxMObrwMaJ0Tib4fvpyNquQ5
         fY2JSorPI/rphbEJnq+hnzBfpaoRykMmQI0Nca5DgV86S4xxs+fxvkaFV8fLkfTtkXZl
         uyD63MJLN1142J3oC5WIeELyUKagp/2YqaXA1jk0Vk4i3kLfL4GLjEp7SiRKcGE2k2vz
         hzvmGxwm3yCKHqTU9jkjCBOaBOtOtdq9Sj3DpGx245/NpgbxMiMiCYEMCBOGhbp9Jful
         DUmg3w5Ao6AcoUe2yHgCI8H2PbC9pUZlY/QyfZb4fseHIDoWlqI/9a3Bxx0R6BB/lkEe
         kxGA==
X-Gm-Message-State: AOJu0YzT5YjcsqT2IEI9vw/24Eb2GOCFn0KYmB3TCvo5l+Y52ZURQq4M
	jcbRGwZKxQhefXB9uVSYrgSNFDeEcxCLe0LxR1TebHXFv02hwVhFB/AQsBKgdQ==
X-Gm-Gg: AY/fxX5YzUFrrHLm2VlsomONQZeeTiN+/wGaIMCpUCR2KUNOayPytrFaAhKF85gpPMF
	kd4pHizwlCATz/PfUeWtChhrW+Bs1+e3KIZpBvjGzdi5tKlzwjX0chyJbXJfklxyDvlpHGZiLhS
	foDDCm0MMcAEHrFj1qffkI2I0Y3uPSMuGeXfw9dX9Xaup79H8f5Z37eGH6xspJtgqpvFHpoGNNB
	j/iWHWI18uyCAwMDP68CQBjEgGPaeObBUtJhGdq0tnxTB0ZGq2jQ2g8uINGPNNzUNdmj4wm+laf
	8Fy7+nmTL7S4+/56hMELnDIoGlst7Fryw3tuq6d77CpFuDDq2FNDLZxtYx/J409TQDMqApqjaQH
	4EzNanPoKVji6/764oUv9oJXJpdlxfTHYI95Yh4xnM63Lqvkq3rOhbq+goEJiDl4zbzV73utUO1
	ncFla9a4mEVwriK0y/RYRWtTZvlliKkmFkQSwSl7wpUwd5aDNhBXCTAoBilwXv56abg9YJ+UPsG
	17fxYsWZ2AT7eLx
X-Received: by 2002:a05:600c:a194:b0:480:32da:f33e with SMTP id 5b1f17b1804b1-4803e7e8526mr34130855e9.17.1768943519153;
        Tue, 20 Jan 2026 13:11:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48042b6a3e2sm1750445e9.1.2026.01.20.13.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 13:11:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 2/2] selftests/io_uring: support NO_SQARRAY in miniliburing
Date: Tue, 20 Jan 2026 21:11:45 +0000
Message-ID: <7c6b334b41e49c2bb0949eb2458851067e42b880.1768942757.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768942757.git.asml.silence@gmail.com>
References: <cover.1768942757.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11855-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 68AC84C229
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add support for IORING_SETUP_NO_SQARRAY in miniliburing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/include/io_uring/mini_liburing.h | 34 ++++++++++++++++++++------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index a55407b09dbb..44be4446feda 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/uio.h>
 
 struct io_sq_ring {
 	unsigned int *head;
@@ -55,6 +56,7 @@ struct io_uring {
 	struct io_uring_sq sq;
 	struct io_uring_cq cq;
 	int ring_fd;
+	unsigned flags;
 };
 
 #if defined(__x86_64) || defined(__i386__)
@@ -72,7 +74,14 @@ static inline int io_uring_mmap(int fd, struct io_uring_params *p,
 	void *ptr;
 	int ret;
 
-	sq->ring_sz = p->sq_off.array + p->sq_entries * sizeof(unsigned int);
+	if (p->flags & IORING_SETUP_NO_SQARRAY) {
+		sq->ring_sz = p->cq_off.cqes;
+		sq->ring_sz += p->cq_entries * sizeof(struct io_uring_cqe);
+	} else {
+		sq->ring_sz = p->sq_off.array;
+		sq->ring_sz += p->sq_entries * sizeof(unsigned int);
+	}
+
 	ptr = mmap(0, sq->ring_sz, PROT_READ | PROT_WRITE,
 		   MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_SQ_RING);
 	if (ptr == MAP_FAILED)
@@ -83,7 +92,8 @@ static inline int io_uring_mmap(int fd, struct io_uring_params *p,
 	sq->kring_entries = ptr + p->sq_off.ring_entries;
 	sq->kflags = ptr + p->sq_off.flags;
 	sq->kdropped = ptr + p->sq_off.dropped;
-	sq->array = ptr + p->sq_off.array;
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		sq->array = ptr + p->sq_off.array;
 
 	size = p->sq_entries * sizeof(struct io_uring_sqe);
 	sq->sqes = mmap(0, size, PROT_READ | PROT_WRITE,
@@ -138,10 +148,12 @@ static inline int io_uring_queue_init_params(unsigned int entries,
 	if (fd < 0)
 		return fd;
 	ret = io_uring_mmap(fd, p, &ring->sq, &ring->cq);
-	if (!ret)
+	if (!ret) {
 		ring->ring_fd = fd;
-	else
+		ring->flags = p->flags;
+	} else {
 		close(fd);
+	}
 	return ret;
 }
 
@@ -208,10 +220,18 @@ static inline int io_uring_submit(struct io_uring *ring)
 
 	ktail = *sq->ktail;
 	to_submit = sq->sqe_tail - sq->sqe_head;
-	for (submitted = 0; submitted < to_submit; submitted++) {
-		read_barrier();
-		sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
+
+	if (!(ring->flags & IORING_SETUP_NO_SQARRAY)) {
+		for (submitted = 0; submitted < to_submit; submitted++) {
+			read_barrier();
+			sq->array[ktail++ & mask] = sq->sqe_head++ & mask;
+		}
+	} else {
+		ktail += to_submit;
+		sq->sqe_head += to_submit;
+		submitted = to_submit;
 	}
+
 	if (!submitted)
 		return 0;
 
-- 
2.52.0


