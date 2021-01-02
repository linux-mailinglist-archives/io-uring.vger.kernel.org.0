Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E6E2E8803
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 17:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbhABQLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 11:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbhABQLn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 11:11:43 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D993C061573
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 08:11:02 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id q75so13833500wme.2
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 08:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/+E5azedHXLx8CF01pY84BgpXJd3V7xR1o+Ofs3Xo0=;
        b=dGJQ2nHGCb8FB+ChBynUsKUCC9eBJEkhmEfrjUsP3hanZqzertBKD1AnIPk2Q9RRpB
         DYIcc3W43G6W4F6BC5pIYHiqAbnLRnupWFTlyrIdvrF/7DKPGipG5ZvV8wnyKTE/1k9p
         DiLFSWmsl5zmR/nu3V7zUo97WNxDjNTQpTXKBI3+CuAnLe5D2na1dRN6aXxZVBr6RlNj
         HV0d0GwIKPU3bE2eZ0odp5t5QwjNcxCLpM5ekJb80ortRUfNLSa+vsuLCKHSx1EAh02D
         VJCUbwtMwQoEbIAJBDMnwdBGCkQHuX5rAFvjwVosJcZqpTdhCZCY+wkAi+psrAtIejAr
         77xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/+E5azedHXLx8CF01pY84BgpXJd3V7xR1o+Ofs3Xo0=;
        b=WvCqr6NN41A9dm+iHHaK5tDgv1hhJk29jjFrpzCn1H49daNF2b3HZUgsYGHJhhj2kQ
         bD2lCKBf0aX02gOzgjvmv81E0peoOT5heNoSrxqKv50o19RCZXCeiXhkZktDZj8TrBJL
         VrQ13YVqn7V8Mcf3LIzDRTBEENCVNncLhgp8h9jCBVgYIUjx4SPIDdCZ59zeVWlc4e1K
         zXT/1QD5VHrRevblG4j3E+mAnDGdi15UpHxiNjiZqhcd356QH5tR6Q3SvPd+jvJ+NsQW
         kS5AeRnSoKtB58iSxIPsKtonwx15Eu6JbmODoRSADFIWOSPQSfM7a2dU+IYQPg3Kd545
         xOgA==
X-Gm-Message-State: AOAM531KCECtVnWhlT8Ki73MS9DlPpO9PwOQaz+BxUMLCAfqJig5ahcF
        9SBUtEyA2gfIvKPf1RSos4tbeZIzJvA=
X-Google-Smtp-Source: ABdhPJz+ELvck1Emc4Y9kGKL/W5uTXG4uJMcEY999Hv/Bx/knrqrWPsh2OVu5LjQQSwvNot5YyTMgw==
X-Received: by 2002:a05:600c:21d1:: with SMTP id x17mr19756393wmj.160.1609603861172;
        Sat, 02 Jan 2021 08:11:01 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id b83sm25222377wmd.48.2021.01.02.08.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 08:11:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] bunch of random fixes
Date:   Sat,  2 Jan 2021 16:06:50 +0000
Message-Id: <cover.1609600704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The patches are more or less clear, but for 3/4 don't know if that was
done this way intentionally.

Pavel Begunkov (4):
  io_uring: dont kill fasync under completion_lock
  io_uring: patch up IOPOLL overflow_flush sync
  io_uring: drop file refs after task cancel 
  io_uring: cancel more aggressively in exit_work

 fs/io_uring.c | 70 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

-- 
2.24.0

