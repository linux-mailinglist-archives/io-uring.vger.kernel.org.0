Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D01C4E63B5
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 13:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350295AbiCXM5e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350323AbiCXM5d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 08:57:33 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7B6694AF
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 05:56:00 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q19so3763591pgm.6
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 05:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=KTtcrac2ZaU4CN1X1YOLw1wfnq1M6J1rWHvMEJ1CrLQ=;
        b=kE++lndd1nhj3QT/3r+l90qvHAy72BK0Xwej6ZnTNPnEOJS7g2RP6bC0ZDiTTuyuV5
         zgCvBEhu8ufV1cQ2G0iqDVcFVnZ+mrQOK2zPC7ISZREVgSTiYF8oYwN+RQiW0cc1Fyxu
         V/z4J9wvhdzAtNsdWiQEfPTBXxtL0Jztotow8Pp++xuojOUHeKk5xxl9ESGdbcAYQxGl
         I0C9n52qnkIdg3EvkqMtq2Q3ioJkuSbHkaQFMwF2ICKs85H9W7Zwa7edvS7LcxbirIb7
         dIZfJbx+HfOtNzPGau23Gv0BYqezm0t/LYSqm7k9FsJDjDJOTGoB90KmtI8Tg9AJ2Pse
         UHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=KTtcrac2ZaU4CN1X1YOLw1wfnq1M6J1rWHvMEJ1CrLQ=;
        b=z8uswBWam2yGWmfA5DKvVfnY+XRR02Jx8JEFrt86gh1F0VvWbkIYO1vGyyPO9ynQmF
         aB/4rVYEgSLyjRKDlcWLNnsCyvz5cspopsRwsVLbuLREXbfGh/TBH5QsmntLK1kQMXh3
         uKkp/Qyi08vK18QVkB1RURTH2JbneuqClfX2ZrySkhxUE1JC66Ygy2TRqXZVAGLRpOWz
         xL28eWbJEEStF+xiFZzubEL+LSXy5piVfNeZYvdx+/XEYNnLrEP39MHfkRSdn/O9ORqD
         NreqiNvsy3jR+AZPjEe/M0jwzOvuL8VNcELUrygkMhpJ+eKBiS/X9UsIq05Fp7xmqibJ
         vvmQ==
X-Gm-Message-State: AOAM532tvFbMcB55GJFU5XGQZHbNCWuV3GvQ4enEaPdPdK+Z9KummW9F
        A/dTHNwXYsZOnzjAocunDO+dmmhLEODeurnP
X-Google-Smtp-Source: ABdhPJxwA9wCLfCNV8Aw3SQv7x8SN1FRW9gM1lj/1kuXs4ThSktVIhj1OkyJ7osCOXLSqdhyVIaZjw==
X-Received: by 2002:a63:9345:0:b0:386:4fd7:1388 with SMTP id w5-20020a639345000000b003864fd71388mr1302512pgm.573.1648126559491;
        Thu, 24 Mar 2022 05:55:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm4003092pfl.141.2022.03.24.05.55.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 05:55:58 -0700 (PDT)
Message-ID: <c7b3291d-aafc-d4e1-f052-432dd7fb08a8@kernel.dk>
Date:   Thu, 24 Mar 2022 06:55:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove IORING_CQE_F_MSG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This was introduced with the message ring opcode, but isn't strictly
required for the request itself. The sender can encode what is needed
in user_data, which is passed to the receiver. It's unclear if having
a separate flag that essentially says "This CQE did not originate from
an SQE on this ring" provides any real utility to applications. While
we can always re-introduce a flag to provide this information, we cannot
take it away at a later point in time.

Remove the flag while we still can, before it's in a released kernel.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 88556e654c5a..28b7a1b8abb6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4474,8 +4474,7 @@ static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	target_ctx = req->file->private_data;
 
 	spin_lock(&target_ctx->completion_lock);
-	filled = io_fill_cqe_aux(target_ctx, msg->user_data, msg->len,
-					IORING_CQE_F_MSG);
+	filled = io_fill_cqe_aux(target_ctx, msg->user_data, msg->len, 0);
 	io_commit_cqring(target_ctx);
 	spin_unlock(&target_ctx->completion_lock);
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d2be4eb22008..784adc6f6ed2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -201,11 +201,9 @@ struct io_uring_cqe {
  *
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
- * IORING_CQE_F_MSG	If set, CQE was generated with IORING_OP_MSG_RING
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
-#define IORING_CQE_F_MSG		(1U << 2)
 
 enum {
 	IORING_CQE_BUFFER_SHIFT		= 16,

-- 
Jens Axboe

