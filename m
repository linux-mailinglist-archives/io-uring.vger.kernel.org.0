Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FAB4B583B
	for <lists+io-uring@lfdr.de>; Mon, 14 Feb 2022 18:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356954AbiBNRNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 12:13:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356955AbiBNRNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 12:13:20 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E16517B
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 09:13:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V4U-Zjh_1644858788;
Received: from 192.168.31.207(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4U-Zjh_1644858788)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 01:13:09 +0800
Message-ID: <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
Date:   Tue, 15 Feb 2022 01:13:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
 <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
 <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 2/13/22 03:51, Olivier Langlois wrote:
> On Wed, 2022-02-09 at 11:34 +0800, Hao Xu wrote:
>> 在 2022/2/9 上午1:05, Jens Axboe 写道:
>>> On 2/8/22 7:58 AM, Olivier Langlois wrote:
>>>> Hi,
>>>>
>>>> I was wondering if integrating the NAPI busy poll for socket fds
>>>> into
>>>> io_uring like how select/poll/epoll are doing has ever been
>>>> considered?
>>>>
>>>> It seems to me that it could be an awesome feature when used
>>>> along with
>>>> a io_qpoll thread and something not too difficult to add...
>>> Should be totally doable and it's been brought up before, just
>>> needs
>>> someone to actually do it... Would love to see it.
>>>
>> We've done some investigation before, would like to have a try.
>>
> Hao,
>
> Let me know if I can help you with coding or testing. I have done very
> preliminary investigation too. It doesn't seem like it would be very
> hard to implement but I get confused with small details.
>
> For instance, the epoll implementation, unless there is something that
> I don't understand, appears to have a serious limitation. It seems like
> it would not work correctly if there are sockets associated to more
> than 1 NAPI device in the fd set. As far as I am concerned, that

Yes, it seems that epoll_wait only does busy polling for 1 NAPI.

I think it is because the busy polling there is just an optimization

(doing some polling before trapping into sleep) not a must have,

so it's kind of trade-off between polling and reacting to other events

I guess. Not very sure about this too..

The iouring implementation I'm thinking of in my mind is polling for every

NAPI involved.


Regards,

Hao

> limitation would be ok since in my setup I only use 1 device but if it
> was necessary to be better than the epoll implementation, I am not sure
> at all how this could be addressed. I do not have enough kernel dev
> experience to find easy solutions to those type of issues...
>
> Worse case scenario, I guess that I could give it a shot creating a
> good enough implementation for my needs and show it to the list to get
> feedback...
>
> Greetings,
> Olivier
