Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84FF305150
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhA0Epc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhA0DCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 22:02:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5D7C06121D
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 18:43:02 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 11so243513pfu.4
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 18:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nEQZPRIBUBvaCOi6qJVJQtrSH+Ox14KjZrlstbQHql0=;
        b=M4gN/y8A5y9ykGJHMs85eRlKI3pLHxRTGCN9VoP9RG1H2N7uFUoP9XK/JnPJMBBoOA
         Qz1FBffNVL2ns1Gvz2ld/CwQkTiiUCsuD/edcHEY8z/8SqHsFq4LdORALGmeHSEOCEgs
         w758LKa2VHjS59YUaz0k3ua2pQRHfKi6rf1J7UjifLuKqzWDAo9C2UWu8a8PH2dwd2+r
         3sDoDBsJpWAbymPNVBjEeLEbgTHM831Na94ZE/xCw2ozDQLY4y2OpVXfI/GNdanNkWL/
         HZ5L016B5yKFmQpMf8OZNGasyZNj+y+ee5ShuATPQON+v4MbrpyKRYmmYtVvTig/GwV4
         GU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nEQZPRIBUBvaCOi6qJVJQtrSH+Ox14KjZrlstbQHql0=;
        b=XhgMlukCAE/Iv2TKTYmyakVIhe3Vnv70rJPgWJEYeI7WFWcFRmUMkkQbkha55qmv8Q
         gWQY5fg7StwLssFR3kTR8reBFP50jgauOtMqNbjl6mCK+HshxkTiDgrECenKwnlDXhEJ
         4hFbGrkrA1Ge30QPFQIPn54BuqCNWrQBzHgRiFWoTVmbjTYDTn+pMtFoGrEPbpkcUXUB
         T/1w6SS7GuJAyUoOajrxuVQRplKH7aJ/AzabwS3TF7+oP3VbNSTMR+VS3gMpi3ddvTNe
         37hMO/YhAvm7YMWyTWG/B3QpYWW4UEs+TPW1BBlJ2Up5laU1PqgkjbnR2ZTl29sIlkvk
         u3vA==
X-Gm-Message-State: AOAM531HX0yDM94wN93eo8yCR5E3QPaeMQOfIkzQj6yTHMFdAngZc3+K
        bV+vlgXOT6RYTC4MxKmawQ7wP0o8HLM/mQ==
X-Google-Smtp-Source: ABdhPJzyYSEEa2Ve9KkTe7Zr0vVt1XUCQ4TLhzfled4g/Do9PEyYf8Z3ZWF7olpgxB9HwLDf5MJeyg==
X-Received: by 2002:a63:710:: with SMTP id 16mr4836315pgh.73.1611715381737;
        Tue, 26 Jan 2021 18:43:01 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id e68sm398014pfe.23.2021.01.26.18.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 18:43:01 -0800 (PST)
Subject: Re: [PATCH v2] test/drain: test draining linked timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <bea8a84405fa2b68a4c18ecae7b80cc2c983002f.1611711577.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <69a98b9e-e1dc-19ae-3117-18dd3a2de51e@kernel.dk>
Date:   Tue, 26 Jan 2021 19:42:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bea8a84405fa2b68a4c18ecae7b80cc2c983002f.1611711577.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 6:41 PM, Pavel Begunkov wrote:
> Make sure references are accounted well when we defer reqs with linked
> timeouts.

Applied, thanks.

-- 
Jens Axboe

