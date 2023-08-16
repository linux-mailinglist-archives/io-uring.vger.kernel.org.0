Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364B077ED3C
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 00:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346958AbjHPWhV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 18:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346995AbjHPWhG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 18:37:06 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141F26AD
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 15:37:01 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bb91c20602so12746355ad.0
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 15:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692225421; x=1692830221;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mu4dBuyA/Y0XWte76PlMvzUEOyFGLrBbyFYXcAZb4Dc=;
        b=jbkrqsei1sWKpVR3Wm5wBadPC70zko1PZZOlFEmSsu9HvP2928Q2mth7XIiqmxhcTL
         nBrdC5KkxxIcTBBDGwJO71ydjZHqlHYsSj0Ipjly+5nk02mah0jqzjojzfmkgdqPa6sp
         ZFZIN9zOUFtV4dr78HCyZTEfZ++aj2LcFWpKb3s+FOFtT0TCuB7U3oTBEBliJ9P8lpD1
         ZEclzs19PSZuANRPDA8a/VUGDUZnDp9QJL2yY7usj/lc/L/28Qzmu1g/FtqXaC8Tgd2h
         nww3YhHe7Wm50v1UMoAEWv3YORvGFzeonp3eAc04zSv1kO+xnvzR12FpwF34RmiTgBKE
         /Fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692225421; x=1692830221;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mu4dBuyA/Y0XWte76PlMvzUEOyFGLrBbyFYXcAZb4Dc=;
        b=PBlUcGH7mQj3oZnGD1vCbeR3Si29wZmFLdfsN2yTPcc38dRsdlG8l4w543HtG/IeJt
         HszG1QoQLRogNECBqZZFp0te7DkEsmNt22xQkKriSsIq5rchjmYF+fJMh746nar7MtZ6
         MT+9L39Yat+L6Hn/nx0vxt2spSbP6oYb3u6ZSYJizAKM2NtRV3CV0gkiG2KxHeekyOzz
         XOGWZf5srpQ8DpKSzpHatK3JS7dYLIVPUb/yALJXRp6D8oVkSfsjedjIaM201gNCACjq
         aHCUQ7HpExyI65Wy533QMeszF5581My0hB/FLaps6D+f5WWpJ2mc+NYvyKD4cqdfALzJ
         qOQA==
X-Gm-Message-State: AOJu0YxvEreLXBAGQwAZAJrGZ763/fvlDIdSWjzXe8+EwLZTDIJ+jXAs
        rXAPYV9n+kv+DcvbSUBjQhcSoA==
X-Google-Smtp-Source: AGHT+IF6SXz0bxpJWBH9xJ/dBged9ibuwaqDiticVd8ULaxI1eM+s0n/g93M1VNQbnrKZhu+8LSFYA==
X-Received: by 2002:a17:903:41c2:b0:1b8:b0c4:2e3d with SMTP id u2-20020a17090341c200b001b8b0c42e3dmr3543868ple.4.1692225421109;
        Wed, 16 Aug 2023 15:37:01 -0700 (PDT)
Received: from ?IPV6:2600:380:4b6d:b7a2:213a:1ca6:4fb5:441a? ([2600:380:4b6d:b7a2:213a:1ca6:4fb5:441a])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902c3cc00b001bdc208ab82sm10649937plj.97.2023.08.16.15.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 15:37:00 -0700 (PDT)
Message-ID: <7f8f397a-ebcb-46ca-9211-f9c8efd61b8a@kernel.dk>
Date:   Wed, 16 Aug 2023 16:36:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
 <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 3:46 PM, Qu Wenruo wrote:
>> Is that write back caching enabled?
>> Write back caching with volatile write cache? For your device, can you
>> do:
>>
>> $ grep . /sys/block/$dev/queue/*

You didn't answer this one either.

-- 
Jens Axboe

