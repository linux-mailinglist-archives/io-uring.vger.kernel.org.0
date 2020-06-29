Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0968E20DD90
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 23:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgF2TN5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 15:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731547AbgF2TNx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:13:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEFAC008650
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z13so15943968wrw.5
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BR2OpAztIc9wXxVF298i//d4RrKAEU4vmYe9QjrF4DE=;
        b=p+947iT9RdxPVO3oZgORf6lwqQLZ9uGVLumjUafxW2lYzpCVUWQUMb00f06XfW90QI
         UW5DKGvoccXh530eyXxfaTnIQ3mXtlSfn2YfW2o9Y9NYTM173kv5ysXUidJSAlFsQsq7
         KIY4q45mQFLB9paTWwDwJlWgY7JjQV9cZVw39MPW1Svvk7wNOBN2Uf82pKI6Usps/NK7
         XvxNORJaqlJypoS6urt4Z5h9WxdQDFa2A/xuzaHvJ5SYl8u+65cAdh1Q9I782Z0oNJXG
         +gpB2HnhY+X6KZxLARq5BG9nSjHVTGgL065j4lckqJjF99TiAHgJK2Riw6Y5ktRdLRUw
         gWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BR2OpAztIc9wXxVF298i//d4RrKAEU4vmYe9QjrF4DE=;
        b=J/rxq98LSXMP2JtEjikCrcf3GqKqUAOFLoMLeLK04fTIeMaIDd904ZmJVG5VnQhsCF
         EIJ9fvFxpqRQbUQo4UDJ404ufbQFQdM357QEPkrC3nogpreI6BZLpQ3mnHbLPKBHzsYW
         1mYcm1Em7hX6ab1CJzMkRr88JujBJCNLqPnBkEZW6cqxiw7HSQUfebDanF8+UNTfEajv
         3Kq/bKz1FVswOAYTMh/XC4O8xVnB3V50oOvLQnxEun77QNB4S/wGb/1LNlP7TnW4K9W0
         1Zp2KrSF6BwJSbE7NPCTDwXHhBxQ4RXD8yii+xT3/YPytGntzrmMJzzM4PrZBq45gzQj
         FLfw==
X-Gm-Message-State: AOAM532WF4Anxyu0k1fCn+naGfheZ995yEpII0bWztAv8IQ8ngb11gIk
        Foe0htikF2jZkmvHr6UzLdnl9drJ
X-Google-Smtp-Source: ABdhPJzOvWnDjT3RkumoTLt6x8Skv/bblaKnvr71eRMBFDN9syGvDUzlFzrtD7/5ybEBkXiLcJaKHA==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr16263544wrn.52.1593425685186;
        Mon, 29 Jun 2020 03:14:45 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id a12sm37807233wrv.41.2020.06.29.03.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:14:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/5] cleanup for req_free/find_next
Date:   Mon, 29 Jun 2020 13:12:58 +0300
Message-Id: <cover.1593424923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Cleans a bit up completion path.

Regarding [5/5], it's so unlikely to happen, that I don't even try
to port it for 5.8, there would be merge conflicts. However, if anyone
think otherwise or this ever showed itself -- let me know.

Pavel Begunkov (5):
  io_uring: deduplicate freeing linked timeouts
  io_uring: replace find_next() out param with ret
  io_uring: kill REQ_F_TIMEOUT
  io_uring: kill REQ_F_TIMEOUT_NOSEQ
  io_uring: fix use after free

 fs/io_uring.c | 140 ++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

-- 
2.24.0

