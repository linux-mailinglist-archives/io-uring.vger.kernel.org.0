Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5FE3F3F5F
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 14:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhHVMuw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 08:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhHVMuv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 08:50:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F82C061575
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:50:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e5so5224643wrp.8
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QmpCqpWeFLjFgjGvKF/vPlkiIs8hZNRNXKN1kNGwtTc=;
        b=YhtuLQWIGPXUNLoiV+piTfqtmRuaMDH60zflXf63TPLyU4G/LlCB2webvg7kzFy8IS
         utOHNUnEzw8FHOlqdOKAh8JwJjnCIDrHIgoE5v+p+t2KQEz0emGygtL3YGgu4jTvqv2J
         csczDDBTRdd6OhjNFt24jCbWKHktLtJmKIDPbpsugt5fCVMtPOmxI52+cPEE/rkynqPv
         Ha8Pomtb7krX2b2+hF4quC2ISb4egUjaQPK7kK0U/MzkO53KuvFhUn20IEB427yIRar1
         7NIsQFgjmVtjtf5IGJ2zbw3OqSiIHDRPWF+pqdyEOxgAxCP6F4Dj5Cu6UCgyY5+YrfMe
         mTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QmpCqpWeFLjFgjGvKF/vPlkiIs8hZNRNXKN1kNGwtTc=;
        b=NZXMvBOIf3PrUCseZImv8bLyqMXgsXpWOZkjF+W8e9zL/pDqIEZ9pCcNN5OH2FCb2W
         E7WgscRkRhoeOquSIDNjW4hW1I44geLO73AbZXkmL9lfG4ds5OlLArcNdH/3NjTx9O0i
         gt5oKOASXAJkwytUC5H3ejAP+yqur8Fa7XjGQ/K86fgDtnDbcJvfinzDV7c23y3EhcjY
         V79b9Xj9rlVyHFceR+xauj7Pq4BiTZTIixo4SepjQaPW/FZB3ZjE4TldB5fBdSx9OrgZ
         JJEfG/VkafDrdxyPEqh0/Od3tjdizHv7UmU3MdZ8UrTcIugi5YMfAdT+pe3ikH+QwwzA
         BVbA==
X-Gm-Message-State: AOAM530GAMyt6PG45cUzcJqHWxjGu+nQi+zEFxta7VHmaR8ftyqZ4Fnl
        EGEu01s9Bs8z6OQnyiK5ehs=
X-Google-Smtp-Source: ABdhPJwfj+oAdJj30mtgPXAxq4iuYXTB3SQ3GOIy0uWsSSkaqQRLqFQZE/c1kGm2S2pij5H7VoPAyg==
X-Received: by 2002:a5d:618f:: with SMTP id j15mr8517431wru.80.1629636609294;
        Sun, 22 Aug 2021 05:50:09 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id m5sm1721135wmi.1.2021.08.22.05.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 05:50:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing v2] tests; skip non-root sendmsg_fs_cve
Date:   Sun, 22 Aug 2021 13:49:32 +0100
Message-Id: <1b9f241b5cbb6bc399528c260d136667f3404a5f.1629636462.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Skip sendmsg_fd_cve if we don't have enough privileges to chroot().

Cc: Ammar Faizi <ammarfaizi2@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: fix error checking (Ammar Faizi)

 test/sendmsg_fs_cve.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/test/sendmsg_fs_cve.c b/test/sendmsg_fs_cve.c
index 8de220a..3866e5d 100644
--- a/test/sendmsg_fs_cve.c
+++ b/test/sendmsg_fs_cve.c
@@ -154,7 +154,13 @@ int main(int argc, char *argv[])
 	if (!c) {
 		close(rcv_sock);
 
-		if (chroot(tmpdir)) {
+		r = chroot(tmpdir);
+		if (r) {
+			if (errno == EPERM) {
+				fprintf(stderr, "chroot not allowed, skip\n");
+				return 0;
+			}
+
 			perror("chroot()");
 			return 1;
 		}
-- 
2.32.0

