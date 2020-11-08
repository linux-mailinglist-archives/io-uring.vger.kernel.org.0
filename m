Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132932AAABB
	for <lists+io-uring@lfdr.de>; Sun,  8 Nov 2020 12:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKHLmX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Nov 2020 06:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgKHLmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Nov 2020 06:42:22 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB81C0613CF
        for <io-uring@vger.kernel.org>; Sun,  8 Nov 2020 03:42:22 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id w24so2904280wmi.0
        for <io-uring@vger.kernel.org>; Sun, 08 Nov 2020 03:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=th8rXaaePoWk5lEuxkPZlF68C1lzNq3lngvO8ZzMjLQ=;
        b=USy3Dn6T6/BvnJR4PlyNiBX6/Z4oLFBi4cl+HvMumPnR6zqkw29WKKasM/UvbVmuG6
         RGFIYmu6RfDF8tn25Bg1skv+8XRpV1b9VyldTpCLVqcDAKgeOXeORMJeKpEYGEKgAwjA
         jzzL8+EWYCDDn84ZPEOqCSumTtK1ZlqWW/yBjy0QHwN94JEkd2l1asjAVriSJ9JrXfmy
         ONebYIYE81J0H7A4/5ZHA8+Gn+qskORlvogbX5gBqUfZXo73ob40L/VlASpiytQjRPgD
         BxPA/9aHrgTWTjaNQRU0eOsHkuRJW6z9oDWB1J2qHsBM4onExHpctTJtyFLN/adO9iqP
         M16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=th8rXaaePoWk5lEuxkPZlF68C1lzNq3lngvO8ZzMjLQ=;
        b=oINKTGsE/3D33yHQ1hersVtCoHhNzgkso6MW8X9O7dYAkw2RCXqYZd3pynJ+xQd8KB
         Nf6SyMFDbyIx6yibvN8CrEIcQvfE56xQZ6FHg6RSNfXf9mWnjE0f3nrI79qGlMvqM/p3
         UzkW6Z0KPAMucW9O6mZCQ3aowEphUjB0wreXfam4uKZ9IFzQpNLRuSmcIsiWpdrV1lpo
         lar7Y2DKCe1KwbbbQ1bAjX2Tg+jkAw7yFupSncDHwMsAwMkPBjr4creg9I94gipbHzYx
         gN1Rmd6tZ+wvvr6YQIe+iUra9OgNyzD20lsfRIuB40V0QLTgJ4uPMv47wJYB0r2WtPBK
         SWsw==
X-Gm-Message-State: AOAM531zp+FSSjKLmnNall8Pq22YRX0OHTpoMeWXgG5IOyuGT84t0qBj
        AkqaoHHf3rZ+LFLKoRIJUJk=
X-Google-Smtp-Source: ABdhPJxgrUXJF1BuOJsrmWZco1dsQKjeuFtEXsfbI90QjA7Rl9xW9HDdWHOF/zHPK7P6VbBmSylmVw==
X-Received: by 2002:a1c:a7ce:: with SMTP id q197mr9226725wme.138.1604835740854;
        Sun, 08 Nov 2020 03:42:20 -0800 (PST)
Received: from [192.168.1.96] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id d3sm9836537wrg.16.2020.11.08.03.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 03:42:20 -0800 (PST)
To:     Josef <josef.grieb@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
References: <24446f4e23e80803d3ab1a4d27a6d1a605e37b32.1604783766.git.asml.silence@gmail.com>
 <39db5769-5aef-96f5-305c-2a3250d9ba73@gmail.com>
 <030c3ccb-8777-9c28-1835-5afbbb1c3eb1@gmail.com>
 <97fce91e-4ace-f98b-1e7e-d41d9c15cfb8@kernel.dk>
 <a8a4ac73-81f9-f703-2f91-a70ff97e5094@gmail.com>
 <3094f974-1b67-1550-a116-a1f1fca84df2@kernel.dk>
 <CAAss7+r+DFTBcLzZhRoJ_p839nro6GKawh=te1wHPkhK9Nw4hQ@mail.gmail.com>
 <CAAss7+oBjNfFXV8O5DaLB0ih6EvcmSE=4V9bB5g2RY0R1oXftw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11] io_uring: NULL files dereference by SQPOLL
Message-ID: <6313f2bb-d574-74d8-d757-cc5164112ee2@gmail.com>
Date:   Sun, 8 Nov 2020 11:39:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+oBjNfFXV8O5DaLB0ih6EvcmSE=4V9bB5g2RY0R1oXftw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/11/2020 06:50, Josef wrote:
>> Josef, could you try this one?
> 
> the null files dereference error no longer occurs, but after a certain
> point in time the OP_READ operation always returns -EFAULT

That confirms the issue, and for efaults, as describes, I expect them to
start falling out after the task-creator exits or do exec. Just to note
that the patch only propagates errors and doesn't change the semantics.

> 
> BTW forgot to mention that the NULL files dereference error only
> occurs when OP_READ returns a -EFAULT
-- 
Pavel Begunkov
