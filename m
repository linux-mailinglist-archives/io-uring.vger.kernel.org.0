Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349481AF31F
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 20:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgDRSTP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 14:19:15 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47965 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725824AbgDRSTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 14:19:15 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 0780C5C00D4;
        Sat, 18 Apr 2020 14:19:14 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute7.internal (MEProxy); Sat, 18 Apr 2020 14:19:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type:content-transfer-encoding; s=fm2; bh=VtsLA
        ZYUyfcBaXYjFlEj1dPwFTtei1tGcP9cncva88Y=; b=PqiRQsbXQr993ADXbbBqD
        lVsaekSeB/UYZ7VLAq4DIR9Q0v6DGFcTVC7ZnhOtpHAtX8KBT2z9I95w83e5UUcm
        36cIFz5WAg3vdKMJr42P6UveOug1hbig34WjYO/wO7sUoJr5ypJRb6nrQz8n0HeP
        cRqfCcYnPBOd5oj8LwkDWKkNW743VXB8PVlDcTLZboZgp0obNCaIhDSAouOIyHt5
        HTJz0sup1xSo7r9LLo7bYN+TTO4w1L/caC32SUrSW3auRC5JT+gdPi8hQvjYsEGl
        UEJjmWwpuf3k716+UAlq71RZVZbxz+Z5pD0WhrH1KN7DcWBPFZ616fIr6Jjx852f
        g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=VtsLAZYUyfcBaXYjFlEj1dPwFTtei1tGcP9cncva8
        8Y=; b=EaJ+3SS4vWevZ9d/i1qz+9Rr5/Xjgsk38Npu20TX6iVISFsUYiKaS02Ej
        eBNlkGR2k4WqnUaXJ8COYrK5vnTacKhvYCa8FTfq4YnW0j9UeVfv3qMEQDTCSy36
        yH0P2Jl9I/tbq2IWpBrp9K33jROcDYAfG6FbkxSpbvxPu0msRq3UCm0nzM1bMGXZ
        1a7+YkF/Pny/Mny5mthox4Sb5SWRM44iRr6QVvOuRlXhAfYLx2RD6czNFqSKS+5o
        hJQD65v/2xcQM1N28dNVN5yoEXKZmlQ4nQTv49JOpwt+5JzvXPnzDGGbH77uIm6W
        41DW2OhcMENaTXMKc+nh8bykG8z+Q==
X-ME-Sender: <xms:oUSbXmCd8KqnvPiG3A5eD64k1KFj03Kt7xWWfES-9gm290BoPgrdQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfgjfhffhffvufgtgfesth
    hqredtreerjeenucfhrhhomhepfdfjrdcuuggvucggrhhivghsfdcuoehhuggvvhhrihgv
    shesfhgrshhtmhgrihhlrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpd
    htfihithhtvghrrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhephhguvghvrhhivghssehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:oUSbXmi5WSOB3pa_2nRqw9DtD9deO-h_doHKBDJM362aEMQL5LQGrg>
    <xmx:oUSbXkbKZ1n4qsN8Sh28bBs4K61EsIfXVFhiZfuemXhq_XVjX58tzg>
    <xmx:oUSbXnkU5j9aSj824L7KD83O8ZHFSctfZYRnpN19r8RuEQDUvRy3kQ>
    <xmx:okSbXmiOugCRPSdgJo-le-PuqGV6CwtTPhTAQq6OZrar0y0u0rNKvQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 748CA660069; Sat, 18 Apr 2020 14:19:13 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-1131-g3221b37-fmstable-20200415v1
Mime-Version: 1.0
Message-Id: <44ccd560-e00a-47d9-a728-89380f2ba2e3@www.fastmail.com>
In-Reply-To: <50567b86-fa5d-b8a7-863d-978420b3e0f8@gmail.com>
References: <08ef10c8-90f3-4777-89ab-f9245dc03466@www.fastmail.com>
 <50567b86-fa5d-b8a7-863d-978420b3e0f8@gmail.com>
Date:   Sat, 18 Apr 2020 20:18:53 +0200
From:   "H. de Vries" <hdevries@fastmail.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     axboe@kernel.dk
Subject: Re: Suggestion: chain SQEs - single CQE for N chained SQEs
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

Yes, [1] is what I mean. In an event loop every CQE is handled by a new =
iteration in the loop, this is the "expensive" part. Less CQEs, less ite=
rations. It is nice to see possible kernel performance gains [2] as well=
, but I suggested this specifically in the case of event loops.

Can you elaborate on =E2=80=9Chandling links from the user side=E2=80=9D=
?=20

[2]=20
https://lore.kernel.org/io-uring/56a18348-2949-e9da-b036-600b5bb4dad2@ke=
rnel.dk/#t

--
Hielke de Vries


On Sat, Apr 18, 2020, at 15:50, Pavel Begunkov wrote:
> On 4/18/2020 3:49 PM, H. de Vries wrote:
> > Hi,
> >=20
> > Following up on the discussion from here: https://twitter.com/i/stat=
us/1234135064323280897 and https://twitter.com/hielkedv/status/125044564=
7565729793
> >=20
> > Using io_uring in event loops with IORING_FEAT_FAST_POLL can give a =
performance boost compared to epoll (https://twitter.com/hielkedv/status=
/1234135064323280897). However we need some way to manage 'in-flight' bu=
ffers, and IOSQE_BUFFER_SELECT is a solution for this.=20
> >=20
> > After a buffer has been used, it can be re-registered using IOSQE_BU=
FFER_SELECT by giving it a buffer ID (BID). We can also initially regist=
er a range of buffers, with e.g. BIDs 0-1000 . When buffer registration =
for this range is completed, this will result in a single CQE.=20
> >=20
> > However, because (network) events complete quite random, we cannot r=
e-register a range of buffers. Maybe BIDs 3, 7, 39 and 420 are ready to =
be reused, but the rest of the buffers is still in-flight. So in each it=
eration of the event loop we need to re-register the buffer, which will =
result in one additional CQE for each event. The amount of CQEs to be ha=
ndled in the event loop now becomes 2 times as much. If you're dealing w=
ith 200k requests per second, this can result in quite some performance =
loss.
> >=20
> > If it would be possible to register multiple buffers by e.g. chainin=
g multiple SQEs that would result in a single CQE, we could save many ev=
ent loop iterations and increase performance of the event loop.
>=20
> I've played with the idea before [1], it always returns only one CQE p=
er
> link, (for the last request on success, or for a failed one otherwise)=
.
> Looks like what you're suggesting. Is that so? As for me, it's just
> simpler to deal with links on the user side.
>=20
> It's actually in my TODO for 5.8, but depends on some changes for
> sequences/drains/timeouts, that hopefully we'll push soon. We just nee=
d
> to be careful to e.g. not lose CQEs with BIDs for IOSQE_BUFFER_SELECT
> requests.
>=20
> [1]
> https://lore.kernel.org/io-uring/1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@=
gmail.com/
>=20
> --=20
> Pavel Begunkov
>
