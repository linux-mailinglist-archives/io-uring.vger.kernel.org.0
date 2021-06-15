Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B593A8B82
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 23:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhFOWA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 18:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhFOWA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 18:00:57 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E9BC061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:58:52 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id x196so164217oif.10
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 14:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=etVr5gKlZJGU2BtvyfLGFda8tPVdaqIzvy47eIraVyM=;
        b=IZ+tLUS5wfpaIwikTTIXHvwFJpJZ+qhLEyVwLxI1OGs2RGPPYxi7YJPghWWkV3bYH2
         UsHckWKbAXc0RIwFG4aCSDpRAnzRKCN6BQjfp1BIuVpgA7z6JYZJ2LDAUKJ90o95NFuG
         Pw2BV2G+T28Bqau6Z8YPX+YOoqUl4iu89nGxFvlFFHH6Ydh6Gft7mM4ff9nQkpzyE46H
         fMSTSEVQ8FKXgo/dKvrO+QbhBLlucM6NQU/UpHAK2reTkRc9Br/RbU+y1Tb4EI7HcuFe
         g7Bwl9hgyNzBu6N2Orw/nfJJ9wn3oYtLZ9j9riT8+T5KlW8jNhTvUhlNR775Uv+0ra1P
         yA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etVr5gKlZJGU2BtvyfLGFda8tPVdaqIzvy47eIraVyM=;
        b=nIgQhT8s3uVOeskjY4hrtv9zWLJxZdHv4pIG3Yjc278+Cos9kiVLutfLoygzNtLzoZ
         m7AHsRAKD9w/ynrmj9RBoVbUrsaxk+YUscHMyQxx8S9fWbnOvlEopPoaSb1Ud/zGWXbf
         QcX8X2avzjU8YEVu0qnTECF5heHWNSE5oovNKDKmwOBX7o6rbHHXJh0Oj/sISC2y++HB
         6Kjdihm/1djZ8yHGrV5vTX+pqbOKIB9u9fFK4WRcpDuhN0AxffXiIuP3aR+mU/wQi1x1
         3t3j9eaU0hyvhh4wETRrJci72sxahe27HnhwmbCh0Umd9F75lyr5W+ObMwSC1JI+N15N
         IaBA==
X-Gm-Message-State: AOAM532J7tU93d1EOTO52ecrSVVa96F7NOre0IQirTqzxKXCbFwSgxJl
        X3ggPXcFVbjWf8HdqA3jkTzE6mCWvmpfag==
X-Google-Smtp-Source: ABdhPJwy8ay+St7sJJmM4y452boRfbCFE71uk+k2uj+/hYB+ihhw2F2uAoWq6J7DLANnQ0aKH4BeGQ==
X-Received: by 2002:a05:6808:11a:: with SMTP id b26mr841679oie.77.1623794331848;
        Tue, 15 Jun 2021 14:58:51 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id l8sm44767ooo.13.2021.06.15.14.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 14:58:51 -0700 (PDT)
Subject: Re: [RFC] io_uring: enable shmem/memfd memory registration
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <52247e3ec36eec9d6af17424937c8d20c497926e.1623248265.git.asml.silence@gmail.com>
 <355210c4-7b2c-8445-b8af-da40aed2af26@kernel.dk>
 <bf49b46b-2e5a-06e8-0563-294fdfd30fff@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2955b98c-9c4c-87d7-62da-6030452d4478@kernel.dk>
Date:   Tue, 15 Jun 2021 15:58:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bf49b46b-2e5a-06e8-0563-294fdfd30fff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/13/21 6:45 PM, Pavel Begunkov wrote:
> On 6/9/21 4:12 PM, Jens Axboe wrote:
>> On 6/9/21 8:26 AM, Pavel Begunkov wrote:
>>> Relax buffer registration restictions, which filters out file backed
>>> memory, and allow shmem/memfd as they have normal anonymous pages
>>> underneath.
>>
>> I think this is fine, we really only care about file backed.
> 
> Jens, can you append a tag?
> 
> Reported-by: Mahdi Rakhshandehroo <mahdi.rakhshandehroo@gmail.com>

I can't, it's sitting pretty deep at this point...

-- 
Jens Axboe

