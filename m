Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD0E2AA68F
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 17:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgKGQFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 11:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgKGQFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 11:05:45 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729AAC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 08:05:45 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id x7so4381623wrl.3
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 08:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R8aajLVAnoRrM6bK5KZOXXtyvh6r2cexcxjADScr5qg=;
        b=lncZobuIyMipD1GJxzTy4l96MhD75kRs40/h5EvL4+uw2PNLix0IPqA+K/7rIXp+K2
         u3OKZQpv9msuk3X/msnLYTY/BXUNbcmAWwUE6gJfbkVqVHGd36mNMUq3emeGUR+XuuLO
         ES4XFsY6ODVJyEoSjTY5dg52rWEO86ylDS9O0wXjreoG5ev3eaOjqh9v2NFBrn2B5zSp
         5xAhQHaF26DxvZwa7l6NIWLL+Ld/0lp29FIaU4yELJlCtzXAEKqdTELNM5UW7F9Hl9Jm
         7yLgRTo5VV6d8hQXgi55EZIkLATomzkv7Pgr//v871qWjNxVJZIod+2Pom4daKxTzQ5w
         F3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8aajLVAnoRrM6bK5KZOXXtyvh6r2cexcxjADScr5qg=;
        b=k8BOEjbe6lU3BMxQ3CkDAMVzm772sp32FfvAM1+eGO9y36gBr9DJQ4FcZYoIMloEoa
         0Xu9eiexFzok0FBUUg+ZkDdb5BVN1+io9NJzEE01p/+y9902qVbdo9FyBNvv0pCLAHYq
         SSsJU2G7DpgU/WLXKqNRRH6GTTlApoPnMXhx+eMeJicWXDoFQxXNmlA9FdmpLqaZvD+k
         5G0JhYxZj8TrgMJti7UCLktmRKoUBJaoN53DfM4QBrTrlDd0p3fPkTjsdcp+Yh5zlAk6
         pryFgJiXv6PgMi5HrHnofGgLA1vK4qe40HdDyqqwiRUvTOcs35TFWI4rA+t5mbQbyLiz
         +jjQ==
X-Gm-Message-State: AOAM530t+72mcmKK05+OS7aZW+0tBcvSWmiQ1i7oQ6EQrl7w2XR1Taoq
        aQ34SBVBUKN2R3u+ePzRMY1/Uk5tbL7dOA==
X-Google-Smtp-Source: ABdhPJyajTGGxhvKAKHy54cikEUfago11WMVf++oBYdWg+ubvqGeVx5cl/DzrUZi1HTVe4BV1Y+nQQ==
X-Received: by 2002:adf:9b98:: with SMTP id d24mr8316410wrc.17.1604765143983;
        Sat, 07 Nov 2020 08:05:43 -0800 (PST)
Received: from [192.168.1.84] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id l16sm6592667wrr.83.2020.11.07.08.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 08:05:43 -0800 (PST)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <a09e69abbe0382f5842cd0a69e51fab100aa988c.1604754488.git.asml.silence@gmail.com>
 <80e87448-4a33-99cf-28ca-25f185c83943@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.11] io_uring: don't take fs for recvmsg/sendmsg
Message-ID: <578923eb-0219-ffec-7c45-e44d15372d41@gmail.com>
Date:   Sat, 7 Nov 2020 16:02:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <80e87448-4a33-99cf-28ca-25f185c83943@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 13:46, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>> We don't even allow not plain data msg_control, which is disallowed in __sys_{send,revb}msg_sock().
> 
> Can't we better remove these checks and allow msg_control?
> For me it's a limitation that I would like to be removed.

We can grab fs only in specific situations as you mentioned, by e.g.
adding a switch(opcode) in io_prep_async_work(), but that's the easy
part. All msg_control should be dealt one by one as they do different
things. And it's not the fact that they ever require fs.

> 
> If there's a cost using IO_WQ_WORK_FS, would it be possible to use IO_WQ_WORK_FS only it msg_control is actually use> 
>   if (msg->msg_control || msg->msg_controllen) 
>       static const struct io_op_def sendmsg_control_op_def = {
>          ...
>       };
> 
>       something = &sendmsg_control_op_def;
>   }

-- 
Pavel Begunkov
