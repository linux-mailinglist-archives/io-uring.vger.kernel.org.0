Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548003975E2
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 16:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhFAPAe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 11:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbhFAPAd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 11:00:33 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACFAC061574;
        Tue,  1 Jun 2021 07:58:51 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o127so8388533wmo.4;
        Tue, 01 Jun 2021 07:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v/DPpONB5odANLklybjY0IIz2Pfr0oDmD8mNE0eMYsI=;
        b=Uz3fUkl9sq/oqwcdscWGbxqJrGU3rI5f/xRfrQixUnNdVN5lPlk4PwAPQGfEQRxOYP
         MLB8LrVpAyJimVWcRG16K+3vVSghn1YodeKsNydqG7okEu2E7cHUuTUDmxusc4cpcTdx
         vrmKOgxa1poBlzFJuRhSKe8oERH4/Ay2f2vM6mEjJjN1/0+nZA3FqAfnPhpl6ZsJd59Y
         7hQBN86KvB4LX05xOSbFqZ7h+lBNDQthjnRssDZ+ypVGgxAs2RuuHbkA3bYY5/on1VJa
         ahAIh3nFaztxBKTWqT1LNQxR6ycjPNLm/qEGrxgivQ/yEiSrXmnfsz9wOEx0EduCjX2i
         zQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v/DPpONB5odANLklybjY0IIz2Pfr0oDmD8mNE0eMYsI=;
        b=Fk/osuI77APTYSfBFaRiuG0BbkQEzuztfdiDR3mf/0ua9HCjWyLhmHVGTB0xrFso4Y
         USttkWAOryy+/nRBW3Dj0Iax/d9GPPLYpy/nlCEUF8bg2n1/j34ZH9HfPth0HGKtDzRk
         tRuRTJc32jcdptVhwt0ULLsT3jESeGt56e+omYEnIt46O0vtBFXZyr4SuX3JzoSv4ofM
         Gbmwm+xNy6ZTKQmsKnEJb9DEj3VkIQmQTYuaCgJWM3nNjJ8Si260tAM9nFCKMuuYev5L
         iWNLWbClGsTCrDP7VhImZzCWCn01Ss6emN1XMFWgQ4HkZbxNeyGchibp0gsKgdUEDG10
         6GkA==
X-Gm-Message-State: AOAM532vuib32Bi6kzAz7Yg+wHLUu/zXPnfS8esG+m1bzNSifnUaQed4
        FT0xML0/jreYESMLoyKJwdTSgwM6Hea5RQ==
X-Google-Smtp-Source: ABdhPJwJHpR7j+k9q5fB1R/HZHo1CkPVkXNi8Ml/nuZf16U8qmV4l9NzZKUscw4KqlK/EHmXvScZ2g==
X-Received: by 2002:a05:600c:d0:: with SMTP id u16mr294549wmm.155.1622559529669;
        Tue, 01 Jun 2021 07:58:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id b4sm10697061wmj.42.2021.06.01.07.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 07:58:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/4] futex request support
Date:   Tue,  1 Jun 2021 15:58:25 +0100
Message-Id: <cover.1622558659.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Proof of concept for io_uring futex requests. The wake side does
FUTEX_WAKE_OP type of modify-compare operation but with a single
address. Wait reqs go through io-wq and so slow path.

Should be interesting for a bunch of people, so we should first
outline API and capabilities it should give. As I almost never
had to deal with futexes myself, would especially love to hear
use case, what might be lacking and other blind spots.

1) Do we need PI?
2) Do we need requeue? Anything else?
3) How hot waits are? May be done fully async avoiding io-wq, but
apparently requires more changes in futex code.
4) We can avoid all page locking/unlocking for shared futexes
with pre-registration. How much is it interesting?

For _very_ basic examples see [1]

[1] https://github.com/isilence/liburing/tree/futex_v1

Pavel Begunkov (4):
  futex: add op wake for a single key
  io_uring: frame out futex op
  io_uring: support futex wake requests
  io_uring: implement futex wait

 fs/io_uring.c                 | 91 +++++++++++++++++++++++++++++++++++
 include/linux/futex.h         | 15 ++++++
 include/uapi/linux/io_uring.h | 19 +++++++-
 kernel/futex.c                | 64 +++++++++++++++++++++++-
 4 files changed, 186 insertions(+), 3 deletions(-)

-- 
2.31.1

