Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7513C16A00C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 09:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXIdn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 03:33:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37262 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXIdn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 03:33:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so5015994wrx.4;
        Mon, 24 Feb 2020 00:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nymHRd519oEr/2Ol/xDdmyiQN5tOm+qHNfWBj7Ts3V0=;
        b=f9F5h86Uonh3ZWKSL+1FCIP03WC4MMNfKcSmK25Xr0N791WFzTrf2v66QMzZh2Jfl9
         JJNRhxQtuh72EIjk5glA0KYpFknjSsmDgXCRxV//qj1aAnqZSz+OEkXCOrraCMjLaNy6
         XCOBCAyjmwAKvaPw9tQthGqqYUfvGj/GBTygchwX9h0wtS5TU/QpZdOqfs28gPUTXoH9
         cUlfNSRBU2wZTpG7pZUbwN5auFruRHJxmqiNg4eP1Im9ntsdt96Nt3EmxPhjDL0cpBM6
         WHE/7/FCLs2HNCePWMYlDYQtBqfZe5HVqsCbbkpHwEIrrNBG/lqeu6shzgkl+kngVmOC
         FkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nymHRd519oEr/2Ol/xDdmyiQN5tOm+qHNfWBj7Ts3V0=;
        b=KjnuwkLxMmN6qxHmbXqZopXN6NmSscNZ96BAHcfWt+0NGJhjby6o1kHqII7frnfwfQ
         mR+XFa+BnHMEE3GXH9e/Swo92m3JlFwMi0X9Xt991MYCfqvBv3VgVQlBKbDoTD4OzLlo
         eWzijsyq4Rpc/nKWY3XWC1sNNgLkiV2cr+9YGdc+IN/gYyqH1oDRpWS5HzxQaKJ/XIFR
         0l2pYm8Bp9/+3sr8wjGkAXHrQHcF+kYnv6F1ZIjvwIXDPAyVgthMNLrQioyt523fy9mL
         z8fx6O0gXM6VcaIv9WFWdzPafJxpdTW1Hf1NtPvOGGnS86FReT2WDr8B2A/pOUAbJN63
         69Pw==
X-Gm-Message-State: APjAAAXlUMa3LMnmrB7Uz5GTVx7AGq9bgTtWDiK643oti6Minl1xXA+b
        UnLnf0HUUI/MxC01nL+FveE=
X-Google-Smtp-Source: APXvYqx6/EIheiy/mnQqM+vtj3ky8o4pyJEHDw44B4na02N1359EweZ63qj/IwFcV5ldpqL4GHrwHA==
X-Received: by 2002:adf:f744:: with SMTP id z4mr60283849wrp.318.1582533220739;
        Mon, 24 Feb 2020 00:33:40 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id p15sm16695353wma.40.2020.02.24.00.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 00:33:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] io_uring: add splice(2) support
Date:   Mon, 24 Feb 2020 11:32:42 +0300
Message-Id: <cover.1582530525.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

*on top of for-5.6 + async patches*

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

v4:
- rebase + a bit of function renaming
- make file_get/put accept req instead of ctx (Jens)
- fix lost REQ_F_FIXED_FILE

Pavel Begunkov (3):
  splice: make do_splice public
  io_uring: add interface for getting files
  io_uring: add splice(2) support

 fs/io_uring.c                 | 181 ++++++++++++++++++++++++++++------
 fs/splice.c                   |   6 +-
 include/linux/splice.h        |   3 +
 include/uapi/linux/io_uring.h |  14 ++-
 4 files changed, 171 insertions(+), 33 deletions(-)

-- 
2.24.0

