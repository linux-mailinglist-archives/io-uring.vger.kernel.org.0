Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB684383E9
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhJWOLY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 10:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhJWOLX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 10:11:23 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77357C061714
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 07:09:04 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id q129so8854078oib.0
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 07:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=6+m1mCDGwB5R+ZTUTwu4GGxhsX/ld75lF1hFMjyccrY=;
        b=1O5APkDK6LuiokD8wPK6c42gALhExZBd4ImzCiF/V/yc6aJssNOO+PNWvdO3M+sNx9
         kYfxN4bGZBhfcqdMvvxOxuYbxHQxlom6SPzNKZ/s9L2U92CVFs6ofsBaWqYTCTaLXO0z
         CzdlHK2kgrHZ8pMes6EVtb3BE0umwbZEezjiEvIgL18NYihFiEEJDrTyKt3UvKIxaqZf
         i/QoRYNpW6qTmTm0NJhmLsNOWeRVCOZGszrGUoXMDtZkynFYLwo75FfjL/rPsoSDaCk1
         cKcwvB7xAJGGHDogZ62PCg/1LfKyu6mGNJ7M0N6pjElj3rLLVTCmuVd2uKz+zwuBfQ+g
         XnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=6+m1mCDGwB5R+ZTUTwu4GGxhsX/ld75lF1hFMjyccrY=;
        b=6Jbf71IflNPuArBGf03xtkSs5/H+IA0iAxh5pfXYWaCfNJsA1bDl9fBWVQJfZOOdFe
         fY4CKjL/uKX42exHz1KEs71ElrHBsjDyW+shYzaRYBqbf5n4N7fRd5n1F1gaFR9Ki6Tk
         jX+BOQ8Ey5MqJ6LsGI3y6thdf14RNdAKUyvIRRvc2y/C+5PtdM8Y2E/lJAEuOTNj0Br5
         /y7rRqp5TVnON3jLrO8lYdqJ19QBmiwmsVnUNDXejoWnlFsPiD7Q5ZBaoHz4CR4EVWCH
         ycJi0Hab+6DkK+YiQJ6Uo2cG1X5+lB2A6ZBLVWEqHwO7ym1K3drbRGFljLD1BtCQpGEV
         /RoQ==
X-Gm-Message-State: AOAM530wd52WKeC/hxCOMu3JlemV5qGAVGMe2XOOawDjxXRyp9SwdKeA
        4wh2NlyXmBLx0UqZaFrXG8gU+nGXo307sKwn
X-Google-Smtp-Source: ABdhPJwPdiFzReC9a49ami2zG52F7rRqQPv3RB5niinRx+Rp60MLaplyLPXkjfY1zH2qsYMLVSm/Hw==
X-Received: by 2002:aca:d692:: with SMTP id n140mr15135804oig.170.1634998143500;
        Sat, 23 Oct 2021 07:09:03 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:7c74:6b9d:23e8:d6e3:1c2d:7022])
        by smtp.gmail.com with ESMTPSA id o12sm2303184oti.21.2021.10.23.07.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 07:09:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/8] for-next cleanups
Message-Id: <163499814272.138820.13768717084764658514.b4-ty@kernel.dk>
Date:   Sat, 23 Oct 2021 08:09:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 23 Oct 2021 12:13:54 +0100, Pavel Begunkov wrote:
> Let's clean up the just merged async-polling stuff, will be
> easier to maintain, 2,3,5 deal with it. 6-8 are a resend.
> 
> Pavel Begunkov (8):
>   io-wq: use helper for worker refcounting
>   io_uring: clean io_wq_submit_work()'s main loop
>   io_uring: clean iowq submit work cancellation
>   io_uring: check if opcode needs poll first on arming
>   io_uring: don't try io-wq polling if not supported
>   io_uring: clean up timeout async_data allocation
>   io_uring: kill unused param from io_file_supports_nowait
>   io_uring: clusterise ki_flags access in rw_prep
> 
> [...]

Applied, thanks!

[1/8] io-wq: use helper for worker refcounting
      (no commit info)
[2/8] io_uring: clean io_wq_submit_work()'s main loop
      (no commit info)
[3/8] io_uring: clean iowq submit work cancellation
      (no commit info)
[4/8] io_uring: check if opcode needs poll first on arming
      (no commit info)
[5/8] io_uring: don't try io-wq polling if not supported
      (no commit info)
[6/8] io_uring: clean up timeout async_data allocation
      (no commit info)
[7/8] io_uring: kill unused param from io_file_supports_nowait
      (no commit info)
[8/8] io_uring: clusterise ki_flags access in rw_prep
      (no commit info)

Best regards,
-- 
Jens Axboe


