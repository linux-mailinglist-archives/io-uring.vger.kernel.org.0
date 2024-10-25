Return-Path: <io-uring+bounces-4036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EF09B0540
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38E2D1C22764
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2631FB887;
	Fri, 25 Oct 2024 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IEYxRep5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA6818E76C
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865651; cv=none; b=mQtlgW/Z9zCQ+xyaqSGh4EPneOs0U1fxTdlxhJH5rDhtBZC67sXbJ/dq7hPOhop9Blmnp++mjEm+EXY/ZMAznDbhO34NrXcUofReAsCL4m8JgOrSI3q8vHwIuXkCmvPGpHSoRsjUF9ycN+UTIKpOerac1C96Ch1AhEJVv6JKif4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865651; c=relaxed/simple;
	bh=1/3N/TaZdaIixqzMewgYD2v4MkCzC3PFbFzzJvqemwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNejDiXIj0utaynGFUzbTNhPZS2cQsLw+rQzHbO171B0dx93bZu2mBvQ1taLSYHfPLjEyy0GRPxjqLhU8H2/w3E+wheihH/pH33VxTDALSNItZwhRm6QEyZ1yOO43UuTDuXhA2sb5uwUjQo26T/Vei2ISb40T7sJ2slsIvV8hxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IEYxRep5; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a39f73a2c7so8784535ab.0
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865648; x=1730470448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnvYP8nCvgPpcLvOgegQl4kPLrKF64NfQHj1rP1I3JU=;
        b=IEYxRep5w3NveqIOLJXgPrDYxC2/zphBdd3t9dBG0ERSq4/4nssyalRltnYWYOMZHQ
         uDCgmDMqryav0lpa289sZMidV38YKw8y+wDUvMtEyhfhXgHbGhKbrLLeDDIklLHvGxKn
         nLj2X4X2xTX+ywzDL/PpgpEskXDnzRe44KqEFirxidxvofsoz7PF8AVX/mTf7o6Tiefh
         vnojHztOgLqtWfUnJ75GM7DKUt8lSrQ6L2Wpm0m2W76OTBvomL/ci5NFitywNUOSZ5Mn
         XhESoRS+HFd7Mzru63Bc1UWjq8z5vSABDDvIOCslgExdWcCfPD+n9K/JjLUz5KMsav7t
         jOtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865648; x=1730470448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnvYP8nCvgPpcLvOgegQl4kPLrKF64NfQHj1rP1I3JU=;
        b=hvfgbN0B7fYR1V+B5CCorvbc93zm75bClCcUtKvxrqS+lBqkAgF8VXJsAb/vzqYT0D
         Yq49Mv+d3DitB5XeBExZ7QzXB0HUz68d5bk2b3w5c6+SKLoxEShYbCgU8KZGeHoBNAL0
         t6UcdiDBOlSg+CItPdPCNBKVZ86d3Fxm+g+oIaoGZIRNtO0vHX4lJY8j2UNQeDrUWglm
         E45NHGf+pcS1yAmuaFeRPyYdR7lotuH2nPixc+aUSl52duszReM+Wo4We0hFhDspbnX8
         MQdtvGC4KalePsdKwPhNc/cUtkIugPMwYS5d4RDt/88rCcAcEBB5HqQXVLVjJO/VMCo1
         hBuA==
X-Gm-Message-State: AOJu0Yxafxe4P498qGzr9f+wCNauKyYweKGpocKwQvcrDIv/LFW9CmP0
	TOm58yv0au1mVZLqvWRnV8x6XBRBWoKR3mUrnDP8L+k9CitkJHJQDHRawLgzo/Q8tVScBKX5Jce
	C
X-Google-Smtp-Source: AGHT+IGD2qqVsRA969wfOwd7OboIh9jjNNvNfr0M7AP6To284FKlplee5rPKiWv0ZRG8GOHQdqaHEw==
X-Received: by 2002:a05:6e02:160b:b0:3a4:da0a:3767 with SMTP id e9e14a558f8ab-3a4da0a3af6mr98399155ab.17.1729865648009;
        Fri, 25 Oct 2024 07:14:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb673sm277292173.16.2024.10.25.07.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:14:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 2/3] io_uring: change io_get_ext_arg() to use uaccess begin + end
Date: Fri, 25 Oct 2024 08:12:59 -0600
Message-ID: <20241025141403.169518-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025141403.169518-1-axboe@kernel.dk>
References: <20241025141403.169518-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In scenarios where a high frequency of wait events are seen, the copy
of the struct io_uring_getevents_arg is quite noticeable in the
profiles in terms of time spent. It can be seen as up to 3.5-4.5%.
Rewrite the copy-in logic, saving about 0.5% of the time.

Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8f0e0749a581..4cd0ee52710d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3240,6 +3240,7 @@ static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t a
 static int io_get_ext_arg(unsigned flags, const void __user *argp,
 			  struct ext_arg *ext_arg)
 {
+	const struct io_uring_getevents_arg __user *uarg = argp;
 	struct io_uring_getevents_arg arg;
 
 	/*
@@ -3257,8 +3258,18 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	 */
 	if (ext_arg->argsz != sizeof(arg))
 		return -EINVAL;
-	if (copy_from_user(&arg, argp, sizeof(arg)))
+#ifdef CONFIG_64BIT
+	if (!user_access_begin(uarg, sizeof(*uarg)))
 		return -EFAULT;
+	unsafe_get_user(arg.sigmask, &uarg->sigmask, uaccess_end);
+	unsafe_get_user(arg.sigmask_sz, &uarg->sigmask_sz, uaccess_end);
+	unsafe_get_user(arg.min_wait_usec, &uarg->min_wait_usec, uaccess_end);
+	unsafe_get_user(arg.ts, &uarg->ts, uaccess_end);
+	user_access_end();
+#else
+	if (copy_from_user(&arg, uarg, sizeof(arg)))
+		return -EFAULT;
+#endif
 	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
@@ -3268,6 +3279,11 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		ext_arg->ts_set = true;
 	}
 	return 0;
+#ifdef CONFIG_64BIT
+uaccess_end:
+	user_access_end();
+	return -EFAULT;
+#endif
 }
 
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
-- 
2.45.2


