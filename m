Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4987B344E01
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 19:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCVSB3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 14:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhCVSBL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 14:01:11 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A3CC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 11:01:03 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id x17so3613787iog.2
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 11:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oueYsVC3DH2HRQ1hDjUw3K5rrsKY3IqbV5dAewJUVSY=;
        b=OnAluE5pplIsLuyhbBfh5q+90OVMOzrB96PW9ooIMbj5qGoW3uCczHDdrBG7f917sP
         5K76TaKRctBL1Jq6UwqAgbWwaYTPW9izz3IgoaN6Qg441dUEzk5sfOoLlmn5XzyZdiwK
         MwjmXAIaSMRD7FLFL5H/+ceYIc8+Zj2UOOk/nijxMr1hvHwrX6j1jXLtOwm5gMOnhMA7
         vpC2a35oE8pQ7TqQzUJgdvdhKC76rcvVgKIAH+D/pL8RtAmnamu29NrWuCaYdsM2Nu+T
         tca7MAc6GsL6UwRbDL6s8m3N4Ky9e0DSAO/039zq8JgB90/CA1TcJ6FQ/Wv8O3eHKBq9
         /AKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oueYsVC3DH2HRQ1hDjUw3K5rrsKY3IqbV5dAewJUVSY=;
        b=V93VURmAjlvwRHK3mmZUuZMliZHpFKaYLdiirexHR3VeMEdX4tkvX5AMFcQ1n9Mk79
         Om4QiVD1Z4sX9FtlmDPuU7OGqih+9vxTyhFbProSmyMqOSSgdLKQEKxX04QkaBF6jGd0
         B92crhq5C3vj0qQelKFW1gLdaaGAw7/N6lD2gYoAh/qwLNJmKKGarbVeU6Vch1mcXcoH
         5hE2Ch05t0S5dvBkA9QqqWVvORicvVAcIaniLa/FHcgHbdhMaRZ9w7v7GV6i33m0a5iA
         8nbwK6qAwiyHzx1xJ9yhbuHwL7hIZJpIDq/xFMsJzwvfB8TIQhI4XkIxSAF7lh67flZt
         /6PA==
X-Gm-Message-State: AOAM5327YYQra1arBPgpLdgZIXUtHr4UGMqCQs0/6Z0jb/+NB4SwZbOr
        mVaf4zix3ilJC1RyHvd51bFxofPdvNNtVA==
X-Google-Smtp-Source: ABdhPJzX7w+oHVaI+rYXR97e3SVaBvI2efK7+oncE8smonIpK1cmdLLmMhGTQxCEKDiNf0r8PGQfpA==
X-Received: by 2002:a02:ce8d:: with SMTP id y13mr538574jaq.29.1616436062730;
        Mon, 22 Mar 2021 11:01:02 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r12sm2903562ile.64.2021.03.22.11.01.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:01:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Eliminated need for io thread manager
Date:   Mon, 22 Mar 2021 12:00:57 -0600
Message-Id: <20210322180059.275415-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Currently (5.12+) any ring that gets created will get an io-wq manager
created. The manager is tasked with creating async workers, if they are
needed. Earlier (5.11 and prior), io_uring would create the manager
thread, and the manager thread would create a static worker per NUMA node
and more if needed. Hence 5.12+ is more lean than earlier, but I would
like us to get to the point where no threads are created if they aren't
strictly needed. For workloads that never need async offload, it's
pointless to create one (or more) threads that just sit idle.

With that in mind, here's a patchset that attempts to do that. There
should be no functional changes here - if we do need an async worker,
the first one created will stick around for the lifetime of the ring.
And more are created as needed, using the same logic as before. The only
difference is that a ring will NOT get a thread by default, only when
it actually needs one is it created.

Comments welcome! This passes normal regression testing, but no further
testing has been done yet.

-- 
Jens Axboe


