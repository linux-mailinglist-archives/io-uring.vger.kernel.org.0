Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911A60F6E4
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 14:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiJ0MMn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 08:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiJ0MMl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 08:12:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A239106A79
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 05:12:37 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y4so1260000plb.2
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 05:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lAOkQR3OSwLmJU6D9ffyhSWK2us3lfrOr//oGUPMeBE=;
        b=t9hm8leadjl9ToaS4weeWRK7Z30BVqcHzqHIDgDXGLP5ILaF7NMyW/RahQe7eAseAJ
         j6lpzqJUzHwcRrG9SJLC6q1hSM8c4NLOxdsHwU6nw3j8ncCkyBt+DejoJfoyiyCvS4NW
         Ig1XN299lleU9+EsFDX5h3yjCa2Trgpce/6N72sVRpGyvh25AvTFyn6+ewEhK7ZEKqfZ
         FNCwur5XIcbkGdW6arrgSSWMq6vqS/NHFKKPxEERH5e/MX7lL8Rr0tMgqm/Bbsi0EYBd
         HNb5ZRvDNsT9uXte3HiWzQCDXmKg5urzy9XcjQv6FUluKRGuCCTDoHdXVo5fB/sF1xPs
         lJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAOkQR3OSwLmJU6D9ffyhSWK2us3lfrOr//oGUPMeBE=;
        b=wnNpfERU0jLAT8kTWdx0rZGlMyWdL8ndn5W+f4Mkz5Fg5cKtLjDGhJsIvjG05fN+M1
         hCwPVng1yUkUNJQwk9zBB1x8sud+vFh42NRW6ieWru+Ku/Ck7M9/iyfuWTpZjCpJk7yq
         zNSKxeVWhbNx0bb1A82ym8S/nDQt5AuuFinu7VZtiOCr3rSzPXXfigCRsNH2GjkwqqRY
         IzuF1JQOSX9YHDWrQCU22cZtVxuCsPyjLi9fNhp/BhqTUdlhsrbyoLb+ZPytmAXHzRHS
         JUWniThQTNx3uj1MCCJ7CDUBgWd5yL5fSdt2poy2ayebOULQCifmZ8Cm+YvVe2fKfMWu
         EPfA==
X-Gm-Message-State: ACrzQf1cx6mQ+IlbKgEOcoeAKBjq7CHdNV2rhtKeTE0WOoTckXQUt91M
        UFGZDwqnv89PS1JhhoRib4zrrQ==
X-Google-Smtp-Source: AMsMyM6ruq9fXsSjOBJMnd1/a1tPFxznLG5AFJikDf1AY04VfKQKbliLYYW53q5mR45gpip01AfFyQ==
X-Received: by 2002:a17:902:ced0:b0:17f:92d6:f5ec with SMTP id d16-20020a170902ced000b0017f92d6f5ecmr48399076plg.34.1666872756401;
        Thu, 27 Oct 2022 05:12:36 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 184-20020a6217c1000000b0056bb0357f5bsm1049099pfx.192.2022.10.27.05.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 05:12:36 -0700 (PDT)
Message-ID: <fedaf2e7-8a71-2fb2-5d7f-a03c01f824ba@kernel.dk>
Date:   Thu, 27 Oct 2022 06:12:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: Problems replacing epoll with io_uring in tevent
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
 <9b42d083-c4d8-aeb6-8b55-99bdb0765faf@samba.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9b42d083-c4d8-aeb6-8b55-99bdb0765faf@samba.org>
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

On 10/27/22 2:51 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> No problem - have you been able to test the current repo in general? I want to
>> cut a 2.3 release shortly, but since that particular change impacts any kind of
>> cqe waiting, would be nice to have a bit more confidence in it.
> 
> Is 2.3 designed to be useful for 6.0 or also 6.1?

2.3 should be uptodate as of 6.0, don't want to release a new version
that has bits from a kernel release that hasn't happened yet. The
plan is to roughly do a liburing release at the same cadence as the
kernel releases. Not that they are necessarily linked, but some features
do obviously happen in lockstep like that.

> Maybe wait for IORING_SEND_ZC_REPORT_USAGE to arrive?

That'll be 2.4.

-- 
Jens Axboe


