Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37EE35F245
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 13:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhDNLX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 07:23:56 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:48560 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234078AbhDNLXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 07:23:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UVXqQIm_1618399412;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UVXqQIm_1618399412)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 14 Apr 2021 19:23:32 +0800
To:     Jens Axboe <axboe@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Subject: 12aceb89b0bc eventfd: convert to f_op->read_iter() causes 6.7%
 performance regression
Cc:     io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <1157fb4c-9975-3515-70b0-fefefa3ddfae@linux.alibaba.com>
Date:   Wed, 14 Apr 2021 19:23:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
We found that 12aceb89b0bc eventfd: convert to f_op->read_iter()
introduced 6.7% peformance regression in test suite will-it-scale

The test commands are:
./runtest.py eventfd1 10 thread 1
and
./runtest.py eventfd1 10 thread 128

the test is a simple while which is like:
while(time not over) {
   write(eventfd);
   read(eventfd);
}

By perf analysis, I saw that the main cost is new_sync_read().
Though I think this regression only happens when there is no
'schedule/sleep'(otherwise sleep occupies most time), I feel it
still necessary to report it.


