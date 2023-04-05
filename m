Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80E66D7F46
	for <lists+io-uring@lfdr.de>; Wed,  5 Apr 2023 16:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbjDEOXn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Apr 2023 10:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbjDEOXm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Apr 2023 10:23:42 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C585277
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 07:23:18 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-324419ed7d9so84365ab.1
        for <io-uring@vger.kernel.org>; Wed, 05 Apr 2023 07:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680704597;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dK43wGmG7Ai2p2LbydJAwrjIqKKvKuxSsfAlz/B3wA0=;
        b=e79lSrRAGC7a476YbyVCSUAQZRetcpugO1I138lI+yltLrQXncJ+02Aq4VHA0kq+pc
         fZnftecUzR0wmPMHQLu1vhZS1IkbYHhGH8XJu4sCFuLDkVkI69RrQlo6If38lv1Xq0k+
         pEhLO3pfgfod+nVFMKEZFLiKfI17we7JHBCgVUlVzVK/5NLhemL3d0AamqfeVZl1xon3
         OXMp1vMLtaw95wKJNIBCzk17TI+IaIlKhz16CLlCN/vxdRzmRXDQazrc2sffMY5HbWeh
         1fEK+4KGdrtUFOIkcYnx5bgb9+F6Xn/RNwZNBWNXkcw3XJ8KKnOh5poh5Ah5ZMwbwVBE
         8T3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680704597;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dK43wGmG7Ai2p2LbydJAwrjIqKKvKuxSsfAlz/B3wA0=;
        b=pHtjGzbQH0F2KP/zjcadZJGUTTDdQzHzxkdtDEqSoXgiFUH4DxIig5h0o64jguXTJ/
         J/QhReCjdk3Eo1bLg9ZxRBoIHcH8tWyyTUlELRi8/G8UteJnf6veRln5b/4nsZhQgJaU
         MgtPTxuPOZwWgGJxOGdAmsUFYgR0jv5M8Y8gtIy0USPV+Yn0T67FdpstnRLboxgkxfZS
         7yRkrKDx1KgZmM9hvPWOFhMnGKCsuCWiDjCzIYy5DjBOOwjpKHH69DDE+y1WaOYK8W6O
         ftfmtWzwchW0KaENhaJI0tiittrjVSTMZYm0iRkng9KInc6zGtlk+KROFKRgMCa2IVWu
         bqlQ==
X-Gm-Message-State: AAQBX9d+SRW4RFFonzYmmNYxSICy30rlWg7lpsyXJ3xFyGfJE2WInpiQ
        F/o1taxC7Fp1I2IlL/m3/+XenWP1wr8SWTaTQmm/Ug==
X-Google-Smtp-Source: AKy350b3CZOiOpxhied4W0joayTcLzR+xooN7N6ZwZXwzYpgdYXakOl3pAZM04QBMycKiwlQ33LHjw==
X-Received: by 2002:a05:6602:2d11:b0:75c:f48c:2075 with SMTP id c17-20020a0566022d1100b0075cf48c2075mr1632429iow.2.1680704597045;
        Wed, 05 Apr 2023 07:23:17 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 123-20020a021d81000000b0040637924a30sm4104650jaj.31.2023.04.05.07.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 07:23:16 -0700 (PDT)
Message-ID: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
Date:   Wed, 5 Apr 2023 08:23:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/uring_cmd: assign ioucmd->cmd at async prep time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than check this in the fast path issue, it makes more sense to
just assign the copy of the data when we're setting it up anyway. This
makes the code a bit cleaner, and removes the need for this check in
the issue path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 3d825d939b13..f7a96bc76ea1 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -73,6 +73,7 @@ int io_uring_cmd_prep_async(struct io_kiocb *req)
 	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
 
 	memcpy(req->async_data, ioucmd->cmd, cmd_size);
+	ioucmd->cmd = req->async_data;
 	return 0;
 }
 
@@ -129,9 +130,6 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		WRITE_ONCE(ioucmd->cookie, NULL);
 	}
 
-	if (req_has_async_data(req))
-		ioucmd->cmd = req->async_data;
-
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret == -EAGAIN) {
 		if (!req_has_async_data(req)) {

-- 
Jens Axboe

