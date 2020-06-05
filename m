Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186611F02F2
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 00:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgFEWgi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 18:36:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53735 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728013AbgFEWgi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 18:36:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 514CC5C01ED;
        Fri,  5 Jun 2020 18:36:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 05 Jun 2020 18:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=oh/OAYaFEQ3HxW5W1KPC5V+cDOo
        ZKlRbij/OZk0Nz/0=; b=bvdXoLAgqqupdoLaD502Zxzh/3CRStByByu8XkRr6yD
        HHBQQpXUYelxiWYkDIbTcSqYKkIGYoUzpy7lQ63zYqN5x056z8fgVHoGHL4UnlmP
        hMTizZWLkXcGKWj5qVnwQlwMy1mQqyzvIDDFc4D6bBPPFSqQC3WOzB7Ty8tDzFCE
        z0/x5Mkb/1qofThsxI3MdHg+XPxAcI/WAkl+0rQTE5NoLcOBJI9ux6h2eEUAtp9j
        D829PUV+BCMsF5q6qRuqX1DcCBZUyBqinaHgDzo+Bef6D2hapzjRmNFD5fM/sIbb
        NvM4Xdk44/icj35oW6gtfW0bgteefzCx7pldF8NXjXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oh/OAY
        aFEQ3HxW5W1KPC5V+cDOoZKlRbij/OZk0Nz/0=; b=LDnvWhsHCwf8xPC7r0ocZ4
        UvRX4HsdXQK54QO9T2vta/i20Cwh91HiipypI15vX4B8wZaWpx8lnww6aJJQ75Tm
        Xy2jHNyJzzmqcKEv0HV3Vmiv/r1a8gfZSWHd0jaMqnpb8WL6mMlu9j3TG2yZAbjS
        eEidO7r4jKN2Cy7E4l8P8vNdBjws7VB8W5ofhES/LP5C2V1g7P0DG1dhlwjQDwkD
        6gEOpe4la1TEyjLKHaO0pq4XyG9Hj6rH+cn7DJMJS5b+mxe/oPDFDyYCYU/y+bDh
        ADR0uD/1pXf3c90DZ2BkIkmrn1gHenDGQsOX7iIflE5I7q7z2RfVqCwAYY0HHnvg
        ==
X-ME-Sender: <xms:9MjaXo2rX9V5EH3JyH6PjEj9uC3IY62mPrrWfKie8cOl4hTUNosVIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:9MjaXjHVzoHjkL5ZJZ1rQP3-fqPCLgcAoXMcbWME682G2-USSu1eQA>
    <xmx:9MjaXg4kJxejztwxvefvM5qba-PkKhwnylWCHF369mbGYKtJjUA3Tg>
    <xmx:9MjaXh1a2qutynR4YcU0-BqItLm-V_Gl5rZt9YQMG0lJwXordEju2Q>
    <xmx:9cjaXgRDUjFsEQG74RKUNS6W5QPWJdcMm1mT21iKBsvgv4RfYdSODw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A3683060F09;
        Fri,  5 Jun 2020 18:36:36 -0400 (EDT)
Date:   Fri, 5 Jun 2020 15:36:35 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200605223635.6xesl7u4lxszvico@alap3.anarazel.de>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
 <6eeff14f-befc-a5cc-08da-cb77f811fbdf@kernel.dk>
 <20200605202028.d57nklzpeolukni7@alap3.anarazel.de>
 <20200605203613.ogfilu2edcsfpme4@alap3.anarazel.de>
 <75bfe993-008d-71ce-7637-369f130bd984@kernel.dk>
 <3539a454-5321-0bdc-b59c-06f60cc64b56@kernel.dk>
 <34aadc75-5b8a-331e-e149-45e1547b543e@kernel.dk>
 <20200605223044.tnh7qsox7zg5uk53@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605223044.tnh7qsox7zg5uk53@alap3.anarazel.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-05 15:30:44 -0700, Andres Freund wrote:
> On 2020-06-05 15:21:34 -0600, Jens Axboe wrote:
> > >> I can reproduce this, and I see what it is. I'll send out a patch soonish.
> > > 
> > > Thinko, can you try with this on top?
> > 
> > Sorry that was incomplete, please use this one!
> 
> That seems to fix it! Yay.
> 
> 
> Bulk buffered reads somehow don't quite seem to be performing that well
> though, looking into it. Could be on the pg side too.

While looking into that, I played with setting
/sys/<dev>/queue/read_ahead_kb to 0 and noticed that seems to result in
all/most IO done in workers. Is that to be expected?

Greetings,

Andres Freund
