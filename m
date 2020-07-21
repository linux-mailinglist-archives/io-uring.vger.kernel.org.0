Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626F7228949
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 21:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgGUThZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 15:37:25 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:40337 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729928AbgGUThZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jul 2020 15:37:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 155FD9B0;
        Tue, 21 Jul 2020 15:37:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 21 Jul 2020 15:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=icIwlvDl4Gvx94nRgzuNJ7LN+Tj
        VSkpAmRu1t8+EeeY=; b=Bw99MbNqyZqay4tM2z9/aDBM0qFvh35RV68RTg8mn5k
        2g9PJy3zIROvOtKwcfpx4Ug0a39RkkQEdBMgRQ29ak7HffRFzLQbGZs3llsIm+x1
        +WPWYn9xW9OjiIIk+JEmv9cvDon92SoNpu9lJr6SYhkEF+cZnqge5/82MsTWwWUm
        ldCYKE1Qg+Um7Qu5SOFaoDmy3fLSfSDGtX3hKqjJEy06nYnAwje0yi4t68XiidAN
        v3GQpVnC+ekjzyq2XJIGJM5RGu1SKmrIsjheNgMolabaAj/QguqpQHdDl9G7VwWH
        Bw458FOB04OSsOD2jcF/wB/msT8VelWpJQLnoly45jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=icIwlv
        Dl4Gvx94nRgzuNJ7LN+TjVSkpAmRu1t8+EeeY=; b=bRj6i59i+X454YtANmNaul
        moYMfIDn1u6Jqo7O007f8kWfkKycXChC7t61am68O0p/znROIan9jXlRakgMHyab
        A51bbvQtsRXFX7MmiVAEogaG6DAQmXJHA2L7bBZJQSOGgjYICMbCGBR1lMKi8tou
        B22VNaITJWovAIeoBng2+HsJ5ZGEWpqg0IM+LcXHapIamJWGlDzwcCuU9MZZP0d1
        CtuGv1ljj8feb1/mtuI4/WzmzeDv9XTW/IvkwrlvlXVVAQY0bd0qfrm8SoVl9kSj
        LsysC09l2icWQvlwbAzJHDHQTOorqyIfoUElo0TNmmtq1zszzRuVhZm8hcbaHa0Q
        ==
X-ME-Sender: <xms:8EMXX-uUvNY8xfdZw3o1BjkkauE4FWmW3LDPDI2Z8kIzx9Pr-c2Xzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeejgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrfgrth
    htvghrnhepudekhfekleeugeevteehleffffejgeelueduleeffeeutdelffeujeffhfeu
    ffdunecukfhppeeijedrudeitddrvddujedrvdehtdenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdgu
    vg
X-ME-Proxy: <xmx:8EMXXzemsDYLr_QYi0lP6K9OHyGpv21v_qGYF5A2jqVXY8TUehKdHw>
    <xmx:8EMXX5yHoOLfeEsfhxEP87Mb_7FplwhsllFmMElIxMLj6E5a-0UuYg>
    <xmx:8EMXX5NR40gvVM4KYggt7NbkS_BlktuVy1SsupbrLNu-BJHnTgECAw>
    <xmx:8kMXXweuVEht6Lg8z_xmf7UB_I3jbGf0a7wZuycwTnJThC_1m_lh7CirKtA>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id B81EE3280059;
        Tue, 21 Jul 2020 15:37:20 -0400 (EDT)
Date:   Tue, 21 Jul 2020 12:37:19 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: strace of io_uring events?
Message-ID: <20200721193719.zx72xkbjvoake2po@alap3.anarazel.de>
References: <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com>
 <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com>
 <202007151511.2AA7718@keescook>
 <20200716131404.bnzsaarooumrp3kx@steredhat>
 <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan>
 <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk>
 <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-07-21 10:23:22 -0700, Andy Lutomirski wrote:
> Andres, how final is your Postgres branch?

Not final at all. Some of the constraints like needing to submit/receive
completions to/from multiple processes are pretty immovable though.


> I'm wondering if we could get away with requiring a special flag when
> creating an io_uring to indicate that you intend to submit IO from
> outside the creating mm.

Perhaps. It'd need to be clear when we need to do so, as we certainly
won't want to move the minimal kernel version further up.


But I think postgres is far from the only use case for wanting the
submitting mm to be the relevant one, not the creating one. It seems far
more dangerous to use the creating mm than the submitting mm. Makes
things like passing a uring fd with a few pre-opened files to another
process impossible.

Greetings,

Andres Freund
