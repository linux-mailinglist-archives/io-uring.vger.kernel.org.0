Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5A01DF403
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387602AbgEWBvZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387559AbgEWBvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:51:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA06CC08C5C2
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id c75so5830333pga.3
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=viOUEJ1fR6EBYLV+aGk4n4pPCzVmSS3wNBos+myVsG9d41L0VNwWkGpSJmOhx3K9++
         f9KJqmYPc52aQNDh7YBCfGeiMDtYKLgYg3KJ8Tinr03i/xE1uwVTqvhDcqDMbeFtl0ry
         /Fbrftn8RXZ8jfaKQjlRMnDxcx7ZUeBqLwxIInOHFnGah2gnFiWL+aSKx/Vus5jvhAvb
         OUE0VGbgSSqfdsPWnexlxMY+WF6b/eVXTi5o6mZVwVvwHDPL5zY9JJY/lOfTSooU5zq/
         3vaOAuGthCRFAY6UAqlOO3/p3MtxKBubwxgq6lOmlbcoZuFWfQBxZer5UAP630v53ff+
         KF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=Lm9GE+wgkk3ROLbmNvIHUCjVz/Gz/nPStBSE7PRr/iTCrI/1pnAc9jNTaFDRErklsA
         KL+xcLUx/e8qSUOpyqWo5E5OF8zBXcXRyn+TnbF3h9e8fzTIuDHdAbCbhCBb1YwK7ZXI
         TwRw+UGrTfeq78hqzfE34A/XzHZhKTT1w2mR/dgPJ/1oMfXkyntda4RqQoVGphmeXRIW
         C/jMew2WIwo4O3s4ObmlG9Gf0STCSPxv/LU4DTz7hLalk/DZ4VlcwbPJGPN0jJQsoFr4
         Pju5TVds6yg3Ie9KkV/1dJjbVfrP/qrCcoyMNhGS5zohU51fgBejQ6msr2B2yal+d0Uk
         yhqA==
X-Gm-Message-State: AOAM532BgfAXxND9C+MUESv5aetAkZHfp8Bpt0LKrG9oqOyEpQyYs874
        l6rfGqqJ2zOT5Utw6vCPEsAv5OETAyE=
X-Google-Smtp-Source: ABdhPJxMDUN9GWGHzw/t3Lk7jZslvDAozX8xG9m2W1wpHYgfAm8cjUlGT/CMaOFe5dKd6Q6mLPzZ2A==
X-Received: by 2002:a65:6094:: with SMTP id t20mr16806792pgu.220.1590198665111;
        Fri, 22 May 2020 18:51:05 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:51:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] ext4: flag as supporting buffered async reads
Date:   Fri, 22 May 2020 19:50:44 -0600
Message-Id: <20200523015049.14808-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523015049.14808-1-axboe@kernel.dk>
References: <20200523015049.14808-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d624250a62b..9f7d9bf427b4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -826,7 +826,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			return ret;
 	}
 
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return dquot_file_open(inode, filp);
 }
 
-- 
2.26.2

