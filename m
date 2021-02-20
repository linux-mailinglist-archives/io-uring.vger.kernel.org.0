Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D89320697
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhBTSIa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 13:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTSI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 13:08:29 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13228C061786
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:49 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v62so10654245wmg.4
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZyTwY5vdUUD/+YZlFi12xNn+AuHE/EaDeHywsrNm3PA=;
        b=jDjLSjoxBicLN3SxILbWYzTwbDv02ct/7Djl2SAW6ScFtPfuypYGc8xycqRNnypF5L
         ChlFZPfgCJbfcnQN0E7jRsubXAk6ssKNDbw77XQYAkpny0QXFxmvVCLW+h41kBMue3fq
         nr0zdVLeWQzM9ZXYhZtmDRoqKVXdp+So9ZyMG9QrbEI4OrDouk418uRGhZ2N8Pc5Yme6
         5qDGYt4EsNcxM2gdNyy7Stj6DAA+HMgGcsrtjjwnrk5s8fuGv0ns2qYc0tKYw2iaX4tW
         Cv0NMKNxL7HXjOuvOOS0NeFbi/xCK/v4EePEhMsYFz4gBY9SNcUJmrR4P+glnZo4HSpe
         Hy0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZyTwY5vdUUD/+YZlFi12xNn+AuHE/EaDeHywsrNm3PA=;
        b=G6/gbghRPHETl9NwFLL8MQCk1pgzw95AKJ+/TU2dVjGKhA2WoiUubFuzJrVZb3dFcI
         9NT4Ey9fUXtQ1Z2g+EqeZ8v+v1rxDfXnOs85XTHzHpWB8tCLGJFrTCWb8ZKMAqWcOPo8
         4JGjECxcNAC0VDISiNp/MCPvnjJ/s5bCSrc8MPi71fR6HzmOb46//Rpgvzse1m4Nygma
         cUdVTzomxFrQ6lJCebLJv/UeeXFAd2zbW9luEIRuoDC1pwkukGjXe4N7NdtpHEmlZxhV
         L4su1Jo04CEwlTRy9LgWLbcM3rk+4wT+8NmsUmggxkMLk3APdnUF/DiGE6Q4kusJjcmC
         pK4w==
X-Gm-Message-State: AOAM531GaHZ+0CnUWyP/hruLUUTKoFKlmPifA+kA1obX6o7WK7C/o6Ln
        /NNdxbaF/7FEEPp1Y5/nCMY=
X-Google-Smtp-Source: ABdhPJyoTC1R+s+Uk9X2Y3o/JMdHuzbp3Yupv14zWiUmP6glWu19tnArW3k0hJGJHOo5vtefADSWfQ==
X-Received: by 2002:a1c:e402:: with SMTP id b2mr10841743wmh.103.1613844467306;
        Sat, 20 Feb 2021 10:07:47 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id b83sm13594918wmd.4.2021.02.20.10.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 10:07:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/4] io_uring: zero ref_node after killing it
Date:   Sat, 20 Feb 2021 18:03:47 +0000
Message-Id: <611ab369e6aab4d4008a4e41e17a53d44c5d7c04.1613844023.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613844023.git.asml.silence@gmail.com>
References: <cover.1613844023.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After a rsrc/files reference node's refs are killed, it must never be
used. And that's how it works, it either assigns a new node or kills the
whole data table.

Let's explicitly NULL it, that shouldn't be necessary, but if something
would go wrong I'd rather catch a NULL dereference to using a dangling
pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7bae301744b..50d4dba08f82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7335,6 +7335,7 @@ static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_dat
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
+	data->node = NULL;
 	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
-- 
2.24.0

