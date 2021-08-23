Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9487E3F4881
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 12:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbhHWKUI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 06:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbhHWKUI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 06:20:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85609C061575;
        Mon, 23 Aug 2021 03:19:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so10402501wma.0;
        Mon, 23 Aug 2021 03:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDiJYxU2rXMrARIirE9/AIZInNgjuohln3iFhjV1wKk=;
        b=JOhpOjbqTyovV7amn4TL+yrLHSFr7Ujrfnn+ts3IT19pZkMQagG7X1b9XFfi4SwqQQ
         U69muqovWRQ44U0kP6+goe/jPwf6F7KTNTvfynpdRJwttRkCdhmlp3aRhpK7lJz6Zk2S
         1BI6ZAlarzqsW5X9XYceUyQQn61WyWyPujmiDznTeSTN91QewnUCAnhLIqV5Z+S9hHUK
         GhCL2laEw9hGAjUxow2NqrGOlqebAvqVru9kdxAFns4B3I8e45UKA+C4A/y383lbRkif
         YchLhf+EMZqKJstu6V7i3rIo2bl3Xdcy/ig82XPUt+d0wT36XAuXYw3ja9ndJqaPienF
         oXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDiJYxU2rXMrARIirE9/AIZInNgjuohln3iFhjV1wKk=;
        b=aGPfuM5hEU20l8b65In4qs461SA+uBelkhuTSkLxmUKPqiZL5AvDtfsgFE0GSfk4Xe
         Ntn+XBA0EGsT4VISEvog9c4hx30zanCL3/98G2czKWshaJa3LfAXDazQuqiH0QPNDsOg
         4m9aiXJqsSq8YO4wWLfK+G2wWaOsVB4732+JVPLkOpLBAwBBL3GxEPI/leCPmV2UU4fr
         46ri9JROqREtfvSuLuU/heqj3fen92lmQK8y7EEz5Tm2yxAWpXWWQkgTQthhUJgWTahh
         WaKLmn0Wl1YiTEMfCG6S9L9QCels7LlTC+l8NBml1G9GtN0kK6W6rmG0kbsPYgpPzEDb
         sWEw==
X-Gm-Message-State: AOAM533tykQsclM8EUe3EMfXOrLHn8pRuDk0grm+x1GM2xk3LR3lPLEd
        25Ah7/VlMQMX+y+cFD+r+j0=
X-Google-Smtp-Source: ABdhPJzCx944HYrvfn8pzEaFUBf2F/lrhPIvpPjudMJSv4IIEBNTTYmW/0xmcwqL+88x7A6DdQtdaA==
X-Received: by 2002:a7b:c4cb:: with SMTP id g11mr5697941wmk.80.1629713964222;
        Mon, 23 Aug 2021 03:19:24 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id l18sm20539922wmc.30.2021.08.23.03.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:19:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com,
        asml.silence@gmail.com
Subject: [PATCH v3 1/2] iov_iter: track truncated size
Date:   Mon, 23 Aug 2021 11:18:44 +0100
Message-Id: <8feaacf52887a91e7c52d60d7805af08f22dd07c.1629713020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629713020.git.asml.silence@gmail.com>
References: <cover.1629713020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remember how many bytes were truncated and reverted back. Because
not reexpanded iterators don't always work well with reverting, we may
need to know that to reexpand ourselves when needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/uio.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..5265024e8b90 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -47,6 +47,7 @@ struct iov_iter {
 		};
 		loff_t xarray_start;
 	};
+	size_t truncated;
 };
 
 static inline enum iter_type iov_iter_type(const struct iov_iter *i)
@@ -254,8 +255,10 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count)
+	if (i->count > count) {
+		i->truncated += i->count - count;
 		i->count = count;
+	}
 }
 
 /*
@@ -264,6 +267,7 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
  */
 static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 {
+	i->truncated -= count - i->count;
 	i->count = count;
 }
 
-- 
2.32.0

