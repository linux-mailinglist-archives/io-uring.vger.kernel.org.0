Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1741C35B077
	for <lists+io-uring@lfdr.de>; Sat, 10 Apr 2021 22:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhDJUox (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 16:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJUox (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 16:44:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C9FC06138A
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 13:44:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so6701893pjb.0
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 13:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Bo8J3/vmthGeI4S9k3sEPafecsWtkfpUSdF9OPct6WE=;
        b=g7oA8ICZhn6hs3To6upAEIpferdRrdE30gM95RgB0WRp9GvSbw/wsroh59pNxr11F6
         6AbewISxRro+90CaPK5kpOfIpkfn6zPBeNylm2GT5DPVi2cVDvjLpp8svXgkARK6kYW0
         OjsZ78hSo2ZJE+NHiFbQOeHUZeqaVSA7fAByEOOq3KNTVLRNlo7h/J7Hi+xFR6emc1h7
         XB/Fd7rha0yxq2rG3DxNjFeqZr0RloP7hfYIrR3VsDBMmV8M3L+0e1erM3da1GLCuVmb
         hgUqQp8qm77CEFBK7uhNMRP1PoF+LRk3UxwNqLF8UUcU1G75ZxoyWbsemSbRQ99Q5PA2
         jgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bo8J3/vmthGeI4S9k3sEPafecsWtkfpUSdF9OPct6WE=;
        b=sXWeW+ifP2bjlYgFBIt3Ux5N/nr9dZq+VM7KxkfUK+bkHKGQzBLeyDGIFCfgi8/Vsy
         x+owZpfcbputhfYytSxAUgR1EsCeKeihlPY8PGoC/w9zCp/sVWOeO7d5g0Am5b+7fm56
         u42d8LgvIYawb9VtvK8U9rPXHKwAlvyWkWXIbrqmEyCDcHviEIS+POsLjDqZM7PbK3JU
         Gr6O/gG53AsX8URR87RrPrfYFKRkU//KRtUnXzf6S+D2nrM0n9za5wmLtzHq00fhYE/D
         JkRQD5vtCxH5cNAKVCzu1xaKDd0AqOvkSrt0EfudAM14TMojI8vmQmdvf8FpyLY2ujC2
         Tq8g==
X-Gm-Message-State: AOAM533wOs8YN/NyjL7heS+v3/IckYZNmb7Jgxrnjo6wO5w6gHV9o8Xn
        4LjWVj9gv5pLYgbOrfGc8Wi5TRd5rK/+Gg==
X-Google-Smtp-Source: ABdhPJz9OrDwDU9C5OKKs4RRvBr8DsWIXJqPlTbQXqyLJ0t35ejMpJLpPqXtC28ZWwNHQW9fSs67XQ==
X-Received: by 2002:a17:902:e806:b029:e5:cb85:dc4d with SMTP id u6-20020a170902e806b02900e5cb85dc4dmr18931781plg.11.1618087477360;
        Sat, 10 Apr 2021 13:44:37 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x2sm6713256pgb.89.2021.04.10.13.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 13:44:36 -0700 (PDT)
Subject: Re: [PATCH 0/3] first batch of poll cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1617955705.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e2f3bc4e-18cf-c225-5d19-41929c6fa8aa@kernel.dk>
Date:   Sat, 10 Apr 2021 14:44:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1617955705.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/9/21 2:13 AM, Pavel Begunkov wrote:
> Few early readability changes for poll found while going through it.

Thanks, looks good to me. Applied.

> # ./poll-mshot-update fails sometimes as below, but true w/o patches
> submitted -16, 500
> poll-many failed

Yeah I think it can run into overflow, the test case should be
improved. I'll take a look.

-- 
Jens Axboe

