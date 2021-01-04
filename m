Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB392EA115
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbhADXrx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbhADXrx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:47:53 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C851FC061793
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:47:12 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id g25so669092wmh.1
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oh7D8D8tsbT2mtYO8coEmWQNiSDVkeAoddrrEeZ3uoo=;
        b=F3s7dUo3CeBOkX3BFh9lYddjFClonh9a3hkMkP3G7kfvTqCc6ihimE4y+vqTtcgZxM
         k3Y3PLQRV7wJB7wpB0ZW0FI2x2xKihZCRsqn1L3iAa3dfSwtUAa8xDqqjon/70ybBC64
         R3SXSaYOC7RA7e8B+MunL1In251YI3O7pQiHzlneerrvZUj5WKx1OsJiFzs2ZFyFjBX4
         2TwRq3XMY/Edu5zwdalj+TRZO3Glx5rGIUyOTD6HzBM4xVhXWWS3h0lZicqoZnFELOp1
         CZPuJunVvUSMZmWZ2MHuTWGNYtjskevIfzxOFkTubJbIwH1+rlMRAH4+N/+V+u5Dh7UC
         AFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oh7D8D8tsbT2mtYO8coEmWQNiSDVkeAoddrrEeZ3uoo=;
        b=DnkmxQdPeqnWuj6y3LIgls2J4lmDE4M84l3dJgSxkv6bn+u4WfY5qMOG2kSk54h/x2
         fXXnbf5vHIN8y+qMlm443a0RpZ6xfFxYTluu9n2QfT8OeYD+Rkgg6WRnwYc9G1FprXUI
         MZsuOc5cnXZhI8AraX9UYD6KV9bxMjiExr3Oh09z7Henjqp5UryxvTq3hGJlGvCEAwt1
         O02LT1nVE3Zgy5SnjEvIFbcdwt4awmWR7xORFitpiMIrZ7R5U6hLakkjtDVFiVL0PRyQ
         IxBb0VePeFiDPhQBf9ResQicowan5Xi8+JE2/zelF800/AMq5/0jGePg64GrZRpFlRgJ
         ECfA==
X-Gm-Message-State: AOAM533LGDW6TBdOnsahqYHnApT6gXXzsC5YQhouGMqdDjcWG6X+CWFG
        N9ZV7KLg3WQZCIAhpa311XANkl1dvlGSBA==
X-Google-Smtp-Source: ABdhPJynVicQEBnS7PbNrzqaM70ox8oZLzX9EC/jOUNj0seRvXprySgsLlvslV1AJhKpukHZuD9iWw==
X-Received: by 2002:a05:600c:3549:: with SMTP id i9mr506504wmq.89.1609792710170;
        Mon, 04 Jan 2021 12:38:30 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id z6sm97140749wrw.58.2021.01.04.12.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:38:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: identify timed out tests correctly
Date:   Mon,  4 Jan 2021 20:34:54 +0000
Message-Id: <324adc3c4d04f890932cb7b2fd8a0ff183f9ff48.1609792468.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to get a stable status (i.e. -124) when a test has timed out,
but --preserve-status makes it to return whatever the process got.
Remove the flag, it behaves same but if timed out passes back -124.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/runtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/runtests.sh b/test/runtests.sh
index fa240f2..7ed8852 100755
--- a/test/runtests.sh
+++ b/test/runtests.sh
@@ -84,7 +84,7 @@ run_test()
 	fi
 
 	# Run the test
-	timeout --preserve-status -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
+	timeout -s INT -k $TIMEOUT $TIMEOUT ./$test_name $dev
 	local status=$?
 
 	# Check test status
-- 
2.24.0

