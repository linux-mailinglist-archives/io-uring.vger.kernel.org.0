Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B71C174345
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 00:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1Xic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 18:38:32 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:32948 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1Xic (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 18:38:32 -0500
Received: by mail-wm1-f45.google.com with SMTP id m10so10413021wmc.0;
        Fri, 28 Feb 2020 15:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5kbWRr234VUdU4bnsQ5OmzRBDQao8sDvHxqL24DmLE=;
        b=G9UXHfHXyg/B3q8wn2lHjQUaudNyej6iFQ6sSyVgRDn5NHk+hYzEI0GLyubBrJ7bkh
         tp6kVrI0fRG9Yd40xM1/3jmTdPeH07/9uIMDE56aEKM14moatkoQ1xRCyDmQWCLJ14Cc
         5BAW7BZLPcuiytVQaF/XqoLbW6bXIoqruQk4PcesLnleTPgIQCNIQXwizaWbRMvpT/fi
         Y1j5LZTJrH6SuJBEBpJj9AjkC9i6D8vpT3gRBehWG5dmKwr1uMzSUZ6qXIiPD0WsaTUi
         lyNL9IGKJXZZfCNOGQZSyw3Kemp3PzZyMBkk4QjzY2rzNtioRhlXuUaY9Umi6gcUUVHN
         Prjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y5kbWRr234VUdU4bnsQ5OmzRBDQao8sDvHxqL24DmLE=;
        b=ovk+yHNByT614YTCCEaUIBt8i4ud5rsU57Nzud1YuWXyn/4nK6Tm4Xi6jtouXTBHkQ
         JJG/QvQHF55VgXovmUtKZe2yTjchYsruwpCShVHNbw/MkQXc9hEa5I/UYZGB5RQFKSVh
         YJMiqRH3L/FzNHih08T2sSWxHINnrwTfjBtOdOqEkow1XHMfuAWT/U6VDmsKLNNG77W8
         QyCbiTlQZ3qeJLm8UV9TrXKgVeNOfiifhJTInSVtjsxCPmkb1zu/IDrA41gd15yrXQZ2
         70kIhyV/IAjg+H+3wXbEGUINUHRRBaLGphdhfY+/QS61qKW+Cd7I+9ICC1p7myHqUzyZ
         9KUQ==
X-Gm-Message-State: APjAAAUEhiFihartxVYAQK4rUQDrhYYsGGzbPmm03CrdWCbyVlxw8XUd
        JBTgWQEsK7GT8wUGlazOSaI=
X-Google-Smtp-Source: APXvYqwYIz+7KiDlbxJNt5ME5knUnyMx1sbVRAUXQIADOMQ+3yGDizVsrLKo/78ueLu7lWyxa7qTKg==
X-Received: by 2002:a1c:3204:: with SMTP id y4mr6668586wmy.166.1582933110305;
        Fri, 28 Feb 2020 15:38:30 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q1sm13762512wrw.5.2020.02.28.15.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 15:38:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH REBASE v2 0/5] return nxt propagation within io-wq ctx
Date:   Sat, 29 Feb 2020 02:37:24 +0300
Message-Id: <cover.1582932860.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After io_put_req_find_next() was patched, handlers no more return
next work, but enqueue them through io_queue_async_work() (mostly
by io_put_work() -> io_put_req()). The patchset fixes that.

Patches 1-2 clean up and removes all futile attempts to get nxt from
the opcode handlers. The 3rd one moves all this propagation idea into
work->put_work(). And the rest ones are small clean up on top.

v2: rebase on top of poll changes

Pavel Begunkov (5):
  io_uring: remove @nxt from the handlers
  io_uring/io-wq: pass *work instead of **workptr
  io_uring/io-wq: allow put_work return next work
  io_uring: remove extra nxt check after punt
  io_uring: remove io_prep_next_work()

 fs/io-wq.c    |  28 ++---
 fs/io-wq.h    |   4 +-
 fs/io_uring.c | 320 ++++++++++++++++++++------------------------------
 3 files changed, 141 insertions(+), 211 deletions(-)

-- 
2.24.0

