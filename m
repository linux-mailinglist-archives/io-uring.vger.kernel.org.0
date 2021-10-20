Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE085434749
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhJTIwI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 04:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhJTIwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 04:52:08 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D60C061746;
        Wed, 20 Oct 2021 01:49:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gn3so2033113pjb.0;
        Wed, 20 Oct 2021 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jyt9s5cRU7FXF5oC4SgHHTIq0zq6TPvhyZdksmJ0x0M=;
        b=aiEkOcBr9zG3Qmt6x4B2KUtMLQ8WThuO6GHvQFpa4sjoZuS61iPFnZhGUrMxz1ZzNj
         +KuGZjqjhc92qxLxruS++xQfUhDE502eG7clHSUYELemi0Of8bW5wJS76TngIIseLRSj
         qr3Qz+fDE5dttwy2Vu/szfe+/SrE784nKroh6TbtGO3DVHkwf6+LZJmSUp/XzoL0p9iO
         kTVIUTatLbqIFgWKo/s2/bwTQQH+FIKNVugJ+mPus18RPJyARfX4h7cvBc4wdq+60fnD
         +ZcU5x8zlEQsC+/zoQkjOygsl1Jt1gH2qFMJ4Y28fNEBu2/9bRZVDOMFxlchhx3E3Usr
         PMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jyt9s5cRU7FXF5oC4SgHHTIq0zq6TPvhyZdksmJ0x0M=;
        b=VzFuSkc/lEZ3/wXSFmedI3Ly0E5k3/y+u1Pzm2VZtc8HzkCdXNVDX9a/Eq5dAERTFg
         V4BniXWe0gKOeQLyB6vog+aBJirm/ErUo9dkFG2lNgC4qKIFtPIuR/NcP/f1W2ofXKCk
         9yEsn4t4gNqGcceXy3C1M1cfV2OduSgAuV51xF+nww2uxWDVXHg8jG+fZSxox87O1sTS
         pekDgVBrOXYIj2OgI58S0qyhWStO9FKPMK4yeJWN5m4sLYCQq/jGjKeb6nmZh6bt6+fM
         jQIt432d2zmhSlvEizV7fhI9kdlJDk3pTHK1a0K/v7R0HCpWWh5kNvuIEgiyZaFIVlPz
         I6sA==
X-Gm-Message-State: AOAM533uJL3kVWW26ODvyqDN8bcJustdM0pKgxs/P9buxexrLGjqC7pM
        t60KcIWNFXr8Qhd1flf7Vy8=
X-Google-Smtp-Source: ABdhPJyg2bMkOl0G8V6eyvGnGr3MzchNpEvZX9+558Y8yf3981qv2OqrcvMVOgfl4HRtAj+1Mk/i0Q==
X-Received: by 2002:a17:90b:1c02:: with SMTP id oc2mr5827402pjb.128.1634719793955;
        Wed, 20 Oct 2021 01:49:53 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x7sm1687874pfj.164.2021.10.20.01.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 01:49:53 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] io_uring: Use ERR_CAST() instead of ERR_PTR(PTR_ERR())
Date:   Wed, 20 Oct 2021 08:49:48 +0000
Message-Id: <20211020084948.1038420-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use ERR_CAST() instead of ERR_PTR(PTR_ERR()).
This makes it more readable and also fix this warning detected by
err_cast.cocci:
./fs/io_uring.c: WARNING: 3208: 11-18: ERR_CAST can be used with buf

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 695388aff926..e2d36607bf94 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3205,7 +3205,7 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 		if (req->flags & REQ_F_BUFFER_SELECT) {
 			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
-				return ERR_PTR(PTR_ERR(buf));
+				return ERR_CAST(buf);
 			req->rw.len = sqe_len;
 		}
 
-- 
2.25.1

