Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC61E811F
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 17:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgE2PCf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 11:02:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726476AbgE2PCf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 11:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590764553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lV3Lg1mm8lwM4+kuioEU6LnhzDq9n3BD9WBg/44Moz4=;
        b=CFm+RbtGVQIUpgtRuIG03jdqzDbpiY+X8A3QuSSnx7jxBqvDYDEx5in/S1+A8fDVnWm7i9
        KJ3gsMOrSb4f425pjGGwKH4OvddyZ6P0kek+6lvFyj3ekbTfm7Hyyf38WQj74Fc6dnZq/x
        X9TUA8ITyUF9qZd5C7PFpnAR7nR4ZFA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-kgy6AAhYMhG-7dtZ0LlZww-1; Fri, 29 May 2020 11:02:31 -0400
X-MC-Unique: kgy6AAhYMhG-7dtZ0LlZww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC2E08017CC;
        Fri, 29 May 2020 15:02:30 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 631225D9D5;
        Fri, 29 May 2020 15:02:30 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        io-uring@vger.kernel.org
Subject: Re: [RFC 2/2] io_uring: mark REQ_NOWAIT for a non-mq queue as unspported
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
        <1589925170-48687-3-git-send-email-bijan.mottahedeh@oracle.com>
        <x495zcf29ie.fsf@segfault.boston.devel.redhat.com>
        <0ab35b4b-be67-8977-08ea-2998a4ac1a7e@kernel.dk>
        <798e24c7-b973-00c7-037f-4095e43515b7@kernel.dk>
        <x49o8q7zp21.fsf@segfault.boston.devel.redhat.com>
        <6ca210e3-eba6-0621-3ebc-d3545f5ad7e9@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 29 May 2020 11:02:29 -0400
In-Reply-To: <6ca210e3-eba6-0621-3ebc-d3545f5ad7e9@kernel.dk> (Jens Axboe's
        message of "Thu, 28 May 2020 17:03:39 -0600")
Message-ID: <x49h7vyzsvu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 5/28/20 4:12 PM, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>>> poll won't work over dm, so that looks correct. What happens if you edit
>>>> it and disable poll? Would be curious to see both buffered = 0 and
>>>> buffered = 1 runs with that.
>>>>
>>>> I'll try this here too.
>>>
>>> I checked, and with the offending commit reverted, it behaves exactly
>>> like it should - io_uring doesn't hit endless retries, and we still
>>> return -EAGAIN to userspace for preadv2(..., RFW_NOWAIT) if not supported.
>>> I've queued up the revert.
>> 
>> With that revert, I now see an issue with an xfs file system on top of
>> an nvme device when running the liburing test suite:
>> 
>> Running test 500f9fbadef8-test
>> Test 500f9fbadef8-test failed with ret 130
>> 
>> That means the test harness timed out, so we never received a
>> completion.
>
> I can't reproduce this. Can you try again, and enable io_uring tracing?
>
> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>
> run test
>
> send the 'trace' file, or take a look and see what is going on.

I took a look, and it appeared as though the issue was not in the
kernel.  My liburing was not uptodate, and after grabbing the latest,
the test runs to completion.

Thanks!
Jeff

