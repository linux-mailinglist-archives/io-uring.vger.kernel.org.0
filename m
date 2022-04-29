Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E23751494A
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359152AbiD2Mbi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359148AbiD2Mbg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:36 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85DAC8BED
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a11so6805053pff.1
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QPWZQXPik/l0zx/mj7hc4QqEQbNToqIKASj6Uie6OLo=;
        b=H2it66w6eERhHjYfwhuixlHV9Wr4w9514rGayWmHt1juz0K7qlnynl7xYBeKOuB/ob
         5jr87hK5AQ9V4YnZpcBaqrB+2H9LYvxJfr5vr8XEFVqXxQ4bVXscG3EJhplwZTVJQX+0
         UAT/0hM0ta6poBTTMCvtIiprm6ba39Ja6ZzGID6CSIQ86361Ylblv5uoRK9BHSalNW43
         8/rg4cgVs7mfusQancAEUB982rdxUPbUsCAhAyGSPy9fSLaonDKT312hEvBGSpQ+0noh
         gZZ1A1uNJtcWKvh8J60Qkl64fm+Q0bZ2ofofo/FuiMcrBIoSF0KCwqclMVxvrV5QrKNm
         cUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QPWZQXPik/l0zx/mj7hc4QqEQbNToqIKASj6Uie6OLo=;
        b=jhMUbBabrXo+C2pZutRYwHm4lrP93USRtBp6RZrzpaTmB6SxfCOWaJeb1NcDiCEq4I
         Eu5fvma5cjMySgGQf5VKikQrdUSN96okBeyGglqf64XfdjvVWn6brSZPF+p0ttkIFha7
         yodp+GaQhfA7XBe7Oxjhl5ijoNnQcHAlzj0ZLEYNkBwekrSG0DUKO7We7OgkWh1TgSqX
         VhpQF0Dm0CAgWEtszdQItw07iFJs1ZKpRDjewAKaomOf4yYIIPqn9SIZulDx4TVhaJvn
         p3OpcqipjupTPDicwXYg3cGfv/qKvPyDTU8rj+CBhWFrYLc4M3gZtTpJHoZk/Eb3qatF
         d7bQ==
X-Gm-Message-State: AOAM5303QHB/RvNCmQGeMTLsqvPhUIZKeYIiqQYkYl6QZUWzzfQ6PW46
        FrIHMkOwDh9B55nR9QWE73sWGCeU6MG5HvwH
X-Google-Smtp-Source: ABdhPJyAxW7AQO7iB/Lq8XPQtqctaCzrWc0eCwGi3j3+OsG2SAuSswmKSRotA2bn9CQ83gw4J6SpWA==
X-Received: by 2002:a63:5c6:0:b0:3ab:a0ef:9711 with SMTP id 189-20020a6305c6000000b003aba0ef9711mr13652330pgf.426.1651235297146;
        Fri, 29 Apr 2022 05:28:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/10] io_uring: abstract out provided buffer list selection
Date:   Fri, 29 Apr 2022 06:28:01 -0600
Message-Id: <20220429122803.41101-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for providing another way to select a buffer, move the
existing logic into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8816c61d455..7f9b9aa57ddb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3581,32 +3581,41 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
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
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return u64_to_user_ptr(kbuf->addr);
+		return u64_to_user_ptr(req->kbuf->addr);
 
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

