Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A7B2F7A3E
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 13:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732140AbhAOMrk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 07:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733056AbhAOMha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 07:37:30 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2C2C061757
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 04:36:50 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 6so1820752wri.3
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 04:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G0F3vXbyzXwCRTptElERVE9356V7sp58CbQseYBEVJ4=;
        b=tCQ1RsN8ifs2bk19+Euv3X7pcjslgXbqcblxMUidKO/WMqemgJKbds7yBZ9mqaIEIY
         7LrxmztyHjSbjysKmgWJ3vYNwFGPP5V+jZf6E88XqNe66VWlD2M5YaIQeNQ+626UwUhu
         mrLCDW61QUEEj++e7xgEkswY7p4qraEoelb2xbucQY8fmEbDlXKzE3G13+VJ0+PxA2Tj
         NAqB2aF+15H+F/D1L4UD7SnFL9tJh8P30Hkeg3KsnsYx8WSCL2O5eTQ2BvNberNbkTJh
         D7wCv45kj7/rjWFq1d7gRoGjVW3UXguwNt6cbkteRXVjTSWqWZptidDVMT8iQE4Fn0rf
         s4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G0F3vXbyzXwCRTptElERVE9356V7sp58CbQseYBEVJ4=;
        b=W2+q0t7vDP9bnTFfF6bdMW3IygtJfRCHfV3fTFioHc+6e6yuvNP63+Rkp0sqPKAygn
         242sv/Dmir5kCphvayATCMEZK2RpcWkTcBfBFYdvpHRS65dOCQA2GokJIY3eHeun5EWH
         4CVBFHkNhPWAWRCCFDGtWpdGy7sZJbPgtsXecJmL3nFyweao3IiHaXagQQKlstwctHqv
         ZI804KnIziNs4mP757gmyTXddVC4Dc0O0lC7BYRLww3NAngsjM5AruOzHOVxeIGj0q3Z
         DPMquV5ytCTPxwlyxZgLqkz3/9GWe7nqttM/rr0fLaUDX2X+qXoZpNvXapNdxS2Q5JpN
         7lsw==
X-Gm-Message-State: AOAM533Ywn6Gs6myZ4svJ1+Yw++8PKlCS9zR7D67zNCFFKm2Xyo8HtAU
        VA8bTXcbiF1YVoqfMADPPwImbxEJZWRAmg==
X-Google-Smtp-Source: ABdhPJyMfz4JDEJJ6fsNirxXtF4/kVINk4KuMdeJKA3sn4sOK8JIfL+rgrHJCF5ROZPDAQpIq3mE3A==
X-Received: by 2002:adf:d218:: with SMTP id j24mr13471324wrh.361.1610714209030;
        Fri, 15 Jan 2021 04:36:49 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id t188sm12331840wmf.9.2021.01.15.04.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 04:36:48 -0800 (PST)
Subject: Re: [PATCH for-current 0/2] sqo files/mm fixes
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1610337318.git.asml.silence@gmail.com>
 <1c14686f-2dec-7544-5fa6-51e5a2977beb@gmail.com>
 <013686d9-2692-9154-d9f0-fc54f1cbb63d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <910e7d51-0790-9f74-9014-e2752f9e801c@gmail.com>
Date:   Fri, 15 Jan 2021 12:33:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <013686d9-2692-9154-d9f0-fc54f1cbb63d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 23:28, Jens Axboe wrote:
> On 1/14/21 2:12 PM, Pavel Begunkov wrote:
>> On 11/01/2021 04:00, Pavel Begunkov wrote:
>>> Neither of issues is confirmed, but should be a good hardening in any
>>> case. Inefficiencies will be removed for-next.
>>
>> A reminder just in case it was lost
> 
> Maybe I forgot to send out a reply, but they are in the io_uring-5.11
> branch.

Missed it in the tree. Thanks!

-- 
Pavel Begunkov
