Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4C6FDBE9
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbjEJKxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjEJKxQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:16 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF944B0;
        Wed, 10 May 2023 03:53:14 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id BBC83C01E; Wed, 10 May 2023 12:53:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683715990; bh=2ATyOmXz9gM5g9c9sCOy2OnjdcTD3k16TX+u9CVj00Q=;
        h=From:Subject:Date:To:Cc:From;
        b=UIt4n0PrUA8ORk/bUfcneviEwFrVQ5DbhccTthi3qJRqTp4WgFOkILi93ZRnYPp6P
         g1U1iSPqAkuC35TFI6T6uRVjo2IXUm6QMqTIhN3TSXmL5RVY1oNUJClqeJo8cUmbcy
         D0uh9JG+tAZ0o3lHjC60EOnDPe/tm/nOvwciogdZFTk+czzVYNuzAMgwtRaIxdfurr
         WVfIgDsDElCM0y4wWaNSxUg/AuTeHnb+whyJL2XPtSBCjM6xfYf0u9TqibsTJbHoYZ
         RQNkdHtCrVyqGLmbprG9EmaJdwOej6tvBWcrMbi9HxjlyzI+mFr59R0pjLoAl5TytR
         RhRgjp7zy3XIw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id CC15DC009;
        Wed, 10 May 2023 12:53:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683715989; bh=2ATyOmXz9gM5g9c9sCOy2OnjdcTD3k16TX+u9CVj00Q=;
        h=From:Subject:Date:To:Cc:From;
        b=IDe2E37v6O3hJXa7airBrCA3TCn9eK+THa/3eT4TSiGz8/XIAKUL4W/eJJO7u4SH4
         /zR5asagyS4fKpiCUcUzjCaHeIkRRhM+xMTGVPA3pLG0vLYFHll2Q9rsHT4/NAN58W
         h8P6BJPlNgvIZQyilHXRRAUlNb8hUfd8aWCiuE7VXwN9OUHGCmQivY/gnBVWPd5jkq
         MTPFA3/tdQOhc77P60GnKJ80KURXaMOB6sXTiFWEiCNh0JvbY0TfoqqoVd1s+21Apw
         eNuu1bYUjMQPukBkbaPifZxZTufWVAXAln905MnhsLMfIplbpB7wyu3cPeICg77c32
         MB/u0E8jiVFaQ==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id d02ee382;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH v2 0/6] io_uring: add getdents support, take 2
Date:   Wed, 10 May 2023 19:52:48 +0900
Message-Id: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIB3W2QC/3WOzQrCMBCEX6Xs2UiyDVI9+R5SJD9rGoRENrUqp
 e9uWvDo8Ru+YWaGQhypwKmZgWmKJeZUAXcNuMGkQCL6yoASW6kRxZNjCiLQ6CmNRaAxttMetTQ
 GasmaQsKySW5Ya5t9/dmr8GC6xfe2eOkrD7GMmT/bgUmt6d+tSQkplHbK2/ZAx86dXfb0YnL3f
 eYA/bIsX9JoPNLRAAAA
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=4262;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=0OsutV/yoQv9ekBoChihF+xOGj4mEsA/cvJvIUMwTqg=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eNCdFZKyUG0jvdRZT0krquoS78tNuQww1Wm
 QpWgfM9MvSJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jQAKCRCrTpvsapjm
 cABzD/0QK2sc7luOm5deMUyR+EFVfmz0r+IBqlAYIxT//RvUseai0GRFi+XWCD2tmyDWVGQBg20
 HE5F0PQVBhMnjt+TkBKMsf2Sgwdx1TuuuTJu940dRHeLterDBKlmntSSc256sVK1haf4n5+/Po+
 kQXc21uLYapK6pIwij44JX5TuXbScjMGuh4XCg8jTK2MOCHve6Y/2NqVHxtNLWPTQMpQ1eghNHh
 GE+SOnBVkXt7+wVKlOwwmoObrAVRI3K+KWosTRxtQcj+GY91qrCcWk8Rqc9YTk/QA0+GmEDm1Zq
 oFHP47sjWSy+2Th1IpDE1785N2eZjdOWludddLLeWg/IdMHuO63y8Dj1cn8/aszmuXNg+ub41XH
 5PmnL6jP9PplYQQpWTggv3HFFofD3aDevR+Ariq9pjRI+YkcdpjXnk3zWzwj/afhdkr/dVdNGKY
 bf8eZDT/4IZ54uPW6/uDnc2h6DmJd1D7TLnYhLfYnJZT4GdtfAiOuSlZmPjPyXdhbvV1E+lr3Vi
 5XKerdViPmAycdey1mm/Mx/6Dmbm3lZ1DESBv9YxF/5gcuqDRc8O9l3CEnsI78itGwgpImWrIK9
 p1Wt+RGQUjVZdlVnxAIiPMPbe+OoR60TNsIr3gJUw5sH1t8h05FR9G7dt4RLv++VabH8RyllPJo
 Oi35qAW5TUIZm/Q==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an attempt to revive discussion after bringing it up as a reply
