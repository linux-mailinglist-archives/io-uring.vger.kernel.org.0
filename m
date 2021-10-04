Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8C421194
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhJDOkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 10:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhJDOkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 10:40:16 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61943C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 07:38:27 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y17so10188310ilb.9
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 07:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OUlkfXpii84uLKcBPu75jqM7hx+kQKNy64RwvbmHtyI=;
        b=2LdU9rf8GPKYQ6FPngBaxRFbKVwtK9J8YybJR0T6WMa4E7W98DZF35XQ1KHDvfAgVZ
         3YBQvXlJbq5evNNQX6fyV3FKtgXfOSXIBJrMxDpci8npyt32vuFcLs6NjXni89C3aVIY
         jHwmVE5a/E3wcD/T/YsIRObwX5T/qpSNC+bPivuKyOgmc2Mi7FSbbRK6OaQvW64gzbc+
         rIa4gCCI9ohJxBnNDx4VCmI0JJXACRgAIMd31zx4DHkpOfFa0Lah3lrXkHfGNh1pkmtp
         XfHQEyVYqQOKUIK3+BereRxBXA34P/7jgj0TGELwMrpNi8sZJPGrXvrShZo22MLl75FW
         9p2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OUlkfXpii84uLKcBPu75jqM7hx+kQKNy64RwvbmHtyI=;
        b=EWDZcyWpU2I1DFwb1uaN0U5HfFhwtyZM9ej9bScHSD0wIjlt94yBMFSmGJbXtF/nCD
         vsZxHKyPO1eGBdkL0zj9xYae5FYwNxkTXXFHaaIsl+JhT/2nB2U1O7YM6LFW+KCvasWl
         V8HttXNL4ZPA2Ch4UEnoYX9rkJqUsetASwWCWZDvlYc/elFWK+sP92vIQ44ZaQA9ivnk
         RMU2yIMe63M1U0Zvork4RkyfOO2PVn2WVRE/VYdvQNbB+Hly1Vvrq6ANKu9Std2WeASc
         sG6yGNEmPeZ4p2FVXwYoCv4jhsZadCfsiIyOm3cK/xY0LmTqg+lx8GgB9upn1xxh6ed5
         sE7A==
X-Gm-Message-State: AOAM531CQA3zsFAPf8khRNMu40I3qDQrk++K8un4gwq30kjPlyy73C9V
        chqjkglvoNr4+NoUXPBUvb4+sSqJrLBJxUWRi5I=
X-Google-Smtp-Source: ABdhPJxLvbJ4iUCj2R0lqZLF8YucBIpSc2zISbG1O0HGPxPGJtOPQFoDA6AimmuNd3TfY+J6gY8T/A==
X-Received: by 2002:a05:6e02:14d1:: with SMTP id o17mr10380307ilk.57.1633358306447;
        Mon, 04 Oct 2021 07:38:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e10sm8994259iov.10.2021.10.04.07.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 07:38:26 -0700 (PDT)
Subject: Re: [PATCH] liburing: Add io_uring_submit_and_wait_timeout function
 in API
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <86271fc62d96470896b9edc88036072f051a788f.1633354465.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ae2fbe14-052e-748c-d187-9021a06790b0@kernel.dk>
Date:   Mon, 4 Oct 2021 08:38:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <86271fc62d96470896b9edc88036072f051a788f.1633354465.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/21 7:31 AM, Olivier Langlois wrote:
> before commit 0ea4ccd1c0e4 ("src/queue: don't flush SQ ring for new wait interface"),
> io_uring_wait_cqes() was serving the purpose of submit sqe and wait for cqe up to a certain timeout value.
> 
> Since the commit, a new function is needed to fill this gap.
> 
> Fixes: https://github.com/axboe/liburing/issues/440
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  src/include/liburing.h |  5 +++++
>  src/liburing.map       |  5 +++++
>  src/queue.c            | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 0c2c5c2..fe8bfbe 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -122,6 +122,11 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring,
>  			      struct __kernel_timespec *ts);
>  int io_uring_submit(struct io_uring *ring);
>  int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr);
> +int io_uring_submit_and_wait_timout(struct io_uring *ring,
> +				    struct io_uring_cqe **cqe_ptr,
> +				    unsigned wait_nr,
> +				    struct __kernel_timespec *ts,
> +				    sigset_t *sigmask);
>  struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
>  
>  int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
> diff --git a/src/liburing.map b/src/liburing.map
> index 6692a3b..09f4275 100644
> --- a/src/liburing.map
> +++ b/src/liburing.map
> @@ -44,3 +44,8 @@ LIBURING_2.1 {
>  		io_uring_unregister_iowq_aff;
>  		io_uring_register_iowq_max_workers;
>  } LIBURING_2.0;
> +
> +LIBURING_2.2 {
> +	global:
> +		io_uring_submit_and_wait_timout;
> +} LIBURING_2.1;
> diff --git a/src/queue.c b/src/queue.c
> index 31aa17c..9ac9fe5 100644
> --- a/src/queue.c
> +++ b/src/queue.c
> @@ -305,6 +305,39 @@ int io_uring_wait_cqes(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
>  	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
>  }
>  
> +int io_uring_submit_and_wait_timout(struct io_uring *ring,
> +				    struct io_uring_cqe **cqe_ptr,
> +				    unsigned wait_nr,
> +				    struct __kernel_timespec *ts,
> +				    sigset_t *sigmask)
> +{
> +	if (uring_likely(ts)) {
> +		if (uring_unlikely(!(ring->features & IORING_FEAT_EXT_ARG)))
> +			return io_uring_wait_cqes(ring, cqe_ptr, wait_nr,
> +						  ts, sigmask);
> +		else {
> +			struct io_uring_getevents_arg arg = {
> +				.sigmask	= (unsigned long) sigmask,
> +				.sigmask_sz	= _NSIG / 8,
> +				.ts		= (unsigned long) ts
> +			};
> +			struct get_data data = {
> +				.submit		= __io_uring_flush_sq(ring),
> +				.wait_nr	= wait_nr,
> +				.get_flags	= IORING_ENTER_EXT_ARG,
> +				.sz		= sizeof(arg),
> +				.arg		= &arg
> +			};
> +
> +			return _io_uring_get_cqe(ring, cqe_ptr, &data);
> +		}
> +	}
> +	else
> +		return __io_uring_get_cqe(ring, cqe_ptr,
> +					  __io_uring_flush_sq(ring),
> +					  wait_nr, sigmask);
> +}

I'd get rid of the likely/unlikely, imho it just hinders readability
and for some cases they may end up being wrong. You also don't need an
else when there's a return, and if you use braces on one condition, use
it for all. IOW, something like:

	if (ts) {
		if (ring->features & IORING_FEAT_EXT_ARG) {
			struct io_uring_getevents_arg arg = {
				.sigmask	= (unsigned long) sigmask,
				.sigmask_sz	= _NSIG / 8,
				.ts		= (unsigned long) ts
			};
			struct get_data data = {
				.submit		= __io_uring_flush_sq(ring),
				.wait_nr	= wait_nr,
				.get_flags	= IORING_ENTER_EXT_ARG,
				.sz		= sizeof(arg),
				.arg		= &arg
			};

			return _io_uring_get_cqe(ring, cqe_ptr, &data);
		}
		return io_uring_wait_cqes(ring, cqe_ptr, wait_nr, ts, sigmask);
	}

	return __io_uring_get_cqe(ring, cqe_ptr, __io_uring_flush_sq(ring),
					  wait_nr, sigmask);

which is a lot more readable too.

-- 
Jens Axboe

