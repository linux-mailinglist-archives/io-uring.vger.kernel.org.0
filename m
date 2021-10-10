Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94B64280CD
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 13:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhJJLYX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 07:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhJJLYX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 07:24:23 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF1C061570
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:22:24 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id w10so15028540ilc.13
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BPph+Hzyhz1qmZ5t4uXozBRqPeOLy4y7NG6FhF66IKc=;
        b=XR/KtQxZlMK2pkCJv2yz8gSHkWs0SXzozjXHZ3jAW2sHBZbItZkPi/G/YQEnr2aQ5N
         t0pD45wXjhlBCSybxhqoEZrDIlax1pAGrpyAQUoR7XfWZwts0ZaiXha8UhlH7iWdXxSv
         Wy+y2ay5knnokbG76miZSxNkgdKo4VKGpgZUN1KLnhDP7+rV3329KIAvHeB0rAgeFTzd
         KITfAgdF1VsqgMbim6deex1a2CvyiQ+o5KbpLvivTaj9vfHTSRs//9XYqimF8ML25sKl
         SVAipQfvv1Ay3Vhatsiot2jOC4UUXpWr8hDhRcVwT+srBwlISu10sCG/bwA9vLAEaxEs
         jQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BPph+Hzyhz1qmZ5t4uXozBRqPeOLy4y7NG6FhF66IKc=;
        b=q32Z+QM5AknvuXo/BX1jPyHGIrIA6dNagE+q61p1nXH91HI97m/qj4/wQx5dAP74Xw
         Ma/yH4n0/nWdCPFzI0KiZ/Wi5BqtXX5GsaC4mOXwEvkpIxkC5yXiy1sOYe9S8P/zMkWl
         RyiEEJGSxe7SAmlmo9TtO44V7PEAmYE3ULyjDfskiM+iRJapyTjdCzX9lxeREOr7+A51
         bmE+LdYBB56/m+bNnJSiaoq7dCINRVr3upXiz04zAUnYhHPSGY4sdrh3L8SgfqMJDzid
         i1/Xc42w1oIew+uE4Hoe4d2M1Uo+qE69Y+ncSrNB863t+BV31TZK+HJ2K0+nsnQZnoG+
         Rvgg==
X-Gm-Message-State: AOAM532Wjyz+cqb7dXOFIHgezE2PtwtIzLYpLXkXYM6JXdskQ3OpsUBx
        RPEoL2PRVVJfkfrISTX5WaMbZQ==
X-Google-Smtp-Source: ABdhPJyewyQ95Zm7SHW551hAwfaUeEqB/31++A/Qb3EFWAfu/P1LQV9SuERRdiBei3GMYwjX99Fzww==
X-Received: by 2002:a05:6e02:170a:: with SMTP id u10mr14304182ill.275.1633864944093;
        Sun, 10 Oct 2021 04:22:24 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r13sm2653156ilb.39.2021.10.10.04.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 04:22:23 -0700 (PDT)
Subject: Re: [PATCH v2 liburing 4/4] Add CONFIG_NOLIBC variable and macro
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
 <20211010063906.341014-5-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40785e6a-5871-2830-4a8c-c43c26207ac2@kernel.dk>
Date:   Sun, 10 Oct 2021 05:22:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211010063906.341014-5-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/21 12:39 AM, Ammar Faizi wrote:
> For conditonal variable and macro to enable nolibc build.
> Add `--nolibc` option for `configure` to enable it.
> 
> Link: https://github.com/axboe/liburing/issues/443
> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> ---
>  configure    |  8 ++++++++
>  src/Makefile | 13 ++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/configure b/configure
> index 92f51bd..6712ce3 100755
> --- a/configure
> +++ b/configure
> @@ -24,6 +24,8 @@ for opt do
>    ;;
>    --cxx=*) cxx="$optarg"
>    ;;
> +  --nolibc) liburing_nolibc="yes"
> +  ;;
>    *)
>      echo "ERROR: unknown option $opt"
>      echo "Try '$0 --help' for more information"

This also needs an addition in the configure --help section.

> diff --git a/src/Makefile b/src/Makefile
> index 5e46a9d..290517d 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -32,11 +32,22 @@ endif
>  
>  all: $(all_targets)
>  
> -liburing_srcs := setup.c queue.c syscall.c register.c
> +liburing_srcs := setup.c queue.c register.c
> +
> +ifeq ($(CONFIG_NOLIBC),y)
> +	liburing_srcs += nolibc.c
> +	override CFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector
> +	override CPPFLAGS += -nostdlib -nolibc -nodefaultlibs -ffreestanding -fno-stack-protector
> +	override LINK_FLAGS += -nostdlib -nolibc -nodefaultlibs
> +else
> +	liburing_srcs += syscall.c
> +endif

If I build this with clang, I get a lot of:

clang: warning: argument unused during compilation: '-nolibc' [-Wunused-command-line-argument]

Apart from this reply and the little language tweaks I suggested, I
think this now looks good. If you can respin with these things fixed,
let's get it applied.

-- 
Jens Axboe

