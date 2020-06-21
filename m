Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6629202B86
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 18:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgFUQQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 12:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbgFUQQd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 12:16:33 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923C6C061795
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 09:16:33 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m21so11575721eds.13
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 09:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mxzqYcHnWvaR3JVJoXgCsD3ZXfEx/W4ehtazGOnVEfA=;
        b=qAhykpjOYmvbZgnS8lv7I5d5aVo1liuqRTFJ8TYTuMulMK4MAZ1pnuJ3b+SMO3LuBc
         Ohuk8dsd/e6zfo+YEzZokCQwxZBR0fmC211I+Yb7iNn+EKTbRIzhVvAVFlFfR2/hoAUE
         aaB5Ip8f/ss9evlgjKgEwc2nne8eHP1wxedN2/+MkBPv8dhoeK/3AX+Eowr3UArnUhin
         EtDkFkyrTH1IjwtOVVBxfCd9c4OBzIonewsbeEhYBj0YJhqLLMvC7g4Zr5eAixsa3Y3W
         k22uPKLSdOOqVS9dNPNRqjzAylt94st6k8cZLYByQB1qSj8PqfWqjvdRgpQzlyK7yy2+
         tx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mxzqYcHnWvaR3JVJoXgCsD3ZXfEx/W4ehtazGOnVEfA=;
        b=VyqeMkabVbULEluaBJPT22nzBY8hhUDwYr5zYaZ5FPg8x2NovDyCDDIZNsD5b8KZbt
         cqcrtcjmQHUOLkW+iUoCG+djJ+jgJ3Q3waYfjm8KEFn6cn6Ri7oXEtBFvhvSpHgehAlo
         LBmlmRt4qETiXmDMy6vaFa7lmIPlcSYsxm+qENegukSonwck+swJ6LhJdgiQQ+vQ0B9g
         aUhRytjJbgRxEb07LYjWpIwvtfLX/X9U93V7Py6GJPLS6U3w8MPGlsgxFZ/CM46Y7wes
         2Gx42n6iJNZ8mdI0PjDuGVEfiYaPtpluCbcn3PffcktLdqJXNUWPlE4uYkGuhT199/r0
         EwMA==
X-Gm-Message-State: AOAM533mNN1kCEg+p5jbi5vkB84Fi/vd+X8mMISObLotyGL+MnAHsN5z
        8ma1UZSg1j6nM16G4YbUN2x8Gc+4
X-Google-Smtp-Source: ABdhPJyqwMlRQBpbugIw1tppO4jHOCWjTeA4RlzctkgsmWqKlKfJPv8pnQALYT58bABFvYF/LtRC+A==
X-Received: by 2002:a50:a661:: with SMTP id d88mr13295763edc.34.1592756190606;
        Sun, 21 Jun 2020 09:16:30 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 64sm10160292eda.85.2020.06.21.09.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 09:16:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/2] Fix hang in io_uring_get_cqe() with iopoll
Date:   Sun, 21 Jun 2020 19:14:24 +0300
Message-Id: <cover.1592755912.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v2: use relaxed load
    fix errata

Pavel Begunkov (2):
  barriers: add load relaxed
  Fix hang in io_uring_get_cqe() with iopoll

 src/include/liburing/barrier.h |  4 ++++
 src/queue.c                    | 16 +++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

-- 
2.24.0

