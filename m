Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C28D656973
	for <lists+io-uring@lfdr.de>; Tue, 27 Dec 2022 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiL0K0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Dec 2022 05:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiL0KZ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Dec 2022 05:25:58 -0500
X-Greylist: delayed 1148 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Dec 2022 02:25:15 PST
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED540A459
        for <io-uring@vger.kernel.org>; Tue, 27 Dec 2022 02:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=MXvoBodU7OzQI8mpNoakyjVd/kHwKN1N+9v2gAsf+uc=; b=RJZu56YBIO3+3pUl/aebCYdqYF
        3A8GvE3DFjA7IvNLzRFgUZ7gzuFmq/ocfHQyx+nWskWiBqAxEJMe4XFykIeYG8F0EsTAjcpQx8PLi
        3+g5MyTuG/lzs5wZktlJKHo5zrnCuAAGTvPJTPr/f5h1AePIilTx5NJaeYpWcaQwLLhVPB0qYIzLY
        73Stzt2ioA7x3XjIj3VS0EQc9CQWsXmoZDpIBVfqCKo3/7DfhG7LIQiuw+Q4U0JX75U8AzlM8B7jG
        lPDWkG4rllfnAZRZnqE9ALK2jjDoYNoHaA/yHaLAh7bbSUBm8W+0JNfMigoF8jP9TROYipAvOAhv8
        4IZsz2q/QtPS1GzShwitcLvlG2/ogfsqD+JNRCYcabIT6h8JZQN0woVZ0sKxaERZFcCJa3ZCXYpsu
        alQGZ94Aw2GQLTTwF7Wo029qMMbsvuBn1+zjZkPQymYTJcLGB/Olx+iC9jW6BCehSoKPzUWvynIaG
        8sQ388H9CQ0thooJ0eaLY2im;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pA6qS-005d3t-UF; Tue, 27 Dec 2022 10:06:05 +0000
Message-ID: <e9d31456-c819-4c4f-b6d5-43507e7e0494@samba.org>
Date:   Tue, 27 Dec 2022 11:06:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/1] uapi:io_uring.h: allow linux/time_types.h to be
 skipped
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Ammar Faizi <ammarfaizi2@gnuweeb.org>
References: <cover.1668630247.git.metze@samba.org>
 <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
Content-Language: en-US, de-DE
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

any chance to get this merged?

metze

Am 16.11.22 um 21:25 schrieb Stefan Metzmacher:
> include/uapi/linux/io_uring.h is synced 1:1 into
> liburing:src/include/liburing/io_uring.h.
> 
> liburing has a configure check to detect the need for
> linux/time_types.h. It can opt-out by defining
> UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
> 
> Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
> Link: https://github.com/axboe/liburing/issues/708
> Link: https://github.com/axboe/liburing/pull/709
> Link: https://lore.kernel.org/io-uring/20221115212614.1308132-1-ammar.faizi@intel.com/T/#m9f5dd571cd4f6a5dee84452dbbca3b92ba7a4091
> CC: Jens Axboe <axboe@kernel.dk>
> Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   include/uapi/linux/io_uring.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
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

