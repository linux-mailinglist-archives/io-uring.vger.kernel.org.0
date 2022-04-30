Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19404516070
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245063AbiD3UyM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245204AbiD3UyB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:54:01 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD5813F70
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n14so2907504plf.3
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YesG9T8z2LoOW1ow8stF4Zvp1AnswdkD6H5E0BQyghs=;
        b=H2WYINfDbaYCfDxVrDvdy8XeM98/uTrjwMaGXQl+PV50a5qtKThhwFi60eB2IYjqkt
         CTY9GA/wwQDRW3yPmjyRXWXQik36MclyZRHAF9ITt0BNoKXgLvAAftkecnSFuZEJXJpj
         jfK9FwLMO7vp5GFzWseDtC9NDZoOEDkIn1OuRUrTJOkDIInBXka1wqISUjT8FKF0uRcf
         pn7wDNTEuCoU+gduyTroS0acPPEPCrMSK/Ea7v+yYjwL1PTOB9y4p/x5MPSTKTK0k4oC
         QJjJrFR+EvwoSFpu1P2LUBXuv+mDIFDUAAYgiaA5UzPHUv28Pdq3gEpy73pusQqAgNSK
         Qvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YesG9T8z2LoOW1ow8stF4Zvp1AnswdkD6H5E0BQyghs=;
        b=Js/A0oHl7jFMnyXlmVXte35R+8oSgtd9PHcPKx1x0tNGr+6WX/RDPVSbzBQJwNiHS9
         zAO0+3610eJJYaO8Ln7o6h4O6nJyktlHSrTyAowF8KDC2A/YuQQRWDWo5za7AlcDX7tp
         H6mVdpE5TmdSub7JkrfaZoLqa3shlTYcl3JLhbpBf7c0FC4k092DNdy+vYJotNFKVQfG
         h0l4T8r3swC7+IItynCzEd0x3KeOaHowx99drAZUXiKYzGRpWEHg5FLqFUgE3bsrgxZK
         lakDD1GVbasUecEZdnePY638RCgIDOnEr80Lqm1wAYm6XFbITIDuN0W4cuca8An5efWq
         oMIw==
X-Gm-Message-State: AOAM530VOZ7gcrv2rXTaqJudlNni3RVw2rj9Ma8kViyNUSYXsTapu74p
        atu12TaZo3SfatG0Snwtl16KBnwxPOnP3Up/
X-Google-Smtp-Source: ABdhPJzRN1tl0pLSlQGNBmx7kiGOHQb36Ktap58yMIZAbEVjTH51jYCUpWx/x3xuQDv5FlEMg2gVXA==
X-Received: by 2002:a17:90a:b106:b0:1d9:7cde:7914 with SMTP id z6-20020a17090ab10600b001d97cde7914mr5597593pjq.56.1651351837135;
        Sat, 30 Apr 2022 13:50:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/12] io_uring: abstract out provided buffer list selection
Date:   Sat, 30 Apr 2022 14:50:20 -0600
Message-Id: <20220430205022.324902-11-axboe@kernel.dk>
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

In preparation for providing another way to select a buffer, move the
existing logic into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b9636043dbf..616a1c07c369 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3583,29 +3583,38 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
 	list_add(&bl->list, list);
 }
 
+static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
+					      struct io_buffer_list *bl,
+					      unsigned int issue_flags)
+{
+	struct io_buffer *kbuf;
+
+	kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
+	list_del(&kbuf->list);
+	if (*len > kbuf->len)
+		*len = kbuf->len;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+	req->kbuf = kbuf;
+	io_ring_submit_unlock(req->ctx, issue_flags);
+	return u64_to_user_ptr(kbuf->addr);
+}
+
 static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 				     unsigned int issue_flags)
 {
-	struct io_buffer *kbuf = req->kbuf;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
-	if (bl && !list_empty(&bl->buf_list)) {
-		kbuf = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_del(&kbuf->list);
-		if (*len > kbuf->len)
-			*len = kbuf->len;
-		req->flags |= REQ_F_BUFFER_SELECTED;
-		req->kbuf = kbuf;
+	if (unlikely(!bl)) {
 		io_ring_submit_unlock(req->ctx, issue_flags);
-		return u64_to_user_ptr(kbuf->addr);
+		return ERR_PTR(-ENOBUFS);
 	}
 
-	io_ring_submit_unlock(req->ctx, issue_flags);
-	return ERR_PTR(-ENOBUFS);
+	/* selection helpers drop the submit lock again, if needed */
+	return io_provided_buffer_select(req, len, bl, issue_flags);
 }
 
 #ifdef CONFIG_COMPAT
-- 
2.35.1

