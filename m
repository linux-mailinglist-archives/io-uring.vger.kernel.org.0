Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF84D5615FC
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbiF3JRU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiF3JQy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:16:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8084242A34
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id h23so37664081ejj.12
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XxjPxsaxC4InhhQuR77UkgiYJHDnnofimUEVznPbP7s=;
        b=cE0U6q+DLO34bJNmaAKT/CGxJk89gONR7vHiSaS17D1nPmPgqbn5JxwjZ1LbBaNfpA
         OE85W5XI/0wfS9ETXKxpcU64reLBlKVGXQBEUkSDKIAsKrnLZybwr+NkV03EOM7VdrjE
         n5d69GitDamCqGLHn4EEIaWXl613jkOQz03QpOLzgZm8ND/Cqi3nm/rgIeERGHvkkevc
         dZTc83ntwq5Kk0F/qt7t/vjBvrCo08OTHPGN/pA2Q9JDiJnX7qk97MjRG1sXpqR9xcdn
         xAqBYj6yenr2FdF9ZBi/d3wgzNE6zOcSVmbNSKfS0exESDftmwpdEviy7N4VmAioexDk
         czwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XxjPxsaxC4InhhQuR77UkgiYJHDnnofimUEVznPbP7s=;
        b=yJS+mxoDo2vwCjwxdLH11sdJoLxfDX83RVB131ktw8ZonjTUidt6y0Yl9f4FgQG60I
         7VuDLIlb8Jmiluwc/Udb1k6I/pU7bnCmEb8pmGdxTjjpoqBPADcXiyaxSfeQTrxeutYq
         vS4cP74gB7Q0eZYHmXlPB+zQc/JwuSZYlzBZu+PMMV8TbwQfb5d8Y8qrTi9JJgUaNOTY
         zlo+gnj8ObA37NIBWCj9UFss49C3ywXTX16pJf7UKEnQENtPubQ5/liAfHJJARMvOc5h
         oyhT6KL+3xyQqWS0c+3dyhNrE2t1nWKt2rYLl0LTC1R1RAr/lGKBNimcJr09UKG1NKDG
         xVTw==
X-Gm-Message-State: AJIora/yuhXKko4nfpW03ScFh1qqDbeWXtkBCNbLqwRvexnXT+hWTfE9
        CwKDcsArxjMAhj3nbYTKLYbPHy/SBt7ymg==
X-Google-Smtp-Source: AGRyM1srdEEjoSm9BDQ/eR4Vr2DlDTACcDyiQSaZOOUZhzNPkTEXBPhnJDwL+88yNhNnvhawFSS8tg==
X-Received: by 2002:a17:906:9754:b0:722:e5e6:1675 with SMTP id o20-20020a170906975400b00722e5e61675mr7715419ejy.102.1656580543647;
        Thu, 30 Jun 2022 02:15:43 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3ae])
        by smtp.gmail.com with ESMTPSA id s10-20020a1709060c0a00b0070beb9401d9sm8884925ejf.171.2022.06.30.02.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:15:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/3] update io_uring.h with file slot alloc ranges
Date:   Thu, 30 Jun 2022 10:13:37 +0100
Message-Id: <8f98bd6d014b9e8b1d86d04aa165b6d36cfb0ed5.1656580293.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656580293.git.asml.silence@gmail.com>
References: <cover.1656580293.git.asml.silence@gmail.com>
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
 src/include/liburing/io_uring.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 0fd1f98..c01c5a3 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -414,6 +414,9 @@ enum {
 	/* sync cancelation API */
 	IORING_REGISTER_SYNC_CANCEL		= 24,
 
+	/* register a range of fixed file slots for automatic slot allocation */
+	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -558,6 +561,13 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_uring_file_index_range {
+	/* [off, off + len) */
+	__u32	off;
+	__u32	len;
+	__u64	resv;
+};
+
 /*
  * accept flags stored in sqe->ioprio
  */
-- 
2.36.1

