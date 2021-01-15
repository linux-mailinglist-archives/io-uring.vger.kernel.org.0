Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5372F814A
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 17:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAOQzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 11:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbhAOQzr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 11:55:47 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D53EC061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 08:55:07 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id a6so6463213qtw.6
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 08:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gViQnJs61iYjF2bOp22g+4OK8hn0HHdPx9JWH0/T2FM=;
        b=oQJPz/G1YrSSuM+txoASn/rZ1s5V3OfCgNO8G9D1P8x4RVqhKQ11uN6woy+UiLVkSV
         GbuaLg9OywEn/ahumLIb5GgAqIsbkbiYAUuXUlLvppgY05nA/D6uuf6mY+pwktc+IIki
         FtMzKewhs4WOZrkcu0k+HBjmiIBMhHCYWqLfr+6YNbNilYgk9nl2QrMBoFrIm9L1gj2S
         bgns9N2WRDUKyGh6HPh8BWRx8LXWY+z6ukjz+B6diQQLTzw62mHsPW/lGeSEo/09aeXs
         Deu2px9CM9eecSXo6jlQBbOT97HIcrMWXUlLHKeup3GpeD7tVJNRO8G7J4hFXooaFivO
         +4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gViQnJs61iYjF2bOp22g+4OK8hn0HHdPx9JWH0/T2FM=;
        b=HcBLa4Sg8kEp5jbpOm+k0uhI8Ab8eX1JNvfFUYdsPGmCzu/6Q4C99jw+HWIDGNs0+F
         6Q259PpXC11Krjqscoe1uCke3What3zV7NdbXE18tnJ05hzMWrlQreMEvOijG5IV5Zfx
         xUoA1qnhmQyO8qeeZHXXRUfY8K3CdWCQYVEeknxQJfjJsSLGbd4ON6LWISe1KUKxR754
         puCk/4ONHNyd0OX5unWA1d19KCnn7HSiarYtF5Bnjcod1UkhWUj6o7xEWOn8sIIatxk4
         fbPQi/b89aTBK823CADb83XeQBZUsrOuTgi8CC120AlVRB+Ib58p0ZPdSQ9+FNpQZkRq
         vO8w==
X-Gm-Message-State: AOAM5305g22S+IvrBSIqCCoa8dYs4nTz/A/QZLSi/x5/utE8k9kkKmYs
        TejJ2L3n31JoBiv9HzBx8BU=
X-Google-Smtp-Source: ABdhPJwCLEcALXx/lvlG2YnpjBKA/9NX93Vu4ZLs3t8WoPYZKnScydJ7FSt1qgfMhMxDtyhGQiQX4g==
X-Received: by 2002:ac8:794e:: with SMTP id r14mr12567574qtt.130.1610729706666;
        Fri, 15 Jan 2021 08:55:06 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id n7sm5276366qkg.19.2021.01.15.08.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:55:05 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v4 0/1] io_uring: fix skipping of old timeout events
Date:   Fri, 15 Jan 2021 11:54:39 -0500
Message-Id: <20210115165440.12170-1-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch tries to fix a problem with IORING_OP_TIMEOUT events
not being flushed if they should already have expired. The test below
hangs before this change (unless you run with $ ./a.out ~/somefile 1):

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <liburing.h>

int main(int argc, char **argv) {
	if (argc < 2)
		return 1;

	int fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	struct io_uring ring;
	io_uring_queue_init(4, &ring, 0);

	struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);

	struct __kernel_timespec ts = { .tv_sec = 9999999 };
	io_uring_prep_timeout(sqe, &ts, 1, 0);
	sqe->user_data = 123;
	int ret = io_uring_submit(&ring);
	if (ret < 0) {
		fprintf(stderr, "submit(timeout_sqe): %d\n", ret);
		return 1;
	}

	int n = 2;
	if (argc > 2)
		n = atoi(argv[2]);

	char buf;
	for (int i = 0; i < n; i++) {
		sqe = io_uring_get_sqe(&ring);
		if (!sqe) {
			fprintf(stderr, "too many\n");
			exit(1);
		}
		io_uring_prep_read(sqe, fd, &buf, 1, 0);
	}
	ret = io_uring_submit(&ring);
	if (ret < 0) {
		fprintf(stderr, "submit(read_sqe): %d\n", ret);
		exit(1);
	}

	struct io_uring_cqe *cqe;
	for (int i = 0; i < n+1; i++) {
		struct io_uring_cqe *cqe;
		int ret = io_uring_wait_cqe(&ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "wait_cqe(): %d\n", ret);
			return 1;
		}
		if (cqe->user_data == 123)
			printf("timeout found\n");
		io_uring_cqe_seen(&ring, cqe);
	}
}

v4: Reorder ->cq_timeouts read, and add some comments
v3: Add ->last_flush member to handle more overflow issues
v2: Properly handle u32 overflow issues

Marcelo Diop-Gonzalez (1):
  io_uring: flush timeouts that should already have expired

 fs/io_uring.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

-- 
2.20.1

