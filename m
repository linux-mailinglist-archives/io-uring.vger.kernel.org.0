Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2A42F4B9B
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 13:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAMMqt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 07:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhAMMqt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 07:46:49 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8AFC061795
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 04:46:08 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c124so1457121wma.5
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 04:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H1P0YzsypAQQDbhCyUwDqkDHsD76lNYeiYvNr0VMXZI=;
        b=sXHZsvonyedMNiuTj+FuWMzd9LC2HIVQ9eBCLq22UaZ/1xmdYoO/qNaz21S6XCCE77
         GVdp8Wf1bV4igVsi+QVpuOH/0pb7G5fPHavCPKVUI0K0s2tykJKKS+bZET1WOf4+Ls6l
         tyP+vUltIureyttmRmIHNGY6c1BkSLLdZwHoEXT5zIaxAhWzhvRMvVCKzUkgE3z2lY5i
         3fplCetaPDcPoTcX2pHM/tDUYc92zU6Lc6qCzlrZixEaafTsrkSMZpwGRqvF0zyiBK52
         tYwNwnXCTlrEaV69pG+iDFjVGwU1UuBHUNpNjCD/KMVXbkdVmaPAljtqIDIID58M5jX5
         IK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H1P0YzsypAQQDbhCyUwDqkDHsD76lNYeiYvNr0VMXZI=;
        b=i7Bb//R1n5n7rr+ccWvaYwVF3vki7nMDDX90Nxfr4b+39EVyqFDsh+UtYUwt/XmsL9
         riu8dKx+gqR9Y7BSk9LtLfaQtygvy5KeIPeJ+xZPjMBJvExAX0JNi8OGMUeFudLABBrH
         OIrI6rpSWSXyOz4yX9ebgNE0y+OgLd9Jy6rrkLAvnkcJjRydhGH0bi08n6s3Ivl9XVJh
         Lc2/KjgTqPkSUDoNBVpIyHwg++w0inEvcbq2UIllYw7Jw6T3zREsiMlFMudFPpFkO6jO
         uPXPyPzidWezOmqeG2qsBYgykhGAPth3GZ+iVdFexepGa8DS4bs7mt5w3DRv0JOe2AhT
         8AjA==
X-Gm-Message-State: AOAM533Pb8MVJPIVjhDoH9tiLZB/wMDnMl1vqV1pV1MUPrFOCM94ZVHF
        aOFDJDHVPuYSUl6Cv5NUw+lzaouqlp1lqw==
X-Google-Smtp-Source: ABdhPJzfrL44xM9dLw+KmHAh9rOgBlDEw/fRwNVt+yM/yQ6pvWO8rH0nSjFvh5n1ZrdgOyVab07KHQ==
X-Received: by 2002:a1c:2cc2:: with SMTP id s185mr1169560wms.36.1610541967372;
        Wed, 13 Jan 2021 04:46:07 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id j7sm2835764wmb.40.2021.01.13.04.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:46:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] syzbot reports on sqo_dead
Date:   Wed, 13 Jan 2021 12:42:23 +0000
Message-Id: <cover.1610540878.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It deals with two ->sqo_dead related bugs reported by syzbot. 1/2 is for
overlooked ->ring==NULL case. 2/2 is not a real problem but rather a
false positive, but still can backfire in the future.

Pavel Begunkov (2):
  io_uring: fix null-deref in io_disable_sqo_submit
  io_uring: do sqo disable on install_fd error

 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.24.0

