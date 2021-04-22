Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65B03682D0
	for <lists+io-uring@lfdr.de>; Thu, 22 Apr 2021 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhDVOzw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 10:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbhDVOzw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 10:55:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9037C06174A;
        Thu, 22 Apr 2021 07:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=ApBLGdb3srp23UKzOn+9GIUCj37fwCzBovp3Qog0JZE=; b=Wazm+xLNx+jQkpZCJJA2yhmrlf
        EJmV4jeWw9mlPtv894B5AZgmmaJyVpUvhJtJRC0l9nbSFU0fYAMGICZOuzO2rghClGPQ6CkdFQD90
        2I79SPqLnTptmWkk+XNz3ZEDHqDuY2Nsda+QPl26LudLhNN6hdVJaoSnLzNdikDsStHWoDRx2JlSO
        M6UmKaIE7yvVQPCm3EUV0Ovx3BGmrE8ykfF3tvSX1raQJRtzHME/oShAHiPsJt4iyyNEwfkfG87dK
        7kuRIh9176iIbg2y1YfbvFE0JKGSWPk/OpgwzqdSWVSKQMbfPLEpuIDm11QWjunBNjp/ln+Mxn3hN
        WUJG7pq5SgG7BPPwcZmjnN3O5xAmJoAOVUfpeuCadl4eBz0d68UXrZShM/Wh3zQbNNfb6kSwEskXg
        0Vajjg9zPhgyHx5HryIltw5Tl8QoIBCQOhqUEp/PIPgQshAblq/lh43/O5QWO6wYpJbZCxnoA1M3s
        FhnOMpHqr8/NjJtY2ZgybCoB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lZajX-0000sy-UN; Thu, 22 Apr 2021 14:55:12 +0000
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
Message-ID: <9f1e123b-dc5a-7ab4-2daa-e1d7dbfe7042@samba.org>
Date:   Thu, 22 Apr 2021 16:55:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

maybe not strictly related, but maybe it is...

> I recently tried to analyze the performance of Samba using io-uring.
> 
> I was using ubuntu 20.04 with the 5.10.0-1023-oem kernel, which is based on v5.10.25, see:
> https://kernel.ubuntu.com/git/kernel-ppa/mirror/ubuntu-oem-5.10-focal.git/log/?h=oem-5.10-prep
> trace-cmd is at version 2.8.3-4build1.
> 
> In order to find the bottleneck I tried to use (trace-cmd is at version 2.8.3-4build1):
> 
>   trace-cmd -e all -P ${pid_of_io_uring_worker}
> 
> As a result the server was completely dead immediately.
> 
> I tried to reproduce this in a virtual machine (inside virtualbox).
> 
> I used a modified 'io_uring-cp' that loops forever, see:
> https://github.com/metze-samba/liburing/commit/5e98efed053baf03521692e786c1c55690b04d8e
> 
> When I run './io_uring-cp-forever link-cp.c file',
> I see a 'io_wq_manager' and a 'io_wqe_worker-0' kernel thread,
> while './io_uring-cp-forever link-cp.c file' as well as 'io_wqe_worker-0'
> consume about 25% cpu each.


While doing the tests with 5.12-rc8, I somehow triggered
a backtrace on the VM console:

it contains:

...
io_issue_seq...
...
io_wq_submit_work
io_worker_handle_work
io_wqe_worker
...
io_worker_handle_work
...

RIP: 0100:trace_event_buffer_reserve+0xe5/0x150

Here's a screenshot of it:https://www.samba.org/~metze/io_issue_sqe_trace_event_buffer_reserve-5.12-rc8-backtrace.png

I don't know what the last action was, that I did before it happened.

metze


