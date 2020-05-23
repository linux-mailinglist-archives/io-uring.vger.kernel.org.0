Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD091DFA78
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 20:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgEWS6L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728887AbgEWS6K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 14:58:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75500C08C5C1
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ci21so6452685pjb.3
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 11:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4QX6izj81MoWvGB/E4/khaJEguGwrdsEfxjduXmAWvc=;
        b=bB83Tj0BajwuSjWkcK8ehgNRsKT4dlqQdsgUPSjJiJ2iXaFPJSy+fQuN42JRHiuPAF
         Ds+TSO9sTx+8fbiOAVgtOWX6Sz5lYix1bG9WAh/F71WpAmuz6k6RoGgcULfHqhCzSSGy
         czJK+XJrC+LZTYdNLs5WA1tyopGAN51nNSKpEc4rmPTh+HjK5AUz5guhgngWLdElEoFp
         Y/U216s5zcrGi7OrgxVS0H1boXsUkpjkDmicuLJP4gJCppIK3k1wT0URrgfknJrl22Hn
         CRM8C/QHbp+xO5nT35RB17ABqdwxlpAFz/I5f7IJcf47ml75nwLzUmNlUz5/4oEh0drP
         Oicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4QX6izj81MoWvGB/E4/khaJEguGwrdsEfxjduXmAWvc=;
        b=h/U2sSLu3AQ2gd5nsuVH5r5XegUrVyugQ6+QR0rmNQFJThszhTPm1/z6zYuaRvuw1h
         JEBqy6N9RZTWbQuuwITelyQV3mv1D3CEZ/2sOWt+TzecvP3q5WGkwQ/PLiwr6wznpReC
         RhUrR+SF6ouSewYL3TxW+VSKIqXDi4sfwqNVvtcuULszi/qJc9TpCxd2XB4vw22YDc1j
         ayuK8fWDkSvMeg/dyKSMnK82CxMc4TulxCtkXDm0IMn7anoYqsLASneyzu0LduKTQ0S8
         Os+oNqcErG0pPOG5gduigOyFaXyfEOuT33vSOzxKbJoCgiNlL1TlrJaH8gkUPeQxDS5l
         pj2Q==
X-Gm-Message-State: AOAM532buIkTd2tKdkqfNRwISjDnXCYUkze4zyNT8ih20kawR2ydvhcw
        rs9x6rNM0BGW8DYZMm83LDkU01TcFGtI7Q==
X-Google-Smtp-Source: ABdhPJxtwoGUVtGeMjBKBqTDc5pH659x6OQMxIcezhl06qMF9UwN+jLw7DQKIdSMErnJ/wvDE2IMpw==
X-Received: by 2002:a17:902:422:: with SMTP id 31mr21310761ple.310.1590260289753;
        Sat, 23 May 2020 11:58:09 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 25sm9297319pjk.50.2020.05.23.11.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 11:58:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/12] block: flag block devices as supporting IOCB_WAITQ
Date:   Sat, 23 May 2020 12:57:51 -0600
Message-Id: <20200523185755.8494-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
References: <20200523185755.8494-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 86e2a7134513..ec8dccc81b65 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1851,7 +1851,7 @@ static int blkdev_open(struct inode * inode, struct file * filp)
 	 */
 	filp->f_flags |= O_LARGEFILE;
 
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 
 	if (filp->f_flags & O_NDELAY)
 		filp->f_mode |= FMODE_NDELAY;
-- 
2.26.2

