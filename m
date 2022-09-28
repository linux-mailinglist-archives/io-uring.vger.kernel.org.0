Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52AA5EE828
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 23:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbiI1VRc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 17:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiI1VRL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 17:17:11 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAEF24089
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 14:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=WwklDmNBEnXvAFSooZFCGaVrwqz5bG6nIaC5QSBAdWU=; b=YtHQ5bc2zxUWOi9H5DiBJStaB1
        E1QKTJVqWY9QHzl2efkUchc1JGm5bZ38lV0SEy6H58pQiWym8HfvyyidPxufvrg5qFk1derFlTfRr
        oUkI1VOu473yJiKu5vZkw+BpzIjdLKLgb6Ye0KRzFthFpDVt1OjTdcMphYd5yyWeZqBbpb9XGICA9
        GZeXcO+z8pJTAXsgn15mjPwgIVP9rwhsDnJwNvQPaKAqnvY6gR/rpr21j1g8rI4jTHj10VxuF6fjA
        +fnkNHmxMW8GyYnhClai4L0Z51gF0A/OZtEAFQayHmuS/gOMzMktsBeBPz8/q3gvC9NJsn5mWLSsy
        nw5HM5QfsngqZOmkX4LyxLy0hATBgtp9lA03tMVlKnPmunUv8u0LIqJBgPlzK3gL7uu2+PkfFAgXG
        zRXdE9bU9+1V0amYhYNjkmaovMkyKoV0c1DpWoMJ0zI85T5hDhXx1pLDg0pozTS3v8JyWWteWB7I7
        CEfJdYfYWVnf5Z5z/yE7D7tB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1odeL2-002H96-R2; Wed, 28 Sep 2022 21:11:28 +0000
Message-ID: <55ed62be-e300-d961-3a9c-c75b0ed59318@samba.org>
Date:   Wed, 28 Sep 2022 23:11:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] io_uring/poll: disable level triggered poll
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <68178467-39c2-adb9-0358-4587ef01cf4a@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <68178467-39c2-adb9-0358-4587ef01cf4a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> Stefan reports that there are issues with the level triggered
> notification. Since we're late in the cycle, and it was introduced for
> the 6.0 release, just disable it at prep time and we can bring this
> back when Samba is happy with it.
> 
> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Also reviewed by me.

Thanks!
metze
