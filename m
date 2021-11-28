Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411E7460723
	for <lists+io-uring@lfdr.de>; Sun, 28 Nov 2021 16:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358125AbhK1PiP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Nov 2021 10:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358108AbhK1PgP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Nov 2021 10:36:15 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C11C06175D
        for <io-uring@vger.kernel.org>; Sun, 28 Nov 2021 07:32:23 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j3so31032137wrp.1
        for <io-uring@vger.kernel.org>; Sun, 28 Nov 2021 07:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=75lHEDDU93V8EjKOnwccFurjpne2KtzIeNkUJrDdbe4=;
        b=JRfHGiooO/mIxhVl5yBzDWlJcz6N7aG0PDXuerjlZ1bzIPt3UlEnlwHTaAAHSOoW1l
         NLJ64v6V82pxXjzVHM3j/n93w7yJuripVfVmuvDujpH/HFBlSFSVqbI52ObgoEoeTzJ6
         /GjOqrb1q1EzXRPPBqqmEW49GKzYQIdgZAdsOt1m9mIHog6gZE71qWBsyQ1XdY89/Rhc
         J7JpdLwRM3s3tB0e6Zx9gm2qqWW74Djh5NopEJfjT2f53hmej1U8DHHv+k3v9VwKyJUN
         R8w1kXK1fDNHKeNxk9IrMAE6OcQbwuCSqKnEiXeodmEwUVKUVXZqHJ4Ad2VWdNDNn2F4
         4QTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=75lHEDDU93V8EjKOnwccFurjpne2KtzIeNkUJrDdbe4=;
        b=sscM47DqUOiNQ4S5AJNSUd1ZaZGDcL/gkMZWWLo6te7RYwVMPHpjJnxe9N4elyMPF5
         79geky6wX8F+59L4CXFzpcOvMe5IOYz0Rf2SY80V3OZ0gM8mYEby6hfXNw7i2AnddRPs
         szixGm3gNQbyCfNTxrIS0z8YXCcCj7cIdHSAS63HdowdbzRSmFRCp2CqUziwnAa9i7LY
         kIpyRq6mL5xPuDJXediaSVDoJ3Ew9gCGd7YBWO3eKII44r6XXJdsXfM1IKZf2a1GxI2B
         cVu5F542YHKf4HJgxfD1n9B93x9MidWBrmLsoYCxuWXq6OhS0bptTKl8M2JFK57Or4KN
         Leuw==
X-Gm-Message-State: AOAM5319hcvsyWKc6fOCvogf3IHph7Ndegu40uCfZ2uD/GqLM+SpVmpC
        iGBJ0o04V7z+QsILGk/QzkVSxhpDZIE=
X-Google-Smtp-Source: ABdhPJz/h/IM6bgm2e+ll2B8+Ke41SAXC/Kx9vZsYHuo+EKVx/Ha7DoMG7W2xn/fQvmW0rWI/2jqwA==
X-Received: by 2002:a05:6000:cd:: with SMTP id q13mr27614284wrx.488.1638113542203;
        Sun, 28 Nov 2021 07:32:22 -0800 (PST)
Received: from [192.168.8.198] ([85.255.234.162])
        by smtp.gmail.com with ESMTPSA id h17sm17029719wmb.44.2021.11.28.07.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 07:32:21 -0800 (PST)
Message-ID: <bb3d5a8d-c407-a808-ff41-417770feb1ca@gmail.com>
Date:   Sun, 28 Nov 2021 15:32:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH liburing] man/io_uring_enter.2: document
 IOSQE_CQE_SKIP_SUCCESS
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <381237725f0f09a2668ea7f38b804d5733595b1f.1637977800.git.asml.silence@gmail.com>
 <1aa70085-c405-4818-96af-9f4a409eecc1@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1aa70085-c405-4818-96af-9f4a409eecc1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/27/21 14:08, Jens Axboe wrote:
> On 11/26/21 6:50 PM, Pavel Begunkov wrote:
>> Add a section about IOSQE_CQE_SKIP_SUCCESS describing the behaviour and
>> use cases.
> 
> Thanks, applied with a few language edits.

thanks for tidying it up

-- 
Pavel Begunkov
