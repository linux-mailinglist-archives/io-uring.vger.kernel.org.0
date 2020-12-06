Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFB82D0502
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 13:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgLFMz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 07:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgLFMzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 07:55:35 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0035CC0613D0
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 04:54:48 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l9so843035wrt.13
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 04:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OY8U1CcPv598NEHoH6Yswxo2COVZK7AXTAhT21QzP9M=;
        b=Pf+uuEdZCeR77v+p/xUmv2b6XAWbpQckU4IBlNo+YeBpmSZB61Gh6kkR92jNBxSFmJ
         Nv7+ZjV0e/HGJY28qafQ9ElppFbRVqMMT5F9sjYM2dy+2p6J6xC3UvSHOCbR6hr5eBfm
         OVwqRRxCdEmX61GkB5/3yajAvVoz0bz+qcURDTsbXxHTS0JbdJmO35tAS5orx+bVPc8l
         GvTncomfG+/Ix6pJ1ft1Vy+Iou6bttoOgZQufuy1tzTOFD7Lb9/m+it9d+MuaXaTOfW5
         jwDstu9f1MqEhS4CvBvNOeX/WXl/UGY/nagYIiqRkmhG0+oZNpxkXOZ54YBWnMWJv+Jd
         h51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OY8U1CcPv598NEHoH6Yswxo2COVZK7AXTAhT21QzP9M=;
        b=YiZh4aDNnZ5KdVxNCU9kSjndVG7h2ePgBxbKcfUNMp9rLSvZhlFgmETBGTkUfOPIpc
         76aGCk9N2C6c2zSPnDhTsmNrAeeKdmfs0NOhbCNJZ11/jtP1Uz3yqs8VEHR0ifXv1u4d
         l1rO1YIYHHw79x2xiTs8EOy14NI/tEmYBKVvE82ljcQxVVIJLMb92eF83gdL/C1hxOwu
         UM1SQFUeYD+YAt6O+FIrSFLXTgj/Mdrgio/LJfVBFqC/OPIPO/PhKQGr9ufU/9OLVWF7
         wYk7gVlsL5YbQoKP84Ad+QDqsFnXK+3m6ubvPBCwyjGxaynQFj+KEibS6Wb6ks9bFPEE
         tCkg==
X-Gm-Message-State: AOAM531IGYXneDKfX+vw8GF9H/oswr6ZehW+OxucRW8OZ95xgRM2RLD6
        zWVqgRo7iYsFkhsYQ63NZ4nGe8b3TqIC3Q==
X-Google-Smtp-Source: ABdhPJznuiWLNcWHA2+Gwn1JmYZawA96dou+ZfF/LdwAnzCT/0kTU+Dk6U0GQ6OhAnSenpujyfTSGw==
X-Received: by 2002:adf:db45:: with SMTP id f5mr5565199wrj.153.1607259287639;
        Sun, 06 Dec 2020 04:54:47 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id j14sm10590632wrs.49.2020.12.06.04.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 04:54:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/3] test reg buffers more
Date:   Sun,  6 Dec 2020 12:51:20 +0000
Message-Id: <cover.1607258973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test registered buffers with non-zero offsets and varying IO
lengths. The first 2 patches are just cleanups for the 3rd one.

Pavel Begunkov (3):
  test/rw: name flags for clearness
  test/rw: remove not used mixed_fixed flag
  test/rw: test reg bufs with non-align sizes/offset

 test/read-write.c | 111 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 82 insertions(+), 29 deletions(-)

-- 
2.24.0

