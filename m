Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8932961D9
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368715AbgJVPqS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368712AbgJVPqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:46:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0821C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t9so3011097wrq.11
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dOjZT4C8sUQX5awNW/R97YbbzveNXM6Uhahqy2PTIPQ=;
        b=MIOOzNgQuID9KZcvQNh8PlijHmhbBZhm9wCJNhxjTlIOe1yvENXUVOa+XJiiOXumTj
         Fqah0wPpEPk3oxztIsVuPYB6iYsFKqQWnqNF0bxTMJA1WDaycRejt0v0DDNfsb33kApM
         Z554BsOVvLtDcA/hS2OBSOKhfZevDdmcWRGOGPSsUE1S59as5CUYocQ0599FkgwK0KAT
         sHhP+F65vNhQ9rHmNXJeu1x+jX5zYwUnICDQ0RjVHLAy21IjJFLN1MFXMtAvEYvqfXfw
         JdyRb5uYPmoNIdnBy6OQDHftA+KVHAES5+PU9kgzvGmCCF31Ia8Qr/r2XH/nXhVM8MeG
         Bdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dOjZT4C8sUQX5awNW/R97YbbzveNXM6Uhahqy2PTIPQ=;
        b=Ja05BHWRaIdx6THLF+7LCKzpWDLW00+n/B+axheOFi5sJbpP7rvcG4rayP+KbYbXh1
         V02ZWj2eI0C6byjQEtwT7rn+/rcBuUHEhsYZyr6axjHTemnETfXA/l5glFGFiikFTe1X
         818jPeEgacl/OstSMZ9Ab6yPRIpiBW/qj1wcp+t79FqzdL/NAZu71MtfrB5NKKIgN1f0
         ThASYfH+yBZ1cT55AfC4Ua19cweAc6s4vqkFDcaLbWLk6bdD/hvigbJd00b3+DTObvFg
         0B5ypORbfnZRXj1tjtgWjFG7e+e7o8ZLf87rJcZ7cHa4H5kOFlA5uS58hwobOMAXpYn8
         RNPQ==
X-Gm-Message-State: AOAM530+dxyNIdNSGeDlbPrj5Ab7ESx9Ggh8wILE76MPizT79q38knzV
        ANti/XrYFCatdf5JZJN/RqE=
X-Google-Smtp-Source: ABdhPJzNTAnaNdJkch8sInsxSsNGOVegidTi7Xtz9Gn6v6/CnNhW4KKn0MQqc2ypae72IVkynWs7Yw==
X-Received: by 2002:adf:bacc:: with SMTP id w12mr3647372wrg.66.1603381576758;
        Thu, 22 Oct 2020 08:46:16 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s11sm4329536wrm.56.2020.10.22.08.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:46:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: dont adjust LINK_HEAD in cancel ltimeout
Date:   Thu, 22 Oct 2020 16:43:09 +0100
Message-Id: <eb5aa148a3d6318fd5d876d346ad167d664ec4bf.1603381140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603381140.git.asml.silence@gmail.com>
References: <cover.1603381140.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

An armed linked timeout can never be a head of a link, so we don't need
to clear REQ_F_LINK_HEAD for it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d9a017b564a..5e327d620b8f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1856,7 +1856,6 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 	if (ret != -1) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
-		req->flags &= ~REQ_F_LINK_HEAD;
 		io_put_req_deferred(req, 1);
 		return true;
 	}
-- 
2.24.0

