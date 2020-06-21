Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7C92029FB
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 12:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbgFUKLe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 06:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729687AbgFUKLb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 06:11:31 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC34C061794;
        Sun, 21 Jun 2020 03:11:29 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a1so878521ejg.12;
        Sun, 21 Jun 2020 03:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=syU+EghuXe8/msbRaVp9ADnfn8XMm0nVNqlQ4ZjbmLQ=;
        b=R7x9DFd+URt7M5W4fNSWOLOH/mpvW5rznedMB/MoHTDxPzi1CdgyZLiinplwvNr6vQ
         N87HuWSET/GMoX2StOrnqVescYrrhXUaHEFnNUJlc4dgUWw6W8jsZSt1a6dstGu9aFS9
         TcO06FZm8muJ4a0qXzxUGBfs7IpkfKOWZWCv9e5KXNsZ9Y6+YxjsdRnyJ9Kh5RJgJo51
         knXNaumqT+g1jkASUpKMZPq+rf7plOCv3Q9alJrQz18/zEZ+EujWaj+N/sQA6yPEJ/L4
         dyWRGVS7dqKVzP7J6YhLVSDm6KeU576nAdAVAD+hG3Q5gH952e/o5WR4JzLePlL9nZME
         ckjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=syU+EghuXe8/msbRaVp9ADnfn8XMm0nVNqlQ4ZjbmLQ=;
        b=D+TV+Mws6DY39yjaukgz0ZM5KXgoAIjJZ1Cu9oD+JhyDbCpaQLBJ0Yo7y531M/HAgM
         Vmm+VNZUYGoaJ6fa4iqnCUSMwHOCxkobPJ+YPnUCY4je0SRORh1GeK3ikJx3wW2kO7G3
         3K8Dz2RlbqpX5xQwjlgTESRxjBaUwAdMewXhDyPH5Tbd2I3qZ0ITJgYg/9VKrziEgKlo
         VdYz8M0sJOKB9mxuBsH/LQmPwsyRpIWwuESXGGfvDZjIDaNHqr3/97G7GlSfuH5z8idx
         uvCN5hpnpG/5ZcE1h7AdMw6uaxAuQWGw+cgl/aMmv6061Al5dGoZqX3g+SG2tmbVJxaS
         XRVQ==
X-Gm-Message-State: AOAM530AUeUtQKbSS7X9p/+BvWTeBoFYU3NmC+FmW2WxFxCQghwvcMu+
        7ivPAmXSV4xsrowfuBGsuQTr22qw
X-Google-Smtp-Source: ABdhPJxSu/CHgpoPPGMxHtVHmLTgIb8gzCD9OnuYTTJADsNRs3SWD5Rp3RpJ37UdfwOIjcsHBV0ZKQ==
X-Received: by 2002:a17:906:4056:: with SMTP id y22mr10862835ejj.304.1592734288123;
        Sun, 21 Jun 2020 03:11:28 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id y26sm9717201edv.91.2020.06.21.03.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 03:11:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] small random patches
Date:   Sun, 21 Jun 2020 13:09:49 +0300
Message-Id: <cover.1592733956.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nothing interesting, just killing some stuff first.
Based on top of io_uring-5.8 + 15 async-buf patches.

Pavel Begunkov (4):
  io_uring: remove setting REQ_F_MUST_PUNT in rw
  io_uring: remove REQ_F_MUST_PUNT
  io_uring: set @poll->file after @poll init
  io_uring: kill NULL checks for submit state

 fs/io_uring.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

-- 
2.24.0

