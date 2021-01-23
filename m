Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0122A301900
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 00:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbhAWX53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 18:57:29 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34823 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbhAWX52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 18:57:28 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3970910CD;
        Sat, 23 Jan 2021 18:56:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 23 Jan 2021 18:56:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=UT6tfV6bEEz8r3S/32kxem/nbH3
        RlnEic0UnIicmAIY=; b=CkjvFhOTlqH4gUoVCA//mwrg1k/RmnP11lgnDldasaf
        HAx1ZCdUN/Y9lmJ3kr9NxVoI22gZP0Yd+lgNE46PtWQ7hnVHJr4hpPDP4bWkVxL3
        dOcNlHsbpRP11nxLOsZA+9E63GjEyuN8QHD/F8ercW0RX9gr2dpcY33NGJ7ICk33
        KP2KAYEOczgalzNY4/DLZVYYOShG/kgZgpdWQ3MxAg14ck0auf4OlJYZFZp+8lYy
        4txnuSmwDnIyJ3zjgfRziCXF98yTLuw3LTM7/P/pALqlkYt6ie2TGR4cLzLB18Ro
        ihazt6+OQ1CPMiarMY9jDkdwt+Vyvw/k2jM43ONJ8Fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UT6tfV
        6bEEz8r3S/32kxem/nbH3RlnEic0UnIicmAIY=; b=pGLrZKoXlp5t0/GGK4dRO5
        duY3+5oiRagEx66YJqNPg2n/4SChndGfcKrSNOa+3bmnAF1tU6DBM/imBwQj7149
        X31f8al0eNupLusHa48ABwNJTBCxaUYCv0T/4Udy7xQVuApMu10xPdccgKarepLn
        jJOr+tUx2IfVMB89QzxxwrAH5ET/kEJb/8QnOg2pKXQ7e8Duds7WbOuNZsous1aP
        WpjsSxmFN+IzSuIvoW6Gckgivz3YOusZIMv0+WfhNpY54pyb/U+1N0H0PYG504vx
        EkNbACpI9uLJmuRjqy/fOtPqt4c3z+zAyClEHTZs2IVSG0ut+I3aULcxoN/WctfA
        ==
X-ME-Sender: <xms:pbcMYOxDeUpMna95IOQ1D64xPwVOlKzIcwvSZ1oLMo3Nnl3jNMOWfA>
    <xme:pbcMYKQPLjbOR2sccG-d6iC4JJRcVREEo9F56ln3FZJ6kET90LxIwSA1dMrVNe-Kw
    MD9lbQzCClIY0831Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:pbcMYAVZOg5qY80aORyA0WCemviFt9BTx_vBSq6IXQ9cqAyDeRbC1g>
    <xmx:pbcMYEjRUSZkjfDonPMVqShWRW6C6J4sDSC_1kXDwB5pkIY5kDOnRA>
    <xmx:pbcMYACQgG2I-6Md9ZO8_ObyOc1sIzEtdAKGSWvf9thlJSSbpShH-A>
    <xmx:pbcMYDPKyg39UfdkBSorrmMh9vwQs7R3Fzx9QgyvtIl26NL7PIyIww>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BE26108005B;
        Sat, 23 Jan 2021 18:56:21 -0500 (EST)
Date:   Sat, 23 Jan 2021 15:56:20 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: add support for IORING_OP_GETDENTS64
Message-ID: <20210123235620.ue4n3p5wbuafs35b@alap3.anarazel.de>
References: <20210123114152.GA120281@wantstofly.org>
 <20210123235055.azmz5jm2lwyujygc@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123235055.azmz5jm2lwyujygc@alap3.anarazel.de>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2021-01-23 15:50:55 -0800, Andres Freund wrote:
> It's also not clear to me that right now you'd necessarily get correct
> results if multiple IORING_OP_GETDENTS64 for the same fd get processed
> in different workers.  Looking at iterate_dir(), it looks to me that the
> locking around the file position would end up being insufficient on
> filesystems that implement iterate_shared?
> [...]
> As there's only a shared lock, seems like both would end up with the
> same ctx->pos and end up updating f_pos to the same offset (assuming the
> same count).
> 
> Am I missing something?

A minimal and brute force approach to this would be to use
io_op_def.hash_reg_file, but brrr, that doesn't seem like a great way
forward.

Greetings,

Andres Freund
