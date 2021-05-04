Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6A372A08
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEDM1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 08:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhEDM1R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 08:27:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C29C061574;
        Tue,  4 May 2021 05:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=ZbfDCAxqtj0cfVzLcBzaHYoyu3xyh+hGqRNR2qCY/MU=; b=spQexJEC9bVqjX/s2JORxAuyUW
        2s4vZyLrSYkF/fdR7LnU7q3LrTLHEcXLK8TDZF1vXAzgwqlmo65keQIV5UAmHHuiX1gzEwSKu1tfj
        grMKaiPMF6fPc7mQz2BZyZRzXB4mcS8++8t6Ln2CYjvTQcxEpB8T4V2hnUq83FpUKmOtyqwZU8VBi
        QB5IgXaMTsStKbf0796hMttd7X8V3bkBjmJN/3rYPDsrXA7WmEXTUv1UywwF5MeeKyedlOjb+8fqy
        HJjWIxXVdEeJOSqF46ZBFwLtVwFS+6jMR+vaKZApvtR6xa6gstAESjV43t33O+VR+wTN60jvhBnka
        sgWl2dki1QocQzXnt6xhjocq0M1z9nt92H4KqdJUVcojSI0873mDooxK0DmY9ZfZ3nUi56cw9kRA5
        eqBgG89EQ/kV9NIGiYUD7DNKfJenWgQSUE9rxbdaQckRd3uYO2AgBC8+rA8xV6KKlmRf2fHKYxbvp
        b4UmfH8H4mTRjLRIMyBQzwHr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1ldu82-0005QC-VK; Tue, 04 May 2021 12:26:19 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
Message-ID: <92e31509-c32e-9f2f-633a-e0ad3d3d1f1b@samba.org>
Date:   Tue, 4 May 2021 14:26:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

+ linux-kernel

I just retested with 5.12 final:

As long as I give the VM more than one cpu, I can easily reproduce the problem with:

> while true; do cat linux-image-5.12.0-rc8-dbg_5.12.0-rc8-22_amd64.deb > /dev/null; done
> and
> pidofcat=$(pidof cat); echo $pidofcat; trace-cmd record -e all -P $pidofcat

On a single cpu VM it doesn't seem to trigger.

Is anyone else able to reproduce this?

Any ideas how to debug this?

It's really annoying to fear a machine freeze when trying to trace problems
on recent kernels...

Thanks for any possible hint...
metze

Am 22.04.21 um 16:26 schrieb Stefan Metzmacher:
> 
> Hi Steven, hi Ingo,
> 
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
> 
> When I run 'trace-cmd -e all -P $pid' for 'io_wqe_worker-0' or 'io_wq_manager'
> I can reproduce the problem, then I found that the same seems to happen for
> also for other kernel threads e.g. '[kworker/1:1-events]', it seems that
> it happens for all kernel threads, which are not completely idle.
> 
> Which this:
> 
>  From 'top':
>    1341 root      20   0    2512    576    508 S  33,4   0,1   0:10.39 io_uring-cp-for
>    1343 root      20   0       0      0      0 R  29,8   0,0   0:08.43 io_wqe_worker-0
>       7 root      20   0       0      0      0 I   0,3   0,0   0:00.31 kworker/0:1-events
> 
>    PID 5 is [kworker/0:0-ata_sff]
> 
> # trace-cmd record -e all -P 5'
> Hit Ctrl^C to stop recording
> ^CCPU0 data recorded at offset=0x7b8000
>     0 bytes in size
> CPU1 data recorded at offset=0x7b8000
>     69632 bytes in size
> 
> # But
> # trace-cmd record -e all -P 7
> => machine unresponsive (no blinking cursor on the console anymore)
> On the host 'top' shows that the VirtualBoxVM cpu emulator thread 'EMT-1'
> uses 100% cpu, so I guess the guest kernel is in something like an endless
> recursion loop. Maybe a trace function recursing to itself?
> 
> On the same VM I tried a 5.12rc8 kernel and there I can also reproduce the
> problem.
> 
> I also managed to reproduce the problem without io-uring, just using:
> 
>  while true; do cat linux-image-5.12.0-rc8-dbg_5.12.0-rc8-22_amd64.deb > /dev/null; done
> 
> in order to keep some kernel threads moving.
> This happens with 5.12rc8 and 5.10.0-1023-oem, but I was not able to
> reproduce any of this using the 5.8.0-50-generic kernel, see
> https://kernel.ubuntu.com/git/ubuntu/ubuntu-focal.git/log/?h=Ubuntu-hwe-5.8-5.8.0-50.56_20.04.1
> 
> I was also able to reproduce this with a ubuntu 21.04 vm using
> the 5.11.0-14-generic kernel, see:
> https://kernel.ubuntu.com/git/ubuntu/ubuntu-hirsute.git/log/?h=Ubuntu-5.11.0-14.15
> On this one I only managed to reproduce the problem with
> './io_uring-cp-forever link-cp.c file', but not with
> 'while true; do cat linux-image-5.12.0-rc8-dbg_5.12.0-rc8-22_amd64.deb > /dev/null; done'
> 
> 
> So it seems the problem was introduced after 5.8 and is not really related to
> io-uring. And it may not be purely related to kernel threads.
> 
> With this on 5.12-rc8 (again):
> 
>   └─tmux: server,903
>       ├─bash,904
>       │   └─io_uring-cp-for,925 link-cp.c file
>       │       ├─{iou-mgr-925},926
>       │       └─{iou-wrk-925},927
>       └─bash,929
>           └─pstree,938 -a -t -p
> 
> I was able to to trace once:
> 
> root@ub1704-166:~# trace-cmd record -e all -P 925
> Hit Ctrl^C to stop recording
> ^CCPU0 data recorded at offset=0x7b8000
>     10842112 bytes in size
> CPU1 data recorded at offset=0x120f000
>     36450304 bytes in size
> 
> But the 2nd run reproduced the problem:
> root@ub1704-166:~# trace-cmd record -e all -P 925
> 
> I was also able to reproduce it with:
> 
> while true; do cat linux-image-5.12.0-rc8-dbg_5.12.0-rc8-22_amd64.deb > /dev/null; done
> and
> pidofcat=$(pidof cat); echo $pidofcat; trace-cmd record -e all -P $pidofcat
> 
> So it seems any busy thread (user or kernel) triggers the problem.
> 
> Any ideas what has changed after 5.8?
> 
> Thanks!
> metze
> 

