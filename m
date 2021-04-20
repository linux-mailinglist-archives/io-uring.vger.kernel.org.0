Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3897536570B
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhDTLEO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 07:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhDTLEO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 07:04:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035C0C06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x7so37118622wrw.10
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UM5zJBv/DcKRe8ky9PJFteNz/kDR7TTcTKy3DZ50zqU=;
        b=vBkJKUi0kizWtbRuc92EBrFwGwqqT4vuybsFK6NEb5CXgObeNa/p9RVO0TvYTksJdo
         bduup41yXwWoWhjhg8kFq0eFqaLB8YEAuF17JRyYaSYlKlrmfwda9XFMvW4Uo65ZkVbp
         AHl9z0hX15kx5oQ03dGFg7nzEvT7d4IQVRRL6pCbi5V145NCz+a+sWzysSnSOPt4wH0+
         amcRLTPEUj5Kv8s5eS7b35uImqHWAcOSEoZI3GbARG+i8i7I/TPWORVHOvfjHRGYcDTJ
         I+XBa9p0P+QRBs7XXJudEq7Qp3uNqKx2gEZW8OkGiGKVHF4Gk2O/9RcOg2xiuxTYaeCH
         NY9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UM5zJBv/DcKRe8ky9PJFteNz/kDR7TTcTKy3DZ50zqU=;
        b=BK4dytiK0gL4VU4VkO+Lg9dDq1vTywcxSdowj9tKN0IDvUgP8CkuVAhYHq+LPXEHlv
         cd1a2T6IlyurRwsQMWOTzARGHIJU4p2l3knR+ZNCOvmoHv5mSiCLlt4n6H/SlsrrwCVh
         tRZp3RSYphyTYE3rrgxcqmUDD6R19NqrBfyxq5edwIgRLguWG2wjEn6wuYJzJK2h2jWQ
         49IwB7mM7y8pV3kRQ1QqqT0S8g5WVdb6dTrJ0j/zGXHluqf7yd7sUJvq38v9ezXXpYo4
         kX56sydtASj7NeCwPuVprl0vl00C5UnAu8Ygw2bBWiy3hlgz6bj5od2UsIzdIqr+LTNm
         aacg==
X-Gm-Message-State: AOAM5303Z9U27Ju1WGClb7gmyxQbdWsyMM32cw5rnTK64k8Rpfib5iBU
        fouOQg4xpeRlRP6lyYTRMyI=
X-Google-Smtp-Source: ABdhPJwaEG6Hh/oZfUmqsBAXdUN3ocUCHIIwO6E3DwYCoMpWmbKTxfkns4Q7Urx0oFRTB/LvjvTXCA==
X-Received: by 2002:a05:6000:1102:: with SMTP id z2mr20081331wrw.333.1618916621750;
        Tue, 20 Apr 2021 04:03:41 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.116])
        by smtp.gmail.com with ESMTPSA id y8sm12899486wru.27.2021.04.20.04.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 04:03:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] small 5.13 cleanups
Date:   Tue, 20 Apr 2021 12:03:30 +0100
Message-Id: <cover.1618916549.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Bunch of bundled cleanups

Pavel Begunkov (3):
  io_uring: move inflight un-tracking into cleanup
  io_uring: safer sq_creds putting
  io_uring: refactor io_sq_offload_create()

 fs/io_uring.c | 43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

-- 
2.31.1

