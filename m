Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7B3D38CC
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 12:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhGWJyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 05:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhGWJyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 05:54:44 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED05BC061575;
        Fri, 23 Jul 2021 03:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=tbZlms1TCx6VmMIUWJxHV+Q2K2LvL/57mEioSuhHS6w=; b=LYX8HSmpXBtZa02zGL+uCYxLv2
        5pHdj7pNdth7rwvDGWWkVCP6z2bdXGzxDrd+r9FLKd6Tlj2KrDQCKQXZDVAPsc5ODtCEoHeAWERdA
        P7TUDzKoaWJwQJniC/3TBHM1xmtwFnD9FitNZURPW3+DgNpFZxxycqxpSt6lsckIxq8gFZytBEjck
        IxbRCtrLIrbRPqV994njRu4lVKiUoGSm+S8A2zG5KDJVcrlvad/hnDC17+C7JbGyWVtQDforj0upD
        gQQOAiO+w+Dd53uSjVCQh1IVYcHXnQrWxjus76N/8VKRZmA5BN7WVDzmrMBDuFMujCvPLCIB8Khxm
        7UzThTOvwbDde6TtSAGI7CZMQZULGzepFlCofboYo67xmmz8g2Hr6zVQ6rDC8pL6/mTJpUEeY+vd/
        BqlH0X5lNU964Q0u/ivk7Suzw4BmErVb/RqJkgBlj/GUNlrxliqmYeSxe3ippGwufGJlk5dHxfuCl
        4kEWw9Za1poaGl7cidBLm86T;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m6sWQ-0006Pa-FU; Fri, 23 Jul 2021 10:35:14 +0000
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
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: sched_waking vs. set_event_pid crash (Re: Tracing busy
 processes/threads freezes/stalls the whole machine)
Message-ID: <d803b3a6-b8cd-afe1-4f85-e5301bcb793a@samba.org>
Date:   Fri, 23 Jul 2021 12:35:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722225124.6d7d7153@rorschach.local.home>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0gsJwh5wf7fqJ7eLhnNbEdAgItjjP5iMM"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0gsJwh5wf7fqJ7eLhnNbEdAgItjjP5iMM
Content-Type: multipart/mixed; boundary="gnPVLGDxnkRtOujpNlOksNSWum1leTELl";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
 io-uring <io-uring@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <d803b3a6-b8cd-afe1-4f85-e5301bcb793a@samba.org>
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
In-Reply-To: <20210722225124.6d7d7153@rorschach.local.home>

--gnPVLGDxnkRtOujpNlOksNSWum1leTELl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


Hi Steve,
>> After some days of training:
>> https://training.linuxfoundation.org/training/linux-kernel-debugging-a=
nd-security/
>> I was able to get much closer to the problem :-)
>=20
> Well, knowing what to look for was not going to be easy.
>
> And I'm sure you were shocked to see what I posted as a fix ;-)

Not really, such problems typically just have one line fixes :-)

> Assuming this does fix your issue, I sent out a real patch with the
> explanation of what happened in the change log, so that you can see why=

> that change was your issue.

Yes, it does the trick, thanks very much!

>> In order to reproduce it and get reliable kexec crash dumps,
>> I needed to give the VM at least 3 cores.
>
> Yes, it did require having this run on multiple CPUs to have a race
> condition trigger, and two cores would have been hard to hit it. I ran
> it on 8 cores and it triggered rather easily.

I mean I was able to trigger the problem with 2 cores, but then
the machine was completely stuck, without triggering the kexec reboot
to get the crash dump. I don't understand why as the additional cpu
is not really involved at all..

