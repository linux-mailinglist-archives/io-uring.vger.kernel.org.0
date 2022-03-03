Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5344CB783
	for <lists+io-uring@lfdr.de>; Thu,  3 Mar 2022 08:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiCCHNA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 02:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiCCHMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 02:12:53 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A499C16AA72;
        Wed,  2 Mar 2022 23:12:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V66BpVC_1646291523;
Received: from 30.226.12.33(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V66BpVC_1646291523)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Mar 2022 15:12:04 +0800
Message-ID: <40be865d-17c0-80a3-e434-73317c5bff70@linux.alibaba.com>
Date:   Thu, 3 Mar 2022 15:12:01 +0800
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
 <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
 <4af380e8-796b-2dd6-4ebc-e40e7fa51ce1@linux.alibaba.com>
 <81a915d3-cf5f-a884-4649-704a5cf26835@linux.alibaba.com>
 <a549f23857b327131c621dbc9a029a91401967c8.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <a549f23857b327131c621dbc9a029a91401967c8.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 3/3/22 06:03, Olivier Langlois wrote:
> On Wed, 2022-03-02 at 14:38 +0800, Hao Xu wrote:
>>>>
>>>> If that is what you suggest, what would this info do for the
>>>> caller?
>>>>
>>>> IMHO, it wouldn't help in any way...
>>> Hmm, I'm not sure, you're probably right based on that ENOMEM here
>>> shouldn't
>>>
>>> fail the arm poll, but we wanna do it, we can do something like
>>> what
>>> we do for
>>                               ^---but if we wanna do it
> My position is that being able to perform busy poll is a nice to have
> feature if the necessary resources are available. If not the request
> will still be handled correctly so nothing special should be done in
> case of mem alloc problem.
Exactly what I meant.
>
> but fair enough, lets wait for Jens and Pavel to chime him if they
> would like to see something to be done here.
Agree.
>
> Beside that, all I need to know is if napi_list needs to be protected
> in __io_sq_thread with regards to io worket threads to start working on
> a v5.

Sorry for the delay, was stuck in other things. We definitely need

lock in this case too. It should be several lines code, super appreciate

if you could add it.


Thanks,

Hao

>
> I'll look into this question too...
