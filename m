Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1DE29E468
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 08:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgJ2HYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Oct 2020 03:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgJ2HYf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Oct 2020 03:24:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E284FC0613DA
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 20:01:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n16so1143799pgv.13
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 20:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=l5xK5Hz7leOEfRzVROgbi3XAgmypfcrG7nW+wCHcmUw=;
        b=gs1SCuSddN2cesitnNGOXmrJKozfMfAKhckLxlZpAUGDxLLDYm4FS24TgATfb11zUJ
         S2I+S4UyP15N63dHvksZVYqKFTomhx34XOffirAYOWB/jFA4GSALHswTZio2vtg4vnEH
         10kOg36qji7uTlt86u7ze0/AUuvoLE65MIALEjd6stPcn0BzmH1pLfyfXv7SG2pI0A9u
         jLyyRjgCaQB3s3wW/TWjIjZz2i+Z/OFwX4wqOSwMIObYs/WgSiNJDLRAKbONkPYOGnMB
         i89Zk+gsVcLwLD+mvOYktxTp5Wt8ZyEtGyYsEE0oW6wMD4HhBP3jUEugAJ9EMz5C9D6K
         7Rtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l5xK5Hz7leOEfRzVROgbi3XAgmypfcrG7nW+wCHcmUw=;
        b=FYnpfOa5tyZimKSNHzhUhtI15cHw1hqqLu8b7QSZW9g6+hollIVg/Pt1EYjrsQetpw
         /Dp6IVXG7ndTwE73EezCLa+DPpUupccIpZsSy9b1/KqYI6HSWOAMeAyfrLPkc0ujFVkj
         TxD8JMQ6bbSVLQ9nkvn8aPrzATNh8LHkSPxZTC74zljcUoRUWQ+vgOu+8C+k3camY/kz
         CBjtdsRcRZ2hEDtflQP/MjbAzA2KvTIsFpd1E80hHnj0rTGV5w8v19NfUuda9ujFOQ4w
         /01WmRJr35bwcYOVv19Vprdo5kDR02mWBKC7Sj7kceZTEmYVGZkDu+ivwdx9r3i8UvS8
         ePmQ==
X-Gm-Message-State: AOAM530eIDgjFfxOiYDpldMgPDnssamf63xBYcxromfYTAw7wsPss/4O
        qMXaclsdM6k8rE5oKCvtQ+74PrVsrtoB8w==
X-Google-Smtp-Source: ABdhPJwCXoLrTOE43Cerbzqv8WzA36QMMa6iqdNqob2pBCbMWJjUmL1hwiDVShemG8Jlgg0owGW0TQ==
X-Received: by 2002:a62:ce41:0:b029:160:c0c:e03d with SMTP id y62-20020a62ce410000b02901600c0ce03dmr2028216pfg.15.1603940467109;
        Wed, 28 Oct 2020 20:01:07 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z22sm970858pfa.220.2020.10.28.20.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 20:01:06 -0700 (PDT)
Subject: Re: [PATCH v2] Fix compilation with iso C standard (c89, c99 and c11)
To:     Simon Zeni <simon@bl4ckb0ne.ca>, io-uring@vger.kernel.org
References: <20201029011959.25554-1-simon@bl4ckb0ne.ca>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <da2ae0ad-df1a-8396-d447-5241d0274861@kernel.dk>
Date:   Wed, 28 Oct 2020 21:01:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029011959.25554-1-simon@bl4ckb0ne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/20 7:19 PM, Simon Zeni wrote:
> - References to the compiler extension `typeof` have been changed to
> `__typeof__` for portability. See [GCC's documentation][1] about
> `typeof`.
> 
> - Added the definition `_POSIX_C_SOURCE` in the source files that are
> using functions not defined in by the POSIX standard, fixing a few
> occurences of `sigset_t` not being defined.
> 
> - Added the definition `_DEFAULT_SOURCE` in `setup.c` and
> `syscall.c` for respectively the `madvise` function (`posix_madvise` exists,
> but there is not equivalent for`MADV_DONTFORK`), and `syscall`.
> 
> [1]: https://gcc.gnu.org/onlinedocs/gcc/Typeof.html

Thanks, applied.

-- 
Jens Axboe

