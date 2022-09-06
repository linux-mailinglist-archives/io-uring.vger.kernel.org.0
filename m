Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47525AE911
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbiIFNGr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 09:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239979AbiIFNGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 09:06:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7974257E07
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 06:06:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pj10so774368pjb.2
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 06:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hUilgeHP0biCxsciT92z9y8bpDsjjbeBXQD/8msdltU=;
        b=GNIWuM9ISomgaI/MfitDMgzaSir/kv+ZiB7ykUG2JOEKioLzlKVIKzosdx3Gr1VZNN
         FSyjgitEn0OlLuUwBj2EKYYhuA8aLqigTBk1n05agFHu9TeGsM2Oy4dxutyDDiB/Kp0q
         g/rs0M+JjhZ6KPqyCIf9xmLsAItYR8v3SejXlDNl/xUw0z3xVOH9YFEZ/PdO9X2FFFKS
         P4euUSP1/v3VHzh5WqkrA600b469pljHUiNI8QZSjczO3F1Qj8ymAh80e35446W96mOE
         urk/jacqVYb2DQ8MHSdSUIGUfDrWb1YGpO2ROSah0jbUKf4theoc5vr4uFzUe74s50Vs
         DF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hUilgeHP0biCxsciT92z9y8bpDsjjbeBXQD/8msdltU=;
        b=etpH0+TZ8/Cv34CzFNWGL06YILlszAOT6Id/78bwjyOEPtcZoGIiFneyQ8pP0QNphn
         qXlSHdGPFZaVqrsO5hWRfilMdz1Krs5X02yVF6lzmRCm3PMI5w9EMXMCzCErqTckPydY
         RrflgqNb9swK8n8ukPoZvFQwBDiix2A3nHC8/IYTeJSCpg5zGdYq3eqHBmuwlO0W7ksr
         DzZL5Z8bU5ICc6S3Wg3793ZJ/8zVC1EqbqsUMzDwqGV9NB6U4yZkkMX/jtkJaM1/gjc+
         TOwMYRKBukEtegqkm9qBzdIPFqEWTWjDqZ47gVRAk85Pg9crjO9em+d6RmJ4PK8cgMEM
         x42Q==
X-Gm-Message-State: ACgBeo2lnBPeGZsMG3m3iBq9mDgmJPdpsSIy6bR2aOeVxCKuB+4CaaJa
        D10rQSIS/byw+YR4ahlVz4nemg==
X-Google-Smtp-Source: AA6agR65LNUY4ND6VirT9/iIW5+aJ6BogblGjGp/Ah6rCqXQ1W0A40gbtwhWH0/EwhhBy8biBCwTgA==
X-Received: by 2002:a17:90a:ac2:b0:1fd:fad1:e506 with SMTP id r2-20020a17090a0ac200b001fdfad1e506mr25026991pje.66.1662469603875;
        Tue, 06 Sep 2022 06:06:43 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902d2cc00b00174c1855cd9sm9819866plc.267.2022.09.06.06.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 06:06:42 -0700 (PDT)
Message-ID: <2ad36f9d-6472-f748-b013-9678ad94e8d0@kernel.dk>
Date:   Tue, 6 Sep 2022 07:06:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v4 3/4] block: add helper to map bvec iterator
 for passthrough
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        Anuj Gupta <anuj20.g@samsung.com>
References: <20220905134833.6387-1-joshi.k@samsung.com>
 <CGME20220905135851epcas5p3d107b140fd6cba1feb338c1a31c4feb1@epcas5p3.samsung.com>
 <20220905134833.6387-4-joshi.k@samsung.com> <20220906062522.GA1566@lst.de>
 <20220906063329.GA27127@test-zns> <20220906065122.GA2190@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220906065122.GA2190@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/22 12:51 AM, Christoph Hellwig wrote:
> On Tue, Sep 06, 2022 at 12:03:29PM +0530, Kanchan Joshi wrote:
>>> This context looks weird?  That bio_alloc_bioset should not be there,
>>> as biosets are only used for file system I/O, which this is not.
>>
>> if you think it's a deal-breaker, maybe I can add a new bioset in nvme and
>> pass that as argument to this helper. Would you prefer that over the
>> current approach.
> 
> The whole point is that biosets exist to allow for forward progress
> guarantees required for file system I/O.  For passthrough I/O
> bio_kmalloc is perfectly fine and much simpler.  Adding yet another
> bio_set just makes things even worse.

It's a performance concern too, efficiency is much worse by using
kmalloc+kfree for passthrough. You don't get bio caching that way.

-- 
Jens Axboe


