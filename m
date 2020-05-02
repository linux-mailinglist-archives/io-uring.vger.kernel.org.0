Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381BF1C250E
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgEBMKl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMKl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:10:41 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCC7C061A0C;
        Sat,  2 May 2020 05:10:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d17so14983515wrg.11;
        Sat, 02 May 2020 05:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJlyhcAhYMixlcJSF8vt+n4ES0FGQmrD3QGfxwqt3zI=;
        b=PQzYJ9ix6jV9aU5NI5U7YFAX6vy8MEnu5LTAvyPNe3YHy7RyAMprIJBeycs/4Bf+KA
         nIQkMcPbQlhvRnhGfenNyl7SpB0qMz9g0derJ1PTYPKj48gRpC5qa0I9C7aSIX40mqK1
         Py+utPjQzPdlc1j45co6E2/S2k+/ncdBFbbY5R/DwEHeKAlgWpKPr79x3UuInhcPFXTo
         86a0LzJZe0ylzHz4kyES0Dd1KpkIeSTNfIsSajTC6QnhIF6gstkhc58hiO3a81ee1TzA
         SWC+p/Sc7q+8goJW2dQdhJlpAF43cx2t0qJWy9ZyJpAB4TrKxHBNKQh5j52znI4opexQ
         jOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJlyhcAhYMixlcJSF8vt+n4ES0FGQmrD3QGfxwqt3zI=;
        b=uFrz/eN4KiM+QRKWAJPo/iqDLTTTYzwxYnf4hs8PLY9cQMM+xTLEAz5jsk4Y9pilcY
         cNgttIPSieVGQMVhSlylynN6QQlw+Yt9Z266KGAMXIw9b5yhTGxtZAWd+ckOwlRVU6V7
         64Nu4tX02xJMk9j8LUcYGD2RTBcBdKxTg0Ig42hY2B1cjSMm3D0Dii1TFohiMqH7fnt2
         ZT2hXNgUxdicCalA8mHj0JGxDPLPp1M9tMGBY0k95tfYTEftHvbRQqNUdUtT2iBGi86U
         zP7F6jTvmCcx90tOXUWMWDoCtVi7WaRWLMW92JVStk19C3ptL+FgNFQVM5XkjjlNllWQ
         z5jQ==
X-Gm-Message-State: AGi0PuZorXrh6AnAWNuZk/ZExQueIsk11B/MoGLPd1Cvnnb0wNdexoQM
        8338JZdF/hKhP1vhGs8ENSE=
X-Google-Smtp-Source: APiQypIwCyHAm1w5bTLfIb0CFsuT+6IqwKZq5xo/9jwFYpoqiWfZE9tl41owZS9plmv5cQlNZQgYZA==
X-Received: by 2002:adf:df82:: with SMTP id z2mr9913988wrl.58.1588421436926;
        Sat, 02 May 2020 05:10:36 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id m15sm3858297wmc.35.2020.05.02.05.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:10:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Clay Harris <bugs@claycon.org>
Subject: [PATCH 0/2] add tee(2) support
Date:   Sat,  2 May 2020 15:09:24 +0300
Message-Id: <cover.1588421219.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tee() reusing splice() bits. Pretty straightforward.

Pavel Begunkov (2):
  splice: export do_tee()
  io_uring: add tee(2) support

 fs/io_uring.c                 | 64 +++++++++++++++++++++++++++++++++--
 fs/splice.c                   |  3 +-
 include/linux/splice.h        |  3 ++
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 66 insertions(+), 5 deletions(-)

-- 
2.24.0

