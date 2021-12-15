Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7275547656D
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhLOWJF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhLOWJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:05 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1888C06173E
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id o20so80244589eds.10
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWfHjxS8soPkBEv/grGsO6Cxt422SrVWlseGj9ksIN8=;
        b=Coza2IyN0izf2pRlNZTTRMiFwQCghrjZud1J1wUu8UhezjqQf6xzX01LmWZK+CsGPC
         5+8YyJj03oLn8YAzyNn49TFzJjO2QxgEd65L4hVCLUQkQuHwf7Afnb6mE3kB2ID2vjXv
         Qb50FreWLp4+cuzJAxXjqZxOjLVk9XInJnipmIe4K06ztQF3CbS0v6POq1JkKup2uBat
         9Ep17qYTuNXjxxPQEgSCKqksBPKgNMz+IvSg9gd0AzZV/KVCvz4gObWwmS5xHb6wqI2x
         O1QYBO+tHjwBk2wqsOT7MSRaOUAwIlVCRkRLet3LIk8s6gYJEovcERFATxS48IKY7lF6
         L8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eWfHjxS8soPkBEv/grGsO6Cxt422SrVWlseGj9ksIN8=;
        b=l6magcd+q5TOPTYWMVwVphl6v6usnXsNuM1YPi1SV/Nyp+/NDxfzK4ASi9AxSBdGzg
         fM/w16dgxBDJd4/h7sQRPsksOIV6YefZTeBm66QvBs8bo5irXST1Qvp8B0Auerfr9efc
         uER3lyegEiYKmSyXjs/Ve58dh9kxSEJFXxv/lSvWIvNPwpCv4OnPcutBP+nL6g2XkwBG
         WYIpTEiRUr3ixcJjbzfBvhPZ2iPSEHla3/fbAMqath7/nRBtMORCCDcuNrDCqdfpjFaR
         oYCMDU8rkwD66PfQTD2Uj8x8c2rD0u0Bm+adWUz9OyLF23BViUfh3xoOML5ap+q9E8sX
         Uv/g==
X-Gm-Message-State: AOAM532CQm4+UFyfjF+gRKjm/kP3i/AeC8eKpSZB4bwD2OGYK3vv+UK+
        ZXTsX1XSjlAVwXqm2PNNFZMtVWdqgmU=
X-Google-Smtp-Source: ABdhPJx5ESAghyR7LoSI8vR5TBIBoa/I4SSKRiuGmC1f3TGd12g9czvnA8VKTuCy8P5jZCIJwB+LbQ==
X-Received: by 2002:a17:906:1853:: with SMTP id w19mr13400545eje.721.1639606143194;
        Wed, 15 Dec 2021 14:09:03 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring: remove double poll on poll update
Date:   Wed, 15 Dec 2021 22:08:44 +0000
Message-Id: <ac39e7f80152613603b8a6cc29a2b6063ac2434f.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Before updating a poll request we should remove it from poll queues,
including the double poll entry.

Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3182b67c1277..416998efaab8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5980,6 +5980,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	 * update those. For multishot, if we're racing with completion, just
 	 * let completion re-add it.
 	 */
+	io_poll_remove_double(preq);
 	completing = !__io_poll_remove_one(preq, &preq->poll, false);
 	if (completing && (preq->poll.events & EPOLLONESHOT)) {
 		ret = -EALREADY;
-- 
2.34.0

