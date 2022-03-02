Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F24C9DD6
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 07:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbiCBGgV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 01:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiCBGgV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 01:36:21 -0500
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560645F8C4;
        Tue,  1 Mar 2022 22:35:38 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V61Jf3z_1646202933;
Received: from 30.226.12.26(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V61Jf3z_1646202933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 14:35:34 +0800
Message-ID: <970e752b-aa75-8f66-ae7a-65ab509bea10@linux.alibaba.com>
Date:   Wed, 2 Mar 2022 14:35:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646142288.git.olivier@trillion01.com>
 <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
 <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
 <d5c162c93cf269d2f94cd0ae8c5d9cd0cd55c265.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <d5c162c93cf269d2f94cd0ae8c5d9cd0cd55c265.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 3/2/22 13:12, Olivier Langlois wrote:
> On Wed, 2022-03-02 at 02:31 +0800, Hao Xu wrote:
>>> +static void io_blocking_napi_busy_loop(struct list_head
>>> *napi_list,
>>> +                                      struct io_wait_queue *iowq)
>>> +{
>>> +       unsigned long start_time =
>>> +               list_is_singular(napi_list) ? 0 :
>>> +               busy_loop_current_time();
>>> +
>>> +       do {
>>> +               if (list_is_singular(napi_list)) {
>>> +                       struct napi_entry *ne =
>>> +                               list_first_entry(napi_list,
>>> +                                                struct napi_entry,
>>> list);
>>> +
>>> +                       napi_busy_loop(ne->napi_id,
>>> io_busy_loop_end, iowq,
>>> +                                      true, BUSY_POLL_BUDGET);
>>> +                       io_check_napi_entry_timeout(ne);
>>> +                       break;
>>> +               }
>>> +       } while (io_napi_busy_loop(napi_list) &&
>>> +                !io_busy_loop_end(iowq, start_time));
>>> +}
>>> +
>> How about:
>>
>> if (list is singular) {
>>
>>       do something;
>>
>>       return;
>>
>> }
>>
>> while (!io_busy_loop_end() && io_napi_busy_loop())
>>
>>       ;
>>
>>
>> Btw, start_time seems not used in singular branch.
> Hao,
>
> it takes me few readings before being able to figure out the idea
> behind your suggestions. Sorry about that!
>
> So, if I get it correctly, you are proposing extract out the singular
> block out of the while loop...
>
> IMHO, this is not a good idea because you could start iterating the
> do/while loop with a multiple entries list that ends up becoming a
> singular list after one or few iterations.
My bad, I get your point now.
>
> Check what io_napi_busy_loop() is doing...
>
> It does not look like that but a lot thoughts have been put into
> writing io_blocking_napi_busy_loop()...
True.
