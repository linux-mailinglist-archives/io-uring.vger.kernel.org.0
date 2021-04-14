Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD5935FBA9
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 21:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345596AbhDNTbo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 15:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhDNTbo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 15:31:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936E4C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 12:31:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a4so20969439wrr.2
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 12:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NbiRGY1mwA5uXDxZVM+JedWA8wm7d8ci6vsQ5aAV4Ts=;
        b=RHdVdQiD3sd9kj0cV3DoW3T/bWl1C6MQhBxWbOQ2+2KRgOOQhJWXLjjjfB0g+W84i3
         qOY86DJpYCiq/DooxwX7TWULZEueA/ZYEz/lvcXMgKmimEW6+nW0ICYPePBsk7L63XpH
         NX7uIRcdsWeuWcl8j2Stil7TliGMmUnRo6Ar1eGwuU6SH3YRs/xGtzd0+pLsp1YNpsBw
         Wc3h50KN4eQpkjpVIpCLLQ9JeMGIPLCYCs0oGXngj3Y3LvME7j4Kg3dr3JTABYhkqJEg
         4SbB2YDsWXqW0y3+A0PLNgKi5OF5WcqcAo3d/gdF1SO5RHCe37Gvaz19Tz2Ljq88dXou
         Lu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbiRGY1mwA5uXDxZVM+JedWA8wm7d8ci6vsQ5aAV4Ts=;
        b=tpdS9yBPdxgqFFA8VhHIt8c78/CIDgKVYGu7fbxkrRnSHrGFsIa06cG8mO8hPjpUuJ
         GjHfmB2dyWQKaCJYFxKkUC88Jf/qiUAk/MAljUqrU6aJhkYSHuHMzS48wWaK/GXQGFWO
         uGq3iX3RD6duAJMkYc4QiO7HwC1QwuEo9YI6UNtP08FUseYG6jYfb/2lka3wTzPhgCDt
         w+XbTy430HTrj2/SPdDVsF/dFH+2Yu+IUW2Vr4Djz3OpWgzi3t3V3DqONLyKIDAUeXMp
         t9tSof8N6F8hu/E/w4RwiHWDL5o/yx1GwvE0czfgwoYTbAIEcVLcUC2EMwCXJ02n/yyZ
         daqg==
X-Gm-Message-State: AOAM533rjPumtl7pKfD/mNRtuawwHFivXt8KR+62VsJlcZaDer0VJDNq
        TiEBGgEG7orypsDO1+2FEDAc95v3sGt6pw==
X-Google-Smtp-Source: ABdhPJxB1gH1cHYzeE0DHzC04ygeerHcidksLiRu2CvRSQCRkf454qs5mS8/KldoPMv3Ap2jFZxsPA==
X-Received: by 2002:adf:dd08:: with SMTP id a8mr34010479wrm.252.1618428681210;
        Wed, 14 Apr 2021 12:31:21 -0700 (PDT)
Received: from [192.168.8.186] ([185.69.144.21])
        by smtp.gmail.com with ESMTPSA id u8sm332406wrp.66.2021.04.14.12.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 12:31:20 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] io_uring: improve sqpoll event/state handling
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1618403742.git.asml.silence@gmail.com>
 <2c8c6e0710653bf6396ea011be106dcb57e175fc.1618403742.git.asml.silence@gmail.com>
 <159378a6-082c-d11a-ab36-03f851878c76@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <9906abbc-18d0-4056-946d-501f8ffebae2@gmail.com>
Date:   Wed, 14 Apr 2021 20:27:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <159378a6-082c-d11a-ab36-03f851878c76@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/04/2021 17:41, Jens Axboe wrote:
> On 4/14/21 6:38 AM, Pavel Begunkov wrote:
>> As sqd->state changes rarely, don't check every event one by one but
>> look them all at once. Add a helper function. Also don't go into event
>> waiting sleeping with STOP flag set.
> 
> Can we defer this one to post -rc1? It'll cause a conflict with
> 5.12.

Yeah, just as always drop what doesn't fit, and  I'll resend after
rebase or for 5.14

-- 
Pavel Begunkov
