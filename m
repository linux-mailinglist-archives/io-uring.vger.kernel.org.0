Return-Path: <io-uring+bounces-10414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E49AEC3CB8E
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85737625BE6
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA95E22B8C5;
	Thu,  6 Nov 2025 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UxxXg80j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAC25A633
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448529; cv=none; b=bp+qvCCYmCdYaO8JlQI3I4Sd5QLFl8PtLUZjeDz5PibRP4p7aLd0OBl5WkTwLcWfp7NfXIanSFzSyDCNhfTvuxGa8c9tesMcitkfx8DUgw4hWllYNbUvkX4m2QJ4d0jLu4TS4IyVRnIEebYMVgTgHa4sIZXOYfuhaSFsY2rFaIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448529; c=relaxed/simple;
	bh=g9mRVXT8xJJdHAU5CReA5xwhcaSkfdmvQLqIYHUc4Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIZgpAlFJatgRThlGNHBMQZYbtX5roS5wpnl0BqHzwLyumls85NzpL2EZXwabSJ6rrvxipUBMowPaoeWlxjbHXNpcd9YRYZ5XjVBLduV/qTl6fRA5AlsSM3c+4nQ27gPhXuKoHZIAOysusHFNY/TjMTdAbLMIi4B17BHa0bxFBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UxxXg80j; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429c2f6a580so1161602f8f.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448526; x=1763053326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAitbUgq3lEl47+1AAE+PQFTyyV4EoHVzoNuDo3VuoE=;
        b=UxxXg80jl1b3EuIw+gQRlAy7+OvUUBt8c8gqDzcVgtIvHQejHYR8+V+d5BT374dbDo
         akTEbbA5YFSQhkvQFPcD+JeebZj9Z9a6TniZBlOoYrmYDDW0MftActku9VqSr5di+f2j
         v2yyWgVxXPa4Ql/d8Jajw3QiDgMQd9c5RcqiD6b0u25oaQYJDJMMqFFQlOtl3+VQWEGY
         XyqUF+yGKccIzaB2poqdfmCOxCrSvw9eF9YEkqUnjcdEK58xBSvfcZvgnyfPf7B+UjBm
         nlJUMk2Vgfaax+a72v1BWTAhykZk01XvEh0E3FMRXfodgwRYv2Dqnh0oWQG+g6uDtnTG
         IVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448526; x=1763053326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sAitbUgq3lEl47+1AAE+PQFTyyV4EoHVzoNuDo3VuoE=;
        b=Nm0TCe1qDj5E6h6NdxyUflsNTyihZU0hu/m7kaAPc4BQ2C+ClGjEKBvbljHFKC8EK1
         cmKdLu7Gkwb2VQHcwzl0ey+4oeGlvEgIMgInCxThkF3fuRKM8p6TN3TLuLJP8mU3XrhA
         Z7k4Ti+9kY8EHE6x1yGvGSDYVm6dELMe3PAR4foMdeiK70nl7KV3XcfM0heyaKYivGHD
         G6GAccXDLIVxQi19/zdZaytZnNRsXKdAiyEmR3Q4riFjkCrlGPSnRXa3Adm8MDjtgsXw
         ML1VyGzbIAkFhFDn6W9o+gMnVL/pIhHRB9Q4RAVoLFdApF8JPD4CCmtRJohGqRpq8ity
         cURw==
X-Gm-Message-State: AOJu0YyMuxaOkQZdIPDBeh2jVg3lI0dIq1BGEJkCep75gD+duV2HrzHm
	VdjMgwHKpP+fifUviU9axI3e1APDvWozmNgj8Z65xo04TRwRQAtV4AzkHN7bZw==
X-Gm-Gg: ASbGncvZEmr+5M7tRE5JjZtUMRRZ3Mv1HEAe87BdGT71EnyMvG6Diuujmj9VWDLps/a
	252+y++aShSqU5c1PWd2XyZGY4bu6s+/LsxcUj+1j1ug6HYGuKUTI3VN1S7gAH7dB1YaoKJ4ti6
	+cVcXcVW+hAz0Zp7jPBo88Ve9rhzOdhlHfDvpFI9IdN73QZXzwMAA/beShYM9T3vI7YwrxSsMVI
	158BdC0BrsEu8NYgrIh/H9z3NWFkjyTRp7Jr+sEHYqKp4c1cFWvhWG9RQd1FXiO25oYodztS1Sg
	mMONXxzh5aSE/TdRcritP9Ot5DEPyzcocpIeKY2bCn/O748bixC55KpVbnYW7UgOq7jXSWKhwkL
	/Mbb0lWWjbyLgZdxf3TP9gVVSy0UjGVYMxwhCn3yaBHLPytV8gAaFKA61LxUlagzbGSWpLpi9If
	a4A+U=
X-Google-Smtp-Source: AGHT+IGHwX+HiV3YNA+csnn9yiUTZk/W0bLYGuPYMMAMobNtkYAS86P2PsPC9mVrSVJezNS4BlRHCA==
X-Received: by 2002:a05:6000:410a:b0:429:ccfe:66b with SMTP id ffacd0b85a97d-429e33077c7mr6884845f8f.35.1762448525802;
        Thu, 06 Nov 2025 09:02:05 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 06/16] io_uring: split out config init helper
Date: Thu,  6 Nov 2025 17:01:45 +0000
Message-ID: <1ebacb050c3a51095c4986f6a7c543143fe08aa4.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Separate most of configuration verification / calculation into a
function, that will be the first step before doing any actual
allocation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 142811c7a4f5..30ba60974f1d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3552,12 +3552,9 @@ int io_uring_fill_params(struct io_uring_params *p)
 	return 0;
 }
 
-static __cold int io_uring_create(struct io_ctx_config *config)
+static int io_prepare_config(struct io_ctx_config *config)
 {
 	struct io_uring_params *p = &config->p;
-	struct io_ring_ctx *ctx;
-	struct io_uring_task *tctx;
-	struct file *file;
 	int ret;
 
 	ret = io_uring_sanitise_params(p);
@@ -3565,7 +3562,22 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 		return ret;
 
 	ret = io_uring_fill_params(p);
-	if (unlikely(ret))
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static __cold int io_uring_create(struct io_ctx_config *config)
+{
+	struct io_uring_params *p = &config->p;
+	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx;
+	struct file *file;
+	int ret;
+
+	ret = io_prepare_config(config);
+	if (ret)
 		return ret;
 
 	ctx = io_ring_ctx_alloc(p);
-- 
2.49.0


