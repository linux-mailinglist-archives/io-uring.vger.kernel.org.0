Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C13514F756
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 10:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgBAJSn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 04:18:43 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:51241 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgBAJSn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 04:18:43 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id DBEE64E6;
        Sat,  1 Feb 2020 04:18:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 01 Feb 2020 04:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=nSRz+8plUrgOix9q1n0MF6i0ji9x/tEzSqxR6M+7kBE=; b=U7XqrMWM
        76bw0bzXcor4T4wgxahL3ysyv6/kf4TRfUxaAiDzbsSHJB1Ij5PT8aejTo8pZC0C
        BminrnZJPHb5RhZS0b8SklVb/8SbunJaEWAVINjWRu7S2NAwBXc6iNqrxf/93ngX
        hC1wbp52KqsA8dR4oeMRuZwPbjd1XM22NXETtGpeXsHY2Rsykt92WqHOt0GySjKd
        +Mz4UYWxRRkeMJeq5Fy37gQip6LKjd4jEXcjOd768lHFZ/tGZ7aVFBMXSZZI+YyO
        QX/cIH06ITHGBLb8AH1RmNzjEwDPEJ4T+8qttzh6X9LzvgxYfoJW8tZyKeP17TJX
        FA6PtL38FgxvvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=nSRz+8plUrgOix9q1n0MF6i0ji9x/
        tEzSqxR6M+7kBE=; b=FOtus0t01lCRyT0KAtxZ/rIqYoGMhIlFyhBoxmy1u8V89
        wM2R2iToj9J3/ZzjX+cTf2VLVqDxMhkzjhRYtS3JBkaoivI/DKrXnmp8TljJw7I6
        Z+2i+00awtk47tDaU25iPHUSqwSl96VTbiH9/3Nivnk5OApG5gDwf2HZiFEbfPgN
        Rw4swPV6GQjahYTdQbv7fzw2xl461LTULzmEpBp9zTZwx1/wLMobWs2yqZpiMWpc
        4aOepjev8n8U4N5g0EHi6kkESOq84S5Wrl0IQko04GznS5bkyC2MaU67E6zQDUik
        32VqunQedBcb68xgq/QHfpKSQ/PsZJmnRqNok7dFQ==
X-ME-Sender: <xms:cUI1XpPwwqUTzqWhO_90pmqsr4ZtUoTgzyS2BbDX_Z0PwW4w1TCmLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgedvgddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheptehnughrvghsucfh
    rhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppedvuddvrd
    ejiedrvdehfedrudejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:cUI1XjvDetQgCA49zpklLhKel8qHPPsbhrLssCB81_pt40yJkEcAPw>
    <xmx:cUI1XtSRIz-_fVVpwUCB1hJ2-rpPRDUHxrP5svUsdb8j22CWmi5u5g>
    <xmx:cUI1XttJbiB9UQ-jVcm6fBMOtraj8_rEDBrc_kMF-17isgK52-6oJw>
    <xmx:cUI1Xt4-MGjmcAAJvIG1F0ZiMU4ZseyzAdj4MYoZJsOBkWTAzpNjPQ>
Received: from intern.anarazel.de (unknown [212.76.253.171])
        by mail.messagingengine.com (Postfix) with ESMTPA id F01453060B66;
        Sat,  1 Feb 2020 04:18:40 -0500 (EST)
Date:   Sat, 1 Feb 2020 01:18:39 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: What does IOSQE_IO_[HARD]LINK actually mean?
Message-ID: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Reading the manpage from liburing I read:
       IOSQE_IO_LINK
              When  this  flag is specified, it forms a link with the next SQE in the submission ring. That next SQE
              will not be started before this one completes.  This, in effect, forms a chain of SQEs, which  can  be
              arbitrarily  long. The tail of the chain is denoted by the first SQE that does not have this flag set.
              This flag has no effect on previous SQE submissions, nor does it impact SQEs that are outside  of  the
              chain  tail.  This  means  that multiple chains can be executing in parallel, or chains and individual
              SQEs. Only members inside the chain are serialized. Available since 5.3.

       IOSQE_IO_HARDLINK
              Like IOSQE_IO_LINK, but it doesn't sever regardless of the completion result.  Note that the link will
              still sever if we fail submitting the parent request, hard links are only resilient in the presence of
              completion results for requests that did submit correctly.  IOSQE_IO_HARDLINK  implies  IOSQE_IO_LINK.
              Available since 5.5.

I can make some sense out of that description of IOSQE_IO_LINK without
looking at kernel code. But I don't think it's possible to understand
what happens when an earlier chain member fails, and what denotes an
error.  IOSQE_IO_HARDLINK's description kind of implies that
IOSQE_IO_LINK will not start the next request if there was a failure,
but doesn't define failure either.

Looks like it's defined in a somewhat adhoc manner. For file read/write
subsequent requests are failed if they are a short read/write. But
e.g. for sendmsg that looks not to be the case.

Perhaps it'd make sense to reject use of IOSQE_IO_LINK outside ops where
it's meaningful?

Or maybe I'm just missing something.

Greetings,

Andres Freund
