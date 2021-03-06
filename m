Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2532F99F
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhCFLHH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhCFLG3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69DCC061764
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n22so3224188wmc.2
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5Wx/YUShBTLM4HN6twd4EqMNWQhJxgroELp9HuwZhdg=;
        b=ul9/WR+te4WwK+S4Gq/d/bYcbPqIM+ql+7/OykKQTTtzDjvoegLJZzsffPDV0uWB32
         AmPDtc+ACuvhSJsDBQdJqtZbiiFTgGRI6jsoBEgQFDNp1d0uamKOoCLIxt31V3dNkja3
         tKtj2/v3pGHtzyslOR0xtTuu80GzSpdpMHVAWIzS15rbfcJDTW+h9fxZ7NKTsbR2G5f+
         B8Gc0dyQyIsvXkBVS58x/qDFYTYNOs2KU0ZeQk2OM/Cwpbj+JiPiKYwnm4xA31fYOKOv
         ulccqKXmuR18nRRokpvDcCEhl9tT19cAHxiuMvpaoqg8swY7kqc9SaGOv2KNCahXxhPq
         fH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Wx/YUShBTLM4HN6twd4EqMNWQhJxgroELp9HuwZhdg=;
        b=SmDLa1ip0I1uGCRcWGM2gmOK/tvtnEHF7AT99h09WUWYs40swy7MpVteDQU2CFCHnH
         i0PJzLNWl3qg7EvY397BNjQXcwC0/bcwGyLM5zuvI1UNRWGBkDdTlnoJ0BZQfqLKGDbE
         fR3K+kfB+sw8EfITPjxBAylFP0B9IzEHBjRnLEsICroOlz0iiZpcYPh22qPizMZ4UagJ
         NnBiRCs4Qip46k2e7TJYS0QCS8XD/X+dcrhz55+TiGQTtu6WiHKWzGy0+BRmfI0KvY9M
         OpIEh5hJjmuMmC9J+eSCoCSiXlepQ8avPPj5zOkWOhZ2RqDixk7uRyCHPcyk3Cj9+Xt7
         XH+g==
X-Gm-Message-State: AOAM530uv6vgau4iYhSSDRXm6TMZ8I+SUpdGjGX6YppVtWm2+8y/5GkO
        MqNSo5qmEGw8/s/khkbfqgXLgEgRG4kdeg==
X-Google-Smtp-Source: ABdhPJyQNXp5plN/njS5THo9vBSH1tK04vqDUTIAMuXSPwZcJ1GDDck6LU1j0ijiK6ciBNQPLlkhxA==
X-Received: by 2002:a7b:c214:: with SMTP id x20mr13298018wmi.186.1615028787735;
        Sat, 06 Mar 2021 03:06:27 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 8/8] io-wq: warn on creating manager awhile exiting
Date:   Sat,  6 Mar 2021 11:02:18 +0000
Message-Id: <e9203c99c68c0c379a6eeaff505b0f4db414e7bc.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a simple warning making sure that nobody tries to create a new
manager while we're under IO_WQ_BIT_EXIT. That can potentially happen
due to racy work submission after final put.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1bfdb86336e4..1ab9324e602f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -774,6 +774,8 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	if (wq->manager)
 		return 0;
 
+	WARN_ON_ONCE(test_bit(IO_WQ_BIT_EXIT, &wq->state));
+
 	init_completion(&wq->worker_done);
 	atomic_set(&wq->worker_refs, 1);
 	tsk = create_io_thread(io_wq_manager, wq, NUMA_NO_NODE);
-- 
2.24.0