to the last attempt last week.

Since the problem with the previous attempt at adding getdents to
io_uring was that offset was problematic, we can just not add an offset
parameter: using different offsets is rarely useful in practice (maybe
for some cacheless userspace NFS server?) and more isn't worth the cost
of allowing arbitrary offsets: just allow rewind as a flag instead.
[happy to drop even that flag for what I care about, but that might be
useful enough on its own as io_uring rightfully has no seek API]

The new API does nothing that cannot be achieved with plain syscalls so
it shouldn't be introducing any new problem, the only downside is that
having the state in the file struct isn't very uring-ish and if a
better solution is found later that will probably require duplicating
some logic in a new flag... But that seems like it would likely be a
distant future, and this version should be usable right away.

To repeat the rationale for having getdents available from uring as it
has been a while, while I believe there can be real performance
improvements as suggested in [1], the real reason is to allow coherency
in code: applications using io_uring usually center their event loop
around the ring, and having the occasional synchronous getdents call in
there is cumbersome and hard to do properly when you consider e.g. a
slow or acting up network fs...
[1] https://lore.kernel.org/linux-fsdevel/20210218122640.GA334506@wantstofly.org/
(unfortunately the source is no longer available...)

liburing implementation:
https://github.com/martinetd/liburing/commits/getdents
(will submit properly after initial discussions here)

Previous discussion:
https://lore.kernel.org/all/20211221164004.119663-1-shr@fb.com/T/#m517583f23502f32b040c819d930359313b3db00c

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
Changes in v2:
- implement NOWAIT as suggested by dchinner; I'm unable to provide
reliable benchmarks but it does indeed look positive (and makes sense)
to avoid spinning out to another thread when not required.
FWIW though, the serializing readdirs per inode argument given in v1
thread isn't valid: serialization is only done in io_prep_async_work
for regular files (REQ_F_ISREG, set from file mode through FFS_ISREG),
so dir operations aren't serialized in our case.
If I was pedantic I'd say we might want that hashing for filesystems
that don't implement interate_shared, but that info comes too late and
these filesystems should become less frequent so leaving as is.
- implement NOWAIT for kernfs and libfs to test with /sys
(the tentative patch for xfs didn't seem to work, didn't take the time
to debug)
- try to implement some EOF flag in CQE as suggested by Clay Harris,
this is less clearly cut and left as RFC.
The liburing test/getdents.t implementation has grown options to test
this flag and also try async explicitly in the latest commit:
https://github.com/martinetd/liburing/commits/getdents
- vfs_getdents split: add missing internal.h include
- Link to v1: https://lore.kernel.org/r/20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org

---
Dominique Martinet (6):
      fs: split off vfs_getdents function of getdents64 syscall
      vfs_getdents/struct dir_context: add flags field
      io_uring: add support for getdents
      kernfs: implement readdir FMODE_NOWAIT
      libfs: set FMODE_NOWAIT on dir open
      RFC: io_uring getdents: test returning an EOF flag in CQE

 fs/internal.h                 |  8 ++++++
 fs/kernfs/dir.c               | 21 ++++++++++++++-
 fs/libfs.c                    | 10 ++++---
 fs/readdir.c                  | 38 +++++++++++++++++++++------
 include/linux/fs.h            | 10 +++++++
 include/uapi/linux/io_uring.h |  9 +++++++
 io_uring/fs.c                 | 61 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 +++
 io_uring/opdef.c              |  8 ++++++
 9 files changed, 156 insertions(+), 12 deletions(-)
---
base-commit: 58390c8ce1bddb6c623f62e7ed36383e7fa5c02f
change-id: 20230422-uring-getdents-2aab84d240aa

Best regards,
-- 
Dominique Martinet | Asmadeus

