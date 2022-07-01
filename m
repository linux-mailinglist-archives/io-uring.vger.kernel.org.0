Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE165635FA
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 16:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiGAOkT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 10:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiGAOjw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 10:39:52 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8E92723
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 07:38:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s27so2542753pga.13
        for <io-uring@vger.kernel.org>; Fri, 01 Jul 2022 07:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=MdECX6StsDwY/HOE9bho1oyH3Lfj+A8SEWgA6oandRs=;
        b=htdxb/HDwmi/YzdWahzjJffQctuG5MXckMstF41KpYf6EQeucbVu3nJ4/7EryMibbV
         wWbbBXbRCpOTSu6TfW7aoqt24q476dJkFySQfDt7heRE4Yi94n6kD1B/wyXMx27Smmqz
         sosV/osYAKjwPBDQVLUjNsAw7Pnfrr7qFtcFYnw9e66FR4FHLShiMtxtLzMMcQWZlZvJ
         GGhxg0yyH+ri+aBzmB9HjxGtfBvoFZ2GT4Pyw1JZ1Nacu7v9u1f7rY+s0hdYyNMyx/U9
         3gGsgxwxGq8NegeQwK2OXIjmsff+BhgXe/L/JtbLjzv1eQLwV5tmI0jxqU8S1XEnkLxj
         PVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=MdECX6StsDwY/HOE9bho1oyH3Lfj+A8SEWgA6oandRs=;
        b=5R7ZoqqIYd21kFB2GuiKmtOBT71CO+AGAQzl5D1ZiPmyaAWb04Zql3x7kkrzdmWBib
         o5e0qH2H3wnr+noEFxqB30lidBao4l3QCqxoK1OgwB1nEoOU0VV/Q+FM8dTnfdZnaLYJ
         GQFEJlJAyqX+Z4H9bc/lvxK+hnfPnk4G6I+GrabmROZ3C1Z4nXtswRKXOOuVnwvYMcGs
         0ZT+ojB1oz8kNmtpRezV9tDEIrTnbOBMkIet02MtsMhGpcBNjWOJtbrNACEsPqr+OWYE
         4LxhyGeKwD9gc5TLGckB71+RYe6dUuf9dvOlTihSu2peXddE2ssL5MXY/bquRx7Qpm95
         qn4g==
X-Gm-Message-State: AJIora/u042Cz4WW3UbAox2BzZJu2mCfYvJ9G1GWdElB1bk3/+fClNu/
        2/xCV5QLJJ9jdIAH9vaTFmXhlQ==
X-Google-Smtp-Source: AGRyM1uKjjuh5y8C2QNR3OdYLOlPJOMb+cW/niCsCpR/8SBDaK+3GNxlX6i8j75gLGEQQIlxC825vA==
X-Received: by 2002:a63:3c03:0:b0:40c:f773:1e07 with SMTP id j3-20020a633c03000000b0040cf7731e07mr12498382pga.443.1656686289055;
        Fri, 01 Jul 2022 07:38:09 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x20-20020a17090300d400b0016a1252976fsm15494539plc.107.2022.07.01.07.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 07:38:08 -0700 (PDT)
Message-ID: <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk>
Date:   Fri, 1 Jul 2022 08:38:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Al Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-16-shr@fb.com> <Yr56ci/IZmN0S9J6@ZenIV>
 <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk>
 <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
In-Reply-To: <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/22 8:30 AM, Jens Axboe wrote:
> On 7/1/22 8:19 AM, Jens Axboe wrote:
>> On 6/30/22 10:39 PM, Al Viro wrote:
>>> On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
>>>> This adds the async buffered write support to XFS. For async buffered
>>>> write requests, the request will return -EAGAIN if the ilock cannot be
>>>> obtained immediately.
>>>
>>> breaks generic/471...
>>
>> That test case is odd, because it makes some weird assumptions about
>> what RWF_NOWAIT means. Most notably that it makes it mean if we should
>> instantiate blocks or not. Where did those assumed semantics come from?
>> On the read side, we have clearly documented that it should "not wait
>> for data which is not immediately available".
>>
>> Now it is possible that we're returning a spurious -EAGAIN here when we
>> should not be. And that would be a bug imho. I'll dig in and see what's
>> going on.
> 
> This is the timestamp update that needs doing which will now return
> -EAGAIN if IOCB_NOWAIT is set as it may block.
> 
> I do wonder if we should just allow inode time updates with IOCB_NOWAIT,
> even on the io_uring side. Either that, or passed in RWF_NOWAIT
> semantics don't map completely to internal IOCB_NOWAIT semantics. At
> least in terms of what generic/471 is doing, but I'm not sure who came
> up with that and if it's established semantics or just some made up ones
> from whomever wrote that test. I don't think they make any sense, to be
> honest.

Further support that generic/471 is just randomly made up semantics,
it needs to special case btrfs with nocow or you'd get -EAGAIN anyway
for that test.

And it's relying on some random timing to see if this works. I really
think that test case is just hot garbage, and doesn't test anything
meaningful.

-- 
Jens Axboe

