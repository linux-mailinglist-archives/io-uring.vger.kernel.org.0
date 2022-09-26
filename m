Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD95EAE77
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiIZRsN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 13:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiIZRrv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 13:47:51 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF7913D16
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 10:18:53 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id h194so5795756iof.4
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 10:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=SBNDj5502h57IDXl6FPkcvdwxfI7lqUcfi/UyHv3Ggk=;
        b=5Hr0FN2rvhIGD2yLM53TEBcHUKNKxSbXdN9xRpCLGWXieVa22OlXxj8zosFbs3quwJ
         vCrDrImqSiKmCNnGxqkQBiBnmfT6P4qsRfeujtQtCo48G3U3am3pLMqpNaTNBrxlW3fJ
         LpJdU/f+i76/xaH12KPojzdElCdjJ7eAEwVwOjcBekcleJrYg856jBg2ds4/KKF0Jtxx
         TCFPWJTUcDGnmkm6VA8ILPQq4aTZSSl0xBS2c57aVhDWFq0L4HmHrmt4ZFN3QzYCdU09
         hEKnYeUEy7StrIcE8bI58yjQYTd6WHNyveZu2PNR1OLxRyWZU2elvauQMrO1C/mb80XG
         3Eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SBNDj5502h57IDXl6FPkcvdwxfI7lqUcfi/UyHv3Ggk=;
        b=El0gNqWQnrNLhPMnvvOk+1FIDWYpfY4g/7ZAtxah1+QuqrDKRTxwcQ7ZfKrFbRfFOO
         nmsxtu2YzlVALgKduth/m4npcWSVT1hD65H9IgH+PHLPbOUCeExLJ+46H5WVu+UyaP2P
         eooMPfckzO3DOR7RQQxLe9kinTlQqnMd/U/soA7ry5Le7EDjK7JpeTv/js5aBCGHlX5N
         7BR60xiD2QFMlkHqU9QERe5Xwq9WE77oJMj2ai4K7s1FsTnKsjqced/mXqpsl99srZf0
         xM0MqDHMwDWUyEoy2c0p3bFIDvlNzBOtjSAI338U/oqFUkniiaJGXw/DKdqbnyaFkpwq
         zozQ==
X-Gm-Message-State: ACrzQf2NXb9P2ygEu0/HDf6g9KErLmxpIc2RYxYtr47CPpSpv7XsHDX7
        88oXFMjNEVcFc//jWK9j9w9UfA==
X-Google-Smtp-Source: AMsMyM6ixmNifzDMC/xdHbCnQo/lvoLsTJ2LfeLmoseogVIt9sIOnEYSMjC0/8J20xyTOeneGDwwyg==
X-Received: by 2002:a05:6638:144f:b0:35a:68a4:b3cb with SMTP id l15-20020a056638144f00b0035a68a4b3cbmr12375012jad.251.1664212732569;
        Mon, 26 Sep 2022 10:18:52 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t11-20020a056602140b00b00689007ec164sm7527902iov.48.2022.09.26.10.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 10:18:52 -0700 (PDT)
Message-ID: <ae593f43-4972-8f96-b99e-2208b21b8051@kernel.dk>
Date:   Mon, 26 Sep 2022 11:18:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing 0/2] 6.0 updates
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20220926151412.2515493-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220926151412.2515493-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 9:14 AM, Dylan Yudaken wrote:
> Two liburing updates for 6.0:
> 
> Patch 1 updates to account for the single issuer ring being assigned at
> ring creation time.
> 
> Patch 2 updates man pages from 5.20 -> 6.0

I'll wait for a v2 of this one as well, as at least the documentation will
need updating for v2 of the kernel side.

-- 
Jens Axboe


