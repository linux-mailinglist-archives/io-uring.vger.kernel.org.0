Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55D5AADE8
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiIBL4f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiIBL4e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:56:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D27B02B6
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:56:33 -0700 (PDT)
Received: from [192.168.230.80] (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 4B31680C2C;
        Fri,  2 Sep 2022 11:56:31 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662119792;
        bh=HjK02FHa1biG0GeMeuI3ThCWizdIm4aEr7iSiHbM9XE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hT0X/HQXtH6V4i79u2fAbI0cnCWh+C9Ex6TSRxNDrGHEwUODg60Og3vEgTQHj48HV
         u/QM/8OgpQ2V7vCrN0AngMJgyW/9pg8t9ZVZAsXACwx4QnCIv4zR319CH3xXxJFet6
         S0Gm/TUJQZ1XXo7nH1XtkLLmUKsRMf+q47lfyIE4dj0vnrgspjhEzKzitb6/nqQ1gn
         1bJsf8GokfZ1c6h5E9Rtt0p7Ud1Sap5dT/9KFoDyLMuLSprOiFfRFADc8aFyGayCsf
         QoXy6rJZlsMjWgy0L8/0Gkasbo4zGhVKAadla1b1dI8QWuXZWQyeU1ybqyWlKGJc7g
         PZzk3zdM/RfhA==
Message-ID: <5aa07bf0-a783-0882-0038-1b02588c7e33@gnuweeb.org>
Date:   Fri, 2 Sep 2022 18:56:28 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/4] zerocopy send API changes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1662116617.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <cover.1662116617.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 6:12 PM, Pavel Begunkov wrote:
> Fix up helpers and tests to match API changes and also add some more tests.
> 
> Pavel Begunkov (4):
>    tests: verify that send addr is copied when async
>    zc: adjust sendzc to the simpler uapi
>    test: test iowq zc sends
>    examples: adjust zc bench to the new uapi

Hi Pavel,

Patch #2 and #3 are broken, but after applying patch #4, everything builds
just fine. Please resend and avoid breakage in the middle.

Thanks!

--------------------------------------------------------------------------------
Patch #2

   send-zerocopy.c:152:9: error: call to undeclared function 'io_uring_register_notifications'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   ret = io_uring_register_notifications(&ring, 1, b);
                         ^
   send-zerocopy.c:152:9: note: did you mean 'io_uring_register_restrictions'?
   ../src/include/liburing.h:181:5: note: 'io_uring_register_restrictions' declared here
   int io_uring_register_restrictions(struct io_uring *ring,
       ^
   send-zerocopy.c:185:16: error: use of undeclared identifier 'IORING_RECVSEND_NOTIF_FLUSH'
                           zc_flags |= IORING_RECVSEND_NOTIF_FLUSH;
                                       ^
   send-zerocopy.c:194:5: error: call to undeclared function 'io_uring_prep_sendzc_fixed'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                                   io_uring_prep_sendzc_fixed(sqe, fd, payload,
                                   ^
   send-zerocopy.c:194:5: note: did you mean 'io_uring_prep_read_fixed'?
   ../src/include/liburing.h:405:20: note: 'io_uring_prep_read_fixed' declared here
   static inline void io_uring_prep_read_fixed(struct io_uring_sqe *sqe, int fd,
                      ^
   send-zerocopy.c:199:5: error: call to undeclared function 'io_uring_prep_sendzc'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                                   io_uring_prep_sendzc(sqe, fd, payload,
                                   ^
   send-zerocopy.c:199:5: note: did you mean 'io_uring_prep_send_zc'?
   ../src/include/liburing.h:701:20: note: 'io_uring_prep_send_zc' declared here
   static inline void io_uring_prep_send_zc(struct io_uring_sqe *sqe, int sockfd,
                      ^
   send-zerocopy.c:260:9: error: call to undeclared function 'io_uring_unregister_notifications'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   ret = io_uring_unregister_notifications(&ring);
                         ^
   send-zerocopy.c:260:9: note: did you mean 'io_uring_register_restrictions'?
   ../src/include/liburing.h:181:5: note: 'io_uring_register_restrictions' declared here
   int io_uring_register_restrictions(struct io_uring *ring,
       ^
   5 errors generated.
   make[1]: *** [Makefile:36: send-zerocopy] Error 1
   make[1]: *** Waiting for unfinished jobs....
   make[1]: Leaving directory '/home/runner/work/liburing/liburing/examples'
   make: *** [Makefile:12: all] Error 2
   Error: Process completed with exit code 2.


--------------------------------------------------------------------------------
Patch #3:

   send-zerocopy.c: In function ‘do_tx’:
   send-zerocopy.c:152:23: error: implicit declaration of function ‘io_uring_register_notifications’; did you mean ‘io_uring_register_restrictions’? [-Werror=implicit-function-declaration]
     152 |                 ret = io_uring_register_notifications(&ring, 1, b);
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                       io_uring_register_restrictions
   send-zerocopy.c:185:37: error: ‘IORING_RECVSEND_NOTIF_FLUSH’ undeclared (first use in this function); did you mean ‘IORING_RECVSEND_POLL_FIRST’?
     185 |                         zc_flags |= IORING_RECVSEND_NOTIF_FLUSH;
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                     IORING_RECVSEND_POLL_FIRST
   send-zerocopy.c:185:37: note: each undeclared identifier is reported only once for each function it appears in
   send-zerocopy.c:194:33: error: implicit declaration of function ‘io_uring_prep_sendzc_fixed’; did you mean ‘io_uring_prep_read_fixed’? [-Werror=implicit-function-declaration]
     194 |                                 io_uring_prep_sendzc_fixed(sqe, fd, payload,
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                 io_uring_prep_read_fixed
   send-zerocopy.c:199:33: error: implicit declaration of function ‘io_uring_prep_sendzc’; did you mean ‘io_uring_prep_send_zc’? [-Werror=implicit-function-declaration]
     199 |                                 io_uring_prep_sendzc(sqe, fd, payload,
         |                                 ^~~~~~~~~~~~~~~~~~~~
         |                                 io_uring_prep_send_zc
   send-zerocopy.c:260:23: error: implicit declaration of function ‘io_uring_unregister_notifications’; did you mean ‘io_uring_register_restrictions’? [-Werror=implicit-function-declaration]
     260 |                 ret = io_uring_unregister_notifications(&ring);
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                       io_uring_register_restrictions
   cc1: all warnings being treated as errors
   make[1]: *** [Makefile:36: send-zerocopy] Error 1
   make[1]: *** Waiting for unfinished jobs....
   make[1]: Leaving directory '/home/runner/work/liburing/liburing/examples'
   make: *** [Makefile:12: all] Error 2
   Error: Process completed with exit code 2.

-- 
Ammar Faizi
