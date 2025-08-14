Return-Path: <io-uring+bounces-8964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE880B27331
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB3F91C88806
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0132857F8;
	Thu, 14 Aug 2025 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+sUNacs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89911F582E;
	Thu, 14 Aug 2025 23:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215510; cv=none; b=IKh8iXwROu10KJTTMOOnmQ3kv72TzAp5HdXvl63bigH2sGrxSgjhEqzce8GqnkXhr+uBcwpienj248Xz7EpEGPcYdIiW/D/39diYtJPUj8W1PjWLjQppD9ai8GOUy4e9ezbjZCS4M9b/N5ioeAw+IBTFfzFU32dPkdvRXCIv4v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215510; c=relaxed/simple;
	bh=t8GEttSGCVJWflbyMII1FQ/++4I6ezLLmjYVDCXNA30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dskb3PC4z20uwRNGajrcV6Z/G+42Rgko5UXSOL/Yf0ZtuVCZj7Z4R1RFDESGfCmwA2KAkpZ4rmhlQY6Ni5ZtuagmV7PgyzR9cR7tvUEUhpY+Gd+To1ixUP5P73DHEQ0s0OY7vJaYBW0pxXQS/EObInRc9wy+8FemOO8AREJvduI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+sUNacs; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32326de9f4eso1484508a91.2;
        Thu, 14 Aug 2025 16:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215508; x=1755820308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIwZPfsZFMC2HIFAyWuB9AmeIpFgWKg0hz4WdMY9XTU=;
        b=h+sUNacs0cyveZGkVeaq+VCmfB0ZvH6ijRf85P/XoSso5KVQYMrTlQC3VhrXGnW0wI
         nspP9aVP8LYLZGtUIDqv9TC6v+/GORgjy8Dn3Opx7P51XNXSl9GSmsdP2TvXgJpQJiH6
         6wS++YndK25jxw9MCByjrIh7muNURV+ZOQZBxBRPhCSD0uzpjVbYkppxR6JeXo0ceNFQ
         +0Pt6X2cwXhi3UKGAN4Pnv97+jJg8u8VNjhhcmRopm98EQQ8ZgaYiXfUwrndivfUjyRV
         cPzbd33JhDVXA+Yrq5ofU4E51ZNY/0IlYAxn63ZZ9e/ufPTHnV+BxNTlAKLc50Z41upI
         63jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215508; x=1755820308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIwZPfsZFMC2HIFAyWuB9AmeIpFgWKg0hz4WdMY9XTU=;
        b=fWDfVXUXTP8fDJmjeSaArjorFsfzSO4ZHHSHTXHcA81QDFatnU3NwvYvPynPjiVVsL
         XPVvaQ9GFdOWkueRHevfFy3Z+4P4+79KWPotsA56mN7yBsDylfsILCRlww6psScpkVbx
         hPxU/pPL2/3Mf0CHkjnLjXh/vJYDIyQBBtOAUWLkg9s15YkG25B+O1O3UUmsX64/wrC2
         fpPtTy8hj19y498ukyjlzO4yaag7ouGSYi/JkgMkF6jsL/swqwKMmuo7ElrnvCDVhQuw
         pAK8rWM540PhmszS0Jf1oysCJudKcYPyB79a/oK0hDczqkG3gaEGmzf4aAmitY/p6RYK
         WclA==
X-Forwarded-Encrypted: i=1; AJvYcCW46XsCwhVJhOKAhfU+4kFDl5uj9kP7f52X0X1F/DkMnWpiffo8baH/vBXtSvfUNsyxlHzjvQ25Q6Sf@vger.kernel.org, AJvYcCWMci6vVdaL6ixbn9yf8+N8iH74CsaMOTeLofH429kTqe/b67cywqMnlEx2qa1aaYCP2Q78xREIaMwfyrS/@vger.kernel.org
X-Gm-Message-State: AOJu0YwkUdVDGTGv4kqybeLToeMMyVJGVLeM3FV1GLJQTtpEdda7RImy
	Zh1NBmAzSENCQYeFj77cIlfrmA+PqdjOGrl2Ytpd/igoOse+uqLMBMJQoBGZUAFJdLQ=
