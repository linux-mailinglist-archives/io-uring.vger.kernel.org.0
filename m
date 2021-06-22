Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3CE3B0D43
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 20:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFVS6Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 14:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVS6Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 14:58:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED2BC061574;
        Tue, 22 Jun 2021 11:56:07 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j2so14318033wrs.12;
        Tue, 22 Jun 2021 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=C1ldvBte5dElMo+OS53IfBDPZQjSCfACMYy0yulDQ44=;
        b=kVqZOTjVwstfjA0+FbY9bQgA+uebRrgeQvTLIgFZ6bpyVA9MG9s0zV6hXQkWxmgqmM
         Qdmh82u4UTAk23P56aXebh2m+Nr/QeKge7Sa5QOCvWQwqE0qZxo3EyM4GzET+Mz8DnPl
         8SsmrZtXFk/XQ0LSRhT803iD4RTNJH9IGmCzMBaXlKNy08z5kIzV06E3qN2tJHZkHIlw
         bhm3rECcLCNqk4ZWfcc2pwrIOFcfzXN4h0wM9C/M87vqF6O8YUHnjuj4t7C+GEdroH1k
         Kufm5PvWlUugEk3E7KAKo2acNFJo2CShfOdjWuZn4Gqv/xWQKjgi3r2xnmYZpCqNTqho
         ugTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C1ldvBte5dElMo+OS53IfBDPZQjSCfACMYy0yulDQ44=;
        b=ZF6ULkpweryq6eh4A/+pt5TDI/+3riF/+4NfCAfswZJY2xKYdLvMIYQi0ErH/Xz/YL
         bAsIao11HZ6TmTmnE8zrH32ECjh5MlcjgUynigQRD4IdjKQnKdVk2v4gVzsNhjMtk/tj
         IIAOSVgb2idJMWfRXi4TJCM7RFWBCwX3HJ7F4sX3TtwmstgwXs4kW6EPwuNr+daYVIcH
         7D35WiV8+M/RHtdg+y2BSUcSAvU19XLwCCwg1VFmql6cf55SgwmNuelBMhOKt0rZ8L93
         wSbhpcZ1lrFkXS46b3/XzXqvhbl1wDg3n6I++PMm/bT2srbnr04n6mg02w/X8OL1X1VT
         E38Q==
X-Gm-Message-State: AOAM533JOKNxvWpB+GFWBZMs49u2oEHsCAMQze/cOek9OrwI2wozptx6
        luXGrkZX9qFphtiaDrJIghJySFFWCp1IWKfW
X-Google-Smtp-Source: ABdhPJyxV0no4+UWZQIvimTmLlCU4VNQ0k6mQDUILcGyrbMUgafeJcYaqdwgs7kFUTruoq86fDicdA==
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr6537970wrx.347.1624388166416;
        Tue, 22 Jun 2021 11:56:06 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id r12sm237428wrx.63.2021.06.22.11.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 11:56:05 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: Fix race condition when sqp thread goes to
 sleep
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1624387080.git.olivier@trillion01.com>
 <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
 <b056b26aec5abad8e4e06aae84bd9a5bfe5f43da.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d9d9527c-6d2e-b840-15dd-057618de7864@gmail.com>
Date:   Tue, 22 Jun 2021 19:55:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b056b26aec5abad8e4e06aae84bd9a5bfe5f43da.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 7:53 PM, Olivier Langlois wrote:
> On Tue, 2021-06-22 at 11:45 -0700, Olivier Langlois wrote:
>> If an asynchronous completion happens before the task is preparing
>> itself to wait and set its state to TASK_INTERRUPTABLE, the
>> completion
>> will not wake up the sqp thread.
>>
> I have just noticed that I made a typo in the description. I will send
> a v2 of that patch.
> 
> Sorry about that. I was too excited to share my discovery...

git format-patch --cover-letter --thread=shallow ...

would be even better, but the fix looks right

-- 
Pavel Begunkov
