Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82F144620
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2020 21:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAUUz2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 15:55:28 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:40422 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgAUUz1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 15:55:27 -0500
Received: by mail-io1-f50.google.com with SMTP id x1so4311057iop.7
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 12:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GR+VQMmvzuZh3DKvR0dUZ1G3VbRW/6DdPWbWLW9ricE=;
        b=qQuI9AGxngqYrVNaOszXN95qfBHyt8gmEP0MQxQSyLn7IOZcGe8+J+tUu9nVv3lp7L
         5VWKy4zlceXkOK7ujViEjNBYGa5SeF9qyd5omtQWMGB95kJ6HM20KBbhjFGzByIl92Ga
         JAO7iuB/maFSGYPtsqgkDSYo+9Cr7feb/D3UsyMfd0K0uRXn16wvK9928iiFbvRS6YAQ
         La6rBNKqTR+Y7QjRVpX55dvXxzp5etNnkq0csXLkWrEgUwtlIvUGkUnWVezAi8J0mJe7
         hKzxzMZgcAd6U7/Pd6HVpAfEisO9y1yn/ljNOv++v89qvl9HqeYGf02V2ZjM47dVrAim
         eVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GR+VQMmvzuZh3DKvR0dUZ1G3VbRW/6DdPWbWLW9ricE=;
        b=JeJ7a9+H5Hwyyxb+XS6AT4RbKO99espPkxnbxf49mzfb0V+IoriJWohTdgxpx+tdbv
         tEBYTFlaiJ2TYrYeJ4efp+d03PFSaG/LxNywc+SJhL1HNzyMn9KeD4iSIIRvil3hl/Bu
         0Qx+4FBZNTKBDzH4x4tt3cYwSRNJLVFrzkcJLAOdXMKR03JTtLmUlfhBKtnNOilMLOlz
         QegKnhUzeD5oydttPjcrYobntgrr23GapgKy5amswa+9fV5uGHojAhHLj52ajsy/wnWs
         3IsngvMbJnQXI9DIB1lyqkOSgATDPnoFXb+eCUAIU8AAhFxSQIRGfDxoQGS8YrDD5Z5S
         eqAg==
X-Gm-Message-State: APjAAAXMMs6f3zp2lhuTOwILI+bt7XtfmjzFzv3HE9O4LlaA2hS4TnqX
        GNNb+hng917KRQdisSSp/5/ly/QRIzQ=
X-Google-Smtp-Source: APXvYqy/GOH/WH4heFfLRP6SesbjLM6uWs2TY8ZV8bj2vK6T7L3SralFT9/Ittx/sGtup3oW/CRrBA==
X-Received: by 2002:a6b:7117:: with SMTP id q23mr4354194iog.153.1579640126999;
        Tue, 21 Jan 2020 12:55:26 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u10sm13649421ilq.1.2020.01.21.12.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 12:55:26 -0800 (PST)
Subject: Re: Extending the functionality of some SQE OPs
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <8ebf0463-34a2-3416-d7e8-a2be420b1b82@kernel.dk>
 <D27B080F-EF18-41FF-B132-2C23195FC45C@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf63fa41-5d73-dcf0-6ac7-2966a30bc249@kernel.dk>
Date:   Tue, 21 Jan 2020 13:55:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <D27B080F-EF18-41FF-B132-2C23195FC45C@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 1:54 PM, Mark Papadakis wrote:
> 
> 
> This sounds great. It may wind up being far more useful or important
> down the road, and if this doesn’t bloat the CQE, that’s fantastic. 

It's there if we want to use it. And we cannot bloat the CQE otherwise,
the size is fixed. But we can use those 32-bits that are currently not
used.

-- 
Jens Axboe

