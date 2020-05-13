Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEA31D06F2
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 08:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgEMGIh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 02:08:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58353 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728784AbgEMGIg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 02:08:36 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E92D5C0176;
        Wed, 13 May 2020 02:08:35 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute7.internal (MEProxy); Wed, 13 May 2020 02:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to
        :subject:content-type:content-transfer-encoding; s=fm2; bh=e+/AH
        NWAEkpDEPZFqgJxIoqoURy7hxCUFbqvgryriwQ=; b=G+9mQsqyB1MDzqyfVvgtx
        N9QhexQUTUmM62yojcXJVrI+7g3jUx8rFS9Q43yOvkSkmjhHy8sY2Q0ZrGSvvML1
        ZhrMwEE55ycv1ADH8XOYTHl19kbDuZ7OWv/62Kis4YtFgC/EeOTnsYnjjAIadLq4
        5oUSnjuyv9lwKKLXVh4JunTFOc7xjP80BOM34D6VxXuZEfmkwzK+xGbae2XCxiuP
        UinmMP7AQZTJ4pAbIGRr7JWyXIqmTO/1fRL3eRKWbXH5V8UUAqbD3qZmFIqSVB0M
        buGgjBS4VteX4aI8RKzpER+Ujth05p3rH/MRs3JDAFky73rwh5srks62DUSxeZHt
        Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=e+/AHNWAEkpDEPZFqgJxIoqoURy7hxCUFbqvgryri
        wQ=; b=1PVbk1OK1+21NRab9kCXG05hF+uaUJ9lICLEiA9cypSmkOmCiRrkkFx6W
        9XiftMfwcV4BP0dgirHe/t24DmuHjWZOgoou+4OSiNb1tmbKmk7jVYI+it7Cieha
        dY1qbdlOBCuPkeF/qdS9AcSQna9eIAq9jZX4Kue4hdFTARfS+4okEaZoh9BDnFG+
        HAAyAdS5BMNvBHEH6j42UqjoW8DbvyyyHVXUnf9b+X1c+LcEogspFhcj8Xdo+hLb
        wSs7uL13BNQJzfXWPJz8IkQ2o7QfghTW009zbKAjZLCUFv1kb6LWozbY6DZ+Lmbx
        G7VS5atOpDPELoWhVGFRWpWZWAGFw==
X-ME-Sender: <xms:4467Xm4TohfXYFAcWPmMm5tn3sn85Y9-AopMLJRSTecPtdE69CTvMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedfjfdr
    ucguvgcugghrihgvshdfuceohhguvghvrhhivghssehfrghsthhmrghilhdrtghomheqne
    cuggftrfgrthhtvghrnhepheeitdehfeehteegueekfedutdefueffiefgteekiefgveef
    gfehjedtjeegteffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhephhguvghvrhhivghssehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:4467Xv411ULUHUOGQxOVaBnYJjRdnjHY3DfPfUg3Yu-tmwN37l5Dbg>
    <xmx:4467XleJ0gS6e4oXoLN9PtR6xOAnmzxN92yPXM-oTyuC0QCTVh6lvQ>
    <xmx:4467XjIQIIhr9MZsXSf02uJMqX6zFS96dhtBX32_lp8b8b2WVLNmfw>
    <xmx:4467XvU9LGMJShf8L4NzaFw8xH9XNqMQ5TuqspSbc4yeCB_HTTzdMw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4B9E566007E; Wed, 13 May 2020 02:08:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-dev0-413-g750b809-fmstable-20200507v1
Mime-Version: 1.0
Message-Id: <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com>
In-Reply-To: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
Date:   Wed, 13 May 2020 08:07:07 +0200
From:   "H. de Vries" <hdevries@fastmail.com>
To:     "Dmitry Sychov" <dmitry.sychov@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: Any performance gains from using per thread(thread local) urings?
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Dmitry,

If you want max performance, what you generally will see in non-blocking=
 servers is one event loop per core/thread. This means one ring per core=
/thread. Of course there is no simple answer to this. See how thread-bas=
ed servers work vs non-blocking servers. E.g. Apache vs Nginx or Tomcat =
vs Netty.

=E2=80=94
Hielke de Vries

On Tue, May 12, 2020, at 22:20, Dmitry Sychov wrote:
> Hello,
>=20
> I'am writing a small web + embedded database application taking
> advantage of the multicore performance of the latest AMD Epyc (up to
> 128 threads/CPU).
>=20
> Is there any performance advantage of using per thread uring setups?
> Such as every thread will own its unique sq+cq.
>=20
> My feeling is there are no gains since internally, in Linux kernel,
> the uring system is represented as a single queue pickup thread
> anyway(?) and sharing a one pair of sq+cq (through exclusive locks)
> via all threads would be enough to achieve maximum throughput.
>=20
> I want to squeeze the max performance out of uring in multi threading
> clients <-> server environment, where the max number of threads is
> always bounded by the max number of CPUs cores.
>=20
> Regards, Dmitry
>
