Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EEE123DED
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfLRD2L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:11 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33154 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLRD2K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id c13so336100pls.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQQHeiahJGxXZFpEK4NpFB8mvaB49zMV/ubA6V5Cag4=;
        b=RA3SX5v3VMmXMzS5G99KqxRDBPW1gPRaBmW8ef0mQq84uUHf5JkWMZN5hVdQIxkLa7
         4NDxijDmswYzbOQFyuufmiawxl/qkqSGDkJuDBuT8AFhpl2ohcy6WF91YOMvOvMlReuY
         6m/cSS0sXylTdD4/yG4+mZQ14lUKcx3GVSI83XrXjJ+cLzlkbcTGJ0fDjvCZhlkuQegH
         uvPctuPqydFI2cdLB9rA0AYyrCL1zbYtbUwz7Lz/IZnP1oXc41EhuOGwQnUolDA/IEG6
         QsdZRUMpzkbjm4XwkoIsNKPcNU7jwq8hP8ELrhgV0rapUUzkTdovPtcp3vNWaN5gbFH6
         Zs6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQQHeiahJGxXZFpEK4NpFB8mvaB49zMV/ubA6V5Cag4=;
        b=Rpq4Pf56ygrBqobhB6BIjyPilSW/72w5CTcOcwBNQdrmufazzBUMiJOTtNdxCrQTmS
         q/R1+llEBay/fPVEWBqXIVav60mRd52tHIYLfmvHQgjioMMIjyBwTD2maQR4Bd4+oA/h
         Om/K5TSig9ulwdNJZ1PW6lAsXkln6MM3gcLYlABsd4fLj5CVtngTBQCre5HB0ZmEpBbY
         0L6lhW/nL6nUFcxZTWUDFJkWkIn54WxOuoiQlbMWNXjKP+CqbXfQVRD9pX0jf5KBABh7
         jdH8nXt+hmE+r7kANzJYsZNfdiwl2wCFkgoJLm4TpWxInTHxh130fLcFbEdS3d7oXV5j
         cvWg==
X-Gm-Message-State: APjAAAU9zB02DDhG9JsvYDTfwbxQ27XBUSn0STeCVHLahvF/L0zYEV3+
        vn+563lT2Rldrtbf+g1/ieQhB9fuoWKc0w==
X-Google-Smtp-Source: APXvYqxLXSyJKR3V/vaODX/gPqCJx4aJ7w2EqFSkex3HseGG+NI29ZSG4sxCeAXUR69O4OFTSZULMA==
X-Received: by 2002:a17:902:74c5:: with SMTP id f5mr41270plt.229.1576639689765;
        Tue, 17 Dec 2019 19:28:09 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/11] io_uring: make HARDLINK imply LINK
Date:   Tue, 17 Dec 2019 20:27:54 -0700
Message-Id: <20191218032759.13587-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

The rules are as follows, if IOSQE_IO_HARDLINK is specified, then it's a
link and there is no need to set IOSQE_IO_LINK separately, though it
could be there. Add proper check and ensure that IOSQE_IO_HARDLINK
implies IOSQE_IO_LINK.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb77242be078..c8d741dd70dd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3693,7 +3693,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		 * If previous wasn't linked and we have a linked command,
 		 * that's the end of the chain. Submit the previous link.
 		 */
-		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
+		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) && link) {
 			io_queue_link_head(link);
 			link = NULL;
 		}
-- 
2.24.1

