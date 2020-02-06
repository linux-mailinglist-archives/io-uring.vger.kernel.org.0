Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14358153D04
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 03:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBFCui (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 21:50:38 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37001 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgBFCui (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 21:50:38 -0500
Received: by mail-pg1-f196.google.com with SMTP id z12so1956854pgl.4
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2020 18:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Qegq55lPgC0BXvUu/wXUbnt5DmIBr/mqJPSuK0MffVE=;
        b=JR6HUENYiKJlHLAt10j6UEXGf3D/qSOezkF4iUhK0bzQ9dbse5/E3WSh8ir9qlqpH5
         jf4Fp/+LIvHw1my1Bvn/J9G5j1LJNvxWv4Jke5XorIRuaL1STjelYKuXD0yhKYhM5oBw
         tHwkq0A/2rKVfz50tVXipbh+lZ7Ri8oOl9Gg4orJ7kQoLc8Q1PFB3f8OpZAuA0mCShMT
         UE9cWtY4R0Fhfu/ZX2vkChVRCAIBpQoIBFmVWnp+QpW1ayTn9Cuh/rGcMKf9U8d1JGbB
         uB5+ZCLlmO2IQmLiJgmXQ9s+Y0Yuri2EVVvLxAkjul6eu9kMo6OxsCuIFBVDj7w3x1Uf
         cprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qegq55lPgC0BXvUu/wXUbnt5DmIBr/mqJPSuK0MffVE=;
        b=Re8oOoTilmTTNiVBA1+c5f9EWPZEZywjKQ1yxVCP1lVqgsudUkEdzyPyjRDubJFj1N
         vT2jlS5PqC2+Us3tsJgcLHKV7bqhmQQqeIyeDrMh+fqIMulSmTqnTX4ZvvG3dvJ0kPci
         sQ550Zft2alZYsaaZaEYhsuP6FIYKLsbIskQgGu/hoeirjXtvPXfFQ5P2iTp8Mu31FfN
         dYRhlnuG/boeaiDucCGlcA7zEHxh7TwIdYoUstHQ/cT9Wf1G9WiH68zIn3haw2CHRWc2
         dpQyXcaYjm4DpJqEWtlgAzVtA51otF8rIF7QOME6ktOfE0C8wba90bLH2aebwRd5Mfs9
         nfIA==
X-Gm-Message-State: APjAAAXsN0kM/GmKMWhz1jBnA2EkE/CIrhWYEr92FnV22CJTAwGGBIcV
        QC11cWtT3wK3hVVyhXYT1/FCfw==
X-Google-Smtp-Source: APXvYqzQURvopbf2xHH7Ke3u3nMN5PBZxuBr5Xtzix0A+O1jwajcJtRtzMV8Uay8e5JjI0gkfxmlog==
X-Received: by 2002:a63:6a02:: with SMTP id f2mr1183633pgc.219.1580957436182;
        Wed, 05 Feb 2020 18:50:36 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id v8sm851074pff.151.2020.02.05.18.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 18:50:35 -0800 (PST)
Subject: Re: [PATCH 0/3] io_uring: clean wq path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580928112.git.asml.silence@gmail.com>
 <1fdfd8bf-c0cd-04c0-e22e-bc0945ef1734@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8c0639c6-78ad-6240-0c18-d3ef8936e2f4@kernel.dk>
Date:   Wed, 5 Feb 2020 19:50:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1fdfd8bf-c0cd-04c0-e22e-bc0945ef1734@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/5/20 3:29 PM, Pavel Begunkov wrote:
> On 05/02/2020 22:07, Pavel Begunkov wrote:
>> This is the first series of shaving some overhead for wq-offloading.
>> The 1st removes extra allocations, and the 3rd req->refs abusing.
> 
> Rechecked a couple of assumptions, this patchset is messed up.
> Drop it for now.

OK, will do, haven't had time to look at it yet anyway.

Are you going to do the ->has_user removal? We should just do that
separately first.

-- 
Jens Axboe

