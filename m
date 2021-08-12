Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E250C3EA6D7
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 16:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhHLOxX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 10:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbhHLOxW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 10:53:22 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF7C061756
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 07:52:57 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bf25so1942169oib.10
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 07:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pSujOi0O+xDmuzKXFBHwC0crGS/A/pfV6LGkL8BeDG0=;
        b=a9OWExA5mhPX1PpKJDMKYmPNi3BPhxrmZwFsLoBnlpOgXcpWc7A0yvS1mlpOhX1k+6
         NGOyRGeroQ/SToTAqOIThQ8UQO4umU5bWwxWKH8PB2A0Ff8xvN9i/o/WTWwbt6kPkGZi
         9rleBoNXUyiC1WblCcea3/Sw+WbZrEyfGZmlCNBmYgmKZV+upkC2NP39j90v2mOv4fyO
         M3at1vBX0uwoWuptiSE8f30A3Z3pZkazz5H/0Ob2cjCdBfOaJ/xaAcXl525sGm/gdm8h
         UnARM/ZVROSWBxSrxPffhlZJ6m6ECMqxjWU9abOJPKo0yl67DxUU/d1IQi4YbqB1cS8u
         jb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pSujOi0O+xDmuzKXFBHwC0crGS/A/pfV6LGkL8BeDG0=;
        b=STyPvsBWvu5jb8eeFFP8MFKd0o+zagCU5lyrjJ4F2bOGDA42LaIAOBOXbyiQ4Tiuz0
         HoVXn74+u0qmRzsociJjPVlVkLUtYy8EDw7a7Hps4j74p64GQ9ktFt/7cS4vMmC7ZyU7
         A/R2MJ9psAS24SD8W71i8WXTgmxMmQG/jgnz2va9P9uMuKznp3WMYdwYRvooDTMuq86Q
         MKyXVRBg9TXQI4pr2GZClC4t+YjDywHK7ywrirz3oKWXjcrBBHk7YmX84KdvSVSCVd20
         y5xCipRYhfBc2AzaU6x/WCqRIw6OwzaHIVwp0Ub5r0ooNdPH2EX52gSF/oqu3MOk5q0I
         EZOg==
X-Gm-Message-State: AOAM533vBUzUp/qkfty0TZ2Qv/FK4pY5NekZ1EvmE9/FKYlnoe5stnTn
        uiDPIr64/opmws35WWc25VFRHw==
X-Google-Smtp-Source: ABdhPJwyPZ5o608iMR+/qClTlJxA5wcfGnhbXnD5DlTcVbH3yiQT5t8fbiAbmwtuTsQWMX+xi2esbQ==
X-Received: by 2002:a05:6808:209e:: with SMTP id s30mr2718429oiw.177.1628779977048;
        Thu, 12 Aug 2021 07:52:57 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l7sm650322otk.79.2021.08.12.07.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 07:52:56 -0700 (PDT)
Subject: Re: [PATCH 2/6] fs: add kiocb alloc cache flag
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-3-axboe@kernel.dk> <YRTFqraI8vckPjRV@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8eb8f25-a539-eb74-e841-c2b024930f46@kernel.dk>
Date:   Thu, 12 Aug 2021 08:52:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRTFqraI8vckPjRV@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 12:54 AM, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 01:35:29PM -0600, Jens Axboe wrote:
>> If this kiocb can safely use the polled bio allocation cache, then this
>> flag must be set.
> 
> Looks fine, but it might be worth to define the semantics a little bit
> better.

Sure, I'll expand that explanation a bit.

-- 
Jens Axboe

