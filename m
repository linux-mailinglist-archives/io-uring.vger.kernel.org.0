Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4676E3EA7D1
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhHLPmW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbhHLPmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:22 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15890C0617A8
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:57 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t35so10964191oiw.9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46//QmBZH3jrthv766p60WFq7Yim71orBie7qxwdLOk=;
        b=AHYlNGB1VuUhJsFptE3Rzc+pkikDIsJJHkgmNwB82F+KMUbVB6wmJgwYELxwIseO8i
         7MxRO28Sb2nZIjJ40mar67nomEgBQL5s9MJdCf+3Z0baT5XSgk3cxcNJUPDFlncVYULB
         7nbiG6CJXH+/5HUQFkcEj8UU3yvgI6erFmzEetW81NJcI3rImhahLR2+sNXzQHrJEL7b
         KHeKKQArgUvmPJVmt8B8O+ECpJnGYo4qMo4fILzs7SB1K06B5HcJcDJqAnJCBxmmF/5T
         IZSNCna1OPjpqt00UG0o3AFIZtn8GGlj5+sM0KXS8TeLZFLWsbjbJTnQJkR17xcQ/48t
         Bxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46//QmBZH3jrthv766p60WFq7Yim71orBie7qxwdLOk=;
        b=qJlrdg0V8Th80qcw61Yue5RgnOC9Dfzuup/lZXernUN/6xurJPkLFXsKNBYhEUZik7
         Lc/ns7O8hnQmXO8t5ch33HXSTg83uWAZexKI3ncXMQZfRh3NjWRD/cCK7wWux8nCFHnu
         b3VbxMiR6iKhA66HEeQK2n2F8omv1j1TiJ8vzVPKdwm5CrHjsA+Az7fy93klb1le0YxC
         xtr2/JHfRoco6DpHGWDK3G/wi2Mn449atdszxQg0urUdfrKlB2t0ffB8qLk/aRN4w6Zl
         3+sTfSyrqF1SvvLexKUrgT/NSeoUlMj/9odL1+zCuGLpyk6Z4z2oJPsUhB8Kgsy8AYxF
         hEzQ==
X-Gm-Message-State: AOAM532MKwXpgVTGg00Pq6vb7CzQGT09WNVO+IezTU1E4a+h4rSuU2RE
        dsVaCDYFhM7y19/cZkJ4piIx41xdI9ENLzZ7
X-Google-Smtp-Source: ABdhPJzMOdA4TfkbjVKZv7BxDailBEKJLEzaXZMOL+3uXynnlUm55GrMLTalK4pu6naC53aDg4sT9g==
X-Received: by 2002:a05:6808:bc8:: with SMTP id o8mr3785607oik.2.1628782916274;
        Thu, 12 Aug 2021 08:41:56 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: enable use of bio alloc cache
Date:   Thu, 12 Aug 2021 09:41:48 -0600
Message-Id: <20210812154149.1061502-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812154149.1061502-1-axboe@kernel.dk>
References: <20210812154149.1061502-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark polled IO as being safe for dipping into the bio allocation
cache, in case the targeted bio_set has it enabled.

This brings an IOPOLL gen2 Optane QD=128 workload from ~3.0M IOPS to
~3.3M IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6c65c90131cb..ea387b0741b8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2736,7 +2736,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		    !kiocb->ki_filp->f_op->iopoll)
 			return -EOPNOTSUPP;
 
-		kiocb->ki_flags |= IOCB_HIPRI;
+		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
-- 
2.32.0

