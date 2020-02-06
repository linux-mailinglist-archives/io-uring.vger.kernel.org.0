Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50AC154C79
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgBFTzl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:55:41 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:45429 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFTzl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:55:41 -0500
Received: by mail-io1-f45.google.com with SMTP id i11so7580943ioi.12
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7EJDgXJItKSHtBqDlGpPXjVpKLFySBu/jYXtj6UBSqk=;
        b=o2TJ5na94rRJqPrzLey6UhOyaQeCV+fXbL9oXrunqYSqw1pwJlDwE0G22NET61LtcX
         71Y43oiTYDi6ldv8WMbqqKkoHJuW46Sb6CMXM1sgTSxOnwduZanEhmT7m7J/SefDAARM
         WME4XkeUq+Tjzu58vXSPJcs1J/nt7mk8T/Aw8hZHo5geX6yvkdIN0k4KQ3kFAvgFfJXu
         Tb0rOVdECcmuDt8vO8Dt+F+UW7zAygiLBmZsp75DS4xfoM8xyfxlrWpA1UfRV2j7EFCG
         PV/p2CV73wg1i6YzpM2OfI0FqGMDtCvk2tfrTvK17Su/oj8ajn6MIeK5YacgEwzw9kD0
         2btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7EJDgXJItKSHtBqDlGpPXjVpKLFySBu/jYXtj6UBSqk=;
        b=OnXhlO5fQ7p2hvZ2t2AtH6OHIJABjqFWBcMvOG8+/JaXRjnY9eknHwl5t+vZWFD3mz
         vPjVNr52Ns4jwjyCFOlI2sdxONhbnJMCi5hFss4n+gPQk+UbLqC8TB3edgJxq+6s3VIg
         J5DfEdBUHbErKdpV/eMCvNkECgfdH0/TFPf0zQ+IfuEoS1eehcD1iFihMTJbxkilpoO/
         oVWKDqw7ZWojctRwjnCFdeYDZrkXQmGn5bd0NyFq2A3d/1ddDRak/7CuSbOkHOJ6HbiN
         3mXWagJZLzdXRbCtzhFmt2H5FnwVaEakNvg+cdKlzReKR5v79zulkAPW32ox0P/ol6rg
         Dr7g==
X-Gm-Message-State: APjAAAXGDd7xyqrLmGOVGFY5YwfTqunl2safE7CN+HoIOFOnUYGP8Tdx
        WXeUjNWsQ04SM6AxkagVeLhCxraTvKQ=
X-Google-Smtp-Source: APXvYqwQ64mS6HQ41I/nwk6tzAjLMk/IwBf+dBUv+mgTa6HnkXBxFKkS7atl+hATRkpB/LmRUwAIyA==
X-Received: by 2002:a5e:8b03:: with SMTP id g3mr34012728iok.279.1581018939563;
        Thu, 06 Feb 2020 11:55:39 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u10sm282505ilq.1.2020.02.06.11.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:55:39 -0800 (PST)
Subject: Re: io_uring: io_grab_files() misses taking files->count?
To:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
References: <f0d2b7d3-2f6b-7eb2-aee0-4ff6a7daa35c@virtuozzo.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b004838f-602d-0992-cb1d-2d083227186c@kernel.dk>
Date:   Thu, 6 Feb 2020 12:55:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f0d2b7d3-2f6b-7eb2-aee0-4ff6a7daa35c@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 9:32 AM, Kirill Tkhai wrote:
> Hi, Jens,
> 
> in io_grab_files() we take pointer to current->files without taking
> files->count.  Later, this files become attached to worker in
> io_worker_handle_work() also without any manipulation with counter.
> 
> But files->count is used for different optimizations. Say, in
> expand_fdtable() we avoid synchonize_rcu() in case of there is only
> files user. In case of there are more users, missing of
> synchronize_rcu() is not safe.
> 
> Is this correct? Or maybe there is some hidden logic in io_uring,
> which prevents this problem? Say, IORING_OP_OPENAT/CLOSE/ETC can't be
> propagated to worker etc...

We track requests that grab files on the side, since we can't safely
grab a reference to the file table. We could have our own ring fd in the
file table, and thus create a circular reference if we incremented
files->count here.

Looks like we might need a 2nd way to know if we need to use
synchronize_rcu() or not, though I need to look into this particular
case.

-- 
Jens Axboe

