Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034501297D5
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2019 16:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLWPPC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Dec 2019 10:15:02 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44105 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbfLWPPC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Dec 2019 10:15:02 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so16444804iof.11
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2019 07:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LBvGCNi+anbEbpi3zkoyM1F2hXLj5z8NY72VD4kbY6o=;
        b=eVCuFzDLL5jgrV9OOXszczK8TiT3Soal1n57SiPy43LFMfLZxEEPcfDkoLade6+57f
         zSV1MRDZ3CZ72JTv/toBw6JsWHjZbgY97x7v/uo6Fy4JA3egh02Vc0GcUNoyzwgz/3v2
         AHVBxGnd60WnQSUJ7PhqX/KjG0lFhK6kfbtUaWwUOxEHYRrosUrv1FkfAeAbmVEaZEIs
         WbEdrEYWhYz8LAXhGo1slmSJDfxnVD37y10BlRruPY6hohz4lKCwQlv62qWnW+6BfW9O
         zwNIM3rhA13eWYBPhwJo4GOH7jKWTtKGZ4KdtpfVBXi0nrbUMZfY2+NuC/kx4jmLGohd
         LGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LBvGCNi+anbEbpi3zkoyM1F2hXLj5z8NY72VD4kbY6o=;
        b=PtqwcN4mK3rQL6GwsPjsKW22SO88CZplYd5vw2cyCchS8Z/QBjesXtJYl5guRv7QgC
         K90YMrLQxdOB/dALPSEgs9KeH5RBlzkdVS7pLfkmVchs5XI3lmorjbEo+4i1SdLRj7M6
         J8o/RyRAs+LdXRfa45orUx1RQutSxsf7yjHeNsbTvdYEV4yT8o1yVYz3irl+J/agdZVg
         gtnXwZ6dzvndnNB8WQLpoWnM1id2JBDBsKdS58uzQvvLI35N77PJvywo1+2hh2CLPFzi
         sBSJrE+yrBurouIUV6h7MtZTAFLyvCdPvFbn49RTcL0y2qIAYfm5EKrN/xki/DPnvefg
         wGCQ==
X-Gm-Message-State: APjAAAWZmmtlXUOVD0jiSckh/DOFAmJMkikHs4SxbzTNSleixX+B2VZv
        1OoVFfF2t5ViE8QwBw/N8gdpoA==
X-Google-Smtp-Source: APXvYqySb01gRQNNzS+W5y0NVs1kzchfdkxFn/knh+2PB2KuwmFB9woYyjd3ezsQAy7Ua3SNczxCww==
X-Received: by 2002:a6b:8ecd:: with SMTP id q196mr19898511iod.136.1577114101835;
        Mon, 23 Dec 2019 07:15:01 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j17sm9171006ild.45.2019.12.23.07.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 07:15:01 -0800 (PST)
Subject: Re: [RFC PATCH] io-wq: kill cpu hog worker
To:     Hillf Danton <hdanton@sina.com>, io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
References: <20191223024145.11580-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ae2945f0-c3ff-7d78-4947-f87c3026100e@kernel.dk>
Date:   Mon, 23 Dec 2019 08:15:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191223024145.11580-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/22/19 7:41 PM, Hillf Danton wrote:
> 
> Reschedule the current IO worker if it is becoming a cpu hog.

Might make more sense to put this a bit earlier, to avoid the
awkward lock juggle. In theory it shouldn't make a difference
if we do it _before_ doing new work, or _after_ doing work. We
should only be rescheduling if it's running for quite a while.

How about putting it after the flushing of signals instead?

-- 
Jens Axboe

