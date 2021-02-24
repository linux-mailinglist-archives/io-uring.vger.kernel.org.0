Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1743235E8
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 04:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhBXDHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 22:07:35 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37304 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229961AbhBXDHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 22:07:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UPPcA2a_1614136011;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UPPcA2a_1614136011)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Feb 2021 11:06:51 +0800
Subject: Re: [PATCH v2 1/1] io_uring: allocate memory for overflowed CQEs
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <f57545fb-a109-0881-ff14-f371d1a9d811@linux.alibaba.com>
Date:   Wed, 24 Feb 2021 11:06:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2021/2/23 ÏÂÎç8:40, Pavel Begunkov Ð´µÀ:
> Instead of using a request itself for overflowed CQE stashing, allocate
> a separate entry. The disadvantage is that the allocation may fail and
> it will be accounted as lost (see rings->cq_overflow), so we lose
> reliability in case of memory pressure. However, it opens a way for for
> multiple CQEs per an SQE and even generating SQE-less CQEs >
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
Hi Pavel,
Allow me to ask a stupid question, why do we need to support multiple 
CQEs per SQE or even SQE-less CQEs in the future?

Thanks,
Hao
