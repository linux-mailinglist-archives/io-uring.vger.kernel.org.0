Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675C01DFA6E
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgEWS6O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbgEWS6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84775C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s69so6444099pjb.4
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39qQrTBLEctUrGanLy/C45/WjdVfQkC7faPzmr+qhpI=;
        b=aKd+2/L3zhcWktix7GTJLEddQj7iHGpD8+Gbc5lZhZOPOtmfTJSybdWwo7P0uIA+5v
         nw2OIz8yCOB1kQ+IBoWa2qYrd11KuhOSiTCgjz8Jjm4+Tbl8Cf41Vg52NSUaa9pR0Tks
         pkC3Lt4M+d5mqE795NFN0OzGrct0KwdthHdOM6Z+6CVlf/5eQQtIf3ehLbgkfuqZc8TW
         LGTqI4HsD0RR6mx2SM2tRYFi+hbvTahsWpdHb5Bev/u13hAyTFgVlHtEXxkQ5BzcNmAl
         BuEeOlr0w8tDobCzI8GcOwgNnklK24cTNiXcD+JIsmWtWOcPcpqxO21EEftbMqyXTPz1
         WWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39qQrTBLEctUrGanLy/C45/WjdVfQkC7faPzmr+qhpI=;
        b=koF4wTslvEhEkJes/cblw1TCrMEKNru5VL1NhD0qiruATSbe4c5z1nTg8xpm2m6xXk
         MDF53j0oY73ID5/yaiQPLxQObuRXk9frsKZIyrOEP/5aOZfkoGwk9shbTO4/8fQwii4B
         5Vi3nK7krHhUQGhp3s0N/p7ilpDSM5OaH0ChWG05AKG0SEJ2CkySzZca8xXOCn9FXV1b
         9y/lKvAaWGIUBFLV4qpbjyRRpd8oRZ3rB94hKjrEmkw4FXViG05QPUXFRq2Lko7MxF0r
         /ptAoaUBzp55L7ZZr6feGcQVGO1OY9lIUXX5N83wG/Hk1P/lK7nvS9dyEkeDFZYnmioj
         FHXQ==
X-Gm-Message-State: AOAM531ffVzNL/a/H1wE4HO+EyqmNU1CDDzmKKmp1nqufxdX9EQjk8w7
        uHi4NI2h3sW8/J8pNrsHOFWeF6jkwmkwZw==
X-Google-Smtp-Source: ABdhPJzz+UanoYeeFHEpf7tdaIQvpR4HprzsHsuIgK/sPHYRYz8bhbR5K4GsEWQ0YkbTx9slFOzW/g==
X-Received: by 2002:a17:90a:930c:: with SMTP id p12mr12921445pjo.64.1590260290884;
        Sat, 23 May 2020 11:58:10 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/12] xfs: flag files as supporting buffered async reads
Date:   Sat, 23 May 2020 12:57:52 -0600
Message-Id: <20200523185755.8494-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
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

