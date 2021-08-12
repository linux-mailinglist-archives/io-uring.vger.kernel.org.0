Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F223EABF2
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhHLUly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 16:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbhHLUlw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 16:41:52 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF66CC061756;
        Thu, 12 Aug 2021 13:41:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h13so10118604wrp.1;
        Thu, 12 Aug 2021 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x+4wra4HxuvSp6gGCVI1S4IbawlslKqdZS2ju2uJ+hk=;
        b=LHGWUkJUpVtjhaiEk37iYzAEd9zziNA3WqigZAE51lKca3jNcVxuMgP1tL0JGPQIXb
         Bv02tbN31x2uo7j0E70zwlI6vatsphcveZYsWP0PVSpWvoxdpvmdRbPSytmH2mxuyPbU
         hkXc607bnncaJN6q+l0gr0u8CCpZnvF9fMDpZQM6I58T5MdGM9mmxQKn4r9NkO66wSYl
         BiypWMTkuGTsxjv7Q9qxUVCwRdxFXPnKX62474268P6jg+utQEOAgN7onnp7HLunGfO0
         jrJzIWN515Oz0wiotty1qjts+kTHs3JW0YtwsiU06yRd7V4Na7ff/DUOtcDwEBeaMtQh
         DwEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+4wra4HxuvSp6gGCVI1S4IbawlslKqdZS2ju2uJ+hk=;
        b=dCKJstYpjM5KTqtOdgSj2fi31EyH7F8FU2dShpmGGqSl4eWuWQ2bJPeiAWs1O8orkU
         6YeD3yhzocQvObBLDSdrDgp5meXxxgOf0dWOmDJ6RVBGYnzMQXKfK9IrnOPCZOOka0c9
         YYyC+rUo3FUHZi0OIO/B+Zc5VbDDGQiWcjz2qIGeOOwaRwXbqc7LYlYfRhKR9p6Eqp4/
         tpXTDKScbEu1Gsjjsm22UbuAu8rRq0HpyxFEWD3EF7+i4Th4l9lJo4BVMi6xiWoQuWBM
         2VYtOiCBhEBKWps4R9eo/R1yLLdo2auFbLYwFLxiEgnfN9Erh2TqnIwZPewPRdyv3A1E
         5v+A==
X-Gm-Message-State: AOAM531bxy4614mtWbJTzpeZuKg6ok0AMAKAUzHSu0NUzs3cnrXSpOcm
        EIY7fW4EplWUh3yek89SGZI=
X-Google-Smtp-Source: ABdhPJxoCiH1MoibKlzSKj9dla+PVvUKmjz9i6At57JMqdZxy8YE5Wyg3TGnSlTmEPCUBf2ZaJp1UA==
X-Received: by 2002:a5d:5650:: with SMTP id j16mr6112218wrw.46.1628800885666;
        Thu, 12 Aug 2021 13:41:25 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id i10sm10296556wmq.21.2021.08.12.13.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 13:41:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com,
        asml.silence@gmail.com
Subject: [PATCH v2 1/2] iov_iter: mark truncated iters
Date:   Thu, 12 Aug 2021 21:40:46 +0100
Message-Id: <69fd298bc71bb80ac5a639e10890a5b7175e566c.1628780390.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628780390.git.asml.silence@gmail.com>
References: <cover.1628780390.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Track if an iterator has ever been truncated. This will be used to
mitigate revert-truncate problems.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/uio.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 82c3c3e819e0..61b8d312d13a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -30,6 +30,7 @@ enum iter_type {
 struct iov_iter {
 	u8 iter_type;
 	bool data_source;
+	bool truncated;
 	size_t iov_offset;
 	size_t count;
 	union {
@@ -254,8 +255,10 @@ static inline void iov_iter_truncate(struct iov_iter *i, u64 count)
 	 * conversion in assignement is by definition greater than all
 	 * values of size_t, including old i->count.
 	 */
-	if (i->count > count)
+	if (i->count > count) {
 		i->count = count;
+		i->truncated = true;
+	}
 }
 
 /*
-- 
2.32.0

