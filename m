Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EC634296A
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 01:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhCTAZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 20:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCTAZV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 20:25:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD3DC061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 17:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=sh0Hysut1X62czHpxpWCKG/K7xGFHqqqcBK8e7aDtiw=; b=Ih8gx8eqIUQ2dcZTTKjSA8IGk4
        MKSXJMEwlkKAjkNa8btLzbJDgaSXBn5ZaSjx99aUfr6l9Op1xXSn+ZNX2K/sk9NGKaljxKKJNKExk
        9IDmyydWS+vGU8wb0LJnAdP6qzNik4uZFGCx1JaFdT7ZnxE66kh5sDKDEjnsr9sCAH9hHlh3v8Ytk
        DieLb31vgzvNk6YKNCaVLtqxcEEBZJZHaliu0ln/66sAjSgvWHPXClMnC2Dv2oWyhA2P/dJCz9vgc
        j7LfPstSERTVbZkmE99pTI5RBmSGwSsur4AhPJByizbb1CETZDfCEtaq5BYep1jJS2byqBw9u4gOW
        ofSaUSZRwlcvdNkohULscHV1ToBY3WYB5XftJErAq3GJgFq/WGiyjS38ZCsNMioHogNHohqwaIyOr
        0WMdqX6XNkK0waZ7j2ambmxCMOtJSlVsLhraA1Ve8xLDgRB21XxnEO6woGUFvkLlGHb9RLHcgX/S9
        HKrtf1rxXLhSeYspLZ29cgT0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNPQd-0007eq-1J; Sat, 20 Mar 2021 00:25:19 +0000
Subject: Re: Problems with io_threads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
 <F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <85472dbd-7113-fe2b-fe0e-100d8fc34860@samba.org>
Date:   Sat, 20 Mar 2021 01:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 20.03.21 um 00:46 schrieb Jens Axboe:
> On Mar 19, 2021, at 5:27 PM, Stefan Metzmacher <metze@samba.org> wrote:
>>
>> ﻿Hi Jens,
>>
>> as said before I found some problems related to
>> the new io_threads together with signals.
>>
>> I applied the diff (at the end) to examples/io_uring-cp.c
>> in order to run endless in order to give me time to
>> look at /proc/...
>>
>> Trying to attach gdb --pid to the pid of the main process (thread group)
>> it goes into an endless loop because it can't attach to the io_threads.
>>
>> Sending kill -STOP to the main pid causes the io_threads to spin cpu
>> at 100%.
>>
>> Can you try to reproduce and fix it? Maybe same_thread_group() should not match?
> 
> Definitely, I’ll go over this shortly and make sure we handle (and ignore) signals correctly. 

Thanks! Also a kill -9 to a io_thread kills the application.

metze

