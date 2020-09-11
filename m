Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0C26632D
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgIKQLt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 12:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgIKPhL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 11:37:11 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603D5C061786
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 08:36:05 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u6so11475127iow.9
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 08:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NbLHw2hUmHrtX5NVGNoFbSfze0l2FrrgICxDaUAEGt8=;
        b=pTmvS4RHe4vNGWLmLh64eesDMFbe3k9eyW8iLMjv4z4OufDqnWdDkgZ6NeCppDh/gB
         xooYZgIRh45DD8tufIu7jJWJaRL4GsZo8l8CyWKHMXd6+HXSmeUk5IwH6Y05jIYUJqL4
         QWQBm8DK+meciuLMm+fTUIKlp9adNtiWV+vPV8oNuRGvekK/6eLweNcm+9M27TvljaGM
         0xfdt2VJznom/wXhp2ur+k2QJK926lgHMJKTGTrGF0OO0D3Asr2MjwAH5vVDn4aS8cg2
         oUJmh2UCPlppURqNCJn5ei4QsnYvjWYcb26/S2sZhxQ5jTpQ6V5Ofe0s7TWtqDrsmRE+
         eCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbLHw2hUmHrtX5NVGNoFbSfze0l2FrrgICxDaUAEGt8=;
        b=koNJvQJbmZCkaNjLLDbMTA0H8dVfMWeiKNaKdPY28n3kGN2HlGzEFEU6OebQRhlMF7
         0xeNK6gmm7MjvMLCgf6PszqI+qzzGZ6Pp1jYtlI9nI+H7LTKVlltDJL2o7OC3MCKVgtQ
         XKge+Ucchr28/mlLa2YNk6VNgEg2zAASt+xBL5Q25c0n0uwP6o9dFauXopMVTq9AH/Nt
         jjAReUrLVn+RAEGijFWi3/2RQ1zgXVrKv509JZrhZFR0HsTESYhMBNKkwkhexc9ON/oB
         dwulb2qTzAqQDhQG73hc62NdLncujUnZI+ITriqGf+WdNi+A3qjmFUT222IQ+7iTOX2P
         wzaA==
X-Gm-Message-State: AOAM530K49IqbbFS9ZKA9ceJuHYU3F7oN9Q0emDiUrhIg6CF+eCmv+6k
        TES0N6XC9noZ8FBCPddV3bDqC7mvEmarJR4Y
X-Google-Smtp-Source: ABdhPJxGSecWElvQmJwr6dEA0PsbuaKr9B0AsA1ozHxQYkmYKyYf1cqErOwcm3CWDPkqYKhILPtJaw==
X-Received: by 2002:a5d:9c87:: with SMTP id p7mr2209746iop.138.1599838564421;
        Fri, 11 Sep 2020 08:36:04 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l16sm1426828ilc.3.2020.09.11.08.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:36:03 -0700 (PDT)
Subject: Re: [PATCH liburing 3/3] man/io_uring_enter.2: add EACCES and EBADFD
 errors
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-4-sgarzare@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d38ae8b4-cb3e-3ebf-63e3-08a1f24ddcbb@kernel.dk>
Date:   Fri, 11 Sep 2020 09:36:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200911133408.62506-4-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/20 7:34 AM, Stefano Garzarella wrote:
> These new errors are added with the restriction series recently
> merged in io_uring (Linux 5.10).
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  man/io_uring_enter.2 | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> index 5443d5f..4773dfd 100644
> --- a/man/io_uring_enter.2
> +++ b/man/io_uring_enter.2
> @@ -842,6 +842,16 @@ is set appropriately.
>  .PP
>  .SH ERRORS
>  .TP
> +.B EACCES
> +The
> +.I flags
> +field or
> +.I opcode
> +in a submission queue entry is not allowed due to registered restrictions.
> +See
> +.BR io_uring_register (2)
> +for details on how restrictions work.
> +.TP
>  .B EAGAIN
>  The kernel was unable to allocate memory for the request, or otherwise ran out
>  of resources to handle it. The application should wait for some completions and
> @@ -861,6 +871,14 @@ field in the submission queue entry is invalid, or the
>  flag was set in the submission queue entry, but no files were registered
>  with the io_uring instance.
>  .TP
> +.B EBADFD
> +The
> +.I fd
> +field in the submission queue entry is valid, but the io_uring ring is not
> +in the right state (enabled). See
> +.BR io_uring_register (2)
> +for details on how to enable the ring.
> +.TP

I actually think some of this needs general updating. io_uring_enter()
will not return an error on behalf of an sqe, it'll only return an error
if one happened outside the context of a specific sqe. Any error
specific to an sqe will generate a cqe with the result.

-- 
Jens Axboe

