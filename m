Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAC73CE81B
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352418AbhGSQhv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 12:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355427AbhGSQgS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 12:36:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BFAC06E446;
        Mon, 19 Jul 2021 09:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:Cc:To:From;
        bh=rJxL8MTI/TqefSHGGEIXwzaL3H4VbwZdFzDSmJozjFc=; b=KkiecDeD5o9jZUxdSngc5d3xhp
        Bejjus/wYOrpp46Zx21y4EDAyN+M1y1jDnqpaXF6fKD9D2cTvIV1fTh6GeKTlOZOZMchG5p2l6uXp
        +rtKpke/67twZsW4TN6OXbQJgvhb2Kj2VFBNAV3A7Jmq+saPv+oEn+GYfgazFXllofUfMLNY0zp7a
        nYOwAZbnB79bItWn9OwMeL8sULV7EacRxbCzxMNJvYFgV06B1cMIKPkhNhdUqcG/sZHlpvK3gd/cF
        L21tjKx/3uB1gx+hP+zkni3vLXLGD6DWyDG7jE/PHDWszN5wnZrwzJRLHPhBZj9baAY+L4jLXYcPv
        gqgHc+qLDouXkghc97MRDThQqhnn7GtylxBk1UehXAkpE6HcFdeYWlIwrsWlPo/fwN4coT1ZWjY3q
        NaCjjnoangBYA4pRjp7zPzWTOuvaL8ZPvNYVC+CSz0uC5W3hNHT5GUJ878HJ2DAaX9YkA9xvf1dgm
        O5afkWhv82l5Yw5OaaXY7zto;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m5Wjn-00030z-6B; Mon, 19 Jul 2021 17:07:27 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
 <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
Message-ID: <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
Date:   Mon, 19 Jul 2021 19:07:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uOJZEblnc5AF4Wx90O1IvhIdsH78Qsp2t"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uOJZEblnc5AF4Wx90O1IvhIdsH78Qsp2t
Content-Type: multipart/mixed; boundary="C4HtY7lNBftOFyUVifL0MlyBSBMccTnvR";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
 io-uring <io-uring@vger.kernel.org>
Message-ID: <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
 <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
In-Reply-To: <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>

--C4HtY7lNBftOFyUVifL0MlyBSBMccTnvR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Steve,
> did these details help in any ways?

Ping :-)

Any change you can reproduce the problem?
Any pointers how to debug this problem?

Thanks!
metze

> Thanks!
>=20
> Am 05.05.21 um 11:50 schrieb Stefan Metzmacher:
> ...
>>>
>>> Perhaps you could try something like this:
>>>
>>>  # trace-cmd list -s |
>>>     while read e ; do
>>>       echo "testing $e";
>>>       trace-cmd record -P 7 -e $e sleep 1;
>>>     done
>>>
>>> Which will enable each system at a time, and see if we can pin point =
what
>>> is causing the lock up. Narrow it down to a tracing system.
>>
>> I wasn't able to reproduce it.
>>
>> With a 5.12 kernel and ubuntu 20.04 amd64 userspace I was able
>> to produce the following strace output (in the 2nd try), like this:
>>
>> # ssh root@172.31.9.166 strace -f -ttT trace-cmd record -e all -P 101 =
2>&1 | tee out
>>
>> 101 is the pid of a kthread while my './io-uring_cp-forever link-cp.c =
file' runs
>> on '172.31.9.166'. See https://github.com/metze-samba/liburing/commits=
/io_uring-cp-forever
>> pid 1375 is the pid of 'iou-wrk-1373'.
>>
>> Maybe it's related to writing the pid into /sys/kernel/tracing/set_eve=
nt_pid
>> as it ends like this:
>>> 10:56:07.493869 stat("/sys/kernel/tracing/set_event_pid", {st_mode=3D=
S_IFREG|0644, st_size=3D0, ...}) =3D 0 <0.000222>
>>> 10:56:07.494500 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid",=
 O_RDONLY) =3D 3 <0.000134>
