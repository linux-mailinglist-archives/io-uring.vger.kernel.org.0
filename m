Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234204EB271
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbiC2RGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbiC2RGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:06:32 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570F3AC065
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:04:48 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id 9so18584288iou.5
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=gtPRvL7XUCaQTFYQre5jOfseLQkx2q2Fbr3z/mqFTNk=;
        b=lVRQAJd6DC8GOJpy+XUtsgHjkhs36dsU/qEBsP7ixlQwxF1aygnrzh+Msnu+44rC7j
         /rwRCOPxH6dqcv+W3nkafCkvNERCp67Bd9RPye8PgzM1Bwcp6gmJP+32vHzmtjX7/K2v
         GBW5LtO/6mN44VAw2kXyDZi4aqjLsTTiXjrXcHlE+GCDjtwqUPK6q896Evetl7lcghsp
         Ic41z+LQde6fkrUUNXabCJ1hVDjiwXm6yMSNollSDL5EK7pj3Hunj6TL+F9zyXAc15/4
         7W8LoXOYg2GN9mg3YkLtoCG5JFpXapOqLJuNLUJ1AjnAIYkP4Mxi0Wv7Czdr7yw15SUB
         roCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=gtPRvL7XUCaQTFYQre5jOfseLQkx2q2Fbr3z/mqFTNk=;
        b=OXI6lTri0EtxSEkgK3KxVm4tTS4/7yYHhMnBPfExY7NqYdFnrMJ+UDPvw8Dmrs0wSL
         f87cg47+yvakiiH1Si9waHlbwr0AFDZGMnQXOz0WKc+eOrQ6IHyCwnKuD4feS6jOh99U
         teHBh0y5Sgg2voIafblrs541n3OfD58F4x5s5HWgvMQswmxpqA42V1f54k6zFp4xkOXS
         dN9KRE5xvTUvoa6SZ8L76GHXwu15WFiFLUAyqGFk4Shct7QLnhJQMwrnsznoG0GTJEaX
         psKRPMmi05wOQ5H6ugeDeZMfyhpUv9Cq+m5vX9EyJw5jYJe2rsuBgMcq6bdSGCZ9dkiw
         qyQA==
X-Gm-Message-State: AOAM530VdY1llGhWBYyGNtBe45tc8yLBIbDYCzFbwnuO0g4f4aX5rcko
        C0bsFd4NhWgWFKnWn3/IlBZIzg==
X-Google-Smtp-Source: ABdhPJwX+yKv/HQ2KpADoqEoTmfyyMJKgNohVKuleTn1EgaLjehwBLx24VwSda/PnV0z2ffSjWZy0A==
X-Received: by 2002:a6b:c842:0:b0:645:c339:38c7 with SMTP id y63-20020a6bc842000000b00645c33938c7mr9440200iof.26.1648573487446;
        Tue, 29 Mar 2022 10:04:47 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w3-20020a92db43000000b002c9ac8e7892sm4560373ilq.4.2022.03.29.10.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 10:04:47 -0700 (PDT)
Message-ID: <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
Date:   Tue, 29 Mar 2022 11:04:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Miklos Szeredi <miklos@szeredi.hu>, io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
In-Reply-To: <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
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

On 3/29/22 10:08 AM, Jens Axboe wrote:
> On 3/29/22 7:20 AM, Miklos Szeredi wrote:
>> Hi,
>>
>> I'm trying to read multiple files with io_uring and getting stuck,
>> because the link and drain flags don't seem to do what they are
>> documented to do.
>>
>> Kernel is v5.17 and liburing is compiled from the git tree at
>> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
>>
>> Without those flags the attached example works some of the time, but
>> that's probably accidental since ordering is not ensured.
>>
>> Adding the drain or link flags make it even worse (fail in casese that
>> the unordered one didn't).
>>
>> What am I missing?
> 
> I don't think you're missing anything, it looks like a bug. What you
> want here is:
> 
> prep_open_direct(sqe);
> sqe->flags |= IOSQE_IO_LINK;
> ...
> prep_read(sqe);
> 
> submit();
> 
> You don't want link on the read, it just depends on that previous open.
> And you don't need drain.
> 
> But there's an issue with file assignment, it's done with the read is
> prepped, not before it is run. Hence it will fail with EBADF currently,
> which is the issue at hand.
> 
> Let me write up a fix for this, would be great if you could test.

Can you try and pull:

git://git.kernel.dk/linux-block for-5.18/io_uring

into v5.17 and see if that works for you? It will merge cleanly, no
rejects.

Thanks!

-- 
Jens Axboe

