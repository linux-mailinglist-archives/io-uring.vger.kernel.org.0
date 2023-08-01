Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7376C040
	for <lists+io-uring@lfdr.de>; Wed,  2 Aug 2023 00:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjHAWNO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 18:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjHAWNN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 18:13:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1FF132
        for <io-uring@vger.kernel.org>; Tue,  1 Aug 2023 15:13:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bba2318546so52758495ad.1
        for <io-uring@vger.kernel.org>; Tue, 01 Aug 2023 15:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690927992; x=1691532792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0EYoLPWYPRPKKBzMk6cia1RqniUMKqoLAzdblyrAC0Y=;
        b=k87V/fHAZCThiW9Y0VpzfFJ2dy7Ak94ild2jBFEtXhgzGtc3M/ukxjgRZrgK3r8OQO
         i6ci6IjbF9JuR5YnmKhBpg1/B6npCScE8Z8uvpzgK8sUVlTd4G0SB08olkQEmN8BiQUt
         J8d86Q/BlMljQ72de4Yp+Tpu29m4nHzplLtP+S8JUGzstspO5LfFGAlAAqgh2Z1WELd9
         JWms/aUIcGXwz7H1Z7cY14SP5YEldKewW1oUodWwcpni2IF8/B/Sa+IhYQKyiwDjAVoy
         D6evvR6awu9M9ywDX9E9ir08I/8Ytmj7RRsEDVVSwY/ICSUx7sG9ttNa64UteO5HTVmA
         UbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690927992; x=1691532792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0EYoLPWYPRPKKBzMk6cia1RqniUMKqoLAzdblyrAC0Y=;
        b=EJrI44z5noAyuD52UV+mT5r/tkX1asjcnm3jcIftNxHY8UhBrNQTYCXDorkT9BVgws
         8z0rjvKI0dhHgHUZxapBMmqy+XQOHzRQFs+WxgFa9/JXUo86tW+eCwCmVuOpTse9lNvz
         nrf5ha+jyne0GBs0QbeDAlFD743L1q6o3p8+/9arp+uAZs8XwEPOlwHra3B2hx5GpXx6
         vAYuuAGVISdADJ86RZkFmMdVXW+/ZB6Mm7QDgtpJfQMtnRvGTnIxxKCQUkmwhGh4sUJn
         6tU9TkJ7/MBX6x+G0dJ3PENRuJq8Ta81YEpd2SiKBuUV2qN/eHG8rZRUBY9tBXuSfL9J
         OFmQ==
X-Gm-Message-State: ABy/qLZhdsN6qPiWCuudqMMkBsgAf6p+BzlvwFoqNfIKa4OUDrU63zCX
        kmDt3PP9UKYB1NRb4mPZTqJTfQ==
X-Google-Smtp-Source: APBJJlGN3yMEc9arY36Uq+2eaGKSx0jk6cBe+zogrlJqOnfwbA2xAtSXd3uQsqg6gHAwim7yxY3r6Q==
X-Received: by 2002:a17:902:d2d2:b0:1b8:b285:ec96 with SMTP id n18-20020a170902d2d200b001b8b285ec96mr18019199plc.23.1690927991919;
        Tue, 01 Aug 2023 15:13:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902ed5400b001b9e0918b0asm10936926plb.169.2023.08.01.15.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 15:13:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qQxc4-00DIOT-0f;
        Wed, 02 Aug 2023 08:13:08 +1000
Date:   Wed, 2 Aug 2023 08:13:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, djwong@kernel.org
Subject: Re: [PATCHSET v6 0/8] Improve async iomap DIO performance
Message-ID: <ZMmDdEfyxIzpfezy@dread.disaster.area>
References: <20230724225511.599870-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 24, 2023 at 04:55:03PM -0600, Jens Axboe wrote:
> Hi,
> 
> Hi,
> 
> This patchset improves async iomap DIO performance, for XFS and ext4.
> For full details on this patchset, see the v4 posting:
> 
> https://lore.kernel.org/io-uring/20230720181310.71589-1-axboe@kernel.dk/
> 
>  fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++-----------
>  include/linux/fs.h   |  35 +++++++++-
>  io_uring/rw.c        |  26 ++++++-
>  3 files changed, 179 insertions(+), 45 deletions(-)
> 
> Can also be found here:
> 
> https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.6
> 
> No change in performance since last time, and passes my testing without
> complaints.

All looks good now. You can add:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

To all the patches in the series.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
