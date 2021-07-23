Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6663D39C5
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 13:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhGWLNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 07:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhGWLNQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 07:13:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE94C061575;
        Fri, 23 Jul 2021 04:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=A8DOOxSy9/LfdlA5+JHj9tfbXzZfOrERjQ8TcqynSQo=; b=VGlbKTjp1ZfGuXaAVZYNTj63PK
        ++fZkjlGukBBK7KGO40KI6blQydBud/PsYEsiWGEk5b4isMbkRSg4YKwgK5bFTHtbqoC5II8OLpC0
        l1a4DHrD2CP62NNdt8RHQozzi8J75DsfU9dr+SBJZ9qRLpL0f06IkbE1SYoc+6gegcgsObkFKfhca
        v/tWZIcfJJ93PFcQkX3wogGPSwkM8/MSHoOpttUea7n/yTwiGlCDi1mk1L3fMJn8nM0rxrrm1gBCO
        pNo+AqwjT3QX85AdBL/BW1QocnulbeaXeBeB3owKucUZFm2gLDMoH/hwfqbbR3YFnXSMbNJUQuCCd
        963R64e4tPVw9WKDD4xUlkOf+tBYabQfrESHC0dXtJGx+GBkj4Si5SOC+kUzPlGHnZNjhlqItGUYs
        Q9QGI5R7YWK6sXbREa6XNaMF7L1i7S4t+nhurDWlSFLyxsnQusTGTXq4ApM4rSGwUgDoe77Q1PMfc
        EmzQqoRrHjGRegpnf7ux1Gp+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m6tkQ-00075t-Mo; Fri, 23 Jul 2021 11:53:46 +0000
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
 <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
 <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
 <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
 <20210722225124.6d7d7153@rorschach.local.home>
 <d803b3a6-b8cd-afe1-4f85-e5301bcb793a@samba.org>
 <20210723072906.4f4e7bd5@gandalf.local.home>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <e3abc707-51d3-2543-f176-7641f916c53d@samba.org>
Date:   Fri, 23 Jul 2021 13:53:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723072906.4f4e7bd5@gandalf.local.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XecFp5NdMmHIT9KmRXPCup0kFFSq3kjRg"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XecFp5NdMmHIT9KmRXPCup0kFFSq3kjRg
Content-Type: multipart/mixed; boundary="GtkweevbFUOLwHdiAoLPfGWg7SlxxFO9p";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
 io-uring <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <e3abc707-51d3-2543-f176-7641f916c53d@samba.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
 <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
 <20210504093550.5719d4bd@gandalf.local.home>
 <f351bdfa-5223-e457-0396-a24ffa09d6b5@samba.org>
 <8bb757fb-a83b-0ed5-5247-8273be3925c5@samba.org>
 <90c806a0-8a2f-1257-7337-6761100217c9@samba.org>
 <4ebea8f0-58c9-e571-fd30-0ce4f6f09c70@samba.org>
 <20210722225124.6d7d7153@rorschach.local.home>
 <d803b3a6-b8cd-afe1-4f85-e5301bcb793a@samba.org>
 <20210723072906.4f4e7bd5@gandalf.local.home>
In-Reply-To: <20210723072906.4f4e7bd5@gandalf.local.home>

--GtkweevbFUOLwHdiAoLPfGWg7SlxxFO9p
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


Hi Steve,

>>> Assuming this does fix your issue, I sent out a real patch with the
>>> explanation of what happened in the change log, so that you can see w=
hy
>>> that change was your issue. =20
>>
>> Yes, it does the trick, thanks very much!
>=20
> Can I get a "Tested-by" from you?

Sure!

Can you check if the static_key_disable() and static_key_enable()
calls are correctly ordered compared to rcu_assign_pointer()
and explain why they are, as I not really understand that it's different
from tracepoint_update_call vs. rcu_assign_pointer

>> Now I can finally use:
>>
>> trace-cmd record -e all -P $(pidof io_uring-cp-forever)
>>
>> But that doesn't include the iou-wrk-* threads
>> and the '-c' option seems to only work with forking.
>=20
> Have you tried it? It should work for threads as well. It hooks to the
> sched_process_fork tracepoint, which should be triggered even when a ne=
w
> thread is created.
>=20
> Or do you mean that you want that process and all its threads too that =
are
> already running? I could probably have it try to add it via the /proc f=
ile
> system in that case.
>=20
> Can you start the task via trace-cmd?
>=20
>   trace-cmd record -e all -F -c io_uring-cp-forever ...

I think that would work, but I typically want to analyze a process
that is already running.

>> Is there a way to specify "trace *all* threads of the given pid"?
>> (Note the threads are comming and going, so it's not possible to
>> specifiy -P more than once)
>=20
> Right, although, you could append tasks manually to the set_event_pid f=
ile
> from another terminal after starting trace-cmd. Once a pid is added to =
that
> file, all children it makes will also be added. That could be a work ar=
ound
> until we have trace-cmd do it.

Sure, but it will always be racy.

With children, does new threads also count as children or only fork() chi=
ldren?

> Care to write a bugzilla report for this feature?
>=20
>   https://bugzilla.kernel.org/buglist.cgi?component=3DTrace-cmd%2FKerne=
lshark&list_id=3D1088173

I may do later...

Thanks!
metze


--GtkweevbFUOLwHdiAoLPfGWg7SlxxFO9p--

--XecFp5NdMmHIT9KmRXPCup0kFFSq3kjRg
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmD6rcUACgkQDbX1YShp
vVaVphAAt7nGq7QD51b53DN5Pgv56EtgKHiPPd4fqNC28AMDTBmivJ0l38CVIOkD
GclXBaT+qY6t+42VpuNugQTe2oPWL2vHycdr4Kz3vT0Akfunrv543c4YLjdM5FHO
eO5BVFWoa9YEsktgqwIPtmZHvvnGhfXfMP5KDUjXpg5kl5J+oTuM52qOEltADn/a
LL02M0BmL4eDlz9lkxn9B4Ba6+NGmABk9z602DLQMBZH4ReLtSjgRww2GP8YEvsw
LEPIRtuVPIKu517fA/pQBWi113DXTNHYMkVd7HBhdXZ/LKY/qU2UBeyNQxllhgTF
BSTuUUfZeMzdK+ZJR5tRgew4w2+59L66NWx0V8HyKh9sZuhGEnmpUlyFgbRfHC2+
UeyrFqstqb2vteTUsHnY7ZyIthDDu69i1K4nxf/mGAMa4JmqAZLXLTFW9QisQpew
Q4bd5+JDp1hLJfIphSmBr2ERuPF9Mw59BtCABAK4dfW7KF1lxOM/QRn2OBMkYAcx
W37xLt/QP7x41/S9E1FcU9v+LNbKIJ5nO7dDZs1FSjBm5jiv9fXWaZVV6Em9cxVN
l8sJM7NAroSlLQhJA7/3jaLhocgab/BbIteeSauwjzbhTVi/GN1AAb1A2erh5qBO
Cjnxg3W2JxnGvzbKT5YIY532brRkpeA4a+l9YHYn9XuQxVzx+IQ=
=4sJp
-----END PGP SIGNATURE-----

--XecFp5NdMmHIT9KmRXPCup0kFFSq3kjRg--
