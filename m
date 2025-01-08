Return-Path: <io-uring+bounces-5751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AC8FA05FB3
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 16:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08E60166530
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 15:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FDE15E5B8;
	Wed,  8 Jan 2025 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gofRoO42"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04491FC7F1;
	Wed,  8 Jan 2025 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349092; cv=none; b=YXrqcUSJrhKYIL8r8yHLlymX0UG4ams5DrIovbXWgCR7cUrwT6Spmi6d40djjQ+06HR3I+u5a0euY7mPq2aGusAympzu7d0LKa6VPQ9RRWST64tO6Z6qngekfE2bey22A615ytDzxUM5ueRW52B9YkLYq2iKossSp1BzDZJ27uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349092; c=relaxed/simple;
	bh=KTsp/tV3YPsfXDpwRBor5ImA0hPArukZ8JeDx2l8lB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O/5qX9Cp7/1YUU0/ZZfFLibIkE8YpkzINkt+UU1ZXjDdnqAcEQDWiTwCSAYOnHwkZQqVm05zyXqh4Qbm5BmZoRoAcQsMUU7YwaGIxPsa7l9Y/fmXdIaYAmGQ32uCprJwAJ1K8W7HHm5rjGme9ZpiiPOcGk1xD+AlYJ8wrSJLVQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gofRoO42; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21a1e6fd923so1032685ad.1;
        Wed, 08 Jan 2025 07:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736349089; x=1736953889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iSbK8QkAl50gexJ4FOFV1wkVyHKU7FzwWr05wKflf2o=;
        b=gofRoO42SlxzBWn7c9/V+3gC4KaDEgjp5rxQawk7krsnzPWPrzx7voEc5Z9W8qyz8/
         tgf0VYcoFtRByubiuzO+geZdBWofODGxjEvFeE3c8ee9E8/KWsBPIfCg6RfuEK72Eu4l
         CdcOM/TtQP/lRXUEqna8ghUUcVz3UQyma+oUBHokTQpJPmLszHeM8j/68925a3vNBeQ5
         f5LOtTo0t8FicLYDyHmggfUdTbPzm2AxXZ1JbOCdlmh1fsBhbO2uJ/VVKgJ5o6ByvU3j
         Qp0a3iFUjh2nU6ZlFi1KL2XaSYGWMWNY7/L4s34xrs2KC0K/vuVwccUVJBESyrxmYMLV
         kDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736349089; x=1736953889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iSbK8QkAl50gexJ4FOFV1wkVyHKU7FzwWr05wKflf2o=;
        b=Az6ktUDjI6XqS+8QyO7ugJfeavbboo+6yFt4LhYxII8sARYzlbe2utJu5YuNNWrjCP
         BqZon9k2WtBrjsIlc0PUPUdbI2ZWndaV/oSztTRU57Of1X7Q5dUGMeo8p71dg+SKUiPa
         1BkNgjeCyPrPmS0D9q40SnUnHK8nI7IqwvuFhY4Rp7PU7X+3KstzEUfv6CoM/2BnZpQL
         BTqER3r2XX0Bu8G/+F0t0xC0T55P2KpgI3c1418plB24Udyp0Vn3dSk2PxsD+1R72NcG
         RGH9STCAQPUpYhEIqfzWdok9aqXD+YDz6cWUv6HkvkXaKHb1IDkk8/aSq6xT8B621dL7
         bwTw==
X-Forwarded-Encrypted: i=1; AJvYcCUye6YaOibHU6yfwWc+dmUEAdrgRco6KIGmCjw77/9GbyeXmYU6o2r3CAPNcrl1w8QINrVGe0uwTw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGEpjVddbngejDLY2wsDXEGBeF8cITtIkBoQWIRkC1krJ0OMBN
	zKHW5aAJNvmOXBXFBgFs8Kn3RXhnSzTUUoHyL6kiXEuRKjuusg0Pr7OdreHW
X-Gm-Gg: ASbGnctiS0boEBO9KIjhs/3YqYvv6LUxcSFkfLzeXuiuTqgQyJcjOqWKzuiE6/liZBV
	r05PAGTfxfFBHrxVqBSDWhes9W7LtaMsNufrart2mzo6or1N02xTt5QJOrYqrCOpZ6Aaekz4Niz
	4iDmj9I0DbKQfK+3q74nqQFNc9a07QcOufgZ1Y1oh+I/uj9LRIVH6by+/tI5c2HF5ia0ueN+thH
	HdsphlT/yiKDDii1HPXYFoZQF+Rh6w3jXICcFCX/phSCTR1UMa19Ii+2g==
X-Google-Smtp-Source: AGHT+IGLN+CleE//JmLu0/bx32Cw4I99p6cNeyFOUJ50KYmr9Ruy8KPBsIp4PIDwNpG47j8uPJYn7g==
X-Received: by 2002:a17:902:da87:b0:215:9642:4d7a with SMTP id d9443c01a7336-21a83da6a40mr56353865ad.0.1736349089306;
        Wed, 08 Jan 2025 07:11:29 -0800 (PST)
Received: from local.. ([2001:ee0:4f0f:f760:15b:fa4:b44a:9b06])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-219dc964b84sm328731865ad.50.2025.01.08.07.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 07:11:28 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com
Subject: [PATCH] io_uring/sqpoll: annotate data race for access in debug check
Date: Wed,  8 Jan 2025 22:10:51 +0700
Message-ID: <20250108151052.7944-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sqd->thread must only be access while holding sqd->lock. In
io_sq_thread_stop, the sqd->thread access to wake up the sq thread is
placed while holding sqd->lock, but the access in debug check is not. As
this access if for debug check only, we can safely ignore the data race
here. So we annotate this access with data_race to silence KCSAN.

Reported-by: syzbot+5988142e8a69a67b1418@syzkaller.appspotmail.com
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/sqpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9e5bd79fd2b5..2088c56dbaa0 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -57,7 +57,7 @@ void io_sq_thread_park(struct io_sq_data *sqd)
 
 void io_sq_thread_stop(struct io_sq_data *sqd)
 {
-	WARN_ON_ONCE(sqd->thread == current);
+	WARN_ON_ONCE(data_race(sqd->thread) == current);
 	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
 
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-- 
2.43.0


