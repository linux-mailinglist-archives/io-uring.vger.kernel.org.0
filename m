Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2053F3F33
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 14:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhHVMJD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 08:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhHVMJC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 08:09:02 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D51C061575
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:08:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v10so10432907wrd.4
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 05:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zJbsT3qY5KkiBRgdFaAPKwhKk8M8Yn4DXefVqiW+zKo=;
        b=an8tOvdr3LF2rkvQmC7fMynDcQKqgIBPZNddx13swSYgpuby6Fj/6JiadlBTNZZk+y
         HY777qY+1sq/vE/uU4W9nSPI0MUJ6JvA5GMZuv2PxVM3mHSdcoM4d/ngirefwsLUi7sP
         pErKLxUOpJxjmD+NcfYBjc1g+btWQSiByCH5AuUVpU8/2l33ABLnRRITtGGU/4aJlBXc
         5wJxLpaHB2/7cfUnpmydqM/lXPvB0/j2321HUZCRd4eFs++i1Rml5Pwb2sDJPGI9lQZv
         G5q6+/iPO+4KNTQ94pjYM41XK4MuVRmlI4FIVqnC5wat7Jz80Dw7VQkAy/w2LQh7axQG
         1JBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zJbsT3qY5KkiBRgdFaAPKwhKk8M8Yn4DXefVqiW+zKo=;
        b=HI4L3Xtqlvh096KHgUcN0P+kk0VwBELgDtGeWTbwOt6I1/PWve9avOHNLSQERytwd6
         0AP3CP6kzvbXwCGPFISMEjzgLO5aHR3/adsmPfst8yDsqCNYYEaHvFrtoKX9zy3Gxi3Q
         X8YHFasBEZyDIB2gh5eBO+By7Hl/0oX7NBriqp687oP6uTEiuaPsuiBxfg7IT2DuDzAb
         7kD7Pb3XV6otciytyjk+2hcSxi34SMCKF4Acsx5QpluPWUZnpQ6WtB5jIRMZ4+Fi4pqh
         9rVn36jObKY+c9ruYKRSEzF2uT3UR3N+EreBhjQZksDmJ6zhXKvGWS68PILtHuyu2Abo
         3eCA==
X-Gm-Message-State: AOAM530c5L22mOIBmbmc35O6FJ1g6zJILjVJE55rD/48mr+wsA7eM8+A
        EuUiCZmCj3YaeIAlBjWzFDtVpHomMsw=
X-Google-Smtp-Source: ABdhPJzUWP0w6/+97ZqZAF/XT4zX9nc4hfa5TeZNtKDF602XFANFRdTvV5R18XfyQHsbOhG5tzCBGg==
X-Received: by 2002:adf:e9c3:: with SMTP id l3mr8536950wrn.300.1629634100199;
        Sun, 22 Aug 2021 05:08:20 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id l2sm11604294wrx.2.2021.08.22.05.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 05:08:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests; skip non-root sendmsg_fs_cve
Date:   Sun, 22 Aug 2021 13:07:43 +0100
Message-Id: <d2fee3ad7d2516d2a154ff380b067ae58a694e61.1629633956.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Skip sendmsg_fd_cve if we don't have enough privileges to chroot().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/sendmsg_fs_cve.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/test/sendmsg_fs_cve.c b/test/sendmsg_fs_cve.c
index 8de220a..57347af 100644
--- a/test/sendmsg_fs_cve.c
+++ b/test/sendmsg_fs_cve.c
@@ -154,7 +154,13 @@ int main(int argc, char *argv[])
 	if (!c) {
 		close(rcv_sock);
 
-		if (chroot(tmpdir)) {
+		r = chroot(tmpdir);
+		if (r) {
+			if (r == -EPERM) {
+				fprintf(stderr, "chroot not allowed, skip\n");
+				return 0;
+			}
+
 			perror("chroot()");
 			return 1;
 		}
-- 
2.32.0

