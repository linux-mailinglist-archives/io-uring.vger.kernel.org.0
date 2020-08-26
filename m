Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDA7253870
	for <lists+io-uring@lfdr.de>; Wed, 26 Aug 2020 21:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHZTnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Aug 2020 15:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgHZTnK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Aug 2020 15:43:10 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC72CC061574
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:43:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so1618674pgd.5
        for <io-uring@vger.kernel.org>; Wed, 26 Aug 2020 12:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sSiqGYhL6mx7GdlZDbkT4CADd/LuyDj2qvehSXEkfFs=;
        b=c0wPYmScaFMOZj7JWatRYkrF0jD6jFzMN0Md0N1TNOWQ9Ph4qv2dl5i7bl2XuK/2g8
         QKQ+2ztblAFVz0LXeFtgAblEZtefFyuhCfkrAiGsrXjmDzeryGjhlqYD71z0uo1vnxHD
         Gt8H/Qw2aAnM1D6yPctfoHqtXYkRpOmyeWoJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sSiqGYhL6mx7GdlZDbkT4CADd/LuyDj2qvehSXEkfFs=;
        b=uTPphUvNG2nx89f9KXn2LbFbYHtovaGrbdjVF3qNm1xgbb9p8mAinjyZg2ARMSBkwV
         ktZl7W5ulmjKURivqckRvaCseNZ2Sp4b9tWmJ54J5jDot9cPcq/jCHtgwBQd7lgltUfm
         X1wqzDJ5M6dYVo1VWZnNGgm+THjX5yrEpdK7BbQIe62TqXOTpwSFdubTiSJBJeNLMTNN
         EDXauPTxnFvLbhfRtsl2ntdDXT1xDFLiDD+uyZBwGeLQjCXmoOBre9tYxacUIZyofoR1
         Juis2Q9T1yDhSvRSRPqK0lig+L8VtACO/B5luSuHMW3GiisHfN2IwRX1KTm7Qoc2bdmE
         Ng/A==
X-Gm-Message-State: AOAM533MtQiejGb6OBu51/tpEyYtxMUwl1lQwIh4R3nGYUwcUtleal5D
        VplFRePe3ghy/XsA1NAWjl0Gow==
X-Google-Smtp-Source: ABdhPJyQnpR7N2xazFbp7J7MUFKkTkxsUr7ZQgxByGJ39DlvvIGGA/PzpplC4Eu0qakGcWY/M93Ulg==
X-Received: by 2002:a63:4450:: with SMTP id t16mr11747991pgk.3.1598470989316;
        Wed, 26 Aug 2020 12:43:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id bo13sm114165pjb.23.2020.08.26.12.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 12:43:08 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:43:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <202008261241.074D8765@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-2-sgarzare@redhat.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
> The enumeration allows us to keep track of the last
> io_uring_register(2) opcode available.
> 
> Behaviour and opcodes names don't change.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index d65fde732518..cdc98afbacc3 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -255,17 +255,22 @@ struct io_uring_params {
>  /*
>   * io_uring_register(2) opcodes and arguments
>   */
> -#define IORING_REGISTER_BUFFERS		0
> -#define IORING_UNREGISTER_BUFFERS	1
> -#define IORING_REGISTER_FILES		2
> -#define IORING_UNREGISTER_FILES		3
> -#define IORING_REGISTER_EVENTFD		4
> -#define IORING_UNREGISTER_EVENTFD	5
> -#define IORING_REGISTER_FILES_UPDATE	6
> -#define IORING_REGISTER_EVENTFD_ASYNC	7
> -#define IORING_REGISTER_PROBE		8
> -#define IORING_REGISTER_PERSONALITY	9
> -#define IORING_UNREGISTER_PERSONALITY	10
> +enum {
> +	IORING_REGISTER_BUFFERS,

Actually, one *tiny* thought. Since this is UAPI, do we want to be extra
careful here and explicitly assign values? We can't change the meaning
of a number (UAPI) but we can add new ones, etc? This would help if an
OP were removed (to stop from triggering a cascade of changed values)...

for example:

enum {
	IORING_REGISTER_BUFFERS = 0,
	IORING_UNREGISTER_BUFFERS = 1,
	...


-- 
Kees Cook
