Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A716AC38
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgBXQxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:53:38 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:42081 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbgBXQxh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:53:37 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id ABC6A568;
        Mon, 24 Feb 2020 11:53:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 24 Feb 2020 11:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Xr/c/vHrr4VK8KSSj/Rm7wjHomF
        n51JEvyFzaH4Jsh4=; b=Bxlywup4+GAm1jPtXJmjZ5ayXvpXrphmMKZI884iYX3
        dIHcXRFtz5AgRrS1aM0W/tDQU//vV70ZkSXEFux+fVkti2Vf10BCdyKog7nfGOfK
        G6YzpGvwIx49wg675ZE2GzajY2uu/i81SD/1TajFraH/PhxfGqqJx0VTo/G24MpQ
        MaQlI05L4pasOXDZfFZ6su6uNY8Gm0S/1IkjJdqSJ2VP4gNNuUBMh3Kve5xEjkv0
        girRwbpv+YM4JbhbT/VJyx1VO83kbS3H/BRsOd3ZpirB2QPEebHKNp4m4Lk+Eaki
        ecLU0I9/v/kHTtWliNMjI4xc/pdNC4zkRBhBCuJe8sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xr/c/v
        Hrr4VK8KSSj/Rm7wjHomFn51JEvyFzaH4Jsh4=; b=kuTaUdQbbNeTPMGvkHlB4P
        1UgdkEQwXe2YL0fjzAmL09+unyuBhAUt2r0cYaP9FleOG2ERGrvCLzTWd7jXDIRD
        LwFeM9LZHla/NjTCukozquuIYfutJmKAMenNRHmNC08xR4mkLCEKPySln11kqj98
        E6GAASvR4b+b1iwmzhLYDIgL4Pa3YH95KfDdRHXFH5B3BXppo21KHYCbicdpAZgb
        ky25cFRLmc8sTW4X8cvUgjaKwfWC14Nd9lJnC4MagUY/P/KsF52eNFmAQ1RKaE8y
        3Ax8VzXAheHg2t6FKNmFsPt/u6M1c0HLWSuTQ14U5WLwgjzu3AUS3e16Lz+mg04g
        ==
X-ME-Sender: <xms:j_9TXlzHhQUNKRXYs8v1dC9lq4uua29yHHF1MbxUXDvOHgb-TRRt0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrledtgdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeeije
    drudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:j_9TXuxsU1eGQaa1usubxu9WEgByJnV3c5NovwDb3WIL3H5LMUHjzg>
    <xmx:j_9TXjmVpGZvb-xMDeDIx0Bync1LWvqbtiqpRjoCjk88doqkz4lFww>
    <xmx:j_9TXvEJLv-uUcEzjBt_juhVNvjRjqgYK4qwN0RH38caTHJCGH5VqQ>
    <xmx:kP9TXuMlFvMoRBRqhehXKS4dKWSL-4y43Uhvv5XeeU9y7uwnYKt1jw>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE8473280062;
        Mon, 24 Feb 2020 11:53:35 -0500 (EST)
Date:   Mon, 24 Feb 2020 08:53:34 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <20200224165334.tvz5itodcizpfkmw@alap3.anarazel.de>
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-24 08:40:16 -0700, Jens Axboe wrote:
> Agree that the first patch looks fine, though I don't quite see why
> you want to pass in opcode as a separate argument as it's always
> req->opcode. Seeing it separate makes me a bit nervous, thinking that
> someone is reading it again from the sqe, or maybe not passing in
> the right opcode for the given request. So that seems fragile and it
> should go away.

Without extracting it into an argument the compiler can't know that
io_kiocb->opcode doesn't change between the two switches - and therefore
is unable to merge the switches.

To my knowledge there's no easy and general way to avoid that in C,
unfortunately. const pointers etc aren't generally a workaround, even
they were applicable here - due to the potential for other pointers
existing, the compiler can't assume values don't change.  With
sufficient annotations of pointers with restrict, pure, etc. one can get
it there sometimes.

Another possibility is having a const copy of the struct on the stack,
because then the compiler often is able to deduce that the value
changing would be undefined behaviour.


I'm not sure that means it's worth going for the separate argument - I
was doing that mostly to address your concern about the duplicated
switch cost.

Greetings,

Andres Freund
