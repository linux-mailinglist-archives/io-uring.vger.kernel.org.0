Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062A83609AF
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhDOMp3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 08:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbhDOMp2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 08:45:28 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0760C061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 05:45:05 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso2186199wmq.2
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 05:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aFkPp9UH9blMlsAgNdq8eosYxVPgglMZQQzElkxIn+A=;
        b=FR2s5HbOKjsV2/w446AhPkh5RURDEcOPQp9qOqc5A4e2Jz3hD6BtY+PwKDaIN8BCET
         zSt2pMrnCQc8ufx8QXU8ipSHOzSGrHVU87KOs5cjv+N7gI+rmFesJjhmc6gf8x6Cn3Ij
         dYp6CFIiqelow4a6Ch5sSf0cT/QQJNr6LWnW3ZYCyxxhvMYbRaKjDkm9TDiJfJQc5oId
         7Imup74KBC/W7qv2nvQexN1dZ1bPoLDj/FyV+bxnPkmI+q529p0cBGj1tm6D5AuoJCJg
         XXycI+poE7J/ycLvgHUOp5hgqUHuTyyHIG8+Xs+DR3U99uDhnRDFG4K57+OOTT2FdQTD
         ++Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aFkPp9UH9blMlsAgNdq8eosYxVPgglMZQQzElkxIn+A=;
        b=Pr/5a0mo/NhTns74rQ9CRbkz3hH+7SutiFxvXMScP/gkL3fzC/BLLg1eys38f0K4MI
         JCzN/NjtYuKRbFlCMbUIVXOufkBydS5g16M/IbDP3+7R3GRfCiqYt3xs9sKdMAp+I6OT
         UqVatpkSrB4snLFq83qjIWmC9q2I9x9WK+OEdJBzXW6wnZSsneX0dZrpMyLo/Q5FLbWs
         bgdP9bjYsN+CutQBcsXgpRFEp0h5ZelZElxBY9/orrvd71EDsWtMIxxsZGvY6eHCY1Y9
         yG35BDqv+TLmDuD36UmQ2+DsGDWo9/QxJYveZK4sH4EAFMiejJBYKJaC7ohIRByZo1ow
         JKVA==
X-Gm-Message-State: AOAM5323BZL2Os+zuK7mzjnfq7I0C/P3bIYCYpxzQvtPMiSuU06UqIxH
        zcOZStmi2rtGf5ICUVQ6T78=
X-Google-Smtp-Source: ABdhPJwTqlQn72UD9sgpeCkteS7hDk9dKCuzOFkK714XdDCM/8xs0ffjB/PFVSDv0jcFQ3FN4uOZUQ==
X-Received: by 2002:a7b:c153:: with SMTP id z19mr3080763wmi.5.1618490704484;
        Thu, 15 Apr 2021 05:45:04 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id o62sm8670551wmo.3.2021.04.15.05.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:45:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC] io_uring: submit even with overflow backlog
Date:   Thu, 15 Apr 2021 13:40:50 +0100
Message-Id: <0933f5027f3b7b7eea8a7ece353db9c516816b1b.1618489868.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not submitting when have requests in overflow backlog looks artificial,
and limits users for no clear purpose, especially since requests with
resources are now not locked into it but it consists for a small memory
area. Remove the restriction.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Mainly for discussion. It breaks several tests, and so in theory
userspace, but can't think this restriction not being just a
nuisance to the userspace. IMHO much more convenient to allow it,
userspace can take care of it itself if needed, but for those
who don't care and use rings in parallel (e.g. different threads
for submission and completion), it will be hell of a synchronisation.

 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 357993e3e0d2..21026653e1c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6673,12 +6673,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	int submitted = 0;
 
-	/* if we have a backlog and couldn't flush it all, return BUSY */
-	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!__io_cqring_overflow_flush(ctx, false))
-			return -EBUSY;
-	}
-
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
 
-- 
2.24.0

