Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDE254B35E
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiFNOhT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFNOhS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B683BF92
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v14so11582821wra.5
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtwqEhPzT3nHMQBDGkRoV01F2A3n7O/yvr9Y5995Vdg=;
        b=iTTyD5Nmxt+1d3T4z8tihEM1OaXHSotP6JShSZd22MmXvL/p2NPhMW9OUoHbFyodAK
         xNfW2szfiZx04CMsc23KjH2NVPTJZYmul4yZKNh73uhQKu7k5e26z8iqMvmIUFnrgGxt
         HvAh1pTS16Sy7HSJxG0YuZGsjY2b99J+E55xPDLu4CGrIIqyBV2hW4FN7xsk6iO9SrtG
         EIUWn/MIRuACeoMJOjTZPGei+busDbtkCp7oTTVH605qZjP2WeFpg6JeXfY0daQcj3Dr
         pWLqqFyn7y/kZbJmLXqsSOQqRj/iZHCS+XgOu9AFEuWmN5FXWeKlie4Z8gyGW+Mkod8N
         B3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtwqEhPzT3nHMQBDGkRoV01F2A3n7O/yvr9Y5995Vdg=;
        b=468uTKV7l6hunqx0dkyDapC+vYp/imrvcnN4VE49S+W1kQCbZLyR3Y387/r7tsKsJf
         kZLD8xK/z9S+5MqCpSHKuzU4k185NS+eM+wJthBG3i1apdVsw6nHntQfOfyQ4L3uzOkg
         iD1WsipvfFUsfW3dsu5zqnypelue1rBgFX3jyhfl+CxcOAvw70GzfYm/sTrrC3cNVenP
         kcZ0TYqV11nraKlpCg8cpoZ4UeAYtNUhneh8lsqH5piiPO9ABuzVY49yXmLSqqZ1dBKd
         n8hGuQQCu7noR0wthf9/W3ZgsE4iwvvqRWp/xAKqkUz8SSrRqaIh/12Q+NinqNL0Ktyl
         Q5/w==
X-Gm-Message-State: AJIora9Js5PVFbdZfMzvfEsxIdH0izuZwu9XIGeNQNWQDyM8s8A3VCwu
        HOPuC2CO0NcdBZ4VPBPVPKbomvAF13AGkQ==
X-Google-Smtp-Source: AGRyM1sTzDvV69HNnS87EyeucAc6VdBuzTZjGVqHpYV0MdBARPkmva8IKLHMFK9xklBjA917a0ci7A==
X-Received: by 2002:a5d:6c62:0:b0:218:3e13:4b17 with SMTP id r2-20020a5d6c62000000b002183e134b17mr5129120wrz.673.1655217436120;
        Tue, 14 Jun 2022 07:37:16 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d58ee000000b0020fc6590a12sm12169254wrd.41.2022.06.14.07.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] io_uring: update headers with IORING_SETUP_SINGLE_ISSUER
Date:   Tue, 14 Jun 2022 15:36:31 +0100
Message-Id: <b5e78497efd3a50bcc75f5d9aab1992375952c93.1655213733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213733.git.asml.silence@gmail.com>
References: <cover.1655213733.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 15d9fbd..ee6ccc9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -137,9 +137,12 @@ enum {
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
 
 enum io_uring_op {
 	IORING_OP_NOP,
-- 
2.36.1

