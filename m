Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E7A23C3D1
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 05:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHEDEo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 23:04:44 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35379 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgHEDEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 23:04:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U4n7KHM_1596596682;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4n7KHM_1596596682)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Aug 2020 11:04:42 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, metze@samba.org
Subject: [PATCH liburing v3 0/2] add support for new timeout feature
Date:   Wed,  5 Aug 2020 11:04:38 +0800
Message-Id: <1596596680-116411-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
supported. Applications should use io_uring_set_cqwait_timeout()
explicitly to asked for the new feature.

Changes since v2:
- bump the version to 2.0.7 since we have changed the size of io_uring
- add more pad to structure io_uring for future flexibility

Jiufei Xue (2):
io_uring_enter: add timeout support
test/timeout: add testcase for new timeout feature
