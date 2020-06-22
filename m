Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D736F204364
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 00:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgFVWSR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 18:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbgFVWSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 18:18:17 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5F3C061795;
        Mon, 22 Jun 2020 15:18:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so5556909ejg.12;
        Mon, 22 Jun 2020 15:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PwAx1lggtUloHQ28uvRcmSf+olc6Ik90k7hCHmYJ3ho=;
        b=ZXpzppos7OZlEpux/3v4UWDRb0ziwyUSApLeRXMpKtutWUdSDqChibzHOvqHagtNzg
         OXR5T8dszPKTmwKXCTpzV5exzxDpPADPkrEZ7XpbtEoiWwAIh/BUPsOustEhE2fuFU7k
         cC6o2i0B9owU6IS1q0pnpGni5wvgyz4+mvrKZO40IHFuiLL5fb5KTT/7Ao++o0fqTvsk
         aOpRpFpslPs7AQZojD+iyLBEUovwzZzs/qub8phG3rjfev47J3aRxOw+fP8lHRCt1N1S
         RIUD1FpmYKgZ49TOSiBDK6h9dYeTo80DUoktIzGaZ2diotAngv218FitzvKqRue1lAkp
         i0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PwAx1lggtUloHQ28uvRcmSf+olc6Ik90k7hCHmYJ3ho=;
        b=I3mLwZscpzRq27xZ4mfp0xpU0TUZRsYofi4Laaxgnp0u8Rw4U6FvFpWF6XXfnDHhe/
         IHlHHqLsPYAsyUW2ioag13ZwUWxieQTu/csHQiqOEPs6pzis+WMIcVQyuNOC2E9xJ4Vs
         Ao+tI/zgDGIvWFkJQWFeRLTULeAcV7OO2lsGvUqUmZ53PMu4K6oVK42mLuIEZvSKNpce
         1sDmfsN9Sxc8kSfOO+6MPHmezyeLvzkiMz26aokf9ZL8xNR2dAmAgI9M2LhTSRCwjJPX
         jMtgdPTRI6PTtNWCkkRKmVj/RW9TNXWKNnYHBdYjNGs6soKrAtmJ7iNArKbt/DeDRkT9
         og1g==
X-Gm-Message-State: AOAM532R8x7pf2KsE6bAuvQwVHu7ch5QoePeIWHOf66XFuWdsuHl31Jf
        txm9vBaNgwlHlN5gyzAc+Mw=
X-Google-Smtp-Source: ABdhPJz4OqTwguCg/23SeF4gHF119hDp+QcGN0MM8yc/8R0AAA6Zz8YmlFaMMAJclkiUDmDj+VqYFw==
X-Received: by 2002:a17:907:35c2:: with SMTP id ap2mr16642972ejc.530.1592864295389;
        Mon, 22 Jun 2020 15:18:15 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id dm1sm13314421ejc.99.2020.06.22.15.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:18:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] io_uring: fix hanging iopoll in case of -EAGAIN
Date:   Tue, 23 Jun 2020 01:16:32 +0300
Message-Id: <0301f35644823a01cbae87e440df7d58ebcf2279.1592863245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592863245.git.asml.silence@gmail.com>
References: <cover.1592863245.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_do_iopoll() won't do anything with a request unless
req->iopoll_completed is set. So io_complete_rw_iopoll() has to set
it, otherwise io_do_iopoll() will poll a file again and again even
though the request of interest was completed long ago.

Fixes: bbde017a32b3 ("io_uring: add memory barrier to synchronize
io_kiocb's result and iopoll_completed")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c686061c3762..bb0dfc450db5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2104,10 +2104,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 
 	WRITE_ONCE(req->result, res);
 	/* order with io_poll_complete() checking ->result */
-	if (res != -EAGAIN) {
-		smp_wmb();
-		WRITE_ONCE(req->iopoll_completed, 1);
-	}
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
 }
 
 /*
-- 
2.24.0

