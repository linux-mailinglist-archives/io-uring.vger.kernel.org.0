Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0606E4EB276
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbiC2RJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbiC2RJa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:09:30 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7E4258FCF
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:47 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b9so12808779ila.8
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vKHs9NsTH3GCqPxT5zNCFY/lteXfJ3cldT9sqlPJYic=;
        b=LcwhcgHbU7VooffhAWpsBUBoWlWB/3UMBOb9A4D55s1aPLEeK4ZyR3j7LjZO6fURr8
         aAH3wFAcgzQBiGYYLn/3KcWAyVEgRtZFZ5SX1qBYOm3p+W5ZtoIGG3OQ24lt/RQcgQZ1
         8Fv62w0Z+8XynAjyXmm+8kPS/lZ3RGTOGQMlDHtZxK9dqPWUH2zsytuBhL2nSmxkVSqw
         PG4bcY4s+dJVMY7dPjtUyWtCePVByLgVdICNW9/yTXh16kk3knvK73mZfeRNFV7/XgsY
         shXJpgi/lBrD9aX9w5GOWmtIQIek07glnd9maqnf3q05ummjL5fJd0fACqvK3scy+yE/
         +9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vKHs9NsTH3GCqPxT5zNCFY/lteXfJ3cldT9sqlPJYic=;
        b=SgSKDBbYeCu/+JyV0hnTcV20g0aVe7mETlHKYP8uUM20O0/otcX9SwFnCpfGGE4B8d
         A+dQtC4s08QxG/6QJCKR2tHdUmusoUutQlSskTkcNGn8uyBmCOQmPsAWyNrU0t2ZoXN7
         vBASDmdUOR073CnS/R1Jhuuz4hiv/taqGZ+V5K3dJceg5BZ2iB7mTnz74Cr+OcrDU8kW
         x7iJb5mfBKVC+ZawIuJgFn5LM4lRQ4eH5GV5B1/R7iu4lYT0NAC6d6/mIBCRysFsWdtU
         set8t8/TmHa5nCO2V20+CoV+iTqofxhAjT21OsNEFEGXn9wN8POFx245ZSrep7lNTc7x
         Ty2A==
X-Gm-Message-State: AOAM5328K7Yp+BWroPP97SxsRstgT2Kj4QRZivhdy0nsinw4+P/ZyWW0
        LfCjfo8+3uVXZkijvNYC+PGtvElrJDRV+gbe
X-Google-Smtp-Source: ABdhPJzg8wYkc8dDI0hIB4kAJyJhin6yQSB0dzQiP+DR2LIMx0OlFhGlLpbTMM3xNRPhqCs5U4yFcw==
X-Received: by 2002:a05:6e02:144d:b0:2c8:5cfb:8fe3 with SMTP id p13-20020a056e02144d00b002c85cfb8fe3mr9138117ilo.35.1648573666539;
        Tue, 29 Mar 2022 10:07:46 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9383069ioj.44.2022.03.29.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:07:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: fail links if msg-ring doesn't succeeed
Date:   Tue, 29 Mar 2022 11:07:38 -0600
Message-Id: <20220329170742.164434-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220329170742.164434-1-axboe@kernel.dk>
References: <20220329170742.164434-1-axboe@kernel.dk>
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

We must always call req_set_fail() if the request is failed, otherwise
we won't sever links for dependent chains correctly.

Fixes: 4f57f06ce218 ("io_uring: add support for IORING_OP_MSG_RING command")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 39a9ff31dbc5..923410937dc7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4500,6 +4500,8 @@ static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 		ret = 0;
 	}
 
+	if (ret < 0)
+		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
-- 
2.35.1

