Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A7F1E0235
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388090AbgEXTXF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387854AbgEXTWQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:16 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6886C08C5C2
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:14 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so7674182pjb.3
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=gxGduZqosF0z63K53o9awU20QA6ufSZ5TTqRe+tv3AOsZ2QlQ979YXr+1dskXq52Jk
         HS3I9zTGgZsmogN4rJCO292dN+jQ4Bh81nqndOGDqgUTCuNwtxtCzXuJPlAMKQRJ58uA
         DuMNOBDX6nN/HrDjMdSSysjmoxpz5chCYgMsvnmdpOOufOk2jA7gdSzJR/TzXpAMz7Lj
         M0TIw38/7f79f2cKH+xUDuzBnClVTmIWWKOLweF65hex28srdE77jZIapgVeALrqEfAA
         ocGg0o8OhrW4mbtznbLks7cKK3H/ZDmHlmgcJ/0qYgXMDuB9nDi7913IThDZ9hVUMz+H
         0p2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DT9kV8IQxC/D+uhFJsefv+iJT3TxYB4ReZ7s4ZFOil0=;
        b=Czbqx2xcNeckqqJvUIMEHuh5Wc2kiuKQeaxgpp2t8dQJjWATlhDbWI4E00zx5/e93U
         xvJrVYqo4kjgIEDiMvFXQVIo0rMHTXbkA36TX/2M8WdJ+ybBHakLSCS9qhd9fv1TjhKg
         wArFbX6mmEIsfgjXEMNXGYlxrgkKPo+JHjNn/F1bu+WNu8LmZGPr6s3Zm9+P9QsSkV4a
         DBL9EvvXbdvSK7x8hX0Tnd4K/R9bR6VJjFoSiQgcgl7l6NXNm0GtrKUlr3J5H7fqUfG/
         PA7/Yoi/RNrO91SGa5Qx2lOIYQn93aln8ZsZQdIGSWId7JojCtaqxDkBHA3INIvyFlff
         OkXw==
X-Gm-Message-State: AOAM533E4kRhEHstoDPkBE71UEIQxOJGHoJ2K/OTYM57BSugcK5EfMUN
        H+AT/+I8K++S+m86mTNEKLm3rWs99W0eKA==
X-Google-Smtp-Source: ABdhPJyWrtKyXRFlA4SwqdiGTTumD68oCqrgZnBOzPkJTTFSdRxzhdggPB+vLC5MAtEqdrvZvv1y/Q==
X-Received: by 2002:a17:90a:648c:: with SMTP id h12mr17363317pjj.229.1590348133979;
        Sun, 24 May 2020 12:22:13 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/12] block: read-ahead submission should imply no-wait as well
Date:   Sun, 24 May 2020 13:21:55 -0600
Message-Id: <20200524192206.4093-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As read-ahead is opportunistic, don't block for request allocation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/blk_types.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ccb895f911b1..c296463c15eb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -374,7 +374,8 @@ enum req_flag_bits {
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 #define REQ_FUA			(1ULL << __REQ_FUA)
 #define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
-#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
+#define REQ_RAHEAD		\
+	((1ULL << __REQ_RAHEAD) | (1ULL << __REQ_NOWAIT))
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
-- 
2.26.2

