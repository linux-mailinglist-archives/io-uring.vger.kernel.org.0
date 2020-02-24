Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6892C16AA6A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXPqX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:46:23 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:43511 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgBXPqX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:46:23 -0500
Received: by mail-io1-f47.google.com with SMTP id n21so10683821ioo.10
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xAXRmre9xt18tThzzHxhWHuXnWo/Y+ls/Uz3k5fi4Nc=;
        b=TkYNhQ/t4X7I/BlXrjhq6T/CIMK7qJ+Xud8v4YfHnC3Hcyfqj/3z6Hy/JjqMGK9xB6
         Jl1qsdTGjS1RfykSpBnYo1nciV9xUlTefgZ6HhbNKHW6sPh3ttKa0z48+UQET19mbQme
         o0kQNWnplvD01gkCcElXcz8Fxc9t+NISev33ABc1ig9P5blI2rgLPJ5boTLeBrdvzuYu
         kYLdy1fjIX9exTjV9t+pi2h0Tp6CusIVzvLF6u4jgpT3Aa/D2stYKHtNbIT5lS1/Caua
         B1MiWEtKi8L5kYqQUa7UGaMptHnJuJgQmxcOH8+B0FfGnSUrVhpB8/Kzj/x1zw89T9qW
         Fkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xAXRmre9xt18tThzzHxhWHuXnWo/Y+ls/Uz3k5fi4Nc=;
        b=uEAyQQbcsjULeMYK50+KZzaGTBQDD67cK6/JeokygCtx6Q39Gz94RQS7JP/DVvq6Zx
         1KG6pWhTGbCTKLI6SCLEeqJRgbtLTf5Ui8dx42t3sVVmbO3bUhZ6QnhFGErRsJWEEtk8
         r1mf6d7VDfNKSwVQAg4FWyCCPeiNNEjlmIejXTq4FO8WosXuHX3Q4QGMMpCv95qGA4op
         Fo2j4p4cJ2ar91ydr/GNjprv9AzloUhz1lfmZYf/k0QXWeXoTS+HGeesvKf9S5F3VWxy
         xXZzHJ5LOK6b9WI+Z5a+tq8nCugf8Atj/BvsbvxJW/4Xm/gA0A9vGBZ9dxnPM9M7iEnA
         CSQA==
X-Gm-Message-State: APjAAAXc69x7nZNq2XOEbRtqLo6nLnkShdzb+dgQXv0ElIOOFYxlc7MV
        CR3CZGaaVvA4bNlUhBAvDIy6FRIKpyE=
X-Google-Smtp-Source: APXvYqxvo/t4s0givnc6Xha5C8aBDsFyXc6g7Um0352ypyFnQYeVlShtsFBPCDJXgsGIWl5FL3VYmQ==
X-Received: by 2002:a5e:d616:: with SMTP id w22mr47921375iom.57.1582559180437;
        Mon, 24 Feb 2020 07:46:20 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 69sm4408053ilc.80.2020.02.24.07.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:46:19 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
Date:   Mon, 24 Feb 2020 08:46:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:44 AM, Pavel Begunkov wrote:
>> Fine like this, though easier if you inline the patches so it's easier
>> to comment on them.
>>
>> Agree that the first patch looks fine, though I don't quite see why
>> you want to pass in opcode as a separate argument as it's always
>> req->opcode. Seeing it separate makes me a bit nervous, thinking that
>> someone is reading it again from the sqe, or maybe not passing in
>> the right opcode for the given request. So that seems fragile and it
>> should go away.
> 
> I suppose it's to hint a compiler, that opcode haven't been changed
> inside the first switch. And any compiler I used breaks analysis there
> pretty easy.  Optimising C is such a pain...

But if the choice is between confusion/fragility/performance vs obvious
and safe, then I'll go with the latter every time. We should definitely
not pass in req and opcode separately.

-- 
Jens Axboe

