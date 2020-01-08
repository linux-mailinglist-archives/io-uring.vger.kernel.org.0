Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9D7133C5C
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 08:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgAHHf4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 02:35:56 -0500
Received: from mr85p00im-hyfv06011301.me.com ([17.58.23.184]:59471 "EHLO
        mr85p00im-hyfv06011301.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726079AbgAHHf4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 02:35:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1578468955;
        bh=axUoYV03pbbCz9Brs/TNqVX9DN3pU2x9JSZtMGqAnMc=;
        h=Content-Type:Subject:From:Date:Message-Id:To;
        b=VgmbrXoDK8I3Xzo9omGC09OPozoR18hCmx2d/uC+jgbK39GpIHsRK6rWeZPwdebq9
         JlVS9zE7dGoOqTCR9CwngFzRAtOVQSAXLDr5mW2ZZM1/zuEW43ywdeHtH2s/OrseB0
         +dJWBk9lWVEbuorTSsRiqudW6ntaxS1DHsHUb1gVVRdOjpl2xpGIoT4Gmrk8ro7Obe
         Cf7JHN03WdN20hnnpal5Gtfwhp2hV3C0sJQV+JnYGhAVXxb+1jku0L1KSJgwY0j+sQ
         lC1ygkBXbLv513KGJKfU65mf8oEXq0XR1fVJ95LxMn9vg+prC2DfFSlTWnn6QQYDvl
         WtqM6R/PxlvUA==
Received: from dhcp.her (louloudi.phaistosnetworks.gr [139.91.200.222])
        by mr85p00im-hyfv06011301.me.com (Postfix) with ESMTPSA id 89CB158124C;
        Wed,  8 Jan 2020 07:35:54 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: io_uring and spurious wake-ups from eventfd
From:   Mark Papadakis <markuspapadakis@icloud.com>
In-Reply-To: <60360091-ffce-fc8b-50d5-1a20fecaf047@kernel.dk>
Date:   Wed, 8 Jan 2020 09:36:17 +0200
Cc:     io-uring@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4DED8D2F-8F0B-46FB-800D-FEC3F2A5B553@icloud.com>
References: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
 <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk>
 <60360091-ffce-fc8b-50d5-1a20fecaf047@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3601.0.10)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001080065
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On 7 Jan 2020, at 10:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 1/7/20 1:26 PM, Jens Axboe wrote:
>> On 1/7/20 8:55 AM, Mark Papadakis wrote:
>>> This is perhaps an odd request, but if it=E2=80=99s trivial to =
implement
>>> support for this described feature, it could help others like it =
=E2=80=98d
>>> help me (I =E2=80=98ve been experimenting with io_uring for some =
time now).
>>>=20
>>> Being able to register an eventfd with an io_uring context is very
>>> handy, if you e.g have some sort of reactor thread multiplexing I/O
>>> using epoll etc, where you want to be notified when there are =
pending
>>> CQEs to drain. The problem, such as it is, is that this can result =
in
>>> un-necessary/spurious wake-ups.
>>>=20
>>> If, for example, you are monitoring some sockets for EPOLLIN, and =
when
>>> poll says you have pending bytes to read from their sockets, and =
said
>>> sockets are non-blocking, and for each some reported event you =
reserve
>>> an SQE for preadv() to read that data and then you io_uring_enter to
>>> submit the SQEs, because the data is readily available, as soon as
>>> io_uring_enter returns, you will have your completions available -
>>> which you can process.  The =E2=80=9Cproblem=E2=80=9D is that poll =
will wake up
>>> immediately thereafter in the next reactor loop iteration because
>>> eventfd was tripped (which is reasonable but un-necessary).
>>>=20
>>> What if there was a flag for io_uring_setup() so that the eventfd
>>> would only be tripped for CQEs that were processed asynchronously, =
or,
>>> if that=E2=80=99s non-trivial, only for CQEs that reference file =
FDs?
>>>=20
>>> That=E2=80=99d help with that spurious wake-up.
>>=20
>> One easy way to do that would be for the application to signal that =
it
>> doesn't want eventfd notifications for certain requests. Like using =
an
>> IOSQE_ flag for that. Then you could set that on the requests you =
submit
>> in response to triggering an eventfd event.
>=20


Thanks Jens,

This is great, but perhaps there is a somewhat slightly more optimal way =
to do this.
Ideally, io_uring should trip the eventfd if there are any new =
completions available, that haven=E2=80=99t been produced
In the context of an io_uring_enter(). That is to say, if any SQEs can =
be immediately served (because data is readily available in
Buffers/caches in the kernel), then their respective CQEs will be =
produced in the context of that io_uring_enter() that submitted said =
SQEs(and thus the CQEs can be processed immediately after =
io_uring_enter() returns).=20
So, if any CQEs are placed in the respective ring at any other time, but =
not during an io_uring_enter() call, then it means those completions =
were produced asynchronously, and thus the eventfd can be tripped, =
otherwise, there is no need to trip the eventfd at all.

e.g (pseudocode):
void produce_completion(cfq_ctx *ctx, const bool in_io_uring_enter_ctx) =
{
        cqe_ring_push(cqe_from_ctx(ctx));
        if (false =3D=3D in_io_uring_enter_ctx && eventfd_registered()) =
{
                trip_iouring_eventfd();
        } else {
                // don't bother
        }
}

@markpapadakis=
