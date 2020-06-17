Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B531FCA35
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 11:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgFQJyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 05:54:00 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:52799 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbgFQJyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 05:54:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.rPv22_1592387638;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U.rPv22_1592387638)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Jun 2020 17:53:58 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v4 0/2] io_uring: add EPOLLEXCLUSIVE flag for POLL_ADD operation 
Date:   Wed, 17 Jun 2020 17:53:54 +0800
Message-Id: <1592387636-80105-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applications can use this flag to avoid accept thundering herd type
behavior.

Jiufei Xue (2):
  io_uring: change the poll type to be 32-bits
  io_uring: use EPOLLEXCLUSIVE flag to aoid thundering

