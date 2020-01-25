Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6E149790
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgAYTyc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:32 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:37112 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTyc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:32 -0500
Received: by mail-wr1-f49.google.com with SMTP id w15so6133494wru.4;
        Sat, 25 Jan 2020 11:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pB7UN8ZNyEDMSk8Y+JG22bv0njEEqIZh39ZLWw6SiFU=;
        b=XHYwEsXZ8aEHZ3lToYcBzM7jXQpbmLdD+acyKgLB1620pluMiMNY3OjZUoDrgIi9ks
         d9dCJXGnVeBna8eTK/iZENM8mIRqJt4fnMnuYzo2lPu2IE5tkbmeGJYGZ/yVJzAKCuBp
         D0w68Gr5rAGcFq8GanrETHBDxoPPdU6GWpP4yZ75OTdsRocLA2xUaYxVLqTXjaaEQPXj
         m2sgcFHT4r7hhL2FeXPPbVyJDapiDJzls5YOd4MGwkrsVwrqdgi8Y2zZMyHSoUXoLHCv
         2XoYDhu0iv5YkSlvEo/yL5eaGmfUe/Vdjt/Kex5+L3fAey17oJDwg+89nUuAvwpkRcvR
         w+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pB7UN8ZNyEDMSk8Y+JG22bv0njEEqIZh39ZLWw6SiFU=;
        b=sBf5ssE1Jw5E67AK5O10CjfPXapvA266XZydETcyTZOs58tRNo4mSmD+rs2o4tdKT6
         481n4D2+rIdXdnkrjre8ZwC4pzr6wQldZnjphBBVdvHtazyRkkRsasZI5qWIaGSuIRSZ
         zCcJrSbgxXPLCairfqTOed6q3Ey+NerFotuxcqmLGjTHWZooe7wkFCBTdZsiP9ev2YrB
         dfSHHObkiI94wGFBdC2TRRmdscWd8bUeGLEiZ3pbS/7B5xaMpfh+KGpCQhorb3MCv40w
         XOVtfxWxYkz26OxOXPkCGGWF/S0AA9guakOyZMT9PGXg5ToDdJ4qIZP3GcisSl2rhm77
         k1og==
X-Gm-Message-State: APjAAAXCZm6EiZOM3mX4llV8CtGH8gebNfbSD/aPPgMnHGagP2vjMDty
        IMkUm5dK4L/kHsXih/Bmj2k=
X-Google-Smtp-Source: APXvYqymvxsm3O3qtufCFQT0KnZLMducZtIrPqt+xlEY4pr6wdA+Ba6XXhcN67+hmsHq3ZIWU7lt3g==
X-Received: by 2002:a5d:6852:: with SMTP id o18mr5387107wrw.426.1579982069879;
        Sat, 25 Jan 2020 11:54:29 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] add persistent submission state
Date:   Sat, 25 Jan 2020 22:53:37 +0300
Message-Id: <cover.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579901866.git.asml.silence@gmail.com>
References: <cover.1579901866.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apart from unrelated first patch, this persues two goals:

1. start preparing io_uring to move resources handling into
opcode specific functions, and thus for splice(2)

2. make the first step towards some long-standing optimisation ideas

Basically, it makes struct io_submit_state embedded into ctx, so
easily accessible and persistent, and then plays a bit around that.

v2: rebase

Pavel Begunkov (8):
  io_uring: leave a comment for drain_next
  io_uring: always pass non-null io_submit_state
  io_uring: place io_submit_state into ctx
  io_uring: move ring_fd  into io_submit_state
  io_uring: move cur_mm into io_submit_state
  io_uring: move *link into io_submit_state
  io_uring: persistent req bulk allocation cache
  io_uring: optimise req bulk allocation cache

 fs/io_uring.c | 219 +++++++++++++++++++++++++++-----------------------
 1 file changed, 120 insertions(+), 99 deletions(-)

-- 
2.24.0

