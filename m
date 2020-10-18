Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21797291699
	for <lists+io-uring@lfdr.de>; Sun, 18 Oct 2020 11:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgJRJUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 05:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgJRJUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 05:20:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823F8C061755
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:49 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 13so7441197wmf.0
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H2WfFsnPv9ZjKgtjqr53+raQLT+S4FZCn2PXNZCqAY8=;
        b=VVnKud/CBD12Nw0FpNAElUc2OKY6gk+1tCxDc0VverSlxPO+81HZsIb1Zue3RG42qy
         7PoQf//rBoQb+qB7VJZjOtIIyixFFywiDrRTNOy1a7XzuC4xv5WhR9RfRJOaN39KnDEW
         MHmD0mXyt+8j4wTMvjhraIesi7Nn5eGMAIGSiPaylkXY6Kw4vT3n0dACcR5ZQNeV5vRr
         AOeQ12KN3L/gyq1YF9tZVFhT/oKFIpD6Fn5Qc2jzVEwl/JY+znZmxYi2DWBX0IQGt5Fy
         AYD/fnP5RUlKO+p+HBFLX0b7/i1kHiZSzYfDKDuILUiSzNaLCRdXyLVTLJSG5+nqcsRj
         HfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H2WfFsnPv9ZjKgtjqr53+raQLT+S4FZCn2PXNZCqAY8=;
        b=PwL28iGsLP+NY2gFu9MNQMkTQLheoV0axH9NKBh9cPdA2+8EI/KIzgtbCmAkIgUrta
         fXyPuVA4zF1T5uHXAgM1YC9b7LPAIPpow6584km6UKHfJvTwjJgkkZCqLGBHX3awWD4t
         hWkdfdN/rGFNWC1ksSNa+nm402ZCJ+xs/FuKoKA/niCJeoxGHD6Q7cKqKY7x0+K+soXm
         GgVsqU6065D4bXkidUiH4Tw83a17GF4F5Z3O20Dcw2hhdjO8bFtl0070/ha3bIOLTIiH
         9gTvD20r65nPkHxdKCi4xo5mDZetgkoapKLCNOQn7TykdnHI6VGZ3kpb+tSFj9XLiL6h
         LWpg==
X-Gm-Message-State: AOAM5324xbpbALL2NJlEst51uOwWWbu93qboKapoF3434tIdG4aoscpI
        r3MVlpn/ObOXtPIsSBwZ+CxWkhhP1aNKwA==
X-Google-Smtp-Source: ABdhPJyN8bGKVAzARSy7moxKEZW9oWwc83QWVAlFoFL7elEsoVXKeqMRmsm6+tsbJ1S7HheYWMz4cw==
X-Received: by 2002:a1c:c90b:: with SMTP id f11mr12201578wmb.54.1603012848241;
        Sun, 18 Oct 2020 02:20:48 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm12782984wrs.26.2020.10.18.02.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 02:20:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/7] io_uring: remove extra ->file check in poll prep
Date:   Sun, 18 Oct 2020 10:17:41 +0100
Message-Id: <d2a569f6dbbdd7bf2e497bdffe642f0731fee6c2.1603011899.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603011899.git.asml.silence@gmail.com>
References: <cover.1603011899.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_poll_add_prep() doesn't need to verify ->file because it's already
done in io_init_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c7ccd2500597..70f4f1ce3011 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5340,8 +5340,6 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 	if (sqe->addr || sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
 		return -EINVAL;
-	if (!poll->file)
-		return -EBADF;
 
 	events = READ_ONCE(sqe->poll32_events);
 #ifdef __BIG_ENDIAN
-- 
2.24.0

