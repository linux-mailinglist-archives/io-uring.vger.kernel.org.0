Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05FC2DF142
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 20:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgLSTQS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 14:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgLSTQS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 14:16:18 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44754C061285
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 11:15:38 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id j18so2615708qvu.3
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 11:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oRfdfh+CNYvaiGWNMhH3iuQEALiaGZ4s9HHHr3MM09o=;
        b=hLVKNOLd4NUVG2FfHvjb7LqfBfGqmGx+j3D6I++Cl785IQ2jY+/GWjeZOBPtcl3QZh
         56+dAK8ZwhMj262zmReC+pixtF3TEHNRqln8LnDRS+Ithp5VDxxgmeCThuwXTdo7ZYMf
         LKhhx/molw2SwmDKCyUeux+Lg/qEwH9ijZxurIZNAgr8Ci72dhqyDFZGbt5f3XfdMohP
         SfcGYy1YGb5i8VvgHv/kZ5+fBKigJH15JiSBIPOUjf1Nq0/bZaoRiMwtqvlzr+TpIsFN
         4Jh/uj9iTOXVhHZ1qQNUuSU8hTlJTRgsLkvk77eoDg+Bm3iTT2NYWHixUAaXsiINAMY+
         PEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oRfdfh+CNYvaiGWNMhH3iuQEALiaGZ4s9HHHr3MM09o=;
        b=sFGAQk4G3y0el8i0AIn1ZQBMD+gM5kFfoe4/05vLs0oAeIbOqWzdyY9btN7O6yuwBS
         lt5r3p0wmMw0tOiiKZxIjYGdh9GaMtQ6t00wRteoiZLaWGfaCqBlOMzCm9Yp9AtKzPGE
         ZZD1XreJfKP7lDN5vUOKJRhia4LSCShL7rq/tvVvBT77Sb9xnG5vhAL+os/UQ+n98NZX
         oNQietdSjWtaHZFNPqsQid2jyccHHHpCQhhMyvozORzDmGdtmzYUsR4J8pGuhQauOFHZ
         HvE5wgxmwmvZPAyEEGCsX0FvEt3Dpfbfirc1AW9ocyO6uL9oAwLySpqluq3rCgWPEX0A
         Jehw==
X-Gm-Message-State: AOAM531EUaZyoH2DlxX2IRxx2sug449sIrjxqd5Vy7Ynld0gAiC11OmQ
        ZmBLri5V/HiJ8lAUkDBPUGc=
X-Google-Smtp-Source: ABdhPJwKecgnxYPHinPRPxKkquAP08uzwf58NCF+XX3WYBtdXuHQf1g2w7R20kwOdjvbHv271GU7aQ==
X-Received: by 2002:a0c:bd9f:: with SMTP id n31mr10801582qvg.42.1608405337466;
        Sat, 19 Dec 2020 11:15:37 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id 17sm7335488qtb.17.2020.12.19.11.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 11:15:36 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v2 0/2] io_uring: fix skipping of old timeout events
Date:   Sat, 19 Dec 2020 14:15:19 -0500
Message-Id: <20201219191521.82029-1-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These two patches try to fix a problem with IORING_OP_TIMEOUT events
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

v2: Properly handle u32 overflow issues

Marcelo Diop-Gonzalez (2):
  io_uring: only increment ->cq_timeouts along with ->cached_cq_tail
  io_uring: flush timeouts that should already have expired

 fs/io_uring.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

-- 
2.20.1

