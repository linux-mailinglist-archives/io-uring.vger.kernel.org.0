Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D191319664
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 00:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhBKXMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 18:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBKXMu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 18:12:50 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3CCC061574
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:10 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id g10so5885915wrx.1
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 15:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=suf6oHJVWZVM/E6wJhhWXC2RQwhEb7BDp9MGiCVkRbU=;
        b=RZfvpp53lxbKR9sUyodLoXDlly7FFrHbBaO69+lg9d0lKiDvAuUr7D7Fdq1dV5LC5T
         x3v5qYRpcZV0/Yz7Fjuj6bsRjp2sBMlbU/YrHM4GJIoeI0bARCSAje1rd4MGsUeNpBnZ
         gmmhqkScOjWQwtI5BMLP31gQfcTkh4U+r2PQ08TroYalR0cFanSPZYPPBpv/D18Chffx
         MUwDKEagRpvF7n145a2WePwUjzlVHDTczEKodxcVbn3OmaynI6wNb8BfH6zGNGCvHHcV
         gUjZts/3cU0Ha8phST655DeenuaGT+IYb4PdkGKhbtWl8kQxXutYpzOm/34KgI5ZXi4A
         /9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=suf6oHJVWZVM/E6wJhhWXC2RQwhEb7BDp9MGiCVkRbU=;
        b=SuY++LmFLGBbiXjIBI0RIOlCHz0SbXDckoEUkYIdsbjQbpnAQQreh+hYXiVU3VZPaT
         U6h8xE49n4dPDTue1pFPFN9+NmKjS+QMXg0Mqram2cCQRkhAMvub7RsI/FYOV+z6RQqw
         3Y1y0S8GD5xlDWJ1FL4K5xS2P50dG/jfHgf50R1Lh2x59fqg8Ds0fkWdWkwhGIGsAlmR
         O8PdM4d0pz/90yHj9bqMKyeB5Cg6XPT6Gp3Bzk9blLi0jx2o6Q7EOO0+8I03B4UU9W9q
         lDnwGzr3GU/NMwzNlWlyvm9KOlgIlSp5yAO5D6V9zRAZMF7/gwmhj0fPlAyuYrXIyGk3
         tECg==
X-Gm-Message-State: AOAM533lSazzRBRbzMTUkWgcd4YFs9te5qENWGaHl8BqbAlhyu/4q0aN
        JeTD8xqALiqu/gfhn+QsUJarMVZAPvIiAw==
X-Google-Smtp-Source: ABdhPJwdssXtR48MIHvU0vUiePh9UJICo9h3Ykoshp5nKq3JhmTWoxMAn+cmzs1751VfoSHEzJS6Fw==
X-Received: by 2002:a5d:6509:: with SMTP id x9mr112653wru.229.1613085129213;
        Thu, 11 Feb 2021 15:12:09 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id d9sm7271184wrq.74.2021.02.11.15.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:12:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/5] segfault and not only fixes
Date:   Thu, 11 Feb 2021 23:08:11 +0000
Message-Id: <cover.1613084222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First 4 should be good and simple. 5/5 is my shot on the segfaults,
take it with a grain of salt.

link-timeout failure is a separate beast, it's from the old times,
and comes from the kernel's io_async_find_and_cancel() failing with
ENOENT(?) when a linked-timeout sees its master but fails to cancel
it, e.g. when the master is in IRQ or posting CQE.
Maybe we just need to fix the test.

Pavel Begunkov (5):
  src/queue: don't re-wait for CQEs
  src/queue: control kernel enter with a var
  test/link-timeout: close pipes after yourself
  test/sq-poll-share: don't ignore wait errors
  src/queue: fix no-error with NULL cqe

 src/include/liburing.h |  4 +++-
 src/queue.c            | 22 +++++++++-------------
 test/link-timeout.c    |  2 ++
 test/sq-poll-share.c   |  9 ++++++++-
 4 files changed, 22 insertions(+), 15 deletions(-)

-- 
2.24.0

