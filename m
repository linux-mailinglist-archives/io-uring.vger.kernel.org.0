Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563E2320433
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 07:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBTGdc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 01:33:32 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:35949 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229802AbhBTGdb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 01:33:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UP03tWY_1613802759;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UP03tWY_1613802759)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 14:32:40 +0800
Subject: Re: [PATCH 0/3] rsrc quiesce fixes/hardening
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
 <1253a9e9-fbf4-4289-ae36-2768c682d6b5@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <52268a17-d8cc-7a6d-258c-beb9fe9eff30@linux.alibaba.com>
Date:   Sat, 20 Feb 2021 14:32:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1253a9e9-fbf4-4289-ae36-2768c682d6b5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/20 上午4:49, Pavel Begunkov 写道:
> On 19/02/2021 20:45, Pavel Begunkov wrote:
>> 1/3 addresses new races in io_rsrc_ref_quiesce(), others are hardenings.
> 
> s/1/2/
> 
> Hao, any chance you guys can drag these patches through the same
> tests you've done for "io_uring: don't hold uring_lock ..."?
> 
gotcha, will test it soon.
>>
>> Pavel Begunkov (3):
>>    io_uring: zero ref_node after killing it
>>    io_uring: fix io_rsrc_ref_quiesce races
>>    io_uring: keep generic rsrc infra generic
>>
>>   fs/io_uring.c | 65 +++++++++++++++++----------------------------------
>>   1 file changed, 21 insertions(+), 44 deletions(-)
>>
> 

