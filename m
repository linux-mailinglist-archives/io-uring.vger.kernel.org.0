Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72373388CF0
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 13:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351048AbhESLir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 07:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350951AbhESLip (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 07:38:45 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61A2C06175F;
        Wed, 19 May 2021 04:37:24 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l70so9259185pga.1;
        Wed, 19 May 2021 04:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DOzmqeCsc2iYMpeX8mb08ZEh7iT/PQ5+mRfgBlIHl0s=;
        b=kFZkuqMMx2CYiZHMph4A++C6mavWKIZ235oxMJ6FLr+7DFrxygl3rEmk5As+zpONyr
         cyDVN2RuOl/DPzyqLZgb/H5alxDfbjuta4VU92B8JKtb9uNZLQKIgy1ywmkMhSor/2tE
         03X4XcXxCaNK5BCOvCuAjyQsRcbyNdgkazgdDYrgliEHRRMFFrZOwPbKmso9eYv3Nqc+
         DhHKRGPbgV/3sUXUO9lOyb8ISa39gSoWtHoEC1KyxDEajQwlRmjggCTz3d7sAz45dXgo
         Bn9h0bRzCku8PbLWuCU4YBcHwP3sYka0lBJR517RC6nGb1eYnqAO32sTleeZRDw2dnSW
         ubOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DOzmqeCsc2iYMpeX8mb08ZEh7iT/PQ5+mRfgBlIHl0s=;
        b=lxQEFK6fd1ZUhZIpwRZccbdAODHApN+HthxIJiHpZpWsky7Auww/D4aD9Nd+V9u5rw
         Qu1m71c93Y8sRuEmUvUloE/9WpFU257C0Ywx9Bqdygrt2/+NK0Wtpj9LhXSUx498rk6I
         DAYOCtXqcdGaFgWSyhooareTjEA6RbCYiwy9oikOa9GMQel2FcPJGZEiTmtP8x8uaWK2
         kqnEm9p7VF/0jyOOtkm3RyR6kTeteePyH4dzjkiUFApgbahpnwRMAoVWxhfq2uup2yhK
         3ASVZiiZeYn3N7ejmiMEbE1qtCWdUpMhJkPVzz8JS+pyp2GdpSUgJpKhBgxm6ahluoDa
         XhDw==
X-Gm-Message-State: AOAM533CfggFd/k3WqAp/OoF5hvS1rK69piqK3SUgNTXEDMvmUhG55sO
        Yz2MU8rV2zpPw4EL6bANUk5B/NbVMRo=
X-Google-Smtp-Source: ABdhPJyPctOClH12JzlsdkuD6Nw179gOXGqMJcbXWoMgB8R16Cb8nMgrhQ3kDjsKXqXOYHhUHKalbw==
X-Received: by 2002:a65:624e:: with SMTP id q14mr10222126pgv.103.1621424244237;
        Wed, 19 May 2021 04:37:24 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3084:b057:1ac1:910f:3c09])
        by smtp.gmail.com with ESMTPSA id i24sm14087508pfd.35.2021.05.19.04.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 04:37:23 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Pavel Emelyanov <xemul@openvz.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Biggers <ebiggers@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH  0/2] Create io_uring fd with ephemeral inode
Date:   Wed, 19 May 2021 17:00:55 +0530
Message-Id: <20210519113058.1979817-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This set converts io_uring to use secure anon_inodes (with a newly allocated
non-S_PRIVATE inode) for each individual instance. In addition to allowing LSM
modules to enforce policy using the inode context, it also enables
checkpoint/restore usecases by allowing mapping the VMA to the open fd in a
task. Offset is already available to determine rings mapped per region, so this
was the only missing piece in establishing region <-> io_uring instance mapping.

LSM tie up has been left out of this set for now.

Kumar Kartikeya Dwivedi (2):
  fs: anon_inodes: export anon_inode_getfile_secure helper
  fs: io_uring: convert to use anon_inode_getfile_secure

 fs/anon_inodes.c            | 9 +++++++++
 fs/io_uring.c               | 4 ++--
 include/linux/anon_inodes.h | 4 ++++
 3 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.31.1

