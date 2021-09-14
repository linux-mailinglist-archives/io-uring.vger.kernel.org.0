Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CAC40B09C
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhINO3x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:29:53 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:57856 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233300AbhINO3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:29:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UoOk.6D_1631629713;
Received: from legedeMacBook-Pro.local(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UoOk.6D_1631629713)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Sep 2021 22:28:33 +0800
Subject: Re: [PATCH] io_uring: add missing sigmask restore in io_cqring_wait()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210914084139.8827-1-xiaoguang.wang@linux.alibaba.com>
 <45cb9bb5-3132-6873-a423-d037e6db01a5@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <f0c26fd2-667f-8f94-446d-4da064a712d9@linux.alibaba.com>
Date:   Tue, 14 Sep 2021 22:28:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <45cb9bb5-3132-6873-a423-d037e6db01a5@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,


> On 9/14/21 2:41 AM, Xiaoguang Wang wrote:
>> Found this by learning codes.
> Does look like a real bug. But how about we move the get_timespec() section
> before the sigmask saving?

Ok,  I thought about this method before :)


Regards,

Xiaoguang Wang

>
