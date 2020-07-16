Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C1F222CCF
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgGPUaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:01 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB03C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f18so8514898wrs.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TznXEyTRkKwF1zWSb5JyNJS5TqhJF6EXg+pk6E/RdcI=;
        b=TqPGhEr74/+fPfjUJ8/rAX6mWqN+tUsGX6jjfFAgA7FLihQu4HugDA1CUyVUQywpLp
         9rFtzEDxQ6tIkBd39EO5+TRF6/8ePcg9AAWcJUyjgbr6ALrCz3xAEvIzSLt3T6qlhGWj
         xLxNpzRe/vcTsafN0fia9uau9FqfABN6fBpZydCvAMDLbPndmvk3rhtLZcNalyReidb/
         mrXXe12F/YBtQOt+tBqHAV+pI2xNLPnnypvK10UMe61X4rD8Gjf7qys5ju9o0XBymTJA
         CZATitqeSZENIX6PicGy+P/yts02Uf4Apu21LsWWEuQsSntqR/HV5igbigGGUvkH9Jp6
         jxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TznXEyTRkKwF1zWSb5JyNJS5TqhJF6EXg+pk6E/RdcI=;
        b=sR5fRl5N5qgdEcvBF06czMlxLZxwVTaUXh+YR9PLZvLI1xPk03QM9QGwFmLjuO2kqk
         jmQTOnPRDQaCU+q3I+9zVXk6XJn1r6d2f9m626ufP4OLU/5bImu+oabqf8+Yl+7Q/4Pz
         68WJPlfXCPBhZI0qcnGliFAW6vSV8a4i9LrUrKvhpT6VsUcHPy6VSdjdMbn09UnLxGmH
         Gms43TgeXSsycx4i1rvOt0OzQ818PojivaxrnbMhsXJ4ukuW9I4zZoFaLy9E97faJg+U
         lVoydW23XJzTErnc54a/5nCIa223ldq8oVkYXPHdH/LlWLlpyadpvuxjF1XiRDJffeNh
         +6KQ==
X-Gm-Message-State: AOAM530JYOywKyd6LfgRydh/dZXod/h/HFeHbjdJlj4ONMqlXvhw7GaB
        0n+59rZmT061zzT1GvlGJ3Y=
X-Google-Smtp-Source: ABdhPJwGhFtLTrljLEBspjZk9GmNReJFHJL4LMjRqax7lIfVNB+01Fl576AxTS5bn4neMtVYlyXHlg==
X-Received: by 2002:adf:c551:: with SMTP id s17mr6412777wrf.330.1594931399755;
        Thu, 16 Jul 2020 13:29:59 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:29:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.9 0/7] recv/rw select-buffer fortifying
Date:   Thu, 16 Jul 2020 23:27:58 +0300
Message-Id: <cover.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series makes selected buffer managment more resilient to errors,
especially io_recv[msg](). Even though, it makes some small accidential
optimisations, I don't think performance difference will be observable
at the end.

Pavel Begunkov (7):
  io_uring: indent left {send,recv}[msg]()
  io_uring: remove extra checks in send/recv
  io_uring: don't forget cflags in io_recv()
  io_uring: free selected-bufs if error'ed
  io_uring: move BUFFER_SELECT check into *recv[msg]
  io_uring: extract io_put_kbuf() helper
  io_uring: don't open-code recv kbuf managment

 fs/io_uring.c | 363 +++++++++++++++++++++++++-------------------------
 1 file changed, 182 insertions(+), 181 deletions(-)

-- 
2.24.0

