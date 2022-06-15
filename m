Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F85854CEC5
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356579AbiFOQej (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356594AbiFOQed (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:33 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D771E2AE20
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:32 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o8so16133081wro.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pRvBVOE/hkiozWmaa4rfYGZwNs1AXWCtzZOpvsa5jls=;
        b=mkDEbLx048bx1/e07voGxuV2tza+hsmZn3tB/pZ7yUvMmJ5JTjM5AZUnqcZAV62b8E
         SjXarMmiZvZusXC/1TqdCYOm6hPhoJy2aIsVwycCog0OabeOSmovt+YD6M/sV1Yt3ZTZ
         XhHoqrqLqRu/MNAHCKFAshbSTNIXS1zqb3YT4entdC96rY8t2VDsCNuHF5DntbErwryW
         yUwdvG0Pnpe+m2fm96oQzTajGUkoSP8n0fae4+4saLd3rihEuHLghqgq5fHpr5PsdTbz
         Z4BqwPcaZBS0fne6aRMJ8J9kY4z5BTN9+7cAuG9S4qcSRmOZJh5uJq09JKHF4s3lpERI
         kXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pRvBVOE/hkiozWmaa4rfYGZwNs1AXWCtzZOpvsa5jls=;
        b=2Pk9aVeGwHtYqM4PTrIVV7dPUnonh+GJRdOyDdpK8OiWiLhydQ1fzGzl2HX78kse9N
         629OLV9yQxuFJrCI2f8U79f7XJy5fO8dIJb5SxxhY2m4R3f+3PoJirJNmV7d5hpOP/9+
         lFS2YqEhQgB9K10/ojrevZJIdNpw8TbRwOMhQJ3MJI7Gjuwtz7EMIPeOSV63kcW/sApI
         9TE4K10MxoiruQU9Y9MyLJb7QpMzGComFEjYiz7jKVOyXXb/R0AohR/YMTAaM73XR9r0
         P+WZY6xNiGW/tHaJ53tnVplQYMmyC6LqKKP3LxSIYEbtSzfRgmcsqvB9xUSvSFnfyIMV
         q3cA==
X-Gm-Message-State: AJIora9bRYchEkEhA30SFPSpatomEltvXITd3Tyshg1YIoD/sZHwV1eP
        YLTH5ApLCmmeeLaqjRB09C7AFFeqNPqaSw==
X-Google-Smtp-Source: AGRyM1vCbCshGB2T1No40yygfprda9pdTH4mYbYGjAZKAO5r34dfkNhbNT1IkhzaYIfGzSbTohUNcw==
X-Received: by 2002:a05:6000:168c:b0:218:4523:c975 with SMTP id y12-20020a056000168c00b002184523c975mr625119wrd.23.1655310871203;
        Wed, 15 Jun 2022 09:34:31 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 06/10] io_uring: explain io_wq_work::cancel_seq placement
Date:   Wed, 15 Jun 2022 17:33:52 +0100
Message-Id: <988e87eec9dc700b5dae933df3aefef303502f6c.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655310733.git.asml.silence@gmail.com>
References: <cover.1655310733.git.asml.silence@gmail.com>
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

Add a comment on why we keep ->cancel_seq in struct io_wq_work instead
of struct io_kiocb despite it needed only by io_uring but not io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io-wq.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index ba6eee76d028..3f54ee2a8eeb 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -155,6 +155,7 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
+	/* place it here instead of io_kiocb as it fills padding and saves 4B */
 	int cancel_seq;
 };
 
-- 
2.36.1

