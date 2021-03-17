Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8F933ED2E
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 10:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCQJik (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 05:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCQJif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 05:38:35 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF43C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 02:38:35 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 12so1053829wmf.5
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMaDU1LssD4SRDotkuNIMUgfOpR2CMTm0AB19wYg3Ug=;
        b=TXy9pVuxXSuBL0zAf0OJju9+LlC9GMCUM9+rQcIQpLQU6e9gnSN4AsOBDf8s1pDGIs
         y47Nr3nCmIOtvUOtr5dQQCjD1UTicUhYWJbldiK6NNj+ChTS/r1vmZsWfX/M+gDJOL1b
         RLYpeT+wZnMMadfDtiJGWDZ4bk+yX+L9pm64dYZEuCQb68VSuoNVsDLmDIhtbWOiSg3T
         yxmeREGZIMXD6usmtz9rUfzjLx1nrYzWn3AjEFkHxl690dQ0nS9K/4dh0Pi6G6HvIafo
         UrMyZISYPL4nSY+RRMlsP25o2AM6DVvzLVocQ+3mm0VOmdUGIF/HsuvuyrpDDrMq3gLP
         ViAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMaDU1LssD4SRDotkuNIMUgfOpR2CMTm0AB19wYg3Ug=;
        b=Nnze/jLcbMEF3qbQYoD/cJ+gwzhGTGXpvD4ZVKQZr5lX64iRe/ldnBpXB5SW84nXOf
         g6Hhx3MXMEPViamGICzuGMoW87HMwF5qkjXvP5mXL7YlyWfiUD5xc2vkIZeCpfNjHGkJ
         V+hVjTi49PJ/B5IUL7i7GFTaRlrjloy5H6SRZPYWAb8G9ToTRLVRm82vCnptnrDql9Z5
         gU03xqFhtBniwl+gH6LE5YvcAcOPU4obI3RC7t3PP88F5N7aR502MdCAxWe4Vkafi3J7
         fyGsZ0YpOemqDqahSmbFHdEwA+G3RCjxO7ooExCc2JlloQ0NroP9XcsYr5wTibhfbt1n
         L5tQ==
X-Gm-Message-State: AOAM532+Y3qqxcF6t6v+aoy2/fRJhfrwzTSNq4N0W0ycZYRwdxWq0g6s
        Qm0gPKNUj7s6Kpf9lizkdaXxNoboavQw21LI2oU=
X-Google-Smtp-Source: ABdhPJzlX3JiHmmQ7nxtnbUljuSZK2MyF+mqIL3SYHiGq1PMRWkKJbrDuRSpsgPYW1EFBg1sN9n/rRgsKgZi1SSm4Ok=
X-Received: by 2002:a7b:c931:: with SMTP id h17mr2876607wml.4.1615973914198;
 Wed, 17 Mar 2021 02:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140236epcas5p4de087ee51a862402146fbbc621d4d4c6@epcas5p4.samsung.com>
 <20210316140126.24900-3-joshi.k@samsung.com> <20210316171628.GA4161119@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20210316171628.GA4161119@dhcp-10-100-145-180.wdc.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 17 Mar 2021 15:08:09 +0530
Message-ID: <CA+1E3r+vddNqqPh5=+U0v_mLA4=gUdJVhtv3PJzwXXtrfr2xCA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/3] nvme: keep nvme_command instead of pointer to it
To:     Keith Busch <kbusch@kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 16, 2021 at 10:53 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Tue, Mar 16, 2021 at 07:31:25PM +0530, Kanchan Joshi wrote:
> > nvme_req structure originally contained a pointer to nvme_command.
> > Change nvme_req structure to keep the command itself.
> > This helps in avoiding hot-path memory-allocation for async-passthrough.
>
> I have a slightly different take on how to handle pre-allocated
> passthrough commands. Every transport except PCI already preallocates a
> 'struct nvme_command' within the pdu, so allocating another one looks
> redundant. Also, it does consume quite a bit of memory for something
> that is used only for the passthrough case.
>
> I think we can solve both concerns by always using the PDU nvme_command
> rather than have the transport drivers provide it. I just sent the patch
> here if you can take a look. It tested fine on PCI and loop (haven't
> tested any other transports).
>
>  http://lists.infradead.org/pipermail/linux-nvme/2021-March/023711.html

Sounds fine, thanks for the patch, looking at it.
Which kernel you used for these. 'Patch 2' doesn't  apply cleanly.
