Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A3A4877E3
	for <lists+io-uring@lfdr.de>; Fri,  7 Jan 2022 14:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiAGNC1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jan 2022 08:02:27 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:44668
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230218AbiAGNC1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jan 2022 08:02:27 -0500
Received: from integral2.. (unknown [36.68.70.227])
        by gnuweeb.org (Postfix) with ESMTPSA id 76C23C00E2;
        Fri,  7 Jan 2022 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1641560545;
        bh=rAWzHPQU/qBZ7SLNNkOvxjWtaOMwpHxMsutZJSUpV14=;
        h=From:To:Cc:Subject:Date:From;
        b=QKJyQqIJOpsPh+Jg4JXz1uHRq681kNIHH9mfAok0UIs9+xNjh9mZEcaJ5WyhUGXrW
         F9l1oKAOca2g+dJLP4RRhlNgKY/3ISmKt4q1pxXif/DCF9kA/s6dyYzMbmgUHBmbIl
         VnGKWlYurvNsd4OQ0iozVBaCAaJLEEjbBhLIyjIyb6gkO+6TeKVmZcoPwgjj6ZerKp
         cHMDFZzR9I9+xIX7fUEm4zWv8FoNwRhiuc7qe7qE17rv4QjTNX+psPG2qAeDFrlrJy
         BAojgv9Y7wKdwRzSQFArSO8/ojnN5ceIfzg+JZ6fh4QVU+Nym3fUM8C/oi2cMZVZcq
         j3ii4f6qRgIeQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH liburing 0/3] Fix undefined behavior, acessing dead object
Date:   Fri,  7 Jan 2022 20:02:15 +0700
Message-Id: <20220107130218.1238910-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series fixes undefined behavior caused by accessing local
variables that have been out of their scope.

FWIW, compile the following code with gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0:
```
#include <stdio.h>

int main(void)
{
	int *pa, *pb;

	{
		int a;
		pa = &a;
	}

	{
		int b;
		pb = &b;
	}

	*pa = 100;
	*pb = 200;

	printf("(pa == pb) = %d\n", pa == pb);
	printf("*pa == %d; *pb == %d\n", *pa, *pb);
	return 0;
}
```

produces the following output:

```
  ammarfaizi2@integral2:/tmp$ gcc q.c -o q
  ammarfaizi2@integral2:/tmp$ ./q
  (pa == pb) = 1
  *pa == 200; *pb == 200
  ammarfaizi2@integral2:/tmp$
  ammarfaizi2@integral2:/tmp$ gcc -O3 q.c -o q
  ammarfaizi2@integral2:/tmp$ ./q
  (pa == pb) = 0
  *pa == 100; *pb == 200
  ammarfaizi2@integral2:/tmp$
```

Note that the `int a` and `int b` lifetime have ended, but we still
hold the references to them dereference them.

Also the result differs for the different optimization levels.
That's to say, there is no guarantee due to UB. Compiler is free
to reuse "out of scope variable"'s storage.

The same happens with test/socket-rw{,-eagain,-offset}.c.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
Ammar Faizi (3):
  test/socket-rw-eagain: Fix UB, accessing dead object
  test/socket-rw: Fix UB, accessing dead object
  test/socket-rw-offset: Fix UB, accessing dead object

 test/socket-rw-eagain.c | 17 +++++++----------
 test/socket-rw-offset.c | 17 +++++++----------
 test/socket-rw.c        | 17 +++++++----------
 3 files changed, 21 insertions(+), 30 deletions(-)


base-commit: 918d8061ffdfdf253806a1e8e141c71644e678bd
-- 
2.32.0

