Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA58718F6CC
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 15:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgCWO0E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 10:26:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42548 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCWO0D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 10:26:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id 22so3958969pfa.9
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2020 07:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gyVFtIAdfxxiuKfx8+zJgTL9jcPcCuD4xyjjj0KliPs=;
        b=CnHY57/ca86uVMekD6N3Ny53hrNuxe4odiTn0RFDYZ0Y0mm2nIxe+kxrn3f9Boi2hj
         gdOqFdv2P2UZFyLkTu/uGF0YCjWKZQe1v+qQ1DuaXUFBBljnMTMMrIOqTElIVR+z0qAy
         jgNLUEeI8s47KOhznH3X858mVXYEzxKKxRlEsp7prVW3nIU4EoZk5e8WL5Z2xD0sp5Z+
         qybiCLg6hyiHdcx/pgsQrJ97Od3auJ32eO8vPfmuhSU4FXXnJW021aSDQhYW4zcto4GV
         4nsmIlPuInr89AZsUZNBj+d1ZWDKk6PfhIbaxVla1pMxcnzoVwFohnb3MJEg3UkkzgnZ
         QBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gyVFtIAdfxxiuKfx8+zJgTL9jcPcCuD4xyjjj0KliPs=;
        b=Xgs8alFIyvOENrjZEws+UkUv0HbSlEyFvtWULPCQauvB58XT94zQCFRigETtrjR3HW
         CpJjqPE98wfnJfHKl8+HDJTioJ5nt1o8c0DxAr4mwHsjDJKCvVAe/EKNhwValKVgIDpd
         W3Gwv50n8V9fgl67WPyda0JJlDWGFvB24LuPjrpKcglZ0jHYg2QYV6Ayx3NYvKDkqBHb
         W0JO0wD/n5MU0YNWoz7rxKkKOPZ+OFyFEIvwNfbAImI/yNo2fR5dA9tHlRi6EgzTtER7
         Tc2eUsb1NRUH1lxDTvvEaAisUn3A0adqcccUfVt5Is+3CV60MDtucQFhkOY5tgoKlfYb
         YoSA==
X-Gm-Message-State: ANhLgQ0+i224e1Uop9l3JRtzFQdY36lmzANf5DfnYzK0xw2MK0zHyDTU
        3QObbmNb4p1TWzXUfaj2F2vPdBKGL4magA==
X-Google-Smtp-Source: ADFU+vuVG3gBwPFElTeDuxB+2JMCHW0iXFiE6p4I9CwD1mqp2tRM+40+5hNTHI5OEsJUH5pYQPZisQ==
X-Received: by 2002:a65:494f:: with SMTP id q15mr22381358pgs.383.1584973562272;
        Mon, 23 Mar 2020 07:26:02 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id bx1sm12738920pjb.5.2020.03.23.07.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 07:26:01 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
 <d2093dbe-7c75-340b-4c99-c88bdae450e6@kernel.dk>
 <d316093f-46cd-7ae0-714a-7b90f3df5f1e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b977334-e4d4-b19a-01c9-631e2a52614f@kernel.dk>
Date:   Mon, 23 Mar 2020 08:26:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d316093f-46cd-7ae0-714a-7b90f3df5f1e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/20 2:38 AM, Pavel Begunkov wrote:
>> No, and in fact it probably should be a separate thing, but I kind of
>> like your approach so not moving forward with mine. I do think it's
>> worth looking into separately, as there's no reason why we can't wake a
>> non-hashed worker if we're just doing hashed work from the existing
>> thread. If that thread is just doing copies and not blocking, the
>> unhashed (or next hashed) work is just sitting idle while it could be
>> running instead.
> 
> Then, I'll clean the diff, hopefully soon. Could I steal parts of your patch
> description?

Of course, go ahead.

>> Hence I added that hunk, to kick a new worker to proceed in parallel.
> 
> It seems, I need to take a closer look at this accounting in general.

Agree, I think we have some room for improvement there.

-- 
Jens Axboe

