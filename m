Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD411E022E
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388214AbgEXTW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388184AbgEXTWW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:22 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F51C08C5C0
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:21 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s10so7788651pgm.0
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8utbws1RCqk2LlI7/gkB8i1cj/u48CIh6THWzODOXyg=;
        b=rMshiG8EIIFNL1uMBODlvvuf94bqJViNg5UM86151u5U7d6woOiNbIvEQgdvWkip2Z
         4g9+5vHQOuzDMROosjj+bj6Blg/CLhLK5vEV3DBUFxBJkdjuCBSJsZRKwURHWVWuMvkG
         8jOvtNQ6v64rSK/PJ1hg5+MO4hooCsE1eQwTAJTNiMD2VkHEx49zfrV59k1lyHvzxKNm
         tkmEJZl8YFSE/WZHCITDnBiis68jg0iqL//e/vmY2lJYseDiXfhsax3yzBXAV7qmApls
         ZMNQZ+Ki+d8QjYjq28AecXUf5Zy5QTI48QVIQDsbVIfZPAMh4PfdChp/zHXp9Qzbt71H
         d/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8utbws1RCqk2LlI7/gkB8i1cj/u48CIh6THWzODOXyg=;
        b=Oo6nZcSUWhje5VugYFxCllTMYPvsHQkBn0FrgwncWkVm/LOPnq/FaiklnJExcZf77X
         /HZJObEZaXYnS9DzomR0XX9cj5RLwZAfSDJDI7BokkFOZYfhaIXYtNp5IvB3VP+8F45w
         is5U762XKTjktdKs3kH2n09MbramOKtmX9zrK2DX4a10AHgqyaVf+bDlxRtSf3tGK2ja
         FhMMhFxwajNOZ0UUrhBM7djNVpS9qlv1G/m3nnxx1D37huJg1y8bW0XZYYau2vb6d2+L
         OydbzTkK0vFzUpHdaXmyOju5kUQPB7LWeOaAsJSHeNF/Yl3Sl4xfosVDlMRAGjZL70d5
         lPqg==
X-Gm-Message-State: AOAM530vkKlvgBUKstIAGLLfzTOGWSAxBRqcGlNiKI6UZDujeNdJGEAE
        DW32cMI4/ITVM0x/kHSZKueIZ/AszVIPzA==
X-Google-Smtp-Source: ABdhPJyYufZlJWGWTLeLNJcHAXoCD/f3jIKpvGkaNmPBexGhsJfRzmJtp4GI8lKYiNDw6AyYjV81Lg==
X-Received: by 2002:a63:1312:: with SMTP id i18mr6502381pgl.142.1590348140858;
        Sun, 24 May 2020 12:22:20 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/12] fs: add FMODE_BUF_RASYNC
Date:   Sun, 24 May 2020 13:22:00 -0600
Message-Id: <20200524192206.4093-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If set, this indicates that the file system supports IOCB_WAITQ for
buffered reads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5a5434ff7543..f7b1eb765c6e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -175,6 +175,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT		((__force fmode_t)0x20000000)
 
+/* File supports async buffered reads */
+#define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
-- 
2.26.2

