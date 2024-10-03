Return-Path: <io-uring+bounces-3389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE6A98E77A
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 02:02:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0E9F288385
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 00:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBAB139D;
	Thu,  3 Oct 2024 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="SkGy6c44"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8AD63CB
	for <io-uring@vger.kernel.org>; Thu,  3 Oct 2024 00:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727913733; cv=none; b=jIIhwduweNvVYtbK8lhfuLXmbWNT39L8pjIywtliUt3x5wYi9O7Bc4F9CJAsXKjJ9vfJP42o5LPHqcNUyqGmMxYJTFPbbcRnpcSuy33uZMMHV5IfkQiAHuXQsdmdACu6b8Fs07ZOstF+/ZE0aq0cjRU6blljn2F30tG1YUjFmR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727913733; c=relaxed/simple;
	bh=6NPWw/CwhT6stwpwgGQLJZMGtUYO8CUPhinPfjIKY00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tUR7LKsuzgO3w5FM4t8kA6/20NncD6ezbG4Isli8FvLB/5ywUqqFTVcrCC9ImoHpLTPUSMvckbHpj4AYFu2pIV33ZLbhjpRJKOkDiDVknGskbBSBrVZKYim2/kfrZwlyqwj5nG86BKhcoDec3oYIuh3fHMU66JlYZeWkLNdRMXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=SkGy6c44; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71b0d9535c0so312731b3a.2
        for <io-uring@vger.kernel.org>; Wed, 02 Oct 2024 17:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1727913731; x=1728518531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LyiYacsCSRJLUh/wWWkp9wksysS1oV0+OGb2ueD0cEs=;
        b=SkGy6c44+BneN5H1L61WoG+03D/4T8ZTC+TnyOJUw446KU3MaS5yN9nSG2HVF4mGU9
         xp5HC0t+U4W9W5uF7dxRZj+e0XsiW+3Wux5r3AmVSVo9dIphckdS8eYVN4cULFKxQwfO
         Z8rrznM8tuTr7RAOcsg9CBTgll79WEM19SZXSsuSW8oe34tYAonZH2swhVUX8pxQ1DCr
         0N1n/nSNpuxnnjXYUtU1L0ssv2ZIPkwu5ByTFhmCX6vbfqS9Pa4LUoy6ZWwLpNfMEhOj
         QgAthQheV/SWGVEVC6RGfHi1H44jIgoS5vSYOF9RE2kvEd+nFTT/b9ySB0qm0o2fWuTO
         898g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727913731; x=1728518531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LyiYacsCSRJLUh/wWWkp9wksysS1oV0+OGb2ueD0cEs=;
        b=pGSs0OZw2xNEwRfvs8u/4ejO23zJqkNMZtZPf8dq/jCFUOLNLB2zxZMLSo2LxOHueX
         tu1cxchwze97exqN40fuVGfQgTUS3EUyO9GbnC4Wg5MuCC/mkvHuCzCsvEvVZtZAnRtQ
         gChqq3Sh8vT3LKlC8qvbqUYgVEXRvoFQ8CaAiIJHXIVMFks7KVvTq2azTWpaBfkDoXBR
         Qs3/G2rvegJKAXHWshDhbyNeN2dCdM4gv4cGJoszoUnptH/I6WPXh8kERfYWiOKKg/g+
         m/fVopGt1Od/5SUfrtfitiUt2OUPolXvS4jbLp9M9v4ak6HPQEnbQH2/rBQMC6fE4M8q
         WYPg==
X-Gm-Message-State: AOJu0Yy+S6CxMQmm7vOYKnnYMBp7GqEBjPiT20BQYX2X+UPLzijaZll/
	307j1MfrMnWVahRVMi5CxGpAJHrfep0DnnUaVY1sEU/1IDZc1ThWEMww+Z4XfSr4L4pQer6WNQu
	p
X-Google-Smtp-Source: AGHT+IEuEx+1UmEwmiCip3IPuwjWmWJ688Bo2iYrIaSjuStPG1CKZ9dnRSclB9wLTmMCwkxKjeM/4Q==
X-Received: by 2002:a05:6a00:189b:b0:714:2069:d917 with SMTP id d2e1a72fcca58-71dc5d71757mr7925413b3a.25.1727913731322;
        Wed, 02 Oct 2024 17:02:11 -0700 (PDT)
Received: from localhost (fwdproxy-prn-035.fbsv.net. [2a03:2880:ff:23::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71dd9df0b50sm57127b3a.171.2024.10.02.17.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 17:02:10 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing] sanitize: add ifdef guard around sanitizer functions
Date: Wed,  2 Oct 2024 17:02:09 -0700
Message-ID: <20241003000209.1159551-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise there are redefinition errors during compilation if
CONFIG_USE_SANITIZER isn't set.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 src/sanitize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/sanitize.c b/src/sanitize.c
index 46391a6..db5930d 100644
--- a/src/sanitize.c
+++ b/src/sanitize.c
@@ -118,6 +118,7 @@ static inline void initialize_sanitize_handlers()
 	sanitize_handlers_initialized = true;
 }
 
+#if defined(CONFIG_USE_SANITIZER)
 void liburing_sanitize_ring(struct io_uring *ring)
 {
 	struct io_uring_sq *sq = &ring->sq;
@@ -174,3 +175,4 @@ void liburing_sanitize_iovecs(const struct iovec *iovecs, unsigned nr)
 		}
 	}
 }
+#endif
-- 
2.43.5


