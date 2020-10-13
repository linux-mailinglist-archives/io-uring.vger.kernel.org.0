Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765D428CA77
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 10:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403970AbgJMIrA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 04:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgJMIq7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 04:46:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD04C0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:46:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g12so22965910wrp.10
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3AUN+1sCzLhTTpnYo5E1q4VgfieKJgzozs5jSYDKnOM=;
        b=iGXMPpLv9WjonktcHpxFW2dwEuOwhPkzBiOxqQd4vRLZMhPldFbivonpTMoG8N4PAM
         SNJ4/KGdcMk+2r0LAZmnb8lnaS6irPuGOrggnVxbQD42Ahf6UPLP60nFe3cfmlzfpCH8
         D145F5hdwGWI10fk1oiya/2/aHxW2apUwIFAH2CQHpPQxKumGVp7KB6WOP/RgxgkIk/g
         heGxUKJ2g+i6XOSuque9NZqVCwGR7joKsDHLJoUsX7tBmUHdRIpN2lo+U2Z6f4fdl4mq
         ijrcZ+1PML7XSa9EJrew9Hx0oMnT/TbIXXb3iuhsfPeZju3S5flJ3MyJkQDD/0ogWtxK
         i3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3AUN+1sCzLhTTpnYo5E1q4VgfieKJgzozs5jSYDKnOM=;
        b=gYI/F/zL9xuwA0ZrXla4ZCRL3FPAi69BFY7aw7rKIaIeP/6XO3PtL0d9nleOuVjDc/
         jcIODLQETFZjn2ihhXV4Q6jsbRKo180MkwXffc7v/LQ0sDnINcYgEYJoKuGmQ5gtWcLW
         VJq4u8017cc9cndxDAPk4ny3bqs5yUdAAiNgx1rfYab96zQae8E2FZEDWPM+qNVa4bi4
         +5SlBMgvQ/vSEXztKUpNzvbQtHQavXzv1guzYQrW6et8h0mMfUKke04L/jPxC/x5HFtC
         BrC+/N+TAsqixyYVXhoG/JmOieLjQ/owL/vC837ItPbyph7PD91fH2KgWW8RqOyPckwS
         dZRg==
X-Gm-Message-State: AOAM532sJinGjjFifcyNP44zsCFsXpILrwm5lWsvIv1W8Yw3SKtRRwqy
        piDbeiTjZ43degUQl66pizwx8Np25tw=
X-Google-Smtp-Source: ABdhPJxS+eRY2joxwC9F9T4CfKu5t3O0JDApZbF9zV3f05KEGCi6UqwfwAKbsAxf54yLqAowhOelfw==
X-Received: by 2002:a5d:5344:: with SMTP id t4mr14777942wrv.267.1602578818314;
        Tue, 13 Oct 2020 01:46:58 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id p67sm26445168wmp.11.2020.10.13.01.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:46:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: don't unnecessarily clear F_LINK_TIMEOUT
Date:   Tue, 13 Oct 2020 09:43:57 +0100
Message-Id: <e604009f225222c16c5629e5cc34277a65839739.1602577875.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
References: <cover.1602577875.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a request had REQ_F_LINK_TIMEOUT it would've been cleared in
__io_kill_linked_timeout() by the time of __io_fail_links(), so no need
to care about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e73f63b57e0b..3ccc7939d863 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1861,7 +1861,6 @@ static void __io_fail_links(struct io_kiocb *req)
 		io_cqring_fill_event(link, -ECANCELED);
 		link->flags |= REQ_F_COMP_LOCKED;
 		__io_double_put_req(link);
-		req->flags &= ~REQ_F_LINK_TIMEOUT;
 	}
 
 	io_commit_cqring(ctx);
-- 
2.24.0

