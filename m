Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7561EE91F
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgFDRGP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729927AbgFDRGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:06:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30BAC08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:06:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ga6so1391538pjb.1
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=95SNrnsfRSHsznN/EFmiPvkkvvFTuZxB91UovD24N3U=;
        b=Wh4JB+s+UWpwgz43Erpmr47eJrSAsMChpQGKJLR01ZKWKDOyCrTzL5NmDU75LWSHYQ
         YFiNNiaoMQDUTtyjgmsLAO2CX5up8tEccCo6C+0hr7/sRZ0osxBjUaWpzQFruyfx/zWI
         8L+WAinsUxaYs+Z3mHobRp+6hACmPIi4nFMKnS/+2Bgn2Ut7b4pEdkhMT3lWI/SNLz6N
         2LQBBlZPZbwgLeiJnVJrVDzqdJNapAc2SvuI6DiemAJhpjt9W4qmxpakNL6xQQpSBqoN
         7EnY0KjYfyQYVVwLIWHVJleJ2NMpRI65U81ghpoh3vStshg68CjtfmGAAFB4eIp4isbz
         3M2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=95SNrnsfRSHsznN/EFmiPvkkvvFTuZxB91UovD24N3U=;
        b=jP7hF08kgfYvNS8mzZc80VSUMHbWGeCvBFTL06qaWqBEFDcytWTySB7IbW98bqXpbr
         zp03q2Qy4LIlfHCvXlVrALAlRYL6dbqOa4reYL8j27J4RZsoRFB7MixJYOkMi8VQzYlS
         D6v/UuoFBSeydC2WSS8QJZ4Nx/ILsrVt6920EJ5/l/wOpC5/9Bj0SusdGDCE6bIidGRo
         IF0DfUqsXbH6cccJUSNN0RNchBWH/NIUBiM8p7nTXY/oMK7IaYGTEF+kCf8fE+T6voq9
         PG6HxJdLiDDqMcAO7bQJqWh9EwOdPBP8l+yEmZU/FZput5klOY7j59PdNWgG3s+5owaQ
         kc0A==
X-Gm-Message-State: AOAM5319fVJNxpGPIsE1iN4B2QeJSTcuuX6J1+WSAJXes/z/bvuWxwgZ
        dqDhJrD56Q7Q/DRIJTmC+l3U4T1xp4cY8A==
X-Google-Smtp-Source: ABdhPJzk5oqt/KdfFMDSXKFwdx1EavUj9ZZIioj2/unpYFcKmD6kQWB5+rd0smPPxnuqVj65N8Vfng==
X-Received: by 2002:a17:902:2:: with SMTP id 2mr5567125pla.311.1591290372276;
        Thu, 04 Jun 2020 10:06:12 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t64sm4590475pgd.24.2020.06.04.10.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 10:06:11 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] forbid fix {SQ,IO}POLL
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591196426.git.asml.silence@gmail.com>
 <414b9a24-2e70-3637-0b98-10adf3636c37@kernel.dk>
Message-ID: <f5370eb3-af80-5481-3589-675befa41009@kernel.dk>
Date:   Thu, 4 Jun 2020 11:06:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <414b9a24-2e70-3637-0b98-10adf3636c37@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/20 12:51 PM, Jens Axboe wrote:
> On 6/3/20 9:03 AM, Pavel Begunkov wrote:
>> The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
>> moved in the common path later, or rethinked entirely, e.g.
>> not io_iopoll_req_issued()'ed for unsupported opcodes.
>>
>> 3 others are just cleanups on top.
>>
>>
>> v2: add IOPOLL to the whole bunch of opcodes in [1/4].
>>     dirty and effective.
>> v3: sent wrong set in v2, re-sending right one 
>>
>> Pavel Begunkov (4):
>>   io_uring: fix {SQ,IO}POLL with unsupported opcodes
>>   io_uring: do build_open_how() only once
>>   io_uring: deduplicate io_openat{,2}_prep()
>>   io_uring: move send/recv IOPOLL check into prep
>>
>>  fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
>>  1 file changed, 48 insertions(+), 46 deletions(-)
> 
> Thanks, applied.

#1 goes too far, provide/remove buffers is fine with iopoll. I'll
going to edit the patch.

-- 
Jens Axboe

