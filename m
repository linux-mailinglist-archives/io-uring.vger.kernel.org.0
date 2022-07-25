Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6157FD49
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiGYKUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiGYKUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:20:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CFFE70
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:20:10 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id ADC347E257;
        Mon, 25 Jul 2022 10:20:08 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658744409;
        bh=T7MXuOouYZKP2Xr9Bmojh99klK11LObnd+vBt5z5AbM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QSwcYjoPB2GugSqdYjhi8CcyitenSHwdMc/4uQ/hVFyhx0vkeV63sLuIjzrDYb194
         nF0CUQT49HP7Swrk3+BcdAbxCbs4PsmYpOnlFtMdJf+BCSRS6hICF20zo/Yq2yw0t+
         JP1x1qzhGOIZt7nUE0ST5wHw33xu7M3CGFIlvvyJmhyxCgczcZO4emCzKtK4yixo8D
         THhxCCC0tYk6dwi80+/tyAiSLUJmEWIyU/r3Yu5uxO2u6wtAPBXktwIuy1xw1l435X
         HEIrMlD3yXgBRztksMhGd7iMeEkbUl8JzUaDepNjAn3vN9JfL9milvabSlifRHicNY
         xzsTn0hF/Gc+w==
Message-ID: <912620ff-7a2e-80b8-eea4-6f231304e33d@gnuweeb.org>
Date:   Mon, 25 Jul 2022 17:20:06 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 2/4] liburing: add zc send and notif helpers
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <7f705b208e5f7baa6ee94904e39d3d0da2e28150.1658743360.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <7f705b208e5f7baa6ee94904e39d3d0da2e28150.1658743360.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

On 7/25/22 5:03 PM, Pavel Begunkov wrote:
> +static inline void io_uring_prep_notif_update(struct io_uring_sqe *sqe,
> +					      __u64 new_tag, /* 0 to ignore */
> +					      unsigned offset, unsigned nr)
> +{
> +	io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
> +			 (__u64)offset);
> +	sqe->ioprio = IORING_RSRC_UPDATE_NOTIF;
> +}
> +

This part breaks 32-bit architecture.

   include/liburing.h: In function ‘io_uring_prep_notif_update’:
   In file included from syscall.h:14,
                    from setup.c:5:
   include/liburing.h: In function ‘io_uring_prep_notif_update’:
   include/liburing.h:716:59: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
     716 |         io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
         |                                                           ^
   include/liburing.h:716:59: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
     716 |         io_uring_prep_rw(IORING_OP_FILES_UPDATE, sqe, -1, (void *)new_tag, nr,
         |

-- 
Ammar Faizi
