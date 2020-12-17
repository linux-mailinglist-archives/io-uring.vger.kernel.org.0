Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEC72DCB14
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 03:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgLQCmG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 21:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgLQCmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 21:42:06 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE44C06179C
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 18:41:25 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id w5so21301869wrm.11
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 18:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RsDQMfdeWisnokLLgsxmXeV3nJP4ObwkW8EdcQad7+8=;
        b=k3bPTgUIGNwoP18nF6JoANgWc9iaKw4OFDDuY32p2FNIeiX7BdCK85ZpztixDQm9af
         QFyM26zM/NDncFMRyhMni2BE68zjTANFlLp0a0xVvdqDYOamh38rC/03WbT7t6aD0WKN
         D56QdKXBvKUqNvMYepl8hy8mLzyh2/gBf+EAUkDCPiXqzrRzqBbI3x/nfxzecPk0hrrE
         Jz4dvRkzq4C2XY5PHXNZaKxkx+sOP2sG20Uz9uTzJKqsIJrQfg34KaQRGquteF5D7uU6
         4LQxQS7tNlGAuXv88Xljk+XC42NoWOmKXuflWwCVEsBweLKHAx2Z/+1wHtOp6ki7Jm+7
         U7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RsDQMfdeWisnokLLgsxmXeV3nJP4ObwkW8EdcQad7+8=;
        b=h+AOehpNSccuz+vYo7fp9YUfH3MrmzwGE2L4tRBV1aZjJ47JWbEEOk2xY01Q9NNlwn
         HTsc0yX1vBUX08AC0jTKteSH71jRzQ1XOdY4uAg7/D4qgDqZ9XdOQ8e0Nn3gpPdBfLt7
         OjwAFIF8tT6hF6L5RbQJ8GXr/Mzk6vyaFKsLaSPOKU4r7tfTtDzg51UEeMCyuGm58qkk
         kQI64o+mQ2lTROJfBueivll+2zX18a2xERPiww9WJfu2UDkER/tYYMK/OS3iojkM6eNe
         xi3y95rBsNsgXEiEb9J3x+GD67+8Rq4cam/EYKQUJhc2CkLIxqWFlCfTJgsI7MHwqkgi
         DJ3Q==
X-Gm-Message-State: AOAM532cP5eOynneP/bYTLorRJWoefZSZGNlh02cZWJQErUCW/cstkyd
        5vh3yDLlqsQVrd7yDWrmmjrrG89QznBuXA==
X-Google-Smtp-Source: ABdhPJxzgXPYKCip3uYY3O4FQfyhE2UEQnySUeDM+wLa+CeZXqousQytYy4mAgjhQlEDap3p0obZtQ==
X-Received: by 2002:a5d:610d:: with SMTP id v13mr41578689wrt.425.1608172884228;
        Wed, 16 Dec 2020 18:41:24 -0800 (PST)
Received: from [192.168.8.130] ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id t10sm6048140wrp.39.2020.12.16.18.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:41:23 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1608164394.git.asml.silence@gmail.com>
 <f0f7de4e-1aab-e28b-87a5-88c4c5cfd517@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/5] fixes around request overflows
Message-ID: <04da3460-dba8-00ed-3f94-0c09a3276145@gmail.com>
Date:   Thu, 17 Dec 2020 02:38:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f0f7de4e-1aab-e28b-87a5-88c4c5cfd517@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/12/2020 02:26, Jens Axboe wrote:
> On 12/16/20 5:24 PM, Pavel Begunkov wrote:
>> [1/5] is a recent regression, should be pretty easily discoverable
>> (backport?). 3-5 are just a regular easy cleaning.
> 
> If 1/5 is a recent regression, why doesn't it have a Fixes line?

I was lazy enough to just ask before actually looking for it.

Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Which is backported to v5.5+

> Any commit should have that, if applicable, as it makes it a lot
> easier to judge what needs to be backported.

-- 
Pavel Begunkov
