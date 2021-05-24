Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2038F67F
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhEXXxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhEXXxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32554C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id n2so30288345wrm.0
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6vzEUeT+BXJ0e75iIdUD3uAUfU3IbOqFiPlZqRC4R7k=;
        b=SO4ZKbhxmjWgFXekAE4Cc9JU+VsvGfEcz7W9i+L5VTAnD4w0I+NiZeZueq/og1sTAW
         6E6zrdTpx+JwUkHp5Rlhnwt1yMgUuoe0Hly7EzHohct7WMmY24+QARTFWvPhYCyMtJOu
         3OgyHk0HnaMK5eJ/QO0C8Zq/M8UN9dIzz4Gj6SZ9ljuZAfO5RvG5C9NnIlEV6jAOeNYj
         EYzHiLARRfrR4fBh5hyXOScJVAd8qo1Ck+2gwMBov9qKCdZLQv7/pNnyM6Uo5DYGmGwS
         yiTZwGKYchUN2DrZ2nikBd7AZQShGRzSKeQVzEJvn/1mkknAOfo2VTmvJgxIMqD5UGi/
         J4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6vzEUeT+BXJ0e75iIdUD3uAUfU3IbOqFiPlZqRC4R7k=;
        b=NVGsr9BDLufOmg4T/xW8FKNF64O0X0erBMnyavpbJexo56t6VORiBI1TUeMrGiQaTC
         oEuuaPR+F0XWYKC6mS7R+YfNZqQYR2AqqCEeM0XzV0I2ubbBmL7XEFUxgPxYwmWuQC+H
         6OeRrqJKQ+S2OnWvAGE/SWUdpKXh02HvKo4NVf9+kFopaBRfc1q+gi4u4SHl1FNPGEeO
         C2BtUs99kQQMVAQL35g88ztrUL9Z6uxGQSPp9bSt7+II4wowzrGqPmYZUJq2IDMdhGXa
         Hi6Vz5wqL3XdSBNZBRonxlO5+W89tM12RAVlFhAZzJ5J3/NNf6FE5QovB52Eernz0E/e
         z+XQ==
X-Gm-Message-State: AOAM533HUTVdHvKbARWQ2o3awauuTMFVWlzkfJ79p2F8I/ZqjNlv2VLq
        xwuOcYOFdDQTbyGnLOT7WrVe1r6DBvbWA2Gu
X-Google-Smtp-Source: ABdhPJzLrGUs0H17jvvjigPT5I0wIzbQXo1uwWaaf1P8CJyMz7qMv2ua3e3AK0T6dqAmtGtdLld1KA==
X-Received: by 2002:adf:ef0a:: with SMTP id e10mr20670280wro.146.1621900293859;
        Mon, 24 May 2021 16:51:33 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/13] io-wq: don't repeat IO_WQ_BIT_EXIT check by worker
Date:   Tue, 25 May 2021 00:51:05 +0100
Message-Id: <757c0c39f1233e9db3b351d754308e8d62096913.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wqe_worker()'s main loop does check IO_WQ_BIT_EXIT flag, so no need
for a second test_bit at the end as it will immediately jump to the
first check afterwards.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 712eb062f822..27a9ebbbf68e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -560,8 +560,7 @@ static int io_wqe_worker(void *data)
 		if (ret)
 			continue;
 		/* timed out, exit unless we're the fixed worker */
-		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
-		    !(worker->flags & IO_WORKER_F_FIXED))
+		if (!(worker->flags & IO_WORKER_F_FIXED))
 			break;
 	}
 
-- 
2.31.1