Any idea why kexec could be so unreliable?
(even with 3 or 6 cpus it sometimes just didn't trigger)

>> While running './io-uring_cp-forever link-cp.c file' (from:
>> https://github.com/metze-samba/liburing/commits/io_uring-cp-forever )
>> in one window, the following simple sequence triggered the problem in =
most cases:
>>
>> echo 1 > /sys/kernel/tracing/events/sched/sched_waking/enable
>> echo 1 > /sys/kernel/tracing/set_event_pid
>=20
> All it took was something busy that did a lot of wakeups while setting
> the set_event_pid, to be able to hit the race easily. As I stated, I
> triggered it with running hackbench instead of the io-uring code. In
> fact, this bug had nothing to do with io-uring, and you were only
> triggering it because you were making enough of a load on the system to=

> make the race happen often.

Yes, it was just the example that made it most reliable to trigger for me=
=2E

>> pid_list =3D rcu_dereference_raw(tr->filtered_pids);
>=20
> That "tr" comes from the trace_event_file that is passed in by the
> "data" field of the callback. Hence, this callback got the data field
> of the event_filter_pid_sched_wakeup_probe_pre() callback that is
> called before all events when the set_event_pid file is set. That
> means, the "tr" being dereferened was not the "tr" you were looking for=
=2E

Yes, that's what I assumed, but didn't find the reason for.

>>
>> It seems it got inlined within trace_event_buffer_reserve()
>>
>> There strangest things I found so far is this:
>>
>> crash> sym global_trace =20
>> ffffffffbcdb7e80 (d) global_trace
>> crash> list ftrace_trace_arrays =20
>> ffffffffbcdb7e70
>> ffffffffbcdb7e80
>>
>> trace_array has size 7672, but ffffffffbcdb7e70 is only 16 bytes away =
from
>> ffffffffbcdb7e80.
>=20
> ftrace_trace_arrays is a list_head, and I doubt you created any
> instances, thus the list head has only one instance, and that is
> global_trace. Hence, it points to global_trace and itself. It just so
> happens that a list_head is 16 bytes.

Ah, that explains a lot:

crash> struct list_head -o ftrace_trace_arrays
struct list_head {
  [ffffffffbcdb7e70] struct list_head *next;
  [ffffffffbcdb7e78] struct list_head *prev;
}
SIZE: 16
crash> list  ftrace_trace_arrays
ffffffffbcdb7e70
ffffffffbcdb7e80

I guess this is what I want:

crash> list -H ftrace_trace_arrays
ffffffffbcdb7e80

>> Also this:
>>
>> crash> struct trace_array.events -o global_trace =20
>> struct trace_array {
>>   [ffffffffbcdb9be0] struct list_head events;
>> }
>> crash> list -s trace_event_file.tr -o trace_event_file.list ffffffffbc=
db9be0 =20
>> ffffffffbcdb9be0
>>   tr =3D 0xffffffffbcdb7b20
>> ffff8ccb45cdfb00
>>   tr =3D 0xffffffffbcdb7e80
>> ffff8ccb45cdf580
>>   tr =3D 0xffffffffbcdb7e80
>> ffff8ccb45cdfe18
>>   tr =3D 0xffffffffbcdb7e80
>> ...
>>   tr =3D 0xffffffffbcdb7e80
>>
>> The first one 0xffffffffbcdb7b20 is only 864 bytes away from 0xfffffff=
fbcdb7e80
>=20
> I'm thinking it is confused by hitting the ftrace_trace_arrays
> list_head itself.

Yes, I needed the -H here too:

list -s trace_event_file.tr -o trace_event_file.list -H ffffffffbcdb9be0


>> It would be really great if you (or anyone else on the lists) could ha=
ve a closer look
>> in order to get the problem fixed :-)
>=20
> Once I triggered it and started looking at what was happening, it
> didn't take me to long to figure out where the culprit was.

Great!

>>
>> I've learned a lot this week and tried hard to find the problem myself=
,
>> but I have to move back to other work for now.
>>
>=20
> I'm glad you learned a lot. There's a lot of complex code in there, and=

> its getting more complex, as you can see with the static_calls.
>=20
> This is because tracing tries hard to avoid the heisenbug effect. You
> know, you see a bug, turn on tracing, and then that bug goes away!
>=20
> Thus it pulls out all the tricks it can to be as least intrusive on the=

> system as it can be. And that causes things to get complex really quick=
=2E

I'll have a look, I may need something similar for my smbdirect socket dr=
iver
in future.

> Cheers, and thanks for keeping up on this bug!

Thanks for fixing the bug!

Now I can finally use:

trace-cmd record -e all -P $(pidof io_uring-cp-forever)

But that doesn't include the iou-wrk-* threads
and the '-c' option seems to only work with forking.

Is there a way to specify "trace *all* threads of the given pid"?
(Note the threads are comming and going, so it's not possible to
specifiy -P more than once)

Thanks!
metze


--gnPVLGDxnkRtOujpNlOksNSWum1leTELl--

--0gsJwh5wf7fqJ7eLhnNbEdAgItjjP5iMM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmD6m10ACgkQDbX1YShp
vVa6OBAAiwX7KSToGS8ZSD21N+2Um8U2ugMo3WRSUBfWQnI2pDeWsTkRcIapJMGV
NzwXDMhHURbSQTcz5l8ldJhvTvAHHU9x3rpntkopvPb33SoF1wg8XRViXMnddOGS
LZf4NNyAsVJ8UTagYCA7shE3YrZTOV22dCwtE2kD3bH5hqAh3nMEDG5Eb4mFRkwS
YkfIHSmENUAfgEk5u8WiVHEf9z+ENjJfgiWUYT6i51yQhUkA2YpStLTk2D/Pj4Qg
2WRpxv7M6R7clgtVgRnUg3rXB8EQKeP3DKDbWRZbDwPg9RUFNmR1tpF28wuzAeVH
ciOLSeu09h/WSGWQnt10kyvafD2NXHAzQdXmuPQgVsKXiY2hyOu5Pz3R64cIIdVi
bsG2BmzckSJg/PjEzlF7T7x1nYPCaYX+elcazI53X11wTGZrvmBVJHqVA8ea8zBr
pCGCMSzhRxXDIPxxR7uSgSNK0AhWk7tH08RxI75oI/18nj8QO3uqgFRHDZ4Ehs4Z
5y6GebpJCR0H5ILiy5yFE7x7p7UIjUUZZ0AF3tTirqfJlmkBoK28NqbDw1Pha8Xd
Ak2+JWN1glM2AJyyau021DUkqmOdBx9nrCTYKe4DwWrXlCRVjKvAaUk37ejSxNXP
/eKRJv22FpTTOY90gMmYLrKmhW3ivpQbUHUlpkf4NWy5jVQxDiQ=
=c1g/
-----END PGP SIGNATURE-----

--0gsJwh5wf7fqJ7eLhnNbEdAgItjjP5iMM--
