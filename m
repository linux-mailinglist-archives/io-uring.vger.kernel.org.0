Return-Path: <io-uring+bounces-6661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E56A41F58
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDD6C18852E0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9686023BCE2;
	Mon, 24 Feb 2025 12:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kr7suwjd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244C233734
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400895; cv=none; b=ISy2sVcA6Bapr7dN7x6F/e4aPU90Ah2g+md8uMpV7r9khG71tc3fBu4g6j2PfWO/50rylslaXsqoUb6dXFX0UAKJoXZz8efeCyuxhMjLb8S3PbAt6ku1GnMG/zbqLlruON2e0pWPtZRjPBTATrYlCnzZf5aN2x4buQ9NU3V2ilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400895; c=relaxed/simple;
	bh=qkGfU7SiShCPMkuQUNL1RqDDOnKfbRsv+FTjN7ldlJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8Hk6Xs2Zx+9UAl+AY+d80++dQEVJebViwL5QBHbMfLnin2NsT/rg3F4GjLY5T00mnBcdaMNxI8Rsan9RoB4dsJsaNtiQWZBvn8vwBxTldz9Xas3ui03tgRiTypTU10HMyScaSNzkCAJEk7y0Fg5Zuq0K7d15zGiXh4a1yxA9IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kr7suwjd; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e050b1491eso9326382a12.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400892; x=1741005692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJ6hNd1BNc/EvBYXhsLk1BzMTv5/8ySZa/E/7n/qpNI=;
        b=kr7suwjdHkPjfzX3a0RPY3YkqmId8Gd3HCBKdva8LIV+IsENLgDgYm3I7OqofDS6P1
         2YJP2OJ6ujHucs/C8comdh2LT6TpDjb/sUt1H4JZl2bywQyLoyad9KEelT4mu1MfyPa8
         GcDUCn3UUEAfw+2pUD5DgKh4s9yEXaHIvQjVramynysvpX3z+XNFlPKZQB2OWmAFu4KF
         kbKdFsCafUsAUNi+M/M9hpvNuwQ1WnE+z8cRVxXZEmC2UQVBCwufY0Qg68RSGO0/i1Js
         I59WwVEEPhJNYrMuwIMHwYP0nNoBxpJ7tpByMltaWIXwfcpLhKY0P8Gp6Y0Kr7q2gwi9
         jIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400892; x=1741005692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJ6hNd1BNc/EvBYXhsLk1BzMTv5/8ySZa/E/7n/qpNI=;
        b=E66OKxK0X/G2jVcJr++W2RUB/h6RrcVibZlS18HDbuec9iyBR8pJgk+HsUuV0+kYnu
         QyTh7p67ISmNTwp5LoFz6XHmaD5I7EixPXBpRcK3NvvMhiwX/nFZmaXG9LxKqb1VYTc/
         m5C4qgRdbvbNLlhu5JrDVskI37oShJOoBoYIqf4UFvLXILYybuanSJa18LOfERoq+N64
         WjQi0IVScwQRWxX1n+DuPnhcgbvZ7M9WC6INZAtBdTgcSBybfDgXPGTM+QR/qRf4u+0T
         8RGVjkBsB+/OrLMH2SUP1O2PVS7QdkYeZ757yxYe467FX+VgKVCBsrx2CcsDPrUYqbe2
         VYbA==
X-Gm-Message-State: AOJu0YwP3hrSu0dEbNGPDB0LkynPQuVbyhFPWc9VxHNzYMLBrxcLQ/de
	NFWeqMFJqXYH9K83FwRrVJ6A7qw31+gIOxEjb5g6DABOl5B9NB7cbZr+tg==
X-Gm-Gg: ASbGncuuJmLs/YgWAFxCdhFvvasLtL0CgHk6AQ0vNnUQfpkQtsX+h9g3OibsTl3XC4C
	KOp2XontCBF7kc56RR3S/g7mzoDpiMd1ryapGHf1P747G9WXylIYCBl4mmiNoyPKV2MjukePe/a
	n32IeQ6/k4gbc/Q0VduVbAUsut9aYSULF+rBnlteRJR/vDeDibOiDr2kWtpP5Yh0EHWbQ4FwIYH
	yBljl9UpuPVsnb9yf1KyTWwgg5jlGPSNJhdTDvzxRr0x5j81+yzSMbrRsBvrNwMkyVjnLVffo5v
	0GcDMYJSQA==
X-Google-Smtp-Source: AGHT+IH0FNGxthliUWH+OP6D2ArVEBUIufU8VBw5BhizUpHJ+iNeKOsCj7IofVzkeIPe1hM2b7bwpw==
X-Received: by 2002:a05:6402:5194:b0:5de:a972:8c7 with SMTP id 4fb4d7f45d1cf-5e0b62ea622mr10874604a12.5.1740400891618;
        Mon, 24 Feb 2025 04:41:31 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:31 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 1/6] io_uring: introduce io_is_compat()
Date: Mon, 24 Feb 2025 12:42:19 +0000
Message-ID: <1a87a640265196a67bc38300128e0bfd7839ab1f.1740400452.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740400452.git.asml.silence@gmail.com>
References: <cover.1740400452.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch adding a simple helper for gauging the compat state.
It'll help us to optimise and compile out more code in the following
commits.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 650f81dac5d0..daf0e3b740ee 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -147,6 +147,11 @@ static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 #endif
 }
 
+static inline bool io_is_compat(struct io_ring_ctx *ctx)
+{
+	return IS_ENABLED(CONFIG_COMPAT) && unlikely(ctx->compat);
+}
+
 static inline void io_req_task_work_add(struct io_kiocb *req)
 {
 	__io_req_task_work_add(req, 0);
-- 
2.48.1


