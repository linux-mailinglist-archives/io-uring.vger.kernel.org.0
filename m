Return-Path: <io-uring+bounces-6662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B50BBA41F5F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:43:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E95C67A186A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA6B233734;
	Mon, 24 Feb 2025 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ndyz5bvv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D2C23BCE7
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400896; cv=none; b=luIxbG0Pj3LIXuxrF3fGYs0qbSYQhLFxSai1AVZYy3xoWuFRAvt58uZiBzmN3Jmo2sJXiCFQfSWfAjseF+tEEOyuDtArecV1PLDB/NP+IX11fCc6yIW4Ogq0n5Qlb1FLfI4lCe/btV+9nJqXdJy9rpiuTBGRW2tfh/LaBj3ujbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400896; c=relaxed/simple;
	bh=Uef6Z3PD9t31rLQfhF6s6QG9HPN2oC5US4T6Vo0uaC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyOgtFi+uBWLZRPzEjJaUBSkTEFpgmZevIICX27mRwobKBiAIv2hinki2u5ARJcsp1fKtbF1tHHmJM+lJomULOb3A5EQMhNmDc/fZCmJ79XZLqx4eyOZUshQe1EcmpqG95Zxh84ZKbG3rIVQ3gi1ZBFxxZg1tXABjIdhukX1O0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ndyz5bvv; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e04cb346eeso7239360a12.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400893; x=1741005693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s9VUFtn2K6wFe96f33YVilmD2xqnBhBUmD8F1IuXerA=;
        b=Ndyz5bvvswcLN1Mf8q1d4CFKHJmmZZdsg0raDTcdH+OinkqW/YnNv6n/CGesgiH5f6
         +RDz/7KamTJRRrhZ5VkTH9kRlStAD3JYTYv57NECFnWhpD8HKGSzEHou5GSFWGMUaagM
         mTKpKDavFSsgrshhlWN13ZIbI6A0DXa572vRuGILqTFQNOPhCn95yjQ3FkZ0hGPF4xmk
         iVmj45r53431EiiXoBgAejWs0ndXhs6oeI6ahyawt97mcGcliHW/hzkOKX222rO1o7JP
         mKdvnalAHLPUznyZqg89YDJCUuQ54MAt+RQ+OCGFh7G4UYpBlvXpJ5SV2H2xr2a/0xnv
         Qz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400893; x=1741005693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s9VUFtn2K6wFe96f33YVilmD2xqnBhBUmD8F1IuXerA=;
        b=TfbE1BgYdU7v++WWN+dUAW6c02tVk3ztuj9SWLkHbP8dSwtgcD4QKmUbcvGSDmqM8T
         cJpPmDQ6oWrPVPNNrfQ9VXkZwbDpUIM+6Pxq6tD9fmOdxHZAMckAqH/izXUMvTLJ8kid
         9QX6yxj1ZHGmVQ/43EeNlp0opuNja98H4X/OY1WeqHJTte62MEBGLFmd2SSxDoWf6qWo
         4uz8tBDmcgliBvNjcQXoqbsY7+nXgEtvN16ekqx9dgaVi30syjhfkumWde/bC/Aq34ob
         euolVDpZoqZtE53TUv1Tx20d9Zgw55WrM+JAwi7au79W+pTxgHxnXWlsx4O7ZnHJSZOb
         Nlvw==
X-Gm-Message-State: AOJu0YwqIVnI6M62nOGah7Zw8b7m9TIpbXP7nqtHx3NGsiQ10VedUKte
	loAUMXHG/8tYGa4pAM6xlppO6JifDIvdn4v51y5mnsLNky9OrJvitOdyvw==
X-Gm-Gg: ASbGncsojCpWraTCHfMrD6ikHRBtjSBvfoe064tK21yda28G1DXQOht7oLH/qDwCDy8
	utOnLcPDur7J5iMcLBwrd2H7wwazaSByRjjTYpqPOqWkTpmYpUELLwdzsuomz8526MHAN3jLFut
	TS6YbmQawEW1BMKTLkGm6cuzKbQzH/Ar/Jk0UFWVmBBxlpBXhLmAlfAevdHInJi7IN3Z8jhEhZJ
	rQy8wE1vDr6gtpqREKTwdYCPeFuPTxO3OATatVtPyp/+FZUey3Hi5Wa2zGxQW1XXQ1EMJDzm4ys
	kJBy9LDfHg==
X-Google-Smtp-Source: AGHT+IEH0J3ZZCQkSAk1lE7Gm+U1ncav75ZaCzYmAnTitJpnxYnpwtRRVKmFW5qgKr+KaevKd8ayqw==
X-Received: by 2002:a05:6402:5192:b0:5de:4f37:e59c with SMTP id 4fb4d7f45d1cf-5e0b724782amr13101108a12.31.1740400892881;
        Mon, 24 Feb 2025 04:41:32 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:32 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 2/6] io_uring/cmd: optimise !CONFIG_COMPAT flags setting
Date: Mon, 24 Feb 2025 12:42:20 +0000
Message-ID: <f4d74c62d7cbddc386c0a9138ecd2b2ed6d3f146.1740400452.git.asml.silence@gmail.com>
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

Use io_is_compat() to avoid extra overhead in io_uring_cmd() for flag
setting when compat is compiled out.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8bdf2c9b3fef..14086a266461 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -237,7 +237,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
-	if (ctx->compat)
+	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		if (!file->f_op->uring_cmd_iopoll)
-- 
2.48.1


