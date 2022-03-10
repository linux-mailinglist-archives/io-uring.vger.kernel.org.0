Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFD54D4FD4
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 17:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiCJRAP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 12:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiCJRAO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 12:00:14 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A9FB5623
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:13 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id 195so7254711iou.0
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 08:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ce2NJE8CV43wwi1UW3RACayj+hvb07XQ1UKU+KD3Sug=;
        b=fE8JGlwCV4sNV6oogV1qw6dPytfgvwbaFXREZVUwjmpNF2VFa+ugzdd7qPKRWK0dX0
         cZZ1+yn0KqRS968NCsF4IOUdd3sSsqTZul/cRHiU9ykXGBNeTAKPY/WJ8+Ax9trc9Ky7
         jJrzFNmavTluWRZf8cVIrpbcDqHxsXgXp6EujmZFBVdLsMYhaU5LDQvXfwU+qR8LEsTq
         s8+YnnlV0woZPALyAQcSFm68BV9IDa/CflYfTauxWTHOmeJp1uH2KH8Pr7O2UbMZN1OC
         EudWCaTi1oNE2VgtZP0aaEAzS87IYIjEABS8k2XOY3qOOHoRljYJHOdWYaCLVuahLtor
         +XbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ce2NJE8CV43wwi1UW3RACayj+hvb07XQ1UKU+KD3Sug=;
        b=lPSlST23YQAHzJ44FMgg0pF+c49cFpnRNJkuGXeoFVot5uIDL5et25d8EU1/82kF1w
         8nFrc0pWbsc+oFLypdXcteGowbbbwe8PQNieSq/w2RLbIuSAcyqs8rkZD4cvdhO4xYDF
         QjCbxdj6glBXV0YLBIDvr3MmWYPoC07f58vQpRW9VLE5AomBMFlgmUc4SE5FGDiNLh/A
         Dou+/lVJTKY7TFlcya0fZGabV4cmXRrTvH851GmQVg8A2AxSZ0jv2WE0hgeuTiSk8iXU
         fCm4NGHY1My1IUH+ckJmGalWZSPUADFhYEIeLX/lxYpM9rQdFqqXo1hG5J4EoNWzgYLT
         l1fQ==
X-Gm-Message-State: AOAM533XuJUTeRr2KOaOxFa5ZOp+5hkitKu+kyBr4GHKDuv2U4FvTVQR
        fQhsKycP/UW7/IqgRcWAQLT2jjPwiOZ4YO4p
X-Google-Smtp-Source: ABdhPJyy8CQDQCT/JFC0bfsFmcQh/oUohBC9NAFr+CI1z6DFUv7EI97Wu8GfJL4+yIxfGBivBr3CUg==
X-Received: by 2002:a05:6638:31d:b0:319:af5b:7b0d with SMTP id w29-20020a056638031d00b00319af5b7b0dmr4032669jap.176.1646931552842;
        Thu, 10 Mar 2022 08:59:12 -0800 (PST)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i8-20020a056e020ec800b002c7724b83cbsm86865ilk.55.2022.03.10.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:59:12 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: ensure reads re-import for selected buffers
Date:   Thu, 10 Mar 2022 09:59:06 -0700
Message-Id: <20220310165907.180671-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310165907.180671-1-axboe@kernel.dk>
References: <20220310165907.180671-1-axboe@kernel.dk>
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

If we drop buffers between scheduling a retry, then we need to re-import
when we start the request again.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4d8366bc226f..584b36dcd0aa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3737,6 +3737,16 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	} else {
+		/*
+		 * Safe and required to re-import if we're using provided
+		 * buffers, as we dropped the selected one before retry.
+		 */
+		if (req->flags & REQ_F_BUFFER_SELECT) {
+			ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
+			if (unlikely(ret < 0))
+				return ret;
+		}
+
 		rw = req->async_data;
 		s = &rw->s;
 		/*
-- 
2.35.1

