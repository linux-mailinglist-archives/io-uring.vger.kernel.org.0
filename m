Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C368C2DF580
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 14:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgLTN0K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 08:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgLTN0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 08:26:09 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6998C0613CF
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:14 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c133so7215835wme.4
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/jNrUleWPHND8Ky7y4DEsfLAE8U/UoBtAxEsI1UYfk=;
        b=MmNKqdDdx/atG4SnikN0uT7Vg7+OgnXzWzAQf0gDBN62QDX7p4zA6iSnnXuE805qcS
         3iEV6DFY9meWXGLWKdtAFfRGC8yB/ywBF8BrdhlRokKmM09ohX77BmPXvWYfHkwlOILl
         HzKq9w6S5dPahor53EVclw6U3gPmbmjux//BeoyYgKiiXsa4CaSsTPM6HsO91Pjtbhue
         BqrDn2lgMfDiNggFRU5vKojAvpaLCgE+HCHnm5YGEogM0YaL+MBCrvDE+mBD5rkkzeIv
         FI8PHhahnX7kOp/qWIcHYWJyLcx5puGrpzJIEjVMjTX1hv/vhXHdl8CisOSgM0797K1N
         Xmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/jNrUleWPHND8Ky7y4DEsfLAE8U/UoBtAxEsI1UYfk=;
        b=cG2pS4Itj5sEGGZ64dmGiQjzBVVOCiZlVOVzqdTHBCM/XRgisN6wb6x174HqMahO8U
         mK2fqmY7CEmC8GugharejCRqRkctZ03+71b5VQogFKmM5ZNJDLnf2TKCAWx8Lb0dufEH
         utxnbC3z/68QeLCP2D5bL8kLksW3Sfy6monJAOsOHOKcP0QhUrpzfeWK3NKTd0h79LUO
         2ABLEJYsNITNyYXvShxc2JyxE6KVuRbiWG84gopbtkwKzGh3em7eMtqOrfKWbM9ZzWnM
         uxvcelReuY2ylXe6cO6zrewagNvJ5gE2ClcCBpl9gbhaC/OO/HyOEpLohq4oO53LSqeV
         WIUw==
X-Gm-Message-State: AOAM532o/RV0O1w9JVEt9YX7XpcIkEL2GrFbaFsgpqnrtSJQi+e20n0t
        mFwSVRYV59TRLw5GKfaCmDpEm5alhpEPgA==
X-Google-Smtp-Source: ABdhPJxQdimtmSuTqs2DKVGUtu/EzDBugNUTJiePorIKKXMN5as+pA6P+h4P3tIuzyV1N2fUuMmmQg==
X-Received: by 2002:a1c:5459:: with SMTP id p25mr11613774wmi.19.1608470713108;
        Sun, 20 Dec 2020 05:25:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id l11sm22946519wrt.23.2020.12.20.05.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 05:25:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] task/files cancellation fixes
Date:   Sun, 20 Dec 2020 13:21:42 +0000
Message-Id: <cover.1608469706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First two are only for task cancellation, the last one for both.

Jens, do you remember the exact reason why you added the check
removed in [3/3]? I have a clue, but that stuff doesn't look
right regardless. See "exit: do exit_task_work() before shooting
off mm" thread.

Pavel Begunkov (3):
  io_uring: always progress task_work on task cancel
  io_uring: end waiting before task cancel attempts
  io_uring: fix cancellation hangs

 fs/io_uring.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

-- 
2.24.0

