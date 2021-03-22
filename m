Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ECD3438EE
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 06:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCVF5j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 01:57:39 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50028 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhCVF5V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 01:57:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0USqi9rM_1616392639;
Received: from 30.225.32.180(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0USqi9rM_1616392639)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Mar 2021 13:57:19 +0800
Subject: Re: [ANNOUNCEMENT] io_uring SQPOLL sharing changes
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <30563957-709a-73a2-7d54-58419089d61a@linux.alibaba.com>
Date:   Mon, 22 Mar 2021 13:54:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ca41ede6-7040-5eac-f4f0-9467427b1589@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi Pavel,

> Hey,
> 
> You may have already noticed, but there will be a change how SQPOLL
> is shared in 5.12. In particular, SQPOLL may be shared only by processes
> belonging to the same thread group. If this condition is not fulfilled,
> then it silently creates a new SQPOLL task.
Thanks for your kindly reminder, currently we only share sqpoll thread
in threads belonging to one same process.

Regards,
Xiaoguang Wang

> 
> Just FYI, but may also yield some discussion on the topic.
> 
