Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD7B392088
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 21:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhEZTIG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 15:08:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235459AbhEZTHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 15:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622055983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZqUwqjGW3WLLcAH5VB99cHVcOFBx82D59nWRgjzEto=;
        b=AYgDt2wKTjzJCC7CFdgrOrxs7W9sS+yjCa2kGVurcubAhwHQmwwQEydBNlyJRzY14ubBiU
        e4JZUeXuKjY8nhhxVldO2/wklDB/MtL/Kma16iiBMS37PCTxWsX88ZiLBkg5WqH9L3CwRU
        MsZ4cnrkZG71+eg1HHdcMdXLeibe2nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-AA6dRXc0NXCsONS8bFLB5A-1; Wed, 26 May 2021 15:06:21 -0400
X-MC-Unique: AA6dRXc0NXCsONS8bFLB5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B285B19251A2;
        Wed, 26 May 2021 19:06:19 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86FCE5C238;
        Wed, 26 May 2021 19:06:15 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 0/9] Add LSM access controls and auditing to io_uring
References: <162163367115.8379.8459012634106035341.stgit@sifl>
        <x498s41o806.fsf@segfault.boston.devel.redhat.com>
        <CAHC9VhQ9r7WHbq2ga+-PF0x5q29nkdNjbLouQETvxDtjE3QaQg@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 26 May 2021 15:07:09 -0400
In-Reply-To: <CAHC9VhQ9r7WHbq2ga+-PF0x5q29nkdNjbLouQETvxDtjE3QaQg@mail.gmail.com>
        (Paul Moore's message of "Wed, 26 May 2021 14:49:07 -0400")
Message-ID: <x49o8cxmi02.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Wed, May 26, 2021 at 10:59 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>> Paul Moore <paul@paul-moore.com> writes:
>>
>> > Also, any pointers to easy-to-run io_uring tests would be helpful.  I
>> > am particularly interested in tests which make use of the personality
>> > option, share urings across process boundaries, and make use of the
>> > sqpoll functionality.
>>
>> liburing contains a test suite:
>>   https://git.kernel.dk/cgit/liburing/
>>
>> You can run it via 'make runtests'.
>
> Thanks Jeff, I'll take a look.  Quick question as I start sifting
> through the tests, are there any tests in here which share a single
> ring across process boundaries?

Yes.  At the very least, this one:

test/across-fork.c

-Jeff

