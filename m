Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3F301931
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 03:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAXCSM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 21:18:12 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37493 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbhAXCSL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 21:18:11 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2520EF8E;
        Sat, 23 Jan 2021 21:17:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 23 Jan 2021 21:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=UpklQmUEUO/zX5MgAoQulqE9tZs
        7EOOqxGs/86z89og=; b=GV0EKv0vPpQMEDwOvUwal9LDy6Mt6QYVEuqOb4k3WaS
        2S0gnkWkWt8ENvP+wrf1mqmVUfe8ysndh5eHBBg8DaBshxKtC9j4tO4is4GzMoQc
        Hjcs/2ywKppXM8j21nFy0O302g0a30ZhyKTQCDBslKgfs2itMX6eUVXAuhJ2fOC4
        JhQzap8ia6pFQoeEDnP+8+nW1ZGL7gIMK8OpUlErpN8gwkfJ50tOIWOpHeArg+2R
        K5AjoszGn9SwYFHf2EsLovTa0JdCTkDxObgfmkN+Ik7URrP9HnomuexsC9n06SRj
        BFlFpeVTTK/8+fTtpsFbjcZn1JtlNmGHQCqhEIuJu5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UpklQm
        UEUO/zX5MgAoQulqE9tZs7EOOqxGs/86z89og=; b=FVhn7fuFxdpqFNR3osD85d
        zuIHmQcsHBlWIAV8yyESWKT4cNTphfQI89P2eDxrj3vnZNu+vpYJib4jVRIi28tw
        DdPqQjgZE/N4C0gHdqN28DX2ZLE1yW2XeV2rY2+OtLzcmK+8q2yyUDkyhL6HhytA
        Bsq8KbuBqaLw2ocOYCfOAyBQ31tiyPrlgHLCaf/KRMYeZi8V1DudjWIW0GXFKGL6
        mdVEaGZzA3jA3TH6fcXbDucYG4JVUCEaUScHWebkJ8Tq098R/+I37UCL6n0V+/dI
        h/oq/iaSep2mBMSIlPcoKl0p5U3YwsZSJGO2dbzBCEXuCoHfv4tRo9mwqM74zj8w
        ==
X-ME-Sender: <xms:tNgMYMPivXYlkcdlG4m2uiWI-n65HuqU0i0VDDKs5byMbX1mfHM-dg>
    <xme:tNgMYC_bTpY0y1_JokZwR6xJeqHGbZ-q9V_1uUIs1PPyVUjzWMOw125lID1p2lJ4k
    tw4B2mvYAtBtsdghw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:tNgMYDTlM6ETztvWtoD6NnHxWWnsVgpNOHWeLc7XRFg_QE0uZUgL2w>
    <xmx:tNgMYEu72OtuoqJhmzOgHdCT0amkvhpJDKjXGHH1lqFp3mrc72F6xg>
    <xmx:tNgMYEfl9BJ8eUBtQnPaeX43DfyYwvu0ZN9pHLMpjNsOZWWXgU4ndg>
    <xmx:tNgMYD6Oi2CNkmwPOljOl0R4l5sx7LDI3lU5329Asg38u53f9qtwAA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF26D240057;
        Sat, 23 Jan 2021 21:17:23 -0500 (EST)
Date:   Sat, 23 Jan 2021 18:17:22 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210124021722.j4v7xrn4licf2aif@alap3.anarazel.de>
References: <20210123114152.GA120281@wantstofly.org>
 <20210123235055.azmz5jm2lwyujygc@alap3.anarazel.de>
 <20210124015905.GH740243@zeniv-ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124015905.GH740243@zeniv-ca>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-01-24 01:59:05 +0000, Al Viro wrote:
> On Sat, Jan 23, 2021 at 03:50:55PM -0800, Andres Freund wrote:
> 
> > As there's only a shared lock, seems like both would end up with the
> > same ctx->pos and end up updating f_pos to the same offset (assuming the
> > same count).
> > 
> > Am I missing something?
> 
> This:
>         f = fdget_pos(fd);
>         if (!f.file)
>                 return -EBADF;
> in the callers.

Ah. Thanks for the explainer, userspace guy here ;). I hadn't realized
that fdget_pos acquired a lock around the position...

Regards,

Andres
