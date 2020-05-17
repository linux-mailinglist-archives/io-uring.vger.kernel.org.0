Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CE71D67B2
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgEQLZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgEQLZT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:25:19 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA29C061A0C;
        Sun, 17 May 2020 04:25:18 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id d21so6768482ljg.9;
        Sun, 17 May 2020 04:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OTXw9mN8rXe77orjzGk/uMC+I6Mqctasvyrsu4HPajU=;
        b=NqTvQXTw5qTVvzvB0fdq9HJIhlayeCwL/BPapVPtNuCpxT1A5Irm3P2b0OTC/l1z+w
         c/Z6Pg4YtRW5axI3FqOXQds7n2WxZGiKrk3VxvthV4ln0kptTGE0kPMQ2A1r6nCQT38m
         WLW3BzLhC55TGzaqo/prsg36vq5gSqjY5VVm/F9foAFPjwGK24DC03RM//PlGb/JMw/e
         sjf2XL3BHPUmorWvkmvmLB3CXz9Be+tN47qP3XpelbqyF5jJtgebJLM/xhAaEkQb0sBQ
         npKiLQy4zq4x8WYYG1h2pIRGyMLFxrhFS0HJ+hM2metHmbEtnb8cn0ndC77ic+3lyUY9
         eO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OTXw9mN8rXe77orjzGk/uMC+I6Mqctasvyrsu4HPajU=;
        b=ZZKpvhfCwrTdRryDOr2hLYyy72s3uNPYZh/fsNJ/KcZKmFX1F0vOZtTVRCt+dP0qjL
         mV6RkKgwqTcjQ2ia140XwQX3AVXdzcObE1sq90B0EhTd1QOfEdFjN/CNNhuuJTq6gJi6
         +lHNFqq0ttqIqt+g7lHLXXyQHc6jm1NYVIAIcfBewakP7U93T4WATL2siGZmdKolL68U
         Rago/waeO6Yga5/r1/WEelv+z1MbLPo8uj19NqoZSB6hwdftwJ3a95F5pFKGo9E4j/hi
         D87DEAHcm0qXVcgaNhJrmkK6iNjCQFAmz2Aw7vECKOP36/gsvg7PCUjo/5wli1tdBE+w
         aJ6w==
X-Gm-Message-State: AOAM530DPYlRY2gxhldsz/Aj6DMLjL0FWZXxagJ14P14sZVzA/1N6Esb
        tw4XlT/TlN2Bsu31HZ0F7pQGgNg/
X-Google-Smtp-Source: ABdhPJzZlwRP81DQPiSh2qI0Ov1OM9aM3Uq+DyS/UVrb+VvPIDnZ1iHH0Hy31aqeU1Fr/kp3ywQryA==
X-Received: by 2002:a2e:5451:: with SMTP id y17mr7524337ljd.6.1589714717318;
        Sun, 17 May 2020 04:25:17 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id c78sm5639828lfd.63.2020.05.17.04.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:25:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 2/4] update io_uring.h with tee()
Date:   Sun, 17 May 2020 14:23:45 +0300
Message-Id: <c628f0d46d138a9d6e12ec0ae3f8677601b5011e.1589714504.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589714504.git.asml.silence@gmail.com>
References: <cover.1589714504.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index e48d746..a279151 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -129,6 +129,7 @@ enum {
 	IORING_OP_SPLICE,
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
+	IORING_OP_TEE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

