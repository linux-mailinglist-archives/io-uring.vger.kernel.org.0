Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095874240D4
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhJFPJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbhJFPJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:09:31 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9221CC061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:07:39 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j8so9800626wro.7
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q8lUP6gdoMT3AciTL0Tva4Abh97dSm6IVi65ZJp4+0U=;
        b=D8GvHRVfvvGtmIkahIsD4RxdnpwXNfXH2rSLDEg3u6hi8mZGqIL3LhWuHPOjN6l4aI
         /acCQBG4fXrTwqJ6kkVI/9iRs71fGn6dHoxRSO6rvMJDUBxLp07itIOZr0+IEco3He0a
         nVRc6HTEtw/0Cr0sT57YNK5EXlFF7jSZ8tiL2qegDduMcMsEBoHLlBDU5SgAqrSRsR8S
         WENyXk5F4cNqNBTp2L1mjhgo1pvaP0tCckgYSwMf+uppsdzGZwnyfqsAwou10sd/bb7A
         3ExAjVqO1MVw9fiafv4PMVoyTgYw+C53zMOXiL5gb4JRxaU8BW+wG8dnnqZDrzbWGR1Q
         X6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q8lUP6gdoMT3AciTL0Tva4Abh97dSm6IVi65ZJp4+0U=;
        b=iZaDfQBpvm8bd3AXVjHZuwvhOKmt/CrZ3yizn7cRt4ZKssXyapp4az59D92aKoBJp2
         QmNGaC3zdY64BF4+JVEGqHuJ1ikPEhfEZ9PVuWZwBb3uw/tnAthQmkEaCUM7bgXPrB+K
         BrNY+blVsnFHXHAXp4rjHep6cx8wEUU+Bqi55lmBqWgTb3UjfOGmIe+LTG5oiJp+c/Au
         koC3NnIktEBL412qHIlVR6Xen1W73we2sl1qXEgQfiVzjFMm1BIy3HjhE8a5TglN8d2B
         L/hn7PbH5oXvVwA2etqYs2DaG2SHhW8Y1b+U2ESxHYQr81d5pIhuxzU2owX/ENQYtH7+
         AfBg==
X-Gm-Message-State: AOAM532Frx1HuXIkoC5kyfe1WU87WPI4J8pceB4cZ3AmneR69ve91VVX
        wyK+NKm0PIHzYLptPiVzGIUlSQE+Ee4=
X-Google-Smtp-Source: ABdhPJxqxD2x+/Vi60E+esAnUBoG0dCLU4j+ehWRq0NiLczW0NM8GaNTPGezUvGQRhw3aFrnparQLg==
X-Received: by 2002:a1c:a783:: with SMTP id q125mr10653247wme.108.1633532858035;
        Wed, 06 Oct 2021 08:07:38 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id o7sm24678368wro.45.2021.10.06.08.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:07:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/5] io_uring: safer fallback_work free
Date:   Wed,  6 Oct 2021 16:06:47 +0100
Message-Id: <24179419d6748516299600bc914f50b9e0b02275.1633532552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633532552.git.asml.silence@gmail.com>
References: <cover.1633532552.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add extra wq flushing for fallback_work, that's not necessary but safer
if invariants of io_fallback_req_func() change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fabb3580e27c..b61ffb1e7990 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1262,7 +1262,6 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 		mutex_unlock(&ctx->uring_lock);
 	}
 	percpu_ref_put(&ctx->refs);
-
 }
 
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
@@ -9215,6 +9214,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->rsrc_backup_node)
 		io_rsrc_node_destroy(ctx->rsrc_backup_node);
 	flush_delayed_work(&ctx->rsrc_put_work);
+	flush_delayed_work(&ctx->fallback_work);
 
 	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
 	WARN_ON_ONCE(!llist_empty(&ctx->rsrc_put_llist));
-- 
2.33.0

