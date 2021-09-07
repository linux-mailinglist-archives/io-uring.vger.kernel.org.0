Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603D0402CC5
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbhIGQWF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 12:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbhIGQWB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 12:22:01 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E43C061575
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 09:20:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id u9so15281697wrg.8
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 09:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6dgSwN7ol1yXriQkyjgfHQ3T2Kfo7tblWaLh+5UXwxg=;
        b=X5WYcDpkqGQPAh9CId/yfG8xEJmJO3X3RGiG6IY1rS9FuAN0VbAsH3HyvFcUoId70v
         nbHJFz4qdfJn1Jr44Cl5hFVssy598QRAmsSAkDFsyPxxwEx7QZcsvsedbAwHPFK00UDe
         BxyAR1F0zsxu01v16fxGcvJFAb3/7xopXJ9yE3OGMLP/94F4CVVx90cdhcUQ4UN5UF/V
         ED3hUjOIwiifS6u6K/d2e4djZqixqToSqKJo+olUIAxB5PifgHhrOeQvc8Tm6ipO3vZk
         VI3SCShSkluHI/zh/FvoAljl91Ef5oUblMPvGPZRa1KP3tAn2DnI2Q5au9RFW4No1HO4
         8c8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6dgSwN7ol1yXriQkyjgfHQ3T2Kfo7tblWaLh+5UXwxg=;
        b=oDS7IIoBt1kXX/9i/OO2AmWs1Y/6ZAYzlqXzIULyUKpTRRl5E7BlO8/p9MOVd8Ga64
         D4ygySb7Grb+eZ2oz/6fcpYiFoLqdOI/32YrEPkBb/ULCd6N4eDBaueBwcvRVzw3dRV1
         niIr155LrtEx8snXRKmIhStrdH5PnvSjUfDnmTpRIE6ILzuJc8Yhykv+A7yzTbLtpZV2
         VxH8yWFo1fXHgivHN9xtDX0Tzck9KCM3Jiz6++PIFbTUqBBaZSeio/AjwO5FHtxZLG9k
         rOYlE5+aNiSKuBIFYJkNhSY+BTEJ5h/IkxC3oHiuZBSQ4PlivFIkkvdXgiuR09ZrLi7q
         slyg==
X-Gm-Message-State: AOAM530Vfti3ikV4lcSx3Aou2Fok8DXPqFR/oy5AeJ6L+PmQIv8klATf
        pQGQG2E1J6TqxwRjqP8iFlOUeORDv2a9ATYu1rM=
X-Google-Smtp-Source: ABdhPJz2Qdte2dyhhO1EukEOIbrssiN0u5LnGHUVgbrNalxMZa6+bagqPRFD9/v3Z55vP+hfw9NTi/5oUzNKOndmWro=
X-Received: by 2002:adf:9e49:: with SMTP id v9mr19926094wre.39.1631031653345;
 Tue, 07 Sep 2021 09:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125923epcas5p10e6c1b95475440be68f58244d5a3cb9a@epcas5p1.samsung.com>
 <20210805125539.66958-3-joshi.k@samsung.com> <20210907074650.GB29874@lst.de>
In-Reply-To: <20210907074650.GB29874@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 7 Sep 2021 21:50:27 +0530
Message-ID: <CA+1E3rJAav=4abJXs8fO49aiMNPqjv6dD7HBfhB+JQrNbaX3=A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] nvme: wire-up support for async-passthru on char-device.
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        Javier Gonzalez <javier.gonz@samsung.com>, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 7, 2021 at 1:17 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Looking at this in isolation:
>
>  - no need to also implement the legacy non-64 passthrough interface
>  - no need to overlay the block_uring_cmd structure as that makes a
>    complete mess
>
> Below is an untested patch to fix that up a bit.

Thanks for taking a look and cleaning that up. Looks a lot better.

> A few other notes:
>
>  - I suspect the ioctl_cmd really should move into the core using_cmd
>    infrastructure

Yes, that seems possible by creating that field outside by combining
"op" and "unused" below.
+struct io_uring_cmd {
+ struct file *file;
+ __u16 op;
+ __u16 unused;
+ __u32 len;
+ __u64 pdu[5]; /* 40 bytes available inline for free use */
+};

>  - please stick to the naming of the file operation instead of using
>    something different.  That being said async_ioctl seems better
>    fitting than uring_cmd

Got it.

>  - that whole mix of user space interface and internal data in the
>    ->pdu field is a mess.  What is the problem with deferring the
>    request freeing into the user context, which would clean up
>    quite a bit of that, especially if io_uring_cmd grows a private
>    field.

That mix isn't great but the attempt was to save the allocation.
And I was not very sure if it'd be fine to defer freeing the request
until task-work fires up.
Even if we take that route, we would still need a place to store bio
pointer (hopefully meta pointer can be extracted out of bio).
Do you see it differently?


Thanks,
-- 
Kanchan
