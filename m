Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD081F8925
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2020 16:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgFNOKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Jun 2020 10:10:43 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:52211 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgFNOKn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Jun 2020 10:10:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U.WpbUT_1592143839;
Received: from 30.0.130.156(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U.WpbUT_1592143839)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 14 Jun 2020 22:10:40 +0800
To:     io-uring <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        joseph qi <joseph.qi@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Does need memory barrier to synchronize req->result with
 req->iopoll_completed
Message-ID: <dc28ff4f-37cf-03cb-039e-f93fefef8b96@linux.alibaba.com>
Date:   Sun, 14 Jun 2020 22:10:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

I have taken some further thoughts about previous IPOLL race fix patch,
if io_complete_rw_iopoll() is called in interrupt context, "req->result = res"
and "WRITE_ONCE(req->iopoll_completed, 1);" are independent store operations.
So in io_do_iopoll(), if iopoll_completed is ture, can we make sure that
req->result has already been perceived by the cpu executing io_do_iopoll()?

Regards,
Xiaoguang Wang
