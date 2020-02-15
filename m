Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F661600D8
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgBOWGk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:06:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40564 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOWGj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:06:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id t3so15173907wru.7;
        Sat, 15 Feb 2020 14:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5PAtRNcVxW/VF6EOqrI1mG5nx7P/Aj/JQzV9Ywd9Gb0=;
        b=aT7aTwikQ0TjDBO1Fp6EA0Q58m3aARsTc7eQiBxDFGUHHBILDXPqSIz+HK5BlJhf8H
         yHd/H9oT+0uOvCHdJdBbxZ7a7hK4168/TtHCde4hEz+HP6eZpEJoyZ9RxBmPbPOpqzZ0
         UMCQJvzLH+Ss5N+jX5C4ZII+XU1pmfcTspV2rfrWA0X2Iu6oyWAIy2RWvHVKPYlC3Gdb
         T8pBS2aIQyhZnSXXq297M+IdpftbkSHJYCsECqrophtEcenilJ8cpM34/9d+ZoBtBPEw
         YDOMRZmUv3wkcbYQDJdlawze7KKgur69y3iaXmKKPdCApb4moqQX7CkY6OE9Gexskgyd
         woew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5PAtRNcVxW/VF6EOqrI1mG5nx7P/Aj/JQzV9Ywd9Gb0=;
        b=FUqmbjdKRoIsp3/nvAn2PVhXlP5QrCqR2yjHzCQWRdjNcU3KyQMzJVq7vsFw7hqdOe
         VhQm1Gy2ImP/bOXR1fbQhkhgD4dIr/IrjbnKOlvE+7sSt+s2gNoP4EIMyrcWczK6DkGl
         e5NrqkSTSiQGrsMBDNUMsf/uCyzc9/Hi0M1iF1JZraTu/8tkRT5R7o7w0tBWnR9yLGOE
         9nBjSSCjW6zW8YYBQxUGziUpBbdu3Ea0SxVcR6DUdHIZzVQK3PEP4bcLKMRmqvimMq9a
         Nt4vvOkAnwFcleUOUhABerPWkXbf1G31cDA1WKQCF1Rj5Utx9GLQOoWJC6J0bQkooOR8
         Cl8w==
X-Gm-Message-State: APjAAAVmeLYOXXqOso55szjAgCOoiYMgphFB2THhu3x/SLBGvR/QBnFK
        TJ6D6U9hYjzon+BiDMmSjnY=
X-Google-Smtp-Source: APXvYqyoqCmaihQvHVPahs0XFCz2CwAiEkp8P2WunXP835AFf8umZWvAQrspwopzPD6jeSdaMGE2Ig==
X-Received: by 2002:a5d:474d:: with SMTP id o13mr11516779wrs.309.1581804396880;
        Sat, 15 Feb 2020 14:06:36 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id v15sm13281923wrf.7.2020.02.15.14.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:06:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] io_uring: add splice(2) support
Date:   Sun, 16 Feb 2020 01:05:38 +0300
Message-Id: <cover.1581802973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Probably, not the fastets implementation, but I'd need to stir up/duplicate
splice.c bits to do it more efficiently.

note: rebase on top of the recent inflight patchset.

v2:
- u32 len and SQE layout changes (Jens)
- output file is in sqe->fd for automatic hash_reg_file support
- handle unbound_nonreg_file for the second fd
- file leaks fixed with REQ_F_NEED_CLEANUP
- place SPLICE_F_FD_IN_FIXED in splice flags (Jens)
- loff_t* -> loff_t, -1 means not specified offset


Pavel Begunkov (3):
  splice: make do_splice public
  io_uring: add interface for getting files
  io_uring: add splice(2) support

 fs/io_uring.c                 | 172 +++++++++++++++++++++++++++++-----
 fs/splice.c                   |   6 +-
 include/linux/splice.h        |   3 +
 include/uapi/linux/io_uring.h |  14 ++-
 4 files changed, 166 insertions(+), 29 deletions(-)

-- 
2.24.0

