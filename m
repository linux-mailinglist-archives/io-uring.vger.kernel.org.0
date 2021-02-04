Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF65630F466
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbhBDN6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbhBDN4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889D4C0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:55:59 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c12so3576198wrc.7
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qki3CnTEpkNyMdIhcAvX5K5YrpNaRHZ/PzBv6u+9W0A=;
        b=pxWNvI9yNVdLd4x7iRbhm30MsXo69/2k/dnjbOgAAFQA6vLr9G1p1DltPg7sniXjZh
         AAqn0I5TbLUCvryqFxoz7vzFGTYpnnPpBnHQvGr6eW1+kEJXv4u8BuARsqt1BuyLCFJW
         XgQcqmR4Gdsyt2LtjtISh36VmB9dof9Ta1DaRJSLoY9kYPBte13Wnr9j+Yzz62C5jZwG
         /emp44XKqDMQI4i2ZPECqQtOmU8g2uNdrYDqJrsx79Ka5Y/RNlQEnMAAya3l1jQY4hKn
         ZVRPMmIi+lez8As/ejLd6mHLATQsOxVP8HC1SPNRMYqHX+qTRPgfRfItf3R4Ios18AJa
         5QMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qki3CnTEpkNyMdIhcAvX5K5YrpNaRHZ/PzBv6u+9W0A=;
        b=tiq94Sz09aFNY5Hk5nWlJU8tpFVmQnkeyeA/0Xw6WhMQ3z3QYID6eX5+ByFgI73+bx
         57p9uKXBOEgxxdF6bAAXzRS9avLqk4aMBemZouflmxUjnWPHc2pVcRSNrsTBSXwor3zB
         QwfqTHY1VfOi7zppiAv2EgnlWD8nemchzcz0uBPGKHcuShm0uLqhsV5yZOiO4ZusNDoY
         PNmRLHe6Er/GDkElpav6LgXK+bVOInboK5ETn/vjfLrpb92AsaA3ia0hB6BIxjUVV5nT
         GGhkdOdKr2fc6+QWlKI6TRQbvfL9FJVqysm/IAAPfyN1QTxgM3Bu3GK/wUp8stkVWQbD
         vkRw==
X-Gm-Message-State: AOAM531tOORM5dq4fMH3OWpoEKJzCVQed1aMQey3K6B6M9gql2ZhK0yx
        G4Es/AJdjxkKtI8gsTHJVmPtdVl77CKmCw==
X-Google-Smtp-Source: ABdhPJzOPavUIPfn60haxwSktT369BCQ8R7XHdot2Z9ucP36WlIhBA34AxQm124iohmQywedpXKv3Q==
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr3133935wrw.183.1612446958357;
        Thu, 04 Feb 2021 05:55:58 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:55:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5.12 00/13] a second pack of 5.12 cleanups
Date:   Thu,  4 Feb 2021 13:51:55 +0000
Message-Id: <cover.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Bunch of random cleanups, noticeable part of which (4-9/13) refactor
io_read(), which is currently not in the best shape and is hard to
understand.

7/13 may actually fix a problem.
10/13 should make NOWAIT and NONBLOCK to work right

v2: add 9-13/13

Pavel Begunkov (13):
  io_uring: deduplicate core cancellations sequence
  io_uring: refactor scheduling in io_cqring_wait
  io_uring: refactor io_cqring_wait
  io_uring: refactor io_read for unsupported nowait
  io_uring: further simplify do_read error parsing
  io_uring: let io_setup_async_rw take care of iovec
  io_uring: don't forget to adjust io_size
  io_uring: inline io_read()'s iovec freeing
  io_uring: highlight read-retry loop
  io_uring: treat NONBLOCK and RWF_NOWAIT similarly
  io_uring: io_import_iovec return type cleanup
  io_uring: deduplicate file table slot calculation
  io_uring/io-wq: return 2-step work swap scheme

 fs/io-wq.c    |  16 +--
 fs/io-wq.h    |   4 +-
 fs/io_uring.c | 366 ++++++++++++++++++++++----------------------------
 3 files changed, 166 insertions(+), 220 deletions(-)

-- 
2.24.0

