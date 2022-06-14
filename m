Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1022754B402
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbiFNO5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343980AbiFNO5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:57:42 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCC21BEA8
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:57:31 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.255])
        by gnuweeb.org (Postfix) with ESMTPSA id 42F6A7E6DF;
        Tue, 14 Jun 2022 14:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1655218650;
        bh=MEJJW+HkyNBFC87Q4lUwrv9DsSOg+Mvy7O+1cDGO7hY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oUwIcPhuB3Fu9yjoS8uqpWrgMNwEfX6W2pQn0Hl5dIalmM8PpxOLoQiQQbuZbGTjZ
         IWcaDx1s8tq8phoXjoFTV7Zttx3Y8o6mZ4CAxkH7rwynQILz19Lx60O/6EnvaYmh8P
         /ZdB7WI6B3rIydIPddZocdhKIOm94D8KYFFoRde9kD7g7jgc+3aRwVW5qc+N4nBxyd
         Btd91PvvVKMkxqPskqakI0jPv1/rZZU9vfnTSVptzzxCVvwfM73k3horRs+F0PAeYI
         Ia0uTnhhofie05fzOT4xP9AIL98GpmTRZ52l2QRjqDuQR2/6oRbZzxyeVCCKGuzTiD
         Rjq3DaZgJrfGA==
Message-ID: <1e971a15-3476-1259-ab3b-7c6953d68760@gnuweeb.org>
Date:   Tue, 14 Jun 2022 21:57:26 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing 2/3] examples: add a simple single-shot poll
 benchmark
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1655213733.git.asml.silence@gmail.com>
 <c73aebd699e851a36a8a85e263bedc56aa57e505.1655213733.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <c73aebd699e851a36a8a85e263bedc56aa57e505.1655213733.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SORBS_WEB,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 9:36 PM, Pavel Begunkov wrote:
> +int main(void)
> +{
> +	unsigned long tstop;
> +	unsigned long nr_reqs = 0;
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	struct io_uring ring;
> +	int pipe1[2];
> +	int ret, i, qd = 128;
> +
> +	if (argc > 1)
> +		return 0;
> +

Hi Pavel,

I am testing this and it doesn't compile, the main(void) needs fixing.

```
   poll-bench.c: In function ‘main’:
   poll-bench.c:39:13: error: ‘argc’ undeclared (first use in this function)
      39 |         if (argc > 1)
         |             ^~~~
   poll-bench.c:39:13: note: each undeclared identifier is reported only once for each function it appears in
   make[1]: *** [Makefile:34: poll-bench] Error 1
   make[1]: *** Waiting for unfinished jobs....
   make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/examples'
   make: *** [Makefile:12: all] Error 2
```

-- 
Ammar Faizi
