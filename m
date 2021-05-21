Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589CD38D035
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 23:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhEUVvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 17:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhEUVvo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 17:51:44 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDACC0613CE
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:21 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id i67so21300492qkc.4
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=NjQYheEqysYNaQjd+p06Inp4wH1U0otC+/CD13zo/Yk=;
        b=E5Spd5BKGx4yGEPJpQdD/aaQk7CvtceJrlp3Y2VBNOQHP0pgw4dR/8GV/BnhsK0OLB
         Ea/veQB1VRgASbTR43L4D4LUuapmWtrvt+fMLKiBcTv0xJJ5cWYPLybP7YT4c4+wCyda
         X0Jra5oRwQLf63pOQP/4dWDgjq215xGj9WN4EsGjIUrWlr5uboOzbvrqjHsi6HJPlQvA
         fUev5VZSdt/m7c+ufV/pWApmZdxobj461G9Dm4KpexmfBxI6qwVnhIcA+DTVmwx8rOZk
         EtD8xsveATZ4614xXmMi/AfjpKDdbqvouBmv8PZeay9O5C7XJclSBBLuZqXV49JXi8i8
         6W0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NjQYheEqysYNaQjd+p06Inp4wH1U0otC+/CD13zo/Yk=;
        b=Du0VFpsO1sIyZOv1m92uBSGVPKwVA55E/Q4Gvj2wywxDgUBkcuVAK/pkrq47UvdQjn
         r8IG99wFzfYHH6CPQbr9GzhMep5vAqEQMLTJ3U7CUFZbtHQz++gb2X3IHu7xxAfH+qZ2
         iCCQn5KBg5VN3FZ85YoVkiWL1Lx73L9M1xGILrEmwH5c8k2dO3V2F067KoyMKpZedgY0
         hRaJGVffDY7nNXxKW4kFgezckNqAvaCfGBV3jWtTs5cCxkLG5zls8mm4BQbdaEVz9QdG
         lkZuwijc+yMpNkYUVZnsZsVAGQWIJWm4bKyWRdSFiv7bxRtQvaLM2L4oAYgZtQqc14id
         4tnA==
X-Gm-Message-State: AOAM530d0zqhJ+zNeiIq+XMbbqJMo/d51qbbS2Z+Nx2FyjpjCytJJHJT
        mLDVxaciVc3ow/sL6mRuiOd8
X-Google-Smtp-Source: ABdhPJynsuaNUC820jY3H2esnoh6KFBANq11zEi3mooubWaHHh6CD0Vbo03pwFPQ4w5+8t77DR4J0g==
X-Received: by 2002:a37:9003:: with SMTP id s3mr14830045qkd.86.1621633820257;
        Fri, 21 May 2021 14:50:20 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id e19sm5357823qtr.45.2021.05.21.14.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:50:19 -0700 (PDT)
Subject: [RFC PATCH 6/9] io_uring: convert io_uring to the secure anon inode
 interface
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 21 May 2021 17:50:19 -0400
Message-ID: <162163381908.8379.10800711368185383459.stgit@sifl>
In-Reply-To: <162163367115.8379.8459012634106035341.stgit@sifl>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Converting io_uring's anonymous inode to the secure anon inode API
enables LSMs to enforce policy on the io_uring anonymous inodes if
they chose to do so.  This is an important first step towards
providing the necessary mechanisms so that LSMs can apply security
policy to io_uring operations.

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9941d1ad8fd..6ff769c9b7d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9562,8 +9562,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 		return ERR_PTR(ret);
 #endif
 
-	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
-					O_RDWR | O_CLOEXEC);
+	file = anon_inode_getfile_secure("[io_uring]", &io_uring_fops, ctx,
+					 O_RDWR | O_CLOEXEC, NULL);
 #if defined(CONFIG_UNIX)
 	if (IS_ERR(file)) {
 		sock_release(ctx->ring_sock);

