Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7AB42A04D
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhJLIuT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 04:50:19 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:49870 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232666AbhJLIuP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 04:50:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UrYtUxC_1634028491;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UrYtUxC_1634028491)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Oct 2021 16:48:12 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [RFC 0/1] Is register file feature hard to use ?
Date:   Tue, 12 Oct 2021 16:48:10 +0800
Message-Id: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While trying to use register file feature, I think it's hard to use, see
patch-1's commit message for more info.

In this RFC patch, I just propose an preliminary implementation, don't
consider tag, compatibility issue yet, sorry. If we come to a agreement
that it's the right direction, I'll refine it as soon as possible.

Also I saw Pavel has written "io_uring: openat directly into fixed fd table",
which requires user to pass a file_slot. I think it's inconvenient to
user app. We may still reply __get_unused_fd_flags() to allocate a fd,
use it to as slot info.

Xiaoguang Wang (1):
  io_uring: improve register file feature's usability

 fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 8 deletions(-)

-- 
2.14.4.44.g2045bb6

