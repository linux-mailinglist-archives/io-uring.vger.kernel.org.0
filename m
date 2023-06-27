Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7150073FB95
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 14:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjF0MBU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jun 2023 08:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjF0MBT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jun 2023 08:01:19 -0400
Received: from mail-ej1-x64a.google.com (mail-ej1-x64a.google.com [IPv6:2a00:1450:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F7D171A
        for <io-uring@vger.kernel.org>; Tue, 27 Jun 2023 05:01:18 -0700 (PDT)
Received: by mail-ej1-x64a.google.com with SMTP id a640c23a62f3a-98277fac2a1so329687666b.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jun 2023 05:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687867276; x=1690459276;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=omb5WPHKjIF19VjpQzIDwr44TOan0N70O5D7yB8S/xM=;
        b=sgTrVNvkO/s7GNIOFrnUhXqW1ZkkCVKfF86rogYZARyOrKzP19DbviI5F9if8TsIc1
         oDAzqFfa0s+F+ZLOLwhOz9Ylgrn+qF+ZDOhYkhBrpIwJAtjYX+D1MpkAAlJVgDPVMf/X
         nQKI2fiAi0K0r3dAzJJgVFk0AV7Z+ztC2zFQG9b9TqEm6Tfn53XxL1uPWsxF2oVvzCXu
         Ea5AmggmgkwD1lrpV/t561g1NZgwHD47jQlB5B+EorEbaVeftVWW2m5I6WE3BaT7lOvm
         VE1McLhJxq2AIGHqsMjBZ1P0TSVEMVp/xH3nDyM+3l0+L/pTzzitphIOqaRQ4jY7Cx45
         c4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687867276; x=1690459276;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omb5WPHKjIF19VjpQzIDwr44TOan0N70O5D7yB8S/xM=;
        b=e9o/6H1NRLBSTQtgsSwCy+toHOOKR/KEZrX2AOWvdmOzBnLB5W7QA+xpBrPJzE4XCq
         6vFXzxvcTWy5BwQyaKtppY3EOVfWzNttSVMqtCPuYVfoZe14Pir0WijYnt8NTnGJ9Gku
         bm3XEHU0LVcmxazZH+H9wyiGrpgi9gsvgUythIb4cKFK4GX0hMDjMOQ3BMjb6ldw/vQO
         IYadj40+NJTxuYgNeukH+klaGXf+6QXRzJVMwSeuB90DWeRbBDMZ49Qzl2dc+7teU0w8
         Elnb7qN2CexxzgYgzlFjjY94hkQcKF6MSOb0X48S6iJyUSVXz85NXD9kjzLMHz49B02o
         yjjQ==
X-Gm-Message-State: AC+VfDx4C5J12eWmHvW3i7O0YiHh3npJwlf0BT44CxcHmmzUmz3lVn15
        OUmmRUbPbQ7y9k3BALGZbrKFObI8xi/rF+zKog==
X-Google-Smtp-Source: ACHHUZ4faU0jd491ttdu3U7/+irU9LewuFv5uSs2YWVwT91VEDSASmrVuXMZ44PNC8mLOdLMnU67aKlrpkg1Yrk2Ug==
X-Received: from mr-cloudtop2.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:fb5])
 (user=matteorizzo job=sendgmr) by 2002:a17:907:75d9:b0:98e:413a:477b with
 SMTP id jl25-20020a17090775d900b0098e413a477bmr1131845ejc.10.1687867276551;
 Tue, 27 Jun 2023 05:01:16 -0700 (PDT)
Date:   Tue, 27 Jun 2023 12:00:57 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627120058.2214509-1-matteorizzo@google.com>
Subject: [PATCH 0/1] Add a sysctl to disable io_uring system-wide
From:   Matteo Rizzo <matteorizzo@google.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     matteorizzo@google.com, jordyzomer@google.com, evn@google.com,
        poprdi@google.com, corbet@lwn.net, axboe@kernel.dk,
        asml.silence@gmail.com, akpm@linux-foundation.org,
        keescook@chromium.org, rostedt@goodmis.org,
        dave.hansen@linux.intel.com, ribalda@chromium.org,
        chenhuacai@kernel.org, steve@sk2.org, gpiccoli@igalia.com,
        ldufour@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Over the last few years we've seen many critical vulnerabilities in
io_uring (https://goo.gle/limit-iouring) which could be exploited by
an unprivileged process. There is currently no way to disable io_uring
system-wide except by compiling it out of the kernel entirely. The only
way to prevent a process from accessing io_uring is to use a seccomp
filter, but seccomp cannot be applied system-wide. This patch introduces a
new sysctl which disables the creation of new io_uring instances
system-wide. This gives system admins a way to reduce the kernel's attack
surface on systems where io_uring is not used.


Matteo Rizzo (1):
  Add a new sysctl to disable io_uring system-wide

 Documentation/admin-guide/sysctl/kernel.rst | 14 ++++++++++++
 io_uring/io_uring.c                         | 24 +++++++++++++++++++++
 2 files changed, 38 insertions(+)

-- 
2.41.0.162.gfafddb0af9-goog

