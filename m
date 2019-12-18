Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94D0124EEF
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfLRRSu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:50 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35821 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:50 -0500
Received: by mail-io1-f67.google.com with SMTP id v18so2793859iol.2
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMAvgjhUpoSPFP8Ns1lMID7Cm2BKXyuelc+voyM2YIk=;
        b=r/VJf4C9Wr3OfSaD9kAxlnCeCSQP9sHcQdbUpk8ubT72nEhDWa4Q/Qiq1sdIaqnqXV
         3bAC3BdKBY7MTi/7RPTCs7JYW2x8vCd3aE59RWWDHFgnNcv/LJbVduzXy0oWQrJpr6iL
         hILyRVB5CO+q7mCYtt7hmVbiArG4KJSUqTq+zO4rby5th/5wDk2cWgMKrVXjpdVq4obH
         8jaQrKTzeWb4MWI6+vQ2J3WJE70Ts4WOM+WLmmp5qIQhvFSGnfnSGvayq58RSo4iPPqN
         UjywpYkK5Gp28l7hGSkj/LnmhBlhhVfakunJ7SZNLTSXG/d0RBQl40XaQXGxyAzoH64r
         1RKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMAvgjhUpoSPFP8Ns1lMID7Cm2BKXyuelc+voyM2YIk=;
        b=BZ/ooeBjyQNYAF3LeKXdJe2aYAbX2wj7cpnw0L1p5Qi2lPoR3rMq+kxygBTKguafBy
         Ayn682Yg7QdBYhEXBzLMaVPbmRpOwzay+Ht8NGP7p4+WM/3QzmQnGsE4mipyxrepuDZ/
         RieybvKGJdEE9MOPhvYzxc2TiF4O2m0GiEhLSYYMA+hZ82WucFDOdqPOiPMzV6dSQIjl
         ble59AFJ6w1hvLKmpgbal2ESqVUhNDsLRWGOotdI10DeTZVMkpsffEVe9CtYY0/89itJ
         6DElVFxown75fjnSbBMuuFgD6Gzp0zLTzTiK12Dm32FN7ox+JzJPfP7+xi614dKqpaPr
         OHug==
X-Gm-Message-State: APjAAAXgLGQGvlsjugCHYm8/PxS6BiqFl35iMGsHGm4SJPcLrpbvLFL8
        VEdTgF6NVc8OOfxHGikUJ9SVDzPU+0c7oQ==
X-Google-Smtp-Source: APXvYqzIOQYhJk5Yapc5On3AtaNAO7u3b592hc8qae9ugzf6EMAsRJw+z3eUhEKaQ7dIk7H7Mr2OiQ==
X-Received: by 2002:a5d:8498:: with SMTP id t24mr2503973iom.164.1576689529419;
        Wed, 18 Dec 2019 09:18:49 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/13] io_uring: make HARDLINK imply LINK
Date:   Wed, 18 Dec 2019 10:18:29 -0700
Message-Id: <20191218171835.13315-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
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
index f4e95538f945..12cc641eb833 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3696,7 +3696,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
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

