Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CF0784D52
	for <lists+io-uring@lfdr.de>; Wed, 23 Aug 2023 01:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjHVXan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Aug 2023 19:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjHVXam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Aug 2023 19:30:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33EF198
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 16:30:40 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1bf1876ef69so6282915ad.1
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 16:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692747040; x=1693351840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QGTk7d3vPNctK/pY4oaBk/bRO+KKwfDsqX6p2Z7+BhI=;
        b=yYZiwzGxGl2HRP0Kildbcszy6aIT4RgUI/eKAEGhBR96GUepd6FVkeFsfqH8VCYfB2
         duyqpuuQ7UGZZXmtvEZHbI6uKnT5NcJSrNwkgovQzkn5gC7/knfuUqM3f56r8tf2Tpvf
         od8ocPBR30CwcMizMYUTUsXgnT3f53kbb6YxfiIawZoDQNut16FdCHOwPi8W/WW2xdI5
         TsObPUl9zQt6laLXsf4isWfhWW86KsWzCf1qtoIXUzHZ5teBp0oaj8BfZOWyqn03OOjJ
         xldvl9iz4OWB40Tr3hsRwRaMNnEBbfwTbbJAJWem8g5K7/gZZUN2yXDQCHQAIohZxFtw
         rvQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692747040; x=1693351840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGTk7d3vPNctK/pY4oaBk/bRO+KKwfDsqX6p2Z7+BhI=;
        b=QZzMRW4xxvjyao+ubyx+LFNOw3P4C1YagG9snuBMwNUnp57oOj0T5Xuhfwarl8BPW5
         qn5wYOOMhXuqdjrP8osjG6LYPpMN8Kw4GcG3cAz39MWr2DpX3ffyssz/w3P0dLvYFnTk
         2YlM6VRcZTngwuxvqXShYNCERQ00w+f8Tj3/VMsTO63uixaBw3M8J09lkDNXwoVVKp4A
         kgHepuYp8Vm+1yP1jdBJcDGIISOdjcVDQ+S+itmYxyLRdcIMnc1pJvlmsJCJpWemg2Ao
         XnwhJ0Z7M1H2EkXqujM6kz17mwhH6qysWZfWHcbJ9aaVAjQZuGJs/ynOmjwsnMMW4kkX
         p82w==
X-Gm-Message-State: AOJu0YxztvWkDuOYXiLUIGxH00jCEdzFB/zIzoIBr9FppGEvtpTyNMOT
        CVif5N+7UUyUvNUPAiPc7jJCvA==
X-Google-Smtp-Source: AGHT+IGwlfqhQ53laOoEfANvWqYih6+WHOCBZGf3F5h0edxJZwWRMNLIy57ZU5S8tYNDdSUCKGAwOg==
X-Received: by 2002:a17:902:ec87:b0:1b8:b55d:4cff with SMTP id x7-20020a170902ec8700b001b8b55d4cffmr12598765plg.2.1692747040351;
        Tue, 22 Aug 2023 16:30:40 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902a38e00b001b8b2b95068sm9707586pla.204.2023.08.22.16.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 16:30:39 -0700 (PDT)
Message-ID: <835ab6e3-94a3-4466-a9d1-55134c935338@kernel.dk>
Date:   Tue, 22 Aug 2023 17:30:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fix locking for MSG_RING and IOPOLL targets
Content-Language: en-US
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
References: <20230119180225.466835-1-axboe@kernel.dk>
 <20230822205425.1385767-1-ovt@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230822205425.1385767-1-ovt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/22/23 2:54 PM, Oleksandr Tymoshenko wrote:
> Hello,
> 
> Does this patchset need to be backported to 6.1?

Yeah it probably should, guessing it didn't get picked as there are
dependencies. I'll take a look.

-- 
Jens Axboe

