Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A064222C9A
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgGPUSd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPUSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:18:32 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A653C061755;
        Thu, 16 Jul 2020 13:18:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so11479216wmh.4;
        Thu, 16 Jul 2020 13:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hT1ysO8UtcshQI1jXyBj8JCzEF++nOcaQlKMyGdyebI=;
        b=gPyJXh21xqwg6wi5lQgsCnsHNHIw9zktYFEeZM4/dwWJwAfEuNc0aXHghzkPptrEiu
         cAh9PlzMYLW0zPNTVC+VV8PCDQUjKDgyhyjllp/rVI5iLFzOi7t7aWFaFO8xCxODZEkU
         u8/Y+QJ5lc/6Ty/GTE/GXgFOZ/loWYpedar5hfUCbuagq5kvlrFQxbjpLbLzd4Zeyhw4
         R81cod5MZcfun9atECCis6ywDNt9vo6LS0fiJx8oiusJNMeNe7us4GOjM5yrg9NPkNpl
         k/KDljEdwh3CfUFlMWz+dMFc4sdS7diIT8HcyIyDelxqrIAODpPXuPuzOI7w8a1Q9Xdz
         YJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hT1ysO8UtcshQI1jXyBj8JCzEF++nOcaQlKMyGdyebI=;
        b=pTajQw3UbO56Wk5by9fQIIigUYtbc6TWmOO0s6DLBfh+QzyctO/78qsEZC/8DdUA7M
         KmnOvzngfMNZM2gX2V/A3sBUY1L3MPyyLI1MzvyQN/1q/HqvTG41ULV1pA2vFsnyiFRq
         9Y3wVnntOowTIjO2Fn+DMf/0ND5A7zvTCSsihmEIZs261KrnUscIhX3BY/86u7cPy8tB
         bkLdduwodFoKe2ychd9jIeoEXIOkm9m5cxbUvVaa1/wm5KxHnzElOoUBfL/9DZ4c4+JX
         rmTFl6kDRP4zT0qyE9t0CDfbj/d7z15NLmVpv72xEYoblBdlSgo9kqtY5D+yBd0+ueEX
         vO6g==
X-Gm-Message-State: AOAM530FmgkopV3Byn1dbNBz/uM8QpvMUkBQ51WJ8BbNbS7Z4ZljMYMH
        hdIb74TaqesI3SRl2SZ//grlDqSn6w8=
X-Google-Smtp-Source: ABdhPJw8nV+8IAqaXqIGkoX8kBdfOHm2J50mIVqOpgcP41uZ6JJSTEB1svlXncB9MoytaJ+z1MBJWw==
X-Received: by 2002:a7b:cc92:: with SMTP id p18mr6057089wma.4.1594930710261;
        Thu, 16 Jul 2020 13:18:30 -0700 (PDT)
Received: from [192.168.43.238] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id k18sm10805024wrx.34.2020.07.16.13.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 13:18:29 -0700 (PDT)
Subject: Re: [PATCH RFC v2 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-2-sgarzare@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ca242a15-576d-4099-a5f8-85c08985e3ff@gmail.com>
Date:   Thu, 16 Jul 2020 23:16:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200716124833.93667-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/07/2020 15:48, Stefano Garzarella wrote:
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
> index 7843742b8b74..efc50bd0af34 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -253,17 +253,22 @@ struct io_uring_params {
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
> +	IORING_UNREGISTER_BUFFERS,
> +	IORING_REGISTER_FILES,
> +	IORING_UNREGISTER_FILES,
> +	IORING_REGISTER_EVENTFD,
> +	IORING_UNREGISTER_EVENTFD,
> +	IORING_REGISTER_FILES_UPDATE,
> +	IORING_REGISTER_EVENTFD_ASYNC,
> +	IORING_REGISTER_PROBE,
> +	IORING_REGISTER_PERSONALITY,
> +	IORING_UNREGISTER_PERSONALITY,
> +
> +	/* this goes last */
> +	IORING_REGISTER_LAST
> +};

It breaks userspace API. E.g.

#ifdef IORING_REGISTER_BUFFERS

>  
>  struct io_uring_files_update {
>  	__u32 offset;
> 

-- 
Pavel Begunkov
