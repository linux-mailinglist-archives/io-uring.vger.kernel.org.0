Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F022B430D16
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 02:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344858AbhJRAbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 20:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242859AbhJRAbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 20:31:34 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E278C061765
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i20so62979009edj.10
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qRqYsSnWG8rW6IIPaCDgTUDcYJThYA3FEKeMfma/0uM=;
        b=mahriUgv+6uyKS9KZg5UGGZswEncB/41/WZD97I3C3SaMPD0dvxAjckyDu4hvcFqpu
         1gxgGdqU96OO9U9d24u0m37EZ/+OTMarRLESjGmwVVGjFRonl3P0SAyNjl8no48o6QF0
         IpGOPDizbskiIDC+DPM0jksy/TGP+BUH4Y0zAwqqjGTRTwFzXTiMtBuDa8fGds/rqp4G
         2P7mLWhMakpP92YjHAVNmubkXUu6xR888LL00j2+wnoqBvS4qBX8A5D3qgQXJoN6Rxdf
         Pfre+nlO/+L1s3MstX1NhlD0z90AdmnVBLQ4m9ZNBMya+qZ8H1QFzuFTN6Y75MFvIn8q
         v/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qRqYsSnWG8rW6IIPaCDgTUDcYJThYA3FEKeMfma/0uM=;
        b=GWSMv5jcdB7sasCb7Wk0dbNUcPq+WVc7k+TS0CU1dEqvfwuupnSz6N5zWafj6aJ5HU
         w6RVxSXZ1I0fto4ajHSwIiDUg01DONy3TxOoH30RhXUjNER5vI4JGvxRC49ee/H9puvd
         KRuj8kqI4YgVQAv7taf0dOHm0GPzQkOGGvKR0r5wTfWypoRC2vgbHICsgkNOmFOi1N0W
         wCdTp2qW25mMvQN6VwnJZpor7R6JSjke4YvZAGEBpogTBNHhbUuUomoYOxSQYDIHYBZB
         YahZ2VN17oHevNSV4c+71x3uvKtm/A28DKOlReY96JPlJD09U9mDMe5yPL/1vVYuSMBX
         4dXg==
X-Gm-Message-State: AOAM532U1VcL4FbUMeXN1ucSEcMQ8QV9xHiSl0mX/5pwYCBwNLOVtA/4
        x/oiS1Qjc4UEiv47ZyO1CyFK4/hhxbPl0w==
X-Google-Smtp-Source: ABdhPJy0rVLY8Bz9pJoGjSht5VTM2iLELlpzuzCUVuj79ABi3TdXhDqKXHyaCLh+qhGzyIUHyqCikw==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr40469198edt.177.1634516960829;
        Sun, 17 Oct 2021 17:29:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id q11sm8881489edv.80.2021.10.17.17.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 17:29:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/4] for-next cleanups
Date:   Mon, 18 Oct 2021 00:29:32 +0000
Message-Id: <cover.1634516914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-3 are simple and easy. There is more to dicuss with 4/4, but
I think it's cleaner

note: base on for-5.16/io_uring + two recently sent fixes

Pavel Begunkov (4):
  io_uring: clean up timeout async_data allocation
  io_uring: kill unused param from io_file_supports_nowait
  io_uring: clusterise ki_flags access in rw_prep
  io_uring: typed ->async_data

 fs/io_uring.c | 127 ++++++++++++++++++++++++--------------------------
 1 file changed, 61 insertions(+), 66 deletions(-)

-- 
2.33.1

