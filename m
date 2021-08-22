Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E503F41A0
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 23:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhHVVG3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 17:06:29 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:36020 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhHVVG3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 17:06:29 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52706 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mHuf4-0001qj-4c; Sun, 22 Aug 2021 17:05:46 -0400
Date:   Sun, 22 Aug 2021 17:05:44 -0400
Message-Id: <cover.1629655338.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] coredump: io_uring: Cancel io_uring to avoid core truncation
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Before writing the core dump, io_uring requests have to be cancelled.

Also, io_uring cancellation code had to be modified as it could set the
TIF_NOTIFY_SIGNAL bit.

Few notes about this patchset:

1. My coredump.c proposal puts the io_uring_task_cancel call further
down the do_coredump function over what Jens did propose.

Considering that this function call can be relatively expensive, I
believe that postponing it as much as possible is the way to go.

I did place it before coredump_wait which clears signal bits so that
seems to be an appropriate location but the logic could possibly be
pushed even more with possibly no harm.

2. The current patch proposal only address specifically the issue caused
by io_uring. It could reoccur as soon as something else flips the
TIF_NOTIFY_SIGNAL bit.

Therefore, another solution would simply be to modify __dump_emit to make it
resilient to TIF_NOTIFY_SIGNAL as Eric W. Biederman originally
suggested.

or maybe do both...

So making __dump_emit more robust to the TIF_NOTIFY_SIGNAL situation
might be something interesting to investigate if it would be a good idea
to do on top or in replacement to this patchset.

Lastly, Jens did already submit a patch to solve the same problem:
https://lkml.org/lkml/2021/8/17/1156

If his patch ends being a superior solution to the problem,
the first 2 patches of this set are still relevant.

Olivier Langlois (3):
  tracehook: Add a return value to tracehook_notify_signal
  io_uring: Clear TIF_NOTIFY_SIGNAL when cancelling requests
  coredump: cancel io_uring requests before dumping core

 fs/coredump.c             | 3 +++
 fs/io_uring.c             | 2 +-
 include/linux/tracehook.h | 8 ++++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.32.0

