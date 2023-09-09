Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB22F7999CA
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbjIIQZi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Sep 2023 12:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343601AbjIIPLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Sep 2023 11:11:39 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C3E1AA
        for <io-uring@vger.kernel.org>; Sat,  9 Sep 2023 08:11:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-27197b0b733so601257a91.1
        for <io-uring@vger.kernel.org>; Sat, 09 Sep 2023 08:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694272294; x=1694877094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FR4mT7BpnQdHvbo4nJB7tN7p8TAHwH3cLmazs6aPmRY=;
        b=K8y37S5UWFsHK/IJcGT6538xALY5nUM5uRehhpr8XIYGvW1Ln9MjWk6SEeJ8acB1J9
         iYDL8bMgGvCnOkZzlRF+5D5VOmNzfG/bdvrt5jjnJMPOYH4oNAa98xN+RFDDnGiOaEUl
         G9oZ0+Ru3u0QZTIAc1HpUK9tX45fh8KY0FgouSDGK0GM3r7N1SEAMfLeCdMvK8FttwsI
         oZdpy0txlqgtExzh1t4RG2cQB4dFGn5JJC3fEYgYDrxoP0+i4Qssgad0t7c9OJtpehu+
         S2V/LtgXV3NjbQ5MZ4e6p9/vIKB7i+Zl+bEaMuKWc+bU6aCUxSDuhza5DaMcVNeowj2w
         RdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694272294; x=1694877094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FR4mT7BpnQdHvbo4nJB7tN7p8TAHwH3cLmazs6aPmRY=;
        b=Klek3rhJyLaHa2eCiZz3iKJBlfNmz44cZwDrjlqAg+PKM7B401dabzRELSWxvY3Ija
         fidmx9vaqEIFdxfWkNkUPOSwb0ng5viV8r4V6kp3v4uLPIcBVVnWr20H8LS/Vd1vTFcT
         AAaMD+4GqpgjrkNTWb78g9+3vhjsJcsUWGFl22SeXSplMwltwcYbsgeS+uWmRRXI28N8
         UMlMRMBFTL8GctmDjds8s/A7YJBWsh4nJtwYNjX1qEgnDYcI3Jt9mwPAsTV4OF8HkpaA
         3yWOm2ZO8u6OyrKKWg2u8l1gVH7BD+2O0EyBVF4mkexSEPir7fhsvnuRgHjcOzWUUMuQ
         OiPw==
X-Gm-Message-State: AOJu0YxVWxkugXZ3N+fV5p+MGWr23k11L8BfcaeNH7eS8xb3MGm6J0KS
        h7TX0b9SuuiyT7O2JvJY8LZk+iBUr7CV3WfnyeqqMQ==
X-Google-Smtp-Source: AGHT+IEetE5imo0CtKdmhK3iz+SEcOuUNbyEMBqZEcAJidGPHnc1cKIxlJx+AQXl4xfSoakrkGKoYg==
X-Received: by 2002:a17:90a:3ec4:b0:26d:414d:a98a with SMTP id k62-20020a17090a3ec400b0026d414da98amr5254874pjc.1.1694272294081;
        Sat, 09 Sep 2023 08:11:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ff0f00b001bdb0483e65sm3371450plj.265.2023.09.09.08.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Sep 2023 08:11:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de, asml.silence@gmail.com
Subject: [PATCHSET v4 0/5] Add io_uring support for waitid
Date:   Sat,  9 Sep 2023 09:11:19 -0600
Message-Id: <20230909151124.1229695-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This adds support for IORING_OP_WAITID, which is an async variant of
the waitid(2) syscall. Rather than have a parent need to block waiting
on a child task state change, it can now simply get an async notication
when the requested state change has occured.

Patches 1..4 are purely prep patches, and should not have functional
changes. They split out parts of do_wait() into __do_wait(), so that
the prepare-to-wait and sleep parts are contained within do_wait().

Patch 5 adds io_uring support.

I wrote a few basic tests for this, which can be found in the
'waitid' branch of liburing:

https://git.kernel.dk/cgit/liburing/log/?h=waitid

Also spun a custom kernel for someone to test it, and no issues reported
so far.

The code can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-waitid

 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/Makefile              |   3 +-
 io_uring/cancel.c              |   5 +
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |  10 +-
 io_uring/waitid.c              | 372 +++++++++++++++++++++++++++++++++
 io_uring/waitid.h              |  15 ++
 kernel/exit.c                  | 131 ++++++------
 kernel/exit.h                  |  30 +++
 10 files changed, 512 insertions(+), 61 deletions(-)

Changes since v3:
- Rebase on current tree
- Move it before the futex changes. Note that if you're testing this,
  this means that the opcode values have changed. The liburing repo
  has been rebased as a result as well, you'll want to update that too.
  liburing also has update test cases.
- Fix races between cancelation and wakeup trigger. This follows a
  scheme similar to the internal poll io_uring handling

-- 
Jens Axboe


