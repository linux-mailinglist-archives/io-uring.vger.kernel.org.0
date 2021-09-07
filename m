Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1B0402D1F
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 18:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345076AbhIGQth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 12:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345327AbhIGQt1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 12:49:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E7CC061575
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 09:48:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q11so15426602wrr.9
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 09:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LEtLeeGoFT8WbYTgRN3HPOn8m+iO600FeLjofpTTVKc=;
        b=kFT+bZHs4/bwXFPsPozvGaiFNmOrEdGI2lwaizqHt0g4Tc7o+nFSxLVT2xn9csBjSg
         742ZBjU2sTYGnkO6G0ljNyVsV6HkzmR+BDlpZNvd59EfLo8sg0mSH+Ub9LGBlAOxvnrH
         SBm+yqcd7cZL17QAnpr0ISvX4AN1hJUHzzt2aQRioSLCzFZvC7xue7Dy6HOfIIlil5wk
         so0FE9HkowHkw2QTNNNENEzrJ7DRCMWbET1gGq+iNAQJfbnYwRjb0djbapWz65kOHi78
         svEz+mMHh6AQaPXyrSlPkxY9Vq4ITsWg905bf8ItHn9erSQuTqJYq9fRzerr+GprSRAf
         LfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LEtLeeGoFT8WbYTgRN3HPOn8m+iO600FeLjofpTTVKc=;
        b=fFODcQKsf3ujRzHlz/nu7lWXuOO8Uy8F0JaaGDMw4cqkSfT08Co/R83yOy4TeT50rp
         AgymvSSLGBizWFlcxXX+k53UenPSH2UgxExJ6HcEYNof7ldrugkxGcqdeNobN+68wYOP
         mS9od6BGBePIXtXVZHUimu4ZTVEXJYLWPX/V06uZfBDXGssmOC3lUWJpHQvpRIj+5Rof
         lNsr3yrDizIZJbx0e1KRJ3XjjvjN9NMiGD3Yr6y8tNwnkSUV8V2iNIQ/wpskZxHnLmfk
         I5gBvGwlvpoZ+8+VeyrT18eBjI7F+sEeRaJqtisV2ziuJQ53ghmeqhoGPTHQaQ6vaOrc
         DNhw==
X-Gm-Message-State: AOAM530+wxSF1lZBHPzXNwqLbBUhn9wQB2h+EMDZ19vluN5OgQyBjjlr
        etJCVSP6UrZhtKbv0A2XJHuS8r+ZxztzagvqfLI=
X-Google-Smtp-Source: ABdhPJx5l+2h9vRLIxgDpts+tXpc6KsZin2C4O26GsUgSORJMvpJyhdwVoRA3G6HU0hoJPjCWLZax6gg9IApUdatgiA=
X-Received: by 2002:adf:90cc:: with SMTP id i70mr19815231wri.408.1631033299617;
 Tue, 07 Sep 2021 09:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125937epcas5p15667b460e28d87bd40400f69005aafe3@epcas5p1.samsung.com>
 <20210805125539.66958-7-joshi.k@samsung.com> <20210907075055.GE29874@lst.de>
In-Reply-To: <20210907075055.GE29874@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 7 Sep 2021 22:17:53 +0530
Message-ID: <CA+1E3rJsrBjpS8mNTg3jk2VWDCZ54OsbB4LC8zZaVeaN0dr2dA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] nvme: enable passthrough with fixed-buffer
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        Javier Gonzalez <javier.gonz@samsung.com>, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 7, 2021 at 1:21 PM Christoph Hellwig <hch@lst.de> wrote:
>
> > +/*
> > + * Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough.
> > + * And hopefully faster as well.
> > + */
>
> This belongs into io_uring.c.  And that hopeful comment needs to be
> validated and removed.

I'll do away with that comment. But sorry, what part do you think
should rather move to io_uring. Is that for the whole helper
"nvme_rq_map_user_fixed"?


-- 
Kanchan
