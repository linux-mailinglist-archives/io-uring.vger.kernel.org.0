Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957F3589D63
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiHDOVb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiHDOVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:21:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDD41F2E7
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:21:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z2so15156144edc.1
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=s0E5++4w/wKc0IHpdLr69LGiYg5m4f2WbebsnhEa8aU=;
        b=T1KcProPY2Xt90dNg0xUoGEzwRemoaiOWhwR8pxED2XUd2meat8i7tPJdJAX+jd+PO
         vkjpQ/y4v3YgtMan6YtWourOpwdhITL79A0dDppB07F++6f7eODVTY6bnu+vd0hh0zzO
         L9kggrawUNKQubFnjXSlDrTVkzOizRLc/4VAYKqDLQJ+bhQvi3bSvHlH9MQvLGtT0Qil
         dXKVz5ZreSMWUnebjHMI1TfC0WIloNQX3I9UTif3+Hn2zMJj5ojcsMHHDR/Hf5i0vyEU
         wUznoBlVTfqrfvl9T8YAkHqD6t8uvKzCax/5haWfwGAuwQ0lDGcorGi098W9Lt5dPiTY
         8X2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=s0E5++4w/wKc0IHpdLr69LGiYg5m4f2WbebsnhEa8aU=;
        b=eXJbpd0XWXplQ6/pSlN36anJs+YNeOIAqS4kEVe9wLTnY5M6dB5hu5PyLNSus72mCI
         C5tBxddNuHsR2KJUTI6czdkyUa+UHLNH04U5y/PTI3K2FUqC50NZ0rkEP5UAI6A9FZ2T
         J9UinOUpnxhPMe99WZvmoFYRZqUdhtFXWmxFPRJrpoPqlrZQNwqMmquI48Bnuae7RbX4
         dIXwjRIu3HNwkf1oE3LKQYZrRYljzSafVPRGHRLT+vYH7WQUqMdIVdC22G9kASbnvbc/
         fg5VVCyi5OQvu4wXdafcyz3LnSONlEXpaE7VAqyN5nb6dwxXhdA0mS5UcMZuwVjNsiPd
         nrjA==
X-Gm-Message-State: ACgBeo3/WNZHWvjPLhkHRSx5YiQxxdn6Ns/yhlKneBJpKeDkpxk/MUUN
        aQesbPu3y1cYFs/2rAYQa8rF8ITROW4=
X-Google-Smtp-Source: AA6agR4KceXeKnFGJSNIV+/j6Ddt42/TvUzby33m5A6SyGpbVZ8Np+K4sgIKLVoG0IRAzFs//ComCg==
X-Received: by 2002:a05:6402:5247:b0:43e:cf46:45b3 with SMTP id t7-20020a056402524700b0043ecf4645b3mr1083074edd.153.1659622888585;
        Thu, 04 Aug 2022 07:21:28 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7c14a000000b0043bc33530ddsm727945edp.32.2022.08.04.07.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:21:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/6] test/zc: improve error messages
Date:   Thu,  4 Aug 2022 15:20:20 +0100
Message-Id: <094a2939de904ea81e65277e10662a1db6e2a068.1659622771.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1659622771.git.asml.silence@gmail.com>
References: <cover.1659622771.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 6fa0535..c04e905 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -676,7 +676,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 
 	ret = io_uring_submit(ring);
 	if (ret != nr_reqs) {
-		fprintf(stderr, "submit failed %i expected %i\n", ret, nr_reqs);
+		fprintf(stderr, "submit failed, got %i expected %i\n", ret, nr_reqs);
 		return 1;
 	}
 
@@ -704,14 +704,15 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 
 	ret = recv(sock_server, rx_buffer, send_size, 0);
 	if (ret != send_size) {
-		fprintf(stderr, "recv less than expected or recv failed %i\n", ret);
+		fprintf(stderr, "recv less than expected or recv failed, "
+			"got %i, errno %i\n", ret, errno);
 		return 1;
 	}
 
 	for (i = 0; i < send_size; i++) {
 		if (buf[i] != rx_buffer[i]) {
-			fprintf(stderr, "botched data, first byte %i, %u vs %u\n",
-				i, buf[i], rx_buffer[i]);
+			fprintf(stderr, "botched data, first mismated byte %i, "
+				"%u vs %u\n", i, buf[i], rx_buffer[i]);
 		}
 	}
 	return 0;
-- 
2.37.0

