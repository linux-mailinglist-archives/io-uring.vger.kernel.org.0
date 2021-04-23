Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856253689AE
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhDWAUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhDWAUP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:15 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58CCC061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:39 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e5so17883481wrg.7
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XztrrCvpDqZbFFHgn6JV1bnNg8Yhnprl6G4Od30sp4g=;
        b=XEXnu1jU6YlQ+tzx1kx4PKG7ciBTYOdWZqk2i5Qmu7YijUp7bbi+zfysPhDleG4aOE
         BBtDjzkpJmHVbhzQU/vXBFatzXCkp+qtZufAjPie9wUak7dFaVV+2Z/annkwuQzmOZWK
         PaXLDeRZMaCGqeSQHVl4jhhQ5kyOBxz4Hytj5YDu+thpvsZ2CdJdlUlHqJd8jqElpC6m
         xGmZUzIb9AqYqvK8o34IeaP/fHC0dEHBzvUigSLnCxhYwIz2O5JJ0pOAAxg7dJHAAFJr
         V8UyIKdEejWPqP3g9327ac0BFtvWZ88WRFlzELgzkmW32/CZYIDeDFNrknZTcXXbWsjn
         pc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XztrrCvpDqZbFFHgn6JV1bnNg8Yhnprl6G4Od30sp4g=;
        b=VPZl0eZzNwpwAKlX4at0IEj80UI5iCOEc8Yowspoeq8UIAQd1Us/iAVut0ZW3yTXaD
         7kSQlZg2wo1CFTEOgMD9KKnTPQbPNbbwJ7A8pIFulfQTScmROoM9I0WPUSf4KgU61Eya
         Vgg9iaKtd1C/lukhjynfkhrExzIp9I3eOdjPeR1zKFIhIP8Rpgd5d9lTstQ8N3GTu94K
         g4YVunkJ5o7ZXXGDC9cY6p/GBVdPEqN9lHixU3DqemAIOKWYPAc7IU9hxH7few7cYERa
         RIoda7uaXBbpL52scVCMDFwl+MY9sEtdfHcz35utqGJRw3JUcJM7Mj29n6BAHtKls6CM
         n3KA==
X-Gm-Message-State: AOAM530K+wUwwg8y+GHz7coZaChgc92osqgn79T7NB3DWBTfD11BYG0t
        AvzytW0HPhJYPinYrP6AwNpwwoJJzjE=
X-Google-Smtp-Source: ABdhPJxz7k3VAwnz+SIujKoJAy8CvnmsKMSAVdfi7OF7V804sKtMssCASHjW8rNtQJ9LUjBTToQJsw==
X-Received: by 2002:a5d:4308:: with SMTP id h8mr1004185wrq.371.1619137178468;
        Thu, 22 Apr 2021 17:19:38 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 00/11] dynamic buffers + rsrc tagging
Date:   Fri, 23 Apr 2021 01:19:17 +0100
Message-Id: <cover.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1) support dynamic managment for registered buffers, including
update.

2) add new IORING_REGISTER* for rsrc register and rsrc update,
which are just dispatch files/buffers to right callbacks. Needed
because old ones not nicely extendible. The drawback --
restrictions not supporting it with fine granularity.

3) Do rsrc tagging, with tag=0 ingnoring CQE posting.
Doesn't post CQEs on unregister, but can easily be changed

One more thing to discuss is 9/11

Bijan Mottahedeh (1):
  io_uring: implement fixed buffers registration similar to fixed files

Pavel Begunkov (10):
  io_uring: move __io_sqe_files_unregister
  io_uring: return back rsrc data free helper
  io_uring: decouple CQE filling from requests
  io_uring: preparation for rsrc tagging
  io_uring: add generic path for rsrc update
  io_uring: enumerate dynamic resources
  io_uring: add IORING_REGISTER_RSRC
  io_uring: add generic rsrc update with tags
  io_uring: prepare fixed rw for dynanic buffers
  io_uring: add full-fledged dynamic buffers support

 fs/io_uring.c                 | 470 +++++++++++++++++++++++++---------
 include/uapi/linux/io_uring.h |  23 ++
 2 files changed, 376 insertions(+), 117 deletions(-)

-- 
2.31.1

