Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338AF58240A
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 12:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiG0KTV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 06:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiG0KTT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 06:19:19 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0817C41D3C
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 03:19:19 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id BC8177FA25;
        Wed, 27 Jul 2022 10:19:15 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658917158;
        bh=653IlshF3loul+oCTWxJfCAm/kdxAy953Myh73F1Bak=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=l53A+ix4ljKYiPH7E5arzbq+6qo0M8fxiCgT5VCyOrG9mVGYYBfNClOqLaF9iDNMB
         TPwR4n2Tt55NOaOQ7/2AiXQZIIh05KKK3HJGpXExAyCdwCf3Rxs5O+hAR/kCWGGvj5
         dPDoTuUYx7x98cYZ9GskesW3uY9GiBRwyfHr/TT+3xLTPHAm/tor34+B3UGL4zpw+7
         MB+nR40oueJ5w2H0nQS7s+NAvOxTQTqfsmWxtzRCnA152p/r1eLzclYsVjcVznNoDv
         ZXnmVXdOyx62E1PGHkn2tlEHzGcz+5EU0RTAArSXIa/4kYakEw8NRCQ5St4oLjk5pL
         CNVoBANGo5T7Q==
Message-ID: <de92e7c3-ff9f-0d0c-19be-936383bc63c9@gnuweeb.org>
Date:   Wed, 27 Jul 2022 17:19:12 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
 <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
 <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
 <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
 <e126981a-c4c1-ca53-b98e-63ba1322f675@kernel.dk>
 <30e8595a4570ff37eb04cb627f64b71a5f948fd5.camel@fb.com>
 <dcb072b9-89d8-bc9d-1f79-daaa7b51cbe1@gnuweeb.org>
 <9f3afabb-9c6b-4da4-c235-d02cd2142162@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <9f3afabb-9c6b-4da4-c235-d02cd2142162@gnuweeb.org>
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

On 7/27/22 5:11 PM, Ammar Faizi wrote:
> So -D_GNU_SOURCE is the culprit. It seems to be unavoidable as
> the warn seems to be compiler specific or something. Maybe that
> _GNU_SOURCE patches the definition of bind().

I did:

   gcc -E -D_GNU_SOURCE test.c -o xtest.c

and examined the xtest.c output.

So basically when we use _GNU_SOURCE, sometimes the declaration of
bind() is like this:

extern int bind (int __fd, __CONST_SOCKADDR_ARG __addr, socklen_t __len)
      __attribute__ ((__nothrow__ , __leaf__));

With __CONST_SOCKADDR_ARG being a union:

typedef union {
     const struct sockaddr *__restrict __sockaddr__;
     const struct sockaddr_at *__restrict __sockaddr_at__;
     const struct sockaddr_ax25 *__restrict __sockaddr_ax25__;
     const struct sockaddr_dl *__restrict __sockaddr_dl__;
     const struct sockaddr_eon *__restrict __sockaddr_eon__;
     const struct sockaddr_in *__restrict __sockaddr_in__;
     const struct sockaddr_in6 *__restrict __sockaddr_in6__;
     const struct sockaddr_inarp *__restrict __sockaddr_inarp__;
     const struct sockaddr_ipx *__restrict __sockaddr_ipx__;
     const struct sockaddr_iso *__restrict __sockaddr_iso__;
     const struct sockaddr_ns *__restrict __sockaddr_ns__;
     const struct sockaddr_un *__restrict __sockaddr_un__;
     const struct sockaddr_x25 *__restrict __sockaddr_x25__;
} __CONST_SOCKADDR_ARG __attribute__ ((__transparent_union__));

But not all header file included by the compiler has this union stuff.
When it doesn't, it will throw a warning like that.

-- 
Ammar Faizi
