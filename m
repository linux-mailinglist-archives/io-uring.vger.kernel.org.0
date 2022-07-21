Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAFF57CB72
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 15:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiGUNJ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 09:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiGUNI7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 09:08:59 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EAA1FCDE;
        Thu, 21 Jul 2022 06:08:28 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id 0FF2A7E24B;
        Thu, 21 Jul 2022 13:08:24 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658408907;
        bh=8c6DdywAwBIRE/n+UmqEj4dgROYwPvas+8/IzXZ355g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UQ52k7JVTOzrvedUUP/PSYuZMkcAfkJMr0e+KquX36/k7Jo2sPLxv+6JBAmGVhrwF
         rGxxdEqXLAX9/vAhD1yYTfUoRAM3CAV6ZMLHyF3G39jGzSTGo74drkTDCOxx1t4p6Z
         t4FmHtGD9on3Yxd+Z3blwT2ae3MpdYZPnv+LNJLAcivz5Zo8ATK+MJfvU2MgRJg/gA
         8eU3GTuBKYOAq8fswgm/b5Ka27HcSN+rPN67AwX4M3vRRlNPUKdeU5/H7Lpw1/8STD
         I5TgQ1phD5ECE3yTaPYQYC2knUKc9JGxeGd8uFF0Yorpjiy7wIVtKFMnVCinWOZ53p
         DLCqp80spwbAA==
Message-ID: <3761ef37-85fc-de81-b211-39eaf3fe2362@gnuweeb.org>
Date:   Thu, 21 Jul 2022 20:08:19 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
 <3489ef4e810b822d6fdb0948ef7fdaeb5547eeba.camel@fb.com>
 <beae1b3b-eec3-1afb-cdf9-999a1d161db4@gnuweeb.org>
 <e3987a2f55d154a7b217d86d805719043957db60.camel@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <e3987a2f55d154a7b217d86d805719043957db60.camel@fb.com>
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

On 7/21/22 7:05 PM, Dylan Yudaken wrote:
> It seems to be a problem with blocking reads, buffer select and READV.
> My guess is that ext4/xfs are not blocking.
> 
> in b66e65f41426 ("io_uring: never call io_buffer_select() for a buffer
> re-select"), this line was added in __io_iov_buffer_select
> 
> -       iov[0].iov_len = len;
> +       req->rw.len = iov[0].iov_len = len;
> 
> Basically stashing the buffer length in rw.len. The problem is that the
> next time around that breaks at
> 
>          if (req->rw.len != 1)
>                  return -EINVAL;
> 
> 
> The below fixes it as an example, but it's not great. Maybe someone can
> figure out a better patch? Otherwise I can try tomorrow:

It's 8:05 PM from my end. I'll try to play with your patch after dinner
while waiting for others say something.

-- 
Ammar Faizi

