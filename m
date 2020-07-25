Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B16C22D61B
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGYIdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 04:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGYIdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 04:33:23 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24152C0619D3
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 01:33:23 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id q4so5377165edv.13
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 01:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jHVmMusMx1x2sooL0ZopESTJPwGQZaA2yZ6TqPRBfOE=;
        b=GHL7UDPt87PDnA2msO+31eupWJpImwcxzTlI6luAbYJYwJnh3teYhMz3sxVZ8gQ9g/
         S937fsL68TC9dPTVlQaGa6HPRq9UYYo2bG4RIeZ8wdir/uX6nfu1DSdJMFgXduDaiMZZ
         Q9qNNIlAxWkaFkDawK2lMpqUVyCEWOn/2HPqcDml/UZXxqMyPF87U6IZxINrP5844L0C
         0do56KFHu2qVdvgvpcHVLMOepStvT7PQKtIu97Uri4hIOY0tPdArRwQ8DZ63TaiT0V5N
         RXNSHgSRkjKaYThl6bYKGMdJm+Q4RTy8B8Se8LOGkCxXRELAIrq4pgH/IprfWjxjFvGU
         HQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jHVmMusMx1x2sooL0ZopESTJPwGQZaA2yZ6TqPRBfOE=;
        b=ZE3irnk0EQEJk1y4jS5ZR/Ps4f6DWqr5ct3Z2QgUJK4BOJgHUmnpbjUIUPdPwr71Ry
         IkC5GWG4NjRyoHPrx5wfkqB/MNKqvSUTNn659VnVpndUqHj9Q0CRTGGKwKJFgzONH+Kt
         fePi+A3QV8IdwXN53SAa53Iqxt7F0fdTuVRGdrcYlck7pWXMln3soxlfMDUW1BS5oMZ+
         Jj100Walgi5ItaPLE/1Uv+KVjuO3zkWivInwtq73xtyY5ETINM4s/wz1VjTkAGPVUFzB
         3yzY4k7dBDZoNvASIEcFSk51wXQg9dYg23PYaqiVqJHqHFhF7l4RPjlBZw89X/0Il7LU
         4V6w==
X-Gm-Message-State: AOAM5312Pm9S+BCBDskikYl3GKbT4YpIEhiSPHGwngyBxFEYm2IM7PY6
        1DFEs144+cIn6mQ5mtUaRtivp9zc
X-Google-Smtp-Source: ABdhPJwVIjFRT1jQiJB53cCPsx15s5nT87NS4QmaMmf1MkzyDDxrHtC9qtXZh5BgrkSDNSxDANL/MA==
X-Received: by 2002:aa7:c991:: with SMTP id c17mr12583218edt.278.1595666001706;
        Sat, 25 Jul 2020 01:33:21 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id r17sm2403597edw.68.2020.07.25.01.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 01:33:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 0/2] 3 cacheline io_kiocb
Date:   Sat, 25 Jul 2020 11:31:21 +0300
Message-Id: <cover.1595664743.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

That's not final for a several reasons, but good enough for discussion.
That brings io_kiocb down to 192B. I didn't try to benchmark it
properly, but quick nop test gave +5% throughput increase.
7531 vs 7910 KIOPS with fio/t/io_uring

The whole situation is obviously a bunch of tradeoffs. For instance,
instead of shrinking it, we can inline apoll to speed apoll path.

[2/2] just for a reference, I'm thinking about other ways to shrink it.
e.g. ->link_list can be a single-linked list with linked tiemouts
storing a back-reference. This can turn out to be better, because
that would move ->fixed_file_refs to the 2nd cacheline, so we won't
ever touch 3rd cacheline in the submission path.
Any other ideas?

note: on top of for-5.9/io_uring,
f56040b819998 ("io_uring: deduplicate io_grab_files() calls")

Pavel Begunkov (2):
  io_uring: allocate req->work dynamically
  io_uring: unionise ->apoll and ->work

 fs/io-wq.h    |   1 +
 fs/io_uring.c | 207 ++++++++++++++++++++++++++------------------------
 2 files changed, 110 insertions(+), 98 deletions(-)

-- 
2.24.0

