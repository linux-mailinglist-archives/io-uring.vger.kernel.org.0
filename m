Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61D1576AC2
	for <lists+io-uring@lfdr.de>; Sat, 16 Jul 2022 01:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiGOXeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 19:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbiGOXeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 19:34:17 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D84513E0D
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 16:34:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o15so6925686pjh.1
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 16:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pzoy1lB0v/6rv9DQZd9VxpupwhasQh/2PyI0IHfFrE8=;
        b=RUs4RJG10t3npoapeFLstot6OT3s2CAwPPMDxx6WbB3XyCwITIKcdE3hATQeTbgqfx
         siSLu2Cow1Al91+Yj8cXP5+AWJYjhrWfOMekD+G6U75zr6J3b+m0Har1b5wy0oea/Fuo
         K6mRsgzH2NiuaPebhGSgxUiRrXnFBypAVT+ZYqxzkksZeIz7aKtkb//RMMl1plawY3ht
         W0ALarB+KnUC9LxxFHiauxK3EFv6BIRLpzhGmpOlmeP0fgWQ39bO+hhJdQ1KBHBMXDOj
         2AOdqFWz4vnpQ3laCcsLaYV5N+tcLXX1MC/zSr07XvHakv3Ez87bNlANsMXCky9ks+M6
         TPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pzoy1lB0v/6rv9DQZd9VxpupwhasQh/2PyI0IHfFrE8=;
        b=vH4Y2EV7zaDYtK/nSsjQUMuE7fnT1U0/d8nCX1ZzCZx4tG2wJUNQaEFQhtPyib/5XI
         880gjsyPqh3C6cYYHxg+6UcIL/jjeczSs2A7ImR9Vib5yn0DKzUTDQT7VBY+hbmD5HTv
         GVX6K5bWUf5ZKQXC/ZksEr1HwBMHponpninoCP3TPEIOv1iFGxva4TGQl3BJH7t5zpQx
         21oZqa17cCG70BJutW9JmDyYpWzXwf796pSjh+NEOUQOioPMObSXDocXrhYCpdCddoPE
         s8PUIn6+IsEyYcLcwi82FZdQZaCrDfHQ6z64iH4zi0YfbVjV+c36iC6PNZkJPg97bSMd
         c9rg==
X-Gm-Message-State: AJIora8BAn6SRG5Agks2Uwn5zn7XSPIHeTaXEUU0RTy1ML/swqDMXt9N
        as2hxeRjPuB4Uwso7VK4gqR9PQ==
X-Google-Smtp-Source: AGRyM1vuPuU3qfouowNfCFYUqlvzGi9NLhytJ13Q1VlElKwXTIZX+SBEfFQdjaOUe7RlMwvURt059A==
X-Received: by 2002:a17:90a:d714:b0:1ef:b93d:fc4d with SMTP id y20-20020a17090ad71400b001efb93dfc4dmr18709466pju.49.1657928055988;
        Fri, 15 Jul 2022 16:34:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b0016be702a535sm4086321plk.187.2022.07.15.16.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 16:34:15 -0700 (PDT)
Message-ID: <7d928dc4-ed59-3858-803a-41b3947ea12b@kernel.dk>
Date:   Fri, 15 Jul 2022 17:34:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file
 op
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Paul Moore <paul@paul-moore.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     joshi.k@samsung.com, linux-security-module@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, a.manzanares@samsung.com,
        javier@javigon.com
References: <20220714000536.2250531-1-mcgrof@kernel.org>
 <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
 <YtC8Hg1mjL+0mjfl@bombadil.infradead.org>
 <CAHC9VhQMABYKRqZmJQtXai0gtiueU42ENvSUH929=pF6tP9xOg@mail.gmail.com>
 <566af35b-cebb-20a4-99b8-93184f185491@schaufler-ca.com>
 <e9cd6c3a-0658-c770-e403-9329b8e9d841@schaufler-ca.com>
 <4588f798-54d6-311a-fcd2-0d0644829fc2@kernel.dk>
 <d8912809-ffeb-8d88-3b6b-fd30681ad898@schaufler-ca.com>
 <27b03030-3ee7-f795-169a-5c49de2f6dd2@kernel.dk>
 <5615235a-ccc4-efc7-c395-f50909860ab0@schaufler-ca.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5615235a-ccc4-efc7-c395-f50909860ab0@schaufler-ca.com>
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

On 7/15/22 5:31 PM, Casey Schaufler wrote:
> On 7/15/2022 4:18 PM, Jens Axboe wrote:
>> On 7/15/22 5:14 PM, Casey Schaufler wrote:
>>> On 7/15/2022 4:05 PM, Jens Axboe wrote:
>>>> On 7/15/22 5:03 PM, Casey Schaufler wrote:
>>>>
>>>>> There isn't (as of this writing) a file io_uring/uring_cmd.c in
>>>>> Linus' tree. What tree does this patch apply to?
>>>> It's the for-5.20 tree. See my reply to the v2 of the patch, including
>>>> suggestions on how to stage it.
>>> A URL for the io_uring tree would be REAL helpful.
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.20/io_uring
> 
> I'm sorry, I must be being extremely obtuse. I want to create the Smack
> patch to go along with the patch under discussion. I would like to clone
> the tree (with git clone <URL> ; git checkout <branch>) so I can build
> the tree and then develop the code.  The URL you provided is a web front
> end to the git tree, and does not provide the clone URL (that I can find).

Just go one level back, out of the branch, and it'll tell you:

git://git.kernel.dk/linux-block

or

https://git.kernel.dk/linux-block

and the branch is for-5.20/io_uring as in the link.

-- 
Jens Axboe

