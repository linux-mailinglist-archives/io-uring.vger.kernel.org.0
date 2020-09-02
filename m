Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A28425B085
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 18:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBQAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 12:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIBQAK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 12:00:10 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4734DC061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 09:00:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g128so6284063iof.11
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 09:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/tr1EYk/aFypni+yEWSPlprtJrpH/gPhca1JBVaroyo=;
        b=zSiKKSpeoaO0o+X5qCkfYMkIYL6dXt+jcbJJgEuW80OcrLs+WSIK9Zj0FXZnUmlWvq
         CAv7RZaU8TGM4gNtNousk0qw+GVBok4UzwQ6WaLQG1U2j958xO0nWczVhR6OwMM7xoJQ
         NW6FIyEmlLbHTovHrBAQ60m1JUy8ImEWddwQBysrjVHt+DIUo9b6SepIiR1AWIhsGzzL
         zbzNhgqjp4t904HOdC9PLlYR+IrRI2lyCPLslHLb9ZQjwkrknoq6KS2PmkpdJa+DfdKQ
         QwDnDpE8bI1dLFLoGjhzOMeNsm2MQLedcW/PmoJaIvmfIZhyaxbe3KMUXhkRop1dCHxn
         SSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/tr1EYk/aFypni+yEWSPlprtJrpH/gPhca1JBVaroyo=;
        b=HhKxxC+TmUo5rjrSpq5bTIfGjrRGbPgs9aAk6ybiearnsdXq0lqnARJAxbVIGGU9cR
         I4INFaQ0PyoGYDaN43Nx7dk0z/6p2mBm4/3pm4t9ivFawPxciKGURGFGOkEkCNsVgRmj
         A4Ee6wxq57wM3HxpzB4s4OZvXZZedvZseDsbNENF1mGhReI2aTp81iSr8K8//k53VyK9
         ytQ6K5WOr6vUDSTSSRYAATZWMgE+1SFAEh5aOHLuYYJ9CCg658+bBfRbxLNHcqvO3mBE
         9kuLyPISmKGTWaf2PuP61tuYdJPMEcXRPRoAjetTJrnhnCgH5F3o20vqMtUj9EY7yDp0
         ewOw==
X-Gm-Message-State: AOAM532aDC+URQSj587EtH40gq2rBsAFlGS+81NfwaEJ5f0fZjtPEL6m
        qWFLJxQge3yFARqSOgyzszrhhA==
X-Google-Smtp-Source: ABdhPJx1V0yTy/taGhnd0APHvqE/TFM3+iIeRzA29vaJx+qr0n8vjY2LEwKW7KBWGlAYC2/E58yI0w==
X-Received: by 2002:a05:6638:134b:: with SMTP id u11mr3930558jad.18.1599062409575;
        Wed, 02 Sep 2020 09:00:09 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c16sm2498958ila.29.2020.09.02.09.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 09:00:09 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Norman Maurer <norman.maurer@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: no read-retry on -EAGAIN error and O_NONBLOCK
 marked file
Message-ID: <5d91a8ea-5748-803a-d2dc-ef21fe27e39e@kernel.dk>
Date:   Wed, 2 Sep 2020 10:00:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

    Actually two things that need fixing up here:
    
    - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
      regular files, so don't ever attempt to do that on other types of
      files.
    
    - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
      it. It should just complete with -EAGAIN.
    
    Cc: stable@vger.kernel.org
    Reported-by: Norman Maurer <norman.maurer@googlemail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b1ccd7072d93..65656102bbeb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2300,8 +2300,11 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 static bool io_rw_reissue(struct io_kiocb *req, long res)
 {
 #ifdef CONFIG_BLOCK
+	umode_t mode = file_inode(req->file)->i_mode;
 	int ret;
 
+	if (!S_ISBLK(mode) && !S_ISREG(mode))
+		return false;
 	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
 		return false;
 
@@ -3146,6 +3149,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
+		/* no retry on NONBLOCK marked file */
+		if (req->file->f_flags & O_NONBLOCK)
+			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
@@ -3291,8 +3297,12 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		/* IOPOLL retry should happen for io-wq threads */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
 			goto copy_iov;
+done:
 		kiocb_done(kiocb, ret2, cs);
 	} else {
+		/* no retry on NONBLOCK marked file */
+		if (req->file->f_flags & O_NONBLOCK)
+			goto done;
 copy_iov:
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, iov_count - iov_iter_count(iter));

-- 
Jens Axboe

