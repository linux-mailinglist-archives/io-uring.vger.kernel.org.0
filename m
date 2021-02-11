Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0A319662
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBKXMx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhBKXMw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:12:52 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23432C0613D6
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:12 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id 7so5886553wrz.0
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3tPmssEfOuJHJnTdOYJ46w4gxZbEJQd/9lMMjr+YY3U=;
        b=epIX+mS+rS2wBINF4s/f+k4xMqKguO7E6zmvwco50iaSeNRw4CngP0UjBLFy0GdgCp
         7BHUk6PWBP4u1b273NF1l+zLa1dSACoBZpFDq7ZnNkMrI8mokT4BiGPUHnX/VG693qzi
         v/vpMeMT5XoRh/EpAWPRCPkZTI33cSDohqr/WbrKgdNSHas4Qg8oFmTWBlX22NeBJIgS
         6m1T0KLeffnxoQVbjRgv5q6HI2odOvPnWNlkxbWBwLEBRhGBgIHdRIw3DIvEyRV4DvWt
         OpZuJ69NJ2G3vRt6FWPnuir7y4ew9iLyEvHWoYlkroV4vhNFPuB1NhYzm+0YIb7m7FMk
         Vweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tPmssEfOuJHJnTdOYJ46w4gxZbEJQd/9lMMjr+YY3U=;
        b=b6a1CR8YTOyuk7eHPeSs0TBbDCOyKC5uO+3tah0S1pIVe86ddkNVZD3Z0vVMbRlyiC
         YFEhd6goTDionRN63kiKYI0MJ4x03FUfxXi5lateWRsvse6D8ujUR+DszrQnrPpOOYxV
         sXUuzVEYnZ+gXcY0LGcFGiA/DGRH1T9fIwzJZwAy/OsDYcMlhDilxYYWP4q/OdCqq0Mg
         lU2TQPhYOqQtLBGg/r3U4jhbcRMe5sV6uU38rQR3nTERMqZEkMUr9WgIm3fkDGwdmqbM
         XmkegJyyJ43rNEkA6fubHUA9TZDIWBsPtzo9on1KCe4bXKP0EyM5agSmkAJL3Cxmove+
         96EA==
X-Gm-Message-State: AOAM532ZphY3ukvfm45eTog27n1pmCGBDrCJO3pRDVP4jHlDe3FysE5W
        Qut4smhSGGuKDZ94ZNLTKsA=
X-Google-Smtp-Source: ABdhPJz3iU+7EcQds2n9k+3+2KPD2c7ULiWRripC+H+oz9N2+OPnJU6S2/ztKOxkxwdRQWsMuRDH/g==
X-Received: by 2002:a05:6000:c7:: with SMTP id q7mr131912wrx.364.1613085130781;
        Thu, 11 Feb 2021 15:12:10 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d9sm7271184wrq.74.2021.02.11.15.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:12:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/5] src/queue: control kernel enter with a var
Date:   Thu, 11 Feb 2021 23:08:13 +0000
Message-Id: <0ce4c042da621e8f305ad8063e548192ffbea7a0.1613084222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613084222.git.asml.silence@gmail.com>
References: <cover.1613084222.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We check twice for all entering conditions in _io_uring_get_cqe(), first
to set flags, and the second to potentially break the loop. Save it into
a need_enter var.

Also, don't set IORING_ENTER_GETEVENTS when there is already enough of
events in the CQ.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index c2facfd..4fb4ea7 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -92,6 +92,7 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 	int err;
 
 	do {
+		bool need_enter = false;
 		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 		unsigned nr_available;
@@ -107,12 +108,15 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 			}
 			cq_overflow_flush = true;
 		}
-		if (data->wait_nr || cq_overflow_flush)
+		if (data->wait_nr > nr_available || cq_overflow_flush) {
 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
-		if (data->submit)
+			need_enter = true;
+		}
+		if (data->submit) {
 			sq_ring_needs_enter(ring, &flags);
-		if (data->wait_nr <= nr_available && !data->submit &&
-		    !cq_overflow_flush)
+			need_enter = true;
+		}
+		if (!need_enter)
 			break;
 
 		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
-- 
2.24.0