X-Gm-Gg: ASbGncvVoYV/k9JlvKPjFmthICB6WlkMbcSzOaaKi6QCrN/MZUXslmOVI8UUYXRFWE3
	FlkGzzzu0PRIJUZdh60wJ6FE0fX1ShhhkXucCwnjnvX/zUQDodY+tDd1R7d6uJA0p5OAGHVdqw9
	RGmU8M6rA0PTAkhQHHzb+4InSd1xKjF4lLcMNfNKByA+UpNqR8Q+AMVxIooyk46WUJPzZrirkHo
	yL5YFz2+nErDXpHIN2MyEkfKkgyp7cxDWSO9I18JcAZHpDW9M/WRif4WDbQd82vtmADMLB1XQk2
	zFkaHPzUh3ggJAZta6X5B0vtNMSMAednAP2jjI0xRrVtM4tE8YljXGZkuJYzoafCfogsp56V/8E
	2sXlGL8akIkzaCywkELdito5elPz26qCwL4Y=
X-Google-Smtp-Source: AGHT+IFsZ/KUzrOHCHY1OQv85Mai8YtZjoLkdIy+63XoZtePPy2M98PIrZ9g2fP099BYmB+Jd/Vg8w==
X-Received: by 2002:a17:90b:588d:b0:311:9c9a:58ca with SMTP id 98e67ed59e1d1-32342191558mr181034a91.8.1755215507650;
        Thu, 14 Aug 2025 16:51:47 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:51:47 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 4/6] fhandle: create __do_handle_open() helper
Date: Thu, 14 Aug 2025 17:54:29 -0600
Message-ID: <20250814235431.995876-5-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_handle_open() takes care of both opening a file via its file handle,
and associating it with a file descriptor.

For io_uring, it is useful to do just the opening part separately,
because io_uring might not want to install it into the main open files
table when using fixed descriptors.

This creates a helper which will enable io_uring to do that.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/fhandle.c  | 24 +++++++++++++++++-------
 fs/internal.h |  2 ++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index dbb273a26214..b14884a93867 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -397,8 +397,8 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 	return retval;
 }
 
-static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
-			   int open_flag)
+struct file *__do_handle_open(int mountdirfd, struct file_handle __user *ufh,
+			      int open_flag)
 {
 	long retval = 0;
 	struct path path __free(path_put) = {};
@@ -407,17 +407,27 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 
 	retval = handle_to_path(mountdirfd, ufh, &path, open_flag);
 	if (retval)
-		return retval;
-
-	CLASS(get_unused_fd, fd)(open_flag);
-	if (fd < 0)
-		return fd;
+		return ERR_PTR(retval);
 
 	eops = path.mnt->mnt_sb->s_export_op;
 	if (eops->open)
 		file = eops->open(&path, open_flag);
 	else
 		file = file_open_root(&path, "", open_flag, 0);
+
+	return file;
+}
+
+static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
+			   int open_flag)
+{
+	struct file *file;
+
+	CLASS(get_unused_fd, fd)(open_flag);
+	if (fd < 0)
+		return fd;
+
+	file = __do_handle_open(mountdirfd, ufh, open_flag);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/internal.h b/fs/internal.h
index af7e0810a90d..26ac6f356313 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -362,3 +362,5 @@ void pidfs_get_root(struct path *path);
 long do_name_to_handle_at(int dfd, const char __user *name,
 			  struct file_handle __user *handle,
 			  void __user *mnt_id, int flag, int lookup_flags);
+struct file *__do_handle_open(int mountdirfd, struct file_handle __user *ufh,
+			      int open_flag);
-- 
2.50.1


