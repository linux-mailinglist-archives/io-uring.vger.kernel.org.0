Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A1E323671
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 05:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhBXEc7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 23:32:59 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:46677 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232132AbhBXEc7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 23:32:59 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8AB9E235;
        Tue, 23 Feb 2021 23:31:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Feb 2021 23:31:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=QN5ZO6PxGXwz1e7duIiOp4u24ml
        dqivtWe/hI5k7jEA=; b=frpuNgE6Emfd5uPW5VxKzkWLHoj9bjFUkLWIixa5fjy
        tlVu5Z0ovn7uE1Wqd3+7UqyzzC+RgHjtBgT9xeNm2bv9FWjjtUzRN0MHdx5qV7Fn
        ZtnpgFFjE2c203gVIn5oQN90BoUqm1HnmAZU5TcXv1N92T0wiVk5NY9hA6Nq9AWU
        E6udSF+i/QUjOhMgiIM9b3JJPAOFKpnPVP5qfNBOSKj9Zte3pGmXj7FIgFI/l2nI
        s0zrWEhMicGDa8Je6PLfd+Qk1YbIsMI3AKTGhInRqQVU0aWaHraAfEewMd+fEB9j
        Dtkps+QH65hsupQq/voselfE3WGtoNLP3nz6igSJS7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QN5ZO6
        PxGXwz1e7duIiOp4u24mldqivtWe/hI5k7jEA=; b=Z5bDmgfVXwU6LxEw8pB1MI
        0ilB0kO0ogF63ILDFe37AnyozVpL5BdRvvEgD6noayQXR94XE2d8zkr96kZZQOr+
        lVYfVlee409r3yWTgYOBcTBEKMEM9Sff1OfHsduQRos5b67CbHN3cK6xtEwhUYoN
        1b2aVG+DgDoCcUE/PmFMHlpjuoaeHAu7IWE0WDZEtSvu0s3A0RtOTls6o4yruYg+
        8lphobga3/nHJjv7CFbemxa2asKPegXdNL8aLlsaOuYAQoUnphazsjvE+N8xO9Ec
        RzijhSsnG1AGp+7fhgYt/wPE9kZlKDByoLfVkk6pNwT2i70/c4xC5CFE7ZOlT4cw
        ==
X-ME-Sender: <xms:t9Y1YD-IudMvMrVrL6a2T1ZtLrU1NRsz4H-e2S0_4cRsBEjrzEeipg>
    <xme:t9Y1YPu4cVrUUrZ6xymWuWBvPieiuwJxQh2YFpRO0AgHkkzuq6xxdUXG7GEyEmk_K
    O2sj9g7iFB1sxZ23Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeeigdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:t9Y1YBCdYdf4RELl12f4dgzcKOTcMUpp3UQuE6C9i0TfhKSepxHW7w>
    <xmx:t9Y1YPerT1clzf7fKmegKDDmz3FeOX8dZdnvFK_c-2EUTpW9DwlQzQ>
    <xmx:t9Y1YIPmY7daxjO_KG1n3qIL8S1RlqwfHT6qIac311doWWdrQpUNvg>
    <xmx:uNY1YDbwl1tZ5cImyXY293pHNkGi50_GVhj2o-MQOzJAUVx_XtUzew>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 990131080057;
        Tue, 23 Feb 2021 23:31:51 -0500 (EST)
Date:   Tue, 23 Feb 2021 20:31:49 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: io_uring_enter() returns EAGAIN after child exit in 5.12
Message-ID: <20210224043149.6tj6whjfjd6ihamz@alap3.anarazel.de>
References: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
 <db110327-99b5-f008-2729-d1c68483bff1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db110327-99b5-f008-2729-d1c68483bff1@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-02-23 20:35:09 -0700, Jens Axboe wrote:
> On 2/23/21 8:25 PM, Andres Freund wrote:
> > Hi,
> > 
> > commit 41be53e94fb04cc69fdf2f524c2a05d8069e047b (HEAD, refs/bisect/bad)
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   2021-02-13 09:11:04 -0700
> > 
> >     io_uring: kill cached requests from exiting task closing the ring
> > 
> >     Be nice and prune these upfront, in case the ring is being shared and
> >     one of the tasks is going away. This is a bit more important now that
> >     we account the allocations.
> > 
> >     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > 
> > 
> > causes EAGAIN to be returned by io_uring_enter() after a child
> > exits. The existing liburing test across-fork.c repros the issue after
> > applying the patch below.
> > 
> > Retrying the submission twice seems to make it succeed most of the
> > time...
> 
> Oh that's funky, I'll take a look.
 
It was fixed in

commit 8e5c66c485a8af3f39a8b0358e9e09f002016d92
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   2021-02-22 11:45:55 +0000

    io_uring: clear request count when freeing caches


Jens, seems like it'd make sense to apply the test case upthread into
the liburing repo. Do you want me to open a PR?

Greetings,

Andres Freund
