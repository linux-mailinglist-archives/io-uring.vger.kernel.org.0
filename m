Return-Path: <io-uring+bounces-10003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 47340BDA33C
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 17:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E6670356270
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29532FF65A;
	Tue, 14 Oct 2025 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9zwgLVh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2FA278772
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760454108; cv=none; b=HwgNdlgYe9535NnJOMFNewY4TP8yY3X9Z/Cudu97EvVEiLxKB41zbKSZmSR9Dd0mTKkr0iRYYGgV1VOZllNNrUnQ9WZTUoPlgNHXsl59Zcl1tNgez+XJLWwQ6tQX17vDF/G48uvVHHrYIxvtcdYNASluvH+fOmjOoYbMgbQXk3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760454108; c=relaxed/simple;
	bh=MRLTq0r/inojRzW5SubfXO0IQDhOzsPVb990014y4jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK3N/IaFBakHMRujRrkDZY6HIE3AKG2qr4HJPvdnZPXE1+4eB6j4YheDfB80041r52JElhAf8LX+65/+JzP5zTiKisIYLauIPUczGdI973SG+Yoay6h1VLQTSSPfqug1NXAuixUbVjLaKZlFW6JUxiVkLsN4J5L/LLwOUpnkWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9zwgLVh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so50503045e9.2
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 08:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760454105; x=1761058905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pH1rlx7kiTnmA2VN4bzdUFPPSmetxk8EkQLpm8UDuEI=;
        b=O9zwgLVhyLPUIy+vlfNdsfJMWgh7BphZzIj1y8UKXsfPb6MvnMmhxKETvvpmvFrWcD
         xKGEJZfmbKHHdV8UKbM54C8EdZrjI7Si+GKtaU7iEt6fIU1c2aJ5rpUQNMVzOqSv/IH4
         LcwdBum4gu6TsTaJ8hoU2zY4BNqv/BWZPPDGgO29RNsRsJ2Ezgzu4pWWaoULatvyXJOb
         YpbdFAnyxD3dSkKMZxVVpqGbaVJkXGJx9d+xeu1aFiJCHn3Iml9/wN8UpMQe1U8b6XWw
         iH6hyocsuWkN3fSDyrkaRoc4gt1JUyz2bbNGbctUxjV4wMRV67fohBziXW+dw1CXkuW1
         q5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454105; x=1761058905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pH1rlx7kiTnmA2VN4bzdUFPPSmetxk8EkQLpm8UDuEI=;
        b=LorkVfqK8BgZkZVI6LseLZqjJkfdUKGU+UX4DYlFplLud1RBUhcYRBU8oWJlBYIKm2
         G51r3YgE8rqTTn5AB4/NlMLpu38HVBD3RkQCjcwzJ3YTGJbcFvfjSpsRQZ3wnqVVjz00
         BH0KrxLUsS/LpQzQZwHKBszXYeySm7l08zpN3n0ATY24p95wPtkg3Vh5lkXCh4tTobEg
         Omwc0kSH6BRYNmTwAlQWyj2cy7VS9aNUiTOoUd1b0v8ihd0fGkRIRI4PX0albK5pJWdb
         vuyR4lSxn48mBnAKKoLuGPIm+PU4NyN/jgVZFPJ+lJ1D2rU9CTbUir78hyYJb8GCq4tu
         ndcg==
X-Gm-Message-State: AOJu0YzfHY/wCDAUhtdyoDlvji0+1KvyodW5gM2k2Q5PCoNGcO0EXE8U
	SPv5VZUzMY4QM/wPE45C+dPRPmB1I26mcYyQm8xvoz3mVYgeB8gPWUMpwEuJEQ==
X-Gm-Gg: ASbGncusIzNkF/kYS0XT6Pqrf+mvOWUYnWr9IgdO8Fd/iMY5c/YjhDa1YVSibXqMWL8
	vIJ2CBHU2SK5zt9+KKm/Ev3W/A9SU0v5ZM98OyOFswI40aqUe+Wkbe5bSilzc3SGBMM8VJpiTe3
	FknkQ37s1+gwgpzCq8UiiLHVsXsTGkFeWMc7n4PKZaOXqaTm7bavah/17OsDwZIIKR5mIv4qpgB
	jUMZOyFPxE/0QA65BZRrWpb/a5klNoxdeL1npVWbnujjNwxJTTQPbpeSL4wDRzipp0ac//9GXXU
	P9SI6vRivmMYbfOfKRT40czMZdcAYahYl57OwT3XLlTg4fYtmQy+k3rqnCI6ds07PLLvYTh5khQ
	v4dvJhvhF0Aktaq3i5s7gRnIAcT0kwcr+aD8+DjdJPGcASw==
