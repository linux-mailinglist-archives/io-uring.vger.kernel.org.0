Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A334C3F7BC8
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 19:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhHYRzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhHYRzC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 13:55:02 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5442BC061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:54:16 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso4886143wmb.2
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rHWtDL8cPBN02OQnCSe7vASBE8l0h4VCtsgvdesUSxs=;
        b=PifZq7P4Y0U3Tk7e8MfaOBqp60qOsppa2xjF9NT+Oxms9Y/a3VwAUgkiMTfWU7FkHo
         iHQtvt0NKFNf5EZQ2IsyCk80p0gReMy3PVf5lgfGpHXkCm4KhogGjOBb7x1sKf7bSBOl
         9gmsiCHjJkAK4pUfnvJn149Fl2lw8jHA6ajWXthwyadmf8NvhC+cZOjrdylCB8rjKYdD
         EEuJ5lP3YdkyOoC39pF1KPF8WoHcjjdoTL7hMjYeXennMp9MgLXOZ3KF0fDRM7qlYvD6
         B5LTLw+PVyUBTievNeqfxFbUMS8Ru3vFOz6en70aPyjxbDbx2yRKdtdzgBCcVyFiVR7Q
         6BUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rHWtDL8cPBN02OQnCSe7vASBE8l0h4VCtsgvdesUSxs=;
        b=erb4O8ETicmDG3zwgCV/4O/wySwYrtqZ7h6QDj95kozOKBp5j/zKv7b2BCg3x0QmAn
         39RPJ3laWBGWECR6wJA3Z941hAUO7HD1YEOS/k7jQUJtEjoI1zMnfKlxm4Yc/Hnmx7oJ
         8w50fcATnwS4fhjGp4E9SiF8MfCQev45OdFG4mg62GJ+n6n/+gwHcdBjiUC89K8nAowA
         QvuUN+ptTH6GNYMqS2LkodeBL5GS+Ni8bHNqCWGhClAreb35V4zagjQUmUNnY1wDd8lG
         UXHadRx06q/c/KsxGcQUSr1MausmO2RDLQmVSoQMZhCPIFEwdhXPhNxzpNVDAwoZAwyb
         Xxzw==
X-Gm-Message-State: AOAM531rngu0ZzfSv7+0h39E0FQjnJU5jPY/YnF2OzuoM4nDLnQ5Z3Mx
        F2VFhaplCznXTcd7O5Or5uQ=
X-Google-Smtp-Source: ABdhPJyZri5qx1kUjsvH+70py1u8vCUsn/wYyhBmhIFK0RGVZd9NV2XIfSLiMHR35/DIHTeHTk6MmA==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr10616247wml.6.1629914054332;
        Wed, 25 Aug 2021 10:54:14 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id q9sm590459wrs.3.2021.08.25.10.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 10:54:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] non-root tests
Date:   Wed, 25 Aug 2021 18:53:34 +0100
Message-Id: <cover.1629913874.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With 2/2 tests pass with non-root users. Tested with 5.15,
most probably would need more work for older kernels.

Pavel Begunkov (2):
  tests: don't skip sqpoll needlessly
  tests: skip when large buf register fails

 test/d4ae271dfaae-test.c |  5 -----
 test/helpers.c           | 19 +++++++++++++++++++
 test/helpers.h           |  4 ++++
 test/iopoll.c            | 24 ++++++++++++------------
 test/read-write.c        | 26 +++++++++++---------------
 test/sq-poll-kthread.c   | 14 ++++++--------
 6 files changed, 52 insertions(+), 40 deletions(-)

-- 
2.32.0

