Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6981E204363
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 00:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgFVWSR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 18:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgFVWSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 18:18:17 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1E1C061573;
        Mon, 22 Jun 2020 15:18:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l12so19577994ejn.10;
        Mon, 22 Jun 2020 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fFefmQtm/yGDL3KNRZLYpoPVW1HgBh8SHc0jxMAqabA=;
        b=bOf7by4F/Qo0wgYXg4O4C6TcKy4OyfcjYLybNt1i7TNWOiAnTMn/MJFG4+0GK+vxyu
         dc4BLAO1KXF7q2xnIUxPIdcrdJSE7sJzgnDMFDJyb8N9YDj++gaxtlkLkZRHcg3vLezY
         tAIOvGTSOpCqMk6Fml3mBrc5CgLk8ZqLTyE8YixJ8jiixWHjR+hu+bT+CAP+2Uk5/9cg
         5Q5RXWh4rMupKVITCpGexfIwa3BvcN5F62jGqT0XCNKPgnmYQz6z3h0vlAXSFmCeY9vl
         uUp/G6ddHde23BD4W6htFMiBtZTCY2f5WLwGAidWe7Ak+XNU13lO6NL0g2AtAq31Ptyu
         GURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fFefmQtm/yGDL3KNRZLYpoPVW1HgBh8SHc0jxMAqabA=;
        b=g2nqpseLg12cBbcBz+Qrmwot2Dja2ocmEDhkcxj+BRsOx2eTEoJFc/Ssn3ZBPI1cC2
         gkN1jB+KaD6y3rqI2PHw+gmSILn/8NqrgAtFhUlI36XWxDP6RmtcSsMVhkYbiVitXonm
         MBKHnX0Dv7pocz3vpSpwBd0rXqHxXVuIoUzeAr5gg+I3vbGoMmhqudBPkVfoLp6uTork
         /whapSYcXlffbTrouVahR/Uj+B1aMdQFadNGG3mbRJxC6gLrf/iRS2jHQEMq+AKlU6p1
         hgpr9LsZzuaMlKKrDw0DNug5VC8oYrIzP7TldF0xZI7wE5AXLXmci+KYG1QTKMXrFKel
         gnlg==
X-Gm-Message-State: AOAM533E5er329119u/wZZRvao1ULuX4v4WVvKhGGKE2WuSHWb52D12S
        DSy4xQW+NdkPIdB8IyEiJpMQ19TY
X-Google-Smtp-Source: ABdhPJy/pGu2MfSGc9DZA57E/DJlW8BMfWArrEv189ahxHqhtCn1lfuKUdOUY3qBMVlrUMbTyeoA+Q==
X-Received: by 2002:a17:907:2052:: with SMTP id pg18mr16759552ejb.513.1592864294018;
        Mon, 22 Jun 2020 15:18:14 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id dm1sm13314421ejc.99.2020.06.22.15.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 15:18:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] iopoll fixes + cleanups
Date:   Tue, 23 Jun 2020 01:16:31 +0300
Message-Id: <cover.1592863245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[1] fixes a recent for-stable patch, should be for stable as well.
[2] fixes getting mm from a wrong task in iopoll path.

[3,4] are unrelated cleanups. I don't send them separately because
they may conflict.

Pavel Begunkov (4):
  io_uring: fix hanging iopoll in case of -EAGAIN
  io_uring: handle EAGAIN iopoll
  io-wq: compact io-wq flags numbers
  io-wq: return next work from ->do_work() directly

 fs/io-wq.c    |  8 +++---
 fs/io-wq.h    | 10 ++++----
 fs/io_uring.c | 71 ++++++++++++++++++++++++---------------------------
 3 files changed, 41 insertions(+), 48 deletions(-)

-- 
2.24.0

