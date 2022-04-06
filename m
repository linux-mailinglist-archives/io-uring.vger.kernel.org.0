Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2463B4F62A4
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 17:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiDFPDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 11:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbiDFPCA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 11:02:00 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ECDBF334
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 04:46:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id k2so2256003edj.9
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 04:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J+/2Fjg9v+C27nvWBCqhNWd2OflMkdZna9b2IQzXbik=;
        b=kg+Xf3pok9FW9yq63N2Subcjytrz88TicML7GUoToBHg2e1Dl4dmsMXh+pkr4trt/0
         ASJK7buPmfzC7wXd2eVtvJqEGzY1GR1m/PBixXUwg53BZ6cJ9LMWxA8A60yj677WWUEt
         vxrbuvkVGiw285LReA2cqUyFrUznpZi4n1UJQXiW7OAajOA4fBv9pXfNY/jF9UJauyhT
         gN6sckUAfNV1AFfpOFA4v/cwGMjnQIcDxtQ+5HF+OMFDuX+1Xe0RUzKwfxz1IwlvnQXn
         Ul1GueKTwuE/cXJ+OPwuy5UmToiGhHVpw8rrJua+2VH5uz8wLkc5UkjuXo648mlu/2+H
         Yx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+/2Fjg9v+C27nvWBCqhNWd2OflMkdZna9b2IQzXbik=;
        b=G9ItwyE1ifxhExW3g05jAM4geL9GIpLme2RIEA/kiNtbvnKEr2CpUqJrLDW61YRCUp
         ZOvYn+rZDjLz+Dwo3Hv8WFapq0f0UDbl+NtPoQ6jK5//dL4NpOJfyI68E1be3lTwVT96
         DAl8E6id6VW2+QtTMFbgYr3tc/KvJo+b3qIw6Em7TmUiqbbJL52EH8M2ctFpLSTDULA8
         R1A/fZFKrCAm6CUI1y79Vm7BeSmw6dRoaRR8dEkndbAHUzPVd/QWUUrFOBZ2HIzxOyeT
         y7Ypik1YA9r4/MWHjMgmLFftN8MT5vhl8ZrV2LQLQV1I1ULZAMxBoqa9Ompj9Uvkhlfx
         jdhA==
X-Gm-Message-State: AOAM532GKDCM75wbji3d3ivaaoJtr3MQ13KfGvqJpGvsdUCpMApyZH7X
        ghV7IG5eaZ9vCa2nxauniHSrtYj9fsM=
X-Google-Smtp-Source: ABdhPJx7xFZQPLYYsp+LxsnuvovsVnA0IqbVC/Qw1Csg2v4SU+iJP+e/ZlT1aGupurRRf3IXky8LDQ==
X-Received: by 2002:aa7:d0cc:0:b0:41c:b59c:c461 with SMTP id u12-20020aa7d0cc000000b0041cb59cc461mr8307255edo.285.1649245532139;
        Wed, 06 Apr 2022 04:45:32 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.65])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906521000b006d58773e992sm6506022ejm.188.2022.04.06.04.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 04:45:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: don't touch scm_fp_list after queueing skb
Date:   Wed,  6 Apr 2022 12:43:58 +0100
Message-Id: <28279689e4f94cf513d416287ee0b2faec5493b8.1649245017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649245017.git.asml.silence@gmail.com>
References: <cover.1649245017.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's safer to not touch scm_fp_list after we queued an skb to which it
was assigned, there might be races lurking if we screw subtle sync
guarantees on the io_uring side.

Fixes: 6b06314c47e14 ("io_uring: add file set registration")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 449d4ea419cb..481e12115dbb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8831,8 +8831,12 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 		skb_queue_head(&sk->sk_receive_queue, skb);
 
-		for (i = 0; i < nr_files; i++)
-			fput(fpl->fp[i]);
+		for (i = 0; i < nr; i++) {
+			struct file *file = io_file_from_index(ctx, i + offset);
+
+			if (file)
+				fput(file);
+		}
 	} else {
 		kfree_skb(skb);
 		free_uid(fpl->user);
-- 
2.35.1

