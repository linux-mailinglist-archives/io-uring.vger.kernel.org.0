Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB9C207C59
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391349AbgFXTqQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 15:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391324AbgFXTqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 15:46:16 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EC6C061573
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2020 12:46:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d12so1510956ply.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2020 12:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=etcC5SCWJE9q5GKdy+4hZU308fzw/ff8X68zPO6H23o=;
        b=1ttHOWHtWCaWFJVfcE2SivyYk2ulxNbtSjixxOQfHds2kZGP6Gc9XkIqkFyUu81A3l
         zVxwmONzVkY/1212l1Ohi1ILWSpgMjCfcSvQhbHxD4nZskRCMuc72cy4JeucvNJCgDX6
         CenroNIIg0Q5c6VjeWCsiLarTiCDSXL4er3ejHU6M2DFrrFTrfJHNzO6GTZgZFtESrtB
         hD6VDL+P7kH7+lBwdCnvXqSCgpXQ1kmTRiBCReupOsYSyrJW8NY//clp62BhHDyH9/t3
         hflvA9iK6GxL77waLEyDKc5iv8fXY4gEAKJOwOjHGT0bOfb8O1JXj/ls4Rp0xE4nv0rP
         Yz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=etcC5SCWJE9q5GKdy+4hZU308fzw/ff8X68zPO6H23o=;
        b=JnnIuDJIryLjKgTKkwscCdKaZuwM2Y74FRiuo4du83dd5JRidgsgF5jXvo9X6dT504
         G41zY1rjOqwdhoPSJy/ffLMd8H6LhyjokLmBQnv0gdQL966nsuBQBspY0yISdMqMXyia
         5M/iOblFKApLmW0dW0dNyCRmWQKKpIkg9sS+Oqi/vXXpo0/F7VhEd44pPKDD2UveV8II
         6VH14sGdQuy50z9Gg7p1mW440lsFC8vYcxVP2oK00xqWiDjr/r2L+7Ik+dOZx+1vis8H
         AjpgBdtXW07ydc3qZ/efnPav2cytNKq9D6BpUw3+Bb88X5b7hcagQAq76zELdWsqlFvC
         c/KA==
X-Gm-Message-State: AOAM533qbKFAh7Aujzc6kZlMWWu/kQyw6/7+CX+tSiVdibFVAoi/6jwc
        mTE2oGISEUUEr1eXzSYyB0hB2g==
X-Google-Smtp-Source: ABdhPJyEiH6lN1BP8U0UF2zar+GhMc8QVt8uZMBCSOvg0OFQqtKiGklvgIkVtpT4o5C259KRtBu70w==
X-Received: by 2002:a17:90a:de1:: with SMTP id 88mr31019016pjv.124.1593027974219;
        Wed, 24 Jun 2020 12:46:14 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 27sm6036508pjg.19.2020.06.24.12.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 12:46:13 -0700 (PDT)
Subject: Re: [PATCH 0/3] iopoll fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1593016907.git.asml.silence@gmail.com>
 <32dc23ae-bc73-b4e2-f9aa-cab59280cae4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d253bcb-8953-d975-1a39-78310ff2e723@kernel.dk>
Date:   Wed, 24 Jun 2020 13:46:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <32dc23ae-bc73-b4e2-f9aa-cab59280cae4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/20 11:03 AM, Pavel Begunkov wrote:
> On 24/06/2020 19:50, Pavel Begunkov wrote:
>> Did more comprehensive iopoll testing and found some more problems.
>>
>> [1] is from the previous series. Actually, v2 for this one, addressing
>> the double-reissue bug found by Jens. It maybe not as efficient, but
>> simple and easy to backport.
>>
>> [2,3] current->mm NULL deref
> 
> And yet there are issues left... I'll resend

Can you also please have them separated in terms of what's for 5.8 and
what's for 5.9?

-- 
Jens Axboe

