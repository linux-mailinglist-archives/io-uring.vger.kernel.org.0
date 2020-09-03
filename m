Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E5425B9CE
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 06:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgICEgN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 00:36:13 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58879 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbgICEgN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 00:36:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U7mHhG3_1599107771;
Received: from 30.225.32.185(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U7mHhG3_1599107771)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Sep 2020 12:36:11 +0800
Subject: Re: [PATCH] io_uring: don't hold fixed_file_data's lock when
 registering files
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200902113256.6620-1-xiaoguang.wang@linux.alibaba.com>
 <a8417eac-3349-cc82-7f13-cb00fa34617b@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <b16114c8-7369-d6db-ceb3-2fecf3f020df@linux.alibaba.com>
Date:   Thu, 3 Sep 2020 12:35:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a8417eac-3349-cc82-7f13-cb00fa34617b@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi，

> On 9/2/20 5:32 AM, Xiaoguang Wang wrote:
>> While registering new files by IORING_REGISTER_FILES, there're not
>> valid fixed_file_ref_node at the moment, so it's unnecessary to hold
>> fixed_file_data's lock when registering files.
> 
> Even if that were the case (I haven't looked too closely at it yet),
> it would a) need a big comment explaining why, and b) some justification
> on why this would be a change we'd want to make.
> 
> On b, are you seeing any tangible differences with this?
No, just found this by reading source codes.

Regards,
Xiaoguang Wang

> 
