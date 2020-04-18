Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D011AECA3
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgDRMxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 08:53:03 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56175 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgDRMxD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 08:53:03 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id E740B67B;
        Sat, 18 Apr 2020 08:53:01 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute7.internal (MEProxy); Sat, 18 Apr 2020 08:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        mime-version:message-id:date:from:to:cc:subject:content-type; s=
        fm2; bh=wNs5BL947XoABR7f/cRj4UEzBo/mUFzpkSo9vl8VpvQ=; b=O2rNFR8e
        Xai3JX7W5LReYNkF2rghrBiaWd1R1KCbCuXji64JQINEe3oEWjRhZQAb68fuKDCg
        JGusdSMLtLah8UKkG+PcJStHdZUucGhOLajuBI++NOIXoPCsmOzjxuZP1lKBtUxe
        Shao4UadWhsqTPnc84lnCOfUgaukbxfdAet2W7vVi07yurD2rXLoEiQzPQanCGpz
        6OrRSJpXM3tqMMySTcAVxBU0ZrKbJxi9Mhr+dHU9z82mtc1LGzAt/QhwB8NvglDy
        UmLMrBGMEDWzQRxYsh6h0KlP3gHr7V/5mVBsJBXMVVPw+FXpwNhdajVbZOYUuUj2
        FstzMkCUNiXW7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=wNs5BL947XoABR7f/cRj4UEzBo/mU
        FzpkSo9vl8VpvQ=; b=Rr9QYNruqbUlFsq5nevTMb3arZVaCz5LVGcNIm9LMtxNJ
        2ge2bg53oelQ//8c2FktKxp3DJoCmTfqxSwDZsH+9T/fqOgv4+87bpGX3nECrqU5
        3VjY6Nj518OerhTY9XvozWROW3z2rejX/NGJfs983nGOjvzGGROe41t2GWbbj1Yd
        USePiQ//oqS/0mntb7LEi/WUTDqmLT5O9W+oFWiq+8Dkh0tBXFpZOWKysDVVb4a4
        2pQSHoV3gK8/5kVK2FzPVLs9UC2ZHyuB/DSKuLVB4iAoJXdbSGOxzjpA0EEXeGkj
        M49vyUlwJgJWeIyaDw2tt3JdPbJUJPGwLLBd/bn0w==
X-ME-Sender: <xms:LfiaXvB8XQoFRRdw8z-ikAS02Qku_KU9ZMhj0YrM1rxP_QdRpZ6ZwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepofgfggfkfffhvffutgesthdtredtre
    ertdenucfhrhhomhepfdfjrdcuuggvucggrhhivghsfdcuoehhuggvvhhrihgvshesfhgr
    shhtmhgrihhlrdgtohhmqeenucffohhmrghinhepthifihhtthgvrhdrtghomhenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhuggvvhhrihgv
    shesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:LfiaXl-ZutBMTsKZOjoDsO2zs07ZzKfng8bh5xrM1Er2q1f4uTWQvw>
    <xmx:LfiaXgDrkB8mAjXc-UG2ZEw0kGYs8VPUtAVolQrwdVGLEbeMVsDN9g>
    <xmx:LfiaXvtlDl7EPzKf8dopHuwd_xj4ZgL3kzWuV-X8tSCRWBcR9kOVrQ>
    <xmx:LfiaXtT7cpK7ppxzdI-A8HPYNfnvjC_-ykYHC6SrVlxD2imTNDj5hA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 1E0AF660069; Sat, 18 Apr 2020 08:53:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-1131-g3221b37-fmstable-20200415v1
Mime-Version: 1.0
Message-Id: <08ef10c8-90f3-4777-89ab-f9245dc03466@www.fastmail.com>
Date:   Sat, 18 Apr 2020 14:49:54 +0200
From:   "H. de Vries" <hdevries@fastmail.com>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     axboe@kernel.dk
Subject: Suggestion: chain SQEs - single CQE for N chained SQEs
Content-Type: text/plain
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Following up on the discussion from here: https://twitter.com/i/status/1234135064323280897 and https://twitter.com/hielkedv/status/1250445647565729793

Using io_uring in event loops with IORING_FEAT_FAST_POLL can give a performance boost compared to epoll (https://twitter.com/hielkedv/status/1234135064323280897). However we need some way to manage 'in-flight' buffers, and IOSQE_BUFFER_SELECT is a solution for this. 

After a buffer has been used, it can be re-registered using IOSQE_BUFFER_SELECT by giving it a buffer ID (BID). We can also initially register a range of buffers, with e.g. BIDs 0-1000 . When buffer registration for this range is completed, this will result in a single CQE. 

However, because (network) events complete quite random, we cannot re-register a range of buffers. Maybe BIDs 3, 7, 39 and 420 are ready to be reused, but the rest of the buffers is still in-flight. So in each iteration of the event loop we need to re-register the buffer, which will result in one additional CQE for each event. The amount of CQEs to be handled in the event loop now becomes 2 times as much. If you're dealing with 200k requests per second, this can result in quite some performance loss.

If it would be possible to register multiple buffers by e.g. chaining multiple SQEs that would result in a single CQE, we could save many event loop iterations and increase performance of the event loop.


Regards,
Hielke de Vries
