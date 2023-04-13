Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31FE6E1005
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjDMO3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjDMO3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B27AD0D
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v27so5165171wra.13
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396141; x=1683988141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cO/jYwlVM1vE8zfdvxGQpMVWtu2D+phnbnHn/ydmrWg=;
        b=c64n4E4fAWwI4LZq/DJDEoIr8CDR7nbf1kTAhRssaFyWqwBp/0hB0NhKcXaUqM7y5M
         5MIC4dR/1XgTaduU1bJtxb59mNNQ0cXh/uOiyXa6+pPtzJOnpkseCS2pCiiGKMlWugOj
         dAr/pOxs/8R6m/rvtwf4cTnIB33kVN39wEkd1i9Iq9NaHAvbZD/T/ONuRpSDmnwcYlqh
         MNWRv/Gn6oEkmD7L5BvNF0TGf57H2ckwGPaRcbR/WLd3pH8QPxN/OETkqsGKl4+rQPOc
         9WJGEfV3P+11khY8Uxn0NkQu1Ga4y++8NKnATRA5/6vsNJY1QJItqEvt97e3Rm99j4A1
         2GuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396141; x=1683988141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cO/jYwlVM1vE8zfdvxGQpMVWtu2D+phnbnHn/ydmrWg=;
        b=W6Tt29xSMkGbhKDrNlfrGJOXbqj6Q70YvoJRD+0WRfwmj7KzA8euTkLLDv3crvhGoM
         3YPuxSNqJbZiKr3ULkFbW270fZj2/ArVQgKflD4jSeO6h66SQAk3l+F1mANx5KSjDINA
         0isK8bfR+gYfIcZO+ym/FiBbyv8VkqSaqQfU3fTm0fsWve7d9DVIOORkNIVxOxtkbGeK
         PFUoLxU6IOYkZ+uynipxyH+/O/BAs0xHOpeKdSiNbQPozw6nyOq8k56Szb285FaJ4Puf
         H41MuxokyMjvPpQmGtGSSjiiC09rQfG42VOOXc2ENgkHS2tMEs0eU/84hWBQfc+x8D1S
         Qoeg==
X-Gm-Message-State: AAQBX9ewv8bAo786xgLVyroKgHsgi8eMPi/7LCoHWNhTIomBuk20Bs51
        urYHg1+Ct67C5gqPPTUb0/+8+U5VOp0=
X-Google-Smtp-Source: AKy350ZhuYJv2SRXihnttjllD0R4oXl7xlfIS6vzIA4DfYx8byzclqgOx81QsSdMWzMzqAhouSgoag==
X-Received: by 2002:adf:f04d:0:b0:2f0:2dca:f914 with SMTP id t13-20020adff04d000000b002f02dcaf914mr1868737wro.52.1681396141393;
        Thu, 13 Apr 2023 07:29:01 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:29:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 10/10] io_uring/rsrc: refactor io_queue_rsrc_removal
Date:   Thu, 13 Apr 2023 15:28:14 +0100
Message-Id: <36bd708ee25c0e2e7992dc19b17db166eea9ac40.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can queue up a rsrc into a list in io_queue_rsrc_removal()
while allocating io_rsrc_put and so simplify the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 38f0c9ce67a7..db58a51d19da 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -685,7 +685,6 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 {
 	u64 *tag_slot = io_get_tag_slot(data, idx);
 	struct io_rsrc_put *prsrc;
-	bool inline_item = true;
 
 	if (!node->inline_items) {
 		prsrc = &node->item;
@@ -694,14 +693,12 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 		prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 		if (!prsrc)
 			return -ENOMEM;
-		inline_item = false;
+		list_add(&prsrc->list, &node->item_list);
 	}
 
 	prsrc->tag = *tag_slot;
 	*tag_slot = 0;
 	prsrc->rsrc = rsrc;
-	if (!inline_item)
-		list_add(&prsrc->list, &node->item_list);
 	return 0;
 }
 
-- 
2.40.0

