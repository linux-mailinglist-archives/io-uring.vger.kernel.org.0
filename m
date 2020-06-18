Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB441FF527
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgFROpK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730992AbgFROoU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:20 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E32C061249
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r18so2986162pgk.11
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=KEZHLow75x1WGZauUbfw6ciLmnTzXmpQXtEtlinmygw=;
        b=HvZc/ixPovm/kRhvl4SJUiwM/PVM+gQUGpw4gn7GL1Ek48GAAcFBxFJBO4YBWLb0Y9
         Oiqk0i8f6vQ1Em168554rqM+AcEyk7rObxLac2g8tH1Pd6I83C8/2mPcrM6EC5HB+yuI
         ZQq+xXWBQ17rDR3i6if4Yr3L8h/fWDRW9Sjj870yRZqr2dNo7/szXK+hje9neRqzDGj1
         k+P4aQd8v6FJFSOymCFraV22X6dCtjZ03CNMccoXsgYKxxTrdgIEeGkBWmuwX9eMXQVf
         6oKU1HJcojpsQ/gOVihItBajLbiifqA4r48bx/wgZ3Vs2f3Le4J1aEEGs7KW+RdevsH2
         /nIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=KEZHLow75x1WGZauUbfw6ciLmnTzXmpQXtEtlinmygw=;
        b=nRRSz8N0g8tZ8z5oqiweo2zQOL1nhWRznmVl4Lepj/rYbN6HSqEEKfUxG9N/2Gt51f
         rn53a5sqVZCGUe5aa2yF0KGKKf1bVQ8NejAF/RvjydvAJ35gZrAfIc3llKL1dgNk9jLx
         Y5ppGmRQlh3Bz4ZmURTckG2NozFesQPJAPaXjLuuocUYutnVMs97dk+mjZz6AgdcTjBm
         pZhTXXF+12AisYjNr4bbSHGd5Xn/uxFkqaYXdO2ghgElMo2htbTRRtBNUtpFUgFMUs1f
         tPVTiXY/2KbuhjxsO3kjIlSX61USBNrSJnJ29Xut/Ir34PMqiaqAhQlPxhEY3VvnEGKT
         289g==
X-Gm-Message-State: AOAM530hJyy8a1nWLnnHNP+DiU5F2IssrklkfsFIxJ8V1O4jvLwTcMPB
        c21pFGAeG8AcKGnGDXV4sPxqaDhTDWQalw==
X-Google-Smtp-Source: ABdhPJybJIEFYk2ErRp3fvA+q2tyQLM9BD6LGpYjoii03ztTUTqqX4O2JwO+0Ij8wpxOd+bSneCDiQ==
X-Received: by 2002:a63:205b:: with SMTP id r27mr3555018pgm.326.1592491454092;
        Thu, 18 Jun 2020 07:44:14 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:44:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/15] xfs: flag files as supporting buffered async reads
Date:   Thu, 18 Jun 2020 08:43:51 -0600
Message-Id: <20200618144355.17324-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200618144355.17324-1-axboe@kernel.dk>
References: <20200618144355.17324-1-axboe@kernel.dk>
Reply-To: "[PATCHSET v7 0/15]"@vger.kernel.org, Add@vger.kernel.org,
          support@vger.kernel.org, for@vger.kernel.org,
          async@vger.kernel.org, buffered@vger.kernel.org,
          reads@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

XFS uses generic_file_read_iter(), which already supports this.

Acked-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 00db81eac80d..fdbff4860d61 100644
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
2.27.0

