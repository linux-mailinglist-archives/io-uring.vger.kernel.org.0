Return-Path: <io-uring+bounces-7082-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C399A630A7
	for <lists+io-uring@lfdr.de>; Sat, 15 Mar 2025 18:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE5BD174F66
	for <lists+io-uring@lfdr.de>; Sat, 15 Mar 2025 17:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4385C205AA4;
	Sat, 15 Mar 2025 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="mUmkojfm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CB22054FD
	for <io-uring@vger.kernel.org>; Sat, 15 Mar 2025 17:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742059440; cv=none; b=efbc9RRGEFFEROqawZ0BIoggjFeQQg6zO7125v6auTv9iOrBTlj8PDZrI7mzuDmn1Y/Xn56O84AnZtje+eG37yxnuLIja9++SmsoVyZVUMIqXZpvaPKLwePC5JomvLX+NGA2nWz+pndzOf9oVtlBncG5GsEAL7eXShAApguvqn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742059440; c=relaxed/simple;
	bh=1PpG5wl2vDgUXZOFXh86OOBxn7Ar5lt5SQ/Ndxx/TgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hirDUwYpSuwvvFlbFiV4MJc9v4BjcSN7hHW9WyON0t6wtE9CBFnFlLeUmyZUA31xXmtKf+svzW0UturDa+CIaRp2wzUG/9k2UhLaYMcmZf+0unhz4tnjU9XHNPuIJpBbDsF7HPoxpnHNOy+koq4/TD1JeGukhVC+ULdIvaUBy08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=mUmkojfm; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22580c9ee0aso55066455ad.2
        for <io-uring@vger.kernel.org>; Sat, 15 Mar 2025 10:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1742059436; x=1742664236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgnlVIlZsctNY//AQHA0xHAjDyuSTMqzdv7gveBxpzM=;
        b=mUmkojfm4Jcb/yjrSlX2/J3IyGZbInyaXOMqgP5/oLof8lIGSJ6HRoZYeRiONfI59Z
         3OUXxBF4sXEP5gNPrld/1Y3UHULZ1TDJMruTeE1MCvgxkezjiAZUwrx1Wnf+L1TFW+ck
         fm/9ETpKMv45bMHzQdBToCzTYB0vqCiAVPeMNsC97JjHw7SlWWjWQTHvne4SlXIrGMbK
         KHxkekftWCtvV54bCCcANpfDL7krEAUXaiN+JluQ8g/KRgPm4H7o+zwDectpzfSg0WQW
         aNk65GGodAy0tDCRBmoEUYj/YrMMKj5CXJtYZBmUGlTsYyeHP80MqNeUQg8qDYmUIAW0
         yytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742059436; x=1742664236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgnlVIlZsctNY//AQHA0xHAjDyuSTMqzdv7gveBxpzM=;
        b=WiJTpqYvrArXlQeGwd1fKp17mhaGhFcJMcaXj6e0m6TPHdXbpShyTeQmrfI4Hy/MQi
         EWbE5Zzbi6jVBU7GBLJUMQRoBzMWSrFt5VUNHIVPonX3IftHcJhOCjHLQsdtvyC0ZkHS
         tI52LYdHkQuN9ZM+9JfLP2GvS15OMIC4ti8efIwMSuiWX0ZIgEl0EA1lRfh+g4diC/7O
         HK52efTmnaaWu7D2N9+S7k0W9zNvc/uyiHZflAsH2PmudEoNMUFSwc5cxgzBCPPwqkvY
         t+sQ8QlCPWDB9+EfnwiUDSiTNXYn7y1GnHYI0by4N1ZsXx+n96AI1ElbXg8I1USjSm44
         SxOA==
X-Forwarded-Encrypted: i=1; AJvYcCWT3a7vUJ3Mbl7r02O+rsd+yanR7acv0cCAp3JXPnozC8AmC+V1u5bhQCgc4+BQph6Jy78pzwKXtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn4eC/PnpjpviTZUzB0Yj+AQS8Ms4ilVqYwVYbcPF8CdeZlkTK
	6YCOoewm27J94/LFnTk1CZgugfDNaBmr3coXSU6Ics1AIqJVqqBXRPdgCQtUO3A=
X-Gm-Gg: ASbGncuE+5GzJrsIm26PsCcd+X3E1BfbIt1xrAjEWO4INUcQ8KvYX1dgZx1200cUpT9
	R9LYfCqe18FXNIBDIVnuWIKBkfZNasdFYm2HbaaOMvz8pvYmt0AdKDAB4rroHxeleAMo1Wu75Sz
	Px4uRMad5X2t1MD1rawheH5po2PO2AWW2vw4UohqzAWOv5HNLhuYiXGH39lVXncdnHdSOgUkF2Q
	uBO7AI5hotPolOEevISJonFiBzUSqge6dioUhM8U02j1A79aZI2zCMdlLGspPXCImK4UI+56qxa
	XAsqhUyNSxvLTA65RIl44zKLStAcZtAtJRCkiGFsIg==
X-Google-Smtp-Source: AGHT+IFCDUOQgEkaQUJPOtUek3RyqU4kZwZOL0TnYTplGs1jgZy9U0ZODBK3dFkuMeQxYadueVihlA==
X-Received: by 2002:a05:6a00:13aa:b0:732:2923:b70f with SMTP id d2e1a72fcca58-7372237712cmr7727611b3a.11.1742059436632;
        Sat, 15 Mar 2025 10:23:56 -0700 (PDT)
Received: from sidong.. ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737115512f0sm4673013b3a.49.2025.03.15.10.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 10:23:56 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v3 2/3] io-uring/cmd: introduce io_uring_cmd_import_fixed_vec
Date: Sat, 15 Mar 2025 17:23:18 +0000
Message-ID: <20250315172319.16770-3-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250315172319.16770-1-sidong.yang@furiosa.ai>
References: <20250315172319.16770-1-sidong.yang@furiosa.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_import_fixed_vec() could be used for using multiple
fixed buffer in uring_cmd callback.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/uring_cmd.c         | 19 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 74b9f0aec229..2c7ae8474a56 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -45,6 +45,12 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct io_uring_cmd *ioucmd,
 			      unsigned int issue_flags);
 
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uvec,
+				  unsigned long uvec_segs, int ddir,
+				  unsigned int issue_flags,
+				  struct iov_iter *iter);
+
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
  * and the corresponding io_uring request.
@@ -77,6 +83,14 @@ io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 {
 	return -EOPNOTSUPP;
 }
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uvec,
+				  unsigned long uvec_segs, int ddir,
+				  unsigned int issue_flags,
+				  struct iov_iter *iter)
+{
+	return -EOPNOTSUPP;
+}
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret,
 		u64 ret2, unsigned issue_flags)
 {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 315c603cfdd4..e2bf9edca9df 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -267,6 +267,25 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
+				  const struct iovec __user *uvec,
+				  unsigned long uvec_segs, int ddir,
+				  unsigned int issue_flags,
+				  struct iov_iter *iter)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_uring_cmd_data *cache = req->async_data;
+	int ret;
+
+	ret = io_prep_reg_iovec(req, &cache->iou_vec, uvec, uvec_segs);
+	if (ret)
+		return ret;
+
+	return io_import_reg_vec(ddir, iter, req, &cache->iou_vec,
+				 cache->iou_vec.nr, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-- 
2.43.0


