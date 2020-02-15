Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799E31600C5
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgBOWCX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:02:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37092 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOWCX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:02:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id a6so14585711wme.2;
        Sat, 15 Feb 2020 14:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JXsyRn0kkAPiEulhK+SilKiMhg70jcsxkKabu1rnoic=;
        b=qJlFgl6SKVwSTtNj5cxz0PbKYvKe7NOfxkmY1NhKl/sADXrawVv4QVCKPzf6DWWees
         FdTJAmPi0Em61W1ny63giQrBsKuoKX/QC22exAZzYSVcUfReY4iq8fRSi3uOEDFZgcMf
         D7NBvQO5ml1P2WE6PsF57iCTwPinqJg9Gt0oOeJMaXoOuFpPO82MFJSGADmUdEA4DX7l
         nJDeCdSC2Cz/FIUjS7ochuHWYucM1vIV3GVY8tL8804ole/afLryhPpOLKAM6Gy90Yud
         ttLjw+jM8oUQx/nl2hkl9YNnuccQd/3q4IqPBNWJc7vesiTCvlzANdxaI8AoNHKacdic
         A1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JXsyRn0kkAPiEulhK+SilKiMhg70jcsxkKabu1rnoic=;
        b=X+yrPTgnmuDOeHmyKaaQ7FfPOxa/OijMkCj18S8CP7DsVkU3n032ndYHuDSd7bXoOV
         LQ6XwQZGKgqDQmxymAzgSx449dnmhupBSvcNzy/g7awuksP0bWiMyn090lE3YAbSEPPB
         oWtnw0kpg9gXlsNhnOINEnlg2+EYSZ1Yr6Rh+9VNLVgRO545CeXU+HMOC2gDQs/hSBVA
         gUdzvnrj77sehHkvKzXPSxYam6k3bfPQe8C/7zQWsdhz2daYBeMdlUmwE/B3xFo83qjA
         Dp+tzGfczXgHxPHk7UG3B5r+aF9WrnTc3UwRTZfKWJEqCixGZ5XaLxmG2kF4w8s/m8Vs
         9RKA==
X-Gm-Message-State: APjAAAVutStGX9yv/6xamZagkvBtlf0zw+jGO+VMjHAwB5CDwThI38Vr
        nBQO5q7Cz5T/vyWgFp84lQy+3g5b
X-Google-Smtp-Source: APXvYqz50F0Bh9OEsk2/jUq3XsXkXtHoJad378zTh9ePQRLVNPv3lfsxuH+epNcv1H+A+QRAIMGKaw==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr12420197wmk.172.1581804140419;
        Sat, 15 Feb 2020 14:02:20 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id b18sm13377021wru.50.2020.02.15.14.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:02:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] async punting improvements for io_uring
Date:   Sun, 16 Feb 2020 01:01:17 +0300
Message-Id: <cover.1581785642.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This cleans up io-wq punting paths, doing small fixes and removing
unnecessary logic from different submission paths. The last patch is
a resubmission after a rebase bundled into this patchset.

v2:
- remove pid-related comment, as it's fixed separately
- make ("add missing io_req_cancelled()") first
  in the series, so it may be picked for 5.6

Pavel Begunkov (5):
  io_uring: add missing io_req_cancelled()
  io_uring: remove REQ_F_MUST_PUNT
  io_uring: don't call work.func from sync ctx
  io_uring: don't do full *prep_worker() from io-wq
  io_uring: remove req->in_async

 fs/io_uring.c | 123 ++++++++++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 58 deletions(-)

-- 
2.24.0

