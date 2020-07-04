Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2AE214226
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 02:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgGDAAw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 20:00:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36149 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgGDAAw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 20:00:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 240FC5C0118;
        Fri,  3 Jul 2020 20:00:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 03 Jul 2020 20:00:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm2; bh=CqVW6ltkdjCYIXgcj2uu/xggHG1Ej9kL2J2uG8J38/g=; b=TiCd57uU
        038kFkaN7pS693Ra5Osj/WDdKnEJgDlR3oIMeUI9n8NQlutclyDJNXeaW+FlCIl0
        CD+BpGVBwxUT9hJZMx3lyfl6gcVrI5aN79lZPGtUdbeLZTFU4j04e73A2GrRKqH9
        kPtblBQdUXzmFEq/aLNOj6z5Gw1cCJ+O/82uaIBTG8Nv0iJEl0+rrbRo8/Nbit8d
        DnMr6yKLABdWUI8lAsO5x8mAOzr0JSFYZq54x7sPVuc4sElWwiTiLgvOldatIpKe
        j+boH/irK68MlY/PsYQJ0SCDVHxzAeUQb5y80LUzCI+/U45FZkWTV7zCkVZNUC+s
        XAOAv28j+/ReQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=CqVW6ltkdjCYIXgcj2uu/xggHG1Ej
        9kL2J2uG8J38/g=; b=AkVK6866lJVJKJvbiyMIhqJrTe6TIaDGnAxSwkHIOXWqs
        Ztrhd0m9cqivgUUYys/Y5uumhHX+GYNBuLcQAfcQcklZ3GADrBaa/jaOMBx9ui2J
        vQTM9eQfXch9ErBEL3WpTairNuD/g/gO8NJfWOrGi5sTrKXpHN1u9c8/7Qu/kRZ5
        9ex6oiDhPlf4KxFTNg2sQrumJorx/AR/ohCK8SQpj5lWQPZVV4n2a8aA18B19jge
        jvZ7YFhMicKbrCCxdEJwN6AQRqM4llxgnpoRt8Kc6Cz0IImetKn8wiC7l1m/vRtL
        fkty3LCez4CL+Kd8prGHJHEKgrAZHKrYP6V8L4xcA==
X-ME-Sender: <xms:ssb_XvpPfgt68xPXR_rEc0-Fz2W0KIIVIzWTwpmI1T8sZZjDv4jhoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdejgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheptehnughrvghsucfh
    rhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrthhtvg
    hrnhepiedvieelgeeuuedtfeduhfefteehhfevvdeljeetgfeugfdtledtudetvdehkeff
    necukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:ssb_XprFEC-D4SZlfqa8juElT-rkVet90UbeNLUbfgu8ocAxRAtxAg>
    <xmx:ssb_XsPWBMmEBjLhU8uOj__jzew_ehxqutG0J--TktNabKTIhUEXPg>
    <xmx:ssb_Xi4Pqkqo_gtRo6HbbEyvB02lsY3jXsAOSAsLg_jsZah7BTarIA>
    <xmx:s8b_XgEAZ1BPDKUaKgUS8wrqEssDhpYv8dMP4TlmFXVg60-6dcJB0g>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACE883060060;
        Fri,  3 Jul 2020 20:00:50 -0400 (EDT)
Date:   Fri, 3 Jul 2020 17:00:49 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: signals not reliably interrupting io_uring_enter anymore
Message-ID: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I haven't yet fully analyzed the problem, but after updating to
cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres does
not work reliably anymore.

The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
interrupted by signals anymore. The signal handler executes, but
afterwards the syscall is restarted. Previously io_uring_enter reliably
returned EINTR in that case.

Currently postgres relies on signals interrupting io_uring_enter(). We
probably can find a way to not do so, but it'd not be entirely trivial.

I suspect the issue is

commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag: io_uring-5.8-2020-07-01, linux-block/io_uring-5.8)
Author: Jens Axboe <axboe@kernel.dk>
Date:   2020-06-30 12:39:05 -0600

    io_uring: use signal based task_work running

as that appears to have changed the error returned by
io_uring_enter(GETEVENTS) after having been interrupted by a signal from
EINTR to ERESTARTSYS.


I'll check to make sure that the issue doesn't exist before the above
commit.


Greetings,

Andres Freund
