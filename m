Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB759320A84
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 14:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhBUNXc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 08:23:32 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36640 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhBUNXb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 08:23:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UP6rv01_1613913766;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UP6rv01_1613913766)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 21 Feb 2021 21:22:46 +0800
Subject: Re: [PATCH v2 0/4] rsrc quiesce fixes/hardening v2
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1613844023.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <c8248b0f-eab9-9c63-9571-a31de9a6e6a4@linux.alibaba.com>
Date:   Sun, 21 Feb 2021 21:22:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1613844023.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ÔÚ 2021/2/21 ÉÏÎç2:03, Pavel Begunkov Ð´µÀ:
> v2: concurrent quiesce avoidance (Hao)
>      resurrect-release patch
> 
> Pavel Begunkov (4):
>    io_uring: zero ref_node after killing it
>    io_uring: fix io_rsrc_ref_quiesce races
>    io_uring: keep generic rsrc infra generic
>    io_uring: wait potential ->release() on resurrect
> 
>   fs/io_uring.c | 96 ++++++++++++++++++++++++---------------------------
>   1 file changed, 45 insertions(+), 51 deletions(-)
> 
I tested this patchset with the same tests
for "io_uring: don't hold uring_lock ..."

Tested-by: Hao Xu <haoxu@linux.alibaba.com>
