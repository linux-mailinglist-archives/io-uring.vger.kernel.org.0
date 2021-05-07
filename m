Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB21376898
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhEGQYM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbhEGQYG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:24:06 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA7FC061761
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:23:05 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x5so9845160wrv.13
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3aA1JI2JPcHfHvzccwwssUxy49j9R8cAIHMybY9UV4=;
        b=QHBBWr+XCrTIQMZ3oQigr+29LdF9eDboQvXUMgF/LfPyhVrocy8u5lVuKkbk36T0DC
         LWFJKETR1G0u/Vtzh0qdOrSRgkqtA+MmXPHi4GVAGr9WmhIMrWYkks+N3NbThL3d4lPP
         z6hsyI6mKClCKwnhBM4kb7SJrf8hHnU8UhfdYvFEgAcWiADHH4nESCAew1qeb1+w7IJU
         Ptr2moVmIfr9rKRkLe4kf25ECpFq8D1YLbk0OaxIwN/mrljBqygtBa2cgbqBNofncdR2
         9IfMbEAVv7tU0CNU47MkxidcL52tUM8FLAOJi0hugod7xEeL2MTbEJ4uKXtd92jPHsKH
         qPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3aA1JI2JPcHfHvzccwwssUxy49j9R8cAIHMybY9UV4=;
        b=mfyt35OyXScfn0iQKwDkPKYjWKHAoz7wEjRJpTvDTvyYoGMCM8hmdhGxYDza3Fpawd
         VVCtDbvu1qCMi7U58p7ImF+xLubNBRF/ks7gJOHDVJAmrhJAAesK+6VYuxIe0lNKCN+G
         DcLLhLr+P4UZAPeiZNIZr7T5n658yOrdzI2ZTgOgFIKhAQe8w9+tWLmbL8p0oXqveV0L
         WLYt5iyFMAdv8ng80NQn/+VV8m+MgDOE7Swk0kisIEhraz5p52GsAlTueeLfLIZWzYKW
         GGwnyFFMeTDBoVovrmXGaFjVQ8eQJjQrWE5DaogxELyev4WJPfwRiZFV4OyuO7oQ2AdN
         I9Dg==
X-Gm-Message-State: AOAM5321tvbyCWSs5uwt5cqbwbbJX/x6ZCkFZ8DemNo+32Ipl1czFxQz
        bdUjiKWoHTQc+HM+dLtziwk+LVjagYY=
X-Google-Smtp-Source: ABdhPJyzucySEcfM+wUcq6gDLocSoWb4Pc7syHbpzWIVMFQriZDA3+HAbX+P1be10x5O4CjVWRUTuQ==
X-Received: by 2002:a05:6000:2ae:: with SMTP id l14mr13265374wry.155.1620404584477;
        Fri, 07 May 2021 09:23:04 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id w4sm8765630wrl.5.2021.05.07.09.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:23:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/4] rsrc tests and fixes
Date:   Fri,  7 May 2021 17:22:47 +0100
Message-Id: <cover.1620404433.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2: rsrc tagging, buffer update, rsrc register, etc. tests
3-4: small tests fixes

Pavel Begunkov (4):
  sync io_uring.h API file with Linux 5.13
  tests: add rsrc tags tests
  tests: fix timeout-new for old kernels
  tests: fix minor connect flaws

 src/include/liburing/io_uring.h |  41 ++-
 test/Makefile                   |   2 +
 test/connect.c                  |   8 +-
 test/rsrc_tags.c                | 431 ++++++++++++++++++++++++++++++++
 test/timeout-new.c              |   2 +-
 5 files changed, 471 insertions(+), 13 deletions(-)
 create mode 100644 test/rsrc_tags.c

-- 
2.31.1

