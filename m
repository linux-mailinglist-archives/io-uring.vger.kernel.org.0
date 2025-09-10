Return-Path: <io-uring+bounces-9716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E815B523C4
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E73FBA05FD9
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569AD312802;
	Wed, 10 Sep 2025 21:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HIh3Xr5o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C1E311C1F
	for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540830; cv=none; b=CL++82nQmZ8q2smYx0m/lDDAZfHiwtBhX6yrn3GRABUMTXZRtY8+BEp9HpMJhouN5DCDLcxIy5AHG2sDOhI+9rXr2R3AurdRwXJzMy6wzS9VfSOc7CiBKgE7ATHbiXmYAOiBO0zA0xOnJZz9h5kikutsF8h+sc+a9QxxENybXAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540830; c=relaxed/simple;
	bh=kvM1elF5+oc1pYFua2y45FGpx0o8xzpLgTvp1ZkbnOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBk76YQwf7VCIRYK1Yb6wyB22bNNkLfsHyaJwZFiQaJO2gKk7OIf/JiPZGZ7d+fAEFdMTFsjsWSU6/5eRQezlfbjd7TeI3BmG1JBR1Mpg1KjsSad8vN2QwxjmSaeMqZqQ7RYkPTn5XdrJi4vlghST9RMde24vylX0l9lFcpLONQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HIh3Xr5o; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32b70820360so26588a91.2
        for <io-uring@vger.kernel.org>; Wed, 10 Sep 2025 14:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540828; x=1758145628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jqVzJkoLAYcnepyiDsaTX/+tOEvAu12voWvejr/kNQ=;
        b=HIh3Xr5oiX1cBubzUDFXG1ey+q5w2++q6EOIM5bRfG1Vl5D/8urv79F6KHVAD+tL60
         94c2eMsouTxWJ3S1XbxibRERElv0lsdWCseKGxpp4ukU1qA1lW72a57UTQgg2gEX+Ukw
         Kt0kiMUCke8U2n4Oz1KLo1o1skTXxNw5CHSEr2IC/IDMTGaVYjfJvNQW7qQAWQQH9TBO
         jfujeflPRBy+UN9A7y5ZO2YheVKGJg1EDpJdCEUvUiZxD6a/1mfHrXf1nlJv6BSRDcS0
         PVmbRk3KKRgGMQ/gM/Ad4kmTMeNf/2GE++GHo47NT1mLq2G8U//wBAj2BexsijM24gLM
         zZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540828; x=1758145628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jqVzJkoLAYcnepyiDsaTX/+tOEvAu12voWvejr/kNQ=;
        b=jksgNtoqd4cLotBWU35CggcWzKAyjKcSwcsJAc88df53TsOVwXS4FVEYvGb8SGEIz2
         A06EuwynP11ivwvgvg6n7DblCRnlaLh7Rredk4B1iTrW3P7xp6RxDWP3Xa5ggdJSkBO5
         0nEXONn32hOGzsNs/h4+qqqY09eHVygvuEw4r4Umu4/fGphhcCXf9J4pyuaqXGxfQFEq
         C1bPkdfBlK0UKT1U7jWr/qNOP3B+Y1j43zX4HUVo0BpClIIkGlVBWq6q3yD6BvgQxb3a
         oOyZjJMQMVOuJg9gv6S4uOiEy5n3tGTLP6wKmPWArKIC4tm3ab/jbiZZgGB+yNrLXGqe
         08Ug==
X-Gm-Message-State: AOJu0YwJHnnJkVyemHWQtVJ6nCFVZr5r6/ogeTeJ/OriAcjZk+Wy0gjP
	di4i9qtoSznBySYLjk/yrRfGbuKGbeRxPpcWRnAobG1PVTwmgNc1NaGBpNAFh7Pd
X-Gm-Gg: ASbGnctvGUZR7wVnrNZAxq5+lUMm7uiRDBRur7rm/79J8kQLqahjV8SE9yeAPGyqhV9
	EeqZWnuirS3DYD7RhQ8hVhKe2wvoJCIDvk7l5a0YycNTWaNcG9tLBDPSmvpriWOvoZ3igIZDI2j
	M8TAnm8BdOIym7tV0M9IugujTobwvE33kX85hENws1Kcpbn1NjP3Trqksh2OyofpmdgBD5VEBW+
	OxsnRhl1XnkIpExM2nk8yv+w3IU90IBVoS8UYVmi+LQoPBw6fJVq5foE/ntmIyv4HR65uGYnWy8
	/acuhUnfi50DZzFA/AMti1hjB8D9kLItiOlSffN9b7Ur8aO3lFjjSywGZ2fpl0nhs3TBEm5aRPO
	UFyTtxakKHWrQrgMmXO4RgjduPKJIMPHjoEqD
X-Google-Smtp-Source: AGHT+IHx0CvPRpX0ZdYZdIZBPvt044adGGF7SX7Po67PGTaEbMsD/C8GoOn8lsEMOGH3zkwFcpQ12Q==
X-Received: by 2002:a17:90b:2683:b0:327:ba77:a47 with SMTP id 98e67ed59e1d1-32d43f05b51mr24773329a91.15.1757540827882;
        Wed, 10 Sep 2025 14:47:07 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:47:07 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 05/10] fhandle: make do_filp_path_open() take struct open_flags
Date: Wed, 10 Sep 2025 15:49:22 -0600
Message-ID: <20250910214927.480316-6-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910214927.480316-1-tahbertschinger@gmail.com>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows the caller to pass additional flags, such as lookup flags,
if desired.

This will be used by io_uring to support non-blocking
open_by_handle_at(2).

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/fhandle.c  | 14 ++++++++++----
 fs/internal.h |  2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 91b0d340a4d1..01fc209853d8 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -402,16 +402,16 @@ int handle_to_path(int mountdirfd, struct file_handle *handle,
 	return retval;
 }
 
-struct file *do_filp_path_open(struct path *path, int open_flag)
+struct file *do_filp_path_open(struct path *path, struct open_flags *op)
 {
 	const struct export_operations *eops;
 	struct file *file;
 
 	eops = path->mnt->mnt_sb->s_export_op;
 	if (eops->open)
-		file = eops->open(path, open_flag);
+		file = eops->open(path, op->open_flag);
 	else
-		file = file_open_root(path, "", open_flag, 0);
+		file = do_file_open_root(path, "", op);
 
 	return file;
 }
@@ -423,6 +423,8 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 	long retval = 0;
 	struct path path __free(path_put) = {};
 	struct file *file;
+	struct open_flags op;
+	struct open_how how;
 
 	handle = get_user_handle(ufh);
 	if (IS_ERR(handle))
@@ -436,7 +438,11 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 	if (fd < 0)
 		return fd;
 
-	file = do_filp_path_open(&path, open_flag);
+	how = build_open_how(open_flag, 0);
+	retval = build_open_flags(&how, &op);
+	if (retval)
+		return retval;
+	file = do_filp_path_open(&path, &op);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/internal.h b/fs/internal.h
index 599e0d7b450e..0236391297bf 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -366,5 +366,5 @@ long do_sys_name_to_handle_at(int dfd, const char __user *name,
 struct file_handle *get_user_handle(struct file_handle __user *ufh);
 int handle_to_path(int mountdirfd, struct file_handle *handle,
 		   struct path *path, unsigned int o_flags);
-struct file *do_filp_path_open(struct path *path, int open_flag);
+struct file *do_filp_path_open(struct path *path, struct open_flags *op);
 #endif /* CONFIG_FHANDLE */
-- 
2.51.0


