Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61563065F6
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 22:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhA0V0s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 16:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhA0V01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 16:26:27 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BABC061574
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:47 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q2so1814664plk.4
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pyYp6RD2YO/EBr9Jv5+SChjQro7c22MC8gaVrpGiC7U=;
        b=tUFVYX0sZ9CZEu0315WMn3J1tFiKAw/HTBn7H0PI4MAmf6rk08Aq5kk4AYONLg8Be4
         ai9bm7h2NtLICvXgMsTRX6lUtoMTzm3r0zFeUZuAjJ3/JOpp9QZnBwZQ8Hs61FINsyO/
         Nhd5Q9uxTh8F/cGkyfwiP7+siaRYgIPD5DVcaF3m3zO56nsM+LtOahb8QAR6WzIdNcBg
         9b4/v3dLZWHCxL9huTKlPyrtDIEhgDwLMHUz8t18BxCHsp8by0pYf8y+WeJgfFAiYzVu
         yz+M+gqVkzUZEOTWdwzChVzdBT8Ft47EfxD2QgyHxbJyC77oyf2jCL6FgWkLSHwzea+G
         3DbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pyYp6RD2YO/EBr9Jv5+SChjQro7c22MC8gaVrpGiC7U=;
        b=dOtW8tbKc2G+8c+4sFQokkBj3+VqwZqNFFs/V2LWTeQxHr9Mdpc11Ay9ugIlSi3BAc
         eG650wbwgI8CJipILcDC+RFXZ0snbNAJECNI0hn/wxaRxe60XdIjN+4guyHAPuOSGLqL
         l0tbXh0o11EHdk+l4JFV6HogShpZJlbqG6acazvhKEm0FSfG0y1XMJs156J6GH4LRZro
         +SJ96vdzmrCQnuOeInHMcFK/cijnZnoyRrqUcyNYCxEbGfwNvUzGlHIMvDMjrDMU3sNV
         xAnwiVKsi/GuQHrHfnpfV7ZLZ9qeO0Sg4NjyCrAOuyeIf2LfsoP86YulE6AbTof/zE8B
         Xilw==
X-Gm-Message-State: AOAM531NPRKKzEPQ4LAizLEORTBCqDeD5lAAkZdaOD4LlPCTX57jSyKf
        UT5Uni/PZbHGzhsRfhrNJ2VgxSWHA8Ol3Q==
X-Google-Smtp-Source: ABdhPJwCNq+qQb3cbF3Qnu13BQASwjSAmwbOArClJfSOBFz7FaGIZxi4lCcaqMLlAG2HUniBwYsJkw==
X-Received: by 2002:a17:902:8ec1:b029:dc:8ae1:7a22 with SMTP id x1-20020a1709028ec1b02900dc8ae17a22mr13291352plo.6.1611782746800;
        Wed, 27 Jan 2021 13:25:46 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mm4sm2794349pjb.1.2021.01.27.13.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:25:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] fs: add file_operations->uring_cmd()
Date:   Wed, 27 Jan 2021 14:25:37 -0700
Message-Id: <20210127212541.88944-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210127212541.88944-1-axboe@kernel.dk>
References: <20210127212541.88944-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a file private handler, similar to ioctls but hopefully a lot
more sane and useful.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index fd47deea7c17..b596039966da 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1816,6 +1816,11 @@ struct dir_context {
 #define REMAP_FILE_ADVISORY		(REMAP_FILE_CAN_SHORTEN)
 
 struct iov_iter;
+struct io_uring_cmd;
+
+enum io_uring_cmd_flags {
+	IO_URING_F_NONBLOCK	= 1,
+};
 
 struct file_operations {
 	struct module *owner;
@@ -1857,6 +1862,8 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+
+	int (*uring_cmd)(struct io_uring_cmd *, enum io_uring_cmd_flags);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.30.0

