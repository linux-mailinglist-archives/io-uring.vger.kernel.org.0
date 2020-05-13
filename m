Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035C51D14C9
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 15:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgEMN1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 09:27:21 -0400
Received: from st43p00im-ztfb10063301.me.com ([17.58.63.179]:37628 "EHLO
        st43p00im-ztfb10063301.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726001AbgEMN1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 09:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1589376438;
        bh=XfMvgAgSTAS3JAGV2pIzgGGWCeLT1fX8Hm7x5grIwDo=;
        h=Content-Type:Subject:From:Date:Message-Id:To;
        b=hTUicZEJmXZk2GIYzIhyWhiO4RJicSehF/99T7qd7AbIXmRZHWrVqvnJYMjN/7h54
         uwYNPM6nw3WL0glHo5KZrCA2ttzIvGUFSP0pHOEH2jeGsPV4zrjShSEaZygiMhOu1S
         jfSLr4bs0GK9Y9htnXUdDJnZH6JKFz3bwWxHm+hZFlAGFWjdFsgnPIQ89jkPN6EM8C
         JiUfvkJJIvt9vMiaA0rU/i4FgNqGADtGeVean2+1bMeXaKN8MtF0MJ8iccHRdJBZ/i
         DhJsVs7WyeI5MCjJ94naFs0hB31vB25lYSMgRAaCy4dxTPBr4oy587i5o7Oe/JXg7k
         67fUaREGmq83Q==
Received: from [192.168.0.101] (athedsl-298885.home.otenet.gr [85.73.215.35])
        by st43p00im-ztfb10063301.me.com (Postfix) with ESMTPSA id 2ACC1A402FF;
        Wed, 13 May 2020 13:27:18 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Any performance gains from using per thread(thread local) urings?
From:   Mark Papadakis <markuspapadakis@icloud.com>
In-Reply-To: <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
Date:   Wed, 13 May 2020 16:27:15 +0300
Cc:     "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com>
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com>
 <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com>
 <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
To:     Dmitry Sychov <dmitry.sychov@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_06:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2002250000 definitions=main-2005130120
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com> =
wrote:
>=20
> Hey Mark,
>=20
> Or we could share one SQ and one CQ between multiple threads(bound by
> the max number of CPU cores) for direct read/write access using very
> light mutex to sync.
>=20
> This also solves threads starvation issue  - thread A submits the job
> into shared SQ while thread B both collects and _processes_ the result
> from the shared CQ instead of waiting on his own unique CQ for next
> completion event.
>=20


Well, if the SQ submitted by A and its matching CQ is consumed by B, and =
A will need access to that CQ because it is tightly coupled to state it =
owns exclusively(for example), or other reasons, then you=E2=80=99d =
still need to move that CQ from B back to A, or share it somehow, which =
seems expensive-is.

It depends on what kind of roles your threads have though; I am =
personally very much against sharing state between threads unless there =
a really good reason for it.






> On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
> <markuspapadakis@icloud.com> wrote:
>>=20
>> For what it=E2=80=99s worth, I am (also) using using multiple =
=E2=80=9Creactor=E2=80=9D (i.e event driven) cores, each associated with =
one OS thread, and each reactor core manages its own io_uring =
context/queues.
>>=20
>> Even if scheduling all SQEs through a single io_uring SQ =E2=80=94 by =
e.g collecting all such SQEs in every OS thread and then somehow =
=E2=80=9Cmoving=E2=80=9D them to the one OS thread that manages the SQ =
so that it can enqueue them all -- is very cheap, you =E2=80=98d still =
need to drain the CQ from that thread and presumably process those CQEs =
in a single OS thread, which will definitely be more work than having =
each reactor/OS thread dequeue CQEs for SQEs that itself submitted.
>> You could have a single OS thread just for I/O and all other threads =
could do something else but you=E2=80=99d presumably need to serialize =
access/share state between them and the one OS thread for I/O which =
maybe a scalability bottleneck.
>>=20
>> ( if you are curious, you can read about it here =
https://medium.com/@markpapadakis/building-high-performance-services-in-20=
20-e2dea272f6f6 )
>>=20
>> If you experiment with the various possible designs though, I=E2=80=99d=
 love it if you were to share your findings.
>>=20
>> =E2=80=94
>> @markpapapdakis
>>=20
>>=20
>>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com> =
wrote:
>>>=20
>>> Hi Hielke,
>>>=20
>>>> If you want max performance, what you generally will see in =
non-blocking servers is one event loop per core/thread.
>>>> This means one ring per core/thread. Of course there is no simple =
answer to this.
>>>> See how thread-based servers work vs non-blocking servers. E.g. =
Apache vs Nginx or Tomcat vs Netty.
>>>=20
>>> I think a lot depends on the internal uring implementation. To what
>>> degree the kernel is able to handle multiple urings independently,
>>> without much congestion points(like updates of the same memory
>>> locations from multiple threads), thus taking advantage of one ring
>>> per CPU core.
>>>=20
>>> For example, if the tasks from multiple rings are later combined =
into
>>> single input kernel queue (effectively forming a congestion point) I
>>> see
>>> no reason to use exclusive ring per core in user space.
>>>=20
>>> [BTW in Windows IOCP is always one input+output queue for =
all(active) threads].
>>>=20
>>> Also we could pop out multiple completion events from a single CQ at
>>> once to spread the handling to cores-bound threads .
>>>=20
>>> I thought about one uring per core at first, but now I'am not sure -
>>> maybe the kernel devs have something to add to the discussion?
>>>=20
>>> P.S. uring is the main reason I'am switching from windows to linux =
dev
>>> for client-sever app so I want to extract the max performance =
possible
>>> out of this new exciting uring stuff. :)
>>>=20
>>> Thanks, Dmitry
>>=20

