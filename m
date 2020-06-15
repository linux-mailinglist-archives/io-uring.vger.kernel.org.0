Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358ED1F934C
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 11:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgFOJY6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 05:24:58 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:44517 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728180AbgFOJY6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 05:24:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U.dZq92_1592213096;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.dZq92_1592213096)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Jun 2020 17:24:56 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 0/2] add proper memory barrier for IOPOLL mode
Date:   Mon, 15 Jun 2020 17:24:48 +0800
Message-Id: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The first patch makes io_uring do not fail links for io request that
returns EAGAIN error, second patch adds proper memory barrier to
synchronize io_kiocb's result and iopoll_completed.

Xiaoguang Wang (2):
  io_uring: don't fail links for EAGAIN error in IOPOLL mode
  io_uring: add memory barrier to synchronize io_kiocb's result and
    iopoll_completed

 fs/io_uring.c | 55 +++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

-- 
2.17.2

