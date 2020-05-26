Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFBC1E2F61
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389933AbgEZTvw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389772AbgEZTvm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29322C03E97A
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y11so829335plt.12
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mDbeWlveWyEr17EututM6ewZlLrenoq+wrG4TB+c+O8=;
        b=UT8tDTtjIxNNLckeUW39C1DftMV8tadKSzZHS24JY/ZgL6QUhytEvq2lkIf1qolpKk
         U19xBYg0KGV33rpnvi79D2PmiTq7vV4GnQy/vbDB5t3xuGIzSzGqlvQmaVY0B+9G+GIX
         llYo8cOvcrKG7jjvG4eBsx1q+LF9dT2crnAC1DmoY/wdrKeOH+NZ2+jAdxVlTNFeGy4a
         bQz1a2+aBWm5/WLAaDmlh/4XzvXPR5G3jeezjLE44Z3L1BaD260oHfxmj3fx6/puUmDQ
         a+gZr/lzYlcH0GBmCG9QZp0U8aQKyRwejv/NOtaCLlRLWl4GrEw481VCXscus2avzuQ2
         95Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mDbeWlveWyEr17EututM6ewZlLrenoq+wrG4TB+c+O8=;
        b=mP1En4lYIGkkMqJ+H5NLtmdP7J1/ARkxV15LOSE/pfLQYl2e3yqHUBCug4BrsP3ZHg
         GqWBfNhEev1DZoxJ2Aa9JG9pZhHF42/GkTfXBF8z9fzNS5JOlnPXFKD8T6Rdp+l/1D+3
         t00e185yAj0kbqMMx6XKs+4c3KmUzxFwrCm7C24Bf0WwPIobf+EYIrkP5l18mpCYPSHw
         dFaJ7zh5fTlwt7P6mOs+0V7Thoy3LlkRtFolSfWmKTuJSPfymUgYgfX8Iii/ZvI97e8U
         sPP/vQRjmncoKK2LD+iBhtrxr3EJll82fEcg+hm9XrVGkuEicfyA5v9Fx5n4bOTyiNTN
         aUhw==
X-Gm-Message-State: AOAM533u/YuV96BEhMxT3OOeDvrrbq2zVJ0Rhp2Xm6HdFHb/Kr6CNmpb
        NMNETVh64o5AT+uTNzrMvHKowh4etQFTXw==
X-Google-Smtp-Source: ABdhPJyosEhz0s+kAgLEF75WSYNIzH1LsNfIRNs9Hso+92gcwzjdxDZZ5u7k8VwB526quKNtSk2K0Q==
X-Received: by 2002:a17:90a:a78f:: with SMTP id f15mr930733pjq.226.1590522700418;
        Tue, 26 May 2020 12:51:40 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/12] btrfs: flag files as supporting buffered async reads
Date:   Tue, 26 May 2020 13:51:21 -0600
Message-Id: <20200526195123.29053-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526195123.29053-1-axboe@kernel.dk>
References: <20200526195123.29053-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

btrfs uses generic_file_read_iter(), which already supports this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 719e68ab552c..c933b6a1b4a8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3480,7 +3480,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 
 static int btrfs_file_open(struct inode *inode, struct file *filp)
 {
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return generic_file_open(inode, filp);
 }
 
-- 
2.26.2

