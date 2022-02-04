Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA254A91A7
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 01:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244495AbiBDAeB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 19:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbiBDAeA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 19:34:00 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75618C061714;
        Thu,  3 Feb 2022 16:34:00 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id a13so8211327wrh.9;
        Thu, 03 Feb 2022 16:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=ZRFw74LhUId+2BhnbVhavTdzfKKwB/VHjbmC42tytHI=;
        b=XOsV5D9/p9jFhIAr4M2+4ZmfGOJtsufhWxKXp7WoUdJJap3QpGL1UGthRb6ptsmGy8
         LfCDkzncLfzSqwwGP8PLwuPoYr2ynmfSNZ6jkOHB0wTFV9Ed9Ncc4D/uNRjEsco2r6CU
         m2LT5yiZlc6ZIxb3PqROU7b6QLVtV3ch/jbsBBtTeklGySDHZn960t38SFeqiMWUWnG0
         S6l4+EAeOUadmgQhhpOyKK0mdPuo+Te7hDh9gXK1lLHu9g9G5czx4ghi0ejlfYCUt2T6
         2u5t7DgcHjxbomjetj7B5NAEMG/SfJsYV/7Hz70QYt4ae9znTOA38mf7arwDtel3w4S3
         5+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ZRFw74LhUId+2BhnbVhavTdzfKKwB/VHjbmC42tytHI=;
        b=Ba85zhqITXNmgb9QqUIwtqaMxVEP6Rw3xejeFjOIbB5a0exxuMheqPZT890QuuL5hL
         /akDYCrp/GTvhSisTkJ7sKfBdlB25H1dv83HU/gPgVDY7NIMLNKRHKq8mfY7psHEhL0f
         O53JnpjYoc5lPkoE9agTb7Q1jTbCPQYdg7fwVcp8z475NE+BSv2FPfSFbpQUr9mQ7xKt
         D4PmEk/saRWBbifqychdVsiYrDDFqmg/Apk1S1+W79Xft3+AZxCWppLGI7n7NHqPAdgQ
         JUlvwGPJlDUxZRaSuh7TpEF7rAeBSByjTU9/tjlkjBHOQSvjqPINojFkJbKSd1hzYZnP
         2ezg==
X-Gm-Message-State: AOAM532qPXsePnxuRIOjOGmwj6b/SgEq6obGtYAGzhfKQ7h4of4Z7nGJ
        ojXN7xmF3MI1FuKO2eIrYcI=
X-Google-Smtp-Source: ABdhPJx98GmNgIUxFQUiPirluysGeHtegCt0P5MHjAFzIyja11+sGWXtvTIyan0YyjKQVl4C6vCPbA==
X-Received: by 2002:adf:f9ca:: with SMTP id w10mr362190wrr.326.1643934839139;
        Thu, 03 Feb 2022 16:33:59 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id z17sm194105wmf.47.2022.02.03.16.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:33:58 -0800 (PST)
Message-ID: <130345c9-e8fb-2f13-59fd-368334b49235@gmail.com>
Date:   Fri, 4 Feb 2022 00:28:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 4/4] io_uring: remove ring quiesce for
 io_uring_register
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <20220203233439.845408-5-usama.arif@bytedance.com>
 <f592de55-5a5c-e715-95c4-d219266bcd9e@gmail.com>
In-Reply-To: <f592de55-5a5c-e715-95c4-d219266bcd9e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 23:47, Pavel Begunkov wrote:
> On 2/3/22 23:34, Usama Arif wrote:
>> Ring quiesce is currently only used for 2 opcodes
>> IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS.
>> IORING_SETUP_R_DISABLED prevents submitting requests and
>> so there will be no requests until IORING_REGISTER_ENABLE_RINGS
>> is called. And IORING_REGISTER_RESTRICTIONS works only before
>> IORING_REGISTER_ENABLE_RINGS is called. Hence ring quiesce is
>> not needed for these opcodes and therefore io_uring_register.
> 
> I think I'd prefer to retain quiesce code than reverting this
> patch later.

btw, if it gets to reverting it'll be easier if this patch
is split in 2. The first puts these 2 opcodes into
io_register_op_must_quiesce(), we definitely want to keep
that. And the other doing the rest of cleanup

-- 
Pavel Begunkov
