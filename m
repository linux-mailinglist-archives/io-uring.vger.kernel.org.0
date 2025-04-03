Return-Path: <io-uring+bounces-7378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF0CA7A1DC
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 13:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F29C189823D
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 11:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193EB746E;
	Thu,  3 Apr 2025 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdaQ14aP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADA13C67C
	for <io-uring@vger.kernel.org>; Thu,  3 Apr 2025 11:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679712; cv=none; b=lSUVKSM+tMkmhSwHSqggy/mjsxI5VhwFKoWGjkkPBRJCXV7miSsbChqBHSEc7QAn3bxoiSJa8lxikP/TzHrV5Bfdqu3G4tjkH5PGOr6/9bcJu8I9uNYMQvCBdfUL6sQu0bq/lUZFd7We0KllaKRwTXFclcCQNBVBjYGtvDNboMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679712; c=relaxed/simple;
	bh=pajgZP0Ey5si76jj7Tzg3iwKqjDt1cuH22ufr5GlAps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=amBlDOaBZqsmlwl63UjbECfp+dWhWWh7wZZ18YNK+7M5GJTvuEoKjrKDPvVoDhzsJmuRN3MJCzNsR9Rf1H6Uqg/d4lQH15/VbaKEIya0//8L1L/zhIITe23IrtkyW9wuZnTjy3EXkh5CYeNoMNfi5qezT2liNFppgi3WcEmR0eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdaQ14aP; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso1274015a12.0
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 04:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743679708; x=1744284508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s1Bv2Qr19TgnDxI8+cOsVADdKez6B4hj95rLCjRTNpk=;
        b=mdaQ14aPCX673KnLNzA4VT5iJIoXKCpuE+v2H7i0ajTYN+PI5iE3rfGmvi/PtPKr4r
         4XgRaD963V0yUswiHq3piLKuImBAVXALd0IAdLTojovoBxib+l0Mqm+uZUQ6UG1hggT3
         31vMC5/dz1mSzVuJSuFEkgJKZRjibKZ6skkQIGy4p7QbC1JySEY6YsZEmTnAKti0NApv
         Z/dhBRmjW5fDSgy7MLeZ/NbsKA++zswHw4+3fVpfO0O0qVuvYJdIy3dzskqtNDA4HZyO
         WGkxymQWjqQ+wbE6eCau5ICU06o51Z/fZJi0Qs3Rt5IB4vin6SOMpBLwWujqECi2lu7+
         Qt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743679708; x=1744284508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1Bv2Qr19TgnDxI8+cOsVADdKez6B4hj95rLCjRTNpk=;
        b=ies7cji9VFDb/WCvwDX4xkV4IDbFdpMiXa8IQlJhcFbNkzW0tHYi0szpQOksK+lzrN
         HDaPoLSbeeTxpWPzBB3XddjPWqx/AxC6W92SYZbIsunj9AFN51PiInJH9pZqVWTn+Kf8
         C2kYXnBJtsjXJ8puVYEJikOGgz9mZA9xJUAyE99Np1RKIUm9TGP8cHSDbWtQ4KFTsmwR
         OULOTZ5ucYWwKp+h3Hch7/dy39j1UBt5dN9XBi+BB+4CvDCTyxoyjrKHePpbrL4QWMEl
         6fNPUIgUtNDE9Da0ae0Ly/hawUy949/1N/PAYCQtQtrjOQEB149m4L5so53pV2SGklTD
         ZWXQ==
X-Gm-Message-State: AOJu0YyT08uJPOK8Qud6m26LZjGYYpoNakHF+MfLwz258E24/OJVR14u
	X9us4n48qP58EoSeVVP9bBzd6b+w4b8wjJwip5qi2Guw2KWgnvoiF9neWw==
X-Gm-Gg: ASbGnctRosRLzOETFaXrnQl1cESEbhtE/hafUfWfsUUmnGbJTeCHexmIkgq5NjDMyqm
	tjHoITRCw6AeRVxuaCamFCY8MaEbx5Yj+OmdgFhni2+AAVEYXjm+YsSzhHmuYgrlRlPSXmapydf
	1eTQPhHGQIssctPe1Y4WRCUKj6rVxKYmkxknsUa/6ilNRYHztv+uOw11iRr0wYEfFeM2TXqXW5S
	hmHCcLmW7PE8p+cQ1hbw7l/E0p2Zy6lJXqpFeJn4CK5NhQClSsFp7yc6mgcRwbDQBAS+Uv1vf0k
	vPilRh48zLqVLidxgJqgHXv4vgk7
X-Google-Smtp-Source: AGHT+IHKLXoSOn2Fe/2lnaeGxDSSJ9Hx5z2eyctOZqTlfCZws1H5l+qmvIeKmsks992xpyuMgB9aUw==
X-Received: by 2002:a05:6402:90a:b0:5e7:f707:d7c4 with SMTP id 4fb4d7f45d1cf-5edfde203f5mr16513361a12.31.1743679707536;
        Thu, 03 Apr 2025 04:28:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7d8b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f0880a4054sm802413a12.67.2025.04.03.04.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 04:28:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: always do atomic put from iowq
Date: Thu,  3 Apr 2025 12:29:30 +0100
Message-ID: <d880bc27fb8c3209b54641be4ff6ac02b0e5789a.1743679736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring always switches requests to atomic refcounting for iowq
execution before there is any parallilism by setting REQ_F_REFCOUNT,
and the flag is not cleared until the request completes. That should be
fine as long as the compiler doesn't make up a non existing value for
the flags, however KCSAN still complains when the request owner changes
oter flag bits:

BUG: KCSAN: data-race in io_req_task_cancel / io_wq_free_work
...
read to 0xffff888117207448 of 8 bytes by task 3871 on cpu 0:
 req_ref_put_and_test io_uring/refs.h:22 [inline]

Skip REQ_F_REFCOUNT checks for iowq, we know it's set.

Reported-by: syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/refs.h     | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 13e0b48d1aac..aad1fd9794b9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1800,7 +1800,7 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	if (req_ref_put_and_test(req)) {
+	if (req_ref_put_and_test_atomic(req)) {
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			nxt = io_req_find_next(req);
 		io_free_req(req);
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 63982ead9f7d..0d928d87c4ed 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -17,6 +17,13 @@ static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 	return atomic_inc_not_zero(&req->refs);
 }
 
+static inline bool req_ref_put_and_test_atomic(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(data_race(req->flags) & REQ_F_REFCOUNT));
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	return atomic_dec_and_test(&req->refs);
+}
+
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
 	if (likely(!(req->flags & REQ_F_REFCOUNT)))
-- 
2.48.1


