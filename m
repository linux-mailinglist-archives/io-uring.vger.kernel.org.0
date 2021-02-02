Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A0830B412
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhBBA0R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA0Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:16 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EF9C06174A
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:36 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id 7so18581911wrz.0
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9guHaK55BB+TqtObhgxuIsZzmX9M3WGkXfCkN9GLzX0=;
        b=jljjvu+4JQU8Zszsd5TdCG44iT4RLfc4yJrhAG0+THUbZUx2p+Em5Bbiq5opS/HLE8
         1MgWSda84887k+NSc2pcYaCDLqdMIBF9tsO8Y2RgcAD+vJFm7QlM3Hpp4JJxhzw1uWnN
         gdxognVUOon7oOgg6gQ6SF1QCYKa/lSwcYEw7Wc+9xb3GvmRpkuGGXFj9xBighJVWlYj
         GrFARmt39j/cBWCthkZUee2dJwOfbAirdzK0vLFeVCWpRyOYo3+0R5Xod5m0IMwFwgsC
         8UD6hzHC/tPDC84b9a/8dej2Gmp/HHplbVD2PDxztmLf2O2+i5vPXGkEpsfZyNzTl/Is
         nKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9guHaK55BB+TqtObhgxuIsZzmX9M3WGkXfCkN9GLzX0=;
        b=b/Vpz0eNF0+XHsRHY6a4nLPoGig+s9vFLMSJvBe1k6n2jv89WonGcVr1VO2kCl7vbh
         7ZnF+Dn/WjY1xoIg/6cnqnyfESrlvFI2FNe4FhveWKBnJNyxRdsVUMb89tdJrtAt2ed2
         czqaW3iLyvREsyedjBJPTp8WRQxMjEYybTJwhgxX/H85kCGDfGIHVoNaaYboSiU3JiTm
         pS5LiGE8HzWItWiXQ0HLp8Pa+pocgwamP3HYFDq/s8UU1p1eOmpAaBaU+VpUH/ZjmdUe
         idrlrr5hsoHOFXYGG52Y9uY6XQxq0JX+mOs0jl7/x9/ZS4NTzLyup739MjwXlE0+Yr68
         N+Bg==
X-Gm-Message-State: AOAM532k8hNAz91IS1xE+TMEbDZneBruYGOZy9pwCGWrY9TjQucY2pVa
        RmO1U2oo9G2CePxWBU1GbsLRc1Usrfc=
X-Google-Smtp-Source: ABdhPJyyyEjs0WBC2OHWVFjGSLX9/LbsjImSvb8+T0sr2mSFCqsV+hbe73pIHko3HG52rxLBprhRxQ==
X-Received: by 2002:adf:d085:: with SMTP id y5mr21273808wrh.41.1612225535144;
        Mon, 01 Feb 2021 16:25:35 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/8] a second pack of 5.12 cleanups
Date:   Tue,  2 Feb 2021 00:21:38 +0000
Message-Id: <cover.1612223953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Those are a bit harder to look through.

4-8 are trying to simplify io_read(). 7/8 looks like a real problem, but
not sure if even can happen with this IOCB_WAITQ set.

Pavel Begunkov (8):
  io_uring: deduplicate core cancellations sequence
  io_uring: refactor scheduling in io_cqring_wait
  io_uring: refactor io_cqring_wait
  io_uring: refactor io_read for unsupported nowait
  io_uring: further simplify do_read error parsing
  io_uring: let io_setup_async_rw take care of iovec
  io_uring: don't forget to adjust io_size
  io_uring: inline io_read()'s iovec freeing

 fs/io_uring.c | 215 +++++++++++++++++++++++---------------------------
 1 file changed, 97 insertions(+), 118 deletions(-)

-- 
2.24.0

