Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8303EF2A4
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 21:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhHQT3X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhHQT3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 15:29:23 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8317C061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:49 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x12so30190673wrr.11
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAv/CS9GDQbfsUlSg90KddEKucM9m9t1rLApe972aMc=;
        b=gmcsGu3ePnviPQ2hTRiP5mwZJQ/a7wzCsx3CtBL3/WELcUeYTtZKv/IxVZ5R1wMU4p
         S+eqDjtWX3z4WAuPtPtYGSdguZd1yi5FitvE/6vuCFjdjmsnleiVxoE8OabOAY2Dn6GY
         WQ17rL5pqiCzJNMyZU7aEEaStLRUhIgS/pcvhfsYvtSdEWw19OhY+KF1iKJlCdhprjPa
         Zh+twW6VWZqam1i4LBN8OUHRx/IudMGTgrgImecp9SLPg/vx9UjG5WNu5zwJPj9AzJFp
         h3CqNqjJQC5NRStSh0bUd1rOVeji+Iz0VTb4icNp872uaM5v2BELXQmOWMabte/ZXORA
         oNNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAv/CS9GDQbfsUlSg90KddEKucM9m9t1rLApe972aMc=;
        b=Ya/xswCdFEu38YpBqYun+lv/FjgR4BJQKHHMCtCi5hwe5UdZKBJ9di2TPYxZTPKkF6
         PYUCbyWSOFRuVplCJrsba3CSXxiejE8m+eZnSEI36ZHEWCDu6Pro+B6hAG1ZAdv8fe/k
         EJKrfMM5p8tck4S3VHr8l9XAi2RIqNbU0TNxPKr9t2TWFdC1A9zkAXoCMTOJggircg6L
         I6v0szZf0qLWN1GOhSlcs1TzvokSNJQEjuEAeKdKLPkSgVbrrKznvJFlqo47ly/UVum/
         sb3d36DboJXOgaV2IPXvsZYbNSRArSmGUeQSA/IAjRXe8XdltFoVJVUqT26WvhIaWFwb
         OBug==
X-Gm-Message-State: AOAM530aCW9tA0OxVzhkD41ubnIP+CUV/+jt5F2eQUFmoHuH5UZQotdE
        /AjTxlPGGANNnpCfl01Q6ZOpKDV5Wa4=
X-Google-Smtp-Source: ABdhPJzRRSt0YWSeZ8L+fpvd1HNZGruuiANNpfLPu5nDUyzJlLzVF6Xup222yA56zrfZm09k5+Ly7A==
X-Received: by 2002:a5d:5703:: with SMTP id a3mr6228497wrv.333.1629228528236;
        Tue, 17 Aug 2021 12:28:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e6sm3120388wme.6.2021.08.17.12.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.15 0/4] not connected 5.15 patches
Date:   Tue, 17 Aug 2021 20:28:07 +0100
Message-Id: <cover.1629228203.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A set of not connected patches for 5.15.

Pavel Begunkov (4):
  io_uring: better encapsulate buffer select for rw
  io_uring: reuse io_req_complete_post()
  io_uring: improve tctx_task_work() ctx referencing
  io_uring: improve same wq polling

 fs/io_uring.c | 87 +++++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 58 deletions(-)

-- 
2.32.0

