Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EAE41784F
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347317AbhIXQRI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347306AbhIXQRH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:17:07 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FE7C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:15:34 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dm26so3819227edb.12
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yIrLJye4LIMMKtlWve4XIDka1yAeTmnoEHAXUYA796w=;
        b=aRRuOv40iHrDBGTj/VcIkEAwIKIzxt81nyBXy+qrCvaUA6P6AsHq5sr8/VUj7IoRDr
         S6JHWqFqtOZsd4771c5og082zTEAuiOGDpavTzPN7Cr7mrgEnZ1G/hT6GHUCf20oQdEz
         5nbEO4QwyFB64gLRIw4Wcgh5BXCiPJN07EFFbBCYkqIic3BBPtSz7IHSDxcYUvrHnXXT
         E0Y3qn1hM4zpSIPU+wWsLZNitP3gp6hszfS//Z6pTrfxnV0CSm1VHibnveedFn8OTn/n
         u8uODq5dADenUp8bqKg5zzbBfWfFMPotASD0UGqi2McCJQKHy87AhcBLInxJWdC3y8bQ
         ZszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yIrLJye4LIMMKtlWve4XIDka1yAeTmnoEHAXUYA796w=;
        b=k492vmRcCQahcdtGn2t4unPkHAMFFCQUW9NA9hyLJKUM/hEL8CxjSrT+7DWnyZfWJr
         AEr5t7sf0rOBTqG/LTkhNTg5KXMG8vw3Lh6Jrhd7d3jxEIG3cTsi+JjTPfLNSi24koXE
         fup+LK9X4Tpx+j7jsLEgnwjWRhi4cP0l9xjVNl/Yw06GScr+gf2Iz8PHFID7EbgZsi33
         D+Hb00MT1jGF858A5D4hv48JYgDnf0SfObVUw8tkXR8OOgObnbyTQsBRcYpp/GjJmRUd
         CpGE7YZmHmQe4MzM5gr6qvFC+kJXt0jSpe5rSa8S+KHzIF8VvWyk218Plo6F32gY4+0o
         I26Q==
X-Gm-Message-State: AOAM532cIdVUwQbgb6P5bUyGwF1jJwOAAQGyIV3J6Zp44IYl7I/oRvNe
        Y1IWliMqP1T06pMuhY8F9uodh4Rr674=
X-Google-Smtp-Source: ABdhPJwFC/KERkBR+ej4Fcp9kxKdvizfPt3OzwVSTr1XDKndKXX8+TJatWpk7nOh5f6xevi8lbUhLA==
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr11992340ejs.31.1632500132903;
        Fri, 24 Sep 2021 09:15:32 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id jl12sm5206401ejc.120.2021.09.24.09.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:15:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH] io_uring: kill extra checks in io_write()
Date:   Fri, 24 Sep 2021 17:14:48 +0100
Message-Id: <5b33e61034748ef1022766efc0fb8854cfcf749c.1632500058.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't retry short writes and so we would never get to async setup in
io_write() in that case. Thus ret2 > 0 is always false and
iov_iter_advance() is never used. Apparently, the same is found by
Coverity, which complains on the code.

Reported-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7bfd2d00d4fc..d7888bb78cbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3604,7 +3604,6 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_save_state(iter, state);
 	}
 	req->result = iov_iter_count(iter);
-	ret2 = 0;
 
 	/* Ensure we clear previously set non-block flag */
 	if (!force_nonblock)
@@ -3669,8 +3668,6 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 copy_iov:
 		iov_iter_restore(iter, state);
-		if (ret2 > 0)
-			iov_iter_advance(iter, ret2);
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		return ret ?: -EAGAIN;
 	}
-- 
2.33.0

