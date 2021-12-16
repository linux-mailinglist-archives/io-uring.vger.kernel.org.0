Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE016477562
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbhLPPIK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 10:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbhLPPIK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 10:08:10 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A5DC06173E
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 07:08:09 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id y68so65449191ybe.1
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 07:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N6pE3NqnXz9siytYRdR4wrsPlbhZQqG3dKNjNWE8EgQ=;
        b=vD2bNAVedHhtm7Cb3CYZ3/DDlhVTOCPbqQsfCfv6nFSus0HHlySKST88+VrblGIFYJ
         /XNx7KnjTYTv+m9ZRhFdEU0qOFjTaZrYWiJBGwDu2MIn86l8wDGRJBIbWzj3z6GJS/4R
         mlYuqC5XZSq3kQdJahTkt5Rgv8jVYHmmtMasXLnDP6KQ6hc22hHN99snZDsw6Rwrjl4l
         HKna1sT5ncXoODnDRziA74eF7x3aq+2gxYCpIOKKR7qNZwi/oP/nQ5GNPWp+TKmH6aeP
         HTj0cw8TAnhN0lJo+AijYLmXKN7lIYx0lu5xxVZA8VaEcOu0d4YQhUuHvhcdzNDhM4LW
         WYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N6pE3NqnXz9siytYRdR4wrsPlbhZQqG3dKNjNWE8EgQ=;
        b=pKwyP8EdDMtXLe25jSFZ5fE5YAqmr/jutTDiEFDApq5tbSexkNEPqp4AJqC+ieKp8O
         0MPXZm2wgHHDENfV3OfCSfmo/XgqggJ7zZzF7ui+9GivOvaqXBtmLfVyhNaD0r2XGbpB
         e4sUlZOdOAFLUrBsYTjSCcv8q03E1ybjUgvyQ73riSINi6DDzozavi+vTWR/DzYk2ECR
         x3j5AxZWc/yR3kjGaXGfbmPwYYnl9hh1mCpsbIoniA7rjANxUZ2c5bkAnCcVTjF00UNM
         pdlWxOzr/blFBjt1mOMSGd5tBvMqWo/uQ4//O4jqjbODZYTbDpX5QlcAB1PklhnbZcN5
         qUFw==
X-Gm-Message-State: AOAM531E4fMvuydpHPzpUeckyA2gLeip2mIMR2uttYMkosOn4ayj+noT
        A14jyw/MnPEmbAgfEkZD4Cw2Q410mbMuf94iFdMFiA==
X-Google-Smtp-Source: ABdhPJxq+l+hxZlBXDnnv4WQkQqCdtXqYe9vLn/USYeGGUpRjwJM+/w8RMfxuf6/pyYhO4tFgmN3s7VurhayA27UTQg=
X-Received: by 2002:a25:d685:: with SMTP id n127mr13413553ybg.523.1639667289170;
 Thu, 16 Dec 2021 07:08:09 -0800 (PST)
MIME-Version: 1.0
References: <20211202064946.1424490-1-yebin10@huawei.com>
In-Reply-To: <20211202064946.1424490-1-yebin10@huawei.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 16 Dec 2021 23:07:33 +0800
Message-ID: <CAMZfGtVTB+pW5Z9i1h_Ye=yMzFLd59xGnJN1w34uAxVRmU9M4g@mail.gmail.com>
Subject: Re: [PATCH -next] io_uring: use timespec64_valid() to verify time value
To:     Ye Bin <yebin10@huawei.com>
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 2, 2021 at 2:37 PM Ye Bin <yebin10@huawei.com> wrote:
>
> It's better to use timespec64_valid() to verify time value.
>
> Fixes: 2087009c74d4("io_uring: validate timespec for timeout removals")
> Fixes: f6223ff79966("io_uring: Fix undefined-behaviour in io_issue_sqe")
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
