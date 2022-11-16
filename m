Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B747462B356
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 07:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiKPGfJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 01:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiKPGfC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 01:35:02 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC59DEDE;
        Tue, 15 Nov 2022 22:35:01 -0800 (PST)
Received: from [192.168.88.87] (unknown [125.160.109.228])
        by gnuweeb.org (Postfix) with ESMTPSA id B4C9D80BE8;
        Wed, 16 Nov 2022 06:34:59 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668580501;
        bh=RTkIMOtf0HhfVfKBcaoF8pGYhOmFJpcuCVB8H/b0kAQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=A3gCFSFUVGNXHikFZY0Nkb3SgaZBlFoNnHwCBzgj5HiJOgBnRsjGkeDHg4l3mTnJx
         YSuUW9OORLf+bUDg5/OJRf/Hid97VLux2HmdO4mcGW/QEcRKaL7bnmkdXCa9EvkBpX
         TFDA2LNYI+t7Sydl1jT3o8uVDb95Oa40agzZrlvASyJLVpExmOqQPG4lSIGuWcdRPV
         sKaZiSYLuV20v9MSfJwetdzZRN/vZX6JDZ1oiSRUzmdO87P2riLvGy9x2Ee3Hx1QOZ
         pheBJK1xoFdSbvYNADGt+1MVLlig0ofBqipTr2JRyYyd/Qvg+OqGS0xMgFWZedE+ol
         16UGA4axift+w==
Message-ID: <61293423-8541-cb8b-32b4-9a4decb3544f@gnuweeb.org>
Date:   Wed, 16 Nov 2022 13:34:57 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: (subset) [PATCH v1 0/2] io_uring uapi updates
To:     Jens Axboe <axboe@kernel.dk>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SORBS_WEB,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/22 6:14 AM, Jens Axboe wrote:
> On Wed, 16 Nov 2022 04:29:51 +0700, Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> Hi Jens,
>>
>> io_uring uapi updates:
>>
>> 1) Don't force linux/time_types.h for userspace. Linux's io_uring.h is
>>     synced 1:1 into liburing's io_uring.h. liburing has a configure
>>     check to detect the need for linux/time_types.h (Stefan).
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/2] io_uring: uapi: Don't force linux/time_types.h for userspace
>        commit: 958bfdd734b6074ba88ee3abc69d0053e26b7b9c

Jens, please drop this commit. It breaks the build:

All errors (new ones prefixed by >>):

    In file included from <command-line>:
>> ./usr/include/linux/io_uring.h:654:41: error: field 'timeout' has incomplete type
      654 |         struct __kernel_timespec        timeout;
          |                                         ^~~~~~~

-- 
Ammar Faizi

