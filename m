Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B707162AF1E
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 00:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKOXJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Nov 2022 18:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKOXJe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Nov 2022 18:09:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC82B611
        for <io-uring@vger.kernel.org>; Tue, 15 Nov 2022 15:09:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso642911pjc.0
        for <io-uring@vger.kernel.org>; Tue, 15 Nov 2022 15:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FRJ2/NFUMo3tot9W+XQ4AmnzXlCEgzOQj+6LcJx3n5c=;
        b=GSETCmmwbzYAUh1qY2IkDbt0DbmzVOSYoPpFC2XzrI8BtKj567Y45nKLP9gUovi3ig
         oQH00y9Ev91UkP0KTipKG57JQCkPbBmhj0KvGNP9sJWrKHcWhHK/mdwDu0knzKwSbFGn
         hyyjbfOPWqTOhSw0zCPDOtZadh2G6OGMTj90qWtII2VogJRv/9icbPbDuVUdyvq02BBc
         +ZzLOw1rhI6SA1219JOfUnWxhwKEWxzUkn9jX3XLfMUbErQ2GudrFc7HQYnlL5zEtS0q
         Y0EtV2xxkCmu1ET4xG5vRY51UHjE2Am6tbHozXw083/SeG9YowKv4MUhf+GmeWKt1eKt
         xMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRJ2/NFUMo3tot9W+XQ4AmnzXlCEgzOQj+6LcJx3n5c=;
        b=H4XaXFEzoz3RL0bs3k7P005MO4ULz/W4kyzXr9AODC6LZOslvh+3nHl7k6xJ+F3Ruf
         DpTqonvByaFNuTKpmHwxRTBUz4mxHhnMXLmNp2r/mAwG8PJPfmxdtyLUcQ9H/jsnDyNl
         i377ZGH1KT/XUlSNmpkjgBVM04W36UokTO7+L2HwgdwBwzFsooIGOVmV87NdayPnVaFK
         K2SnIs1A9vsuQv8fd/NDsQYZeEmqaSIPjPEixxqZdilKOdFbm9u/Dlub3TqPg8R5+e50
         i51nXN6DeYrEsuMVV90/8p1OJ/2fWSqK9DzuYkuUYUTxpds+oO+ScyFivUOCzLuRjYIA
         m2Dw==
X-Gm-Message-State: ANoB5ploWzDSmimyQcVd29KU2OAhuo/J1AnfCEFUk4efFPOj4JImqly3
        NY6CW2kTQAExOmL+ZQViidlsthF15PEuRg==
X-Google-Smtp-Source: AA0mqf5hrzm+u74QOK/MPhyijy1Gq+yHbSRmdLenCJSPLSlcI3lTOa69tFlNv+HXA/9Pa+laoNSPdQ==
X-Received: by 2002:a17:903:2348:b0:186:c372:72d6 with SMTP id c8-20020a170903234800b00186c37272d6mr6220475plh.25.1668553771178;
        Tue, 15 Nov 2022 15:09:31 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902868300b00168dadc7354sm10478322plo.78.2022.11.15.15.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 15:09:30 -0800 (PST)
Message-ID: <928d9094-db54-7b27-98a6-9ece514f12e1@kernel.dk>
Date:   Tue, 15 Nov 2022 16:09:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v1 2/2] io_uring: uapi: Don't use a zero-size array
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <20221115212614.1308132-3-ammar.faizi@intel.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221115212614.1308132-3-ammar.faizi@intel.com>
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

On 11/15/22 2:29 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Don't use a zero-size array because it doesn't allow the user to
> compile an app that uses liburing with the `-pedantic-errors` flag:
> 
>   io_uring.h:611:28: error: zero size arrays are an extension [-Werror,-Wzero-length-array]
> 
> Replace the array size from 0 to 1.
> 
>   - No functional change is intended.
>   - No struct/union size change.

The only reason why they don't grow the struct, is because it's in
a union. I don't like this patch, as the zero sized array is a clear
sign that this struct has data past it. If it's a single entry, that's
very different.

Yes that apparently makes pendantic errors unhappy, but I care more
about the readability of it.

-- 
Jens Axboe


