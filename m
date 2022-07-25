Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F293580851
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 01:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiGYXhG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 19:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiGYXhF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 19:37:05 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233E3627D
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 16:37:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o12so11752836pfp.5
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 16:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xvwCJiaTIkm9Ti6chMfLFDhU7LcrceBALXH+h88zd44=;
        b=AlAFMG6yHZC1U9fw8DQLdF/JA9Rw3M/JFlpGG537qBLlc+NEpvCvocSxG8UGzRJBma
         XMlfx/zZNmd5ZzE11Vv5XmPmkqSaHVvXxviDuJxTj6Ma9fDdMgQ5rPOI4FdfhSxRZndZ
         ez6jgguh/k2k5B7XwSYMTE/pdNnSxnVAU6KKqNoiPwxrfCLU0/ffACzOQ4d38W3juAeO
         mJOOwyY4aok9tco7hEBHlnLTq2klSpsRJgMIY2koiy+A6SuIVVLnwsKWA/rrq7Fdb++M
         sJcG8JCS306pbd4J/wLD10QFf/WVHYY6HK+QeIRiXnQJjjCiTFwJohscIIepQdX9NN4T
         UcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xvwCJiaTIkm9Ti6chMfLFDhU7LcrceBALXH+h88zd44=;
        b=5A38gkIXhJBnjPfgkZxwtcS7JIqvz5lBOmDNAbwO2X/trwbJyDKmsoYN8hjUjETPhc
         WbICu8NgfC/suO+dpe7SOvIXDbbQBTfIEkbOE61+u++eX2akKfIXRORVviCwISUfUZP+
         2T1phIKShWWcsmn0VgogY8TPev95Vxkd5xb+kebGaSj06ryG5L8rhL/D66/nBE4uTzzI
         QYjb2LMhXle/bb2AoRHKheSZ+New3zoxSr48hqY+X7t5ZuxASh5DXhGcEiBkQ4EaRBOw
         ISqkT9jRp+0MwtHL7t/mlbGda46D1le6RUolBHeBtQU27DCcfRif+STvfpIkW/+oGA7d
         Mhzw==
X-Gm-Message-State: AJIora8gt8ub0uXReF5GEdR8lSd1QOUVPi/5QBVhlLZKlQSUKJcxq2Ej
        Cn2WHYFRsGYn9MUxCr/TU6aCxbep4yVXTg==
X-Google-Smtp-Source: AGRyM1tr9X8UP2rkpNNpN+/+jMu4Vj3GKz95zYstPw159/+xdGvAIQIfWv9qLdSyp/d75iKVf5kAHQ==
X-Received: by 2002:a05:6a00:1d26:b0:52b:f8ab:6265 with SMTP id a38-20020a056a001d2600b0052bf8ab6265mr6841061pfx.54.1658792224583;
        Mon, 25 Jul 2022 16:37:04 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090301cc00b0016d10267927sm9854700plh.203.2022.07.25.16.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 16:37:04 -0700 (PDT)
Message-ID: <eb9f8e37-a3b5-0b87-4f90-7ec80772e3fb@kernel.dk>
Date:   Mon, 25 Jul 2022 17:37:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and
 notifications
Content-Language: en-US
To:     Eli Schwartz <eschwartz93@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
 <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
 <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com>
 <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org>
 <7f146700-ad7a-08b2-ecb8-c88d4f57a8eb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7f146700-ad7a-08b2-ecb8-c88d4f57a8eb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 12:55 PM, Eli Schwartz wrote:
> T_EXIT_ERROR is different. It doesn't mean the test ran, and reported
> something wrong with the software (e.g. liburing). Instead, an ERROR
> return value indicates that the test itself broke and cannot even be
> relied on to accurately test for a bug/regression. For example, if that
> test was designated as an expected failure, it still knows that in this
> case, error != fail, and it won't ignore the result as an expected failure.
> 
> Also in general, if you see test errors you know to look at bugs in the
> testsuite instead of trying to debug the software. :)
> 
> I added T_EXIT_ERROR because it may be useful, without knowing in
> advance whether I would have cause to use it anywhere. It's a valid
> possible state.

I think we should kill that, it just causes confusion and I generally
hate adding infrastructure that isn't even being used. Besides, I don't
see it being useful at all. Yes, tests could eg return T_EXIT_ERROR if
io_uring_get_sqe() return NULL and it should not have. In reality,
that's just a test failure and you need to look into why that happened
anyway.

As such, I don't think it's a useful distinction at all. Nobody is ever
going to be writing tests and be making that distinction.

-- 
Jens Axboe

