Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D544550DDE
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbiFTA0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbiFTA0n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:43 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F9FAE4C
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:42 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so4909564wms.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iptJu5S9l0iTt5O+vNfxYG0xjAG14H5Pl4KgK+E5Nr8=;
        b=PeydXpV4x1bQmUlhd8FGnJJWLRkcgkBP6TNlxIcLttns+xt+/x6yTOG7asmt86US4D
         tQ8ATXoFZeg7qe0pW0hEWg415eRTwi6uuquHFIM91iuzzFnNz/ijHNU//14GGXIQE2yZ
         5EmxyW1YKgvNpHBltEuK1+Cchp1iVNWObVCNSWgaoHmx8Nuweil/xUoBLMQMoTH2QMSX
         KdHIKEsBMWncylXC1BpYhRGjJ2hzFKBSNoLT/m8rBMPeG7cAj5lhLX/XS8phXPjk1HmO
         NRakWw/DTrpsvZSIhUC24dUTLF00eP3B70PF0Yu6dsvM8iiSXRa9n0EQEz3Hw8o9+1LX
         6vXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iptJu5S9l0iTt5O+vNfxYG0xjAG14H5Pl4KgK+E5Nr8=;
        b=5iPnA5dzikAwURs/XHuQT969skv6NTIw6tIiKDND7IqEH27Sqk2n0fIi9bszuNYUy4
         9fQVklPDAIk9F9NR6ATASIjN8jZtkkFqErflmiD7Yi8bCmeDubYfH/thqu15weA5K9LH
         cjDBaj/cxlyjcd7BxGA5kx7zgNzOMBaA/HcoBHP4k3tjS6WRCEnp6wqsIg9Mbw7fDI23
         EGdkz4hMNsvsOPsm3lLrxKQDODCaPD5V35uvewJuu4c+H5hvADkKNubq9Vd6e5LLzWXQ
         cvCfeSkx6zCNHV/LzZWeUQ+jfwTMo1nEHWnvdYa/4YcsYR4D0PdKJ6zHtb1iDYInW/gP
         aDBQ==
X-Gm-Message-State: AOAM530Ovim49NKY/74RYdD3sykD8ll6gobyqAZScwOJewBmFjkFHOEj
        iAhfYwb7mnpePO5nmA6kWdVnZPvNKRSyeA==
X-Google-Smtp-Source: ABdhPJwCbsIQt+/3JIcFlPskj0MF4Ug1T1I4YsYS7dYZwOYIu9ud8O5b4y0rMfeugYrD9t+omH4JEA==
X-Received: by 2002:a05:600c:4112:b0:39c:9417:a89f with SMTP id j18-20020a05600c411200b0039c9417a89fmr32497779wmi.150.1655684800838;
        Sun, 19 Jun 2022 17:26:40 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 10/10] io_uring: add an warn_once for poll_find
Date:   Mon, 20 Jun 2022 01:26:01 +0100
Message-Id: <ec9a66f1e22f99dcd02288d4e42f3cc6bb357804.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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

io_poll_remove() expects poll_find() to search only for poll requests
and passes a flag for this. Just be a little bit extra cautious
considering lots of recent poll/cancellation changes and add a
WARN_ON_ONCE checking that we don't get an apoll'ed request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 9af6a34222a9..8f4fff76d3b4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -827,6 +827,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 found:
+	if (WARN_ON_ONCE(preq->opcode != IORING_OP_POLL_ADD)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
 	if (poll_update->update_events || poll_update->update_user_data) {
 		/* only mask one event flags, keep behavior flags */
 		if (poll_update->update_events) {
-- 
2.36.1

