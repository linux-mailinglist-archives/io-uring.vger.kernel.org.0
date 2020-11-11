Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E752AF77B
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 18:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgKKRly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 12:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgKKRlx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 12:41:53 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614EBC0613D1
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 09:41:53 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id p7so3125864ioo.6
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 09:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bWSzRLi7HvyeJivJF548h6thb9TOqOcyRYDbIel8CSQ=;
        b=mczFoVUo2H4N5+3qiQyr30GccS8BhBzDLa9U4PvfyJzvDo2R2BQfHesbG9eqaPpS8b
         QhGsKgCue+zv2ll/DE5+FoxQf1HO14cof5KKTz3qQ0ExbovNhVNaSyxzIA2UEov5NUlV
         0uB33PhOrUM/54LzF7Qnzl55ROFMC9gS7e7QdgQpgW7FmGEwNGa1dtKQxRPS7eh9OJZu
         MVFEE3LIL7Jeh1zUrA0xIhipqY0EvTMDO8SkG0AX/1yVzXr1Llkt6n9clEWbTa3vgvHO
         1o+aWsLvmqogyaX/3dFfGfjCZ+g0ThIfFjbJYHs71C+RLDYi/52czpzYPPbMD/qDDwDR
         Os2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bWSzRLi7HvyeJivJF548h6thb9TOqOcyRYDbIel8CSQ=;
        b=scLq6YO3XwbjTDykrTBAjs8Q+rsjbG0hr4knVNRf1P0e/3UHVdIGYRAiJLxMgTVbzQ
         XC1tcHnBhllQfWG7Ihf4lBus0pVAJqO/wOREISjrRWABlHweQL+x5APdgRhHh6Spf1aq
         waSBd56qH+906Y3lNpYGLrd5etioE2dwMCU0a4Ai4oqQ7+zyuI5Rt9ixLTyBpyq2RN+l
         UlHJYSRz26aoVw+EUFqiAxPHZjdMmBThbAx29hYbZUXVsdo7QuFaBuScwI7LwAzP458A
         teQvGWMCNuZH8z3DjLSTy78LUcSqYzOQKRBBwRX1QRozmhJ9ol0h4mGumTZjBQZdcgYf
         2sgg==
X-Gm-Message-State: AOAM532uZlt6Wh9lP82m9FaEDR7KQMCfYoHRvVjtNYKJgNGXO1kBC4YM
        V/oQ0x91YSz5FN61HCBtTzkmyw==
X-Google-Smtp-Source: ABdhPJwoZNER0z2k+Di4MKdUAQ6/1iBtY6MoRc/yC6YBxH5Jlx5x4sHCcm97XZUhBFKnc4YZa9tYqA==
X-Received: by 2002:a02:a496:: with SMTP id d22mr19900123jam.78.1605116512786;
        Wed, 11 Nov 2020 09:41:52 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e13sm1612982ili.67.2020.11.11.09.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 09:41:52 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Dan Melnic <dmm@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: round-up cq size before comparing with rounded sq
 size
Message-ID: <99ea52bb-0157-8458-d570-6bb41c4e394b@kernel.dk>
Date:   Wed, 11 Nov 2020 10:41:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If an application specifies IORING_SETUP_CQSIZE to set the CQ ring size
to a specific size, we ensure that the CQ size is at least that of the
SQ ring size. But in doing so, we compare the already rounded up to power
of two SQ size to the as-of yet unrounded CQ size. This means that if an
application passes in non power of two sizes, we can return -EINVAL when
the final value would've been fine. As an example, an application passing
in 100/100 for sq/cq size should end up with 128 for both. But since we
round the SQ size first, we compare the CQ size of 100 to 128, and return
-EINVAL as that is too small.

Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8018c7076b25..c77584de68d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9226,6 +9226,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		 * to a power-of-two, if it isn't already. We do NOT impose
 		 * any cq vs sq ring sizing.
 		 */
+		p->cq_entries = roundup_pow_of_two(p->cq_entries);
 		if (p->cq_entries < p->sq_entries)
 			return -EINVAL;
 		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
@@ -9233,7 +9234,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 				return -EINVAL;
 			p->cq_entries = IORING_MAX_CQ_ENTRIES;
 		}
-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
 	} else {
 		p->cq_entries = 2 * p->sq_entries;
 	}

-- 
Jens Axboe

