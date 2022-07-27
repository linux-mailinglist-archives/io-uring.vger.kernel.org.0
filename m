Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB22E582395
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 11:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiG0J7U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 05:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiG0J7T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 05:59:19 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABC329800
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 02:59:17 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 86D007FA25;
        Wed, 27 Jul 2022 09:59:14 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658915956;
        bh=TJeeK3FtMTcQXDkf+pWRgY2OKXOu4GIob4sKD2nUpyE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NsyLn+5e6gUjspuxrY6/vyqMec0IVTiCq+812RLXSvzVMJ6mKpBBC0BaEfnq1Ln2k
         YsdoWdHSCcJUNyfnTKbpbAnxnwxFyoEBtWGJvS3uX4LzHP6NyfxrvD37VZ/yPDse6W
         AcRXPYLl27/exHbK18yfYEBX4DIAkBwJjkehtpXgDhn3iB5V5nwIl6iyOKp12GYYyO
         RANxr7Lo/PiEqnsfCq+F5ix9J0iBCaG9Ym1qdYJhDTzFXX9HCsEowKeW3/CfnZLVel
         Bzm+h/4ABfk2p7vXkpgxkpzmIswM9fH2ALX/zlsYL35rwszvL/rfh/lB0RYKOXvDb3
         O6NfAYzYXzanQ==
Message-ID: <dcb072b9-89d8-bc9d-1f79-daaa7b51cbe1@gnuweeb.org>
Date:   Wed, 27 Jul 2022 16:59:10 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
 <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
 <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
 <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
 <e126981a-c4c1-ca53-b98e-63ba1322f675@kernel.dk>
 <30e8595a4570ff37eb04cb627f64b71a5f948fd5.camel@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <30e8595a4570ff37eb04cb627f64b71a5f948fd5.camel@fb.com>
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

On 7/27/22 2:57 PM, Dylan Yudaken wrote:
> Interestingly it did not show up on the Github CI either. What flags
> are you setting for this? Maybe the CI can be expanded to include those
> flags.
> As you say its not the first time you've fixed this, or that I've done
> this.

I use the same flag with the GitHub CI. Just a small experiment here...

I compile this with default compilation flags:

#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>

int main(void)
{
         struct sockaddr_in addr = { };
         return bind(0, &addr, sizeof(addr));
}

===============================================================================

ammarfaizi2@integral2:/tmp$ gcc test.c -o test
test.c: In function ‘main’:
test.c:9:24: warning: passing argument 2 of ‘bind’ from incompatible pointer type [-Wincompatible-pointer-types]
     9 |         return bind(0, &addr, sizeof(addr));
       |                        ^~~~~
       |                        |
       |                        struct sockaddr_in *
In file included from /usr/include/netinet/in.h:23,
                  from /usr/include/arpa/inet.h:22,
                  from test.c:2:
/usr/include/x86_64-linux-gnu/sys/socket.h:112:49: note: expected ‘const struct sockaddr *’ but argument is of type ‘struct sockaddr_in *’
   112 | extern int bind (int __fd, __CONST_SOCKADDR_ARG __addr, socklen_t __len)
       |

===============================================================================

ammarfaizi2@integral2:/tmp$ clang test.c -o test
test.c:9:17: warning: incompatible pointer types passing 'struct sockaddr_in *' to parameter of type 'const struct sockaddr *' [-Wincompatible-pointer-types]
         return bind(0, &addr, sizeof(addr));
                        ^~~~~
/usr/include/x86_64-linux-gnu/sys/socket.h:112:49: note: passing argument to parameter '__addr' here
extern int bind (int __fd, __CONST_SOCKADDR_ARG __addr, socklen_t __len)
                                                 ^
1 warning generated.

===============================================================================

Interestingly GCC also complains here, but it doesn't complain when
compiling your code. Your code only breaks my clang-13.

What is the magic behind this?

We never disable -Wincompatible-pointer-types in liburing either.
It's enabled by default.

-- 
Ammar Faizi
