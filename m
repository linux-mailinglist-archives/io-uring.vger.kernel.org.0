Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15567795E8
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 19:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbjHKRMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 13:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbjHKRMs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 13:12:48 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52F919F
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6873f64a290so501405b3a.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 10:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691773967; x=1692378767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=yH6KG3+EAxHzyHZJpawLo8xckY0qtQdNL1GWHc/8kl4=;
        b=ukTReQKhLnyA6ySc++gGxFNNrRNp/5lnCSlk4xDo2vQwOePj+7oLz20x8gG1Vw+hDZ
         hVDc/Ob0ITonkAmrMnENcvuh3HjqBDt/7xcH1rLUQJTGkz64zaM1c++oFaLUoTA4fqxu
         XZx4lxb0DPsCJaEon4eC7KBbAKk/2a/ihOBNdj3FhwG4hG1C7r9ihc3ghPzf5/fR+/i4
         6nxgTWsvOp57XxX8V5h/UbxZhe0zeu38H6nhZnMNLGtplWpU5lGmgWpN69dnHDWi384F
         97UlriKEVf5pnTRZ+AvlxaHT4phq3OUR4uYYlMvy0K3XCmam6Scquz0mC7QiDXShvtfi
         O0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691773967; x=1692378767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yH6KG3+EAxHzyHZJpawLo8xckY0qtQdNL1GWHc/8kl4=;
        b=XHTdx8vys/pCXz/Bdn4R107LCiQH/e65DVk74wW+5onUICPj6nUx3gVNsLpFR05Yjs
         3SAx/OdgBoVNc/MLAdicDnzdP3vqYsPgX6eYM6mcSsssVsijHLjxcOg4Ea4+i35thakg
         iGfqQ3x5PK42JP6auPEYP2yxkk8ora+0A++2mZE+sbTUXzD7phxqag49PTiFsKnXJByo
         atpTXhrFUHJY9rltxS5zlAI5K+zFZpMoaS9ccU+bHYdaWRMXy57j5oKuTWfEwUMdV4BC
         91nH1IY4cQjthqPWTzHk0BGFbmm8SHdY8m+E4iIj4ADmGsBIg4/yka+Y7SZ9OYUXWlo2
         soYQ==
X-Gm-Message-State: AOJu0YwpiY0fvOFPO7otXo/T/3TSGpsYP3MbyiJaiMhdX7dEyWV5WK9u
        BdPSYqzscXw3qE2ukpleFg3fRx0vsAoq1d8nCjg=
X-Google-Smtp-Source: AGHT+IG3GpFCatmHj/4UyrMs9h6ObwGlS4sGiJ0bG2yKJLhEhvpxHEDBjdYfVAADoi51GgzuhigqrA==
X-Received: by 2002:a05:6a20:440d:b0:13d:1ebf:5dfc with SMTP id ce13-20020a056a20440d00b0013d1ebf5dfcmr3258507pzb.5.1691773966728;
        Fri, 11 Aug 2023 10:12:46 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u20-20020a62ed14000000b006870b923fb3sm3541250pfh.52.2023.08.11.10.12.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 10:12:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Ensure file refs are dropped on io_uring fd release
Date:   Fri, 11 Aug 2023 11:12:39 -0600
Message-Id: <20230811171242.222550-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

When the io_uring fd is closed, we ensure that any pending or future
request is canceled when run. But we don't wait for that to happen,
it happens out-of-line in a workqueue. This means that if you kill a
task that has pending IO with io_uring, when the process has exited,
there's still an amount of time until all file references has gone away.
This makes a test case like:

#!/bin/bash

DEV=/dev/nvme0n1
MNT=/data
ITER=0

while true; do
	echo loop $ITER
	sudo mount $DEV $MNT
	fio --name=test --ioengine=io_uring --iodepth=2 --filename=$MNT/foo --size=1g --buffered=1 --overwrite=0 --numjobs=12 --minimal --rw=randread --thread=1 --output=/dev/null &
	Y=$(($RANDOM % 3))
	X=$(($RANDOM % 10))
	VAL="$Y.$X"
	sleep $VAL
	ps -e | grep fio > /dev/null 2>&1
	while [ $? -eq 0 ]; do
		killall -9 fio > /dev/null 2>&1
		wait > /dev/null 2>&1
		ps -e | grep "fio " > /dev/null 2>&1
	done
	sudo umount /data
	if [ $? -ne 0 ]; then
		break
	fi
	((ITER++))
done

fail with -EBUSY for the umount, even though the task that had them
open is gone and reaped.

This patchset attempts to rectify that. Patch 1 switches us to a
simpler private percpu reference count, which means we don't need to
sync RCU when exiting. A RCU grace period can take a long time, and now
the task will be waiting for that when exiting the ring fd. Patch 2
tweaks when we consider things cancelable, moving away from using
PF_EXITING and just looking at the ring ref state instead. Patch 3
finally does the trivial "wait for cancelations to happen before
considering the fd closed" trick which fixes the above test case.

-- 
Jens Axboe


