Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78114C38D3
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 23:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiBXWfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 17:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiBXWfC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 17:35:02 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F7C1DFDFB
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 14:34:29 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id i1so3147495plr.2
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 14:34:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puf/8FKdbLYr0quA4rpvgcZpxrpDxz2P+EMGDZo/H/8=;
        b=zW1XQed7hZqIDys1FFIRwDgCwawIM8Wlc0HH7sHO9m3Py+lyaGDIlZ5e9W6kIDlm2E
         tfRHJFz1yrsLOGZKCw+pV7qAE2aCyGJ/+BiTuRUUoOvGJ8itTnUV+4eMy3+LUwxn83ll
         yqhWHMbZ8TIoPo0kUa320x80m7l0Vboh+VAQPNVJfRlpvOo6T7eLUd0Bxd96WjHd3zR5
         LsQtjr4HTN8GJ5J5Dw6MaC4kF/3xFz4JH/ETEvat9tChhXw6XTfbZLsKazed5lgLfn+z
         VU+roUqbuJ13GHYCsqLKi+yxF6uS5yA7a+xtY9R8hn6Z79KolamVt8KQlCwK55hgVeCK
         TEgQ==
X-Gm-Message-State: AOAM532hdIeHfw7MS6bj/nG5IT8MNg+WK1HoxVUVNODMO7qQbSETKynw
        thGrd9VtHJDe3PM+8rRokbA=
X-Google-Smtp-Source: ABdhPJzRDjZLym3li7hQ1xawBNXudqozQ0BsjH0SuPNJGvDI9I0OWzXtLRm+ZuRQbprUfctKxS5dAg==
X-Received: by 2002:a17:902:b08e:b0:14f:11f7:db14 with SMTP id p14-20020a170902b08e00b0014f11f7db14mr4511843plr.106.1645742069068;
        Thu, 24 Feb 2022 14:34:29 -0800 (PST)
Received: from garbanzo (136-24-173-63.cab.webpass.net. [136.24.173.63])
        by smtp.gmail.com with ESMTPSA id my6-20020a17090b4c8600b001bc2cb011dasm305319pjb.4.2022.02.24.14.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 14:34:27 -0800 (PST)
Date:   Thu, 24 Feb 2022 14:34:25 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
Subject: Re: [PATCH 1/8] io_uring: split up io_uring_sqe into hdr + main
Message-ID: <20220224223425.yb2bs5sp3vhttjz3@garbanzo>
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-2-axboe@kernel.dk>
 <20210318053454.GA28063@lst.de>
 <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04ffff78-4a34-0848-4131-8b3cfd9a24f7@kernel.dk>
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 18, 2021 at 12:40:25PM -0600, Jens Axboe wrote:
> I'm not at all interested
> in having a v3 down the line as well. And I'd need to be able to do this
> seamlessly, both from an application point of view, and a performance
> point of view (no stupid conversions inline).

At this point I've now traced the history of effort of wanting to do
io-uring "ioctl" work through 3 sepearate independent efforts:

2019-12-14: Pavel Begunkov - https://lore.kernel.org/all/f77ac379ddb6a67c3ac6a9dc54430142ead07c6f.1576336565.git.asml.silence@gmail.com/
2020-11-02: Hao Xu - https://lore.kernel.org/all/1604303041-184595-1-git-send-email-haoxu@linux.alibaba.com/
2021-01-27: Kanchan Joshi - https://lore.kernel.org/linux-nvme/20210127150029.13766-1-joshi.k@samsung.com/#r

So clearly there is interest in this moving forward.

On the same day as Joshi's post you posted your file_operations based
implemenation. So that's 2 years, 2 months to this day since Pavel's
first patchset... Wouldn't we be a bit too much of a burden to ensure a
v2 will suffice for *all* use cases? If so, adaptability for evolution
sounds like a more fitting use case for design here. That way
we reduce our requirements and allow for experimentation, while
enabling improvements on future design.

  Luis
