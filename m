Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B372B335B
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgKOKUf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgKOKUe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:20:34 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1D0C0613D1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:20:34 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so21041018wml.5
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M14tdPTF/PZcSCjZBCdHAoRRMkRAX8u0tgQrBe+hPVA=;
        b=bEhya+d0HSXRhHOFpq23DiOqJMOvtUViuPrGktKBqu+Cgu9MPA31bXgAe8i1/awznH
         QdgXh4fMXs3tW2bL9/HVXHud4hvBUHniOeZYJAILk0aZoedFcAu61LGQ8XCiOLpy8TRy
         eyriXLXjzXeOg2ZBJJ0SDhLfpnZJFiH/PTA43wcGPh93y/agvV32zlx7EFzJ+UTf/N8G
         eJ0OJMPgb2+wqtjz9HJqtRa4ysQGmkahT1vmNAj4S7rl7rVw6pefJqNT72l71k7SMtof
         7niyviuwb5IFa8VPxZ6gUYp9njnmWKAasK78QuUIlV8pkLK14RLPgE6Kk+h9c1kbVHTI
         Ed7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M14tdPTF/PZcSCjZBCdHAoRRMkRAX8u0tgQrBe+hPVA=;
        b=p/GnxRmvTHZcZ6h3gwYG6MfU3u5Y4KAa1QD9KJqX3grquNplT+jxOYoL0boOMvfkV9
         X+N2bg9F94rG4TN6hGVMkN9YLXSXtG/TCfq3fqWeV2qlOuztvrJdcpDhiTAAz9ezrSXk
         Nix9dcDHGpYnHSXBCMLUWIpr2t9xkjrTh1JPN1CoQ4fTWO8odqSZY+dMTPsrdbH+/7e+
         Rzj4V1P/pQi399ptF1MV5aQ3zQ/8bCcN0626po1D/FkIo0NgrAUsWz7BfycsH5CPDxl5
         PmHgkUL1q8A1D/2At/HNKkkTQhp6EeQkmvDOLNzKFq5oC5FUUJw/O9QRq5fBit3SDonQ
         UIXw==
X-Gm-Message-State: AOAM530gd0HHDeukpQVY3xEo8tJ6EeuZdC1BqbaxYWaG2KOOqCl3e2qn
        9mrT8ed1KX23Yfc9sTK7kHS3znGTZd0=
X-Google-Smtp-Source: ABdhPJz90UEjUGfXmum+102xsesl57fggc1Ety55Fi5fi9qas1El+owSH6+/JQCiqMcpCxSAaH900g==
X-Received: by 2002:a7b:cd99:: with SMTP id y25mr10168782wmj.128.1605435632640;
        Sun, 15 Nov 2020 02:20:32 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id b14sm17746961wrs.46.2020.11.15.02.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:20:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.11 0/2] clean up async msg setup
Date:   Sun, 15 Nov 2020 10:17:16 +0000
Message-Id: <cover.1605434816.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This refactors sendmsg() and recvmsg() msg copy, async_data setup
and its later use. Also deduplicates a couple of things helping to keep
it saner.

Pavel Begunkov (2):
  io_uring: update msg header on copy
  io_uring: setup iter for recv BUFFER_SELECT once

 fs/io_uring.c | 83 +++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 42 deletions(-)

-- 
2.24.0

