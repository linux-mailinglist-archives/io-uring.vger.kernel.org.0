Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B688214CFB4
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 18:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgA2ReN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 12:34:13 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:37035 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgA2ReN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 12:34:13 -0500
Received: by mail-io1-f46.google.com with SMTP id k24so647291ioc.4
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 09:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WHw1X9Lw89CTmFKgLlcuszF0Rg+9rtM3hI/h17kh3bI=;
        b=f8Q392En5TautCdJ1QomAVS87wtKuytyLSEXpr4kYsD+qI8D46Ge/PBza5psrXhv8m
         OYJlh6PYTtUSiFdqea5Bof2GCq2k5CDvjQ2vgWalOorKs6hxQi6NUdQkfJBht3jBfjXS
         4oVrB9hcJWY3yE5mTPzwsXjMqQGgm3Dlc/vq/8GhOiElD+fX8qrrIk8bVCES2vOhi2p/
         RRWirw6mX5MyphQtXYu1v1E2QlvtxqYmeGBJ4vjyg22asUceMHYW4N9ODxyetndlLthS
         RukvblNbaw6ow5jgWWGCPiYc1w+vhgWtZKhD8SmgC06zI/TJk5McKrq3XUuTp2/1rVdK
         Xghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WHw1X9Lw89CTmFKgLlcuszF0Rg+9rtM3hI/h17kh3bI=;
        b=s6UF8ECSN4MCu1UU3LLTgc5/PLSNaq6wTkMRgeAthmJldwYXzeuYy6gIjFm1S8aXHp
         vjuHWwa8Mc3MWdgQxCI3fGseZp8SCFWSKlJkny/RLBTqSnjNPEvLGgxwLWY2ZL3zBw3C
         NuRLbnStfvaiCd8y1WHY3A0lPpg0ATRihg7/lfCItIzJHOrufGGQa6NO+Nz1XuIqBkW1
         b+ZuFR2pCcDnPorddww30oBdkd+aAM0TSOMQ3Zli1SMEXB7lzQsdPJ40ploovKgLfoSm
         Wq3pQs0XdF225iXW+jpG8zy9Ktnn6cavqh3FRUPnABlBnN1yDwRWOonmMtqyaYOi/ktX
         sV2w==
X-Gm-Message-State: APjAAAXo7Cp/XNrnjRHOkdHdiGFQYZadee9wVXYcD3CV5ssR0zOS1/+4
        OXHRsImXLRW7b/iEereDetIt0A==
X-Google-Smtp-Source: APXvYqxyRzjsQQdZjzIrF7fabQbjp9nx49v1HvGdu26vGzioZ/NZnE1lBC7lT3kDwx5/LoaX81Ndpg==
X-Received: by 2002:a05:6602:193:: with SMTP id m19mr450888ioo.222.1580319252178;
        Wed, 29 Jan 2020 09:34:12 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f76sm908937ild.82.2020.01.29.09.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 09:34:11 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9aef3b3b-7e71-f7f1-b366-2517b4d52719@kernel.dk>
Date:   Wed, 29 Jan 2020 10:34:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 7:23 AM, Pavel Begunkov wrote:
>>>> The override_creds(personality_creds) has changed current->cred
>>>> and get_current_cred() will just pick it up as in the default case.
>>>>
>>>> This would make the patch much simpler and allows put_cred() to be
>>>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>>>
>>>
>>> It's one extra get_current_cred(). I'd prefer to find another way to
>>> clean this up.
>>
>> As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY case
>> and the if (!req->work.creds) for both cases.
> 
> Great, that you turned attention to that! override_creds() is already
> grabbing a ref, so it shouldn't call get_cred() there.
> So, that's a bug.

It's not though - one is dropped in that function, the other when the
request is freed. So we do need two references to it. With the proposed
change to keep the override_creds() variable local for that spot we
don't, and the get_cred() can then go.

> It could be I'm wrong with the statement above, need to recheck all this
> code to be sure.

I think you are :-)

> BTW, io_req_defer_prep() may be called twice for a req, so you will
> reassign it without putting a ref. It's safer to leave NULL checks. At
> least, until I've done reworking and fixing preparation paths.

Agree, the NULL checks are safer and we should keep them.

Going through the rest of this thread, I'm making the following changes:

- ID must be > 0. I like that change, as we don't need an sqe flag to
  select personality then, and it also makes it obvious that id == 0 is
  just using current creds.

- Fixed the missing put_cred() in the teardown

- Use a local variable in io_submit_sqe() instead of assigning the
  creds to req->work.creds there

- Use cyclic idr allocation

I'm going to fold in as appropriate. If there are fixes needed on top of
that, let's do them separately.

-- 
Jens Axboe

