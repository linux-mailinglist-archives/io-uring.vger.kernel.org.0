Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF8E2F652D
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 16:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbhANPuz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 10:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbhANPuy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 10:50:54 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911E4C061575
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 07:50:14 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id h1so2455255qvy.12
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 07:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3BwGg4HOW6DMwl/57Hoo5Gwnz29lE3JhtZoZ884UFZo=;
        b=K3Z5L5EGf5uc9jCEU1/iWtZgaEmDPaBKbSSYqH0zzaURcX6uwe5S+qVYIqCJSVHT0x
         NVtwsa+HqqqFSDnjuaJv8FW+PNK68otRaJZ2R82TeSx5Qh9MtJjUjzjsar9A7Q/w+SI4
         5G3vK+RbS6+4jzGlvw8r0maOgYp8SqpvJTZjS81rqfyN45jkZCq8xgyGG72miNsM7M+9
         y2Is5PXc/mshLOpmTi/MA3My0sJuTEa2jdReuyqphVZVsYGIlau24cssj73Qs4R+9lVp
         EDAnMeV670mPOPVuLaSysM8oZoRvqpI7bG1gDCeIdzcD/6ccfCIrPkk6V8oGBKxiZm9p
         dpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3BwGg4HOW6DMwl/57Hoo5Gwnz29lE3JhtZoZ884UFZo=;
        b=rqSwMde/5/cnhV5qprlaIPdTbWKQ+qSqJfzESKJk9NnxZNiOayoaGsPCn413B84ogL
         04PSQwuGdDEARWL1WFPj+vpEgjCMu0NdLJUmX20IPH9wbjVM7HHxHNC5botHlgxqt05B
         7orPKNhmhkeYJVtaY9dSJ8lg5kwAaPpFLVvFPaS3U+jqmAkenobjdx5JRv/fs7wdQCDv
         huCf71fKFn+EK7+1kC1rkCuGi/+rgAS4bDws2MIZ+TuohsjjqUqH4Ra+GXtQF18hFxbL
         2BBnhipElQDeiYhxvyYvPZifzb7JuMy0hLnLfQSkek7aqLwqE0bv9hvRWSFOSNexpjN1
         fwdw==
X-Gm-Message-State: AOAM531RkGwVCRncptTvOCcu2afGLAd4LDonxZHlcB6lJzISZDOFa8oo
        wmZ/PTC6LPmXqlKehE8aKtk=
X-Google-Smtp-Source: ABdhPJzbQif0o15wpNcf3Gim7yh1tEI3rVolfbdv8mNQj0sPSvryDe/i7T7W9/ERzGv1x+B8Cx9HAQ==
X-Received: by 2002:ad4:5901:: with SMTP id ez1mr7700396qvb.6.1610639413919;
        Thu, 14 Jan 2021 07:50:13 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id a194sm3149029qkc.70.2021.01.14.07.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 07:50:13 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH v3 0/1] io_uring: fix skipping of old timeout events
Date:   Thu, 14 Jan 2021 10:50:06 -0500
Message-Id: <20210114155007.13330-1-marcelo827@gmail.com>
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

v3: Add ->last_flush member to handle more overflow issues
v2: Properly handle u32 overflow issues

Marcelo Diop-Gonzalez (1):
  io_uring: flush timeouts that should already have expired

 fs/io_uring.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

-- 
2.20.1

