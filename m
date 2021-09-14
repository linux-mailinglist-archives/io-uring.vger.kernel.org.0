Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F0140B6A1
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 20:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhINSUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 14:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhINSUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 14:20:11 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E348C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 11:18:50 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q3so18336430iot.3
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 11:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/DlbHIwhqZWmynoeI9akrU5r11YhMn5GyGLHT9CgidA=;
        b=UDilk6ENg+TF6QykZxn9fSc5r2PYpMyz9BGc1yyMQdPd0W/Q1ANKAcfhPOSmKPmrgz
         EWcKlqUsxvQ/AllZKGjJUkPyXBVV05qYzmo0iSIQ1+yG+djtTMY2SysPVbBB9jMiVBaJ
         15YqPfvlaOtxxLlbaQ7//yQ+a7zII0p3BKWlrPUp+D0gSV2eRT7ELydWjYFLs8gZj4zZ
         s4+AcKjiCN+KizpTp4gJ0q93zwDyxz4xS+xG3zsq/s8EKapBpCbUWDFFWef6nabbOFX4
         j3svPaYjSAftIgtxdy46Cld4AwFZZakqA1zXM31ovz/UDBDZBZhWnpxcF66WtdqrW/KX
         +rBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/DlbHIwhqZWmynoeI9akrU5r11YhMn5GyGLHT9CgidA=;
        b=cQmM9F/p9sgzFGVTiIY+WngB6aekSza/PAogDRA1YgOsepXcySlUpY0rxa/7yNQW3A
         bea8TwmJbTDj6AdRKTsQ2q4cbhWMqomG2JnaOWHw5y9w5e8ze/o4tWnbOtSWeKGz5naH
         wz558aKO8OnJL3wrWRmo9ynaJaMJeSsycdnIXuQSWmtgZoQHEBLV+W8xwKxVcD6yqyKm
         3B/HiKwMBsHxiSgpnPct9uA0aQUDnqsUUgmAbcHh2AhzU3qarODGrxvmxiy+8nYxDE/I
         FIPz2EYCyAW3dYRpc+frMb09A8lWlPXZeUJ7nLMJSIK8z3A4MN2DG//ct0wbgvn9arXL
         UHfA==
X-Gm-Message-State: AOAM530Vc25HFUaASwKWZhfbTRZPvVhlPMwW594nqiC1Ru49ITZTOOCm
        er+Ml+bzUzZKWuUMGPR1VZ9J+8ShF9rBCpc7z8E=
X-Google-Smtp-Source: ABdhPJxL1KlgA00AomWQSQ4HFg5tRoQkQOt5IiE6RhDtdCAiamyEyo/4AvLUXqlNiHunDQ5nGWJ/9A==
X-Received: by 2002:a05:6602:2219:: with SMTP id n25mr14720667ion.185.1631643528879;
        Tue, 14 Sep 2021 11:18:48 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z18sm7173148ilo.60.2021.09.14.11.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:18:48 -0700 (PDT)
Subject: Re: [PATCH liburing v2] man/io_uring_enter.2: update notes about
 direct open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e5fe9b4c3130a5402e4328d87f214a98b39e33f7.1631642033.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1593237d-7756-c080-2b79-fa55127a89c6@kernel.dk>
Date:   Tue, 14 Sep 2021 12:18:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e5fe9b4c3130a5402e4328d87f214a98b39e33f7.1631642033.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 11:54 AM, Pavel Begunkov wrote:
> Reflect recent changes in the man, i.e. direct open/accept now would try
> to remove a file from the fixed file table if the slot they target is
> already taken.

Applied, thanks.

-- 
Jens Axboe

