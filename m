Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D404248D8B
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 19:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgHRR4B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 13:56:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726541AbgHRR4A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 13:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597773359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7rcQfbzVqFNXSBFYczQ6SAPAKe67r5rVc8uGA9TgkhA=;
        b=iZRm8ym8zECwULRhOOVJFt5qCnXbBYM4WUb79Dj79A1c0luOltRJZ0zY+1wFmlg+8pZuBf
        IMrmtPDQ0cDKKqUlD3dG/iMQIY/Ddv4F8uKCPS5GmhITgaKdamkbL+cb4srj2/hvTL+V90
        zjjlJpypgv4SY7uPWtH2MkRi1ZwYrRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-R-rLzo32OhKa_0Y30_xfXg-1; Tue, 18 Aug 2020 13:55:57 -0400
X-MC-Unique: R-rLzo32OhKa_0Y30_xfXg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0260488EF19;
        Tue, 18 Aug 2020 17:55:56 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 747D2100EBA5;
        Tue, 18 Aug 2020 17:55:55 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
References: <20200813175605.993571-1-axboe@kernel.dk>
        <x497du2z424.fsf@segfault.boston.devel.redhat.com>
        <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
        <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
        <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
        <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
        <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
        <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
        <aadb4728-abc5-b070-cd3b-02f480f27d61@kernel.dk>
        <x49sgclf0w8.fsf@segfault.boston.devel.redhat.com>
        <8cc4bc11-eb56-63e1-bb5c-702b75068462@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 18 Aug 2020 13:55:54 -0400
In-Reply-To: <8cc4bc11-eb56-63e1-bb5c-702b75068462@kernel.dk> (Jens Axboe's
        message of "Mon, 17 Aug 2020 13:57:25 -0700")
Message-ID: <x49blj7x2hh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 8/17/20 1:55 PM, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> On 8/13/20 4:21 PM, Jeff Moyer wrote:
>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>
>>>>>>>> BTW, what git sha did you run?
>>>>>>>
>>>>>>> I do see a failure with dm on that, I'll take a look.
>>>>>>
>>>>>> I ran it on a file system atop nvme with 8 poll queues.
>>>>>>
>>>>>> liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
>>>>>> linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20
>>>>>
>>>>> Fixed it, and actually enabled a further cleanup.
>>>>
>>>> Great, thanks!  Did you push that out somewhere?
>>>
>>> It's pushed to io_uring-5.9, current sha is:
>>>
>>> ee6ac2d3d5cc50d58ca55a5967671c9c1f38b085
>>>
>>> FWIW, the issue was just for fixed buffers. It's running through the
>>> usual testing now.
>> 
>> OK.  Since it was an unrelated problem, I was expecting a separate
>> commit for it.  What was the exact issue?  Is it something that needs
>> backporting to -stable?
>
> No, it was a bug in the posted patch, so I just folded in the fix.

We must be hitting different problems, then.  I just tested your
5.7-stable branch (running the test suite from an xfs file system on an
nvme partition with polling enabled), and the read-write test fails:

Running test read-write:
Non-vectored IO not supported, skipping
cqe res -22, wanted 2048
test_buf_select_short vec failed
Test read-write failed with ret 1

That's with this head: a451911d530075352fbc7ef9bb2df68145a747ad

-Jeff

