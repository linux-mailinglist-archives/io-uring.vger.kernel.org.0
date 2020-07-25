Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D528922D71C
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGYLoB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 07:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYLoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 07:44:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF28C0619D3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:00 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g11so741385ejr.0
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 04:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/ZMHT559HyIkp2b0Jgv4ja/z4eNZ5RzvZ15qstfIDc=;
        b=n1ov1dopmmDUAXl1kt8y3h4YWIplL5g1DgIggWlJHg5B1krwTOIlrc9W/nqK6O7UVn
         5w89R+AXMF+jQvPoU3jGc9CgO3BEJihOWXk7jIc5OWv4MvaicXcOYPrFK9bVG4tqaKpd
         gHzQJvZ2cozwB7J7HGreYdtA9ONi+/WK+/LlY1gKJ3rZy1xvcOBVpVGc73L9fWvpBTj5
         U9x1pGu4eUGJ/n8Ej7OxqAD6XWI2IqVFRRrUX4Eeol7txU+U3yfwDrpvCXeMq1L28/9B
         2kB1EG/ZS3s8WHDzODGXfYDENJTBMUnrd4mNQhAAqw3trkC75nFpHN01v9tH2wcV+xGj
         Sizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/ZMHT559HyIkp2b0Jgv4ja/z4eNZ5RzvZ15qstfIDc=;
        b=RZTKnIH9tU6jI8qcBnrcGnTCZhEniTo3z8ndY2xlygexesjFT1wSc5RZQp9UhX7v4T
         jND5OdKhVYZ2BpDWDH/K0GtFmQvRvfR2IWpUiPUX9Dk+5wmjkw6tyUkgU/enRUSyQQ2e
         0uHHEmwY1cgwUyW2CeqXGybRMALhJ6iGjVnO3Kc6BTY4wm6I3Mdh8mBfsJQ1eJHl30Zp
         iYOyq8po6D5czfnPnoAnsiAKpKbivDWHaINTkzNFEMKCeWABQMZnxnNTfTCUTcmuuvxt
         ARS0wqbzXuy5S9CdmYcB3TToUwzBiYgYO9EnPIpAqRmv+62RZGhdaJXcgJIyWJaAmpGr
         8AbQ==
X-Gm-Message-State: AOAM5302MCU8CqtanFpCiiWBlsfT5HDuXAVtbgIf21R4nV/9atqPzUjo
        P//SGYUZ1i6D/EucRyqAX0k=
X-Google-Smtp-Source: ABdhPJyBahhlkaAScqGauWV9tJ2+4jxc8NCVYTow1rVRqiZJNZ2I4RXxv20gNfGLt24ojxOklYNE+A==
X-Received: by 2002:a17:906:2b04:: with SMTP id a4mr12537726ejg.199.1595677438941;
        Sat, 25 Jul 2020 04:43:58 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id i7sm2743601eds.91.2020.07.25.04.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:43:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] 5.9 fixes
Date:   Sat, 25 Jul 2020 14:41:57 +0300
Message-Id: <cover.1595677308.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unrelated to each other fixes/cleanups for 5.9

Pavel Begunkov (4):
  io_uring: mark ->work uninitialised after cleanup
  io_uring: fix missing io_queue_linked_timeout()
  io-wq: update hash bits
  io_uring: fix racy req->flags modification

 fs/io-wq.c    |  5 +----
 fs/io_uring.c | 38 +++++++++++++++++++++-----------------
 2 files changed, 22 insertions(+), 21 deletions(-)

-- 
2.24.0

