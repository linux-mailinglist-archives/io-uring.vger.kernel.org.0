Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70820F47A
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 14:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbgF3MWd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 08:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732221AbgF3MWb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 08:22:31 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CA0C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:31 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ga4so20272515ejb.11
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VP+8T2AL6dhPEsLPBtBJlrG5tNQ/z2VPPHj5E58M95E=;
        b=r4EF8HTUJUfvH60zhHRuYAVzD4ZovPythDqxTMYHum6MOFAiLYQs6DOGIvYB4DMiZd
         dY5TaIq5Bg7hRKK8wbFtBPOKxYhlsHY/sB/c2FbWjj8xWxUyCX5YzonauGZLel+SOsjf
         t7kALje9wWZRSmKvQyuZHEpGpFxl12xm1PHJbG6aBm1qL+GSmK6+2VWczCCxOz+mxo4E
         vkgGgUSAeuoH2DnlfKUEoGdopjSJ3zOteJfUX5u/ELaZBTtMROjswzPYWLhSq7i72QTP
         D3aMc24auiD/OIGT4LN0T46ECYBqzvX8yXZr5s1Kp5T9zJloiXVKY68aNhs65a7mBs3n
         NGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VP+8T2AL6dhPEsLPBtBJlrG5tNQ/z2VPPHj5E58M95E=;
        b=hB3kFbpHJDcArswcMpxPgglrOIBBITomkw82L49Jr8PCmFiJhT5Nc4VeP7QL+MbB47
         Lmkk4Ncf10E3Mut0SKYpx7USTspSOQtHxz6i6MScMKB8gy2aFjlz5gKuswvYPwVH6fz5
         mfcEIw7gUl87PukR9t6sM1uUvhEGxxrdNXaCUTnN1ejmCFQ01AuGr/5D67qlFzn0iFP6
         9gKjHfQrLlfXOjPHO9/KBGMh2frFjlxMu2zTfM1gyE41Z0Y7g0A8Gx4S5GYz6RASVuXL
         LPXRP2dUdZLIuW2p8IXB1SUcfZUjObIADwIsCxIIhhQvq9iwaTRXuM+xnTZaf9n0MK/r
         a2kw==
X-Gm-Message-State: AOAM530GxJBq+86/b0ycnW7ZoO2RQk6YcaPFgINzp7aCp2FZYWRKnniP
        yEIUCNTf5zQh5sdtkK/4NYY=
X-Google-Smtp-Source: ABdhPJz2LjL/WRf03SG+2SYUxQBB358PrgYuRG2JDN4tRQvEq3+2Xk88kKMw5K5VhaBR4b/NBHcWRw==
X-Received: by 2002:a17:906:7f0f:: with SMTP id d15mr17539698ejr.159.1593519747918;
        Tue, 30 Jun 2020 05:22:27 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y2sm2820069eda.85.2020.06.30.05.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:22:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/8] iopoll and task_work fixes
Date:   Tue, 30 Jun 2020 15:20:35 +0300
Message-Id: <cover.1593519186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[1-3] are iopoll fixes, where a bug in [1] I unfortenatuly added
yesterday. [4-6] are task_work related.

Tell me, if something from it is needed for 5.8

Pavel Begunkov (8):
  io_uring: fix io_fail_links() locking
  io_uring: fix commit_cqring() locking in iopoll
  io_uring: fix ignoring eventfd in iopoll
  io_uring: fix missing ->mm on exit
  io_uring: don't fail iopoll requeue without ->mm
  io_uring: fix NULL mm in io_poll_task_func()
  io_uring: simplify io_async_task_func()
  io_uring: optimise io_req_find_next() fast check

 fs/io_uring.c | 79 +++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 46 deletions(-)

-- 
2.24.0

