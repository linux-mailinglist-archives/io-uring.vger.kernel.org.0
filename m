Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4644562E389
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 18:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiKQRxf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 12:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240254AbiKQRxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 12:53:11 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0998A7FC2F
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 09:53:07 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 446AD81652;
        Thu, 17 Nov 2022 17:53:05 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668707586;
        bh=l5xMKBZdppFPi4ovTtvIyXdvrR8vUBABu4PUQKmz+P4=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=MX6eq/8vkSWs+ws46lgC+JQMqQEGzdtIi+3qcDWkDyaKSvTXVNhMoNm6aAQdFjSfn
         3MBKOG4QwZO3387wXFNixVbWh3JO3FxI8jFg2JGEkFMn8bId1Ht/t1CipJq+yq7zGm
         cLkkGzsNvMYg/p5M+Pq7qJtcorOwpRg5Bdl1KRSYkaTDkdsvfC7c6ETcuW9bQBGqJk
         tNTUnBDVKNh+ToT57iWNSaTjzAgXjWCExu61YIL3HhcoCFoQic9Sl3y+ZRBfTzqvp4
         CUgb9LqGTudl0GX7fMqfdGqVnV5ARn5bMDq9sqXJ/bkfxrY42cK5ueoq501XqUjtkj
         TjPNNbS/WJqrw==
Message-ID: <085800fc-184f-3e94-930f-a5f9d4a91d34@gnuweeb.org>
Date:   Fri, 18 Nov 2022 00:53:02 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1668630247.git.metze@samba.org>
 <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v2 1/1] uapi:io_uring.h: allow linux/time_types.h to be
 skipped
In-Reply-To: <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/17/22 3:25 AM, Stefan Metzmacher wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 551e75908f33..082020257f19 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -10,7 +10,15 @@
>   
>   #include <linux/fs.h>
>   #include <linux/types.h>
> +/*
> + * this file is shared with liburing and that has to autodetect
> + * if linux/time_types.h is available or not, it can
> + * define UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
> + * if linux/time_types.h is not available
> + */
> +#ifndef UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
>   #include <linux/time_types.h>
> +#endif
>   
>   #ifdef __cplusplus
>   extern "C" {

I admit the v1 was a stupid mistake. Sorry for that. Now this change
should not have any effect on the kernel code.

Only apps that use io_uring.h and put:

   #define UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H

before the #include will get the effect, which Stefan will do in
liburing once this one gets accepted.

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

