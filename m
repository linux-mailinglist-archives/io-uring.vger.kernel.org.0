Return-Path: <io-uring+bounces-6664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D964A41F7A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5DA216B37F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CCB23BCFF;
	Mon, 24 Feb 2025 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NC7Sm9DN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3150123BCED
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400898; cv=none; b=m04UucfjgPJgvvFdywqgO/MSkT0W+Tn8/XghLyHDiw1LLlG7HcTs34Ty63pXDYqR5ZL1B9sjWxwXbIgUbUn3m/GNTyMhmVnaCbOZ1zT7G/px1yIsgtDpe3uWG4tHB/vNQfvUrISK95/Sc4+q1/thdo1HOWlPR5efQUHRvLHsUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400898; c=relaxed/simple;
	bh=3QU4q8iXcFGLbSXXEgtj284mS6q20pqcFQeIiGMPYGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohYpRVnQ1HuTn6TJell5bPGIsCwGfyCAOs3kM+aQVYW0MAMgf4/CQMyCPahknZaJ5wQJ9dR0pwFA5qCPVGEK14B2fY2mxYYHuv9RyAeDMtBHozLojTodlhHriRSNS3IiXj7cQyJiD8gcir0C+NKs795LQ4dQyId61hDqJOdZtj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NC7Sm9DN; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5dc89df7eccso7872033a12.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400895; x=1741005695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpRDb9Jc6m/HtHMq4BA9JO0pJq4DDZoA3bizjMcy5DI=;
        b=NC7Sm9DNfte3FpW/x03zLowy7GLi5u2rp+6iUWbqATQrDlJrYQ1dYZBMUC3IoiDXV0
         F7Wu102Duy67xct8V9+RarqhAtkpFp5BMsg5yEHQZ3eoByWezBo/9yBWjyc8NNXTPtbS
         dzzOqrgWtWYLLAvtlMM0e5ArAT/af+2EEhwoHuJe1HSlMLIK9InBzMChOLUFLM8x1LDB
         Ih2aPje2G7a81VisICLc2pfCKsDrrw3BXg+hteRe/xaFu9DYX1ZmHlyGfES6GvI3C3Ib
         ffE7yfWGRl4fHMhVN5B+Jq/QcIGSrzqzJnvpG8MYhVLmcMNo5L3MjuotQDjpSWUanbo3
         Wpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400895; x=1741005695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FpRDb9Jc6m/HtHMq4BA9JO0pJq4DDZoA3bizjMcy5DI=;
        b=Ugn30O/aZlCjfTYGropgF8jPcKyMsyxuS00Zv4rAFFAAZWhrWS3vxST0xDGZwQ0W5F
         EYa1emAmzGSgYN++P3ayJ00KSBgcC6aWnpFku5lGeN9aXJujH2+gGnPd3dwHPxwjK0oi
         3EYt03VBr+zbayiezYCyscHGx7QyQG42Uv9JUPKLs+uNIs6WCd9bhsDw1m402URV1Uxi
         OeyDxa7QZOl2NGKCcIB91Rb2KWkOgrBSv1THfUCLmlAxTHXzcNQwF3UvjLwUOafJgDX4
         uWPBwKwNp/vJ+euoaBasNjT++vs/37hmnSBP4eUJ7yfkIVM1KWYWE2gEj1H8/WcQ0KNT
         nJhw==
X-Gm-Message-State: AOJu0YzZ9kQwSMjpDN5Med6PnDgo79xvpt7m6YVKggRHrL+jek1LB5AN
	tpL82vTSaI672xVxIT/P7UcZuWMfCYiRXK8oDQATd/+YWMeyjssVThdfQw==
X-Gm-Gg: ASbGncvG7Q+aT8YsNQJuaHF6eZPQdjsG//y7C1myuGiRd50dJ+EMx89ck5U4zRq7wVS
	N0muZCHchb0DDw8aqbEFRavutYoxZIakCiIab6oU10dqKMuuIUX/RJl7rKuagofFU0e6LopYxmZ
	DuHax8YgJlEsiWDBKniRFOPP96lXX2PgVOwwkNTdCxHU5MU8+Pi4VtX7AHhbukQHlNjR4JcBkSU
	PPM0Fjjlsj3WnYpQ5QWJ7FhwATAoEGbB88Y7Kk67L/O6c8p4lpT7jvk+efp/GbFWPwjwoNS1acW
	W3IPdvHybw==
X-Google-Smtp-Source: AGHT+IGZGM73LHX+t5UqOGADPN7LrjZ9BvfiklKpwSsTR8CorX392wqpjJGw/WBlEKHXmWB/7W/Xjg==
X-Received: by 2002:a05:6402:1d4b:b0:5e0:36c0:7b00 with SMTP id 4fb4d7f45d1cf-5e0b7257b92mr13400911a12.31.1740400895118;
        Mon, 24 Feb 2025 04:41:35 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 4/6] io_uring/rw: shrink io_iov_compat_buffer_select_prep
Date: Mon, 24 Feb 2025 12:42:22 +0000
Message-ID: <b334a3a5040efa424ded58e4d8a6ef2554324266.1740400452.git.asml.silence@gmail.com>
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

Compat performance is not important and simplicity is more appreciated.
Let's not be smart about it and use simpler copy_from_user() instead of
access + __get_user pair.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7133029b4396..22612a956e75 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -48,18 +48,12 @@ static bool io_file_supports_nowait(struct io_kiocb *req, __poll_t mask)
 
 static int io_iov_compat_buffer_select_prep(struct io_rw *rw)
 {
-	struct compat_iovec __user *uiov;
-	compat_ssize_t clen;
+	struct compat_iovec __user *uiov = u64_to_user_ptr(rw->addr);
+	struct compat_iovec iov;
 
-	uiov = u64_to_user_ptr(rw->addr);
-	if (!access_ok(uiov, sizeof(*uiov)))
-		return -EFAULT;
-	if (__get_user(clen, &uiov->iov_len))
+	if (copy_from_user(&iov, uiov, sizeof(iov)))
 		return -EFAULT;
-	if (clen < 0)
-		return -EINVAL;
-
-	rw->len = clen;
+	rw->len = iov.iov_len;
 	return 0;
 }
 
-- 
2.48.1


