Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A5B3A18DD
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbhFIPPH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:15:07 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:41743 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239024AbhFIPPE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:15:04 -0400
Received: by mail-pl1-f181.google.com with SMTP id e1so1271879plh.8
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=swSSpRapk0bk6e5DCL7L3P+PAWoEFuxXvuvR+mMpZlw=;
        b=pCYwzbYeqaLV3t61kJ1n+T99+mJD8OgtsYz3c00V7ZidBuKXQnEJ/XqGG6Icw1EP3e
         uetV1q3lTY+z9TsfSJm4iaP74+pUt/4Ci809WO7X0e0MoDgBiKmwqQaaoIc1d0UmHAIC
         +SKWRpFtQ7u6Tn1NHV4fanyFNhXTA4P3aeyWYUfodVJ+TlI9YBqDa0UVBmo0Rsz9+S62
         pLp2GKexRC8KAHcDP96AOH4l3nq5vBrfAMUmNWBrn0ZIpcFmIh08uhvHogESq+l9bswu
         ryyrdTdWTtIalpXgQkJ0PLBeqU/3XuGZ2Bq9q3MXxovkVlxf4qBAvgGlAce6USt8nGIq
         jSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=swSSpRapk0bk6e5DCL7L3P+PAWoEFuxXvuvR+mMpZlw=;
        b=B+Ym3Z/XfcvJMTTrL94T53EtGF8tIThGDzzt5+VkaqZbhl5OqKfTT1l64hwCdv7B86
         8B+dXOHFxchukXs4vmv4olSUm79NnTTEduBeK8uTo5V7CSLAfJeGnapCPkI+zpcB38k2
         8wgpucF0sfyvxHETkTFApkHK3y2KclmyzsNh9pDD7wZ48rZ3j9vnOw9YD7YydfBc4YET
         kCua8r7jKvZhImUSz65Y5mlcKs3WnEhQANTN9uJ+XzofmGyTXWcGdEQ2nceSGgtOFC26
         v7d3ITvd9CPRj9vx4AMSxSBzb+/wB6ZJDaBCSboPj6eCKJWMwaSsl/CzpmlXiqJzNdlX
         sSBA==
X-Gm-Message-State: AOAM531g7wj918BjYH+Kyr4PBtfx8JnkgaMMmdFqJ9yYJjp3yKEWfihz
        uIMEzaNlFN3rYaa++XGEOfRCXuQaH3tHcQ==
X-Google-Smtp-Source: ABdhPJyrJY+9EGa0RQVo1D6GEf4v+j+NQ5F84lftmxcTspY0RrLfhcoJmy3kgxck2sIzglK2LuIdQw==
X-Received: by 2002:a17:90a:f193:: with SMTP id bv19mr11313329pjb.86.1623251518388;
        Wed, 09 Jun 2021 08:11:58 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id z24sm14448067pfk.149.2021.06.09.08.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:11:58 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: test shmem buffer registration
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c0bebfd100d860fb055af8edf7e56b8838e92719.1623245732.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <04734e7e-4f7e-c1f7-6c4a-f8e63fbc695e@kernel.dk>
Date:   Wed, 9 Jun 2021 09:12:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c0bebfd100d860fb055af8edf7e56b8838e92719.1623245732.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 8:27 AM, Pavel Begunkov wrote:
> Add a simple test registering a chunk of memfd (shmem) memory and doing
> some I/O with it.

Applied, thanks.

-- 
Jens Axboe

