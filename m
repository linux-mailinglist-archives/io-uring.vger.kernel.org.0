Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA95369E4
	for <lists+io-uring@lfdr.de>; Sat, 28 May 2022 03:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241243AbiE1Bpg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 21:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiE1Bpg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 21:45:36 -0400
Received: from out199-2.us.a.mail.aliyun.com (out199-2.us.a.mail.aliyun.com [47.90.199.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE81B13C1F2
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 18:45:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEZnCju_1653702330;
Received: from 30.15.236.15(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEZnCju_1653702330)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 May 2022 09:45:31 +0800
Message-ID: <076bc71c-673f-ecda-a3b9-31e0040d7ef9@linux.alibaba.com>
Date:   Sat, 28 May 2022 09:45:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v2] io_uring: defer alloc_hint update to
 io_file_bitmap_set()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <dce4572c-fecf-bb84-241e-2ea7b4093fef@kernel.dk>
 <20220527173914.50320-1-xiaoguang.wang@linux.alibaba.com>
 <587a9737-9979-302e-4484-dfdbebe29d78@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <587a9737-9979-302e-4484-dfdbebe29d78@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 5/27/22 11:39 AM, Xiaoguang Wang wrote:
>> io_file_bitmap_get() returns a free bitmap slot, but if it isn't
>> used later, such as io_queue_rsrc_removal() returns error, in this
>> case, we should not update alloc_hint at all, which still should
>> be considered as a valid candidate for next io_file_bitmap_get()
>> calls.
>>
>> To fix this issue, only update alloc_hint in io_file_bitmap_set().
> Why are you changing the io_file_bitmap_set() type?
Oh sorry, it was introduced in patch v1 to check whether alloc_hint
is greater than nr_user_files, but forgot to revert it in patch v2.

Regards,
Xiaoguang Wang
>
>

