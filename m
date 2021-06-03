Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B6839A9C2
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFCSIA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 14:08:00 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48499 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhFCSIA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 14:08:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 937CC5C0072;
        Thu,  3 Jun 2021 14:06:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 03 Jun 2021 14:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=L7JL5l0QHtqSsOPix17Y5ib8Syw
        C0opDRoDXdkot+QY=; b=fnJjmEBz2x+tbWb1S1R9JTR5zOjX6A02txQWKMzz7gL
        kmdrh+hUUZKNMNExbJF5KlmSLzlUy3UhgUVkB7HaIZ2GsowHTUyE8dYF99CyUc0C
        b0KeFg+HmDt7yq3ADcvYn+uzva+E2aW9YhUgklFjTLVVAklOo5duuT1xZu+0wjyW
        EtnzOuUwyX9KzdbGZyPURi3pke2y5K9p8wmpvegCiymO26C78OQ/byzS+XD8uQkD
        bnqguVTejqpF1gooU0Nj4FENRd0FStEWLp2MdU73qq/DWqiC5zcOlM2XGnnjRWGV
        NZv/OHTeCB4QV6A9DrBjb6q47xiAzatkPCqTYCEW+kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=L7JL5l
        0QHtqSsOPix17Y5ib8SywC0opDRoDXdkot+QY=; b=HXkckYBehCeHod1L6gETOT
        rNR82hjv9NHeB1BYmLpKA7CzP3Z6W8qqwD6fm51OLKFjiEavyd7Vdx43t59YZb+V
        SY4uZmN4VVDTkLZ3oRiZsAuyMkqepa0/033eLcJ46Br/MbnKtkfCBweiJxxZsRVC
        gOmNkcXykBHrOEP0DRd0A3SIAv6x/wupk8/pxNAk7kul3YYRQFcE2mXXi8Jgow75
        Zoy8NK4a7EEnaSGEi3zaRHmRXD5nxW9wy1fUiVal+8tQz324onnEluPcQTSJkg++
        e6FFo8idEKyWpd1mBa6YwtxT5shx/z7vKWty2vSJv/OHYU0/un4wE+Nwc2Ekp7fw
        ==
X-ME-Sender: <xms:Fhq5YNHuXLPzQ6bYXvS-3_Zw8PqDAOTgPGklvwxU1g5Gwh6hXa7lRA>
    <xme:Fhq5YCWRw4vo7yfXTnNCBHsYqO0Y7BkD_pYnY9PpBCOxsb1C4H-1ZXo8CWxpzWAm6
    O_JldZ0t9RyhlHyEg>
X-ME-Received: <xmr:Fhq5YPJiKBL8DOEVoP_Wjhp65OcaMaqMYkbmCJ5Hw2BVKNOaGUDaBG47OcDQuBNWtoaUQlvinaM0sjnIPPw6RruRz7ZMbw9amQDMSmJHJxUou0oCMJu2iG8bmwWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeff
    hfeuffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:Fhq5YDH5ElxUR4veE4hNWbal5ZUjZi5vXSaP8AAKrpHmpI1o5-QVAw>
    <xmx:Fhq5YDXkZbMVDaW8HN6ljMZZ4FnY3o28snWBbZ4f9rutZWE9O8ol5A>
    <xmx:Fhq5YONkLMXMwX6gMfxe0CQLYY6456nbVhBSLVmNaVz_RF4PP_mKMA>
    <xmx:Fhq5YAhjUwwMcC6_jbouEwP1SqlODGs-DNv03QWOqJzSj3B9TX3YWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Jun 2021 14:06:13 -0400 (EDT)
Date:   Thu, 3 Jun 2021 11:06:12 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Memory uninitialized after "io_uring: keep table of pointers to
 ubufs"
Message-ID: <20210603180612.uchkn5qqa3j7rpgd@alap3.anarazel.de>
References: <20210529003350.m3bqhb3rnug7yby7@alap3.anarazel.de>
 <d2c5b250-5a0f-5de5-061f-38257216389d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2c5b250-5a0f-5de5-061f-38257216389d@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-05-29 12:03:12 +0100, Pavel Begunkov wrote:
> On 5/29/21 1:33 AM, Andres Freund wrote:
> > Hi,
> > 
> > I started to see buffer registration randomly failing with ENOMEM on
> > 5.13. Registering buffer or two often succeeds, but more than that
> > rarely. Running the same program as root succeeds - but the user has a high
> > rlimit.
> > 
> > The issue is that io_sqe_buffer_register() doesn't initialize
> > imu. io_buffer_account_pin() does imu->acct_pages++, before calling
> > io_account_mem(ctx, imu->acct_pages);
> > 
> > Which means that a random amount of memory is being accounted for. On the first
> > few allocations this sometimes fails to fail because the memory is zero, but
> > after a bit of reuse...
> 
> Makes sense, thanks for digging in. I've just sent a patch, would
> be great if you can test it or send your own.

Sorry for the slow response, I'm off this week. I did just get around to
test and unsurprisingly: The patch does fix the issue.

Greetings,

Andres Freund
