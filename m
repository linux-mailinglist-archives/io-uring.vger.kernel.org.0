Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BD51ED2EA
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 17:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgFCPEx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgFCPEw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 11:04:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F1C08C5C0;
        Wed,  3 Jun 2020 08:04:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t18so2744247wru.6;
        Wed, 03 Jun 2020 08:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EaI/fPBCqtkjskO1ZBg7tXxR2YCOAFVkYGl0c5GySBA=;
        b=UkTOTjt2iVxyy5z12tFFzhqmWEI5nvNXi5R8xOTYNa0136A2hIstiFVc5VWgwM6J5E
         mmo6w87ZKhpHa/RJsBRZ2Epyi3I/rM+HRwfmKvAcJmrBM2Acj//56G/ytCVqlaeot7NQ
         6jzLWh/dnujkmYQC2vHgsJKdDm08iKfgxmklW93x7WntvdF5+NwnTY1uWNq5lXKcAWfM
         kBRCmKlVeEqhWNbtugTinYDQ/CkyyVkeMjrw7fAksfbXi5F3oLSaDvOWxBbZ5r8bQt3d
         pg7MAj4sJQWANVgWuQ2I8LCpAGrdt3uljIcXHV60+2WVTZ4vfWMOMRoDek5PP7dBldqv
         6JUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EaI/fPBCqtkjskO1ZBg7tXxR2YCOAFVkYGl0c5GySBA=;
        b=hAWrZMN5YlswcJphFaX1F5LmwC325xAOTWySUjf0N1Q9Ygk73CgOaxnbdwnnkjpDQB
         1PVte6t7Ge0aV987oQW1oUGC/oTNg+gzrQRq6A5hFvnllOKJZ28JE/xY/9buGDxVl8pO
         Vi4S3qEOFS/0sj1+WGJGH5qrLOwyRyeT0w5FYuq4OyGTMBbra70Ab6dMmH+fq1gp86fe
         rFsrnjB2Sh0IzGibz4wvTEa3w3RKHyrPX9G+OFJ/RwVcM0mcqyq5RxQ9chwM73ghWByW
         CUNfP/rKqMEM4fNO/zRD3mRRHTO4S2uLMXmBB/VRt9SEJrZRI2QbiJm62mJg8MeFr0Lu
         1YCA==
X-Gm-Message-State: AOAM530g7+uflI+y4sbYiBUU4BeMGMRbgcAkE0wTVVCVBxKlkH44svPR
        6YJwxi6tCfgipuqf7W1OtHE=
X-Google-Smtp-Source: ABdhPJwnYRwOyV1Foxw39sJWShmFJj3RAqDNa8b57N4ISepVv+5I9v1Gbc1rJKjRc3xSJk9bbWefzQ==
X-Received: by 2002:adf:906e:: with SMTP id h101mr30772799wrh.221.1591196691316;
        Wed, 03 Jun 2020 08:04:51 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id f71sm3074808wmf.22.2020.06.03.08.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 08:04:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] forbid fix {SQ,IO}POLL
Date:   Wed,  3 Jun 2020 18:03:21 +0300
Message-Id: <cover.1591196426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
moved in the common path later, or rethinked entirely, e.g.
not io_iopoll_req_issued()'ed for unsupported opcodes.

3 others are just cleanups on top.


v2: add IOPOLL to the whole bunch of opcodes in [1/4].
    dirty and effective.
v3: sent wrong set in v2, re-sending right one 

Pavel Begunkov (4):
  io_uring: fix {SQ,IO}POLL with unsupported opcodes
  io_uring: do build_open_how() only once
  io_uring: deduplicate io_openat{,2}_prep()
  io_uring: move send/recv IOPOLL check into prep

 fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

-- 
2.24.0

