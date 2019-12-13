Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA76111EA70
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfLMSgm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 13:36:42 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33968 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbfLMSgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 13:36:41 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so447280iof.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 10:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fmQ/i8Hv9KuLkHqebIqqpi0bvHKZix85zq5Fj72/GSc=;
        b=xGrEF5HicQOGceBwIlUOAP0NP9x+3itij83BXMCYcjLxd613mMzXkX1g8vFi9WML9F
         EhjouRDmF7zHwuZxV1+ZxUh43UwOCIuxRkyyKbnz0TSgwJDUzGkYP+Z0jqRGDzr9SRd0
         aUqSTXdEdUPBVC83cHZusrnN7POVTuD97s2R9PrtuZRxKZmR7fxC99TX/6i7AoHcejjy
         rd55K2o4bJ7KF2mUmM9sYwwEofP6kOPT6a+X4byGGCTaJS6G3mvHDGIFWcx0psQ43Npn
         vEct+GGmd/T4aPT7wmzRDUkxUNNyTSksUj342AK/vD14n7NWv126LKK59pr3Vvhm0nQ5
         vVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fmQ/i8Hv9KuLkHqebIqqpi0bvHKZix85zq5Fj72/GSc=;
        b=gt5Mj13r/jj/o4OOywgGYBrzsA2HLqa3Ff5P5N7szjfQ5Nyqb2AhFYEuSeCQ45KzA2
         8iwBFz+jkGwYhGDwLi8MldBGavskFPh6IlXE4nT3PDkRxMLygOJh/YsncSpwHokmMg94
         lpJyZ6sw7aJxVMJDjICJiiGG9FMhthMsaNzt6IXTW50GyB0/nxlzdekdHq4uE+mAZ+B8
         hlnpN2LsNU54IIpZDLfy8QuRzvL1yDVOBxQy7DdRlISsG5vMBdzNmTJTcyEaGxT5/xY4
         o8rQob1sLvYJwHNw/T2walkwyHgjTFDEpwxGyl225mQjsywDpf2qvOCTQypfoME7Bzok
         NOkw==
X-Gm-Message-State: APjAAAU74B/IlKR4fFdsnqBld+ULdPDbae/n+hgUjQdNL7RL9jn5upoL
        plZ1dZdTn2jD0Q+xw459eNjsEC0BdAOcXw==
X-Google-Smtp-Source: APXvYqzwM6u0hVV7Go6ppFNmkO3+1q2lXIEXPw9kBKlyzB0CMcc+u/85LdwCV9HsWKqXK/flrtjyXw==
X-Received: by 2002:a6b:f605:: with SMTP id n5mr8172162ioh.61.1576262200820;
        Fri, 13 Dec 2019 10:36:40 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm2932031ilk.4.2019.12.13.10.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:36:39 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/10] fs: make build_open_flags() available internally
Date:   Fri, 13 Dec 2019 11:36:26 -0700
Message-Id: <20191213183632.19441-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191213183632.19441-1-axboe@kernel.dk>
References: <20191213183632.19441-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a prep patch for supporting non-blocking open from io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/internal.h | 1 +
 fs/open.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 315fcd8d237c..001f17815984 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -124,6 +124,7 @@ extern struct file *do_filp_open(int dfd, struct filename *pathname,
 		const struct open_flags *op);
 extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 		const char *, const struct open_flags *);
+extern int build_open_flags(int flags, umode_t mode, struct open_flags *op);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 long do_faccessat(int dfd, const char __user *filename, int mode);
diff --git a/fs/open.c b/fs/open.c
index b62f5c0923a8..24cb5d58bbda 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -955,7 +955,7 @@ struct file *open_with_fake_path(const struct path *path, int flags,
 }
 EXPORT_SYMBOL(open_with_fake_path);
 
-static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
+inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
 {
 	int lookup_flags = 0;
 	int acc_mode = ACC_MODE(flags);
-- 
2.24.1

