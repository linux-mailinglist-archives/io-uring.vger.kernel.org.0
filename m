Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C86417428A
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 23:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1WyH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 17:54:07 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:52498 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgB1WyH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 17:54:07 -0500
Received: by mail-wm1-f51.google.com with SMTP id p9so5096206wmc.2;
        Fri, 28 Feb 2020 14:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UboDU9Ej5tW2nx/yEIvaM0e2XXSDSBexpcQy2rl6/ZY=;
        b=sov6ePTi4iwbWlheqBYFidwE8Fh+EVBEm2mEGjkOuZsVQtQ/ED2kDFkLiY3eoWj0GK
         pZVeMwxbyJPBiPfVc26P5M2Ql5L69+h+pkY8IO4jSRVhIil34fS17Xa27QkFSjdfO7j+
         x7z6TRbSLqBI+p6mQRyPaZZVYgD+kzqFr+4t8v45DXd0k5QbqOfYBVn1t7B6GIdzw1g2
         zSc/oYgVJ1cy9DlyAF+BmYjBRGC3nftMgA8mMsaSdnA0VTpcCGjzYRWk8fIV4+Ro1Kcj
         GI/nNiyca6uN5LOEYV+sVCQUiTWCpadg5XZbb3wlst1iYzmj7ij4GXImV3uS+UAv9S8Y
         vfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UboDU9Ej5tW2nx/yEIvaM0e2XXSDSBexpcQy2rl6/ZY=;
        b=UfVRBB6Q0J2Rl6+cSdbGEwAnWbfL81ZvoQV4t3ORtt0Hq18gyeEF1BkSNvGr6Os9Hg
         g1ibVquAwz7ikWIYGj+3LLcDOTRH1GOR7LRC/XNqiCdeBH0X7pj47120+A2mesA8iJyn
         3nPgY3HD6exDSNJyDz6BRJ0mpYIdN/g4KK2nh831XY/fN1z53hpUIyWx/Yb3YY8SH1sg
         7sGTCdtJqTzC0CpEsP3tkXAbP0C/OTxR32Ai9JA9vN4cRZ42Q9OmIRoLx0Z1wJmCBd+0
         2q98sO0Pw/0IF5r2T/5gTDdCevg2xsTYE/Loxj0m4QIaQq7BROKYxa7mx9LUH/n4F4Fc
         Pz/Q==
X-Gm-Message-State: APjAAAVmBbygcPpEFTFqhv4nCWnxoHacpnLTeKkuylOAv14/PMOmqwRN
        nT0Jt77qLCUQvVpgvMLn00T8TTjk
X-Google-Smtp-Source: APXvYqyFcdRsSZAGuSTp3co+jN4UFYaw4G4x2fTqCXTrEQnEw5LK+dwElUwaHYRMNYJx9GRbNHTYqQ==
X-Received: by 2002:a05:600c:114d:: with SMTP id z13mr6670849wmz.105.1582930445580;
        Fri, 28 Feb 2020 14:54:05 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f1sm14603773wro.85.2020.02.28.14.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:54:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] return nxt propagation within io-wq ctx
Date:   Sat, 29 Feb 2020 01:53:06 +0300
Message-Id: <cover.1582929017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_put_req_find_next() was patched, handlers no more return
next work, but enqueue them through io_queue_async_work() (mostly
by io_put_work() -> io_put_req()). The patchset fixes that.

Patches 1-2 clean up and removes all futile attempts to get nxt from
the opcode handlers. The 3rd one moves all this propagation idea into
work->put_work(). And the rest ones are small clean up on top.

Pavel Begunkov (5):
  io_uring: remove @nxt from the handlers
  io_uring/io-wq: pass *work instead of **workptr
  io_uring/io-wq: allow put_work return next work
  io_uring: remove extra nxt check after punt
  io_uring: remove io_prep_next_work()

 fs/io-wq.c    |  28 ++---
 fs/io-wq.h    |   4 +-
 fs/io_uring.c | 334 ++++++++++++++++++++------------------------------
 3 files changed, 146 insertions(+), 220 deletions(-)

-- 
2.24.0

