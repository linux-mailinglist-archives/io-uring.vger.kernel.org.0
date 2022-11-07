Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CD561FFF7
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 21:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbiKGU6L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 15:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiKGU6L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 15:58:11 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE3E2B61E
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 12:58:10 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-373582569edso118239977b3.2
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 12:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IAoAra9R2Xqdytgvb5FHE5lvqaFSAU/5jMDpLKBjdb4=;
        b=NB8+Ew0AYfjmdPJdO0XSLwfeZ+OYwIKA9BIG0WqV9UrxO3UPzg8TrtAk7vX7Fpgouh
         Rr0mu5WbmN5eVwxYMl0tb6d8HqaeDN5jziODCiHZrIr9GkLq1ikFlFRNaSGPbJrtaSha
         97hu4cLAScRvpdzS9lRQ3nMVtwtkOwhNnGz+F5c9kScSKtHJ8UkXaOIOjWXW+/NXl3os
         Vkk/TDoxm/DmVPBMqFDueVrFsDxqB87yhGLX9L4d/gGZsbHNcLoNaVM6Rzh0c5lZQEFK
         O1owrltdz5foiqAOjZEUYB8vm97E2wbZMy0EzGX4LIDDSF/FtmUJB7dspANhyP0/E8Aw
         7vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IAoAra9R2Xqdytgvb5FHE5lvqaFSAU/5jMDpLKBjdb4=;
        b=MNQ85SYYdYtswVoYy9fvx5JiwZ5hk3HGy2250m25PhbNcUZKrd7P7lbcEIDKAMyVmv
         LODYopuOD2jqusHJEjLrW/nfg5qG50BLGetdbU+xgUxCVHKKhAgnWXUJf1A2L1I652AP
         KgDCWdC8o3DrfVSGKfODB7ZNRCSfdmp65BgophGgHKJm8besJKcV8h2KCrhQBgvGVPcb
         lBuuM3w+fcxkcIdmVJy39/qGxcP17oyGj0vnYENfJ+vVSqbl9hKwITYtMFZRyZsVWcdt
         9zRVOGCvB7pn71v6gGDvT20fHI7eeHYv91lPT5aQpl6WlsKCejLQm1fvwZ/kHbJj8ASF
         ys5w==
X-Gm-Message-State: ACrzQf0MsUqD9Q33BkN5mLCaVesdJXSkkhKTtaObpEzdlEhWFdV5WYj5
        hhp4uJD18ctY35Pit2DMBvHZyBERfg==
X-Google-Smtp-Source: AMsMyM7xHXCGj+7pqy5ZViDJCt7bvm3vyqjC4LS848X+8b6/op7HR4kC3hHLFiKF1yGjPQJpZbwBHpjO4A==
X-Received: from cukie91.nyc.corp.google.com ([2620:0:1003:314:8113:36e9:8e90:5fb8])
 (user=cukie job=sendgmr) by 2002:a0d:c481:0:b0:35b:cbe2:d66a with SMTP id
 g123-20020a0dc481000000b0035bcbe2d66amr833796ywd.125.1667854689567; Mon, 07
 Nov 2022 12:58:09 -0800 (PST)
Date:   Mon,  7 Nov 2022 15:57:51 -0500
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107205754.2635439-1-cukie@google.com>
Subject: [PATCH v1 0/2] Add LSM access controls for io_uring_setup
From:   Gil Cukierman <cukie@google.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>
Cc:     Gil Cukierman <cukie@google.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patchset provides the changes required for controlling access to
the io_uring_setup system call by LSMs. It does this by adding a new
hook to io_uring. It also provides the SELinux implementation for a new
permission, io_uring { setup }, using the new hook.

This is important because existing io_uring hooks only support limiting
the sharing of credentials and access to the sensitive uring_cmd file
op. Users of LSMs may also want the ability to tightly control which
callers can retrieve an io_uring capable fd from the kernel, which is
needed for all subsequent io_uring operations.

This was tested by running the liburing test suite on a kernel
containing these patches.

Gil Cukierman (2):
  lsm,io_uring: add LSM hook for io_uring_setup
  selinux: add support for the io_uring setup permission

 include/linux/lsm_hook_defs.h       |  1 +
 include/linux/lsm_hooks.h           |  3 +++
 include/linux/security.h            |  5 +++++
 io_uring/io_uring.c                 |  5 +++++
 security/security.c                 |  4 ++++
 security/selinux/hooks.c            | 13 +++++++++++++
 security/selinux/include/classmap.h |  2 +-
 7 files changed, 32 insertions(+), 1 deletion(-)

-- 
2.38.0.135.g90850a2211-goog

