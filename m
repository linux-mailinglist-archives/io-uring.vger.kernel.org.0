Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769AA5635AE
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiGAOfl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 10:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiGAOf2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 10:35:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DDF3CFE6
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 07:30:54 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h192so2569830pgc.4
        for <io-uring@vger.kernel.org>; Fri, 01 Jul 2022 07:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=lcUts9IRbHMoYKbUwXCQXdwgQkjG8wAgntfc6a84Bzk=;
        b=i6JialmZiw+wHNeAvHcpKTIFr0MYcZSBWHyK9ku4aQu3UocWa79NsyyNmyZAjZxLXF
         PMHTN+aMRiS9m/Lc5x3K/0diosTPQEjG9P4lx2GzEHd3O3fCe5ICdFvFa6XC1rDYWjgF
         fB5sKKdLorSL3/BvShteEZ3YsoJ48nKfHxDDemnRRPRIh6srncHNrCp41yl9zFfzTa3e
         gZGArV8NlySbiki+wKdD4rOi91oUEacsZ+akcux088FMB07dPkgxgtN0Lz3RIoRSwKlD
         Fhr18qgexDLlJy9/2meoYDpr0YQSga9XJllO/448ogR2uD5X8Am0GB3TJw6ZNKjTJWxS
         LWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=lcUts9IRbHMoYKbUwXCQXdwgQkjG8wAgntfc6a84Bzk=;
        b=Q+bgQtzpUMdjALAmvbk/0KoL37vjLcJgMh7a96Q2+zPb3ssDOJyw61wWJYllg0GbDb
         EUP8GfLP0IS3AUpx4OqpvoTiBRX3T+9ovjzPl62C9jCfRboUOfgPYUAw9+bxe4GItVLz
         yGqb++GgzvMYU+AAXrLkBw3k+WCztu8iyaMeh5S4FD5fT91IDNDrvktvwEUoVEP+/e4Y
         bnBgw6UyqR210a3ktmbES4sQLnfC33aRiyqb27jxUmFepXXfNb7mRVF7Bf4iMyVpJZIL
         uIIBoIbJzs75Nt3TK+5IPaE1zryngO2vOK/g8csJIhqSIX4wUf2AAJgMfjfY+Qlqllk8
         w2Vw==
X-Gm-Message-State: AJIora8s6oXa4rLnd5myisH7x2ebjjYZ+kbJ0coxpyTPqppYrd6h63/J
        07IgTdxnK/LqrR8k/JKUcpCZAw==
X-Google-Smtp-Source: AGRyM1uh4FYNuZr5eq7SjLg0KSqYaKNNix56AAXCr8IAjyfrw3Y704ctiVNZiyUFZK8dp7vB5+ohjQ==
X-Received: by 2002:a63:1047:0:b0:40d:7553:d897 with SMTP id 7-20020a631047000000b0040d7553d897mr12334549pgq.485.1656685854229;
        Fri, 01 Jul 2022 07:30:54 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u3-20020a170903108300b0016a613012a0sm15494212pld.210.2022.07.01.07.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 07:30:53 -0700 (PDT)
Message-ID: <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
Date:   Fri, 1 Jul 2022 08:30:52 -0600
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
In-Reply-To: <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk>
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

On 7/1/22 8:19 AM, Jens Axboe wrote:
> On 6/30/22 10:39 PM, Al Viro wrote:
>> On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
>>> This adds the async buffered write support to XFS. For async buffered
>>> write requests, the request will return -EAGAIN if the ilock cannot be
>>> obtained immediately.
>>
>> breaks generic/471...
> 
> That test case is odd, because it makes some weird assumptions about
> what RWF_NOWAIT means. Most notably that it makes it mean if we should
> instantiate blocks or not. Where did those assumed semantics come from?
> On the read side, we have clearly documented that it should "not wait
> for data which is not immediately available".
> 
> Now it is possible that we're returning a spurious -EAGAIN here when we
> should not be. And that would be a bug imho. I'll dig in and see what's
> going on.

This is the timestamp update that needs doing which will now return
-EAGAIN if IOCB_NOWAIT is set as it may block.

I do wonder if we should just allow inode time updates with IOCB_NOWAIT,
even on the io_uring side. Either that, or passed in RWF_NOWAIT
semantics don't map completely to internal IOCB_NOWAIT semantics. At
least in terms of what generic/471 is doing, but I'm not sure who came
up with that and if it's established semantics or just some made up ones
from whomever wrote that test. I don't think they make any sense, to be
honest.

-- 
Jens Axboe

