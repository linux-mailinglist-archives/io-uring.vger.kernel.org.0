Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD05174E44
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCAQTf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51547 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgCAQTf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id 9so2270436wmo.1;
        Sun, 01 Mar 2020 08:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vW+Ty405jQ8HcjAn8g6TletdwFBEFprHNMTBYXmVxvw=;
        b=WiDrt86p2qgfDc3uubQrmC204LYld9wyx9Ibu2TPRNo8CxkGZf4SUHnwkqTgqlDtYK
         n7VoqwhP7/D7N+8mZvgtOLWgUs5fgLS1FgjkEqz7eYY0cOhDr1GaHVIZDp5GaFZ9/NBy
         CvnrW2inMePmNagrot2v5xHlYf6ldAubWFVCzYfibQBcgUckjqfvn5irK/1IRlKocyIS
         /I56cbkn1vj+Uv7evpeKIw/GVQfGwTyXXnAECSgqsWKsfQk7W1DQJc2ZLvPUiqOS3OoB
         0HAXMmBoJWPttCz1/DEQXp5qFk4Oie4cOEk1m1qD216ibcfp/mTNVFsQiIy4l7gv9ezK
         NZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vW+Ty405jQ8HcjAn8g6TletdwFBEFprHNMTBYXmVxvw=;
        b=InzhvAMRyI6ZIl+1qbBVXdllmTYUWeRhEJ2/eORXIpakp3UPD+uWvWMkn6dkvz7q1p
         yqGCzoeHnH3Qz/nLmtv5RoQu0cXp38iuqNGyGkm7OuAn6kXxmfEPN7turuRcfPVZbKhv
         jp55JPKjHtcvg9wglWJoy3qXWmNp0ZvfR08aqVjTkKHAd77VcaMAxknbWmd06vcTasQN
         3IYawFl5Ea8rzyVn3QGMP6I/lkJBEXKM7yI3TwqrVuobk6jthBLGGVa0ioawrQwWOnHO
         NQbe6EGx5TupVEbV1OzDJQGji3TG+HaLvY8yu1258PMz3Cgx6WbSUELl3ud7bf++tEYV
         bP9Q==
X-Gm-Message-State: APjAAAV/ue+oiXz4WuCEbm45QgfqSRowYhUwQvyl61rnxHeSI0E3BpPw
        uFkpTQ2uarOrFdbkkFHhXfE3VBYx
X-Google-Smtp-Source: APXvYqxUAjrGCEyLC6AwS6GMYW4sAUUtt3bi8y7e4qD5siCe+aPMuMpyxW2CBpKoSwg4J8cyHg+Ymw==
X-Received: by 2002:a05:600c:2951:: with SMTP id n17mr6916119wmd.97.1583079571366;
        Sun, 01 Mar 2020 08:19:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/9] nxt propagation + locking optimisation
Date:   Sun,  1 Mar 2020 19:18:17 +0300
Message-Id: <cover.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are several independent parts in the patchset, but bundled
to make a point.
1-2: random stuff, that implicitly used later.
3-5: restore @nxt propagation
6-8: optimise locking in io_worker_handle_work()
9: optimise io_uring refcounting

The next propagation bits are done similarly as it was before, but
- nxt stealing is now at top-level, but not hidden in handlers
- ensure there is no with REQ_F_DONT_STEAL_NEXT

[6-8] is the reason to dismiss the previous @nxt propagation appoach,
I didn't found a good way to do the same. Even though it looked
clearer and without new flag.

Performance tested it with link-of-nops + IOSQE_ASYNC:

link size: 100
orig:  501 (ns per nop)
0-8:   446
0-9:   416

link size: 10
orig:  826
0-8:   776
0-9:   756

Pavel Begunkov (9):
  io_uring: clean up io_close
  io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
  io_uring: make submission ref putting consistent
  io_uring: remove @nxt from handlers
  io_uring: get next req on subm ref drop
  io-wq: shuffle io_worker_handle_work() code
  io-wq: io_worker_handle_work() optimise locking
  io-wq: optimise double lock for io_get_next_work()
  io_uring: pass submission ref to async

 fs/io-wq.c    | 162 ++++++++++++----------
 fs/io_uring.c | 366 ++++++++++++++++++++++----------------------------
 2 files changed, 258 insertions(+), 270 deletions(-)

-- 
2.24.0

