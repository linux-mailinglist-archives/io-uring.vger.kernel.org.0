Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B2A1DF404
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 03:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387570AbgEWBvZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 21:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387562AbgEWBvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 21:51:07 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D99C08C5C6
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e11so5047943pfn.3
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 18:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4QX6izj81MoWvGB/E4/khaJEguGwrdsEfxjduXmAWvc=;
        b=HWiIpVJ0rbiIpbanC9FRw7TVz9oZwP0rp5HJBm3PBdMNA69cgUdOvPeGShjJ95mpwz
         eM3w0I76JQXY6eewhOI6WGMug0mdjEcjo1159u1LrEDJkGVG2c94kRuWmswELgKMf5X2
         HSf3k1SDRGGiSfTt+N/7tUoMThp1Dh0szve7+DHCYl9OdA79R2zMf9RSfB2anFohfIAA
         uuIRNXjlGgGyAwDzXd0CBBDB3o6dSCZ5jSPkxxeardFObAFgRY35MpQHQmQem7PeBQ+A
         KAeQ3zurCwciU4RzhLE152QNK/Smu2h0cJ2hGTx2DLdnbM2FdWkGXcxhK+r1MLs96NR7
         jFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4QX6izj81MoWvGB/E4/khaJEguGwrdsEfxjduXmAWvc=;
        b=pcjTTVlKt+mHhhZtJcDSD0avdMjjuBJ+wupwtRUgg5hAiMxEdyscZ8mPRFqsmXaiXd
         Dlq6Zhzt2FOJ2RhUgtu2KK3R3KAmC3+nhyA54stO6XylUBQ/dUgYfZvaFom5sC7IkRtD
         EVNHzYx82BYRi3pafHP3++pYIazdfyqCjXHjPsrgOlrsDhxmjmWJ3fvBiwX1/Wy7GaJS
         BP91qauJHBYDurscYA3UYpity087z6fjn1NCJLiRaroo1Fe/ad9PSntZF5RbYVGo/UOB
         gH2fSZfzSODy/2weDuPZE0V/cxy2CO+ZCm+USXOXylmC0fxPoH0vFJZMZU2uwhCA8Pd3
         3dpg==
X-Gm-Message-State: AOAM531jRi1RXTla6p17NzPKMxIEeBDmgkvNIsruAQJ05BGD3GeSBuHz
        EA1rFjVXzgpYHbjJzzcczcK0NrBz9Hk=
X-Google-Smtp-Source: ABdhPJxGTsRVBy9xHpjhWrY0KMo+JW0XIbljpozkhKZ4qE+E/pFMPYZvl4ItatMrGzf9Se9U7xUQFw==
X-Received: by 2002:a62:1c93:: with SMTP id c141mr6669567pfc.289.1590198666267;
        Fri, 22 May 2020 18:51:06 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id a71sm8255477pje.0.2020.05.22.18.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:51:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] block: flag block devices as supporting IOCB_WAITQ
Date:   Fri, 22 May 2020 19:50:45 -0600
Message-Id: <20200523015049.14808-8-axboe@kernel.dk>
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

