Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EB21E0229
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbgEXTWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388211AbgEXTWY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:24 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177E5C08C5C4
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so5699435plv.9
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4QX6izj81MoWvGB/E4/khaJEguGwrdsEfxjduXmAWvc=;
        b=FrXCWih/fqy5rFigNvFp2soetQnTjk3UWgjf1t5Fq9zUKajb6xucJmoe4faadG/Dmc
         Lj7A8hdDcSd7cwHUcnjgUu9TkCTHTVgWOuBdk6bdc2aSoswqnHSy3nb37tiShQKrRgwU
         kQGRSX/5Ki0ECJ1FKNiSS5m/Un75CkOharfLmwwahvohU6GmkkVM8hyoaWdv2bMn8DL+
         UUnlV+L9+B+Jj9LPHpFsrshojMI4VFzFwwfeQ/C5Uc0g/CKzE2PcxT0SqhVO8/D14I3X
         LUxExRTj+3BF9xbf6ZL8baH0FFQafDwnYkxJYf311W2Wnbkzfk3xuzawz1p9wlX71+uX
         ZuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4QX6izj81MoWvGB/E4/khaJEguGwrdsEfxjduXmAWvc=;
        b=XMMY8uc7alV4sjg4dXluFQ65xh9P/PkdeMZ21PIhJAulZ3SqXNgUpvbFkRQrOmcwg8
         MNrf8WhsqzVu2dflmYs2yOvHq/J+4KRD2y45L+vDE6xHM3Y9lb/wn1p1ET4Ht3ZH8ei/
         MdowVqYjttVcYtPQnbvTFb1T9Hsu33d5RsS7iAaa6ZNE25j9vWrQyP5c6s/e2FAeQtWb
         unCsEtsvggDwuYiA0Dxxlfn+HYDiBHF9vFoIqCtMqrFjKUQFpq4ni/B5uxiN28xDtGhC
         4320RPU1TCq4hBzZQjEo8RWL5Ons5RTw3PR6dBcsoIdiHVbcss5hJVSSKoQlyTmt0702
         sFcQ==
X-Gm-Message-State: AOAM532iVtWGdMkYKkKlCPS8ZESMsl/1EOqh4PriPGZK2CXYvPEcYKGB
        Z8j72H5IbwrFZ6ZJ60K4T0BH+AVQqPPMxA==
X-Google-Smtp-Source: ABdhPJyjDCYHAk0AUhemwGeKPxGqOTLpvrciZlQVB8VBWPs9J2AE+uiuLeGMBoKTiCckFgaWydI+aw==
X-Received: by 2002:a17:90a:1303:: with SMTP id h3mr15729181pja.44.1590348143383;
        Sun, 24 May 2020 12:22:23 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/12] block: flag block devices as supporting IOCB_WAITQ
Date:   Sun, 24 May 2020 13:22:02 -0600
Message-Id: <20200524192206.4093-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
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

