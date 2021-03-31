Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B39350826
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 22:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhCaUZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 16:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbhCaUY7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 16:24:59 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E61AC061574
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 13:24:59 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b16so23783256eds.7
        for <io-uring@vger.kernel.org>; Wed, 31 Mar 2021 13:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=1fjLWaOqrkaLshYXUsAkkbIWuZJq+y4Wn9WZPL/q3Hs=;
        b=eiTvTyLA+r6R9ayEwBXyzX5jGTXh+H+da6xpfztSN1qfSntv9fXtP1RLRRUx/CQDbB
         vd0yvicEeYVZX5UyUy+DssLQhBYxJZUm+URDAIeMv/4VYED4PlocoHV/h9uBiiybgC2E
         KSCZfGKmbbREHuAAj00zMR/My8FTeA74SvMCvL9HaainUnLikt9vSJuKJVum8/GdAs5O
         /WNfXvL2vIxB/10yxloXqYPstc5qNGpM8NZY2RFSVgq4ErXAObjLA0yUcOL+QwfSnvZx
         q5/H8VrujbJ1dSXyLz3RirrwESdzzQJChkHdAdgAnqzGVdlBitussct8S7tfje+E0NOR
         5kDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1fjLWaOqrkaLshYXUsAkkbIWuZJq+y4Wn9WZPL/q3Hs=;
        b=Zp429ncQlfxvjWV7v2k6zWpofRGetArnbijgt5UTZYrVcr14GrOXRtIvCUBvieM9us
         edCDckCZuXX9w3q2NXghbud5zcDJYum9lWdZAM6741SYyv2euUuinGn8YYl32VKw7xmz
         Pq6SNwxaBP24avy5YFwe7pqq7Kj2ZEq6ALHUqcJtgTsoEs9tuq1kgTP1jFJg5fi70cYK
         FLIoN6JbOqkw9e0ToPbIhF+nE+v8W2mZBJ8Q6vEBcDiEma9m7H3aoxQdN2+JmoLnykwR
         4ijcAiZC4iYnM9zIiIl4yu18QxcyA9kxuMsB9c+wrFJx01cuWGwWLnW1tc5nghn4hM1a
         CuvA==
X-Gm-Message-State: AOAM5321s8pkRAhVT+jGSqnhoZNIkhD8kWU1L8no1sqCAJUhsSJMV/Om
        Z6HqTZQ2fr6pH7a9ItJ0oLxLqFCmwg==
X-Google-Smtp-Source: ABdhPJyYouYwL21Tn0/IH6fO6gKrEH9cB9Dfa3UYXKb+UGhhTtN3JTai3QHCyF4WIyETQrIydZvi1g==
X-Received: by 2002:a05:6402:1d19:: with SMTP id dg25mr5986394edb.218.1617222297911;
        Wed, 31 Mar 2021 13:24:57 -0700 (PDT)
Received: from localhost.localdomain ([46.53.254.127])
        by smtp.gmail.com with ESMTPSA id m9sm1746536ejo.65.2021.03.31.13.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:24:57 -0700 (PDT)
Date:   Wed, 31 Mar 2021 23:24:56 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: buffer overflow in io_sq_thread()
Message-ID: <YGTamC6s+HyF+4BA@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The code below will overflow because TASK_COMM_LEN is 16 but PID can be
as large as 1 billion which is 10 digit number.

Currently not even Fedora ships pid_max that large but still...

	Alexey

static int io_sq_thread(void *data)
{
        struct io_sq_data *sqd = data;
        struct io_ring_ctx *ctx;
        unsigned long timeout = 0;
        char buf[TASK_COMM_LEN];
        DEFINE_WAIT(wait);

        sprintf(buf, "iou-sqp-%d", sqd->task_pid);
