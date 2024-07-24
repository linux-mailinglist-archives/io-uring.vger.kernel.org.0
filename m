Return-Path: <io-uring+bounces-2565-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF7193B035
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08156B20DB9
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A639157499;
	Wed, 24 Jul 2024 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtCutIds"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE1B157484
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819769; cv=none; b=nQnSYF1z/5L5UV4ttbFLVGlFcySKn3ZAH5jfCkwqD+xKfjoOms7zR7YEJRjzjplqJ0pIqOY50nkXyCAvDtiMTfSBg4ijluQPtHuI68A5mMYRKO7J2C2ObxGTCCxBlKETzBwA2b63yDfQv9Fi++Z1FUjQDs9GHQIK8cpJCRVeqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819769; c=relaxed/simple;
	bh=U/Zrm74Y6bAZ25qPGoTmtqdhNvJvPc6f7rwdKN3JKLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npp5GzKkS8ex8Ez/EuqyX8zjht8dbN6OobDlhuIUvmcMQEpcvMnHK9kXHT5wQqVTuR8oioUOz2frDnGosvpF2nKC+sUOZnxRl438ct9o1zQr5lE/2fV8Sm8mR5lzTqD3XYuWsGitWw2f51FU9k7eoOA63Hd4o4YlRI7DMI++uko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtCutIds; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so6447491a12.2
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819766; x=1722424566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xPXl4cyMnqaZjdoGQ/w6s2umAK37vqhIOacq7LqJQpU=;
        b=UtCutIdsJp88fncPzip3xVAUBkyDcBl0Dp7Qy+T/yB6+7du97bq+ILhUWSoXXlW35v
         C6vzrOD3gwMZi4j8QlqS30QIs824T8v8w5lB1DZ4j71+S9bilHFwkMirDw2L16DL9qd2
         BdG2yIvLKF3yeBZyWJvtrOCXgywzi5+mTz2peqvqNNLMuZs71/yyTd5t+4TZrLuH3b4p
         /pEdx8lVuSjRenwgl9oLA1Pyok9LnPN5Iuaj8bIcl5t+oDEDknci8OgmBLPSgI9iKLEu
         OHxLxxWh7gJ/nvnmkuumLXJjKw3iurY7lrl+rSsHC9QHrT71n5ki1rEzS0QU7u/Lc0Br
         BCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819766; x=1722424566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xPXl4cyMnqaZjdoGQ/w6s2umAK37vqhIOacq7LqJQpU=;
        b=dcflJldFLEuvYQ2VgDNcIpggkC+/VVTrZTviB+HdXdm4JHOvEz1QG72lLBBDnTVphl
         aYmiRK0cgnjUL4uwOD4RB4mCXF+tEQEaphXc27Ufp0HjYwI1pKkWRA7fAH9UZ/iARgYt
         1/0znxB+UEySlckGGYrCnvYkcKN9zUUVDYMJgF6mtlt1iKNmdVFWP8qqIn68bgPLj+fW
         eiudwgqDTRTMrQ2R8iRnI6/5udXiIbdoFE4kqc9DPomlSiOXx6MnhSdQEZPcXE/Oid10
         wyr+Vf58ebxbI8kO/VZdlHEXVGvb74iAWqlTsVoVF1z7mOcVlnLCyPXVWi89Kql2lDWJ
         mj8Q==
X-Gm-Message-State: AOJu0YzNwejULFCH/0+f3Dn2/yPbqG144qlLz7Qz9MX9tD7K3FM4IbqZ
	CslaX2gcFKIibzmsSI9G+MveMEyKRzuOLjnNpZcf7vRULRpCCcQYfyFXZg==
X-Google-Smtp-Source: AGHT+IGCLGMScdOnN+Dl3YxvFDSj+VPB2oSzGfhyA9J550z4GqCQ9mWckBWoDvEk/YoW21/wspYrqg==
X-Received: by 2002:a50:9e48:0:b0:5a2:87d3:6ee6 with SMTP id 4fb4d7f45d1cf-5aaee4bd9d8mr1159541a12.32.1721819765971;
        Wed, 24 Jul 2024 04:16:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 4/6] io_uring: simplify io_uring_cmd return
Date: Wed, 24 Jul 2024 12:16:19 +0100
Message-ID: <8eae2be5b2a49236cd5f1dadbd1aa5730e9e2d4f.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1721819383.git.asml.silence@gmail.com>
References: <cover.1721819383.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't have to return error code from an op handler back to core
io_uring, so once io_uring_cmd() sets the results and handles errors we
can juts return IOU_OK and simplify the code.

Note, only valid with e0b23d9953b0c ("io_uring: optimise ltimeout for
inline execution"), there was a problem with iopoll before.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index a54163a83968..8391c7c7c1ec 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -265,7 +265,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
-	return ret < 0 ? ret : IOU_OK;
+	return IOU_OK;
 }
 
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-- 
2.44.0


