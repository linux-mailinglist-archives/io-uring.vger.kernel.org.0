Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46192B59A1
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 07:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgKQGR2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 01:17:28 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:53050 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgKQGR2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 01:17:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UFfrlD2_1605593843;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFfrlD2_1605593843)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 17 Nov 2020 14:17:24 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH 5.11 0/2] registered files improvements for IOPOLL mode
Date:   Tue, 17 Nov 2020 14:17:21 +0800
Message-Id: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Xiaoguang Wang (2):
  io_uring: keep a pointer ref_node in io_kiocb
  io_uring: don't take percpu_ref operations for registered files in
    IOPOLL mode

 fs/io_uring.c | 44 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

-- 
2.17.2

