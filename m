Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06320550470
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiFRM15 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiFRM14 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:27:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375AA18350
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eo8so9403132edb.0
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/pJ49m2+IL4kzsIVLJ1E9AlFAdEpgLhPZK8wfi57hPo=;
        b=kl2d/o0FQIvNlboNVMFcWSqtTZ5enSIUY/ozpuG5ExuB3605smXx+hcbF5a9sRK433
         ZQYmrsa1xxucxQi7M2/aVfhnfHAd2mDbLw/qIUv+BeWAAl3DweSINnYANZ/OPhQ4Q2J9
         G2XTNJlyBRzjzozDf/xwNt6pHF+4Pb/R3LC4S+Yb78UZon4PvihPWz8s8m2zR9IizcTY
         sMuBsgHvby1/xM2v3XAcVELiD6GeguFRvGopq8+fGM65h/Ex8OTmaEksqs3KmB6SpXYD
         ukEhgA4v/2N1XIqWUzO7PrcIHHkOteH9A62XijM2PCc8ooOJsEwumqpR3a7ryNeRtcjH
         xP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/pJ49m2+IL4kzsIVLJ1E9AlFAdEpgLhPZK8wfi57hPo=;
        b=Sp9hzIwPYCT27JTldWvdNEz/zQVpIZIBk8TQwI36n+TtuJ03jJ/uemVbKTKKLsUTWe
         VOjX2tkd0kT/kBaQcl4fQPjF0MsSw3hS+c1ygae79ZYjgtMm9/qY0YkSpX70w7pXOT58
         QmgMC3n+0cY2gynLd+X+knsMeHZtMxoyOYa12Sr5ZYQa7ItrPTFnnwAjgzftECq2atbW
         yomTNS1XwVvc+vhdjcj1W8jjIxg+VbbLpT/l+A6pMIJAFfbiqlq1MaT5AdFgp3yXwpFK
         6Z1vfioAmTIAo4K3SNvUAFFv/obxEOSL58DciDEegcFZuVyN4VC2RX9YxB9eawkO7A2z
         k72Q==
X-Gm-Message-State: AJIora/MUYwloDVgeCNtgK25LqmJVDiHk+G7xaiyqlh8v9MCrvNLpz7Q
        iYhZFaR1j3HL2HKPuoHcRaMigeQSQt4xEQ==
X-Google-Smtp-Source: AGRyM1urgDViPe2i5FRJdpdodm5fOPrGoZOk1RqNgUJcSbL2m93bGiywj8fKlXOL2btTLKtZRMYuRA==
X-Received: by 2002:a05:6402:56:b0:431:6f7b:533 with SMTP id f22-20020a056402005600b004316f7b0533mr18067409edu.333.1655555273462;
        Sat, 18 Jun 2022 05:27:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u23-20020a056402111700b0042dd792b3e8sm5771523edv.50.2022.06.18.05.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 05:27:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/4] io_uring: add an warn_once for poll_find
Date:   Sat, 18 Jun 2022 13:27:27 +0100
Message-Id: <6ba50b0e272128f578f1c7b96b7e4b6ab927a44f.1655553990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655553990.git.asml.silence@gmail.com>
References: <cover.1655553990.git.asml.silence@gmail.com>
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
index d4bfc6d945cf..15a479a0dc64 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -824,6 +824,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
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