X-Google-Smtp-Source: AGHT+IEBLIIA2AWLi9tNv9wjZchxVpHsxfIa78VuW4dgan1dLi7vU5uXga7+qY/6AwlzB/iuIwrXbg==
X-Received: by 2002:a05:600c:46c9:b0:46d:27b7:e7ff with SMTP id 5b1f17b1804b1-46fa9b18289mr171219125e9.36.1760454104212;
        Tue, 14 Oct 2025 08:01:44 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4983053sm243910975e9.8.2025.10.14.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:01:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v4 1/3] tests/query: get rid of uninit struct warnings
Date: Tue, 14 Oct 2025 16:02:55 +0100
Message-ID: <6c6df3a32c68feb478787fee1511e67909982cef.1760453798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760453798.git.asml.silence@gmail.com>
References: <cover.1760453798.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compiling with -O0 revealed that compilers are too smart and complain
about io_uring_query_opcode not being initialised. It's not an issue as
it's passed to the kernel to be filled in, nevertheless, let's silence
the warnings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/ring-query.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/test/ring-query.c b/test/ring-query.c
index 971fd9ba..d0aa396c 100644
--- a/test/ring-query.c
+++ b/test/ring-query.c
@@ -36,7 +36,7 @@ static int io_uring_query(struct io_uring *ring, struct io_uring_query_hdr *arg)
 
 static int test_basic_query(void)
 {
-	struct io_uring_query_opcode op;
+	struct io_uring_query_opcode op = {};
 	struct io_uring_query_hdr hdr = {
 		.query_op = IO_URING_QUERY_OPCODES,
 		.query_data = uring_ptr_to_u64(&op),
@@ -76,7 +76,7 @@ static int test_basic_query(void)
 static int test_invalid(void)
 {
 	int ret;
-	struct io_uring_query_opcode op;
+	struct io_uring_query_opcode op = {};
 	struct io_uring_query_hdr invalid_hdr = {
 		.query_op = -1U,
 		.query_data = uring_ptr_to_u64(&op),
@@ -119,7 +119,7 @@ static int test_invalid(void)
 static int test_chain(void)
 {
 	int ret;
-	struct io_uring_query_opcode op1, op2, op3;
+	struct io_uring_query_opcode op1 = {}, op2 = {}, op3 = {};
 	struct io_uring_query_hdr hdr3 = {
 		.query_op = IO_URING_QUERY_OPCODES,
 		.query_data = uring_ptr_to_u64(&op3),
@@ -163,7 +163,7 @@ static int test_chain(void)
 static int test_chain_loop(void)
 {
 	int ret;
-	struct io_uring_query_opcode op1, op2;
+	struct io_uring_query_opcode op1 = {}, op2 = {};
 	struct io_uring_query_hdr hdr2 = {
 		.query_op = IO_URING_QUERY_OPCODES,
 		.query_data = uring_ptr_to_u64(&op2),
@@ -201,7 +201,7 @@ static int test_chain_loop(void)
 static int test_compatibile_shorter(void)
 {
 	int ret;
-	struct io_uring_query_opcode_short op;
+	struct io_uring_query_opcode_short op = {};
 	struct io_uring_query_hdr hdr = {
 		.query_op = IO_URING_QUERY_OPCODES,
 		.query_data = uring_ptr_to_u64(&op),
@@ -234,7 +234,7 @@ static int test_compatibile_shorter(void)
 static int test_compatibile_larger(void)
 {
 	int ret;
-	struct io_uring_query_opcode_large op;
+	struct io_uring_query_opcode_large op = {};
 	struct io_uring_query_hdr hdr = {
 		.query_op = IO_URING_QUERY_OPCODES,
 		.query_data = uring_ptr_to_u64(&op),
-- 
2.49.0


