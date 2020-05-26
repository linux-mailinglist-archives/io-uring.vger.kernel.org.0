Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A3A1E2F4F
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389750AbgEZTvl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389706AbgEZTvk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:40 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400FC03E96F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j21so10556598pgb.7
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39qQrTBLEctUrGanLy/C45/WjdVfQkC7faPzmr+qhpI=;
        b=yFrvO5Xl3qNEXOkExAlKW5HCKxIsDSMlTDL6yu/qdDNmAN9gaTkhr8Ji+yI9XJMB6r
         Yyj0QZ3VaFi/iX801MVu58AB5V7toUQ/3YSKHrzjYv7i2pgw3diwzJ9VU9sKkiQ+CqO5
         +3TnFQnSzV+5hEs5v5Y4SsfGIfcKj9q7W3SSj/g2m24bxPjK6B7OSCJCgOwvDr/T+fH0
         FXKEQYV/edda3rOI2u6He8F3YutgqUpDtRr1cjsP0bBekPjb/tjeT+Zdyk9nrP1RvMHF
         IL3sBKXh1sO3XzmReF4iBAlL3BzPeFNzf+QnoSzUJnqeO7X206hePi35FPbwAjeQ87ro
         IySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39qQrTBLEctUrGanLy/C45/WjdVfQkC7faPzmr+qhpI=;
        b=V/ItNsi620PeXtAbMDoaiBvzepYyWlzmMalF/W91ugrXqfTPJpGHRYHJ+RUGqy3cQM
         SDBmH2fteVfD7Le8S3NQW6pTYNZgvBdfPsmmw9xs2oFiFFga405arsfOh0oNeqPjMzhR
         OP0XIQits1F2F8phM2qjooh5/Yxo+bKGYvmqLYBywVuxnjbjikkkd9AgwhGIxNW6l3gK
         ei3fLT83jL3J2a9P5WIA2mnSFuVht3c6Xdy0NC9b1ONMCaT0/CjztzGbp1jHJzWiBG1C
         3E5mQuidrT40ADc6odHY+hUjb7/d6nzCu84UGWHwlEeX4o7u6wENcOCY3/3bTY3dQWy9
         QW6g==
X-Gm-Message-State: AOAM5312wgq60eBRBhUBXTR3OMfpDYip3rHPKlzGikpqcOTbqEsj9RCu
        yruvQU/thYyeSkiIeF+pMBzbPbgGLSHpIg==
X-Google-Smtp-Source: ABdhPJywnc6qZ+WtihMTbkb+pFwn9JjcTK1HqNCVBDIVrphWDInm6gN1LVPRjjrnGs3CvW4hueDaXA==
X-Received: by 2002:a62:14d6:: with SMTP id 205mr417227pfu.75.1590522699174;
        Tue, 26 May 2020 12:51:39 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/12] xfs: flag files as supporting buffered async reads
Date:   Tue, 26 May 2020 13:51:20 -0600
Message-Id: <20200526195123.29053-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

XFS uses generic_file_read_iter(), which already supports this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4b8bdecc3863..97f44fbf17f2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1080,7 +1080,7 @@ xfs_file_open(
 		return -EFBIG;
 	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
 		return -EIO;
-	file->f_mode |= FMODE_NOWAIT;
+	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return 0;
 }
 
-- 
2.26.2

