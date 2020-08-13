Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9024412E
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 00:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgHMWVj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 18:21:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42396 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbgHMWVj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 18:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597357297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E/9oryBE/fwZtrdoZ9CzoxldNjabl8b050CmatPEveM=;
        b=EMyTxGAYIuqHk2R4jPlOG70PtN+DP1cTqY3MH/exnHmNVDKDASk74inlF+tF6dT6jps1Rx
        0+WePZZN0UDrxN8bHBkuFXqw1mAbSuOag1T8V5SAWCxcGBh3dmhXp8iU7VrLLg2LxuGbsS
        oENLYJR28Dso7fV/qvjrvM3T0WU605k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-Rwm1l-DEOeKIi4KQG7fyGg-1; Thu, 13 Aug 2020 18:21:35 -0400
X-MC-Unique: Rwm1l-DEOeKIi4KQG7fyGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3B9B1902EC9;
        Thu, 13 Aug 2020 22:21:34 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EBD31992D;
        Thu, 13 Aug 2020 22:21:34 +0000 (UTC)
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
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 13 Aug 2020 18:21:33 -0400
In-Reply-To: <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk> (Jens Axboe's
        message of "Thu, 13 Aug 2020 16:08:37 -0600")
Message-ID: <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>>>> BTW, what git sha did you run?
>>>
>>> I do see a failure with dm on that, I'll take a look.
>> 
>> I ran it on a file system atop nvme with 8 poll queues.
>> 
>> liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
>> linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20
>
> Fixed it, and actually enabled a further cleanup.

Great, thanks!  Did you push that out somewhere?

-Jeff

