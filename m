Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39A7D450C
	for <lists+io-uring@lfdr.de>; Tue, 24 Oct 2023 03:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjJXBgY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 21:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjJXBgY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 21:36:24 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1EDE;
        Mon, 23 Oct 2023 18:36:22 -0700 (PDT)
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
        by mailout.nyi.internal (Postfix) with ESMTP id 05C805C039A;
        Mon, 23 Oct 2023 21:36:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 23 Oct 2023 21:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1698111379; x=1698197779; bh=9J
        0ZoSHZZJfNIXjsydauE4Wu3MSGMm0P6Y6Lgsx/GH0=; b=laaBaHL84tTgZVXECW
        5LTJeVP7eWWuorRB9p0QnWRCi9+2jXPQTvzUfcwxh0yHZtS51x+BBAoaEpKl3trj
        4viciQ7ctOUKJ/GAcg91lL/lyg/QTY9M/OWzdBpDVV+UUJQIyqRgnGET75GqqDWh
        tjqBCNPIlsXhTShh3uGmagzZCmmTO11P0PzkitZodnVFWbz4+MLrMlUBNsO53Tus
        zxR0W1+xWmWqHv+6mvEObYdGcEJiBqcvG4YEUrNjhkE8UjEkPO6IFqU/Rr01erYW
        4vSYK5BvNlbHZcNTGGPREAPBViscT3lFG7o70ADlGt0YP/kUCi8PEWiT61SgLEu0
        eV3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698111379; x=1698197779; bh=9J0ZoSHZZJfNI
        XjsydauE4Wu3MSGMm0P6Y6Lgsx/GH0=; b=OKq3Coa0rNBd/0W4x+PmsT9zPJmaS
        J0hUFQASvmahTuECcvsqrehMpzDCwjrjH3fpS0Y/PwCFGzfIyUUB3rsXolOoqVxW
        uwUXnZCVqLZ1ZwQEau3YWwBJlPm4jgkWad+zbmIiA460+kDzETaluQzLjErVatq1
        oQF7CVdRq6xebn/tex6TeT4DXiaJVcW6ctJ/eShl0ozz9vCo9RTxB99Nk1mYmrR/
        sk0SXTlaJGPEWoUwqMgAyt3NRZtGNOTZbl9iBQ2ks8TRMo8GRbrg1uMQxX1HeFCT
        CK0LJxIfV3bbtOla2ceqQLQ/cJsCdX3Uu1z3IZ/ePn9O+9fZ610vy/zUQ==
X-ME-Sender: <xms:kh83ZRPeEWMGVEVR2s3M1OSI4LDEDTMRkzuuEGOznVJvqDIGVtGMbA>
    <xme:kh83ZT-8mreZXyvCYgAsK5bYfq4wGfpIZhY_jJvF_yWZtZbD08_dvreOjahsxw33z
    oVl5rZ9B_J1EGJpqQ>
X-ME-Received: <xmr:kh83ZQQZd1UfQw-4bU0cGWIu8u7QTvT85CVxRHLdObx-he5aaZLNUJSA28OL38GZp7izLBEmSbPSLtCPoHVPVbJLBX5Lldplga9f3MzEk9MiSikIvqG9wAG2xjF2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrkeejgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:kh83ZduqwjBAvoklMkE4ENR5EP2tu6GGA_ncF10RpGKP7ggRFp7J9w>
    <xmx:kh83ZZdFi1DeXebW5qR3USskkXcJhKPUh9Vy8c4nWhs1IpDHZeMxBg>
    <xmx:kh83ZZ3n7AWqtqzkYtUejhAg9upmWa73mqb_G0xCdfMCt0AEEoEJWg>
    <xmx:kx83ZaVrukIljQDpw8ZgK55tMJcsBytTwqi6ekGJ14yswXeW3DSUjg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Oct 2023 21:36:18 -0400 (EDT)
Date:   Mon, 23 Oct 2023 18:36:16 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        Ricardo =?utf-8?Q?Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        gustavo.padovan@collabora.com, zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: task hung in ext4_fallocate #2
Message-ID: <20231024013616.pq5wdgmfb55mnyze@awork3.anarazel.de>
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-10-24 12:12:23 +1100, Dave Chinner wrote:
> [cc Jens, io-uring]

Yes, good call, had been meaning to do that but forgot.

> On Tue, Oct 17, 2023 at 07:50:09PM -0700, Andres Freund wrote:
> > I had the idea to look at the stacks (via /proc/$pid/stack) for all postgres
> > processes and the associated io-uring threads, and then to deduplicate them.
> > 
> > 22x:
> > ext4_file_write_iter (./include/linux/fs.h:1073 fs/ext4/file.c:57 fs/ext4/file.c:564 fs/ext4/file.c:715)
> > io_write (./include/linux/fs.h:1956 io_uring/rw.c:926)
> > io_issue_sqe (io_uring/io_uring.c:1878)
> > io_wq_submit_work (io_uring/io_uring.c:1960)
> > io_worker_handle_work (io_uring/io-wq.c:596)
> > io_wq_worker (io_uring/io-wq.c:258 io_uring/io-wq.c:648)
> > ret_from_fork (arch/x86/kernel/process.c:147)
> > ret_from_fork_asm (arch/x86/entry/entry_64.S:312)
> 
> io_uring does some interesting stuff with IO completion and iomap
> now - IIRC IOCB_DIO_CALLER_COMP is new 6.6-rc1 functionality. This
> flag is set by io_write() to tell the iomap IO completion handler
> that the caller will the IO completion, avoiding a context switch
> to run the completion in a kworker thread.
> 
> It's not until the caller runs iocb->dio_complete() that
> inode_dio_end() is called to drop the i_dio_count. This happens when
> io_uring gets completion notification from iomap via
> iocb->ki_complete(iocb, 0);
> 
> It then requires the io_uring layer to process the completion
> and call iocb->dio_complete() before the inode->i_dio_count is
> dropped and inode_dio_wait() will complete.
> 
> So what I suspect here is that we have a situation where the worker
> that would run the completion is blocked on the inode rwsem because
> this isn't a IOCB_NOWAIT IO and the fallocate call holds the rwsem
> exclusive and is waiting on inode_dio_wait() to return.
> 
> Cc Jens, because I'm not sure this is actually an ext4 problem - I
> can't see why XFS won't have the same issue w.r.t.
> truncate/fallocate and IOCB_DIO_CALLER_COMP delaying the
> inode_dio_end() until whenever the io_uring code can get around to
> processing the delayed completion....

The absence of a reproducer obviously is not proof of an absence of
problems. With that said, I have run the workload on xfs for far longer on
both bigger and smaller machines, without triggering the same symptoms.

Greetings,

Andres Freund
