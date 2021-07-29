Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4FD3DA710
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhG2PGa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhG2PGa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:30 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F595C0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:26 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so4265196wmd.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gQqHxgFrrYW46Qkmj1aQWq5ER5mnoLq4uIS2O+OthMM=;
        b=lGYmqXTclmytnN0tOb3dZW0uQAqrfCISNC/4+jW/8WwEI3pB9BsJDP8WyjWeT21Roy
         o8iov1QqwcdydkXq/Y4t4QvYgrvd//NCqp8kIDOxmhA/1g9RBUvdf4AcPqELWpVxIMDd
         kWXPfUczMyUh8lxMNm2gjF8tAhv1jp2v2L1Jk7oM5aK1isEJDU6yq/AxNLAhQhwQ8fw/
         ZbxaMSEAVubTeYNs8tZDPRlmNPQSpBNRuVC285WAMDB/D3hPFp832BVEMhP2ImBcH5T+
         fKogSIxnqtcEJsh4Rt1JtIK+zX1ScgqGZ/HglnPtD3sZ0vmwyEA+e5UUBSauMFspuZU5
         oMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQqHxgFrrYW46Qkmj1aQWq5ER5mnoLq4uIS2O+OthMM=;
        b=aLhibvjm7hrEeX5giLIcIGCMiqP4/xJugMgLYfnQDOFLz5nUjptPP9XX0NNfy1ApNo
         /Km8EAFu4d52Tpsx6a2dLGjlmHJUcoO3e+Y2vgNtzeVIWT7TGcLGWBK3DHL7Lk2ZBH6t
         AElst3EVh9DCL+AC+VKQH1aC6oI3aSgUvCj088eGyI7ofz9Oaj3J+AadY4u+LZ0568rl
         N6D82Fd4cDmXpD0G+963NTTqWildjocvJP5lrcIyHypYdzPHxbpLzYBC1IU+DC9sZeu9
         /fEk+HgdPj+GUzOlqPCu3GJwC7KfaqSOLyEcZjLTt+P0ZPwHjeK+ZNZ0PKBdK5ddNBpM
         QBjw==
X-Gm-Message-State: AOAM532bcj91+D0/M06J9lvZf2zsgCGmB+43lTNLQEBXrP905QUnUhc6
        aze3uagZ6tUPxSGmiVSZM23Um2sTL/I=
X-Google-Smtp-Source: ABdhPJx8102N+AoB9yqQJLvKIHjVkA02SDXcyxtGgy1BdDnkKCD9uMGT8upmzbMDltKQvnvIPodUqA==
X-Received: by 2002:a05:600c:28b:: with SMTP id 11mr14517168wmk.6.1627571184728;
        Thu, 29 Jul 2021 08:06:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/23] io-wq: improve wq_list_add_tail()
Date:   Thu, 29 Jul 2021 16:05:29 +0100
Message-Id: <18360c185c1681b0452eb1960cbad9b3fc5015b6.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prepare nodes that we're going to add before actually linking them, it's
always safer and costs us nothing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 3999ee58ff26..308af3928424 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -44,6 +44,7 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
+	node->next = NULL;
 	if (!list->first) {
 		list->last = node;
 		WRITE_ONCE(list->first, node);
@@ -51,7 +52,6 @@ static inline void wq_list_add_tail(struct io_wq_work_node *node,
 		list->last->next = node;
 		list->last = node;
 	}
-	node->next = NULL;
 }
 
 static inline void wq_list_cut(struct io_wq_work_list *list,
-- 
2.32.0

