Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788EB6B520E
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 21:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjCJUi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 15:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCJUiY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 15:38:24 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04B03E614
        for <io-uring@vger.kernel.org>; Fri, 10 Mar 2023 12:38:22 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n5so4404470pfv.11
        for <io-uring@vger.kernel.org>; Fri, 10 Mar 2023 12:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678480702;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dlLhK/LHL4Xfo7GAMCI7D6In0Skr36B2KpJuEO66y44=;
        b=7CxWz9unLKigyQ7y7Oxnr5hmnTvf8n3cmCboPcb8sETGnRiIVRN/XCEQiRx3gv097q
         EbIIX3XN/t3iW3iq4DbrKu82Ae9Gb4OzqUhsH3jcmXwbl00VNQAywSAQGUPmj0yAAzqD
         2niny/kICNo2KoEiBvHeKUHOWAqS5o4D5EkFwIVuHB5M+6AZKivaYW0ZUGtPfXfLGfUt
         0hvypwVtvLA1+k2JP1X3AGIUvtIxcSaSBQ5JAQJqblViis9JttpUP/kPxWFPMWzch1tn
         aOD3pe3PS0hotApldyyUW0igDCyyqU3rzAIhhGX2R6eGtGxwFbN7GDmpTo4dYnITvND2
         eOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480702;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dlLhK/LHL4Xfo7GAMCI7D6In0Skr36B2KpJuEO66y44=;
        b=Pmlsg6m6kryyrG3gnwckOE+RHN5Fjc9g6LUWjyca3vmZnn0a6A2DLSur2jZTQkPmQ6
         qge3XAKmA5q8Za6zu0Mw/OFLYC1bbruSVpH6RoD9zIGwVHpgVtHasZegj1gBpuCss3fV
         L1SxWnJZCNkpxHT05bZ9St9ID/rMS3AYZp0DU+ql7r+s+kLpk6Pv6rOE3X/CU2BwRMK0
         btqlSe9L2zGNFOTb0qZq0Y7Y3sJesR10OIpKEZlefmQybM4JPWXOERVIq363ehN71n1f
         76zevC5sI0wVpXXuNjC57SGSEXkbIa2LO9/OYCNCLezMtEitqqt1Hf7X8voYlhC6m971
         xw1A==
X-Gm-Message-State: AO0yUKV9ACExkE2zNy7zGp9rgeMhZVSv19eT6qZ1ImXbRqsNORZus7Vn
        LlrM2wYHUkfIxAiZ0iW1aUvdvw==
X-Google-Smtp-Source: AK7set9AFXNkehZR0V+EXjQvkjvFJU49ubheoycO1AexRci0R6XYmGsyCH6y62vzAByAi0iHCZ4C8A==
X-Received: by 2002:aa7:8753:0:b0:5d9:bfc9:a4f with SMTP id g19-20020aa78753000000b005d9bfc90a4fmr3632178pfo.3.1678480702009;
        Fri, 10 Mar 2023 12:38:22 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g1-20020aa78181000000b00571f66721aesm225494pfi.42.2023.03.10.12.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 12:38:21 -0800 (PST)
Message-ID: <ac6a2da7-aa88-b119-6a44-01d2f2ec9b6d@kernel.dk>
Date:   Fri, 10 Mar 2023 13:38:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring: One wqe per wq
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
References: <20230310201107.4020580-1-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230310201107.4020580-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/23 1:11 PM, Breno Leitao wrote:
> Right now io_wq allocates one io_wqe per NUMA node.  As io_wq is now
> bound to a task, the task basically uses only the NUMA local io_wqe, and
> almost never changes NUMA nodes, thus, the other wqes are mostly
> unused.

What if the task gets migrated to a different node? Unless the task
is pinned to a node/cpumask that is local to that node, it will move
around freely.

I'm not a huge fan of the per-node setup, but I think the reasonings
given in this patch are a bit too vague and we need to go a bit
deeper on what a better setup would look like.

-- 
Jens Axboe


