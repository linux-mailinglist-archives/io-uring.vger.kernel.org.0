Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F84213FCF
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgGCTRI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 15:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTRI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 15:17:08 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D735C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 12:17:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so30916158eje.7
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Gype4CDbQgmsr6Q3MoeGkTYB1aX9ic4h77gFX4ILSJI=;
        b=VaWz6AqQ7b1PMuwYQHb2RFTJngNONn6JOdsbECCu8VWXTmbK+zm6Gp3Zr4Ed7maBvJ
         39ik+X/GF7hBSbYjgWCxp8VWPhFSt1TceGOg5CN7n8/1nNg7h/NHwxNKFx1sHYgneI+9
         WbjxbJUSbtDf1ItoOAKmMQ/HpoJ4Emah6Roc3NYwNgAEcPL6YARW7j5db9pBhJ1EvyPs
         b1NApHZpfYXKGL/RYWsSTpyQ1RwAtAXg386OAGlswZiq0A563T1hZ5FOpfql+jofCzu+
         vaRI59jnufUATbhSZjSevE1s0BCoBGF+NYDUGd9Q+9JsuqQ+luzt3DvmYAhgWfnvmT4W
         Kk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gype4CDbQgmsr6Q3MoeGkTYB1aX9ic4h77gFX4ILSJI=;
        b=sIDb3RlhCCZFXn/A6O8Tk4jIXIqV0vX3eW7+f4lKolFOaglm628uXrllt46G2om4nT
         YIKxOZ7KlgDdJzgL3OQquoU9k25zUU/H+1sryUxBqdEw86vdHwzooapRomrf/hxTf0K3
         uALrxHpw0azcQtVxJHpI3+QkSf2vUbnfaOSC9fzKZBOSFkPfImb0pEoE5BpgJUgS6yzL
         1X3OOtCekubgiX46io9oETq8LEQj8UM5d4YnS6RBZJSEDcidFMIqYqiZbSjtfpXfWzO1
         j1TZw5kajoTPjyYRzpPXif5UL9N77m3TBHgiH7gptTpc46q+tO2J33fDW2BtCRvA2RW2
         GImg==
X-Gm-Message-State: AOAM533pMY+jSmdlzp2TmhiNiEB+2S60IYiEAdVT08AyYWYF/mv6Whun
        sagHuAMzNhYQENQ9V3sz2NoNm4SS
X-Google-Smtp-Source: ABdhPJxUMfrK0JXNGkBu9R3NVMdhfWM8eWlEdf79JfqgWJb9eB8flrX952ZIXurb9+o6F13I3P9Iug==
X-Received: by 2002:a17:907:2654:: with SMTP id ar20mr31794453ejc.62.1593803826902;
        Fri, 03 Jul 2020 12:17:06 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id p9sm9907883ejd.50.2020.07.03.12.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 12:17:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: fix lost cqe->flags
Date:   Fri,  3 Jul 2020 22:15:08 +0300
Message-Id: <0ca2e3872ff7d48132f77fb05dca3a519ee364b7.1593803244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593803244.git.asml.silence@gmail.com>
References: <cover.1593803244.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget to fill cqe->flags properly in
io_submit_flush_completions()

Fixes: a1d7c393c4711 ("io_uring: enable READ/WRITE to use deferred completions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d61d8bc0cfc0..a2459504b371 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1416,7 +1416,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 
 		req = list_first_entry(&cs->list, struct io_kiocb, list);
 		list_del(&req->list);
-		io_cqring_fill_event(req, req->result);
+		__io_cqring_fill_event(req, req->result, req->cflags);
 		if (!(req->flags & REQ_F_LINK_HEAD)) {
 			req->flags |= REQ_F_COMP_LOCKED;
 			io_put_req(req);
@@ -1441,6 +1441,7 @@ static void __io_req_complete(struct io_kiocb *req, long res, unsigned cflags,
 		io_put_req(req);
 	} else {
 		req->result = res;
+		req->cflags = cflags;
 		list_add_tail(&req->list, &cs->list);
 		if (++cs->nr >= 32)
 			io_submit_flush_completions(cs);
-- 
2.24.0

