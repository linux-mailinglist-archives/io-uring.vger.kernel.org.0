Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22F277E880
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 20:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345447AbjHPSQh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 14:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345451AbjHPSQg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 14:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857B51986
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 11:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692209755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4NCk5EuygTllxrThg0vFVBSkXpm2Kj6r/bz6FMUkUls=;
        b=NvMFsdPs6KmHDPI8AJZkWtRRouZAgFGhEL783J86k6j8gAaSvaz2nST6XugdRQQYzB71li
        jL0a7MOwzb76XxaNumZLQbMC1fjhjYhMlxnxF8Zsk9AVKl82eHYq3kLp0+HeHwPQ1bMqFQ
        OGrSFNh9dcfTI7pRWTWyDUaqPZ7SIXo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-8Hh94IScOuyW4gb4qhhidQ-1; Wed, 16 Aug 2023 14:15:54 -0400
X-MC-Unique: 8Hh94IScOuyW4gb4qhhidQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 131FC857A84;
        Wed, 16 Aug 2023 18:15:52 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E626492C13;
        Wed, 16 Aug 2023 18:15:51 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     matteorizzo@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, asml.silence@gmail.com, corbet@lwn.net,
        akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        andres@anarazel.de
Subject: Re: [PATCH v4] io_uring: add a sysctl to disable io_uring system-wide
References: <x49wmxuub14.fsf@segfault.boston.devel.redhat.com>
        <87cyzm504h.fsf@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Wed, 16 Aug 2023 14:21:39 -0400
In-Reply-To: <87cyzm504h.fsf@suse.de> (Gabriel Krisman Bertazi's message of
        "Wed, 16 Aug 2023 14:10:38 -0400")
Message-ID: <x49sf8iu9u4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> Jeff Moyer <jmoyer@redhat.com> writes:
>
>> From: Matteo Rizzo <matteorizzo@google.com>
>>
>> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1, or
>> 2. When 0 (the default), all processes are allowed to create io_uring
>> instances, which is the current behavior.  When 1, io_uring creation is
>> disabled (io_uring_setup() will fail with -EPERM) for processes not in
>> the kernel.io_uring_group group.  When 2, calls to io_uring_setup() fail
>> with -EPERM regardless of privilege.
>>
>> Signed-off-by: Matteo Rizzo <matteorizzo@google.com>
>> [JEM: modified to add io_uring_group]
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> ---
>> v4:
>>
>> * Add a kernel.io_uring_group sysctl to hold a group id that is allowed
>>   to use io_uring.  One thing worth pointing out is that, when a group
>>   is specified, only users in that group can create an io_uring.  That
>>   means that if the root user is not in that group, root can not make
>>   use of io_uring.
>
> Rejecting root if it's not in the group doesn't make much sense to
> me. Of course, root can always just add itself to the group, so it is
> not a security feature. But I'd expect 'sudo <smth>' to not start giving
> EPERM based on user group settings.  Can you make CAP_SYS_ADMIN
> always allowed for option 1?

Yes, that's easy to do.  I'd like to gather more opinions on this before
changing it, though.

>>   I also wrote unit tests for liburing.  I'll post that as well if there
>>   is consensus on this approach.
>
> I'm fine with this approach as it allow me to easily reject non-root users.

Thanks for taking a look!

-Jeff

