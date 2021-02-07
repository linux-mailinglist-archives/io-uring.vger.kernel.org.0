Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A41312864
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 00:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBGXgx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 18:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBGXgv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 18:36:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852B8C06178A
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 15:36:11 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id a16so11212523wmm.0
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 15:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pJuC1ZDeL8m4ieq9PzDYGXq1hHvSdJdK+FmO18tqrQI=;
        b=dKcqeNXKAaNv+R+e2yPard7xUUBRCJju0VmvxT3EW4McyUmk1pj5FivHcbgVstu5ON
         HsWfkSMA5juxR8gwfwuDobxctVMe3HB69g0nHXLEKHCZRmTP0tuWFGMKgPSJaUPk/a86
         kbGP3Dr50L9AvdABqEa9MtZVbri6G8f+4Gp6/uX0k2K4YPmm67+ciUHs87teNAndUUBZ
         IzjBj3j3TZCvDxHpNi12FL8aGdw1nplfhYCCim311QeMfaHEgINBCiU2mPWBD2khaBWa
         R/37nsCE3e7yOKrfuTioIgnfMFP1f/EhqeWqxBrawGh4v3fCkjSoMh4R8PMzXJGQ6nE5
         4WUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pJuC1ZDeL8m4ieq9PzDYGXq1hHvSdJdK+FmO18tqrQI=;
        b=Gm3+o/gojs6ZctjEZMhqyVXvLZ3CF3NK27wlHV5GIwqqpBEwR3zyxPnyq4EoiXdFdU
         JTMpWni9S25dHo7ea6PY+bvfo4LHBjMYhuJOk9KdmIyCQHTr8iXpffl4xCwDDxG3b8lv
         OgJgc0jH3VWzeBilmHT6rasaGuOpL0Z/4na79tezx3D8P2iVZ9Lz230kufgBnRfDd2lC
         bX9sOvjWgPgkiLxLwbvia1NT8rVhdOGnIDzPFKtgUg2mY528xOKg3Kyk2y0LSuKxakT8
         pblTIPvUtEBjLUsWHPm60BQe4K5lY8Mvs92/U7FAPJrZL3ZK/tgliUunhkdFjl9dxSNP
         gFJw==
X-Gm-Message-State: AOAM531F8Wc9xNKhmvVcwSGfpzFVQo6SrTP9xOsXpE6yt8CocK3ZvVad
        mzdt5AFwumWm6ven38aMKl0=
X-Google-Smtp-Source: ABdhPJztpVF+2UKUC6tngTOlVj2O3Z6Eg9hRihwehhUD9NRw0VJCinBMmDcE9CIwIiAkSDCUBkYWjg==
X-Received: by 2002:a1c:c904:: with SMTP id f4mr12672698wmb.14.1612740970376;
        Sun, 07 Feb 2021 15:36:10 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id l10sm25453380wro.4.2021.02.07.15.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:36:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Victor Stewart <v@nametag.social>
Subject: [PATCH liburing 3/3] src/queue: don't loop when don't enter
Date:   Sun,  7 Feb 2021 23:32:17 +0000
Message-Id: <39bc4096ded4d4d0e8f8059bff52a51d16617213.1612740655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612740655.git.asml.silence@gmail.com>
References: <cover.1612740655.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

_io_uring_get_cqe() can live-lock in some cases, always return if we're
not going to do __sys_io_uring_enter().

Reported-by: Victor Stewart <v@nametag.social>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/queue.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index be461c6..8c394dd 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -89,12 +89,13 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 {
 	struct io_uring_cqe *cqe = NULL;
 	const int to_wait = data->wait_nr;
-	int ret = 0, err;
+	int err;
 
 	do {
 		bool cq_overflow_flush = false;
 		unsigned flags = 0;
 		unsigned nr_available;
+		int ret;
 
 		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
 		if (err)
@@ -110,11 +111,13 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
 		if (data->submit)
 			sq_ring_needs_enter(ring, &flags);
-		if (data->wait_nr > nr_available || data->submit ||
-		    cq_overflow_flush)
-			ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
-					data->wait_nr, flags, data->arg,
-					data->sz);
+		if (data->wait_nr <= nr_available && !data->submit &&
+		    !cq_overflow_flush)
+			break;
+
+		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
+				data->wait_nr, flags, data->arg,
+				data->sz);
 		if (ret < 0) {
 			err = -errno;
 			break;
-- 
2.24.0

