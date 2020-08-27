Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CAC253B8B
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 03:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgH0Big (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 21:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgH0Bif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 21:38:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA06C0617BE
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 18:38:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y206so2201696pfb.10
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 18:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=JL/XYkHz2lUd+aZ+JaVoP8GVD7T3vySVfKsYHZnzn0U=;
        b=y7KWu/m6tbweruxy4LllYb02zunc3xatwP1j7w5ZvDbKIxqD+6UuMlE9EEu+1RsCF/
         2nhgfiZSNRiRvCx2UrE7ad8JIeilagBdQEwRcLfD1JWQyaaIIRuCWdmUPc2pn0y6TlnS
         mG/NCKAeNVDj5/BbiCFEKE8/exxaDgAPYjfAfPSUq2t4clMYK/ts1iwgFaUXf6K44qCP
         EO1rkDYjJWfq0o9aKPQejnMetF24mOOoO2h8EteGhi+T1QvupQqWu+Kz27WPGFV67j9q
         Bz0W4Ib0tOa8C8uapXMJG9mVSvJCKy7eY+BJ71UyuEzep680y+tFesRcaYNHEK0fwtf6
         KUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=JL/XYkHz2lUd+aZ+JaVoP8GVD7T3vySVfKsYHZnzn0U=;
        b=ibwi4D+oDWl3SX8RKxBvPlkVPAw/nqxUWd8m06kygMvkCExi6KFsy6If5jBtD1hOGm
         bvcyzxQbb1tl7SiBZnzuHqq1IKBFvSt2L1rH1GwDWPBBQEiLmWih/HqZR6PZXnotHmLA
         o2PCUAqeUTZC11tyQn8adrGBPsKeso/mpQbCQAdgFJCKOCumAA18VEgJaBZcqMC3MJZ4
         cVIZGV2bCuK5LxM5XWdKJGYMmJm38yF40eKstBJZ2koRMu7PuMXLpdzLq1z+ToVVoD2z
         y/hza+MEz7mONraSVvf0pltF2TI9zeISAX90w1D6YiWppEuScOQCR8cgJdhCAywXWU+P
         Hp6w==
X-Gm-Message-State: AOAM530I5qj8dc45NrJ5ya4iT0bAVq2S8E0okMpoaIv+MeMcqmGPIIo3
        0b4Tdt1hmag0ZTUsaGH1IiUfGNfWy0yqSPSF
X-Google-Smtp-Source: ABdhPJxm7XA4NKzhlntCZAh5qt63kc0tVQIVaJzxDlfjuqpDkZpu7GLAb5b00CQILBj8uyt0Pv+ccQ==
X-Received: by 2002:a63:cc49:: with SMTP id q9mr12215466pgi.390.1598492313822;
        Wed, 26 Aug 2020 18:38:33 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t10sm274543pgp.15.2020.08.26.18.38.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 18:38:33 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: clear req->result on IOPOLL re-issue
Message-ID: <0e5eb3f1-d1bf-7c0f-7fe0-d18cb0fc5ac4@kernel.dk>
Date:   Wed, 26 Aug 2020 19:38:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure we clear req->result, which was set to -EAGAIN for retry
purposes, when moving it to the reissue list. Otherwise we can end up
retrying a request more than once, which leads to weird results in
the io-wq handling (and other spots).

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd2d8de3f2e8..6df08287c59e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2049,6 +2049,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		if (READ_ONCE(req->result) == -EAGAIN) {
+			req->result = 0;
 			req->iopoll_completed = 0;
 			list_move_tail(&req->inflight_entry, &again);
 			continue;
-- 
Jens Axboe

