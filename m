Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F46B320663
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBTR0P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 12:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBTR0O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 12:26:14 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FA8C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 09:25:34 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m25so1138685wmi.3
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 09:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RsBjvfxYKheEYHBLG3aSQGiKeGw8NlDjkJWrO9wZrpA=;
        b=VfSoF+9021oF7U6Qmvm1FJiRAeM1yhsMuQW1CiYvmp4redoj7bYTste9TT6mLANCaq
         l01ek06oUKclnkF5oucNsrlGiUHj15RhDOfU7GNxHuQwVRQowKunHB/4mIB0c86SWrH7
         VQkyEXpqor/7yao5BkXxHDTOCXZ7mZE9tazVXXU+xGntECY9rL2mwHP/VKA3VT7TAX3u
         Lc2dKtj6H5T5XdMnXvihE7bEUZsyVBAZSZE87+MzG39y6d5X97WXIx6hgxPULI8HGCrw
         MeMjpylmEq8TpoufyQmNSATCbNjslAJRmMo+HCOJgfS1Bevi42gjcEpNHrFxxEtvc4tY
         +xoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RsBjvfxYKheEYHBLG3aSQGiKeGw8NlDjkJWrO9wZrpA=;
        b=Ria/HIYu03UFdZyCUHUD3/uX3S1IoWM8RraIPirJeGz4N9McpHcePUk33zi63+A80W
         kKjY59zSSZNm5OufFf5aXNjFrYuCACaQHuMiFPF453blFi4s1wbqgYwbGSsez7l7w4Lp
         24nOC8vc/BNZRTh2ePBJh6tGo8PCBOxLXt1mbkhC2OPSEXwY4UXDeQ2P0iM1yuoqEE/h
         m1pTlMia+jf1+e/vEvjcGrSylclIMS3yKrD+aJQw//fQh7lbHBWdpQ8XZRFhXBh+EXKJ
         DdVk+CR/jusDB4MeAL9Ocm3voASULR7lhZRW2hGpcV9omSgT1wXuPtm9HtEGLmY0fti7
         E3WA==
X-Gm-Message-State: AOAM530eqfsoMNmi9QUANZuzduPAnqyS9Ow+RxA9KWapE/4it4pjV0U7
        wGtPAtUKYqZ3CmLXb3lyKRE=
X-Google-Smtp-Source: ABdhPJwM5aADbpd7INIoRTYgf40skDtR2bvQur7xyrbDfSeaW6wpfjwfW0/SJx3m6GLGBMxbqiYAkQ==
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr13059051wmq.41.1613841933158;
        Sat, 20 Feb 2021 09:25:33 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id r1sm19908520wrl.95.2021.02.20.09.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 09:25:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] resurrect
Date:   Sat, 20 Feb 2021 17:21:34 +0000
Message-Id: <cover.1613841429.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Combined approach with tryget, fallbacking to trying completion and
doing synchronize_rcu, where the last one is very unlikely to happen
and limited by one such per register syscall.

I expect 1/2 to cleanly apply for stable, 2/2 needs to be backported
by hand.

Pavel Begunkov (2):
  io_uring: wait potential ->release() on resurrect
  io_uring: wait for ->release() on rsrc resurrect

 fs/io_uring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.24.0

