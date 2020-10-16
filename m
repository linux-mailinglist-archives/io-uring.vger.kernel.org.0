Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A27290915
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410530AbgJPQCg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409138AbgJPQCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B372C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h6so1715341pgk.4
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Qe/LVPQff2q5pV8rh0BKZZu2GptzafMvIubbtw5LTw=;
        b=oGVYFFO3qH+fgu/cBDkvAgALfP5Jpf/rzyUs+TWTFqeN/x3nuXrJAwK682NYGmXAU7
         n4SL6pPEBc+mt8/VfBQBxwV0zA/64LUpGg1EJ8+kXBJoTeILVlV0d0bY8PWsOZR9F895
         vP9tV96dTsbtNZK3mAq14QYem0IcDDE6wxfFvlpcyLZC3UOcN0o33Z3sjDL5ejyVrkOx
         iYAbwhuOOrVNqIOvi+EKlynluglugpIIN2ZfQBWpgzLRRgEjAM8xFYjJD1tH1/zj79Zf
         Kh+5pmTbq/DvcwitQ606PNT+QMtmSr67PuiFwuTaLHW9zc3xIbxh1IpROPk4sAha/phi
         gSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Qe/LVPQff2q5pV8rh0BKZZu2GptzafMvIubbtw5LTw=;
        b=e6Y7o4m1ENgN94iEKDt//XaCZXhid9XOWSWeQ8wXdi3rVIFKCIXknAUzQ9njkSxhpP
         jH7vXbIx31o9zN1K7Ei9jgs1/UgCNTYaQxFXAdkoa3dfUcWjg5rjbSf8jxWtUCOwni8G
         VLyi3R9JyEQe2mfGaJmYes9910h+TY/EK3MBRS1COkWUKi8RaYSCn/f8Xq/3QqzIZ7CK
         UILt2W9J7xPuj/6OdxLKxXXh5Vbi3UYbkC1ieptW+5fgze7oGbZZcnZ50dsVGrBrdowl
         Mn/1D7z1L8BOMXulCxxCaM/0dnZYvDXM95pIgEU6JXDrmvwfrbwPdE7uk9v3u2QligbJ
         KwqA==
X-Gm-Message-State: AOAM531eYoQ784uTK15UOb1taN43uS1jGtRGh5HyveN+N9Z6q0CO9H1z
        8TSK/Psi5f04SnkZtv4RMof/e5BNLL+EnVFN
X-Google-Smtp-Source: ABdhPJzuuc3Yeqk8uobED53hA45j/VmtywNJOKimMrFAfgS5cNqQaekcR+rxYs4vk8aBCW24qKHIPA==
X-Received: by 2002:a62:54:0:b029:152:3212:f622 with SMTP id 81-20020a6200540000b02901523212f622mr4408432pfa.46.1602864152091;
        Fri, 16 Oct 2020 09:02:32 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 03/18] io_uring: don't clear IOCB_NOWAIT for async buffered retry
Date:   Fri, 16 Oct 2020 10:02:09 -0600
Message-Id: <20201016160224.1575329-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we do, and read-ahead is disabled, we can be blocking on the page to
finish before making progress. This defeats the purpose of async IO.
Now that we know that read-ahead will most likely trigger the IO, we can
make progress even for ra_pages == 0 without punting to io-wq to satisfy
the IO in a blocking fashion.

Fixes: c8d317aa1887 ("io_uring: fix async buffered reads when readahead is disabled")
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eede54be500d..8b780d37b686 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3243,7 +3243,6 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	wait->wait.flags = 0;
 	INIT_LIST_HEAD(&wait->wait.entry);
 	kiocb->ki_flags |= IOCB_WAITQ;
-	kiocb->ki_flags &= ~IOCB_NOWAIT;
 	kiocb->ki_waitq = wait;
 	return true;
 }
-- 
2.28.0

