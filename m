Return-Path: <io-uring+bounces-3881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2EE9A95F2
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DB1E1C22302
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA15E5B216;
	Tue, 22 Oct 2024 02:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RXf1kqKS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF0E126C14
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562680; cv=none; b=itNSOYkPnkVLggqxF9nNfiSZKgs7LBYS9wk/D5Pg8VuE3kRiAsDx9Rj7jt/Sn80HA5qLiEzEPJkGWKz1IjbiID+cJw6WhVY5+Mx729T2LCoWmPhXkcWtf1U6PqwvMdgdU9eqc8ik/f318PYbxFqkbkHFI3RcnW3EmJjxeBvp3KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562680; c=relaxed/simple;
	bh=xTsMZ1NscutzFx3vj+pkF7qRllj0ph1Ef4bK3IFUMp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8wsGHeKEo8xdiKPP56WCEExJ9eFl9ch5ZiW/MceJaCfoiE6jkL60a+cS4Rj0At9dHP3c25IPMeysqcflMBFGad1Hj1GNQqUmY1ig+egs3L7cMRv/dk/5X8v5vJslLjsrYllQGwNPb1viV6eFnSaurEo892ig+R/82a82DmBi6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RXf1kqKS; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a3b8964134so17593405ab.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729562677; x=1730167477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBSkbQIxH9wsbcPCiHBwUytG72Sft1sfvVnb0fwF/aM=;
        b=RXf1kqKSsI4VlIJJwPb0WM3YwdE3ZVUe1EadFC1kiXnciXrxKzYpPkQ1KfHNrMs8c3
         VZDWbvzXgNKoSHjZ55b0rvUOAtzA2iXlW0hyONCjiwFys9X9/xirfEodTppuvc+ZIvtI
         BzvNV4OMdKroRuh6UcrKWT4ouOsvvj/qCqvtCI0qYuQQcoJemTa8VusNwQJiUmZHXmnF
         MGwui8TSLgEmthJ21F//6bQl7xHoIzAkcjfBrYAI9/GfC+95dbUwsvf28pI4zTb4RodL
         f5jv/4UEHnkFKRnQ+TiIx9cYZ/aAD9QXbuaPCtKWJjjMdIe1375/I+wfvzY9zZJS64t8
         PCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729562677; x=1730167477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dBSkbQIxH9wsbcPCiHBwUytG72Sft1sfvVnb0fwF/aM=;
        b=XRrVhlOIyuqaf4nsSMyON3URDarOI7KSj3z/byOnKFsJTRhpy5y3gVp7y7tYsIRoGA
         wKRTIxTCcYK64FXXZ2Z6rY8ScyagVVPoLgB9Ti2QsDrSJcu1dGcGVuPXaxDIC4w/3HOo
         6NV0QKe/n6k8dm3ovUd1+qiVMuR1EN64QjsvImrXzZl4Qmin+UKNRO6oSsf9PpcDqxh1
         zeZHdOwz1Y/m64EDsSffTOJ2wHoALqDXBTXTBtoT74b1OocdXap4PgPQb1vk2Jb5F5O3
         Rt8gyMC9braXE9Op3UCgILjI3Jembx5vAUlWKMhxwkQzJcE8YHWzVlFD+zQ/S4FqJv5w
         kwbg==
X-Gm-Message-State: AOJu0YxqzNvNIYJEobpHgKUQ6M9mvn2/TwUouwSKrlV3zIUv7/bleQ8m
	vAIp6YFd3sy7lNmUgAuNxtTcq9GsZtdiuVN9zIU5D5wp4XIkBzdYSLlrk8WqYmk09V5DQPrFIAz
	b
X-Google-Smtp-Source: AGHT+IGSHjHnrpmOhVVs/uuCYiDkh8mJ+mi+kXUMX7Lbkgfxr2ZL9NATjI2P7bpojAkT02PyD56JHw==
X-Received: by 2002:a05:6e02:13ac:b0:3a3:b254:ca2a with SMTP id e9e14a558f8ab-3a3f405435cmr107364905ab.9.1729562677587;
        Mon, 21 Oct 2024 19:04:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab58820sm3845534a12.52.2024.10.21.19.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:04:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: kill 'imu' from struct io_kiocb
Date: Mon, 21 Oct 2024 20:03:23 -0600
Message-ID: <20241022020426.819298-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022020426.819298-1-axboe@kernel.dk>
References: <20241022020426.819298-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's no longer being used, remove it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 391087144666..6d3ee71bd832 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -613,9 +613,6 @@ struct io_kiocb {
 	struct task_struct		*task;
 
 	union {
-		/* store used ubuf, so we can prevent reloading */
-		struct io_mapped_ubuf	*imu;
-
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
 
-- 
2.45.2


