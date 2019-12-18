Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE52F123DE7
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLRD2E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:04 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:40807 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLRD2E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:04 -0500
Received: by mail-pg1-f174.google.com with SMTP id k25so454333pgt.7
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bR2/gcv9PCVGCoAAfQwNq2/uKT3svV6rvO1a5/PmBjM=;
        b=f5kvBLCG8NSpdOE4Of+2/sqmaatxfEaruKPg2FEMIocE0E9k5V92NMsPfsafsldwnc
         WQ/NLeaWdUPjeENMqAwkF8QcEIcU2ZTmfQte5PIGp8Rr5RcrY039NplX75Hir80fjlTO
         DYkG8N0yEzt5jx5MbEMDNDIZI6fmnweHqMnnLJUHijrrVFs5LoBWScpeqe6/BvkhmqTP
         OA+bZbhKi7tlnMaEkbq7V+GDYhJwfqwhjSQ5ZZS4bTZwqsj7CDbLhRhyh86jFaJJDj1S
         x63/1ebTSg/2MvVUp9zYudUrkWZ85609eAcc6CtHaFOPxm3mmviXHHf4GDTFx0gEuwMX
         z5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bR2/gcv9PCVGCoAAfQwNq2/uKT3svV6rvO1a5/PmBjM=;
        b=lYRXhSKXRcgOWrc9WjXAvnfENQp+bVYgJrbuLosGwjI0PwI+rpS9pMv9mpsmRqyIEU
         6z1gJ49txfM/MTTKitfzZ7XEe+nRtuP5cU6ML4TsVlHvzOZ53SYmYle7Mh2tgUO/mQ4M
         Yn/fCJmgxO1jI3+UOMVlj2iDHQuuWCEYDK5ZnuDNJDP9cN1QsGpnPYODJyeUkBpb9vjm
         nJevr3+bh9fTliY5N0hv+M7ldeqQ5dAOka6amlHu604YnizNmlMhcuIfzkF7kUnHI19c
         6nrve8Z7JQ56l/C38RYBY905gfnqBLor4JyW+PyGr7rFETa03tLLZ9+5UOiENy0q+C8G
         obgQ==
X-Gm-Message-State: APjAAAUQiZt24se2Dcy6YDrNH0Gz8fIXstA8qvWx5uEk6XSLLCD3/o/I
        scLWSJvPI7srkLHUfyp/+GucT9F8dIGYOA==
X-Google-Smtp-Source: APXvYqx7zefoyX3Zmv50C9gizY4f3NgHXBBPldJ9t+u5Ddcs1VJso3q2E2vHR6SEsLW1OOLnsgTpww==
X-Received: by 2002:aa7:87d3:: with SMTP id i19mr482501pfo.175.1576639682697;
        Tue, 17 Dec 2019 19:28:02 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:02 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2] io_uring fixes for 5.5-rc3
Date:   Tue, 17 Dec 2019 20:27:48 -0700
Message-Id: <20191218032759.13587-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hot on the heels of v1, here's the updated set. The main difference
here is ensuring that ->opcode is stable for deferred (async or just
linked) execution. Doesn't help that we fully prep commands, if the
reissue ends up reading sqe fields again to figure out which command
it is.

I think this improves it all around, and it makes me more comfortable
with the persistent state. There's three patches that deal with
poll add/remove, cancel async, and timeout remove. Those are the three
commands we still missed that need to retain state across a deferral,
and then a patch that stuffs sqe->opcode in a io_kiocb hole, and
ensures we assign ->opcode and ->user_data when we retrieve the SQE.

Lastly, a patch that adds a warning about new commands that don't
have a prep handler. We need that for ANY command that reads sqe
fields, which is all of them obviously except NOP.

I dropped Pavel's submit-and-wait patch for now, hoping he'll send a
new one tomorrow and I'll get that added

 fs/io-wq.c    |   2 +-
 fs/io_uring.c | 692 ++++++++++++++++++++++++++++++++++----------------
 2 files changed, 470 insertions(+), 224 deletions(-)

-- 
Jens Axboe


