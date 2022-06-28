Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AA955E67F
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbiF1QPe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 12:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346717AbiF1QOq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 12:14:46 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E39A38D92
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 09:10:10 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id A9FE37FC13;
        Tue, 28 Jun 2022 16:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656432609;
        bh=HYTVRzG+ZXV9MylD3iCfHP/1hJN298rVzQ2iEDFDl2Q=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=fdpcw8P0aJBT2MzT6/q8mfhgTZbZYii67fC6PEFIs1d8PGjoYu5fjX0EeTxEBeoWV
         3pcrlVbrJbgGgzPvgrrKveJo9XBd4PiUS1T+nV9dxtr53iTNWMc4ibX0Ago6miziAr
         VVdztD7XoLjcul60TKvIjnCv6McVFMWl98bjEps8HAVKNaEvWYrtn4PUJhNxfYaIk/
         bLXsGBnyIoS3cRTKaN9xjmiCjXfJrx2AQee+SZsBBe7Eye2FNcdA36vYpNDirNof/z
         K5O0X+LAieVaee1ZReDNr91YsoqPaWBaH/Mwyd8OKFhOGAU+8TURVUz924p5tR+edm
         Inarzg2D75HuA==
Message-ID: <684dc062-b152-db2b-1fb9-fbd52e0b21e5@gnuweeb.org>
Date:   Tue, 28 Jun 2022 23:10:01 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220628150414.1386435-1-dylany@fb.com>
 <20220628150414.1386435-3-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 2/4] add IORING_RECV_MULTISHOT to io_uring.h
In-Reply-To: <20220628150414.1386435-3-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 10:04 PM, Dylan Yudaken wrote:
> copy from include/uapi/linux/io_uring.h
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   src/include/liburing/io_uring.h | 53 ++++++++++++++++++++++++---------
>   1 file changed, 39 insertions(+), 14 deletions(-)
> 
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
> index 2f391c9..1e5bdb3 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -10,10 +10,7 @@
>   
>   #include <linux/fs.h>
>   #include <linux/types.h>
> -
> -#ifdef __cplusplus
> -extern "C" {
> -#endif

Dylan,

That `extern "C"` thing is for C++, we shouldn't omit it.

Or better add that to the kernel tree as well, it won't break
the kernel because we have a __cplusplus guard here.

Jens what do you think?

Just for reference, that line is introduced in commit:

   commit 3d74c677c45eccf36b92f7ad4b3317adc1ed06bb
   Author: Bart Van Assche <bvanassche@acm.org>
   Date:   Sun Jun 28 12:58:19 2020 -0700

       Make the liburing header files again compatible with C++

       Include <atomic> instead of <stdatomic.h> if built with a C++ compiler.

       Fixes: b9c0bf79aa87 ("src/include/liburing/barrier.h: Use C11 atomics")
       Signed-off-by: Bart Van Assche <bvanassche@acm.org>
       Signed-off-by: Jens Axboe <axboe@kernel.dk>

  src/include/liburing.h          |  8 ++++----
  src/include/liburing/barrier.h  | 37 +++++++++++++++++++++++++++++++++++--
  src/include/liburing/io_uring.h |  8 ++++++++
  3 files changed, 47 insertions(+), 6 deletions(-)

Adding the author to the CC list.

-- 
Ammar Faizi
