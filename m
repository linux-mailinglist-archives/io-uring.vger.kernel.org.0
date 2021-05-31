Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412893966CA
	for <lists+io-uring@lfdr.de>; Mon, 31 May 2021 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhEaRW0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 13:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhEaRWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 May 2021 13:22:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DACC03463D;
        Mon, 31 May 2021 08:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=RVlbLW66TiIW3jd2h4UgrbY33doG/AEt9RLkSJlK1Jc=; b=A1Ce2XWbByqZg2EhFThmC4fBq3
        fanNp2dIRSaqzNBfCXiVKwwzfaid731+GMMmBNIgAAgtcvDs1PHPgYSPGuXxYdmVDsTwIbBUNVaUl
        Sx5psZHosWOg6NeC08qG/LgpielW6tovvKfnHg3h30CETss54aEGEJhaEXdFzk5JJr0E8sLuTI2Nj
        0HPhn2/vWnxqITZpRUuDkqIQRp2hc04NMzPGVLFD1HT5GPI7skNR+DDSWQ3bzuhoFgDaX4vxidNEm
        jX1plyUKly+SZs+LQxyf9y6CaISXWhUF/j5pKeHopfIlAkdtj1uyKRJRg3ZgAbjJbBIQ5z+zFaTUp
        CC0M9cfFX1tfaVrK0JRS9ububuzuX/Yynu8Y/w/60C0mF0fWwVWlkDKZABsDCtS+OnsNkivssyOpL
        cwCeTYFruJGCt9O0ve2vMkDs+2RfJCd0ggSUCJQew6MhtjzZVs49HwhoXc6/WYMJHYB90+7MLG0Ux
        Na2enXAHcd3lB6gWRcaI1M+m;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lnk1G-0006kR-Gj; Mon, 31 May 2021 15:39:58 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
Message-ID: <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
Date:   Mon, 31 May 2021 17:39:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Steve,

did these details help in any ways?

Thanks!

