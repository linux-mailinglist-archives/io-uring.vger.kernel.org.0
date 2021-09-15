Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B5440C852
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 17:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhIOPdC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 11:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbhIOPdB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 11:33:01 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D4C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 08:31:41 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so2333086wms.2
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 08:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J2EDhUfSKr3+xLXBcYbTTlnEPHJQPAffNe4PFsPKFSI=;
        b=MRXTKEMLPPPS2pcABRnAFx4drCUhGDItELlSawVwgX/80Woxo2n2uofk/UFa3qJX7M
         LcQNVsrexRfoVxoSPOGJ+s98yiJMzHvLHS/vF3lAbRHqlvnZfNz2gF1Rxz/V1PjrHXD3
         7kTedI5F1qUlsOw1mv3wLtyIaBAto3tjUqxQgmlTMvmYrBLnIc63PijJ9pfgJ/QbQRzm
         qkj1rrKTzorrCuzZ7QDusqvkAJLksHDW8qGPfLGSCOauVEy3G59QKekBdhlRU0GyZKb2
         CfRjW6UP770Sn8G0P1TuXVeGh5iGVcdOJCPRjfMezFCJ3SW/8WK1iApPyMF20sx7aIrI
         L3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J2EDhUfSKr3+xLXBcYbTTlnEPHJQPAffNe4PFsPKFSI=;
        b=1N8AgmnODZ914vRF7G6mre7xaZ0Rq+eWKzvLc5mvfj9tB3WXTHHcVhVMW5jXyjKbP8
         Gtj6g99Za+QsrlirD+G0jI6uWFtLvhLVRZtbvGsBtYejWc+tS5R8NamGo8OcwTVX4V42
         AW3S91a+ASUEhmNd0JNKRTzbwelKSqW1odOqYYkqs5lT0X0nNj2VU4F+x2jt1FZ7DQxt
         Nymj09OXJKNjpEK19F/GEy5UM6PeafhUaQ0gYiO4uHBRSdi+v4DQzGe7uiJkVTqHvFfO
         ftvJ6dFBV52UnPev93y9ra5VvMnOV9PzBG7nnQZj/z9GOuzGr7eJSndqdC6QLwGuFq8T
         qTjQ==
X-Gm-Message-State: AOAM5316VdGxy92rRxbAQVPTsKkXaT7fJOfn8c4bczgFNbICyinyvNgo
        c/M0b5kw25mWYnb9UkF3xqztj86oKLE=
X-Google-Smtp-Source: ABdhPJykSplCYcLNDhxpj/61yWWUSFpkOjiM/HtbHbQpOuN+TbOcZQ9OPtnFTZGhCc6c1S9nIt3Eqw==
X-Received: by 2002:a7b:c30b:: with SMTP id k11mr306506wmj.49.1631719900298;
        Wed, 15 Sep 2021 08:31:40 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.239])
        by smtp.gmail.com with ESMTPSA id z7sm368979wre.72.2021.09.15.08.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 08:31:39 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add more uring info to fdinfo for debug
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210913130854.38542-1-haoxu@linux.alibaba.com>
 <3ecf6b05-e92d-7d74-8f72-983ec0d790fc@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c5161c85-6e01-c949-e233-7adca5a63c46@gmail.com>
Date:   Wed, 15 Sep 2021 16:31:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3ecf6b05-e92d-7d74-8f72-983ec0d790fc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 4:26 PM, Jens Axboe wrote:
> On 9/13/21 7:08 AM, Hao Xu wrote:
>> Developers may need some uring info to help themselves debug and address
>> issues, these info includes sqring/cqring head/tail and the detail
>> sqe/cqe info, which is very useful when it stucks.
> 
> I think this is a good addition, more info to help you debug a stuck case
> is always good. I'll queue this up for 5.16.

Are there limits how much we can print? I remember people were couldn't
even show a list of CPUs (was it proc?). The overflow list may be huge.

-- 
Pavel Begunkov
