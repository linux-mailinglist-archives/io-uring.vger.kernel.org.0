Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94393F9FB3
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 21:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhH0TP3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 15:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhH0TP3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 15:15:29 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030DBC061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:14:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id v123so6455541pfb.11
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zrseztdRoga4HKNqtl5zoaTsTnSH+8hjPeggdHZBni8=;
        b=jLPCb948Vzc/UmK1R1foPDw0eRMBRYptaA0GCMst4MFNUFTq3P5vCtgo5E3T92u8kL
         Pa6KR/foOJXCoFh/pHT76xKCFpGlQkyMnIZdpG55QX0Lby62NYJERr8XVU2z4w0vUlwp
         1tYPRfXGKt7hcJ+xYQ1gv5Pl3n944NyiI7QDkD3ZhKY7XCzlsY7kh3UhBzFUXbLp6Kbl
         1pJyCVQSAseD6MBa57g33Sqj2ipu+O3FQZ4CO97qUZBex63IQWK17gZ7NEsAc4QcNfbp
         TgtnOA87jAEYu75TGye7EZ8/z49DWwg9lXSVLXltc8VJfmcqLse9NKBrN2OJHO9gU6Bo
         VnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zrseztdRoga4HKNqtl5zoaTsTnSH+8hjPeggdHZBni8=;
        b=X1MbowH5bxQIlb3v2gjTg/hVpB5UMfcB9GPP0Y5V4mBRbI+JP4LpyNIKLhnWhPFiph
         SaBc1AwzEYsNokE8RE78/irKl663ubzmPuWmdh88ui6y462AyD7Tx053w76hbUT7gE+b
         TZ4mYtsgU8BN7mWOKJFwvesPDnpnX3GYEF1tilMOcTmFalkcmma4cPghKzMoK3+C7GzV
         xVCnPfG9lSbKPG9jc97tWW9PRY9maIAlZ0gQ1lcFVYIE0cnNHjRvOt+ZZsb23Z2v+U2n
         ATPWKVMd3kMSONnhZ35hHJZ2qvlvuA0auas4mytxCS8Y+ShnZWvcF8R4Xd+0qo2Qz1K1
         utIA==
X-Gm-Message-State: AOAM530TQB79tDn3IfCo9sMJWXh0f/fRC7Wa/7cSd125OVePkwH64uJT
        Kw9UAoa5y1vQOeH+FZu4PMe62Ui9L0mWwutn
X-Google-Smtp-Source: ABdhPJxG4llESc77M1sqbtYzCsZQmcmqORqPW7YSeYqoEoAhS2djMKfwEMsKahyOMarM8HTPe+V/Og==
X-Received: by 2002:a63:fc0a:: with SMTP id j10mr9070564pgi.136.1630091679066;
        Fri, 27 Aug 2021 12:14:39 -0700 (PDT)
Received: from ?IPv6:2600:380:4935:79ff:156e:745c:f627:64cd? ([2600:380:4935:79ff:156e:745c:f627:64cd])
        by smtp.gmail.com with ESMTPSA id y12sm12159pjm.42.2021.08.27.12.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 12:14:38 -0700 (PDT)
Subject: Re: [PATCH liburing] register: add tagging and buf update helpers
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
 <7c95d8a0-7449-ce1e-4c7b-c6fb8537d61f@kernel.dk>
 <652de562-c9ac-3a03-fdd1-e91751eb1997@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <52832dbf-1c55-db0e-4521-198ec6443fe7@kernel.dk>
Date:   Fri, 27 Aug 2021 13:14:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <652de562-c9ac-3a03-fdd1-e91751eb1997@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 12:51 PM, Pavel Begunkov wrote:
> On 8/27/21 7:48 PM, Jens Axboe wrote:
>> On 8/27/21 12:46 PM, Pavel Begunkov wrote:
>>> Add heplers for rsrc (buffers, files) updates and registration with
>>> tags.
>>
>> Excellent! They should go into src/liburing.map too though. 
> 
> Hmm, indeed
> 
> Should it be LIBURING_2.2 or LIBURING_2.1 ?

It should go into the 2.1 section, as it'll be part of 2.1 release.
Any symbols added after 2.1 has been tagged would go into a 2.2
section.

-- 
Jens Axboe

