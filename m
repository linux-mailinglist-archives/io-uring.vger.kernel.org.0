Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E6424400C
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 22:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHMUtN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 16:49:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29381 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726192AbgHMUtN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 16:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597351751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ffn4p6zbGDq2jZcq23ay+hgurYer5FQwJQjcpNrhDM8=;
        b=KW+C77a/W/v8+qYZfd72B2wTzPVS+b33AQO3M7+I1Lx6FCtkqwXEHsKt9+vkYZqehQyUNZ
        /sTg4weTSUJVjqVMLoaZ/x6wUsn7AA9ZxlzGRE96TkOr6MtLRcLLROKvUazH7q60vFmnsF
        H5b9Bpsr5fTt9s+zEQA3ly3zO2zvb5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-dZ5c0GxXPg-ZEsbNZFeN7w-1; Thu, 13 Aug 2020 16:49:09 -0400
X-MC-Unique: dZ5c0GxXPg-ZEsbNZFeN7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2C2C1005504;
        Thu, 13 Aug 2020 20:49:08 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 421AD5C1C2;
        Thu, 13 Aug 2020 20:49:08 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
References: <20200813175605.993571-1-axboe@kernel.dk>
        <x497du2z424.fsf@segfault.boston.devel.redhat.com>
        <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
        <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
        <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 13 Aug 2020 16:49:07 -0400
In-Reply-To: <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk> (Jens Axboe's
        message of "Thu, 13 Aug 2020 14:41:36 -0600")
Message-ID: <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 8/13/20 2:37 PM, Jens Axboe wrote:
>> On 8/13/20 2:33 PM, Jens Axboe wrote:
>>> On 8/13/20 2:25 PM, Jeff Moyer wrote:
>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>
>>>>> Since we've had a few cases of applications not dealing with this
>>>>> appopriately, I believe the safest course of action is to ensure that
>>>>> we don't return short reads when we really don't have to.
>>>>>
>>>>> The first patch is just a prep patch that retains iov_iter state over
>>>>> retries, while the second one actually enables just doing retries if
>>>>> we get a short read back.
>>>>
>>>> Have you run this through the liburing regression tests?
>>>>
>>>> Tests  <eeed8b54e0df-test> <timeout-overflow> <read-write> failed
>>>>
>>>> I'll take a look at the failures, but wanted to bring it to your
>>>> attention sooner rather than later.  I was using your io_uring-5.9
>>>> branch.
>>>
>>> The eed8b54e0df-test failure is known with this one, pretty sure it
>>> was always racy, but I'm looking into it.
>>>
>>> The timeout-overflow test needs fixing, it's just an ordering thing
>>> with the batched completions done through submit. Not new with these
>>> patches.

OK.

>>> The read-write one I'm interested in, what did you run it on? And
>>> what was the failure?
>> 
>> BTW, what git sha did you run?
>
> I do see a failure with dm on that, I'll take a look.

I ran it on a file system atop nvme with 8 poll queues.

liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20

The error I saw was:

Running test read-write:
Non-vectored IO not supported, skipping
cqe res -22, wanted 2048
test_buf_select_short vec failed
Test read-write failed with ret 1

But I don't think it was due to these two commits.

Thanks,
Jeff

