Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6862316BD42
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 10:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgBYJ0l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 04:26:41 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42863 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbgBYJ0l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 04:26:41 -0500
Received: by mail-lj1-f193.google.com with SMTP id d10so13182377ljl.9
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 01:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FIBeL/I6br4Va4/n1rZBg8mC5DbVtS8kjLtf5aD2JxE=;
        b=fNuhSmjyU7nfuRE8jitcUccKoKLrBEduyHSML87R3WDGXgl+7GancLzmCjqjidAr8j
         ZtxqYC2IRT//V4pNhVVLFn9RQGu6sobXj1XnaxneSKh+to6VzR1CHC3Hbtx59xbSV650
         AtVB2r2EuMzEX/gS9jaZsB2WNivGsiH4PNmVGgJqSh9/TJCsKRCaxJd1np3Bl3jTLUI6
         k5JGGyG4BaHOJulpoOOxivM9uN0doBEoaCjXLP+lbtI0yrT9b2A4hbdaKUKSyi3X6mKB
         0juGUEs+w0uylj2yVKKm1PMCJVzahIBylDMyMgb2j02JbJbJxW9O8e1CZ3BVoLoo6+RZ
         fiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FIBeL/I6br4Va4/n1rZBg8mC5DbVtS8kjLtf5aD2JxE=;
        b=SU5yUZMX4RvLRyRyaXukumAlvtOLCYCz64p/fcjjsOKj8cZKS1PeN+XBCTxbrcIXvH
         y6K5HFlIU+gKGXBaifCKbcdY3j2FmIifdX9q9LdLdyGt1AcyeD925v9yWM/WD+31xSjC
         J3hjm1Ex4Q1zxmIlewR6I0uBHV3urQz34dkDNNdW/qPkF9m0DxcMeQOZxg6uelTVzuhY
         fXMoH/PPkLP2cZx2MymVKTD3J8f2iDujjlFLnT7H4IQ0BELu5LUwUcdHZRObVuvfLOKE
         LqRPg13eHTuK+0wm0ffeQ2HXaN0QENjNanpAWUGwcX9j4Ps0EN+Db1p/X0qPCYSgR5G6
         IiaA==
X-Gm-Message-State: APjAAAXj2nktCJUO0oXTiXYfY3P65oKbdjNGrJ7xh6PgjYTmHDxPDMCy
        viHWW9Qb8b1CWRbMlnHiM9VcX1z6LZ8=
X-Google-Smtp-Source: APXvYqwRpf/hSlMT1LXBZXXFkiugQK/pQwJLYFelOV3vQ/qgyDLk8QPkv95pZ0e+9QbnihEPo5urWg==
X-Received: by 2002:a2e:7d0c:: with SMTP id y12mr34083946ljc.39.1582622799005;
        Tue, 25 Feb 2020 01:26:39 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id q14sm7078816lfc.60.2020.02.25.01.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 01:26:38 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
Message-ID: <acb90f56-bb54-90e2-9c87-be4f754b322b@gmail.com>
Date:   Tue, 25 Feb 2020 12:26:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/2020 6:50 PM, Pavel Begunkov wrote:
> On 24/02/2020 18:46, Jens Axboe wrote:
>> On 2/24/20 8:44 AM, Pavel Begunkov wrote:
>>>> Fine like this, though easier if you inline the patches so it's easier
>>>> to comment on them.
>>>>
>>>> Agree that the first patch looks fine, though I don't quite see why
>>>> you want to pass in opcode as a separate argument as it's always
>>>> req->opcode. Seeing it separate makes me a bit nervous, thinking that
>>>> someone is reading it again from the sqe, or maybe not passing in
>>>> the right opcode for the given request. So that seems fragile and it
>>>> should go away.
>>>
>>> I suppose it's to hint a compiler, that opcode haven't been changed
>>> inside the first switch. And any compiler I used breaks analysis there
>>> pretty easy.  Optimising C is such a pain...
>>
>> But if the choice is between confusion/fragility/performance vs obvious
>> and safe, then I'll go with the latter every time. We should definitely
>> not pass in req and opcode separately.
> 
> Yep, and even better to go with the latter, and somehow hint, that it won't
> change. Though, never found a way to do that. Have any tricks in a sleeve?

It seems I have one. It can be done by using a const-attributed getter
function. And I see nothing against it in gcc manuals.

__attribute__((const))
static inline u8 io_get_opcode(struct io_kiocb *req)
{
    return req->opcode;
}


-- 
Pavel Begunkov
