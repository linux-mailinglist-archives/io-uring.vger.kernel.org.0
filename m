Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90862C7A2C
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 18:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgK2RQK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 12:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgK2RQJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 12:16:09 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1948FC0613CF
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:15:29 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s8so11952852wrw.10
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJUC1073KwpGwSk532k5A5AbzQysgZmV+hqxrOlbwUo=;
        b=u7mejHkYRqpDxbvqqfDaPx9ns9JepEch7yfk4ZF8UxZJFwiEheQLIryw2JUYq3AoJI
         s6ucsWkPjyze62MZ9uc5yJGUbOzHa7YHIncS53gFlT0SsvLI//zJ1zvINqPnrg6+oqaP
         3dhqyxwn97eM52rzCdj4aGe1r/LPCEs9QipWIIOJJ75gNCfSW7t3+2/huptTUpnJzpJ3
         ymjY9OLkHjnqI87PHyER9m5VpJ4Q5C3670YLz0psIQveeDND02w6TWk6xCrE3QWMSvIm
         M167vz30dTZO8wDnyP2cLMI3Vg/wzCGmTDc5nPA9wts/rK9BGSRrQV38FTl8pILa/pMh
         OwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJUC1073KwpGwSk532k5A5AbzQysgZmV+hqxrOlbwUo=;
        b=dbm8idgKrOHvpxDE/i0cNuwBPRapkmcpDg4Si+d0IJZCBAen2p5nZTJPbN2RlhsIC9
         TquvQDWqSjwsYo8wcMCPwz6/TQCvNiaBrYvSOtiuR8ybg0ZFccATaQsVR0hV2qaSKKAT
         iG3EAIwHyHnBXY4pKHgR1nTkMwcfcL43Mo71izTaxqQQwetBFioUVC48AktrhEsXgX9+
         Nu3Xo+89V0kzmt4vc8IpLItJaIC9/8kMCNksolgiYN0b5JuxwG1ko++uXrMPvanV86v8
         ocjtQ8ZOthhT4+2v5nWalehn70OYLKK1rFK0MTdBfFCs4mG/vawKarSAYd4XfMvUZu3o
         tB5g==
X-Gm-Message-State: AOAM531oeOQ2IcyfbJvONayU1l5ZJnSWQ3LpNi4UDH8Z1a9jL24KsElx
        G892rdy+K6aTmbxj1COAqvkjsfNloc8=
X-Google-Smtp-Source: ABdhPJzwFZW/g6gL/CtAbhn3nXXDWPdAlh/yw/C8g5FkdD+sM3dtfgHet9mdnuvY+dNogyaSBPtt5w==
X-Received: by 2002:adf:f2d2:: with SMTP id d18mr24083841wrp.302.1606670127110;
        Sun, 29 Nov 2020 09:15:27 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b4sm23312035wmc.1.2020.11.29.09.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 09:15:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] implement timeout update
Date:   Sun, 29 Nov 2020 17:12:04 +0000
Message-Id: <cover.1606669225.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Timeout update is a IORING_OP_TIMEOUT_REMOVE request with timeout_flags
containing a new IORING_TIMEOUT_UPDATE flag. Even though naming may be
confusing, but update and remove are very similar both code and
functionality wise, so doesn't seem necessary to add a new opcode.

Updates don't support offsets, but I don't see a need either. Can
be implemented in the future by passing it in sqe->len.

Pavel Begunkov (2):
  io_uring: restructure io_timeout_cancel()
  io_uring: add timeout update

 fs/io_uring.c                 | 90 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 71 insertions(+), 20 deletions(-)

-- 
2.24.0

