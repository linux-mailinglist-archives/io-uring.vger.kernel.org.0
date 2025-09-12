Return-Path: <io-uring+bounces-9772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 942E0B5536B
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 17:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F4E2AA59AC
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 15:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF2F223DFF;
	Fri, 12 Sep 2025 15:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebktm0UX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCC2223DF0
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690863; cv=none; b=QIfS5G7YOGCrWxsI/wubt2UhDOqQpDuniQLz97mIFpuCsGckcnsKIMupazttyOm8GG+AAv4R+iqBj4A4KvU7CL3zxq7lnCm8qc5n786PFpvjJk3u/xZXRYWlLqfaEQZza34+GRwjGcMpPEEgNFB79vcNJkdE7zOLdA5z9/cEDQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690863; c=relaxed/simple;
	bh=5lZAum//LBJxIdFWj7t2aj1kNCLx6ty7TxuHKOp1bq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZyHddHUst3+R9a/XlxXFuOKqNywYjhYKhdcDBuv48IgX67RNrs8GgA7I9Jy7x1EynzlOoe0NDNJWfvcxZ9OGfvUMsIgYBwmrTiVPY0sCNGC+3rvOhQS53rF9Fya23rK+UHONXDZWGYQbwybRP9ORNIAnany+Vrx2ZG0Cm/rM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebktm0UX; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-77251d7cca6so2050458b3a.3
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 08:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690861; x=1758295661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUi/pbtm53Cxnha5F4AHOpQXypNU1RUW/H6Uafi66yY=;
        b=ebktm0UXtt8xRmG1L4PyppUs6xL2gZK4vUKY07CX/IBGitar+TXHA4ctwcuxwm6GLD
         1xQpGVzK7qSYFFOMkOkI3MpgmekRyTBjoqZ4hUrz8olY3AYAajAYh/OCqXVA/mbQSJX2
         snC3Jn1OvAockX4v2il8GxPyQez1z5zw5V3lPWFAvlYl173KjHAp6n3Mp4zqI18AGwsc
         14HE+sfRSsd4IvYTNposbO/QD28krY5zFRcH+PHdQvBFw1n1zWO7vfPuFoaU0ShalrHX
         GQypgIr4jSc37EAq8PkqEC4RIl5vLmU3GF1YP+o/HgiOCEVYYhN7BUgnXWsnCEN9AhLx
         oV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690861; x=1758295661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUi/pbtm53Cxnha5F4AHOpQXypNU1RUW/H6Uafi66yY=;
        b=n+gWWhKTYZAz2CuyikqNO22g5YZ+0f1FCZzgdsoQ7B4ZagrOfmRI/nx0sa2dYs8SCr
         D3piB2p7cb4lDRdypEWPW8BEmgXr57FryBfxVW67fEl0AIMig9sBcfVaGWzX/hUVZSrI
         hKZMFFB7lA/cyU22bVuSP7DMbIpNFmy5DGSSyP3Ex0My61BgBp64bspzikzVNyHhHsiN
         xE5BgRIe4tmQ5WWPi5qVm0YbCVBFyTfowMBjLTe7r2Uk8BJNYpRi7MzbW8Ag+ZRBpHmn
         tyvcP+EBgt3tMNOZn4F0zcrBUmPR9jhL3T5bB215AbbdJH0laOcXXpIV2er6Px0H0VbU
         3RDg==
X-Gm-Message-State: AOJu0Yy89WZgvdhJzqukzj/tijUgNI+t6OhkJUQPpVXcXEpuKhM0afXS
	ZZ8Ylq96CCI5h7vG0l1lnwWcycLKBeiAA6DAnmZ7R7q4CdIvHXKACnLrjaroakeq
X-Gm-Gg: ASbGnct7f7oOQUN84B1ez99W5AMQMHXFPuKxoAfl6h5/WCMjrCKB8brmYciK6PGd5k8
	iCTCm50AvFvxPh8FRJLojTOthLEnQRap2CZO9aP4yZ46Q/XQbMdqHIiBEWmJHTpKKVUM2qLstO1
	Scck/7QI/IFll0fjlJ6q0PT5X313ebDXMnrKvwCFJnWaVgfA6MIBzwxG7HfJCQwr+obF+ppe602
	EtwDKjncJwnSQbwAT520GgHk3hXZDF3WrCBVNDHhDjYrmxq/25nn/G6Q5QhYaRNcfRf+Zq1s5YJ
	spiKR7bEdfT/NHNpPQnQXYvEZvFNEBV+P7K+YBxMsX6yXNOSRcgMeeYGFTUyW67HRhdPwV5xOuf
	bpYAmCkWcG8ebafxZ/KWOUR4odiWlO5z9dgAG
X-Google-Smtp-Source: AGHT+IG8rXgJY0fPAkbXI3vB4rO2IaBq0OGh9o5R7npgR22A2CZCysWwZy4wkg/iQ2DT6W4h2WNgxw==
X-Received: by 2002:a05:6a00:2e98:b0:771:e908:b573 with SMTP id d2e1a72fcca58-7761219b880mr4365933b3a.31.1757690861065;
        Fri, 12 Sep 2025 08:27:41 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:27:40 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 04/10] fhandle: create do_file_handle_open() helper
Date: Fri, 12 Sep 2025 09:28:49 -0600
Message-ID: <20250912152855.689917-5-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912152855.689917-1-tahbertschinger@gmail.com>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This pulls the code for opening a file, after its handle has been
converted to a struct path, into a new helper function.

This function will be used by io_uring once io_uring supports
open_by_handle_at(2).

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/fhandle.c  | 21 +++++++++++++++------
 fs/internal.h |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 4ba23229758c..b018fa482b03 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -401,6 +401,20 @@ int handle_to_path(int mountdirfd, struct file_handle *handle,
 	return retval;
 }
 
+struct file *do_file_handle_open(struct path *path, int open_flag)
+{
+	const struct export_operations *eops;
+	struct file *file;
+
+	eops = path->mnt->mnt_sb->s_export_op;
+	if (eops->open)
+		file = eops->open(path, open_flag);
+	else
+		file = file_open_root(path, "", open_flag, 0);
+
+	return file;
+}
+
 static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 			   int open_flag)
 {
@@ -408,7 +422,6 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 	long retval = 0;
 	struct path path __free(path_put) = {};
 	struct file *file;
-	const struct export_operations *eops;
 
 	handle = get_user_handle(ufh);
 	if (IS_ERR(handle))
@@ -422,11 +435,7 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 	if (fd < 0)
 		return fd;
 
-	eops = path.mnt->mnt_sb->s_export_op;
-	if (eops->open)
-		file = eops->open(&path, open_flag);
-	else
-		file = file_open_root(&path, "", open_flag, 0);
+	file = do_file_handle_open(&path, open_flag);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/internal.h b/fs/internal.h
index ab80f83ded47..0a3d90d30d96 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -366,4 +366,5 @@ long do_sys_name_to_handle_at(int dfd, const char __user *name,
 struct file_handle *get_user_handle(struct file_handle __user *ufh);
 int handle_to_path(int mountdirfd, struct file_handle *handle,
 		   struct path *path, unsigned int o_flags);
+struct file *do_file_handle_open(struct path *path, int open_flag);
 #endif /* CONFIG_FHANDLE */
-- 
2.51.0


