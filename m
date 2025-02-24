Return-Path: <io-uring+bounces-6701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B587A42CE7
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648E9177C4D
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12151F3D45;
	Mon, 24 Feb 2025 19:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h38yGW7+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A81200138
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740426263; cv=none; b=Pg98e4R4qi9RwoZwv+pDsx9XdnmNF02bXaYjFbED2rcs2A1X6aEFKzMkc47ajCctUGmVF7dvK3grfCKxatymAdGA9slUkzfEuATVVUJKmIJFSoBQITqgsW2zj8Tv3PEiqnt6DZRpP1qiyptWNV2t8S56on7A7YqM7XkL9Pddo0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740426263; c=relaxed/simple;
	bh=Rtd1vr5SAaF02h6dyLb9Ksi5yf1TT9r9MZf01jdx/pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOg2wRjRsKGa0OocAONxQ7Gmo3wMM3kdJJ6gjP5JK5mt5iDnsBVwkAX3UFGCapFZ7Ti4ig59o+RK6vjZBKvNVWZSnNJsNd19HKNKUZXwd3HebM5YYzzNlWtevaFVkHVDWVSfCVTH4/bShBR3nAY/fYSZT+TtS6ttHsLJcjqv6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h38yGW7+; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso2520163f8f.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740426260; x=1741031060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QwZm2v050ucBGPYTt5nSqW/wI1mc4sDWfiJMAxM5Nk=;
        b=h38yGW7+/zQiSNBG+7qj9Tl111hoBVm4gIM5W+fO5Q9hV5V8W/fEtCn/OtiYyEim6x
         Mbe3BahUi6SfSAyhhh9D4WTXXFE0I7Mzc9iDqd+w4F7gskRbN41M01Rcy2lWTHZqW4pG
         SDmWsLEEaP+86sVMgNNUIGUvxLT6geexa1F2Voeq6TbxEFN7OHHVl/TtiMLvd+U3bt5y
         /ACCcqQlira/pXPR2cIXTWGUlMJvjS576zp/wYQZCLtRQsIjqosalZ5ewOkEjdJHYTuX
         PkMlPWP/BZHWAKmveAnU5tk4c+AET5/SWV4LozMccvKbCHFbJxxa/LNVeFcym+eIq8v2
         PclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740426260; x=1741031060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QwZm2v050ucBGPYTt5nSqW/wI1mc4sDWfiJMAxM5Nk=;
        b=rjEjcsR9+KCdyGLHQEdRY9DDK4BSJ8gN5q1KO93zCXjXmu5EdB/sOEgfvHe2n1VGZG
         mPvYxqgmOxPUHesZAf43C5Z2IgUPamMUQalgQtDC5zJ202PBhZzpSOz4LMFxWcwQq6Tf
         bgwA9PenihBD0OnP4K2BMqG18KfRFH9QaVfrXVGN2ZOZRyksoIAXeZNbvW34JcVN+glX
         HL2Qkt1u0jqvErWjXXu1UNfBvZUeYtqhCu8d5IKbpX9zKeaY9jCDDHOOj9JuzoIqkF9C
         +MRGey1vKLKG7c2hRfPAP7U0/MoO5L1BJpe2UTVA/DxtDkMZksbF3IRAp7Obwah1QXP2
         Oj/w==
X-Gm-Message-State: AOJu0Yzd+ITUCokuVtcuesiGh9g3XA8IjET4gRePHIKEnXgXDJgcBoH3
	UEC/HMQl3xvOmKlsCH0E3kmcS8vXYjKyH4WHRZc0Y7vZrL8Mxixj34sASQ==
X-Gm-Gg: ASbGncuD5Efrq+wMFE31B+v3VjS3foKDgxZU5Wd5RHXAkeocryM854Sz9sZt2m0SWwL
	6yI4euDAmj4ecsKwLhWMhbQXQ9PSvPI0PLQv/j6F2geJXCxBNILvSmkkvuD9g1cDfj+i4fEKE1e
	ZbDG9MRraoJjqQv81L2eo6vUyUc0Otnq5pdxP0HNJRoXfPW2mZkJYNsNxmD9QKqAR5iESbnZ9cA
	ldO2okUlq/LCjSVYx8FJCh+EC8yTwvypowbU+E675hbhtDj4Ll8PIXMeU4EJDDFzKDmNz0xXTTp
	7jO3qZr2uX8AW+NUgWh1OWo0FbLMhVak8r4LIs8=
X-Google-Smtp-Source: AGHT+IEZ+/3z+ctNhMqN5FVLH9mxpg2OZxKJtFIffD0DuMlU55JxHI7OwFOBrzynYsepth3XFPxmkA==
X-Received: by 2002:a5d:5887:0:b0:38f:2065:3f20 with SMTP id ffacd0b85a97d-390cc604b28mr218205f8f.17.1740426259783;
        Mon, 24 Feb 2025 11:44:19 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab14caa5esm1548305e9.0.2025.02.24.11.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 11:44:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 1/4] io_uring/rw: allocate async data in io_prep_rw()
Date: Mon, 24 Feb 2025 19:45:03 +0000
Message-ID: <5ead621051bc3374d1e8d96f816454906a6afd71.1740425922.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740425922.git.asml.silence@gmail.com>
References: <cover.1740425922.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rw always allocates async_data, so instead of doing that deeper in prep
calls inside of io_prep_rw_setup(), be a bit more explicit and do that
early on in io_prep_rw().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 22612a956e75..7efc2337c5a0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -203,9 +203,6 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 {
 	struct io_async_rw *rw;
 
-	if (io_rw_alloc_async(req))
-		return -ENOMEM;
-
 	if (!do_import || io_do_buffer_select(req))
 		return 0;
 
@@ -262,6 +259,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	u64 attr_type_mask;
 	int ret;
 
+	if (io_rw_alloc_async(req))
+		return -ENOMEM;
+
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
 	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
-- 
2.48.1


