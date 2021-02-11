Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E69319663
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBKXMx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhBKXMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:12:53 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B1FC061786
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id y134so7312910wmd.3
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4jyX0O3fxVG6gtoWmfDR4frKEwY45aA4KNpIGh/N8Ic=;
        b=N3/HnBwVKm7sa+g4ORyJi+W2eUjFgcR0CXS/nSnkpXtDOwcp1jzhFLy9FyRTgK78R8
         cwBioG+VTEDEjKtajYB+QmlFoNKWDGPhxsu4Mfu7c732co4BpzNwwWYdxpR03UOsX5fM
         yVc71w3qouXcutxi123FHyUwQpxtdoVyzNtsSnLZzCdDQyqU6cNMIZnqui6ewd6ByHBe
         uJldnIzBnLsJzd046a6jTmqsu97yaZKTwlS+5gjIa9X1K2/ws8FM5tAjEzL7AOTYDdS/
         tEJ4+lySetg7qRPMMS/CwH17ZQS41cQ/ydwUObZtGY0xPjOiMjeDnSt4iQ8NbTCepz5o
         qMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4jyX0O3fxVG6gtoWmfDR4frKEwY45aA4KNpIGh/N8Ic=;
        b=cD5t9KucL0HnjHG6tQHW/VI4a2ejAU8LQqqWU01wQl3Tk0GjyslkukxnkRCyt0WGAw
         DMAERg7eBdQ1qeqOddVDvHQo94hmDM9sx1NH4xiovn23HBvfQy6zLfKDczNJeml06AP7
         ujGURjt8JIWCsAcT00ZT3SrBc8oKz69zlyPSAB4EYwfJbrgstsNtqE5IZiBCwgLwcFpc
         6FQ4Ygnmpqq9AjuNypdTlEl9PCGrQz8sHlC2qocDlZdgq5qs0SHfYAvJUvnX5kDGCwyO
         7CTt1Suhk98MpISF4wsAD4ajDXO5vkgWEms2nbNo21zFmXVNkw5MnEFELd42PIqyhmsd
         PqeQ==
X-Gm-Message-State: AOAM532XqiUcM/e6RlN7zK/LkfofIOslj1z1CallWnOVeO6P9vC0HtDy
        FvrNhxtI1k9IRGkHhJS1DhQ=
X-Google-Smtp-Source: ABdhPJzbqT5U8CO5mTvybzHIO6PH1pTomqu6nVFvR4OFNnsvhp+rx2uwEaWf01cec2vqWtZgDBrOZQ==
X-Received: by 2002:a1c:408a:: with SMTP id n132mr240067wma.86.1613085131672;
        Thu, 11 Feb 2021 15:12:11 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d9sm7271184wrq.74.2021.02.11.15.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:12:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 3/5] test/link-timeout: close pipes after yourself
Date:   Thu, 11 Feb 2021 23:08:14 +0000
Message-Id: <2233afd12348c28a19fd8bf7eacdeee62685b25f.1613084222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
References: <cover.1613084222.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Close pipe fds when we exit test_single_link_timeout().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/link-timeout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/test/link-timeout.c b/test/link-timeout.c
index a517c5e..5d8417f 100644
--- a/test/link-timeout.c
+++ b/test/link-timeout.c
@@ -528,6 +528,8 @@ static int test_single_link_timeout(struct io_uring *ring, unsigned nsec)
 		io_uring_cqe_seen(ring, cqe);
 	}
 
+	close(fds[0]);
+	close(fds[1]);
 	return 0;
 err:
 	return 1;
-- 
2.24.0

