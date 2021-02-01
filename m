Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105FF30B005
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 20:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhBATEb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 14:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBATE0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 14:04:26 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6682C061573
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 11:03:45 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id c4so15113963wru.9
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 11:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wbPRte9mnUvJSGIm0SJSbFCbP5EE6LqwiyIb4fLskmQ=;
        b=cyPuM2rhdIyeS7En7IcGJQM2oWKK69xrhTWNor6h9qeeYw8FtxmAH2k45OM1dLYBUT
         x0KKTJkTLiy9MAfa1yuqPA3ZTKjlCFS15QArk/AJT8N7d+zk7BCCTdb2zheBD1v7rEmV
         AsyrZ5agRFC/jmdz+WLLb7R/eka1pz47Wf0ykwxlKbmYGgtux9N3TdureojRTZFgLCkq
         3AYYA/qSjjmuF4MwuDbVUGRtQHGYm/1S12u3YXH8b/MckRbAs9ZtwtjFynFJP46xTdcT
         wAL0zUpNqmOdjoJUQl5P939R1M6C9m6wUe/41KykONcXWs+MbAPD14KCFabDY8In7t4J
         cfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wbPRte9mnUvJSGIm0SJSbFCbP5EE6LqwiyIb4fLskmQ=;
        b=SPYJoKO89EBbmaeFwHE6u9e22ynTlYNprRP5+Qrx0sHkcA+RYGZmcC9QnIq4QS3OHD
         ndj6ks+UPJoFduJfxg4qh5bxL7RwLe2/S6DCdwN54TwnQC8r+oJIt+iukHnkjVHpe22K
         9NyCbkvcKTi4ElkEXKb9RagppLEtqH3MIpVdXlexq6V9I+7rgCVWdPwSb/trzR0ll8e1
         EM+8++c32ZU9Fopb0JjWkjJek7GMZZlSQVpAj0rUHHOT4hQ5slI3J1iN7Iw76IYNZCqN
         yRtZ4BLTttYMU16r1QMupzk7u0BMwM+lIabeQyGCYOkg6T/8s4/StIjiaJZOHnbCjTJg
         uyXA==
X-Gm-Message-State: AOAM532yoVjq8nrT8f/gKtJChd1PZzWTB2SZX3QNEzmQi8PszsoW43Ty
        L3grW59GstPzzWm8dReYH0M=
X-Google-Smtp-Source: ABdhPJxy8vnkpXENrrtC6Bm4r4iiCp+fA5vgQqHbDVmghTulagwRBUW8C3+XfUQjTytF08l8m39A7w==
X-Received: by 2002:a5d:6a10:: with SMTP id m16mr19591287wru.220.1612206224513;
        Mon, 01 Feb 2021 11:03:44 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h14sm182728wmq.45.2021.02.01.11.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:03:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/6] for-5.12 stuff
Date:   Mon,  1 Feb 2021 18:59:50 +0000
Message-Id: <cover.1612205712.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/6 is a for-stable fix (syzbot).

Others are the first part of 5.12 hardening and random cleanups.

Pavel Begunkov (6):
  io_uring: fix inconsistent lock state
  io_uring: kill not used needs_file_no_error
  io_uring: inline io_req_drop_files()
  io_uring: remove work flags after cleanup
  io_uring: deduplicate adding to REQ_F_INFLIGHT
  io_uring: simplify do_read return parsing

 fs/io_uring.c | 119 ++++++++++++++++++++++----------------------------
 1 file changed, 53 insertions(+), 66 deletions(-)

-- 
2.24.0

