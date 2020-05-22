Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BBC1DF091
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgEVUX2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731046AbgEVUX1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751CCC08C5C4
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k7so5409434pjs.5
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=dDUvxjbstbHn7Sjiy+FPAA2PEvxIM7GifOiRJeDAMSbY7yuZnnZssNPrW/E901JJmZ
         OiWeE8x8Dullp8KQX0tfScd3zLgJ5dqFDExo65YjCoSluEuUiua3jP++fR5YzUqru8zI
         NXVTSEKuAtwrG/ZRrJptiR6rdkUh3s0gV2rnNOuBXEHCRFP2f7G+O6Kd7xTEzLo5d7O6
         1kKmpbdn46318RaR3RoKDqSBHERhxohD2GZV8Ws+IOrzVKyuazrQVmIYmUbQkjczdFs6
         4tMUI5bcGqqrmfzKTUnEqt1xwSLASC838o8d/OH5NWXSrzKDy3ZhjDyXw5k2B4zWiXIr
         qkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=eWul4bRSsHZulbJi4LAQ6z4DyJOyNstyK9OJuC/E36PtJa/GlPCGu87n436shVneag
         XYnzU/aXR4F/WaFBLzlBarU9ZiO5Akx4YwC4YamVgrrRt0HjWY9TctEwOSm8XUb6fmb2
         cDDCCcDI/0cp4vHxr3fdR0NbHxk5VA+wBPXgnw75jiGjOGzSTvVa6SVpUH2UjBTkZimj
         mBD7S8kZX9Q0CNROyqc0w4UvT5hFxaOzYWyMZENo/+4YDLxe6aaFSqKVMgy9btIsBtcR
         Lt7bSHb7M1Xn8IF9kTeFR/E3zn/wGNkQj9582F8dCsiIh0+R0JkYd6Rnv8qy5kvt36v3
         S0vQ==
X-Gm-Message-State: AOAM530X9kJXsJExD39v/aENCXNhTUDuifaerBiUeeWr77nKXOpAIcu/
        OmbTke6W2eGqSo1T1U2TDpyo5e57OwM=
X-Google-Smtp-Source: ABdhPJxHHV8hqa7uaJgKGvaQpHrwfQ3OD8pDgEG5RnHU/xBhEFUUXMnZAbPdGq2y0/Mjy8qPwsjM7w==
X-Received: by 2002:a17:902:b907:: with SMTP id bf7mr16387892plb.136.1590179005767;
        Fri, 22 May 2020 13:23:25 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] ext4: flag as supporting buffered async reads
Date:   Fri, 22 May 2020 14:23:06 -0600
Message-Id: <20200522202311.10959-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
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

