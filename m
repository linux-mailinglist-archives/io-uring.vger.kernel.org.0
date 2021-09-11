Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE04407623
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 12:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhIKKrt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 06:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbhIKKrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 06:47:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D228C061574
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 03:46:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u16so6429240wrn.5
        for <io-uring@vger.kernel.org>; Sat, 11 Sep 2021 03:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=m2ppKDsXkEAZENCjAvonwClmUiPW1q5dG5nwvZqvr8w=;
        b=Bevw4P3IcsHwgj/PAV7Cc/6ykLxbRoSJRmw0FZuIrURQvI9bHT29lBxPCnGJwqNrdr
         qfh+qC46vLzkosRXaNLqTtqpY32zQM5zK8iI6UPaG3MmWm/W5k6qVqPPFFZdkQjHVBLz
         j38WhGBgfQ1CEOAyxbuiVEyaW6GBZpE1xtvK5UzD2wl40sRKNz18s9ywxenW5wGeRoLg
         yoriScPsbowQGQXMoGxs17lNRPAddoEIPN6y4EO8qgYibU3jcrLvfPIJMuAIdWRfZEvH
         6nau6pHNwPT5vOxoVK8+5/XcqQ+xgeDd2D1wtmjsHc7jJfK/Boh1ITc4faPVUOFJ515l
         H3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m2ppKDsXkEAZENCjAvonwClmUiPW1q5dG5nwvZqvr8w=;
        b=xjR2nd/xMLgYI83qUFpG5l3sY48Jo+M2B7LUmyWRzbwbz3AAEBI6xN9SA2SjRQWSDS
         W4XMxFAl9Ns4woR8fFHfgcGAU6S2YQD/YrNAJi44TRfMImCRJrYvXnWiXVTdd8dTpmMN
         r5v8mwcTXONQoE8NOeWU45nevR9O5WLIs/gCec4n64mXM+WM1tvzHqNxwT5Xu52GJVbs
         aqiInIlOPoEkZSHmDI9yt/XXOCIIgJp5FGgc0LQ269ozYAxlyc9FfCAx2SKEip/eYzQe
         /O2hGcCWcBPKQ1Icq+OSwzoWXZb05Vf9zEOyeGzhFw6zZ4kFW3Vc0B+fq6xcX1VO2eSR
         hAwg==
X-Gm-Message-State: AOAM530sPCd0VswfuYzp8RGw/ExvXYzFhpAv/2hEhLULwcM645pWMfOB
        /NqwYllzM05tz+yoAPh2eOueh79Wehw=
X-Google-Smtp-Source: ABdhPJxxkiHQMhgdRMJ5bFBvnT0mSd8V8v4U7K4m+EQ1FBco7yfLRn948N6YXgHgG9dZkUhWXwAN2g==
X-Received: by 2002:adf:f911:: with SMTP id b17mr2599484wrr.412.1631357195034;
        Sat, 11 Sep 2021 03:46:35 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.175])
        by smtp.gmail.com with ESMTPSA id d9sm1665406wrb.36.2021.09.11.03.46.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 03:46:34 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] exec + timeout cancellation
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1631192734.git.asml.silence@gmail.com>
 <425d6d4c-5d43-4b25-f5a5-9a9129742535@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9c1d1147-d359-a321-91ea-d59c33e55ec1@gmail.com>
Date:   Sat, 11 Sep 2021 11:46:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <425d6d4c-5d43-4b25-f5a5-9a9129742535@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 4:33 PM, Jens Axboe wrote:
> On 9/9/21 7:07 AM, Pavel Begunkov wrote:
>> Add some infra to test exec(), hopefully we will get more
>> tests using it. And also add a timeout test, which uses exec.
>>
>> Pavel Begunkov (2):
>>   tests: add no-op executable for exec
>>   tests: test timeout cancellation fails links
> 
> Don't seem to apply, fials on Makefile.. Care to resend on top of the
> current tree?

Sure, will resend

-- 
Pavel Begunkov
