Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5A6F7335
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjEDThw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 15:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjEDThv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 15:37:51 -0400
Received: from mail.reece.sx (phobos.reece.sx [51.68.206.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF20A5FF9
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 12:37:50 -0700 (PDT)
Received: from [10.0.2.15] (unknown [192.168.144.2])
        by mail.reece.sx (Postfix) with ESMTPSA id 4FEE54FA039A;
        Thu,  4 May 2023 19:37:49 +0000 (UTC)
Message-ID: <204843b9-9758-c66f-b563-33865a8696bb@reece.sx>
Date:   Thu, 4 May 2023 20:37:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: io_uring is a regression over 16 year old aio/io_submit, 2+
 decades of Microsoft NT, and *BSD circa 1997-2001
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <23940f55-9905-4e4b-48dc-31d309c9e363@reece.sx>
 <6171ec94-150c-e277-d495-aaa3e1d694f7@kernel.dk>
 <9e050e00-d50d-04df-7372-34f0f5e404a5@reece.sx>
 <818a2af6-673a-38e6-d8ad-647e749d0a29@kernel.dk>
From:   Reece <me@reece.sx>
In-Reply-To: <818a2af6-673a-38e6-d8ad-647e749d0a29@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Does this mean you stopped after the part where I cited 3 APIs including 
an old Linux interface (16+ years old), FreeBSD's implementation, and a 
Windows NT interface that all predate a hypothetical 14 year old? I 
guess this means modern Linux is less mature than both its' former -16 
year old self and a hypothetical 14 year old.

On 04/05/2023 20:31, Jens Axboe wrote:
> Maybe less anonymous then, but the tone is still way out of line and
> not acceptable. If you don't want to be perceived as an angry 14 year
> old, I suggest you rewrite your email and try again. I stopped half way
> through that steaming pile of words.
>
>
> On 5/4/23 1:29 PM, Reece wrote:
>> what are you talking about? i literally cc'd you alongside the mailing list. how is an email alongside commits tied to my real legal name "anonymous" trolling?
>>
>> On 04/05/2023 20:27, Jens Axboe wrote:
>>> On 5/4/23 1:20?PM, Reece wrote a pile of garbage.
>>>
>>> If you have constructive criticism, the list is open to discuss it.
>>> Sending trolly garbage anonymously is, however, neither welcome nor a
>>> productive approach.
>>>
