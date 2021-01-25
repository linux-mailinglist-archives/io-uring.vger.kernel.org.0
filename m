Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715CE3024B1
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 13:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbhAYMMG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 07:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA90BC061224
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:14 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id c12so12042818wrc.7
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pl9AW4ZJNRuQbDJ253fXnBHqGegO9lQ780HpTe/6iJc=;
        b=K68UsxJV2S67Ng4kYAIzhffQUSP3fcShXgBMrJyF8xNITYkyaWgoAh/NsT/e3Ws9FF
         sd/pTraaJgShsJSW+vJT9KVqItCMAe+ktmOINZDDxauvpRPh7qoqu1yWAXmtHrSCPnF0
         9v/Ox5gnk0D6iLPQf6Bc5MRKTYBTS45TaJvk7hUl2BShD47ZVJDje7/oXC1B+vq1fVFF
         NlZwQOX5LxWatNFpCdkJi2gx2gAYRaC7Vn7X47AtmkkKtOQ5JRC48LldaKNtBJAr9C1S
         cVPFufmfZWKFslZBkgOMh9sI9FvXRZHe+YkDZlFibkQt+E1vMEJ9DfvCwht3FnrC9edn
         052A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pl9AW4ZJNRuQbDJ253fXnBHqGegO9lQ780HpTe/6iJc=;
        b=uVkQMo0vI3HK8t6Eq9+ckhKRLd3du4jqgL8JXb5ghVKzqJRhwTyPhoWo8ZkD+ALXyz
         XMw2yvyMhD8QlT1/60sdUM3ZKuGREQya47TOcnfDAclDyhc+z9lYHY9TiDdCTcRfCpQi
         Tm7zaqLYu+5Zxrjxn9rZex7Mb4Y2phBRdhAuxB7Tuk1WaO/gRHy0BvVv8MnBjstodo3J
         JOUSczIUv3E7W4E0ESfCgJ16vURM07zRqKHFkp9ff9hTXXDBFNpz6sjFJGeJkzqqYuQ3
         KjzHQyYU/RtAP4vSMFTey5hS8P/xlqe3LRb3FV4Z59pYu3oyG8UxLYj+ZWAHoQ1XDDwu
         /Rfw==
X-Gm-Message-State: AOAM530qC7QCFNojrecE3pErgi9h9oU+Edh4p0lRdekTCUTzespCS7or
        6xaphpjhk9FxJ3H4t0H3Aoc=
X-Google-Smtp-Source: ABdhPJzMsArd3zpV0SfWWRfyKS3uffIQlcmRh+6/RUUIJgOfFHN1/ZSimGhIzUQ/hWpKD8ZCp2h0aQ==
X-Received: by 2002:a5d:6712:: with SMTP id o18mr441870wru.375.1611575173701;
        Mon, 25 Jan 2021 03:46:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/8] second part of 5.12 patches
Date:   Mon, 25 Jan 2021 11:42:19 +0000
Message-Id: <cover.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1,2 are simple, can be considered separately

3-8 are inline completion optimisations, should affect buffered rw,
recv/send and others that can complete inline.

fio/t/io_uring do_nop=1 benchmark (batch=32) in KIOPS:
baseline (1-5 applied):         qd32: 8001,   qd1: 2015
arrays (+6/8):                  qd32: 8128,   qd1: 2028
batching (+7/8):                qd32: 10300,  qd1: 1946

The downside is worse qd1 with batching, don't think we should care much
because most of the time is syscalling, and I can easily get ~15-30% and
5-10% for qd32 and qd1 respectively by making ring's allocation cache
persistent and feeding memory of inline executed requests back into it.
Note: this should not affect async executed requests, e.g. block rw,
because they never hit this path.

Pavel Begunkov (8):
  io_uring: ensure only sqo_task has file notes
  io_uring: consolidate putting reqs task
  io_uring: don't keep submit_state on stack
  io_uring: remove ctx from comp_state
  io_uring: don't reinit submit state every time
  io_uring: replace list with array for compl batch
  io_uring: submit-completion free batching
  io_uring: keep interrupts on on submit completion

 fs/io_uring.c | 221 +++++++++++++++++++++++++-------------------------
 1 file changed, 110 insertions(+), 111 deletions(-)

-- 
2.24.0

