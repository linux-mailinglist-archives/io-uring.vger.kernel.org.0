Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255D4295625
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 03:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894795AbgJVBrH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Oct 2020 21:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442706AbgJVBrG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Oct 2020 21:47:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD0C0613CE
        for <io-uring@vger.kernel.org>; Wed, 21 Oct 2020 18:47:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y14so126973pfp.13
        for <io-uring@vger.kernel.org>; Wed, 21 Oct 2020 18:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OmAwvBZ9uAhPDlxcIDcn1mXNop70iw8qcrz1ASYUCIo=;
        b=eAgwJrplAA6FZa0sMS3olAK5KHxsOFla4bdkWmIbXoYlRELG7dBVAo0snK+RpzuYdF
         Nn1HDEHmYPQWHXCZZAk17b4gDKCINAmPsYZ4hDxZ7ozjRE8Frwu83r8M+iBNRz5Ridw5
         vceacWO2UEKqOEhi4x16jOCJvmgV+v9+fL0ok2h8GYc6IWUAT3mSMyvlXYPO3Ag1tddz
         8OaftMqKVv+qr9vhiDFfj9SdnUbKk1hOyGy2q2vcJ1OFWD2maND+RbcA8vDTBWfDUfUD
         rijX46sPPety8RfT0KYUf6viMDo9VE/ehP7q8cwUU+5c3/GV+V1y0JLpY1s7Rnib+G/y
         EnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OmAwvBZ9uAhPDlxcIDcn1mXNop70iw8qcrz1ASYUCIo=;
        b=QLIKuOOI4jS8i6ucOiFznqk9+bwAFDsPgwaf5yAFEaG4FoQHx1fky3L1s7V8Q2TcPz
         VD/H9BTOomH2W6ln8uXgLBZ66U3FN/lTkazTTlyzFJHXq6ikZs7RKxPl9mbTOm3FLnAO
         fF12PVIZF9hXzJE8mODq2L5qMpCWEEJY2Mivqs4EzHYJVs4m3H02+ARvtXZRid7mUhfy
         WjRXD6LJBA07N2/amSe1cQXOB8xOwkUhBnviI+aLkWFe8NU0agJdEjg8/c1u5laCSnE5
         l/qM/pZLy8W9q6xKnHM7XGqlQRzXdcMyfHDCGtNVmcyQ2pGUfjDa6up2NoaNk2kY9nDE
         LDcQ==
X-Gm-Message-State: AOAM5316SeENNFaEoPxxwXD4qTdqdVIIrQ1ohdicjLXJPTpHLcaPAUWA
        Y6zyf2pCmST4ta4U/HL1f6GGCyicBG5Nlg==
X-Google-Smtp-Source: ABdhPJwIOu434YeiK4aYxJmi//GHdAb6O7c3P6mn7F2RgYAZ8NaSb3qmkMPIwpfGTNuZcKwNmOCpTw==
X-Received: by 2002:a65:628f:: with SMTP id f15mr374062pgv.168.1603331225334;
        Wed, 21 Oct 2020 18:47:05 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f66sm20619pfa.59.2020.10.21.18.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 18:47:04 -0700 (PDT)
Subject: Re: [PATCH liburing] add C11 support
To:     Simon Zeni <simon@bl4ckb0ne.ca>, io-uring@vger.kernel.org
References: <20201021154215.148695-1-simon@bl4ckb0ne.ca>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <66afb9a4-6329-e4f2-defe-491a5d497611@kernel.dk>
Date:   Wed, 21 Oct 2020 19:47:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201021154215.148695-1-simon@bl4ckb0ne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/21/20 9:42 AM, Simon Zeni wrote:
> Signed-off-by: Simon Zeni <simon@bl4ckb0ne.ca>

This really needs a changelog explaining what is being done, and why.

-- 
Jens Axboe

