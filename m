Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0647A3B8A11
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhF3VRd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbhF3VRd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:17:33 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E50C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:15:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id hc16so6563367ejc.12
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=8G3i5F1naaYv337asjcTDedFAarZ13EF9OWowzAhOeU=;
        b=lFPjr3jNsgxM8Ok9GNT89LtC5+6tIyGmWZm2xBh1Iun+ewIxhSut36KbUwDnq7ExJh
         5qGs71Qdff0OJ/hVkvtlUNeebq4rYJ3sqcP7ueJtnABbg9zcCPVKLT+xK+ouqillMNtX
         4y/t8EwRZ5bH22QwHfcFCGoXpRZ4xuMB2w2m8VDW7s/9kjaIMPWFM6JGuOYYZA60AIoY
         l+9vPlCNba+9I129s9MQr5rkRqo3rPlbhzvnwtgg1otJ7V3UiZ87F6HVt1ES1Vd+YG2V
         EvmKQoEpE2o7M4K8P9LESrzSjRETVnATxi6uLbNklKj8qmqfRwS1tqcd4StZ/1SGSdS0
         C57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8G3i5F1naaYv337asjcTDedFAarZ13EF9OWowzAhOeU=;
        b=jeMWnfKihwU2pLcmx3vSGvnT8K1JvX66PVxYBfVG/a+ncUowUqaMcQtWiSHBaLLyzv
         c3Y/qhnt+7u0cvda45Fcu1Ca92pdZ2ooJpTi/q5aYAYu20jNlnwuNd8C5gJzEwJ/O3IX
         xVu0JPZBCbdpuWVgD+VZjicX0f/9zJwtrpC0aQuWgLdug9568psVqhL+N+35xAAKt1mm
         AhoQDGpFuh3YxXAM34kOmfsAsu925eGUTc+sPooEKAnz0vsJyH1A7IbtyixkqmhIKIAG
         en4GWpolRT7SFvItAzNvCy5CbK4e4vO7ZfLV/6OyVorRjuRi7wnwe39n8YdMbdEuAG0Q
         YYFA==
X-Gm-Message-State: AOAM531kQA/0WukGWsz7SSmc/elRBLs566QoEKuwI8GiZKH47uX2QFLn
        3V66c1MCMokoRjLuUFp5qag4fes/lKCqSbb2SZtKGXy5shkvlA==
X-Google-Smtp-Source: ABdhPJxJSIIwOoJ1iEiudgeomAABsQDHOundbB8oCcXiqJTm3VtRSSWbjiOBuicYCz/ZOSdBqqBeCnWXXz6AVPZteTQ=
X-Received: by 2002:a17:906:c010:: with SMTP id e16mr37243735ejz.214.1625087702127;
 Wed, 30 Jun 2021 14:15:02 -0700 (PDT)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 30 Jun 2021 22:14:51 +0100
Message-ID: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
Subject: [Bug] io_uring_register_files_update broken
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

i'm fairly confident there is something broken with
io_uring_register_files_update,
especially the offset parameter.

when trying to update a single fd, and getting a successful result of
1, proceeding
operations with IOSQE_FIXED_FILE fail with -9. but if i update all of
the fds with
then my recv operations succeed, but close still fails with -9.

on Clear LInux 5.12.13-1050.native

here's a diff for liburing send_recv test, to demonstrate this.

diff --git a/test/send_recv.c b/test/send_recv.c
index 19adbdd..492b591 100644
--- a/test/send_recv.c
+++ b/test/send_recv.c
@@ -27,6 +27,8 @@ static char str[] = "This is a test of send and recv
over io_uring!";
 #      define io_uring_prep_recv io_uring_prep_read
 #endif

+static int *fds;
+
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
                     int registerfiles)
 {
@@ -54,17 +56,28 @@ static int recv_prep(struct io_uring *ring, struct
iovec *iov, int *sock,
                goto err;
        }

+       fds = malloc(100 * sizeof(int));
+       memset(fds, 0xff, sizeof(int) * 100);
+
        if (registerfiles) {
-               ret = io_uring_register_files(ring, &sockfd, 1);
+               ret = io_uring_register_files(ring, fds, 100);
                if (ret) {
                        fprintf(stderr, "file reg failed\n");
                        goto err;
                }
-               use_fd = 0;
-       } else {
-               use_fd = sockfd;
+
+               fds[sockfd] = sockfd;
+               int result = io_uring_register_files_update(ring,
sockfd, fds, 1);
+
+               if (result != 1)
+               {
+                       fprintf(stderr, "file update failed\n");
+                       goto err;
+               }
        }

+       use_fd = sockfd;
+
        sqe = io_uring_get_sqe(ring);
        io_uring_prep_recv(sqe, use_fd, iov->iov_base, iov->iov_len, 0);
        if (registerfiles)
