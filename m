Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6D6516071
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244583AbiD3UyM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245206AbiD3UyB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:54:01 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141503983F
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:39 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id bg9so8991007pgb.9
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oEUkYenP2vfmVZVZ5g8EKjw+k8QAq+ZP+tUsa3WmQzY=;
        b=EmBaiIeBodkjP+MROAcMrIqTTv6PWpLjfiobEYVl7NQ5hr8j8HlLTvLAbwwqXoKD2g
         B11kRggszUPn+XmqVBj9cOvPTjhfgKNSIXCefCWUaS9IK8N6DWxSYVubqu0iR9DnwXy+
         F3iLnXiBNBM1ssY0yuZ3prwW0AYtgrcIzur66h5AB687+Fim0HsQfK25dZwWlt0jkAXi
         NB1/RaSiQyiLIS8R2WKjQYfczuE0omtxP/mAtmj6Qn7dbPPSvrw/A7kM+8R7jbCiJISI
         PStTbsp86euBuTCPs1V2TKHVogwL7WEjcLVJaB58TfEbEpQ4bf4vtycf5uJ8O2AeTj8o
         0R2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oEUkYenP2vfmVZVZ5g8EKjw+k8QAq+ZP+tUsa3WmQzY=;
        b=RuKmKidfwPdaFWyfzygVOvKeUmHm6UkKllvRcnYX11ThT+HhI5Rvc0x80wal2GybBF
         v3PtvPitJukNSyIit1cxkLA6M6jnnUVDvqzUmzV3sjop3xDGXsxNW6g2QNt7PN7MnLMC
         UDFAhq3wlijgJZyxZbZ7Ypw4twyRubxxy7PzrTPbQrmnjJFWKhlzyq0m9vs3ClCXoJrM
         tKE6bIlFbT5i+h0Cj2Z+cnCqTpWZ2BrcN0inmgh0jPDdclajiRC5UQAtgMOjlWK+Scus
         MVyR3mSqCMhzhb54nYJAtFTxXpQxMw5evrm8mv4k9pMFyz9irPI+1KMf2oN/FItQL9NI
         i51Q==
X-Gm-Message-State: AOAM531ymFZ9R/7lH12bun+XphghJSdhuSeHR+oVV21Fc8D9wHudHLSx
        yK61VDae73AO8/QFfURDjmPCWrql2RCuBSTV
X-Google-Smtp-Source: ABdhPJykam31tXBO0tobGwn6AVZF1DQ14VYvaQeH0EAgfUe7610Jz43VYK0+H6mpec+1p4I5NnWFMg==
X-Received: by 2002:a63:8641:0:b0:3ab:494d:111e with SMTP id x62-20020a638641000000b003ab494d111emr4094631pgd.618.1651351838282;
        Sat, 30 Apr 2022 13:50:38 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/12] io_uring: move provided and fixed buffers into the same io_kiocb area
Date:   Sat, 30 Apr 2022 14:50:21 -0600
Message-Id: <20220430205022.324902-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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

These are mutually exclusive - if you use provided buffers, then you
cannot use fixed buffers and vice versa. Move them into the same spot
in the io_kiocb, which is also advantageous for provided buffers as
they get near the submit side hot cacheline.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 616a1c07c369..3d5d02b40347 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -977,8 +977,14 @@ struct io_kiocb {
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
@@ -995,8 +1001,6 @@ struct io_kiocb {
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

