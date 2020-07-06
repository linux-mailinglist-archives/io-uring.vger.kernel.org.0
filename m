Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAA1215A2D
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgGFPBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 11:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbgGFPBY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 11:01:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3809C061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 08:01:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so39755223wmh.4
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 08:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XSM+wNbUpBErdeGCpkm3vYzq+wancK5WjdL49sdHWdo=;
        b=tGhGdPDHDLdNw7yl+lj2s34C3SSYRBR/SXB16PSuUegpxuctKgX4npkX4JUe1kMw5E
         vbV+jIk4cK2qKuBgeG5VN8PdJV1D+/L1pBwiwNajbgvt0BzfP3j5jYjiOqPSz40kOyzE
         tn7yzSwbHkFm2EcYvhcYZogAtuWIBaH1wL9Tdv8u5dvxM/IIqY/8w/Vv6pXivLdQtQip
         l9ywHLl1kKTRJKwucqwfPYHousD5wgE4kYCRGP04NAHzFX7H8BGQyx38aZLMqCzGCSlY
         7hxihgxEcOlkHWC4OzdPEohYB5Jpmw0UqlnmJWlrO/kdKF4EfoW5pfF51eSb59IWMrzr
         6Ksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSM+wNbUpBErdeGCpkm3vYzq+wancK5WjdL49sdHWdo=;
        b=J0nhuZMnwZ8C2BMO4KTtM4R6lT3kJ+JVL04rHXloaWEJnX1BjB3EWz/mAtGYxLSDov
         SPvsppklZS496K4lQ/f75ZFqX91Fiu0I4QkMKZ/rogJF3YlcQDEJQxI/aELTHbBwlkOv
         GTfcgMiRXQsW95aLb4FMP6W5/fq7iMrau0KFmcCHxZu0LyYwQ0QORKW+u8SjFrucQMYZ
         l9R0h2M6yDkJWOOuhf+5ifPzGnG33+shJYJceUzzsdkebumr1MTyID+vKf+EyHMy9tI9
         00siMa5yjwQD23EtFGYkaUfC32yXAGzS2XE6q153G2tudzgu89T+Qt2kVq5JDNOhovku
         4X4g==
X-Gm-Message-State: AOAM5313+SNJa7LhjZeU65OLhXHYqdLr9KmgseOK8Ic5Lph+EOXKxO8J
        cJjw7GIjs+gIz4khOnrTUH4=
X-Google-Smtp-Source: ABdhPJwCEgoqVNMbe9ThvPhoGKNKQYH8hqCNGeVDlLGlE+C30PO/YZIi9AsHK/R1D4nmCxuwYQVQ3g==
X-Received: by 2002:a1c:2905:: with SMTP id p5mr38231613wmp.91.1594047682483;
        Mon, 06 Jul 2020 08:01:22 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id k18sm15626168wrx.34.2020.07.06.08.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:01:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/3] io_uring: don't delay iopoll'ed req completion
Date:   Mon,  6 Jul 2020 17:59:29 +0300
Message-Id: <b10180e4f58ab85a2b32a61a71fbbfab72344b18.1594047465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594047465.git.asml.silence@gmail.com>
References: <cover.1594047465.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->iopoll() may have completed current request, but instead of reaping
it, io_do_iopoll() just continues with the next request in the list.
As a result it can leave just polled and completed request in the list
up until next syscall. Even outer loop in io_iopoll_getevents() doesn't
help the situation.

E.g. poll_list: req0 -> req1
If req0->iopoll() completed both requests, and @min<=1,
then @req0 will be left behind.

Check whether a req was completed after ->iopoll().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a2459504b371..50f9260eea9b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2008,6 +2008,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (ret < 0)
 			break;
 
+		/* iopoll may have completed current req */
+		if (READ_ONCE(req->iopoll_completed))
+			list_move_tail(&req->list, &done);
+
 		if (ret && spin)
 			spin = false;
 		ret = 0;
-- 
2.24.0