Am 05.05.21 um 11:50 schrieb Stefan Metzmacher:
...
>>
>> Perhaps you could try something like this:
>>
>>  # trace-cmd list -s |
>>     while read e ; do
>>       echo "testing $e";
>>       trace-cmd record -P 7 -e $e sleep 1;
>>     done
>>
>> Which will enable each system at a time, and see if we can pin point what
>> is causing the lock up. Narrow it down to a tracing system.
> 
> I wasn't able to reproduce it.
> 
> With a 5.12 kernel and ubuntu 20.04 amd64 userspace I was able
> to produce the following strace output (in the 2nd try), like this:
> 
> # ssh root@172.31.9.166 strace -f -ttT trace-cmd record -e all -P 101 2>&1 | tee out
> 
> 101 is the pid of a kthread while my './io-uring_cp-forever link-cp.c file' runs
> on '172.31.9.166'. See https://github.com/metze-samba/liburing/commits/io_uring-cp-forever
> pid 1375 is the pid of 'iou-wrk-1373'.
> 
> Maybe it's related to writing the pid into /sys/kernel/tracing/set_event_pid
> as it ends like this:
>> 10:56:07.493869 stat("/sys/kernel/tracing/set_event_pid", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000222>
>> 10:56:07.494500 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_RDONLY) = 3 <0.000134>
>> 10:56:07.494934 read(3, "1375\n", 8192) = 5 <0.000433>
>> 10:56:07.495708 close(3)                = 0 <0.000121>
> ...> [pid  1443] 10:56:10.045293 openat(AT_FDCWD, "/sys/kernel/tracing/set_ftrace_pid", O_WRONLY|O_TRUNC|O_CLOEXEC <unfinished ...>
>> [pid  1444] 10:56:10.045650 <... read resumed>"sysfs /sys sysfs rw,nosuid,nodev"..., 1024) = 1024 <0.000948>
>> [pid  1443] 10:56:10.045821 <... openat resumed>) = 5 <0.000359>
>> [pid  1445] 10:56:10.046000 <... fstat resumed>{st_mode=S_IFREG|0444, st_size=0, ...}) = 0 <0.000873>
>> [pid  1443] 10:56:10.046174 write(5, "101 ", 4 <unfinished ...>
>> [pid  1444] 10:56:10.046674 read(5,  <unfinished ...>
>> [pid  1443] 10:56:10.047007 <... write resumed>) = 4 <0.000475>
>> [pid  1445] 10:56:10.047188 read(5,  <unfinished ...>
>> [pid  1443] 10:56:10.047498 write(5, " ", 1 <unfinished ...>
>> [pid  1444] 10:56:10.048343 <... read resumed>"_cls,net_prio cgroup rw,nosuid,n"..., 1024) = 1024 <0.001312>
>> [pid  1445] 10:56:10.048578 <... read resumed>"sysfs /sys sysfs rw,nosuid,nodev"..., 1024) = 1024 <0.001224>
>> [pid  1444] 10:56:10.048796 read(5,  <unfinished ...>
>> [pid  1445] 10:56:10.049195 read(5,  <unfinished ...>
>> [pid  1444] 10:56:10.049547 <... read resumed>"ges hugetlbfs rw,relatime,pagesi"..., 1024) = 690 <0.000403>
>> [pid  1445] 10:56:10.049722 <... read resumed>"_cls,net_prio cgroup rw,nosuid,n"..., 1024) = 1024 <0.000339>
>> [pid  1444] 10:56:10.049924 close(5 <unfinished ...>
>> [pid  1445] 10:56:10.050224 read(5,  <unfinished ...>
>> [pid  1444] 10:56:10.050550 <... close resumed>) = 0 <0.000323>
>> [pid  1445] 10:56:10.050714 <... read resumed>"ges hugetlbfs rw,relatime,pagesi"..., 1024) = 690 <0.000327>
>> [pid  1444] 10:56:10.050883 openat(AT_FDCWD, "trace.dat.cpu0", O_WRONLY|O_CREAT|O_TRUNC, 0644 <unfinished ...>
>> [pid  1445] 10:56:10.051299 close(5)    = 0 <0.016204>
>> [pid  1445] 10:56:10.067841 openat(AT_FDCWD, "trace.dat.cpu1", O_WRONLY|O_CREAT|O_TRUNC, 0644 <unfinished ...>
>> [pid  1443] 10:56:10.100729 <... write resumed>) = 0 <0.052057>
>> [pid  1443] 10:56:10.101022 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_WRONLY|O_TRUNC|O_CLOEXEC) = 6 <0.014801>
>> [pid  1443] 10:56:10.116299 write(6, "101 ", 4
> 
> The full output can be found here:
> https://www.samba.org/~metze/strace.5.12-trace-cmd-record-all-P-101-kthread-fail-01.txt
> 
> I redid it on ubuntu 21.04 with this kernel:
> https://kernel.ubuntu.com/git/ubuntu/ubuntu-hirsute.git/tag/?h=Ubuntu-5.11.0-16.17
> which is based on Linux 5.11.12
> 
> I tried it onces using of pid from a kthread and it didn't reproduce:
>> 09:10:50.719423 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_RDONLY) = 3 <0.000084>
>> 09:10:50.719605 read(3, "", 8192)       = 0 <0.000075>
>> 09:10:50.719774 close(3)                = 0 <0.000080>
> ...
>> [pid  1135] 09:10:53.468541 fcntl(6, F_GETPIPE_SZ) = 65536 <0.000009>
>> [pid  1135] 09:10:53.468589 splice(5, NULL, 7, NULL, 4096, SPLICE_F_MOVE <unfinished ...>
>> [pid  1134] 09:10:53.480165 <... write resumed>) = 0 <0.014106>
>> [pid  1134] 09:10:53.480201 close(4)    = 0 <0.000011>
>> [pid  1134] 09:10:53.480250 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_WRONLY|O_TRUNC|O_CLOEXEC) = 4 <0.000024>
>> [pid  1134] 09:10:53.480311 write(4, "7 ", 2) = 2 <0.000194>
>> [pid  1134] 09:10:53.480530 close(4)    = 0 <0.000011>
>> [pid  1134] 09:10:53.480565 openat(AT_FDCWD, "/sys/kernel/tracing/tracing_enabled", O_WRONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory) <0.000013>
>> [pid  1134] 09:10:53.480605 write(3, "1", 1) = 1 <0.000008>
>> [pid  1134] 09:10:53.480632 newfstatat(1, "", {st_mode=S_IFIFO|0600, st_size=0, ...}, AT_EMPTY_PATH) = 0 <0.000007>
>> [pid  1134] 09:10:53.480673 pidfd_open(7, 0) = 4 <0.000010>
>> [pid  1134] 09:10:53.480701 poll([{fd=4, events=POLLIN}], 1, -1
> 
> The full output can be found here:
> https://www.samba.org/~metze/strace.5.11.12-trace-cmd-record-all-P-7-kthread-nofail-02.txt
> 
> And using the pid of io_wqe_worker-0 it happened again,
> also writing the pid into /sys/kernel/tracing/set_event_pid:
> (remember 7 was the pid of the kthread):
>> 09:13:18.000315 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_RDONLY) = 3 <0.000074>
>> 09:13:18.000471 read(3, "7\n", 8192)    = 2 <0.000158>
>> 09:13:18.000703 close(3)                = 0 <0.000052>
> ...> [pid  1224] 09:13:20.671939 close(4)    = 0 <0.000084>
>> [pid  1224] 09:13:20.672106 openat(AT_FDCWD, "trace.dat.cpu0", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 4 <0.000085>
>> [pid  1224] 09:13:20.672292 openat(AT_FDCWD, "/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw", O_RDONLY) = 5 <0.000062>
>> [pid  1224] 09:13:20.672432 pipe([6, 7]) = 0 <0.000057>
>> [pid  1224] 09:13:20.672595 fcntl(6, F_GETPIPE_SZ) = 65536 <0.000051>
>> [pid  1224] 09:13:20.672728 splice(5, NULL, 7, NULL, 4096, SPLICE_F_MOVE <unfinished ...>
>> [pid  1223] 09:13:20.688172 <... write resumed>) = 0 <0.020134>
>> [pid  1223] 09:13:20.688215 close(4)    = 0 <0.000015>
>> [pid  1223] 09:13:20.688276 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_WRONLY|O_TRUNC|O_CLOEXEC) = 4 <0.027854>
>> [pid  1223] 09:13:20.716198 write(4, "1043 ", 5
> 
> The full output can be found here:
> https://www.samba.org/~metze/strace.5.11.12-trace-cmd-record-all-P-1043-io_wqe_worker-fail-03.txt
> 
> I thought it happens always if there was already a value in /sys/kernel/tracing/set_event_pid...,
> but the next time I started with pid 6 from a kthread and directly triggered it:
> 
>> 09:41:24.029860 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid", O_RDONLY) = 3 <0.000048>
>> 09:41:24.029982 read(3, "", 8192)       = 0 <0.000046>
>> 09:41:24.030101 close(3)                = 0 <0.000045>
> ...
>> [pid  1425] 09:41:26.212972 read(4, "sysfs /sys sysfs rw,nosuid,nodev"..., 1024) = 1024 <0.000077>
>> [pid  1425] 09:41:26.213128 read(4, "group/rdma cgroup rw,nosuid,node"..., 1024) = 1024 <0.000075>
>> [pid  1425] 09:41:26.213316 read(4, "ev/hugepages hugetlbfs rw,relati"..., 1024) = 1024 <0.000058>
>> [pid  1425] 09:41:26.213459 close(4)    = 0 <0.000044>
>> [pid  1425] 09:41:26.213584 openat(AT_FDCWD, "trace.dat.cpu0", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 4 <0.000229>
>> [pid  1425] 09:41:26.213895 openat(AT_FDCWD, "/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw", O_RDONLY) = 5 <0.000055>
>> [pid  1425] 09:41:26.214030 pipe([6, 7]) = 0 <0.000066>
>> [pid  1425] 09:41:26.214188 fcntl(6, F_GETPIPE_SZ) = 65536 <0.000065>
>> [pid  1425] 09:41:26.214332 splice(5, NULL, 7, NULL, 4096, SPLICE_F_MOVE
> 
> It ended here, but I think the rest ( close(4); openat("/sys/kernel/tracing/set_event_pid"); write("6 ")
> was just eaten by the delayed output of the ssh session.
> 
> The full output can be found here:
> https://www.samba.org/~metze/strace.5.11.12-trace-cmd-record-all-P-6-kthread-fail-04.txt
> 
> Does these details help already?
> 
> Thanks!
> metze
> 

