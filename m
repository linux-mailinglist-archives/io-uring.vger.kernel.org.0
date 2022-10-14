Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99725FE784
	for <lists+io-uring@lfdr.de>; Fri, 14 Oct 2022 05:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiJNDS5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 23:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJNDSC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 23:18:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA942C1
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 20:17:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f193so3261168pgc.0
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 20:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3sgeYtMHg8Gp4TsbDEljP1UzY0Be2a6q3EGGpGUcElU=;
        b=yAalkQbm+EnT3IYCLrxI1RMTi9jU76NzHZkfHX2uLu+Qcazm7yBc6eMaYfLx5OKVQJ
         LTN2f70QWrg8tja0LXjAxJcxjcVa23bCVqB7e1RJQdrdvBG3wFP44ndYLeFDLOweLC/Y
         8qlmlfqPubHR18T8q2kSQ+Jj8U8ViINunGCjMhiECGdoR+Yobf4+LuLI3GMZkkjuBCx1
         ha/atP61pBfQzT4USMiIisCmL4S3L+qNguOYOG2EV9bkQE/GVLQx9zmD6EEHi8/fRXxv
         fJaVpN05DVDR/CigfBHBk37+f6DFKCiUhkIz3rnhp75/7qrziSbQLeVfAuOfSVYVNMwu
         vj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3sgeYtMHg8Gp4TsbDEljP1UzY0Be2a6q3EGGpGUcElU=;
        b=0M9Eg5H/7E38JgCs0s8MK4HvdW3mFHGSWL6WQGreOR8lKzfNDAFx5AD/ldk0jEPNS3
         TdFRwB2PT8g4pgVX6Jp/kLk8klEGJ+/8RICS9bkA0JktJrBjWkIG0+7c76lpuT1iOmM3
         wjze0eW/k7iJ7HNZKlOp9RVG/ygcmZwUsSNnK1GS6oHGddbGC9e/7sNP+9XjCNh6lPjm
         5KS+K1lDEvXSBvhEqARda3kavNB6RQnkmlc3YEEDEekDz+orqU7xPC5YJPImnQOP+ebL
         kDdnOTG6gVlvxJVh99RgWDSJBAePrsSpdQ2h+aDzv7B09d+jtS9Y2VfOsoRG/MXROJ9E
         49Cw==
X-Gm-Message-State: ACrzQf2UiKKr1ctIkQnjNmGO0f2Rnb78Xcr8IFB3aQp4/1kOraowxFeo
        fSnsJax12mIJSylflA+us1u62nmXbPBgerNW
X-Google-Smtp-Source: AMsMyM4aWE+eAkV+c9EfjH4IsG7X7t/mTX1R3n+90ok22eCtjRZEZupXTpdxeE6tRBFTWkkxKaI6uw==
X-Received: by 2002:a63:1a07:0:b0:46b:2825:f9cf with SMTP id a7-20020a631a07000000b0046b2825f9cfmr1512391pga.370.1665717468768;
        Thu, 13 Oct 2022 20:17:48 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902b78500b0017f756563bcsm571638pls.47.2022.10.13.20.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 20:17:48 -0700 (PDT)
Message-ID: <b67c417c-28ff-f6db-10ad-1eef025c757d@kernel.dk>
Date:   Thu, 13 Oct 2022 21:17:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAHC9VhQCLQogAFSvAy4AtL8VzHX9dtUetFsV2HpqR0FVWkiiYQ@mail.gmail.com>
 <85403545-DA41-49AE-834D-AAD9993FF429@kernel.dk>
 <CAHC9VhTqN4hmzGaPRpocV-EDBwTidj60jWzHKHkt=YaUwM8RDg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhTqN4hmzGaPRpocV-EDBwTidj60jWzHKHkt=YaUwM8RDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/22 5:12 PM, Paul Moore wrote:
> On Thu, Oct 13, 2022 at 7:10 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On Oct 13, 2022, at 4:58 PM, Paul Moore <paul@paul-moore.com> wrote:
>>> ﻿On Fri, Oct 7, 2022 at 2:35 PM Paul Moore <paul@paul-moore.com> wrote:
>>>>> On Fri, Oct 7, 2022 at 2:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> The msg variants of sending aren't audited separately, so we should not
>>>>> be setting audit_skip for the zerocopy sendmsg variant either.
>>>>>
>>>>> Fixes: 493108d95f14 ("io_uring/net: zerocopy sendmsg")
>>>>> Reported-by: Paul Moore <paul@paul-moore.com>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> Thanks Jens.
>>>>
>>>> Reviewed-by: Paul Moore <paul@paul-moore.com>
>>>
>>> Hi Jens, I just wanted to check on this, are you planning to send this
>>> to Linus during the v6.1-rcX cycle?
>>
>> Yes, it was included in the pull sent out earlier today.
> 
> Great, thanks again for your help in taking care of this.

Not a problem, thanks for letting me know about it!

-- 
Jens Axboe


