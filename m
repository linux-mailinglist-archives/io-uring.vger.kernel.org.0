Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F214E57E0FF
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 13:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbiGVLu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 07:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGVLu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 07:50:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AD53343D
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 04:50:25 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so5046835wme.0
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 04:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HT6qpwF9Y4ADTJ8y2fUqQ9kABRQnIh/m7aED+Ze69tA=;
        b=TVD0akM9PBYGGPrDIWLRo9vVjfuNK1RKPiH0vrG8Ft9SjpIsbZiPOeYtcyWi7tQHmP
         FMdwRrqyj5FUkn1gZaxOzeu63oVfpJ0BLjjX7OKQMVqZq5FAaaDBx3hU6CURP+9R0xxI
         mWLEhg6cI5NLW9C7G64N5hJpFXKTOgNfRiwsafIEprJSdtttssgXV/5drMyCSehhTlm2
         ywhkCnkR4f3Q8quOKUxUPZ3iqa13bzt+D5fjwfzni+sq14tIcO9OkQ58DmesPWVeLEsm
         Bd27wq6s7sd3DVYxF9x+Ml9+MPC9S4ifyfSsetEtE4OqPvGrjN71mCnQUp66QkBByz0/
         Wcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HT6qpwF9Y4ADTJ8y2fUqQ9kABRQnIh/m7aED+Ze69tA=;
        b=ijxIB4/xxGCgQXD+yF5zDf2cTCCj/EnQZbeyv0HTr3RNt6rJY8iPLViacdzOsQ+VqJ
         BAMiln37ZZjpuWCziBwmAjCspA80vP31UM/k7mMzIdcVi6fvv60ZjLwJK3/qRG35zl4V
         iCPqvBpsnQMvaobBFSQN7OI3cFU6Z/BPQHa7Gphl/L8FGVqQCnIwieLSgS89Cytkhgvb
         VMc5Fy4XUcPZVsHEeOqtVyqumWeMNOjIYm1TExdhbLlYX5wYIZFKPUZKRgyrcJItnVTs
         TqPImYjWLloUqn/ouWka8cjxSDTZv/SY7PJEQZKSOzeWpZr6efb0qTz/3pc0WqEIiuqW
         dhGg==
X-Gm-Message-State: AJIora9luE7Rb+uiE4Zi4RSEWRMDobDS7esqTdrkpf4qlFTaAIsaFzc7
        zTkzpDar8TFwsJ5IJKEYubaNtQJPBde00w==
X-Google-Smtp-Source: AGRyM1vUoUty1bMMYft2ZPL/lDkwsRASHeKj7Tr/ASNM+l+ywwfuoUTc3I66PdovT8ebrzORgCyGPA==
X-Received: by 2002:a05:600c:4e12:b0:3a3:2fe2:7d0e with SMTP id b18-20020a05600c4e1200b003a32fe27d0emr7026733wmq.151.1658490623116;
        Fri, 22 Jul 2022 04:50:23 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3d])
        by smtp.gmail.com with ESMTPSA id k20-20020a05600c1c9400b003a31fd05e0fsm18257853wms.2.2022.07.22.04.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:50:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] man/io_uring_setup.2: document IORING_SETUP_SINGLE_ISSUER
Date:   Fri, 22 Jul 2022 12:49:02 +0100
Message-Id: <9e282a50456df4451e28189bd3ac6e54d598ecc3.1658490521.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_setup.2 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 75c69ff..0f57d8f 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -239,6 +239,24 @@ variant. This is a requirement for using certain request types, as of 5.19
 only the
 .B IORING_OP_URING_CMD
 passthrough command for NVMe passthrough needs this. Available since 5.19.
+.TP
+.B IORING_SETUP_SINGLE_ISSUER
+A hint to the kernel that only a single task can submit requests, which is used
+for internal optimisations. The kernel enforces the rule, which only affects
+.I
+io_uring_enter(2)
+calls submitting requests and will fail them with
+.B -EEXIST
+if the restriction is violated.
+The submitter task may differ from the task that created the ring.
+Note that when
+.B IORING_SETUP_SQPOLL
+is set it is considered that the polling task is doing all submissions
+on behalf of the userspace and so it always complies with the rule disregarding
+how many userspace tasks do
+.I
+io_uring_enter(2).
+Available since 5.20.
 .PP
 If no flags are specified, the io_uring instance is setup for
 interrupt driven I/O.  I/O may be submitted using
-- 
2.37.0

