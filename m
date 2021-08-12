Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572153EA7CC
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhHLPmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbhHLPmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:19 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570B4C0617A8
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:54 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id be20so10948751oib.8
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LEnopQL4PHusgBDS3f+zKlQOKB9hsKjgx1LSo73cC14=;
        b=jPHTzAiTHc6FoNV++PtWwTTZ7W0ltfV924DY4oBUi4/BbGIr159yPRx/mDJpIKoA8+
         nsZjIHxaD0PBYr11WBs92pL3U8hSE7WeNOnCT97KpAZRVQD3eG8Fd6+DZOebn5Rv74jj
         f0BfuuGsugOprSHQxTWmfoS8tJ4a3apiLlIPiBOlnpZ8nOWIJ9JPqBrQDFuEfTuJCi+f
         rpbWbHxrJQBnCuqkUqQYWhIkh5lmLyYEqvRDX1MLAjASwM6yP3YKUzXAPW7ztEPK/UpL
         PfUaaudJspIaDMWOK3bKtN5pnTa0YBer89Z9UZFhVCxek5baCpCY69/eGKq1qcmxnMfL
         0Zzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LEnopQL4PHusgBDS3f+zKlQOKB9hsKjgx1LSo73cC14=;
        b=jySNT3BwE+Skx39w8c2MO1m4Udd1qUCQ/EnJFcaq1XO+oq6qY+IwgeB4YnFyO0TTA3
         FoZJNRmQeh1u7Gzn9gPs5i53ksWMGcaQuG/sjeMWuG1e7gcSJlJb0W2Q3eVBRv2xCe3d
         yzFVNLBf9oSBp8Ggp8/rFu8GepMR4tL9+Y17/tPsRS05ik9e5wKQXqSPsL1uIxGhDWbO
         56gCVkLsS/n1HevMJAFZQjqm6zKIfcDkPaZoBqtcKXParbxcSFe5etAuYJuq0VGjybRX
         5id+gS7G2944NQYxEvzyTj/24KxJp++sU06asXGcCPd1LFXNx/8Hbhj32YXlm6hbNxfl
         aqww==
X-Gm-Message-State: AOAM533XamlpCaHjmeih+sMoPOIifFcxsQWfci3H3a9B4nE7QEvCBbqO
        R5ZRXhbfYxUs65CY4KykKyEE9GogrLxQI22D
X-Google-Smtp-Source: ABdhPJy6tTDQsmMyTtSwAxGdAXZ4oMRMLnqItaww2JbeqGfzhj0BjF5Z3TZJVYZhpmbVBeBlhvnXww==
X-Received: by 2002:a05:6808:2084:: with SMTP id s4mr3827632oiw.167.1628782913507;
        Thu, 12 Aug 2021 08:41:53 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] fs: add kiocb alloc cache flag
Date:   Thu, 12 Aug 2021 09:41:45 -0600
Message-Id: <20210812154149.1061502-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812154149.1061502-1-axboe@kernel.dk>
References: <20210812154149.1061502-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this kiocb can safely use the polled bio allocation cache, then this
flag must be set. Generally this can be set for polled IO, where we will
not see IRQ completions of the request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 640574294216..0dcc5de779c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -319,6 +319,8 @@ enum rw_hint {
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
 #define IOCB_NOIO		(1 << 20)
+/* can use bio alloc cache */
+#define IOCB_ALLOC_CACHE	(1 << 21)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.32.0

