Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB8877636A
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjHIPJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjHIPJ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:09:56 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB3F1999;
        Wed,  9 Aug 2023 08:09:51 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9E4DE5C00CC;
        Wed,  9 Aug 2023 11:09:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 09 Aug 2023 11:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1691593788; x=1691680188; bh=m7
        Yanb/vvsE/fqlIS6281qF7gWWLaghgUEnS3kHEVy0=; b=neG4KZuWdFoqjpt55G
        C6BGZC3xc91iYe1axORYvayX3EjKpNORwPe96Hp2IJNRde99sVDwBklTgLnTtQZm
        AwU5Xyc2SixBeufC5gQLYj7NIiPqrfmTBAPAYB/8vftniCos59B0MLMI5fVayp/B
        EYYUVE0Zvu0pA7ANtUV8HaMwjEyQVz3WyJ6RNWbu7t0hEHEhQCHvOYlEy33QH7+s
        eWs1PnsXlczGMXM3bQBYJEFSmU+kbM29yDUzYRQiduz/61ONTLAsXzXHfBfNPXIB
        kZCWKqCdBOGaGDTUHSasGCtRsYFdC9L+ER2SFGdrt7DE0escJ8v+L8kuimvnri4G
        mqgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1691593788; x=1691680188; bh=m7Yanb/vvsE/f
        qlIS6281qF7gWWLaghgUEnS3kHEVy0=; b=0wYJnG2jecIE88IDHNK4B3wtDn+tI
        ZMIk3gtRQPlcr+yG0x8DLWJyCTubvrstivux2twxPOsirVL9fxyc+eyd/mVmMpMe
        RqHcEUCk/17MLe/a3dQGe8hOVB9zDfZ1FZLMBrJ9B5C198T3LX7HQDS4c+/ZFBuj
        EweSfjMsDr+FaDHpIywVLqhWpp1dGkzrLqH3m40tlavpXbOP33VCa7LVPItT6n06
        +SUy7l56t1WQQvRMP9KeaIb0KUnB4Am5xW5t8SLXiNbGtmWcUxMV83R6hP3c7Syp
        c2Uj3jTNMufW2nPHMOS9ken//385ThRZ2Z83w6MbHrdcL0lx7MgvAaUqQ==
X-ME-Sender: <xms:O6zTZABPODP7SAzfEtWb8fvevVdAJzmxgjbADHkM6a6jA74R_hHwWQ>
    <xme:O6zTZCi_6YHumSuxXikBRqLE7flX_KGmsLfL1U5UwpFg3OMLCnnjhFB6mnoZojKdW
    aWA9g-iKAnmuQTEQw>
X-ME-Received: <xmr:O6zTZDmshDLvhCyTpCC_LtXlTC3Bv1p-GNR3PL586crbN6kEtEfV-lcPtAJ-rJW_T5MRoCfkXXJqXzh3WROjfuojsuJpKWBp2ozXZORCMr9TvmhUrCWdvOUYjzCk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrleeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:O6zTZGz2pyx1aZJXdPyjZU1sGSbBV33WvmJrdfF307Xo5cMEopOaCg>
    <xmx:O6zTZFS4vPpX6S6IJfRLhsZLpHewPWgoaGIdxdDkxk1ycQP1vtkBZA>
    <xmx:O6zTZBaQTJagVRrc0WK-erBsE6sSKlU3H-_vUtrFm0IFchzVAfFhQw>
    <xmx:PKzTZGKL_39ndypR66zDr36gTnF3d3mHbE3L4hIzWKUnOIHySJGJ7A>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Aug 2023 11:09:47 -0400 (EDT)
Date:   Wed, 9 Aug 2023 08:09:45 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Matteo Rizzo <matteorizzo@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, asml.silence@gmail.com, corbet@lwn.net,
        akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        krisman@suse.de
Subject: Re: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring
 system-wide
Message-ID: <20230809150945.abp755qafjhxbmx6@awork3.anarazel.de>
References: <20230630151003.3622786-1-matteorizzo@google.com>
 <20230630151003.3622786-2-matteorizzo@google.com>
 <20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de>
 <x49fs5awiel.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49fs5awiel.fsf@segfault.boston.devel.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Sorry for the delayed response, EINBOXOVERFLOW.

On 2023-07-26 16:02:26 -0400, Jeff Moyer wrote:
> Andres Freund <andres@anarazel.de> writes:
> 
> > Hi,
> >
> > On 2023-06-30 15:10:03 +0000, Matteo Rizzo wrote:
> >> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
> >> or 2. When 0 (the default), all processes are allowed to create io_uring
> >> instances, which is the current behavior. When 1, all calls to
> >> io_uring_setup fail with -EPERM unless the calling process has
> >> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
> >> regardless of privilege.
> >
> > Hm, is there a chance that instead of requiring CAP_SYS_ADMIN, a certain group
> > could be required (similar to hugetlb_shm_group)? Requiring CAP_SYS_ADMIN
> > could have the unintended consequence of io_uring requiring tasks being run
> > with more privileges than needed... Or some other more granular way of
> > granting the right to use io_uring?
> 
> That's fine with me, so long as there is still an option to completely
> disable io_uring.

Makes sense.


> > ISTM that it'd be nice if e.g. a systemd service specification could allow
> > some services to use io_uring, without allowing it for everyone, or requiring
> > to run services effectively as root.
> 
> Do you have a proposal for how that would work?

I think group based permissions would allow for it, even if perhaps not in the
most beautiful manner. Systemd can configure additional groups for a service
with SupplementaryGroups, so adding a "io_uring" group or such should work.

Greetings,

Andres Freund
