Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B43EC861
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhHOJlh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhHOJlg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:41:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F23C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q11so19317665wrr.9
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jYhX6tfHpXjIcE3Ax8XnshdAVx9zsOToO4G0ciN/9rA=;
        b=Si4OL24WNn8OjH+25//Or33b5OI2JqjqSX/quNDi7cmQrlGTdV5DqLo8Wau2h82obW
         wy6X6q/zvBwkoiLJJ+juCgvL3/xXQMh9zth1hZX8TQp2ZC0ypXQsmAVobQkHUOuPisvL
         9LWUB9fPrdiFK2NtTYDRBgVC+lOgijQat62Y1nAm2NsEfW1MOSCDj63fwHg+38/ZMI11
         NQlZWKwf1bto+sENkT4/FvOjFTE50MBDb9gvhZ/3uddR3uRvoEFyC6BhjtfJSj1E99hK
         U4aibzYaQFBb26Mh6KZeL1pYBbj0DAaqOMmyypOF4Eez+tKpVu/Fp27QohwCyY9FJNbE
         tM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jYhX6tfHpXjIcE3Ax8XnshdAVx9zsOToO4G0ciN/9rA=;
        b=OPmUTsriyiLb1yqgciIH5/0dxzQ8rL2B/gKV/h5wxx0Hi5bpBbCRoqnE6jCGLyhRIo
         k12vjux5khjBhe8kdFPq7tu+6Y3Kz5JhBBHmAsYCF0pbNsGWJCnvODFvvBbmPDZ7LX2a
         YVl0GbBpaMnTSOz59w5fhjjQEwfLpWLkABPlsS2FbYAVQX1/Matm91zRp3C1sUGD/zyN
         deBicW7AuWyMpt8tcdEi30H1C9XcC+ds/6oT5o6Md+wGFKPzmruGvWKFyC0XN3GMitXy
         yzh0w17AVSfW2F7jl7aHLVRsdN/nnkSI+IresI3qeO9uiUoMgrVNKSml6rEdJcOTSuc/
         uj5Q==
X-Gm-Message-State: AOAM530yjTsmcQh/RIu9jV7ArSGyTclWoi1xPMUwVkFugkflMLL9Kl1o
        Un4l/WSaMeMlTVoGaVqWink=
X-Google-Smtp-Source: ABdhPJyKq8n1okCZ4PtsDUXKIKq53RiQ6jqksu2uvGMsASFAUYZ9iiBeY4GUlxFePmIZDGZSAZfnHA==
X-Received: by 2002:adf:eb4a:: with SMTP id u10mr12299785wrn.11.1629020465499;
        Sun, 15 Aug 2021 02:41:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id t8sm8828815wrx.27.2021.08.15.02.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:41:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/9] io_uring: optimise initial ltimeout refcounting
Date:   Sun, 15 Aug 2021 10:40:20 +0100
Message-Id: <177b24cc62ffbb42d915d6eb9e8876266e4c0d5a.1628981736.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628981736.git.asml.silence@gmail.com>
References: <cover.1628981736.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Linked timeouts are never refcounted when it comes to the first call to
__io_prep_linked_timeout(), so save an io_ref_get() and set the desired
value directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fde76d502fff..d2b968c8111f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1310,8 +1310,7 @@ static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 
 	/* linked timeouts should have two refs once prep'ed */
 	io_req_set_refcount(req);
-	io_req_set_refcount(nxt);
-	req_ref_get(nxt);
+	__io_req_set_refcount(nxt, 2);
 
 	nxt->timeout.head = req;
 	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
-- 
2.32.0

