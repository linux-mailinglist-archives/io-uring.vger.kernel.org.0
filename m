Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD72C1E6E6D
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 00:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436904AbgE1WNF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 May 2020 18:13:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43738 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436899AbgE1WNC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 May 2020 18:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590703980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJ7wUIz8+LqU8MlmdK+YO1zPyDMYMFj8DiuWpWexjXM=;
        b=OlPmV1TTIzdV0CFwp/pSWbuFjTjGua5d14O2h2pKwwCyADhaf4XLkpA7fzaFU4qo7LFUi7
        YgWB7u6aPfaQpW5T9YZCdwLnrS9yzaj7F8//kUOp9WxFprr2eZpKJ7cOsoLtfiWUrjjeVe
        zXIBhnQJvhMgIJoopjGkqbjRvOpa5kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-xmgWEHMrOtG3zGaeLswzeQ-1; Thu, 28 May 2020 18:12:57 -0400
X-MC-Unique: xmgWEHMrOtG3zGaeLswzeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0269D8018AC;
        Thu, 28 May 2020 22:12:56 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75C862B6EA;
        Thu, 28 May 2020 22:12:55 +0000 (UTC)
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
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 28 May 2020 18:12:54 -0400
In-Reply-To: <798e24c7-b973-00c7-037f-4095e43515b7@kernel.dk> (Jens Axboe's
        message of "Thu, 28 May 2020 13:22:19 -0600")
Message-ID: <x49o8q7zp21.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> poll won't work over dm, so that looks correct. What happens if you edit
>> it and disable poll? Would be curious to see both buffered = 0 and
>> buffered = 1 runs with that.
>> 
>> I'll try this here too.
>
> I checked, and with the offending commit reverted, it behaves exactly
> like it should - io_uring doesn't hit endless retries, and we still
> return -EAGAIN to userspace for preadv2(..., RFW_NOWAIT) if not supported.
> I've queued up the revert.

With that revert, I now see an issue with an xfs file system on top of
an nvme device when running the liburing test suite:

Running test 500f9fbadef8-test
Test 500f9fbadef8-test failed with ret 130

That means the test harness timed out, so we never received a
completion.

-Jeff

