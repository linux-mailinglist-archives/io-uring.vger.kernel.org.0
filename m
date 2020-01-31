Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D014EF7D
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgAaPYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:24:09 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46714 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgAaPYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:24:09 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so8499109ioi.13
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Xgbt4a4i3DmZVgF9zJmCL29g8nE4gsBvrTmnunAGKqg=;
        b=OVDbW1vHKF+NCS/D87b0ayzsMce3pp4voxMpTQJCIOZdgEPnWdy/l6mXee6hGGHtS8
         +dvnAHtTIYfqQ6nxN73xl3qnseXX+0VfZZfqOoQNFXm995QYnKeICWQ9cEisqKOePtdK
         4WRSKsx7xxAPTRzCzm4J1jTIftqEibQC1eJFQdfP1lWgtzr5yKfnhgSWNomXfcKSGUyj
         KMaL3PRV376JcuZETrCCCmaKGQRbihDNqXeeMGFVwrxn3pPWWtoq8Wj8mq+WVwhesYxj
         WnvufFWzajXlnYxJ2dVReXaNpj7S7YFaVhABzkzOrevZCF5uoLuf9xQrclgLXb9KPVbN
         9deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xgbt4a4i3DmZVgF9zJmCL29g8nE4gsBvrTmnunAGKqg=;
        b=bcR0xpnpyGyOL6N4Riy0FTEDZgUz5My7ux+tS0msrEagOvZLrmJHELAQ0t59NHb8co
         LidbgBKWC0ZaNV5SpBf+Aa9IudGZHIJSGr6GnH3qtNVIDycCVvLjiaM9TE7tHWK7jGqW
         AyTSZutEuEepTVcsq1HCto35YUJXfCdkDeYCMN06L5dU6Ds4OeS4wba5JkLj6BBO9pBC
         Zu7TCinpuc5dAWSNUSKeA/WjEXzYN5Wd72C1kKzDHsqD/MANFQINEpogJIIVir5pYOno
         nTezhioPfVm9Rvoe5LNQM7p+Npyyc0A/kdG+G7RGhbxHn5XadFvoTd1FTv9AaMu+e/NJ
         38Gg==
X-Gm-Message-State: APjAAAXgn+4RzC5cBkPox3wO+/J42yHj2DrwaAVYR1UNmS3VdXvoIktl
        XgrUu2JQQM4aV5PwrIIPf37JfaCwHPw=
X-Google-Smtp-Source: APXvYqxaNHa1hdx+MAIGDCxtTc21MVii2hPhmqvVX7nlnSGlfBFvVEAH/VSHNLNWXlFH1yHCouBYdg==
X-Received: by 2002:a02:708f:: with SMTP id f137mr8838104jac.4.1580484246907;
        Fri, 31 Jan 2020 07:24:06 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e1sm3213764ill.47.2020.01.31.07.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:24:06 -0800 (PST)
Subject: Re: [PATCH liburing] add another helper for probing existing opcodes
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org
References: <20200131150002.4191-1-glauber@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d4cff1bf-bb75-e202-26c8-a6d82fae5737@kernel.dk>
Date:   Fri, 31 Jan 2020 08:24:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131150002.4191-1-glauber@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 8:00 AM, Glauber Costa wrote:
> There are situations where one does not have a ring initialized yet, and
> yet they may want to know which opcodes are supported before doing so.
> 
> We have recently introduced io_uring_get_probe(io_uring*) to do a
> similar task when the ring already exists. Because this was committed
> recently and this hasn't seen a release, I thought I would just go ahead
> and change that to io_uring_get_probe_ring(io_uring*), because I suck at
> finding another meaningful name for this case (io_uring_get_probe_noring
> sounded way too ugly to me)
> 
> A minimal ring is initialized and torn down inside the function.
> 
> Signed-off-by: Glauber Costa <glauber@scylladb.com>
> ---
>  src/include/liburing.h |  4 +++-
>  src/liburing.map       |  1 +
>  src/setup.c            | 15 ++++++++++++++-
>  test/probe.c           |  2 +-
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 39db902..aa11282 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -77,7 +77,9 @@ struct io_uring {
>   * return an allocated io_uring_probe structure, or NULL if probe fails (for
>   * example, if it is not available). The caller is responsible for freeing it
>   */
> -extern struct io_uring_probe *io_uring_get_probe(struct io_uring *ring);
> +extern struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring);
> +/* same as io_uring_get_probe_ring, but takes care of ring init and teardown */
> +extern struct io_uring_probe *io_uring_get_probe();

Include 'void' for no parameter.

> @@ -186,3 +186,16 @@ fail:
>  	free(probe);
>  	return NULL;
>  }
> +
> +struct io_uring_probe *io_uring_get_probe() {

void here as well, and new line before the opening bracket.

Minor stuff, rest looks fine to me.

-- 
Jens Axboe

