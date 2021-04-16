Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51513362537
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhDPQKs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbhDPQKs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 12:10:48 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D643FC061756
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:22 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c18so23509469iln.7
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IXXAjkuMBD7sinLZEPF9Yc+buWxunNaqHDvicBbBdhM=;
        b=dkHQsn5b9z+bIUXGwGUBvHecCBFrOfsimc+u+AFCFtGvQG+C/EuvNVZjG0nI9sMoX8
         AoAHVbj+ydCnOEBsKUvkl9ImSVOVIP4Lrz108uy9jaF3AflaVecR9tu3eqaAFMIOLd3T
         5xS0bOQIbXizSEb8JBZy5tTBxuBQrK1L12oWO8kyUPIIAdM1w5kXM8R+zhP5HVS6XOMj
         sOV8vhSma6f+POPlRRWfOnyg2linK/be/XFp59l8JXfKdr+keFqd2ncbd1tUdW+pQYKN
         3QUkI7d/mneNDJrq4Ae2MiqGfLauta7NcMcrzw/pXDlAJIfmLlhhB6n//v56ZqYbKlT0
         lCdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXXAjkuMBD7sinLZEPF9Yc+buWxunNaqHDvicBbBdhM=;
        b=UFv4ki7WXv2CBJACk6/Wb7kLrPaY01LeIyHWQiigesFx39w9uJJzGCTSPJq+F+wp0/
         ZVzp/dFpYdOXIohmgp7NtCiLKnYd/HEwlLB5WFXhNCzgoQZdhvInLd6zZW0AkdPcqdX8
         4TMp7iFwuA/6Xr/9aUwx/NQtZWozvgN6CLkxHSLLvU0bMpZdwek0xeunxIpfTiS1JHVC
         5H5CIbrtGpaxbjYD+LI0Aax4W1gnyhWAJwrbyP6C6Vwx+RFb9Y1Z7IgFS0XBitqM7n73
         R2QLB5zFmQ8aorf6Tol7M6ZaUaA5wlcdS219KbZqfhKOspCIe3JtXPl1al2wBQKjTPE8
         LQ4w==
X-Gm-Message-State: AOAM533fvzrguFQ3iMuDCJgRvVEt2+kz69AL66kzkzhO+wvRk1Ui9tx1
        NZkAc6h2fDUDcg+I3UdV17Hl7g3K7pmLyw==
X-Google-Smtp-Source: ABdhPJyDaTT8qTVkvxy4+Wl5+VZORfaLmR3A+5LE3Of9d6i0XKPQKJ3Ecgv8dyGjAC2y18dwQrP8EA==
X-Received: by 2002:a92:5214:: with SMTP id g20mr7669262ilb.219.1618589421968;
        Fri, 16 Apr 2021 09:10:21 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f13sm3024641ila.62.2021.04.16.09.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 09:10:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: disable multishot poll for double poll add cases
Date:   Fri, 16 Apr 2021 10:10:16 -0600
Message-Id: <20210416161018.879915-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416161018.879915-1-axboe@kernel.dk>
References: <20210416161018.879915-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The re-add handling isn't correct for the multi wait case, so let's
just disable it for now explicitly until we can get that sorted out. This
just turns it into a one-shot request. Since we pass back whether or not
a poll request terminates in multishot mode on completion, this should
not break properly behaving applications that check for IORING_CQE_F_MORE
on completion.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ab14692b05b4..4803e31e9301 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4976,6 +4976,12 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -EINVAL;
 			return;
 		}
+		/*
+		 * Can't handle multishot for double wait for now, turn it
+		 * into one-shot mode.
+		 */
+		if (!(req->poll.events & EPOLLONESHOT))
+			req->poll.events |= EPOLLONESHOT;
 		/* double add on the same waitqueue head, ignore */
 		if (poll->head == head)
 			return;
-- 
2.31.1

