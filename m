Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8C34ABF4
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhCZPwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhCZPwP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:15 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675A9C0613B5
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:15 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id v26so5841813iox.11
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NTT4HsvI3kjbzvwySLsQmNjt7JR4etvocB0sNfxH6sA=;
        b=vTlCnlJhHEG4rMMQ5bt1Sd3zNpAol+alVO3sVPstXTCedpEvmJ74f+p1MKvd1x3Zjg
         esjyVJ+vE9oGvBHklpobdVkX3/js61qy2woCpK9mE4VC4o2nR486fTZq2AcKJ/mYrljv
         DkDbuT1li7r5yTTyY0Ho8U1BgjDgMRQRwOgbPPtXuqZD3W9J6FG927fc32qTaX3Zi3LF
         19zl+cxUapY9vJ+J59bfaxblVdHs43kGB7awBrOajQ97dyAahG1HFdPnPdIJU6xylaqs
         /Yx0+OmlhyJHdLjGZOWrCanf4sT1Sk0tECEDAdq6rttcqZQecwPL7iQaypChV+HGIStN
         msSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NTT4HsvI3kjbzvwySLsQmNjt7JR4etvocB0sNfxH6sA=;
        b=rlNebSuNBYgJoijk0RR/49jG+znYuWiU9jpXS/HIY2/Odi6ksfKMIWEI1R/umJghFk
         zW5ZGmW9y5p4A0c1ZERvi/+2ZETxuhrudBH8rZX3Ms06bp0lvqD4okbWFcAVaib1QAD3
         V3teXmWqgTnmcFC1WjDXTbHGcyizhB5Sg7NqDFsFpYNEM5/9e84/o+Y4TxbbdfoZXEP1
         NqQqL9EkA+QXHXFr16OTlPEgNycqDF/jniV3hZ3CRQT2K5s+wtFJdJreKwngi4XMXCug
         bH1+stQ9k9e51/eG5/2jK0JDQJPCrXhzKxTwPZ76ECK1LhIEHQVqub0g7li6fm+7Cziv
         USyw==
X-Gm-Message-State: AOAM530qFqF8p/lA2nuVYLlPG2BB4/2ib7BQAVPWO+zJD8jkKWEEFGzD
        jFy0fc9Dc/u51ClPTC6JMkC5XooYcIinPw==
X-Google-Smtp-Source: ABdhPJxy+J23GP1zva7BpruSxdUjVOnAbqddqHsJbDtBo5xZMkKdEZEoNMyD9ByYYdAbGsJXfGJI3A==
X-Received: by 2002:a05:6638:d47:: with SMTP id d7mr12473118jak.2.1616773934732;
        Fri, 26 Mar 2021 08:52:14 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/10] io_uring: don't cancel-track common timeouts
Date:   Fri, 26 Mar 2021 09:51:27 -0600
Message-Id: <20210326155128.1057078-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Don't account usual timeouts (i.e. not linked) as REQ_F_INFLIGHT but
keep behaviour prior to dd59a3d595cc1 ("io_uring: reliably cancel linked
timeouts").

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/104441ef5d97e3932113d44501fda0df88656b83.1616696997.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 69896ae204d6..4189e1b684e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5563,7 +5563,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	io_req_track_inflight(req);
+	if (is_timeout_link)
+		io_req_track_inflight(req);
 	return 0;
 }
 
-- 
2.31.0

