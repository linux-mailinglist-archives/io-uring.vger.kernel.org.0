Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6F57D809
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 03:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiGVBgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 21:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVBgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 21:36:07 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5771C1FCC7
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 18:36:04 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c3so3257175pfb.13
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 18:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=bxT6riPifz36rWt2QtqMFw2kvqX9zlXnEmm3bdreFD4=;
        b=UlOvOAqsHodfWm9OPZRZVSITPBA8ZRuYd2w4wXa31Oviq1G8nAZSxwGX9BQAEBc3em
         bEDK/Z+TWv/v9ui+amacd1jZjxppojN+WKl/TgX86f+AoAAO1nHw91d8SPWNc0ODO+8N
         wPqaysCf8+ndpihOoW9AUgCnpmJEeETx8np4E/RpZMD8VK/j81xdWba7Po0O3yvmcise
         VXj7t/vT2uuSa3LRfYMcwv1+J41/lxHm2Mra8PKYQKnTVaAkOYXvr3xIpXZvN676KofE
         Uk7Y4vrsd8LOXXwZMk0hLDeE7wMVAu2ZmVdCnxyFoEyNYbKhlKKvK2RcSh5L1tSLlfRJ
         1GIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bxT6riPifz36rWt2QtqMFw2kvqX9zlXnEmm3bdreFD4=;
        b=D9HZKeFOu8WOEpIG9RulMwNoX8vl+XCdI2eKQ7UVlCfOKJRSIY/HModOMkbcqFh240
         a+I3JWq0IfY0k52SnWLR+ptPdxOzx4V3mqmIci4g2wgfzGXfVUOR4Kz7izuckGcS8EbN
         1K+McYc6tGO2bl0+yU9hqA1aJbCTbk5lKtCK+uK5zhqIQ2tOFZXpgDJY8GAMRsg7cWEk
         swVQBzfdzEP0e3hGJWwbjKbBbCYSEpk8NLO8bX5lt5D4C7qS6QdspI6N0Z8WmkZPRE09
         /T5KG0ElPfiVd4sCOIcYArpZahWrrUqqZQoHUEuAtF4nK31ONZRKnhXvO38LySUmUd4+
         w/wQ==
X-Gm-Message-State: AJIora+wlHGcw2Op7VD49PqBCNb+MePGBHdoJ4ycpEtCieSCqZSlPDBB
        3rptVAPhWzfyZiPmysHeQSCfJhvB68VUIA==
X-Google-Smtp-Source: AGRyM1unWEUSBKnvsQggkwDUJ4SNpkAOODYGopGdoi4dvZbYe9yWOqKcFo00DCBbwom2SHkKXUdwAA==
X-Received: by 2002:a63:ed0a:0:b0:419:c3bc:206f with SMTP id d10-20020a63ed0a000000b00419c3bc206fmr1031020pgi.195.1658453763643;
        Thu, 21 Jul 2022 18:36:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902684400b0016bdf0032b9sm2310582pln.110.2022.07.21.18.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 18:36:03 -0700 (PDT)
Message-ID: <389c6d6e-f524-35cb-14dd-9eb1d0c8f644@kernel.dk>
Date:   Thu, 21 Jul 2022 19:36:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: ensure REQ_F_ISREG is set async offload
Content-Language: en-US
To:     Yin Fengwei <fengwei.yin@intel.com>,
        io-uring <io-uring@vger.kernel.org>
References: <a4c89aea-bc3c-b2f6-a1ae-2121e3353d79@kernel.dk>
 <3088d30d-567c-c64f-fe68-3585967afef4@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3088d30d-567c-c64f-fe68-3585967afef4@intel.com>
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

On 7/21/22 5:43 PM, Yin Fengwei wrote:
> 
> On 7/21/2022 11:11 PM, Jens Axboe wrote:
>> If we're offloading requests directly to io-wq because IOSQE_ASYNC was
>> set in the sqe, we can miss hashing writes appropriately because we
>> haven't set REQ_F_ISREG yet. This can cause a performance regression
>> with buffered writes, as io-wq then no longer correctly serializes writes
>> to that file.
>>
>> Ensure that we set the flags in io_prep_async_work(), which will cause
>> the io-wq work item to be hashed appropriately.
>>
>> Fixes: 584b0180f0f4 ("io_uring: move read/write file prep state into actual opcode handler")
>> Link: https://lore.kernel.org/io-uring/20220608080054.GB22428@xsang-OptiPlex-9020/
>> Reported-and-tested-by: Yin Fengwei <fengwei.yin@intel.com>
> This issue is reported by (from the original report):
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>

Sorry, I missed that in the original. I'll be rebasing this branch this
weekend anyway, I'll try and remember to make the edit.

-- 
Jens Axboe

