Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35946175E24
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 16:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBP0F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 10:26:05 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36121 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgCBP0F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 10:26:05 -0500
Received: by mail-lf1-f67.google.com with SMTP id s1so7922480lfd.3;
        Mon, 02 Mar 2020 07:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bukTu9hwl5g5tnxxRv26V6s76cWTVObhbh4EskdLihU=;
        b=OoSkkwh7Cmv3dCPJ/k1vu9Sn5CeBGuir/88pWzCGEYK9jq7EjoUY7/PBZmMJMtmxYg
         M5wWnf3WOrg76bbA8+VQsuj8mj+RbK8UMLq7PR7yIx3LE6+WR3Qn3aO0B3/hMgX3osbS
         a5A3V/GeBRDKnR4zfzy7DoWCALYlD07R6nlmwtF6t0GKYjoEdmqcd5D5Eq/Ft8YmEW7o
         T3QKXKNkhGaPw8hmO+5+OJwDLIYWPREuQarcV4clbrOyR0qz0wo0VOHt4Lss8b2wxfhj
         2F1APIe4aPffFjqqZsd88CVqULmVOxY6U+PxKWHp6JUQcpN9ItxqMzVeMyctKqSlfYF6
         WKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bukTu9hwl5g5tnxxRv26V6s76cWTVObhbh4EskdLihU=;
        b=TSuxY52FDcs2u4vg+c0FYTjHJTGY0YtTjzaKPqTRTa4U3LcnYp/nFibix3qE7esJtl
         lKUU1av7xx6AS/AgJIF//1Gb4g8gFCjZR/68DRTp5bzrnNAKO4iGbdnd7gA+ngYKOFVm
         VkE1OPa1a5dWXOSLDVLC1wOhdJzTlqNc4SpJFXRtUNvGQIUaAe5hVpPkg69PuIIzP/9f
         m91ldvj+B/zNbfgHlsjo6jMtvMhmU00QQi1Jv9s3uTEgPNEdS3qVQlYh7KWwNJcDXxVW
         xlggwzLNt1bOPRA/F8GO5eyyR+w93QNbQK0b+mLiNYcFdQFaBs7+3UCddxNB2+9DXnhU
         vKbw==
X-Gm-Message-State: ANhLgQ3PBBJZApPBGdxikNpkW0tDuqYvqB6TBuDYoOFMtGEgjir5DzX8
        K0Qy8pusXqp2JAt2qSCdUnF0ichNx8E=
X-Google-Smtp-Source: ADFU+vtqfAJonV+lvjYlIT+V/SuYsnMeHhJPyqr0BubSWwv4qEZKQIBkJhE1ZXWZwz2MUZcsbwolqQ==
X-Received: by 2002:a19:ed08:: with SMTP id y8mr11146164lfy.56.1583162762468;
        Mon, 02 Mar 2020 07:26:02 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id 138sm12353615lfk.9.2020.03.02.07.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 07:26:01 -0800 (PST)
Subject: Re: [PATCH 9/9] io_uring: pass submission ref to async
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <29efa25e63ea86b9b038fff202a5f7423b5482c8.1583078091.git.asml.silence@gmail.com>
 <fb27a289-717c-b911-7981-db72cbc51c26@gmail.com>
 <fab1f954-98f0-3576-9142-966982988bc0@gmail.com>
 <902c439f-81ff-7593-e6b4-eee3f217c292@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <19a08aaa-069b-27d1-1cb7-5033b74c2e78@gmail.com>
Date:   Mon, 2 Mar 2020 18:26:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <902c439f-81ff-7593-e6b4-eee3f217c292@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/2020 6:12 PM, Jens Axboe wrote:
> On 3/2/20 8:08 AM, Pavel Begunkov wrote:
>> On 3/2/2020 12:39 AM, Pavel Begunkov wrote:
>>> On 01/03/2020 19:18, Pavel Begunkov wrote:
>>>> Currenlty, every async work handler accepts a submission reference,
>>>> which it should put. Also there is a reference grabbed in io_get_work()
>>>> and dropped in io_put_work(). This patch merge them together.
>>>>
>>>> - So, ownership of the submission reference passed to io-wq, and it'll
>>>> be put in io_put_work().
>>>> - io_get_put() doesn't take a ref now and so deleted.
>>>> - async handlers don't put the submission ref anymore.
>>>> - make cancellation bits of io-wq to call {get,put}_work() handlers
>>>
>>> Hmm, it makes them more like {init,fini}_work() and unbalanced/unpaired. May be
>>> no a desirable thing.
>>
>> Any objections against replacing {get,put}_work() with
>> io_finilise_work()? It will be called once and only once, and a work
>> must not go away until it happened. It will be enough for now, but not
>> sure whether you have some plans for this get/put pinning.
> 
> I have no further plans there, the get/put work only exist to ensure that
> the work item stays valid in case of cancelation lookups.

Great, it'll go into v2 as well.

-- 
Pavel Begunkov
