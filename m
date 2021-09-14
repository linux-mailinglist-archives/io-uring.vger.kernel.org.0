Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2940B21D
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhINOym (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:54:42 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:44622 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233055AbhINOyh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:54:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UoOlYjV_1631631197;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UoOlYjV_1631631197)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Sep 2021 22:53:18 +0800
Subject: Re: [PATCH] io_uring: fix missing sigmask restore in io_cqring_wait()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210914143852.9663-1-xiaoguang.wang@linux.alibaba.com>
 <d5e72e5f-5653-f738-f675-9ac955d7e55e@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <0b734068-51d8-2442-74ff-620891fc5502@linux.alibaba.com>
Date:   Tue, 14 Sep 2021 22:53:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d5e72e5f-5653-f738-f675-9ac955d7e55e@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,


> On 9/14/21 8:38 AM, Xiaoguang Wang wrote:
>> Move get_timespec() section in io_cqring_wait() before the sigmask
>> saving, otherwise we'll fail to restore sigmask once get_timespec()
>> returns error.
> Applied, thanks! I added a:
>
> Fixes: c73ebb685fb6 ("io_uring: add timeout support for io_uring_enter()")
>
> to the commit since that's when it got broken, that'll help with
> stable backports. Not that it's a _huge_ issue, it basically means
> the application is broken anyway.

Agree, thanks.


Regards,

Xiaoguang Wang


>
