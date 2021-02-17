Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D321031D9A7
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 13:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhBQMmo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 07:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhBQMmn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 07:42:43 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB94C061574
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:02 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v15so17255216wrx.4
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e2aGwBdJDGn1kPtWl04w3FtQM1Uf8r1aAIefYon93nQ=;
        b=FNQlOuwSZjOI79Y4zORmycvIyJzR1l6QxvHBvq2WwVpFQhjOvht/yFqdOtFIuIozul
         HzQ+dFkdUXQX9SFXdSOZNFSfF+CpcuA0/OhNzech67SIPFeQLOjGDjW1NMNnrcQyDOi3
         ORPSXBThZe+ko0+udoZmwDwp+TMAn1DP+86zM4tWWtkeld4VqbfNpEPxmiIlX2B2RKjD
         KpAsuMs1am88VGJSurirpkU2BtJOg7UdJX8SZc9/ocg2YeUF+2yrCLyRcjYXYIdiM0LF
         wh8UFJfo6iBNVt8XhyATLNZkMfVkx4qPgliEC0A0dimWR5zLPyQvRF/j+rKkcczA4N2e
         az1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e2aGwBdJDGn1kPtWl04w3FtQM1Uf8r1aAIefYon93nQ=;
        b=XpaVc9B14mdJgG+4Yrb3hVAVV+uSOgbRhajU+NZwlu03MzliKr/nbKT4rWtP+vV15/
         2s08Kuh63DeMkJRmBs2tHjGBY3D2ZLlZtD+0CIK5ys76RG8uBJOUtwLOK4ULFzJh0F/v
         iRA/nB6X7nsj4lN2xTSYnGcYlhFqXDFAYBJjLpMzpDs0Q+7n74ynnwAXK2fetJ6z0/Fw
         pLWh7bvK7YsoykVM/gH2i5nwkFtVaD4TmiVAXfJIe7Qsi7U/6Igl5fOXDsfM1p0PbHTs
         zfJRE+Y/u5A0Wh23+tnZJBQigjYu6zC8eBPBlPi2MuFZRQq8dvAmUNb6BRUSy41ORS3l
         ipDQ==
X-Gm-Message-State: AOAM5305C6HRese70qZPXbKI9wSmeutNV7pjNxa4IsEAPxifR53xNALn
        KuMLDQB383A6ihI3Z0FFvrjbrzcGVStjmQ==
X-Google-Smtp-Source: ABdhPJza473hJUTSf2Oo6C2aIjxhiXpT8tC1M664w5fQbOdwZ1kbitDkL/1+lsV8RJFD4zp83lOOXw==
X-Received: by 2002:a5d:58db:: with SMTP id o27mr28668590wrf.397.1613565721324;
        Wed, 17 Feb 2021 04:42:01 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id t9sm3589979wrw.76.2021.02.17.04.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 04:42:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 0/4] add BPF-driven requests
Date:   Wed, 17 Feb 2021 12:38:02 +0000
Message-Id: <cover.1613563964.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pretty much an RFC for executing BPF requests in io_uring to start a
discussion, so any ideas and wish lists are welcom. Some technical
but not much important for the discussion detais are omitted in the
patchset, i.e. good cancellation system, optimisations and some BPF
specific parts.

Some of major missing points:
1. We need to pass an CQE/result of a previous linked request to BPF.

2. Whether to keep to a new IORING_OP_BPF opcode, or do it in a common
path for each request, e.g. on CQE completion. The former looks saner,
but is not nicely aligned with (1.).

3. Allow BPF programs to generate CQEs not binded to a request. A
problem can be with supporting overflowed CQEs, it's either to
always kmalloc()'ing storage for them instead of using req's memory
or piling up on top. Eventually we will need it anyway to be able
to post several CQEs for a single requests.

Pavel Begunkov (4):
  bpf: add IOURING program type
  io_uring: implement bpf prog registration
  io_uring: add IORING_OP_BPF
  io_uring: enable BPF to submit SQEs

 fs/io_uring.c                 | 259 +++++++++++++++++++++++++++++++++-
 include/linux/bpf_types.h     |   2 +
 include/uapi/linux/bpf.h      |   2 +
 include/uapi/linux/io_uring.h |   3 +
 kernel/bpf/syscall.c          |   1 +
 kernel/bpf/verifier.c         |   3 +
 6 files changed, 264 insertions(+), 6 deletions(-)

-- 
2.24.0

