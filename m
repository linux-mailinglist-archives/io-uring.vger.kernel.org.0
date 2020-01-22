Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654AB1448B7
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 01:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAVAGO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 19:06:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41947 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbgAVAGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 19:06:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so5395697wrw.8;
        Tue, 21 Jan 2020 16:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=foKquxBAIMXjAR3tdf5BNsaZnzetsrzrXlbRi9LRBb4=;
        b=U4MDQ+MDFZ4+2VQMTW1Z2qxQ0J5lVSlfpS0Ugvi7MKull33Mv3+LI6Pu0vEhpl1j55
         pXL3y8RB7AumVU9f5hDAnyiu1VI7uDcNkjJW06UZmOKWY7kWy7e4K0xQd4PIcde0I3dV
         u90jbXknx9egI5Qt5QqYbfSZBbMixLEYPnO1L8t5tFyi6d4k2yyQ1YS2jWVGF4hCvdsP
         A4yGRE/5YTTPOUkNAnMruf06GBg7XlAKPwwV2fbGYtvSxn3xxkoCqKMr0J3hk+dkA0Jh
         P9Z+1gga6DqXVT+G2Ncxtb9H9xu0RvJQuNyE1pN9GDIKwHaNjAIGsH8EZoEZJH+ggLNv
         P2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foKquxBAIMXjAR3tdf5BNsaZnzetsrzrXlbRi9LRBb4=;
        b=ZoA3CFXXPDo7e7e8KdmFs8QEiI1NuK1w6bOfzn7FLoQZjzTblhO9ocITCLLs1w9ojo
         AtHkUFvF+DPuaOLdfCFdwP/KzA7e0IRnmEMreY1YBW8jHONcBepoQUJ/0BK02EmfaxdM
         DFiLOnQWUcxVq72z44iKVzadoBdYUUFfLntMzZjfdIhMGv1+CJZxcDNlk4he7gWtBZSC
         ufJCDTgErvTbawrQ+R0eRSzIzWjISH/XPOosKpSV5IXdUQnPrZaHBwvM7FNdoBHCJom7
         hmC70qp84Hi5dibkUBjF7mT75OAbXA7BwhCN0dx0Hk4QdB1gxL+1PBKMuHz5HdTGf4D5
         SWUA==
X-Gm-Message-State: APjAAAVi9mV9Kon+wT7XvFJwYH/UGz2RxPbBDWOQ7e5nsrpTbViu1T5C
        pkadHejG/Mnlm1u/rVakS72qUiJE
X-Google-Smtp-Source: APXvYqy1+h3okdtS4UStCFTzfwEd5REidTaNSenzsWxlM58/Cew+MSrlV4Q/x3+3dagG4lzWfvV9Yw==
X-Received: by 2002:a5d:44cd:: with SMTP id z13mr7840658wrr.104.1579651570339;
        Tue, 21 Jan 2020 16:06:10 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id o4sm54527068wrw.97.2020.01.21.16.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 16:06:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/3] splice: make do_splice public
Date:   Wed, 22 Jan 2020 03:05:17 +0300
Message-Id: <525cb9fc7d729a96fd7ea57d88e8f82337973bfa.1579649589.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579649589.git.asml.silence@gmail.com>
References: <cover.1579649589.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make do_splice(), so other kernel parts can reuse it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/splice.c            | 6 +++---
 include/linux/splice.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3009652a41c8..6a6f30432688 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1109,9 +1109,9 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 /*
  * Determine where to splice to/from.
  */
-static long do_splice(struct file *in, loff_t __user *off_in,
-		      struct file *out, loff_t __user *off_out,
-		      size_t len, unsigned int flags)
+long do_splice(struct file *in, loff_t __user *off_in,
+		struct file *out, loff_t __user *off_out,
+		size_t len, unsigned int flags)
 {
 	struct pipe_inode_info *ipipe;
 	struct pipe_inode_info *opipe;
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 74b4911ac16d..ebbbfea48aa0 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -78,6 +78,9 @@ extern ssize_t add_to_pipe(struct pipe_inode_info *,
 			      struct pipe_buffer *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
+extern long do_splice(struct file *in, loff_t __user *off_in,
+		      struct file *out, loff_t __user *off_out,
+		      size_t len, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
-- 
2.24.0

