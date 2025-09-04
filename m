Return-Path: <io-uring+bounces-9561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D99BCB4425D
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 18:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A3B51C83E1B
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 16:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10492D3EE0;
	Thu,  4 Sep 2025 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HDP/MGHN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f100.google.com (mail-lf1-f100.google.com [209.85.167.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB84279329
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757002349; cv=none; b=p9/8m3SCesP+HJn4GoGEG1XZ0SA3bo+GfqgmyDVxs0ZdZrWGwBj+stldMjdAG9xLDLknYAjKQLloQI+aho+g065jTuxQfub8ol/yf2PB238/rjzb1QR+xpR73fAO84YTJ81Hkseg/h3j3ClGSehAkQ/Ux6tQLx3PSEA0LQKjljA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757002349; c=relaxed/simple;
	bh=9FnvyBaQhgL217zbtYg3CJx4Xsf1/txFXu0ygWQeOfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=epKKhzWZWjD/L1yJwItpcU9y2520GTLt1BkTTXk8sl+xHr3rJSa4BLIa1tGv0DRWUMoBNtukkM3UzM6DWKG7tKpWR270k5vtKSeUcr4az+Tpr9pifzVaz6NfCEU1Yznjxd29xAFtixfD+YcqlFeK/TcVJz503WXUv65ncp0ZNug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HDP/MGHN; arc=none smtp.client-ip=209.85.167.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f100.google.com with SMTP id 2adb3069b0e04-55f7be09db9so262278e87.0
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 09:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757002346; x=1757607146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsxIwM3/sFeVcWsdnOzOxmcx7zHrThhqU6pbaZl6QQ0=;
        b=HDP/MGHNzM5uuWkLmO/MiwvzakhReddfXfV+xYctSUq9JpC53jv7JFDnWfkoM66Nir
         /lb/FR6rYZwwY/b/47IeenUTBcoN2zWzqKHak4Nb9fb3IEPd5ivRIAcWc0Vuklxe5bbH
         +RRAUG/kdSuyN9ilBVL9Hx3OYcpJ+xO2yoI44alIqw4mz1H9fxK8GaBD5PgkTviliIbT
         KgmDJ0TRVM9qyRFumgzG7RzqlxpOfL7a5SSIKCARNft0CWsQLllvjSuhFck8FsGuBkWZ
         HRBK1Dsf1XahgKTmcmVPgdnhdMeOjceGq8tp/IyTSx8z1PNpnb5bwgMKmaW/5iDoLpOb
         dHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757002346; x=1757607146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZsxIwM3/sFeVcWsdnOzOxmcx7zHrThhqU6pbaZl6QQ0=;
        b=dTUczw1xTAADxXOyT3o/oFy5RW9Ac8HRZlZ49lD43P83GVUcBlcnO/ZRy84qZ0vjJI
         TCY6XIjYWdsO6vGfRpR3vr7Sf3yfv+1fZ9t2Tccq5tWfBnY6YwG0KoHj6517/Mc+Oh7U
         rlWfe2mLfBenDmxm9qe4YYKUwhl+4TtxrNYQeVLNjuOyNxtSQ1pRTJAbFsU1lRmU0b4x
         lcgcGY/FkQArUY2wfcdhdoTQy7B7pUDoekmQFr++2pjHUIUdQ2muD3o7asNAxbWQe0Lq
         8oG6OL3tR9VBzUL6kqp5Aa7vp31odnJXXIcgF9ttbJKJ3heipPuae/FIkU2v99sh9YFL
         MIDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLkZ7HZA3v/++bNM9w8DcZEUp/0ovXahQZ+q/5o2ygPMI2gqregtbUMLMFfHquEiaN52V8bpg3VA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCUAVWHeo5w529i8Qs1Xkwd2TVOF6ag3ikjQZALTkyv7rS5lMd
	U576upgDX9y7IfVE9BrDlSeSZGbQp3hXLv8kf1cqJhHpTaAV810EwqGoW9h+2EjWXQ98TrO5GH5
	16a6TWaw2Ylulua39tDcdbAVCq3epQf+o0R8TenR/l24TYjOo/5wu
X-Gm-Gg: ASbGnctxI5JiU8ZAujC4h7jB+TGKugzrFl6JlDuBHDGEu/4kPETQaOEsGXQGEcMnxHi
	qpIpJ8AKIjHan2JL53s0d5+GVvQF7Ud65g5DHk1ZdiXji1LGX4LdkCrIPovOp/dxiFpz60KTZX1
	R6lI1psfFysk9k7dzG7dc89xgxDa6lYrcz/JGMPoKy65f+mCfLiDGe6KKCCp1Yvv8dghA7s+Ig6
	l7TfDH9gzmE4MaHOoN4aDB0H5UtHWqUokKN1BuuLqiSziqEVfuwZ8U8I/RDiEU2t3+1LCoziwzL
	RFa2mD65dPLjeBXk8PqVSK3puq0aZGyGKWmNi5eAM0HtYxXHRyrvpPabXQ==
X-Google-Smtp-Source: AGHT+IHMiLSuXrxqntjfGGMbldL9ObUKGomVHhB/Q3Gky1ZLsT8NCICYAWZyHvIuOFfxm62c5xVvIsEoODyH
X-Received: by 2002:a05:6512:124a:b0:55c:d7d6:69ae with SMTP id 2adb3069b0e04-55f6b21e202mr3578815e87.10.1757002345650;
        Thu, 04 Sep 2025 09:12:25 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-5608ad4d44dsm1002087e87.64.2025.09.04.09.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 09:12:25 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 11533340647;
	Thu,  4 Sep 2025 10:12:24 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 15EB6E41920; Thu,  4 Sep 2025 10:12:24 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: remove WRITE_ONCE() in io_uring_create()
Date: Thu,  4 Sep 2025 10:12:22 -0600
Message-ID: <20250904161223.2600435-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need to use WRITE_ONCE() to set ctx->submitter_task in
io_uring_create() since no other task can access the io_ring_ctx until a
file descriptor is associated with it. So use a normal assignment
instead of WRITE_ONCE().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6c07efac977c..20dfa5ef75dc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3889,12 +3889,17 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ret = -EFAULT;
 		goto err;
 	}
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
-	    && !(ctx->flags & IORING_SETUP_R_DISABLED))
-		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
+	    && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+		/*
+		 * Unlike io_register_enable_rings(), don't need WRITE_ONCE()
+		 * since ctx isn't yet accessible from other tasks
+		 */
+		ctx->submitter_task = get_task_struct(current);
+	}
 
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto err;
-- 
2.45.2


