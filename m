Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3F246F298
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 18:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhLISAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 13:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbhLISAF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 13:00:05 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2478C061746
        for <io-uring@vger.kernel.org>; Thu,  9 Dec 2021 09:56:31 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id d14so3713656ila.1
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 09:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IwDQColPGCU49BS4yP7Ee0C5BTDNWKC0qbV8xP+eXUg=;
        b=elwo14buS+US6KaK2JgnQiS0L06mqmS8PcR3s8oohAKmrKLqQiH4dQsH/qShYyMQFw
         6Wqgt1MztAxPd0Z9wLqOt/EHqyu3uoX38r4e0qSiDaIZjX9TKVR1wnsSHxifTRHEd2aO
         92pxnIT7AukV47LphWHpkC0U847e8iQRDwwnVQFFbWf/ohanXFXm9+RnUPa+XJuw9CdJ
         qytXsvRLY+0E/3znKC25AOiWzKpkXt7HNbCt7yXtRqko6kdmqA9Re1RRZ4EtBlotNf3F
         EYvuwNnQtjISfi69HZBdHnX0IUPN0jIfU5jn2AxTbajllqJvwPM54qnhY73RrbFZ1xwV
         0RqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IwDQColPGCU49BS4yP7Ee0C5BTDNWKC0qbV8xP+eXUg=;
        b=lldHTawr5ASY1KNg3N39JRxHOehS1J8TbpFqueLJaJ92godrqo5jtNubUxfKbtG8N8
         d+8UrwAKhlIshjZ+W51+pN341b4XWZMSXhKGSVbIqVjUSVQHtMF3midZnBkA1V6AAE5k
         HVFg3F2oY3qY6h2zex9G/9R0i38rVSsu1Czg6teopjuK3rjki1/anKGtjQi9nShsODIS
         Yro48lqN81l+oxNPGoFmgLQ6tubUZoAMczLLWemTGRguzevpy9CHDfnyP7gfAG7iKVXV
         ctDtceCH8bgk/YzVYnGSfL15DVWhMcYdOw9lSNzoufpO/Z8wUCOT7XGYpjY+zHzoeOwH
         NBig==
X-Gm-Message-State: AOAM533N6e73MEewjUkAnuvpJ7wTDe2DuGWaDsLGPTcpuI7HkW0h5Kd9
        Z07wwGPg8AgelL8pHAw0OYZeDAULfWg=
X-Google-Smtp-Source: ABdhPJxP/9vN/DoAza/xmJrDv4DUML6dSm2vEEIm2JeYon83K+M2IlktSkS/V6mX2/U9vReVqQ0HnA==
X-Received: by 2002:a05:6e02:1ba8:: with SMTP id n8mr17332683ili.254.1639072591377;
        Thu, 09 Dec 2021 09:56:31 -0800 (PST)
Received: from p51.localdomain (bras-base-mtrlpq4706w-grc-05-174-93-161-243.dsl.bell.ca. [174.93.161.243])
        by smtp.gmail.com with ESMTPSA id l1sm275897iln.48.2021.12.09.09.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:56:30 -0800 (PST)
Received: by p51.localdomain (Postfix, from userid 60092)
        id 233D711B88C0; Thu,  9 Dec 2021 12:56:36 -0500 (EST)
Date:   Thu, 9 Dec 2021 12:56:36 -0500
From:   jrun <darwinskernel@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: happy io_uring_prep_accept_direct() submissions go hiding!
Message-ID: <20211209175636.oq6npmqf24h5hthi@p51>
References: <20211208190733.xazgugkuprosux6k@p51>
 <024aae30-1fdc-f51b-7744-9518a39cbb19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <024aae30-1fdc-f51b-7744-9518a39cbb19@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 09, 2021 at 03:02:12PM +0000, Pavel Begunkov wrote:
> Don't see how a CQE may get missing, so let me ask a bunch of questions:
> 
> First, let's try out my understanding of your problem. At the beginning you
> submit MAX_CONNECTIONS/2 accept requests and _all_ of them complete. 

correct.

> In the main loop you add another bunch of accepts, but you're not getting CQEs
> from them. Right ?

yes, io_uring_prep_accept_direct() submissions before entering the main loop
complete.any io_uring_prep_accept_direct() submitted from within the main loop
goes missing.

> 1) Anything in dmesg? Please when it got stuck (or what the symptoms are),
> don't kill it but wait for 3 minutes and check dmesg again.
>

nothing in dmesg!

> Or you to reduce the waiting time:
> "echo 10 > /proc/sys/kernel/hung_task_timeout_secs"

oh, my kernel[mek] is missing that; rebuilding right now with
`CONFIG_DETECT_HUNG_TASK=y`; will report back after reboot.

btw, enabled CONFIG_WQ_WATCHDOG=y for workqueue.watchdog_thresh; don't know if
that would help too. let me know.

also any magic with bpftrace you would suggest?

> And then should if anything wrong it should appear in dmesg max in 20-30 secs
>
> 2) What kernel version are you running?

[mek]: Linux 5.15.6-gentoo-p51 #5 SMP PREEMPT x86_64 i7-7700HQ

> 3) Have you tried normal accept (non-direct)?

no, will try, but accept_direct worked for me before introducing pthread into
the code. don't know if it matters.

> 4) Can try increase the max number io-wq workers exceeds the max number
> of inflight requests? Increase RLIMIT_NPROC, E.g. set it to
> RLIMIT_NPROC = nr_threads + max inflight requests.

i only have 1 thread atm but will try this with the new kernel and report back.

> 5) Do you get CQEs when you shutdown listening sockets?

yes! io_uring_prep_close_direct() call, there is only one inside dq_msg(), come
in on subsequent arrival of connect() requests from the client.
tested with and without IOSQE_ASYNC set.

> 6) Do you check return values of io_uring_submit()?
> 
> 7) Any variability during execution? E.g. a different number of
> sockets get accepted.

with IORING_SETUP_SQPOLL, i was getting different numbers for:
pending, = io_uring_sq_ready(ring); vs
submitted, = io_uring_submit(ring); according to the commented block at the
beginning of the event loop. don't if that's the way to check what you're
asking. let me know please.


thanks for the help,
	- jrun
