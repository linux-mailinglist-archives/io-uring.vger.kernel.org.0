Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6D34AA65
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCZOqB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 10:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhCZOpa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 10:45:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E98C0613AA;
        Fri, 26 Mar 2021 07:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=mtNIqPG9Q1dGrTRGe+RN+2nCiKVa40ParN2yl85CZag=; b=xMWEHeL0j0R9MXCbrX2fCj04af
        +xm+YVzki5Mb5SP/Xj8sJTfu8Ay3RxevoIKsYLEDMMj595h5yFFHX6awnGFK6+LEtBx3dm1ZMwkyq
        4kGujtP10e1fpcqOxY/OfZdOGgo497qcYYQSSaSz4o0rYOvoC9jUM+BfpLpq7sY9sUjWf6gi17/Fc
        supOCeU/oVVpTD15UEsd8DlbHKgzmKBaBty3H206WVp8GWDYNyIpbNNA8AL419GHsXcttdVZNmbiY
        S8sEZ2OqJFc9FWAC2Sn8Ie4UJ+ZP/E5/ryTR78nrVFrmIw1GKEAQyKZ+1SOSFEMFQ1wRr0det6yxw
        fe9CJH+pFMmGFxU7DLnLhPWngALAihhH9D+RqlrMNhj/so5ySVa84ZOCQ5z/ayN8HjTn1bOcpAqxc
        O/oeaKXWs2RFj/W7sw6tCh+WvLcX3XOFGrbkJHzw4dCpiiUjByFB0aiXjgPLIym3rFRoKv1GbqGp9
        +k5cSjJn4p7TB0sEeSp/4cnL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPniK-00039z-F3; Fri, 26 Mar 2021 14:45:28 +0000
Subject: Re: [PATCH 0/6] Allow signals for IO threads
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
 <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
 <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
Message-ID: <ac807735-53d0-0c9e-e119-775e5e01d971@samba.org>
Date:   Fri, 26 Mar 2021 15:45:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>> The KILL after STOP deadlock still exists.
>>>>
>>>> In which tree? Sounds like you're still on the old one with that
>>>> incremental you sent, which wasn't complete.
>>>>
>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>
>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>> tested both of them separately and didn't observe anything. I also ran
>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>> pushed), fwiw.
>>>
>>> I can reproduce this one! I'll take a closer look.
>>
>> OK, that one is actually pretty straight forward - we rely on cleaning
>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>> and never return. So we might need a special case in there to deal with
>> that, or some other way of ensuring that fatal signal gets processed
>> correctly for IO threads.
> 
> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?

Ah, we're still in the first get_signal() from SIGSTOP, correct?

metze

