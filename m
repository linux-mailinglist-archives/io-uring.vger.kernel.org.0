Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6112162F78
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 20:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgBRTMS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 14:12:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38104 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTMR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 14:12:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id e8so2830797wrm.5
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 11:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJ/IUtl0Gpuvq/DfwJ9GChu+YnzkAX5bkmmGx5oWnIA=;
        b=jSgL4O+2tFCXdazYzO0kQaGKShPLUCbzwB855ESHEd5ch/AidM7CHTbmPBHLXeOEcK
         m+h19WBPhZdX2KmsbrKlCi6hEPdRH+F1ARwLFbTp0hlOResemdzJ0DrYllq4d/++gxDI
         pkhPl+1TUa6NhFBBGMIPdXUPt3P8W1Y3TB+hiSfF36qYaJGOBHN5M7esihkuSzSNZaCo
         bgCAWAvJ+hcneosT2RjDOy5GNciEbQnox1Xa9DSsYKaFGXZFPjL0S2+xz2IW7Dpae0FX
         4D7LpsjzoRjiHvV49yzrdU2AaYLaOVHIyMYPH75yKA4XSPntCR9SHDxDM/3zoDs2IPcq
         q8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GJ/IUtl0Gpuvq/DfwJ9GChu+YnzkAX5bkmmGx5oWnIA=;
        b=uFC8eg5l8gvuI0uPXgz0x/JZVIoI/B5b5stgx9dTeCMcqPftzCGe1xLINg9JzC8P7J
         KEA5FtKQDUGT1gqbseIKoYJwKMZfalmyTJpKqwYPvzjvftjdcsFSiqSSqJcjJkA1UUa7
         tYGUtr/2lIVNirG4+G3HKyXUUtOlBaJqS+GRnSofBQjurqvWJvC3nqsc6W7Nqxr/+tL9
         WCpn+iOeYkfSrhnS2iIOfWPISUWdxxcfzfy8mZdFHc//Gne9Uf8Po0qtNbjFdb1tj4kb
         MnliUsuw+UsV5lDZSR+71g6oLgrLPsS8U3IkZU2dz+gKRXYJMyccUSY2RVTVl6ohyEqR
         y3eQ==
X-Gm-Message-State: APjAAAWd2VlEvlm12CTIY/iQCSvdnM4BMzYAYFSKaSyO4SdWhBIdy3UC
        s7ZiaQ3/6hU7OO9rIhZfUiKiKRZv
X-Google-Smtp-Source: APXvYqzhKIRPmyjoj6VJEWkLv52p3gphpq6P7ju+xWprosUv+iUNmM91a50+lheifABKrwBzmgCsvQ==
X-Received: by 2002:a05:6000:108b:: with SMTP id y11mr31334141wrw.187.1582053135627;
        Tue, 18 Feb 2020 11:12:15 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id y7sm3862750wmd.1.2020.02.18.11.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:12:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 0/3] io_uring: add splice(2) support
Date:   Tue, 18 Feb 2020 22:11:21 +0300
Message-Id: <cover.1582052861.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not the fastets implementation, but I'd need to stir up/duplicate
splice.c bits to do it more efficiently.

note: rebase on top of the recent inflight patchset.

v2:
- u32 len and SQE layout changes (Jens)
- output file is in sqe->fd for automatic hash_reg_file support
- handle unbound_nonreg_file for the second fd
- file leaks fixed with REQ_F_NEED_CLEANUP
- place SPLICE_F_FD_IN_FIXED in splice flags (Jens)
- loff_t* -> loff_t, -1 means not specified offset

v3: [PATCH 3/3] changes
- fd u32 -> s32 (Stefan Metzmacher)
- add BUILD_BUG_SQE_ELEM() (Stefan Metzmacher)
- accept and ignore ioprio (Stefan Metzmacher)
- off_in -> splice_off_in

Pavel Begunkov (3):
  splice: make do_splice public
  io_uring: add interface for getting files
  io_uring: add splice(2) support

 fs/io_uring.c                 | 175 +++++++++++++++++++++++++++++-----
 fs/splice.c                   |   6 +-
 include/linux/splice.h        |   3 +
 include/uapi/linux/io_uring.h |  14 ++-
 4 files changed, 169 insertions(+), 29 deletions(-)

-- 
2.24.0

