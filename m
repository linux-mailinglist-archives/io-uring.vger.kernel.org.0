Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576795167EC
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354837AbiEAVAg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354896AbiEAVAd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:33 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFA92CC9F
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i1so4998844plg.7
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7lW0UdMurNw9+Xj+o1pGkiN+Qyv4L6NeW/O6JE29O8=;
        b=CdOin7qWUBjalDu7su91IHfbxpsJmvVAIgtJjTXFr0+QN1ExLFfE3k7cIw9+oQhUOI
         5IBPgLykD100ldM/6d0JvxcklwPWVCTdwISbVOdGRRPTKPwFViAvcuHN9DHgmwtzrx6+
         c2NfsuKSkfHrUGDyli5NnABzXnoSdTNqdH+i0ELLMt1d+XjzuI7/32n3GRhRzhU+9Yyp
         ulFdUFgcQTePAVk1plWCt3sOsZaYPf/Le4WMrJQsK49ykaGp3BzVhQ7wzGztLuaRFDSy
         FbvFcl6CLSkt5vvKQsmv9nghPNAU/EhbdM1awXkIbE45bgwIhAErIbKmcy85JE1YnrcM
         IvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7lW0UdMurNw9+Xj+o1pGkiN+Qyv4L6NeW/O6JE29O8=;
        b=XKSOR+tNMjk1ywPussgUs82iSglMUZDW5D2mELQQR6j2jJZthb/VUrEABStnQn0ra6
         t6+vVMwcAoTfKdyqxT736D0Uk3NgbGeRF5X7dmO+2s9wVXW8s979B1Eg9HE0OIoob834
         TmPRP2SSpquXYs6/8urQEOqsCIp6F90QXCllfRh7wnTd+TZYoxkolEg0ycZPzZ3dgw4m
         TboPTXyFHAmFyzafel/8uehj5jQMdq4G632hu6rLX0z1vnMkgT7aPWg06UNMroycX6x8
         YhV1+9lZoCq4NOr1CaH09WZeXl6mYYQglJCGEqtN5pA/EFkoldQ/ueDEdxpxjcsEyp5X
         qGqw==
X-Gm-Message-State: AOAM530J+e+9OaZChM3UeGgQMbUKyboti/tp24PvBQyLGQ0nqhB5mcNW
        K1zncLRVX7maqGoJ5CMsTOoyd0UR7QW9mg==
X-Google-Smtp-Source: ABdhPJy6MCJlE0dQaykt5gITz0dW9+MSAtwY4Kaiq3W+a4TRgePEAtO91HBa1iMVTkhM7lHWBWyL7A==
X-Received: by 2002:a17:90b:33ca:b0:1d4:d5ab:40b0 with SMTP id lk10-20020a17090b33ca00b001d4d5ab40b0mr14833854pjb.96.1651438626567;
        Sun, 01 May 2022 13:57:06 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/16] io_uring: move provided and fixed buffers into the same io_kiocb area
Date:   Sun,  1 May 2022 14:56:47 -0600
Message-Id: <20220501205653.15775-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These are mutually exclusive - if you use provided buffers, then you
cannot use fixed buffers and vice versa. Move them into the same spot
in the io_kiocb, which is also advantageous for provided buffers as
they get near the submit side hot cacheline.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f83c366e35b..84b867cff785 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -975,8 +975,14 @@ struct io_kiocb {
 	struct task_struct		*task;
 
 	struct io_rsrc_node		*rsrc_node;
-	/* store used ubuf, so we can prevent reloading */
-	struct io_mapped_ubuf		*imu;
+
+	union {
+		/* store used ubuf, so we can prevent reloading */
+		struct io_mapped_ubuf	*imu;
+
+		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
+		struct io_buffer	*kbuf;
+	};
 
 	union {
 		/* used by request caches, completion batching and iopoll */
@@ -993,8 +999,6 @@ struct io_kiocb {
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
-	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
-	struct io_buffer		*kbuf;
 	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
-- 
2.35.1

