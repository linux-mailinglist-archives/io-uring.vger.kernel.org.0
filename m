Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3A9132C7E
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 18:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgAGRFz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 12:05:55 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:42051 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgAGRFz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 12:05:55 -0500
Received: by mail-il1-f195.google.com with SMTP id t2so173891ilq.9
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 09:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kbiWj3hsFb2raXSepJdHXFBL46D9EdghCDfj9UYmh+s=;
        b=s6/KrsEqptUnzDAHMDp3iBPuRHoDPMO6AgWgBQVpFET8ySrMo+bmF+LfCnrvzXcifD
         ndsX3eZ+gDijg/5ejOD0eoGaMsOS7dJUxiKSTU+nhnFgPY8ry9/BnMnk1XKCY2scAUKh
         +WPwcZY4GRadWa1Rf8mVN714ahobfDdva5HCrB0AEJsCHayIfFbT32Crs7beif3x4+mo
         HlLIavx4hmx0LmkOfkwEwHcWtDh4H16r2UYpI0vp/rO/k/a4EU1Gqdmf3lKq9aSWXSV/
         2frlk5BNFVD1decBLG57AlO2VITgG0oDBZvH0b7W7s/Ia360k0RpJTAQxjN33cHaUeFf
         MJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbiWj3hsFb2raXSepJdHXFBL46D9EdghCDfj9UYmh+s=;
        b=jeC/WwS8o9l6+mYw99eHytCmOf5MusyKYkj1ITJawsqw5w8V8zrllhBB4Dxa5jqYmY
         X4TL/XA6XWNAUxjUy93hGEplLT/Qc0klT0GU8drhnaFmbn1msqA+pGML+vIizf+6Y36a
         HyW0sR/5VEAm4+uBWmzPeNwvzDvOeLrkqDRQWE2F6rpxqf0yQgMI57LONp98qoijg+u2
         Xs2l+Twd24USNqbFdmEkoUUPoKUw7dOmtFUtpRA2LVcL5cAutDy4xInVdtJVZJtIA9wd
         LBSvANcmKbgHyjHZyXYe/4speqCwZTrxRalTZeh69kdVYGKkjbw28TZYxUMo4laKkzGQ
         eaFg==
X-Gm-Message-State: APjAAAWGVVq2qPbZN+UKf+naIkzMWfcBQVgd/UDfrJX8I4buECSW9ST3
        o8RKvcRFatyyCn5vwkrgPhdyKJS7fDs=
X-Google-Smtp-Source: APXvYqwKi7uzbzlg5QYDTKhr37E5E0zuCHxDm7viv4yVLeux3ZkGT/MlIqtBJlDfGkcciXxTT8nHzw==
X-Received: by 2002:a92:db4f:: with SMTP id w15mr45365ilq.182.1578416438519;
        Tue, 07 Jan 2020 09:00:38 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm42547iln.81.2020.01.07.09.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:00:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] fs: make build_open_flags() available internally
Date:   Tue,  7 Jan 2020 10:00:30 -0700
Message-Id: <20200107170034.16165-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107170034.16165-1-axboe@kernel.dk>
References: <20200107170034.16165-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a prep patch for supporting non-blocking open from io_uring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/internal.h | 2 ++
 fs/open.c     | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 4a7da1df573d..d6929425365d 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -124,6 +124,8 @@ extern struct file *do_filp_open(int dfd, struct filename *pathname,
 		const struct open_flags *op);
 extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 		const char *, const struct open_flags *);
+extern struct open_how build_open_how(int flags, umode_t mode);
+extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 long do_faccessat(int dfd, const char __user *filename, int mode);
diff --git a/fs/open.c b/fs/open.c
index 50a46501bcc9..c103623d28ca 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -958,7 +958,7 @@ EXPORT_SYMBOL(open_with_fake_path);
 #define WILL_CREATE(flags)	(flags & (O_CREAT | __O_TMPFILE))
 #define O_PATH_FLAGS		(O_DIRECTORY | O_NOFOLLOW | O_PATH | O_CLOEXEC)
 
-static inline struct open_how build_open_how(int flags, umode_t mode)
+inline struct open_how build_open_how(int flags, umode_t mode)
 {
 	struct open_how how = {
 		.flags = flags & VALID_OPEN_FLAGS,
@@ -974,8 +974,7 @@ static inline struct open_how build_open_how(int flags, umode_t mode)
 	return how;
 }
 
-static inline int build_open_flags(const struct open_how *how,
-				   struct open_flags *op)
+inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 {
 	int flags = how->flags;
 	int lookup_flags = 0;
-- 
2.24.1

