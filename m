Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F3388CF8
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 13:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351117AbhESLi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 07:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351198AbhESLiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 07:38:55 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80252C06175F;
        Wed, 19 May 2021 04:37:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p6so6854423plr.11;
        Wed, 19 May 2021 04:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nVEklMyW1HIUBV1kdoh341kUZbkxzE1X+sGH+uDnxLg=;
        b=p83Ehm1sVP3n5tSX/orSkR5GrDAK53ql1L3ms86+i5VDGC0SUqilJVaGTebNw3HTiE
         wpSdHLQ8mcr8Sy8UfgrVhayU38idrbolSe7hVTPyyYXIlWNCyJGyWpVtuRRLpFgwXRtE
         yDlOnvLV9txC0IA/ahrUDt+MqadSjQCYylPbBt0S3NIGJBOZjLW1NqrgumoGUBWWmvfS
         vRwdfT2pyAM004PD1RHHo6r59EiO0J00pzRrP5VStufPfJPNmoMzW5L2Ny8H5+mQ32jT
         cR4nnvsUauZUTuS4LwJdUxw+N0Rh+16fsWqUbTQwshJMGkoPIAIDc0RV/WEs1k1iUscC
         hz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nVEklMyW1HIUBV1kdoh341kUZbkxzE1X+sGH+uDnxLg=;
        b=b985ccoQinTKz0nnmRJ66iWefhdX258zwE82JQueQIFAslCuzVEZ7XdS1Cld8a9VB/
         NQKQwbx6dMBneAm92DNYgCMiYBFu1XHO06tjgABFfw8TIBD1EDjuO5V088QZ2ET+Xmmi
         Lh4OsKHq052yvrdHofgX/HXV8KFnMpo46DFllSbWa2nVscljyGtIJBYx5d6A+ZZNpqR3
         +mgIv+mFpK4Pojxi4dE/Ltlb5C4B0bGoZwqxL47/8acElnm3Xg4ixhkVZflpqXj+bHZI
         paBBnKd2jWKfi9/hmIQ8pAeq8p/KkcnggkOcE1lJoaaV5DFFZQ6cKuW9B8rSaCPCLdri
         eYPg==
X-Gm-Message-State: AOAM533cuWX7Et+ULLWjJU+cWQTG1mFlLZVp15rKl1Z7XLD6CnaxwO+v
        biE7hi3nAUYzCYeTudggmUuekdVs0E4=
X-Google-Smtp-Source: ABdhPJxKF9Kl5/1mS+NmsBKb9lV7bLjVcmyADoG7WXovihNuOZFqyzmG08U8nIV4UD8fkoLHicGZ4g==
X-Received: by 2002:a17:902:f68f:b029:ef:919c:39f2 with SMTP id l15-20020a170902f68fb02900ef919c39f2mr10533179plg.41.1621424255928;
        Wed, 19 May 2021 04:37:35 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3084:b057:1ac1:910f:3c09])
        by smtp.gmail.com with ESMTPSA id y24sm3507268pfn.81.2021.05.19.04.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 04:37:35 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Pavel Emelyanov <xemul@openvz.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH  2/2] fs: io_uring: convert to use anon_inode_getfile_secure
Date:   Wed, 19 May 2021 17:00:57 +0530
Message-Id: <20210519113058.1979817-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519113058.1979817-1-memxor@gmail.com>
References: <20210519113058.1979817-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_uring use anon_inode_getfile_secure helper exposed in previous
commit. This gives each io_uring instance a distinct inode.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65a17d560a73..001fcfb63f33 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9454,8 +9454,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 		return ERR_PTR(ret);
 #endif
 
-	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
-					O_RDWR | O_CLOEXEC);
+	file = anon_inode_getfile_secure("[io_uring]", &io_uring_fops, ctx,
+					 O_RDWR | O_CLOEXEC, NULL);
 #if defined(CONFIG_UNIX)
 	if (IS_ERR(file)) {
 		sock_release(ctx->ring_sock);
-- 
2.31.1

