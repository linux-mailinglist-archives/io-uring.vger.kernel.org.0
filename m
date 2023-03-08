Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4306AFD6F
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 04:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCHDdj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 22:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjCHDdf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 22:33:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C788A29E10
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 19:33:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u5so16445035plq.7
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 19:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678246406;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GkqujeajDOVGkFJlXH2eTg70d+LtwBvsMGIszeviqrU=;
        b=BiFQ1GA47AR13egNO3EGqB4pIIUWqAJikzXxopNWNKUwrfVgMPSRJmVERVdc7RfgBB
         osmLqnCk9uDgRMu/z8UQizOAUewkWRMPZguSUqKFmmgh0U7OE1+bmKlowlsch0J4tUAl
         W1zVmxfftoaUrVzi8/pnl1BNimXsONp/v+xnhLadicXarF2jWhj8NSkQ63Aqb2vdsxvs
         AR383znsDFsA5XQxBg/l/D+VGJkg4vJrdxb0Bgl7AkRqIRyz0+QChnLqQxe8VtPJZvBi
         D1mQ24ERm9K/yvsHF5W2y1jmChK266LFlVXiToiLIpfWHIzLg7HEMtEqYPHAont75Ual
         fu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678246406;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GkqujeajDOVGkFJlXH2eTg70d+LtwBvsMGIszeviqrU=;
        b=w39goCFmjKAyHKX4QkTBAUs9Q8p3ot7YjioOS8+d3O7YTGbb66y0rk02cWayW3Z6FZ
         CXGsYE6R9WVfBd3jzLUE9821UBPW227m8muqzvy65xO1tu1T0y9ma7L99W85FguqOXEZ
         u34vyFPt0LmNHZ7+tjspomLnXAqdFKD2NpXhhAyl07bIOgXCsSa91YTy4k2FNnKUw3ZK
         yyPQ8GNKlv0IRuXW/3Nhd44zASGrx37wWxyoVI3AXZfgHME1gkOgtgcPPZofvW1LN6rE
         QDOpYYo+XFbXv/N78ms+9jZP9AUlgWsS93KUVqNzI0g0lErgFlFAzlc4z41jq4eHWwi+
         Fh8Q==
X-Gm-Message-State: AO0yUKVkN3UOmtsjQlei7HE+OI+YYXqF4cut6cfCaRkJGG882VBGAe48
        NneK9H1By7//EHmGAJ4pqQUcCWoPyf31Ta00M+M=
X-Google-Smtp-Source: AK7set/1m8Y+pGS6qiTpWiZsMNtX9prLeulRjQfjEo+YTJKM6Gh6UIWk1nE0wIc9B1yapFFTBtH47Q==
X-Received: by 2002:a17:902:e5cb:b0:19c:13d2:44c5 with SMTP id u11-20020a170902e5cb00b0019c13d244c5mr18346411plf.3.1678246405928;
        Tue, 07 Mar 2023 19:33:25 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id f6-20020a170902ab8600b0019a7d58e595sm9026879plr.143.2023.03.07.19.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 19:33:25 -0800 (PST)
Message-ID: <30edf51c-792e-05b9-9045-2feab70ec427@kernel.dk>
Date:   Tue, 7 Mar 2023 20:33:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET for-next 0/3] Add FMODE_NOWAIT support to pipes
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20230308031033.155717-1-axboe@kernel.dk>
In-Reply-To: <20230308031033.155717-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/7/23 8:10?PM, Jens Axboe wrote:
> Curious on how big of a difference this makes, I wrote a small benchmark
> that simply opens 128 pipes and then does 256 rounds of reading and
> writing to them. This was run 10 times, discarding the first run as it's
> always a bit slower. Before the patch:
> 
> Avg:	262.52 msec
> Stdev:	  2.12 msec
> Min:	261.07 msec
> Max	267.91 msec
> 
> and after the patch:
> 
> Avg:	24.14 msec
> Stdev:	 9.61 msec
> Min:	17.84 msec
> Max:	43.75 msec
> 
> or about a 10x improvement in performance (and efficiency).

The above test was for a pipe being empty when the read is issued, if
the test is changed to have data when, then it looks even better:

Before:

Avg:	249.24 msec
Stdev:	  0.20 msec
Min:	248.96 msec
Max:	249.53 msec

After:

Avg:	 10.86 msec
Stdev:	  0.91 msec
Min:	 10.02 msec
Max:	 12.67 msec

or about a 23x improvement.

-- 
Jens Axboe

