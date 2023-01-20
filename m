Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C18D6758DE
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 16:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjATPjX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 10:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjATPjW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 10:39:22 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA01C44BC7
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 07:38:59 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id j1so2611055iob.6
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 07:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gHZ4zxBKFj/78J0fghwgqaCjE6ht7Gwjai/lQVrZMf8=;
        b=gzg/QqiLfqNSaqONNPcY97/OcjrVcsvcFTexWk9phcHskdpA/awPSAPK+qKlGdaMWL
         tMmDAxtDSo4MhCTU9yCIXclGWEEsEii8lZmmogEkgXGIhh0RGjTxC7ILBVdtHC9MvCcI
         +3BoP0vdvEvHIS+VNFDhzZoK/UyAdx2WaY1mBZ9u94Vf34ZZk6HW+t5z+xprtptdDOMi
         njaXyLqgFCOPwbexbVkcX2SgD0SwDkT/doNPxWzFiIzG2OIR+t/M50uI4bh+RSKZLMnH
         O4+/pnWilxTCpHgCgRhrfCFpSpAfVX5A1kZtR4CfkkTFFT2U9JMYPBDoQqZsP1I8UkZS
         vvTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHZ4zxBKFj/78J0fghwgqaCjE6ht7Gwjai/lQVrZMf8=;
        b=flmiY9OH0unp/2hsYBDSy59I6dL/9BxEMkvzB2Gc90bss15x4EIFsfBI/apafl/WxH
         90vu8hWNUScXiQX6nQ5G8/k6x3uCY59fWFnMrtAPjN7a2ttPLLMPzZdnW8eWBJDIAUle
         P2CoJT8ib44450XeoqkvTiPI/3wzSPW4ipWDPAzWVmnTK0rej9426oVjnAFuiIzhUxiN
         hUyy1ai0asECWUYLmw7cN8Bbck600Ohr0Qaol9nk2sR2n8SeG1+JApkMugR5NDZ7xIrw
         X7FaZ3NGIoe9a3dZn2/1D1vAOR2kCtWvkkOHedIPu+kG56SBZrkWQiTrrNKvveyE1BZh
         324w==
X-Gm-Message-State: AFqh2kpqI69GGn6AX0jnucQjY/+GdpyxaHMTib9D4h5lZqySBoVRekrE
        Ul1GVU5oeeS4sCWyIBTgHUukNQ==
X-Google-Smtp-Source: AMrXdXsYSPJPn7W3Ubt8NCyYzB8UwottVFJpCvJnHsWEcCNVGQcrk9dR2AQCl75CacxgnfxJV4FO9w==
X-Received: by 2002:a5d:9e4d:0:b0:707:6808:45c0 with SMTP id i13-20020a5d9e4d000000b00707680845c0mr1239435ioi.1.1674229135632;
        Fri, 20 Jan 2023 07:38:55 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t19-20020a056602141300b006e01740c3b6sm13476398iov.2.2023.01.20.07.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 07:38:55 -0800 (PST)
Message-ID: <d0f3cc26-959a-4e63-a840-5c3429932185@kernel.dk>
Date:   Fri, 20 Jan 2023 08:38:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] io_uring: Enable KASAN for request cache
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org
Cc:     kasan-dev@googlegroups.com, leit@fb.com,
        linux-kernel@vger.kernel.org
References: <20230118155630.2762921-1-leitao@debian.org>
 <a0f75aa2-34dc-e3a8-c9fe-11f88412ef93@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a0f75aa2-34dc-e3a8-c9fe-11f88412ef93@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/20/23 8:09 AM, Pavel Begunkov wrote:
> On 1/18/23 15:56, Breno Leitao wrote:
>> Every io_uring request is represented by struct io_kiocb, which is
>> cached locally by io_uring (not SLAB/SLUB) in the list called
>> submit_state.freelist. This patch simply enabled KASAN for this free
>> list.
>>
>> This list is initially created by KMEM_CACHE, but later, managed by
>> io_uring. This patch basically poisons the objects that are not used
>> (i.e., they are the free list), and unpoisons it when the object is
>> allocated/removed from the list.
>>
>> Touching these poisoned objects while in the freelist will cause a KASAN
>> warning.
> 
> Doesn't apply cleanly to for-6.3/io_uring, but otherwise looks good
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

I ran testing on this yesterday and noticed the same thing, just a
trivial fuzz reject. I can fix it up while applying. Thanks for
reviewing!

-- 
Jens Axboe


