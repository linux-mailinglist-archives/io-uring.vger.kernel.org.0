Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229401E303F
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 22:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403928AbgEZUqS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 16:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403920AbgEZUqR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 16:46:17 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747FC03E96E
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 13:46:17 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ee19so10135490qvb.11
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 13:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=grxbOYNpOqxM7JP5izyFEjnzTirkS5+MQpdVDhkVv6s=;
        b=SK/j8/sBEAECUReC3/26qb5WYBKgJusmM4Bi0ypDM/Zohzcal6XacR3hCU754mhVtt
         E/5T4evfDsYZZhA9Ukgqn71YcrmQhklo/ouZh7stq4wCar8JR0/8bulocC1KxQxwmqk3
         DDp4qVL9jeoL9CohXbQhdUV/7gnfjQAqnufAqXJl5p1ZSF5aNK8Xc0r/slhNtqDf96z7
         RPlr9aVuPCFMtPtrndIWOuD20FaYhurPZLBbVrBcYvb4pSG0il+Tfmct4CaGWVG06Mc8
         HQMn28HfZJDmqy7v+pNpgsdZwJeG0NcquoKR0QGCX0ZPO54EuyQMmtsgW7QGQr8jRLP1
         hbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=grxbOYNpOqxM7JP5izyFEjnzTirkS5+MQpdVDhkVv6s=;
        b=Y/o536Ua645xNEkPNyPZMc5MlBNn+PcPLnDSnyEx5WKodJTsQ/Unal+oPUaFPe9XCl
         0++aOoJBWXolC3obK2RzfJIgSWc7Kl0g/8VB6rYpJPJEx8T5p3X5CHfeSkX+eiD+hUfB
         hQF8nmRX7K0r6y0z5OJ2ivFAs9JPXOf88M1pnRv3zLKhyP+kps+7LpJWQTB065IwVOiY
         gvi5opvLY6yHlYL7138wxpxn0bAVka0exMDZixUALF8Dl2KvA9hSu4IlXgMVL8BiabVY
         gvRd3/+0Kdnl1jlLct5Hv/6VZ56h9KTf/RgwOwQOVAeOwvIyfrMW51vKDLoGak8ViBJu
         Z1NQ==
X-Gm-Message-State: AOAM533+XjM9tGWpKTXKjjluUVwmXq/HdbfR/m7JyasF74xEqOY7xj0U
        dsC+3e8dBtqk/4k6ez5qb+pFJA==
X-Google-Smtp-Source: ABdhPJw17yp0oF4CQ8J3+E7IWKM6xulkRGgACyehYTnS6SFzVDCaB8Ziav9WNv6ap066m6W/aJRucA==
X-Received: by 2002:a0c:ffc6:: with SMTP id h6mr8896151qvv.213.1590525976662;
        Tue, 26 May 2020 13:46:16 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2921])
        by smtp.gmail.com with ESMTPSA id n184sm658331qkf.0.2020.05.26.13.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 13:46:15 -0700 (PDT)
Date:   Tue, 26 May 2020 16:45:52 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 02/12] mm: allow read-ahead with IOCB_NOWAIT set
Message-ID: <20200526204552.GA6781@cmpxchg.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-3-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:13PM -0600, Jens Axboe wrote:
> The read-ahead shouldn't block, so allow it to be done even if
> IOCB_NOWAIT is set in the kiocb.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Looks reasonable. Especially after patch 1 - although it seems that
even before that, IOCB_NOWAIT could have occasionally ended up in
page_cache_async_readahead(), which isn't too different from the sync
variant except for the range calculations, and may have blocked on IO
submission in the past.
