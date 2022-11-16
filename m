Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E0B62B91F
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 11:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiKPKjC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 05:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiKPKhF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 05:37:05 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC3F248C4;
        Wed, 16 Nov 2022 02:29:04 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id DF66781608;
        Wed, 16 Nov 2022 10:29:01 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668594544;
        bh=kv9K+eAhAgOOw0umGQi03iVhUmWyfNCkW9m4Mftth3g=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=trQ9/M+3ji+3a/I+q60BkllYOjDYTF9KUHB879BeU/UdHMv27SKOgecsxicPh2qMW
         AqCPYREloFoWHfrdNc7rXVz5K50OtbtOIY2iG+Xu2+rN0+lshWVf/wgraPoBLGwYa+
         vVoMKEhhgJExkiVpW4/0QYhkvdMqDW+N/zdr2Kq/bowPsRn3CTAFLna5O5nyYC/34J
         BtEeNtxJaaP64WmIT/uQf8vPhctUFncFCMFHgmUHApiF3pnPshb7MW8Rof1AH2mmE3
         eV10CZzp0P5JBK3TH/4l9nC7JFIqRIyjNPqoS3gPSKWiS3W6IXiWtkDvzzVSU8koW6
         Li+rtFiU2VnuQ==
Message-ID: <cd9642a2-3f09-46c8-51bc-2c359b8b3f0b@gnuweeb.org>
Date:   Wed, 16 Nov 2022 17:28:58 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <20221115212614.1308132-3-ammar.faizi@intel.com>
 <63a47e31-6d30-6dad-7b8d-1f14a7bd8fd5@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v1 2/2] io_uring: uapi: Don't use a zero-size array
In-Reply-To: <63a47e31-6d30-6dad-7b8d-1f14a7bd8fd5@gmail.com>
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

On 11/16/22 5:14 PM, Pavel Begunkov wrote:
> On 11/15/22 21:29, Ammar Faizi wrote:
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> Don't use a zero-size array because it doesn't allow the user to
>> compile an app that uses liburing with the `-pedantic-errors` flag:
> 
> Ammar, I'd strongly encourage you to at least compile your
> patches or even better actually test them. There is an explicit
> BUILD_BUG_ON() violated by this change.

Oh yeah, I didn't realize that. This patch breaks this assertion:

   BUILD_BUG_ON failed: sizeof_field(struct io_uring_sqe, cmd) != 0

This assertion wants the size of cmd[] to be zero. Which is obviously
violated in this patch.

I only tested a liburing app that uses this header and validated
that the struct size is the same, but not its field. That's my
mistake.

I'm *not* going to send a v2 per Jens' comment.

-- 
Ammar Faizi

