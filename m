Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4926B9CD7
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCNRRc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjCNRRa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:17:30 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A61FABAFF
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:09 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id bp11so3589732ilb.3
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678814228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9y1AOW+wzzyKm4hOaf7aPymFqkoUpTPYFIIeeYcziY=;
        b=RVpN5cpEH+PxOjzyqQ8D13Ph+D6dTyOaVQFleYFPnYaRK2Myh8WdajoUIRqoiYj/eF
         7E1DZA1AL0zoecxp0W1qczlgwC27U3vuCOp8GWHCFNa8PFbURM49mYTq3k+XYHMaRBxV
         rRVSV/7p+iWBi+0WXGE3PBjF/akHGmdFUU0/1OmrgpBUQjmA5LPk/g0JsWN2rCL7eI1f
         83ou7vNtZf30mn3Gn4MbVdv4MnheFsnGjqsZZiztQuAJO4JwknRYPo+JJPoRW2SIUHkK
         xJ6I4rJcyRoNp1u7dVN43hTAxhSwR1okZchBC6OPIHVuNSBPBlg4QlcdnMMRvCm07VEs
         bM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9y1AOW+wzzyKm4hOaf7aPymFqkoUpTPYFIIeeYcziY=;
        b=HgPZjAk2ju6xyhkKqqbeMKyLQ6SG1hOp2HGLB7hkvOB2F2+C2BzRSXyPE+6Z6/d9BN
         TFIHmxpiHSYdhT+X6fR3gWrMMqFwqYzAxbCafUGAK8JbseCSN5GLNiujAfmGxvTxDMks
         JoIxzNBWJaZTW66iryK1OIO6ccrWiy5KBjLc3X6pUasDoaZ3JnWrbUC1YqnwE9JZsCxu
         1YlOHsdqK4GCxOHneSIZdHXfTWxXnfF0xZF+ddhtoxwn9SFN1EODipZxe7/Drqw4ruK7
         VYk2Iz/7X58VfRpkqQJJ/eppmJxAJD78gCb9Rq2lQin14SpQzF7bthzAJPC86l21fVXf
         gIPg==
X-Gm-Message-State: AO0yUKVnGXUM9ZwQSHRNCKV/ZwgET99894Q6pmzWa/1dpt3n3WyGA+oG
        3Cf+fXx07suw4vKoCLAAaQ1zUxufK/vtPBwEyvny1Q==
X-Google-Smtp-Source: AK7set9am81GP+KSG0DF/oeQiPpNldOJdrN+vxl+I1TatGokDo6V0TjE6G8N/SlKOLhSaB7FR1+VvA==
X-Received: by 2002:a05:6e02:5cb:b0:31f:9b6e:2f52 with SMTP id l11-20020a056e0205cb00b0031f9b6e2f52mr8376653ils.0.1678814228049;
        Tue, 14 Mar 2023 10:17:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a056e02068c00b003179b81610csm948950ils.17.2023.03.14.10.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:17:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     deller@gmx.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/kbuf: rename struct io_uring_buf_reg 'pad' to'flags'
Date:   Tue, 14 Mar 2023 11:16:41 -0600
Message-Id: <20230314171641.10542-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314171641.10542-1-axboe@kernel.dk>
References: <20230314171641.10542-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for allowing flags to be set for registration, rename
the padding and use it for that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 2 +-
 io_uring/kbuf.c               | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 709de6d4feb2..c3f3ea997f3a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -640,7 +640,7 @@ struct io_uring_buf_reg {
 	__u64	ring_addr;
 	__u32	ring_entries;
 	__u16	bgid;
-	__u16	pad;
+	__u16	flags;
 	__u64	resv[3];
 };
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index db5f189267b7..4b2f4a0ee962 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -494,7 +494,9 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 
-	if (reg.pad || reg.resv[0] || reg.resv[1] || reg.resv[2])
+	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
+		return -EINVAL;
+	if (reg.flags)
 		return -EINVAL;
 	if (!reg.ring_addr)
 		return -EFAULT;
@@ -544,7 +546,9 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (reg.pad || reg.resv[0] || reg.resv[1] || reg.resv[2])
+	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
+		return -EINVAL;
+	if (reg.flags)
 		return -EINVAL;
 
 	bl = io_buffer_get_list(ctx, reg.bgid);
-- 
2.39.2

