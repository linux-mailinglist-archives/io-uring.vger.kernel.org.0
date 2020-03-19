Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCD718B9B7
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2020 15:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCSOs1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 10:48:27 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39121 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgCSOs0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 10:48:26 -0400
Received: by mail-io1-f67.google.com with SMTP id c19so2517679ioo.6
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 07:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pnXoHEC35T/2ZNDlJjWt1Rx6rLLT4IWH18roMdnuB2c=;
        b=15mcFeyBHzRi6+IZbM8k4K2+ZUcwY+QF2SlhyMBR2AZ4g1Efv3BZeLOPbOLrsUKy3n
         CAc2t2iNYiRYQGUiijO+3AODETz01aHgO7e4uiSAPge333cdSvOFtGY0MwV7J3keJEdG
         tbhV/cEOoD0X1LZN4Nefg0aSu/DZ8GvzTrzbz7GDlfkI3c9Tv+/BYc8x9carqhLOFw9s
         f2f3vu+RIxeafGSdoFKoxQPC0YfnYoXzYWwVLpg8qAbC6L3Bzrp8K+YKuiyWw6HTKv6i
         f4WIevL4hW+iNBnKy3XzMpJaXIiHpyJDC6UQ4JTZh8UuX+lj8Ruq7Hxua3G6WGq6SrNb
         Le2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pnXoHEC35T/2ZNDlJjWt1Rx6rLLT4IWH18roMdnuB2c=;
        b=jmivlAtjgmfT2wsIPnzPJYkFWoAqJQVoSiHX9heJOVM+wPvrA9Gbhnzl+rAA57LlJd
         sBg6W/fS/ZmYZ1EPCKomzTMD9RpCRb7M3RGXAiOaH5A4YJ4brsZIL7EBB+xzRAcx3isJ
         dDKA8JZdbOanvpJJ5yH4MeZ6zhC/ClgHnLoV0cg2Jl9mrMTcm3U8yhgqQxZpvfDfoKkh
         ku25+fqu6hvfBLXc4pe9K0k26jHBzmxnpvhblaecPsSQN18k7rV6h8R6/ojuNZZXiVnZ
         fkJomlk60UQHscUoyQShOdKSUj+64ei7CUxwiOA/PrnN/7RHQf0U5NYMw5juI3IOr6M8
         vjqw==
X-Gm-Message-State: ANhLgQ0uDAJrxmCXmO4eFa8HGcUQDgpLn/ZfCdAqsngrCLjHRPszHxU7
        LhAl+VE744s1KQTgDsw0LQYNfE7vEL5aXw==
X-Google-Smtp-Source: ADFU+vt9g8RBpkrW63UVR7gzsJWgP4sMdUGb2UAWZ6JLxC39b0geED7RtATbU0N6A29wTf5fBtDrQQ==
X-Received: by 2002:a6b:bd04:: with SMTP id n4mr3008848iof.196.1584629303915;
        Thu, 19 Mar 2020 07:48:23 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 7sm830572ion.49.2020.03.19.07.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 07:48:23 -0700 (PDT)
Subject: Re: [PATCH] io_uring: REQ_F_FORCE_ASYNC prep done too late
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <d9c7608a-a5c5-8082-1b74-90ce690288b4@kernel.dk>
 <aa52134d-5e0c-6de2-ebdd-f77119fb7b00@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <88a4070c-24ac-ed34-4853-e82c681e1959@kernel.dk>
Date:   Thu, 19 Mar 2020 08:48:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <aa52134d-5e0c-6de2-ebdd-f77119fb7b00@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/20 4:41 AM, Pavel Begunkov wrote:
> On 3/19/2020 6:51 AM, Jens Axboe wrote:
>> A previous patch ensured that we always prepped requests that are
>> forced async, but it did so too late in the process. This can result
>> in 'sqe' already being NULL by the time we get to it:
> 
> Isn't it fixed by f1d96a8fcbbbb ("io_uring: NULL-deref for
> IOSQE_{ASYNC,DRAIN}")? BTW, the same can happen with draining in
> io_req_defer() -> io_req_defer_prep().
> 
> Can't look through your patches/RFC properly, but I will try do that
> this weekends.

Ah I think that it is, I was running the 5.7 branch and that one
doesn't have that patch. Disregard this one, I think we're fine.

-- 
Jens Axboe

