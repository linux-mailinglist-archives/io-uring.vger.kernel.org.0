Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9034AA5B
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCZOoW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 10:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhCZOn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 10:43:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D65C0613AA;
        Fri, 26 Mar 2021 07:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=92BEnOFnANMpOhV4r5obgI+ctgm9EMwkTyHcYR7m4xw=; b=0fvnn/mIljrZy4Dg8aPGS7YmDv
        M/pZz8jC0btnXQpxekyJ5rub24vC/X1lGzVE+p37VlRfXHH7QFepl1M3qRz7JjXwVw9l9EmoSM/ZJ
        xhwu0JPsW9cBzbhc0euM2wImBo+BgfXxy0yNAbMi5ecQ6ZdC/kHIt29aOwTZMb3TWfG9QU+Qx54hF
        ki4AaOdyL+ACOSoFm1WT0+P5J07vopgKHllCyrofHYl5M/p0u0MqW0dnygx+xQxwOoOEln+7y1GfF
        NtxkYXv+Kd3jIbx7rNZzT7Li+OpcvRvLFKk8Cz/HKUk0qZ4b0AXfmJy8AgxlAPQOGHo/Nmz/OaU/S
        8MdH7mVAKgxfuTqg6MYIXCPM/NcsTm3UBt5ArBp5k9vSAxk2JJWDdhxWtM4qyZTZVpEJAIzzTgO0+
        VWgft5MEnOUgV3SgyVlEPcQKK827SN8qVctmrkmKXzyFxYuq5tn+sqicR2Uyzz7BDn4rPr+H8PBgx
        khI26n8NSw7OWLrEHwFrOe6i;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPngn-00038z-Bm; Fri, 26 Mar 2021 14:43:53 +0000
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 0/6] Allow signals for IO threads
Message-ID: <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
Date:   Fri, 26 Mar 2021 15:43:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.03.21 um 15:38 schrieb Jens Axboe:
> On 3/26/21 7:59 AM, Jens Axboe wrote:
>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>> The KILL after STOP deadlock still exists.
>>>
>>> In which tree? Sounds like you're still on the old one with that
>>> incremental you sent, which wasn't complete.
>>>
>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>
>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>> tested both of them separately and didn't observe anything. I also ran
>>> your io_uring-cp example (and found a bug in the example, fixed and
>>> pushed), fwiw.
>>
>> I can reproduce this one! I'll take a closer look.
> 
> OK, that one is actually pretty straight forward - we rely on cleaning
> up on exit, but for fatal cases, get_signal() will call do_exit() for us
> and never return. So we might need a special case in there to deal with
> that, or some other way of ensuring that fatal signal gets processed
> correctly for IO threads.

And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?

metze

