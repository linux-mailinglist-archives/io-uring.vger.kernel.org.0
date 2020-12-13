Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3502D90DB
	for <lists+io-uring@lfdr.de>; Sun, 13 Dec 2020 23:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgLMWNI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 17:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731431AbgLMWNB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 17:13:01 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94385C0613CF;
        Sun, 13 Dec 2020 14:12:20 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 91so14551787wrj.7;
        Sun, 13 Dec 2020 14:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9nxrWqcqD+NfL/E6pdVeNrVlJmdS2gvVv7D8xgbY/eQ=;
        b=dF086oKY/H0yy2SCYekpY3t0HtfeVwzk1D52EsK+0RLf/3jUCSsARG9ZujjcHMv/XR
         IksFhDEai7bxAT180ne63PVGVMJ2IxPZllBnCOvZ6TT/UFY6RVpeJ4GqJPpvRWHoO1i2
         Ne74Xp7a6VZkZ4FkC1ynQ3pTGGM+QriCt56G65RpMPl23xrivoMP7p53OQwubf35J2my
         SEl9h+/qIWB+FKzywtT4aPCqWhxHSuS+nmB5aXn1gqPzoIXneMy1w82SajjjMxBLT0mF
         5nGDMbNqdP+QlAeb46T9zBlCxOGrjPK26O4xSmujxTPIBzOfc7CRO9NEI3BNHiMhpLl9
         maeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9nxrWqcqD+NfL/E6pdVeNrVlJmdS2gvVv7D8xgbY/eQ=;
        b=mJX1MrHUoHxlJ4DKFxo3JCyvNYRRzLKGC5kbN9P6O1BzCZY4gpQBkxm2h9lLuK+qyM
         cGTdanw4vdTSDzIWsRwaYhc+puDs27V243tjFHL8qN+H/gI7jP3iXLW+a8P9mEySHcrZ
         TRf4hXzBswDNBbuQ7bPIEepGlp5LvesmwwcedVEMi2qIiwmC6Jy7h8dY7l8LabcXApsK
         pRprG9zMo81i4B27zhLMho5MpZoIm43/IclMcKPTm9oAS7EBHECSpOXbJie4KYkt02zz
         VlBhvNZRWfXbN0XfTS9Cjx+fL7WHYm+0c7PdgOBL0521mzSlvgeKd11tBKrPOhO8WQKs
         wxUw==
X-Gm-Message-State: AOAM531ZMW9IuFjbclvwbJXLdV/f3ftD6piWsl33x60DF73F4FrWzIDh
        Qk3t6ZACX7Kc2KtO0yhld+1Fg6EAJ6Ju3ZjQ
X-Google-Smtp-Source: ABdhPJyUDq/ElypTFjQP41ePoMgoMoW+nE653MComyet2+mKcZ6hmkEjnDKHEfu2VyKKSi5WyODxdw==
X-Received: by 2002:a5d:56c3:: with SMTP id m3mr8832166wrw.419.1607897539098;
        Sun, 13 Dec 2020 14:12:19 -0800 (PST)
Received: from [192.168.8.124] ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id h9sm27378431wre.24.2020.12.13.14.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 14:12:18 -0800 (PST)
Subject: Re: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
To:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1607477897.git.asml.silence@gmail.com>
 <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
 <20201209083645.GB21968@infradead.org>
 <20201209130723.GL3579531@ZenIV.linux.org.uk>
 <b6cd4108-dbfe-5753-768f-92f55f38d6cd@gmail.com>
 <20201209175553.GA26252@infradead.org>
 <20201209182456.GR7338@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ef3ddc2c-75ea-59aa-f27e-f974b003802e@gmail.com>
Date:   Sun, 13 Dec 2020 22:09:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201209182456.GR7338@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/12/2020 18:24, Matthew Wilcox wrote:
> On Wed, Dec 09, 2020 at 05:55:53PM +0000, Christoph Hellwig wrote:
>> On Wed, Dec 09, 2020 at 01:37:05PM +0000, Pavel Begunkov wrote:
>>> Yeah, I had troubles to put comments around, and it's still open.
>>>
>>> For current cases it can be bound to kiocb, e.g. "if an bvec iter passed
>>> "together" with kiocb then the vector should stay intact up to 
>>> ->ki_complete()". But that "together" is rather full of holes.
>>
>> What about: "For bvec based iters the bvec must not be freed until the
>> I/O has completed.  For asynchronous I/O that means it must be freed
>> no earlier than from ->ki_complete."
> 
> Perhaps for the second sentence "If the I/O is completed asynchronously,
> the bvec must not be freed before ->ki_complete() has been called"?

Sounds good, I'll use it. Thanks!

-- 
Pavel Begunkov
