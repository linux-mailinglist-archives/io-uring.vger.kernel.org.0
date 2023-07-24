Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF3976006B
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 22:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjGXUW5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 16:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjGXUW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 16:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC076E4F
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 13:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690230130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ShKXd85SOx0saxITqxIawBxKdACPZs/8Qk1lelqQbIY=;
        b=Bytd3qrrv5/dtdBgI7cinP4U6g9kjt8472TQlRv7OfNWDs1+an3WTLtUv9i3uH6KcK9Yak
        Hbmi/H+KLxcEHeDSLqjbz3YhuPlDxKakpsalCH4pECWw1FBLkcz3UHYdZTYJRMnU9FY9LE
        Tn1RMxFsQCkcBSgD6/CsRm23x9FEqlo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-7eNZMO9ONJuqpUPYsJfYuw-1; Mon, 24 Jul 2023 16:22:05 -0400
X-MC-Unique: 7eNZMO9ONJuqpUPYsJfYuw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2B56802666;
        Mon, 24 Jul 2023 20:22:04 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B701492CA6;
        Mon, 24 Jul 2023 20:22:04 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Greg KH <gregkh@linuxfoundation.org>,
        Phil Elwell <phil@raspberrypi.com>, andres@anarazel.de,
        david@fromorbit.com, hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>, riel@surriel.com
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
        <2023072438-aftermath-fracture-3dff@gregkh>
        <140065e3-0368-0b5d-8a0d-afe49b741ad2@kernel.dk>
        <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk>
        <0f63b072-840c-db5d-13cd-7faa554975d3@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Mon, 24 Jul 2023 16:27:53 -0400
In-Reply-To: <0f63b072-840c-db5d-13cd-7faa554975d3@gmail.com> (Pavel
        Begunkov's message of "Mon, 24 Jul 2023 20:22:28 +0100")
Message-ID: <x49cz0hxdfa.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> On 7/24/23 16:58, Jens Axboe wrote:
>> Even though I don't think this is an actual problem, it is a bit
>> confusing that you get 100% iowait while waiting without having IO
>> pending. So I do think the suggested patch is probably worthwhile
>> pursuing. I'll post it and hopefully have Andres test it too, if he's
>> available.
>
> Emmm, what's the definition of the "IO" state? Unless we can say what exactly
> it is there will be no end to adjustments, because I can easily argue that
> CQ waiting by itself is IO.
> Do we consider sleep(N) to be "IO"? I don't think the kernel uses io
> schedule around that, and so it'd be different from io_uring waiting for
> a timeout request. What about epoll waiting, etc.?

See Documentation/filesystems/proc.rst (and mainly commit 9c240d757658
("Change the document about iowait")):

- iowait: In a word, iowait stands for waiting for I/O to complete. But there
  are several problems:

  1. CPU will not wait for I/O to complete, iowait is the time that a task is
     waiting for I/O to complete. When CPU goes into idle state for
     outstanding task I/O, another task will be scheduled on this CPU.
  2. In a multi-core CPU, the task waiting for I/O to complete is not running
     on any CPU, so the iowait of each CPU is difficult to calculate.
  3. The value of iowait field in /proc/stat will decrease in certain
     conditions.

  So, the iowait is not reliable by reading from /proc/stat.

Also, vmstat(8):
       wa: Time spent waiting for IO.  Prior to Linux 2.5.41, included in idle.

iostat/mpstat man pages:
              %iowait
                     Show the percentage of time that the  CPU  or  CPUs  were
                     idle  during which the system had an outstanding disk I/O
                     request.

sar(1):
              %iowait
                     Percentage of time that the CPU or CPUs were idle  during
                     which the system had an outstanding disk I/O request.

iowait was initially introduced in 2002 by Rik van Riel in historical
git commit 7b88e5e0bdf25 ("[PATCH] "io wait" process accounting").  The
changelog from akpm reads:

    Patch from Rik adds "I/O wait" statistics to /proc/stat.
    
    This allows us to determine how much system time is being spent
    awaiting IO completion.  This is an important statistic, as it tends to
    directly subtract from job completion time.
    
    procps-2.0.9 is OK with this, but doesn't report it.

I vaguely recall there was confusion from users about why the system was
idle when running database workloads.  Maybe Rik can remember more
clearly.

Anyway, as you can see, the definition is murky, at best.  I don't think
we should overthink it.  I agree with the principle of Jens'
patch--let's just not surprise users with a change in behavior.

Cheers,
Jeff

