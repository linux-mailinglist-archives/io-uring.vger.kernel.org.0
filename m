Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7197B134858
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 17:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgAHQrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 11:47:03 -0500
Received: from mr85p00im-zteg06021601.me.com ([17.58.23.187]:33692 "EHLO
        mr85p00im-zteg06021601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729379AbgAHQrD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 11:47:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1578502021;
        bh=z5vtUorkniBZ6fympcT1CYmOSOpwegQICWrvW31Fcc0=;
        h=Content-Type:From:Subject:Date:Message-Id:To;
        b=U36GkWDoU0ha82CrrSibpUBWLZi/2sxO0ccGf5SRU4gOt+i5YIQQA9pzwukSzoc6S
         Dwt+VFEJnVVOHsSET7/bA/gD+dB6n1CTicHwAmn58pMxKueY6k/z93STK8IUUc+RtP
         e/z1BZpnAV8R5xFtqcAxVTJyOlgIHDs8OvcLBFRTrTaB+YK9G60wTapHii6gqXQmKl
         Qe3A+Z+A7B2zhNi9PDisQSgJb+gkCXoFst/4Hg3EEsC3LDhHxexOihrRhJ4KBlJ37b
         X/hZdDWWdKgHaDkwuo3cslRlRCyc/bjrZ3F0pBH0J+wfXSwadmzIz7zMMszql9cK01
         sLrumIJl/3Zjw==
Received: from [10.187.227.108] (109-178-162-185.pat.ren.cosmote.net [109.178.162.185])
        by mr85p00im-zteg06021601.me.com (Postfix) with ESMTPSA id 75BA84013FC;
        Wed,  8 Jan 2020 16:47:01 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Mark Papadakis <markuspapadakis@icloud.com>
Mime-Version: 1.0 (1.0)
Subject: Re: io_uring and spurious wake-ups from eventfd
Date:   Wed, 8 Jan 2020 18:46:51 +0200
Message-Id: <02106C23-C466-4E63-B881-AF8E6BDF9235@icloud.com>
References: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <d949ea3a-bd24-e597-b230-89b7075544cc@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (17B111)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-08_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001080136
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Thus sounds perfect!

Thanks Jens

@markpapadakis

> On 8 Jan 2020, at 6:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> =EF=BB=BFOn 1/8/20 12:36 AM, Mark Papadakis wrote:
>>=20
>>=20
>>>> On 7 Jan 2020, at 10:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>=20
>>> On 1/7/20 1:26 PM, Jens Axboe wrote:
>>>> On 1/7/20 8:55 AM, Mark Papadakis wrote:
>>>>> This is perhaps an odd request, but if it=E2=80=99s trivial to impleme=
nt
>>>>> support for this described feature, it could help others like it =E2=80=
=98d
>>>>> help me (I =E2=80=98ve been experimenting with io_uring for some time n=
ow).
>>>>>=20
>>>>> Being able to register an eventfd with an io_uring context is very
>>>>> handy, if you e.g have some sort of reactor thread multiplexing I/O
>>>>> using epoll etc, where you want to be notified when there are pending
>>>>> CQEs to drain. The problem, such as it is, is that this can result in
>>>>> un-necessary/spurious wake-ups.
>>>>>=20
>>>>> If, for example, you are monitoring some sockets for EPOLLIN, and when=

>>>>> poll says you have pending bytes to read from their sockets, and said
>>>>> sockets are non-blocking, and for each some reported event you reserve=

>>>>> an SQE for preadv() to read that data and then you io_uring_enter to
>>>>> submit the SQEs, because the data is readily available, as soon as
>>>>> io_uring_enter returns, you will have your completions available -
>>>>> which you can process.  The =E2=80=9Cproblem=E2=80=9D is that poll wil=
l wake up
>>>>> immediately thereafter in the next reactor loop iteration because
>>>>> eventfd was tripped (which is reasonable but un-necessary).
>>>>>=20
>>>>> What if there was a flag for io_uring_setup() so that the eventfd
>>>>> would only be tripped for CQEs that were processed asynchronously, or,=

>>>>> if that=E2=80=99s non-trivial, only for CQEs that reference file FDs?
>>>>>=20
>>>>> That=E2=80=99d help with that spurious wake-up.
>>>>=20
>>>> One easy way to do that would be for the application to signal that it
>>>> doesn't want eventfd notifications for certain requests. Like using an
>>>> IOSQE_ flag for that. Then you could set that on the requests you submi=
t
>>>> in response to triggering an eventfd event.
>>>=20
>>=20
>>=20
>> Thanks Jens,
>>=20
>> This is great, but perhaps there is a somewhat slightly more optimal
>> way to do this.  Ideally, io_uring should trip the eventfd if there
>> are any new completions available, that haven=E2=80=99t been produced In t=
he
>> context of an io_uring_enter(). That is to say, if any SQEs can be
>> immediately served (because data is readily available in
>> Buffers/caches in the kernel), then their respective CQEs will be
>> produced in the context of that io_uring_enter() that submitted said
>> SQEs(and thus the CQEs can be processed immediately after
>> io_uring_enter() returns).  So, if any CQEs are placed in the
>> respective ring at any other time, but not during an io_uring_enter()
>> call, then it means those completions were produced asynchronously,
>> and thus the eventfd can be tripped, otherwise, there is no need to
>> trip the eventfd at all.
>>=20
>> e.g (pseudocode):
>> void produce_completion(cfq_ctx *ctx, const bool in_io_uring_enter_ctx) {=

>>        cqe_ring_push(cqe_from_ctx(ctx));
>>        if (false =3D=3D in_io_uring_enter_ctx && eventfd_registered()) {
>>                trip_iouring_eventfd();
>>        } else {
>>                // don't bother
>>        }
>> }
>=20
> I see what you're saying, so essentially only trigger eventfd
> notifications if the completions happen async. That does make a lot of
> sense, and it would be cleaner than having to flag this per request as
> well. I think we'd still need to make that opt-in as it changes the
> behavior of it.
>=20
> The best way to do that would be to add IORING_REGISTER_EVENTFD_ASYNC or
> something like that. Does the exact same thing as
> IORING_REGISTER_EVENTFD, but only triggers it if completions happen
> async.
>=20
> What do you think?
>=20
> --=20
> Jens Axboe
>=20

