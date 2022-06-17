Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1917654F6CC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 13:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381630AbiFQLgx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 07:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380246AbiFQLgx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 07:36:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24A26A06B
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 04:36:51 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o6so3658583plg.2
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 04:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=0TlSppUangN+koeQ9qRptnVYYcxY+JAcx6jBYALw1kk=;
        b=TujYdMJYOudZkpUQ1m8Yu5OIH0yn2iAj3WmjxMqIlGrI2FRKV3iwgWQz8Z5dsvVB05
         fWeaow9klrPhvWkBR8c20dA+rFk62fCiGW3YPQh4VCIv8qOmbjWm/8sycuL7miSDTQEF
         gnAKoBObs4u0EItCSKz1zkT43C69hJyqQYq5iFzDFngM/zhKdoDG+dUkbqo7ZGNKTXd2
         W7YmXMmqSRFhdrqWjZmqdHdreUQsDVscJzlTtmPcHDb9JXmWXtoVx9vBqJI7Xjxxl/2h
         F98vbfBIHBXgaOvsoJGzjrGeaXO2/lrz0/UAVWwfZ/DPVRsfMSfnIHoJzjGe05Ts6S7g
         XbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0TlSppUangN+koeQ9qRptnVYYcxY+JAcx6jBYALw1kk=;
        b=L0Mlc6qs2XF2+R56H+WC2TjJpjgqFoczkFm6MBCgX6Xe0nEVxmA4WOl0pSG9C6d92n
         cgu+QXC7gGCxowkmOILlSjNV56Uj1R75Lzt/jqCZufl5rjCg9YrGZix8qaeeDtZwaQ+U
         hE7YdI9qIAND/5UNwXOy2koyQ/PzleoWjCeiZD52wpPAs4BDRRO4WoYR3N6oaCndMlxi
         DWKEqq0Iu5v0cGX2MQ+15HiGE/j0WE+HlPOtHiybvT0xSal5S4s16IAQaXn7VtumN7HY
         L7ruD4HoytXB5wJDuuw3ABvxKBGEaj4dLiuI/QBJuGWiZIBd27QpOI9nYkvO4V6M7acj
         hu+Q==
X-Gm-Message-State: AJIora/UPfBc1M2Xs6AhPamL0x14QLBKkkkw68ftQAiK2mCqUi8L3WoT
        awk4ZqZRXMFy+/VGYBuDp6pxdg==
X-Google-Smtp-Source: AGRyM1tgF3BM6ToBZKzMb3FNrucyVHS8/BbrHbqiLywObJtLNTME8Ed9xamycWX+bwhyedlrMWbklQ==
X-Received: by 2002:a17:90b:1bcd:b0:1e2:c8da:7c29 with SMTP id oa13-20020a17090b1bcd00b001e2c8da7c29mr21062783pjb.4.1655465811265;
        Fri, 17 Jun 2022 04:36:51 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b14-20020a17090a6ace00b001e280f58d02sm3085593pjm.24.2022.06.17.04.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 04:36:50 -0700 (PDT)
Message-ID: <f143f6a6-5378-d1c4-e4c9-c6569ede78ba@kernel.dk>
Date:   Fri, 17 Jun 2022 05:36:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing 2/2] tests: fix and improve nop tests
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655455225.git.asml.silence@gmail.com>
 <92f01041e5ef933a6018bd89dd54cc1fae57c6f6.1655455225.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <92f01041e5ef933a6018bd89dd54cc1fae57c6f6.1655455225.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/22 2:42 AM, Pavel Begunkov wrote:
> We removed CQE32 for nops from the kernel, fix the tests and instead
> test that we return zeroes in the extra fields instead of garbage.
> Loop over the tests multiple times so it exhausts CQ and we also test
> CQ entries recycling and internal caching mechanism. Also excersie
> IOSQE_ASYNC.

Yes that's not a bad idea, thanks!

-- 
Jens Axboe

