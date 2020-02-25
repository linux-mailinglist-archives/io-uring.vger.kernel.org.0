Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274C016EF77
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 20:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgBYT4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 14:56:23 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:39801 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYT4X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 14:56:23 -0500
Received: by mail-il1-f193.google.com with SMTP id w69so266104ilk.6
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 11:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0bnuIoazpdi1bqhMGp/ogy10VtN2OQHp+Tim58aiY2g=;
        b=WlJ4eggYyACLU6mSD9CpIOzS3bb55piyaX7m2/+ZRAElAdNbwgv+Yie7ki1BN+QFoF
         O4hwGmSnxK2FYHB5dVu/4vXlvBmrVmGHpIVkQzjMHqKVH5N3yzSAsn3pMBjNtt0ycUsz
         ZMd2YApqYl+J4E6xhE9YMX+1jfsCtdfsVFzeYBYgrtc/y/OHoxBRpwhvEAIAyBZiHpgY
         L5QqSm6yNDSDKNZCJ8oi/W+rj4yDElRFJvhCvUjEc1I3cEMIlQ0hMue0IkSc+WnKOgk6
         sP9xkGq0qdxaRIh3j1BO9ydELn+ouqp4WeNip/D0Uc9Yi8Z92FCCssOMRUK18EC8vOPj
         KaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0bnuIoazpdi1bqhMGp/ogy10VtN2OQHp+Tim58aiY2g=;
        b=A4RBf2UGMqu3K8spAa1yoPFUT0gFH1j79VnJpuiT8BlYEjnv2tV0cc+GY/yvc8uYEk
         W4ASYrZeH3BLHzQWcCA7AB7y6GTbHX2yEb6ZHzUXjfSPcbkKvOcUfmowdkWFJyM3K74a
         1/eMt7U2/69gs1gLtCfCx+tACZ/dgMuZFVROSNcZ7k3L6EFoxndJ4Ej6JfbsNcW+eiw8
         Y8YWhXt48zUdZtK6ukSTeAk9iqb5pbaS17w4CAhgtfudH3+JPaEdfF6S0dwDmaCPd6Ho
         SJw30SR6xTXens9ziqQFoVjBWiFMw4oing0GeA3Yignpd/7/dS8izwL8Nwy1BBwHysrN
         wWqw==
X-Gm-Message-State: APjAAAWjFxsSPA7ysbgE+igXMybw2aUb2jEsxmGpvg7oe+EJ+lcfOKU/
        J71SWH3d96nev909Kpnfzl0U9ku4hqo=
X-Google-Smtp-Source: APXvYqz7/q3LuErQVZbxSPEhPAppA/9x15QU7YrvwcTpk32dQTlhoK4pTMPqEqo7awRsPUUUCwc/1w==
X-Received: by 2002:a92:8692:: with SMTP id l18mr331732ilh.208.1582660581598;
        Tue, 25 Feb 2020 11:56:21 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm5891793iln.81.2020.02.25.11.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 11:56:21 -0800 (PST)
Subject: Re: [PATCH] io-wq: ensure work->task_pid is cleared on init
To:     Bart Van Assche <bvanassche@acm.org>,
        io-uring <io-uring@vger.kernel.org>
References: <c3ae0a5d-0557-cdaf-b38e-9d47605c2347@kernel.dk>
 <78cb95d8-781f-3046-e161-4bb2a2ca3622@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb536688-78e1-2fc5-664f-788418b6915c@kernel.dk>
Date:   Tue, 25 Feb 2020 12:56:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <78cb95d8-781f-3046-e161-4bb2a2ca3622@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 12:38 PM, Bart Van Assche wrote:
> On 2/25/20 10:55 AM, Jens Axboe wrote:
>> We use ->task_pid for exit cancellation, but we need to ensure it's
>> cleared to zero for io_req_work_grab_env() to do the right thing.
> 
> How about initializing .task_pid with this (totally untested) patch?
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index ccc7d84af57d..b8d3287cec57 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -80,15 +80,7 @@ struct io_wq_work {
>   };
> 
>   #define INIT_IO_WORK(work, _func)			\
> -	do {						\
> -		(work)->list.next = NULL;		\
> -		(work)->func = _func;			\
> -		(work)->files = NULL;			\
> -		(work)->mm = NULL;			\
> -		(work)->creds = NULL;			\
> -		(work)->fs = NULL;			\
> -		(work)->flags = 0;			\
> -	} while (0)					\
> +	do { *(work) = (struct io_wq_work){ .func = _func }; } while (0)
> 
>   typedef void (get_work_fn)(struct io_wq_work *);
>   typedef void (put_work_fn)(struct io_wq_work *);

That's not a bad idea and would be more future proof, in case more fields
are added at a later date.

-- 
Jens Axboe

