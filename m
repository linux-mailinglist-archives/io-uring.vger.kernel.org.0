Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C795F266230
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 17:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgIKPdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 11:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgIKPdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 11:33:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C1CC061796
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 08:33:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b17so9381539ilh.4
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ILQeIKlo1kBUbOzDmNM/gnsPE2wzOnHqFWFlC6srhCA=;
        b=asT1JKFGRXK8wDFkz13kd8IqTMRw+meaM4OfOZmiXHsBFOYi4ox1AQunPnF7M5JjL3
         3+jAhjYgWKCXh0KPlLc0amdx2Uq5D1x8virLhe+EILQqNmN2cgocfQKw2HPA1pqa3qM5
         Vl+rxTNwDaIyg/j6CRtXvLSvx0AGIa6a1snRWxGNEbZgip5t0oDBTOctlr5IV8xhTA9k
         E8AX2/trEn2xq8QPpFygmnSjlTYTGZEBFlnLdu9wyMbJD1C3vGFBqhw6lCp7hHRI7wtX
         bxkLnA5lP8h5Vb5HN8MwouB4KWv2BtFjP/TqYe/95uPyZTqtteMHVM7poPiM6jmiOF6B
         6Crg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ILQeIKlo1kBUbOzDmNM/gnsPE2wzOnHqFWFlC6srhCA=;
        b=fjkw8d0tfwWephiwVlzjJ0/Bki5pqwUuGKeR5DEs4ngDDKId8vH7+Hzt7OpQ/sG/QI
         O3Idmz4qJAfYvwAnsitsDxhTyrQphFBRvdEggRErZ/J5z4sOXSL8b726UeIQxmScnzvb
         zEpu84NeJtqkLqsnM756erRinEsgb0wYpxT0HX26y7pC0XjgwOYLWD1+PppQ0TFhyqgz
         hIn1MlSt7P7MYWj3D3ugSSHDntmZA50bNCKcuCcYiOHKaw2R5UY/swf8NPA7S3rK7+iC
         r5BV1I3Zi+DFMulkB7DG1jB1nVEEZsiXbfZhz2AgxTsvmFElqm8Cm4nTe20UsBILjLWj
         8V0A==
X-Gm-Message-State: AOAM532EBLpDEH+NgygFbBT3seyZln0klz2VR9m4jogjHua9OtPvEwX3
        cErtcxEfwxjanj2gOwIPZpH6AvNdAytE8Wvj
X-Google-Smtp-Source: ABdhPJz9RBoAY0uxlrqYu7tFpy2cuX1kET5dUvQqywC2n6ZeopvlCfMFQ5tRswkn/atda9x107XPhQ==
X-Received: by 2002:a05:6e02:1023:: with SMTP id o3mr2312642ilj.141.1599838382445;
        Fri, 11 Sep 2020 08:33:02 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m18sm1414095ilc.37.2020.09.11.08.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:33:01 -0700 (PDT)
Subject: Re: [PATCH liburing 2/3] man/io_uring_register.2: add description of
 restrictions
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-3-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <13663e4a-d5a0-17c2-199a-46d03700de6e@kernel.dk>
Date:   Fri, 11 Sep 2020 09:33:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200911133408.62506-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/20 7:34 AM, Stefano Garzarella wrote:
> Starting from Linux 5.10 io_uring supports restrictions.
> This patch describes how to register restriction, enable io_uring
> ring, and potential errors returned by io_uring_register(2).
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  man/io_uring_register.2 | 79 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
> index 5022c03..ce39ada 100644
> --- a/man/io_uring_register.2
> +++ b/man/io_uring_register.2
> @@ -19,7 +19,8 @@ io_uring_register \- register files or user buffers for asynchronous I/O
>  
>  The
>  .BR io_uring_register ()
> -system call registers user buffers or files for use in an
> +system call registers resources (e.g. user buffers, files, eventfd,
> +personality, restrictions) for use in an
>  .BR io_uring (7)
>  instance referenced by
>  .IR fd .
> @@ -232,6 +233,58 @@ must be set to the id in question, and
>  .I arg
>  must be set to NULL. Available since 5.6.
>  
> +.TP
> +.B IORING_REGISTER_ENABLE_RINGS
> +This operation enables io_uring ring started in a disabled state

enables an io_uring

> +.RB (IORING_SETUP_R_DISABLED
> +was specified in the call to
> +.BR io_uring_setup (2)).
> +While the io_uring ring is disabled, submissions are not allowed and
> +registrations are not restricted.
> +
> +After the execution of this operation, the io_uring ring is enabled:
> +submissions and registration are allowed, but they will
> +be validated following the registered restrictions (if any).
> +This operation takes no argument, must be invoked with
> +.I arg
> +set to NULL and
> +.I nr_args
> +set to zero. Available since 5.10.
> +
> +.TP
> +.B IORING_REGISTER_RESTRICTIONS
> +.I arg
> +points to a
> +.I struct io_uring_restriction
> +array of
> +.I nr_args
> +entries.
> +
> +With an entry it is possible to allow an
> +.BR io_uring_register ()
> +.I opcode,
> +or specify which
> +.I opcode
> +and
> +.I flags
> +of the submission queue entry are allowed,
> +or require certain
> +.I flags
> +to be specified (these flags must be set on each submission queue entry).
> +
> +All the restrictions must be submitted with a single
> +.BR io_uring_register ()
> +call and they are handled as an allowlist (opcodes and flags not registered,
> +are not allowed).
> +
> +Restrictions can be registered only if the io_uring ring started in a disabled
> +state
> +.RB (IORING_SETUP_R_DISABLED
> +must be specified in the call to
> +.BR io_uring_setup (2)).
> +
> +Available since 5.10.
> +
>  .SH RETURN VALUE
>  
>  On success,
> @@ -242,16 +295,30 @@ is set accordingly.
>  
>  .SH ERRORS
>  .TP
> +.B EACCES
> +The
> +.I opcode
> +field is not allowed due to registered restrictions.
> +.TP
>  .B EBADF
>  One or more fds in the
>  .I fd
>  array are invalid.
>  .TP
> +.B EBADFD
> +.B IORING_REGISTER_ENABLE_RINGS
> +or
> +.B IORING_REGISTER_RESTRICTIONS
> +was specified, but the io_uring ring is not disabled.
> +.TP
>  .B EBUSY
>  .B IORING_REGISTER_BUFFERS
>  or
>  .B IORING_REGISTER_FILES
> -was specified, but there were already buffers or files registered.
> +or
> +.B IORING_REGISTER_RESTRICTIONS
> +was specified, but there were already buffers or files or restrictions
> +registered.

buffers, files, or restrictions

>  .TP
>  .B EFAULT
>  buffer is outside of the process' accessible address space, or
> @@ -283,6 +350,14 @@ is non-zero or
>  .I arg
>  is non-NULL.
>  .TP
> +.B EINVAL
> +.B IORING_REGISTER_RESTRICTIONS
> +was specified, but
> +.I nr_args
> +exceeds the maximum allowed number of restrictions or restriction
> +.I opcode
> +is invalid.
> +.TP
>  .B EMFILE
>  .B IORING_REGISTER_FILES
>  was specified and

Apart from that, looks good to me.

-- 
Jens Axboe

