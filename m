Return-Path: <io-uring+bounces-10740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E13C7E88A
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 23:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5F814345225
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 22:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FDC27FD59;
	Sun, 23 Nov 2025 22:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExMtn78q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946827FD75
	for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 22:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938309; cv=none; b=Kd9TjppGYgIrqQo3yrMhgqJMzxrNXv926gZ+wSE+FR0FARJTml3SEJ3ySRFqJKr/5agCtBC2O7tUdOg7JA6PhEu5InKlCFnBkYZG4iha8JwLptwFfA9j5gmTZK3U6l6kXdt4OJEvu/HOxiy1/RJ5WWyo4BoEMR90Vfddnihl1xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938309; c=relaxed/simple;
	bh=2QAhGEFKNmLFH3rV8w4M1xXti7VQ8PITqhdQLrQ5sfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrOs1m5yTAUvjtWynYbTxpcycXj7u/MoOoHY5uTBycxMbE8kpnH+qVdXxG9C0Yk3fJjIFGHqoEI2URvNDdVVI52XLlUVfxswDq7VECsvlwCId6uwEo67a0rkWQjYqiL2hqjrri68n2n3OrFNHHbtSBTzKvUswIMygBVSlQAMEGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExMtn78q; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so2269761f8f.3
        for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 14:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938306; x=1764543106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6fykkTkHS7qppZkkxaQlxQiAfIqxjHL5zv+seY74S0=;
        b=ExMtn78q7qR6pIUKU/7VGEUjfVV6bk4JomIs0V7n3OZ75PBi4JcasAliBmf1wTvoyx
         b92OsjRkMwvIJuHVXeRbVuryPNFAwkzKf4EGn7EO8szNtfK1k5krVOdZmS8No32ZESGv
         ImPPNTwX7bmkJ1IhqUNvIU76EZji1bIfOQtq1ljfyidK+oNXUJ7XWwa6MNxvVFiP8HHs
         B48v9HxDqE527c99oqmHROtvLt21uqMQkqSXO9ArUQjRm7NuOAtbNBiuF1oPNo1YAURf
         n7K4uaIjeMzrer6TJnVDiPQbQLbmf5Oe9zgZDmAiVIE3QFQMktiqlGywBqIateN1ldED
         3Ohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938306; x=1764543106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g6fykkTkHS7qppZkkxaQlxQiAfIqxjHL5zv+seY74S0=;
        b=mOJliPw0ihSYSFVloTCGjn4aFou55zdDbcjNJZYjyg6zAarQ9uYBdMjhvzDIavFjes
         LfWtDlJhUgHY2PI3KM63RvqEZZJ1MYJBlsVsLaEN7SSUyBL7xk/glRiLV8TaUhu3MDFn
         PJcPG/1OHKUiyaF4D6OADFp0+7ik+HsaUzV3LR6gbEriTY5ddXIDJ6pto6QY51Ov0IMa
         Y0SKlnw/BfFcGKFtn0sczgb4XgOpoVwT4rKlN2/tyexj9qzudS1qU5n/HjjivjqVjgSX
         GWjRXvwWo22XpQ+xsBF4kQShzmcTz51Q376IZW5rSYMgGMMyOts6vjFTL8DhSiAb4bGG
         91Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWGcA79EdsaKtv2DJoIALh9xehsq3Zh2PkiFNelvryMnTGa5mBoVN6o+NZ0FnmTG5gXKX0Ku4LgDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQVk50uGwIBs/mzsf5Fy9Iwh3mvm1NdcK6KvJBn67v3EGC07nX
	W4Mckwtf8dvW6ZzRVXu+pHvov387+sZpVwtWoqlezAIqncT7nZa18ADg
X-Gm-Gg: ASbGncvp09TtPuJfZeg585kIQ9mx1oznvWbOM+xXJK0vHhwlDi+zfKtbmVARcz4+/eM
	A6c9gNE7Kd9RCH/jk0qJXovLd5hPYnskPR3rU2aW89umbxzIfw8IXSvLiTaAAjfW8JJuDVoWLez
	WuL8KgvOD1YGD40R+/E0ghLWjN36rteBO+XRTpU1BGiOxaL4vYWxN79SUi7QCb8/AZMgWQlENMs
	1i0pBtfCPXTyDL7qriGvOimreBtM2jUpgCheQk2Q0CmkanR0A5QxFDpt0rtmN0efWbSWWav0fF3
	0LNkusQvwv2AhNfWFs+jwg06mpw+wFpVy9AugOHHTH7MTn7SL9SqUoFdKNyC4roNKLMfbaHbwS5
	3LkpXZ4kpaU96DU6p/pafdaSFrf0pZL+qpsASQMN8MoPDxM33jjECCtpeKymf8OIaw24fm20Iyw
	FbLdGAdcSPwHFFiQ==
X-Google-Smtp-Source: AGHT+IG6zETWdv1uNEXL1H7qlBK8rzCntcx0G5cI2YCnUx99f9VimwWWKVBIKAVqjQPLH9huSPPJwA==
X-Received: by 2002:a05:6000:1448:b0:429:d3e9:65b with SMTP id ffacd0b85a97d-42cc1d23c3emr9659226f8f.59.1763938305625;
        Sun, 23 Nov 2025 14:51:45 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm24849064f8f.33.2025.11.23.14.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 14:51:44 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>,
	tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [RFC v2 03/11] block: move around bio flagging helpers
Date: Sun, 23 Nov 2025 22:51:23 +0000
Message-ID: <6cb3193d3249ab5ca54e8aecbfc24086db09b753.1763725387.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1763725387.git.asml.silence@gmail.com>
References: <cover.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need bio_flagged() earlier in bio.h in the next patch, move it
together with all related helpers, and mark the bio_flagged()'s bio
argument as const.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/bio.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index ad2d57908c1c..c75a9b3672aa 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -46,6 +46,21 @@ static inline unsigned int bio_max_segs(unsigned int nr_segs)
 #define bio_data_dir(bio) \
 	(op_is_write(bio_op(bio)) ? WRITE : READ)
 
+static inline bool bio_flagged(const struct bio *bio, unsigned int bit)
+{
+	return bio->bi_flags & (1U << bit);
+}
+
+static inline void bio_set_flag(struct bio *bio, unsigned int bit)
+{
+	bio->bi_flags |= (1U << bit);
+}
+
+static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
+{
+	bio->bi_flags &= ~(1U << bit);
+}
+
 /*
  * Check whether this bio carries any data or not. A NULL bio is allowed.
  */
@@ -225,21 +240,6 @@ static inline void bio_cnt_set(struct bio *bio, unsigned int count)
 	atomic_set(&bio->__bi_cnt, count);
 }
 
-static inline bool bio_flagged(struct bio *bio, unsigned int bit)
-{
-	return bio->bi_flags & (1U << bit);
-}
-
-static inline void bio_set_flag(struct bio *bio, unsigned int bit)
-{
-	bio->bi_flags |= (1U << bit);
-}
-
-static inline void bio_clear_flag(struct bio *bio, unsigned int bit)
-{
-	bio->bi_flags &= ~(1U << bit);
-}
-
 static inline struct bio_vec *bio_first_bvec_all(struct bio *bio)
 {
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-- 
2.52.0