>>> 10:56:07.494934 read(3, "1375\n", 8192) =3D 5 <0.000433>
>>> 10:56:07.495708 close(3)                =3D 0 <0.000121>
>> ...> [pid  1443] 10:56:10.045293 openat(AT_FDCWD, "/sys/kernel/tracing=
/set_ftrace_pid", O_WRONLY|O_TRUNC|O_CLOEXEC <unfinished ...>
>>> [pid  1444] 10:56:10.045650 <... read resumed>"sysfs /sys sysfs rw,no=
suid,nodev"..., 1024) =3D 1024 <0.000948>
>>> [pid  1443] 10:56:10.045821 <... openat resumed>) =3D 5 <0.000359>
>>> [pid  1445] 10:56:10.046000 <... fstat resumed>{st_mode=3DS_IFREG|044=
4, st_size=3D0, ...}) =3D 0 <0.000873>
>>> [pid  1443] 10:56:10.046174 write(5, "101 ", 4 <unfinished ...>
>>> [pid  1444] 10:56:10.046674 read(5,  <unfinished ...>
>>> [pid  1443] 10:56:10.047007 <... write resumed>) =3D 4 <0.000475>
>>> [pid  1445] 10:56:10.047188 read(5,  <unfinished ...>
>>> [pid  1443] 10:56:10.047498 write(5, " ", 1 <unfinished ...>
>>> [pid  1444] 10:56:10.048343 <... read resumed>"_cls,net_prio cgroup r=
w,nosuid,n"..., 1024) =3D 1024 <0.001312>
>>> [pid  1445] 10:56:10.048578 <... read resumed>"sysfs /sys sysfs rw,no=
suid,nodev"..., 1024) =3D 1024 <0.001224>
>>> [pid  1444] 10:56:10.048796 read(5,  <unfinished ...>
>>> [pid  1445] 10:56:10.049195 read(5,  <unfinished ...>
>>> [pid  1444] 10:56:10.049547 <... read resumed>"ges hugetlbfs rw,relat=
ime,pagesi"..., 1024) =3D 690 <0.000403>
>>> [pid  1445] 10:56:10.049722 <... read resumed>"_cls,net_prio cgroup r=
w,nosuid,n"..., 1024) =3D 1024 <0.000339>
>>> [pid  1444] 10:56:10.049924 close(5 <unfinished ...>
>>> [pid  1445] 10:56:10.050224 read(5,  <unfinished ...>
>>> [pid  1444] 10:56:10.050550 <... close resumed>) =3D 0 <0.000323>
>>> [pid  1445] 10:56:10.050714 <... read resumed>"ges hugetlbfs rw,relat=
ime,pagesi"..., 1024) =3D 690 <0.000327>
>>> [pid  1444] 10:56:10.050883 openat(AT_FDCWD, "trace.dat.cpu0", O_WRON=
LY|O_CREAT|O_TRUNC, 0644 <unfinished ...>
>>> [pid  1445] 10:56:10.051299 close(5)    =3D 0 <0.016204>
>>> [pid  1445] 10:56:10.067841 openat(AT_FDCWD, "trace.dat.cpu1", O_WRON=
LY|O_CREAT|O_TRUNC, 0644 <unfinished ...>
>>> [pid  1443] 10:56:10.100729 <... write resumed>) =3D 0 <0.052057>
>>> [pid  1443] 10:56:10.101022 openat(AT_FDCWD, "/sys/kernel/tracing/set=
_event_pid", O_WRONLY|O_TRUNC|O_CLOEXEC) =3D 6 <0.014801>
>>> [pid  1443] 10:56:10.116299 write(6, "101 ", 4
>>
>> The full output can be found here:
>> https://www.samba.org/~metze/strace.5.12-trace-cmd-record-all-P-101-kt=
hread-fail-01.txt
>>
>> I redid it on ubuntu 21.04 with this kernel:
>> https://kernel.ubuntu.com/git/ubuntu/ubuntu-hirsute.git/tag/?h=3DUbunt=
u-5.11.0-16.17
>> which is based on Linux 5.11.12
>>
>> I tried it onces using of pid from a kthread and it didn't reproduce:
>>> 09:10:50.719423 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid",=
 O_RDONLY) =3D 3 <0.000084>
>>> 09:10:50.719605 read(3, "", 8192)       =3D 0 <0.000075>
>>> 09:10:50.719774 close(3)                =3D 0 <0.000080>
>> ...
>>> [pid  1135] 09:10:53.468541 fcntl(6, F_GETPIPE_SZ) =3D 65536 <0.00000=
9>
>>> [pid  1135] 09:10:53.468589 splice(5, NULL, 7, NULL, 4096, SPLICE_F_M=
OVE <unfinished ...>
>>> [pid  1134] 09:10:53.480165 <... write resumed>) =3D 0 <0.014106>
>>> [pid  1134] 09:10:53.480201 close(4)    =3D 0 <0.000011>
>>> [pid  1134] 09:10:53.480250 openat(AT_FDCWD, "/sys/kernel/tracing/set=
_event_pid", O_WRONLY|O_TRUNC|O_CLOEXEC) =3D 4 <0.000024>
>>> [pid  1134] 09:10:53.480311 write(4, "7 ", 2) =3D 2 <0.000194>
>>> [pid  1134] 09:10:53.480530 close(4)    =3D 0 <0.000011>
>>> [pid  1134] 09:10:53.480565 openat(AT_FDCWD, "/sys/kernel/tracing/tra=
cing_enabled", O_WRONLY|O_CLOEXEC) =3D -1 ENOENT (No such file or directo=
ry) <0.000013>
>>> [pid  1134] 09:10:53.480605 write(3, "1", 1) =3D 1 <0.000008>
>>> [pid  1134] 09:10:53.480632 newfstatat(1, "", {st_mode=3DS_IFIFO|0600=
, st_size=3D0, ...}, AT_EMPTY_PATH) =3D 0 <0.000007>
>>> [pid  1134] 09:10:53.480673 pidfd_open(7, 0) =3D 4 <0.000010>
>>> [pid  1134] 09:10:53.480701 poll([{fd=3D4, events=3DPOLLIN}], 1, -1
>>
>> The full output can be found here:
>> https://www.samba.org/~metze/strace.5.11.12-trace-cmd-record-all-P-7-k=
thread-nofail-02.txt
>>
>> And using the pid of io_wqe_worker-0 it happened again,
>> also writing the pid into /sys/kernel/tracing/set_event_pid:
>> (remember 7 was the pid of the kthread):
>>> 09:13:18.000315 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid",=
 O_RDONLY) =3D 3 <0.000074>
>>> 09:13:18.000471 read(3, "7\n", 8192)    =3D 2 <0.000158>
>>> 09:13:18.000703 close(3)                =3D 0 <0.000052>
>> ...> [pid  1224] 09:13:20.671939 close(4)    =3D 0 <0.000084>
>>> [pid  1224] 09:13:20.672106 openat(AT_FDCWD, "trace.dat.cpu0", O_WRON=
LY|O_CREAT|O_TRUNC, 0644) =3D 4 <0.000085>
>>> [pid  1224] 09:13:20.672292 openat(AT_FDCWD, "/sys/kernel/tracing/per=
_cpu/cpu0/trace_pipe_raw", O_RDONLY) =3D 5 <0.000062>
>>> [pid  1224] 09:13:20.672432 pipe([6, 7]) =3D 0 <0.000057>
>>> [pid  1224] 09:13:20.672595 fcntl(6, F_GETPIPE_SZ) =3D 65536 <0.00005=
1>
>>> [pid  1224] 09:13:20.672728 splice(5, NULL, 7, NULL, 4096, SPLICE_F_M=
OVE <unfinished ...>
>>> [pid  1223] 09:13:20.688172 <... write resumed>) =3D 0 <0.020134>
>>> [pid  1223] 09:13:20.688215 close(4)    =3D 0 <0.000015>
>>> [pid  1223] 09:13:20.688276 openat(AT_FDCWD, "/sys/kernel/tracing/set=
_event_pid", O_WRONLY|O_TRUNC|O_CLOEXEC) =3D 4 <0.027854>
>>> [pid  1223] 09:13:20.716198 write(4, "1043 ", 5
>>
>> The full output can be found here:
>> https://www.samba.org/~metze/strace.5.11.12-trace-cmd-record-all-P-104=
3-io_wqe_worker-fail-03.txt
>>
>> I thought it happens always if there was already a value in /sys/kerne=
l/tracing/set_event_pid...,
>> but the next time I started with pid 6 from a kthread and directly tri=
ggered it:
>>
>>> 09:41:24.029860 openat(AT_FDCWD, "/sys/kernel/tracing/set_event_pid",=
 O_RDONLY) =3D 3 <0.000048>
>>> 09:41:24.029982 read(3, "", 8192)       =3D 0 <0.000046>
>>> 09:41:24.030101 close(3)                =3D 0 <0.000045>
>> ...
>>> [pid  1425] 09:41:26.212972 read(4, "sysfs /sys sysfs rw,nosuid,nodev=
"..., 1024) =3D 1024 <0.000077>
>>> [pid  1425] 09:41:26.213128 read(4, "group/rdma cgroup rw,nosuid,node=
"..., 1024) =3D 1024 <0.000075>
>>> [pid  1425] 09:41:26.213316 read(4, "ev/hugepages hugetlbfs rw,relati=
"..., 1024) =3D 1024 <0.000058>
>>> [pid  1425] 09:41:26.213459 close(4)    =3D 0 <0.000044>
>>> [pid  1425] 09:41:26.213584 openat(AT_FDCWD, "trace.dat.cpu0", O_WRON=
LY|O_CREAT|O_TRUNC, 0644) =3D 4 <0.000229>
>>> [pid  1425] 09:41:26.213895 openat(AT_FDCWD, "/sys/kernel/tracing/per=
_cpu/cpu0/trace_pipe_raw", O_RDONLY) =3D 5 <0.000055>
>>> [pid  1425] 09:41:26.214030 pipe([6, 7]) =3D 0 <0.000066>
>>> [pid  1425] 09:41:26.214188 fcntl(6, F_GETPIPE_SZ) =3D 65536 <0.00006=
5>
>>> [pid  1425] 09:41:26.214332 splice(5, NULL, 7, NULL, 4096, SPLICE_F_M=
OVE
>>
>> It ended here, but I think the rest ( close(4); openat("/sys/kernel/tr=
acing/set_event_pid"); write("6 ")
>> was just eaten by the delayed output of the ssh session.
>>
>> The full output can be found here:
>> https://www.samba.org/~metze/strace.5.11.12-trace-cmd-record-all-P-6-k=
thread-fail-04.txt
>>
>> Does these details help already?
>>
>> Thanks!
>> metze
>>
>=20



--C4HtY7lNBftOFyUVifL0MlyBSBMccTnvR--

--uOJZEblnc5AF4Wx90O1IvhIdsH78Qsp2t
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmD1sUYACgkQDbX1YShp
vVavZA//cY71680DfazFL2enjNwkDAXNctCceHhL1XEbeSLM9YliKrcqxe72M5TU
u/LxcF3JNlldYNLmg0Bcdf8bybyHlknSJuT4ao+P4xwi43jPdm+T6mtaHSciMubo
cY+Dld1xa+TW7HpBZ2g7kuqnlwkd4TON7pzjQHXcLiPf3OXGIsQ3uKbCmHl9gBvJ
5ZVNr2bcEaxqAjdGqakGR4BCbZjbw2QJTYduv70ye3JepBFc8h3wVyawdEsRYaO+
crtG1mD752dUitmy7a3HJsz8PZAon2RENDAyN0GSu5R0UxwAjKCAdCrlsOzV/3/9
v+Y8EDLym+8nP0aKuLPJq1kPVh6m+PqyP/6LjsdoL6ShfkLpCpFH91atm5x/w1Pq
X8PsDG54mk3eYXPDBK7iZICG/AJvtMoy4GANlOVYQBEzNcOeeZxGAgKBcuaWu/TV
aGk/KVUI2MRqcjZH1CQRL8woXuGDvt5yz5JaiC9LB/zFmdFhQKQ0bNzasJvcHfgf
Zs59xu09KBXwVkgLV1F2mOSInSEk0Zh77meMinIAL1V54uVn6sJ/b12b0t0g1Fo9
5g2J0Yhrn8eAsFYMZwS8L9ps8427mfjJMuZLZ/G5Bcbx07yILyQx2WUmpNcSpGf1
YN0UT/GpuuHkOJRTchgGy5HZ9EkZtEqawSfBrQB2Qk3YCdbyTjc=
=nIBP
-----END PGP SIGNATURE-----

--uOJZEblnc5AF4Wx90O1IvhIdsH78Qsp2t--
