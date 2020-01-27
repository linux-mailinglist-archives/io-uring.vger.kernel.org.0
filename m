Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3E14AB2B
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 21:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA0UeB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 15:34:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36657 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgA0UeB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 15:34:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id 185so1667240pfv.3
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 12:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qx5Mwy1HGTone59HD0v5YKqMJwoLzEggjX1nODaTJDQ=;
        b=YJS/GTi41XA8H3ypF1EYYWveOt8L81W7Zqwl4eK4XM1Xh1v1hkuB4dOvAg3lyDMAgS
         nhAdC5SsIu/wt5A6euibJ6GxVjaRVubsT6eHydFskkXM7yxEhBtHw5jHMA3x7doP70Uo
         jo+iDHPpGh6ojfOkk18+xuPEwy3NIfwPemM7942bXqkyAXVqotOPBnF4nB6slbDrWl7V
         fv4eOqt7BP+H7D0f+1B53Vl+mq6cTz+vQiiNg6eaqGH+wpwUKRFsMBwYzqoEv/OL8qlm
         MQOKJKgdEUt62WAbDWQLyuyXj1iAtGx5hgy+AQNiX2W3jFP7U+bZbB+dMGuS3l2sJ0wb
         QdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qx5Mwy1HGTone59HD0v5YKqMJwoLzEggjX1nODaTJDQ=;
        b=OrYdXyqlRao4srBuORoGthVt4uliRmKG07yOqvKEYpo8ZgDuwwKJ9GqGHCMXeRFPlj
         NB2Gp4YqTDzIST8qqw5K+K10Buc1k46gjC6hC776htTWLNixX5MOKoAAAJiTqqpVDsAA
         /e7ZS4YWOgw4uGSMae2V45MV0NvjpLj8r6K1mh9Jk78WN7ByPEH2vHtN8a4r6XKo3Dlv
         EZNA8bIfWiA8PhSeKGVGLCkVYHSwIaF9/1RkghN4TSV0RcCdY5J+eyhbezsA+93ki8Fj
         WrNuSiRalSmhUmyg9FMtodOgO4ZtqpvXDMBNqHJqcvGQmBF286VG3XquWHeFrTqxXQjc
         k/dA==
X-Gm-Message-State: APjAAAUUUwQbyP3OrzHDvNUdrGl44QrGpc79WY39sHJPQc/DcIUGc+p8
        lL5w71jIbEmKoaqDCmPe7lKN9YDXz/o=
X-Google-Smtp-Source: APXvYqy8CHfzsAH8BjNIjC0D9MS0AAbN07Zd20dOwYSbiLt23Y7gdxMvttBQz8s/wwO+8kbbxI132w==
X-Received: by 2002:aa7:90c5:: with SMTP id k5mr413588pfk.143.1580157240640;
        Mon, 27 Jan 2020 12:34:00 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c2? ([2620:10d:c090:180::dec1])
        by smtp.gmail.com with ESMTPSA id i3sm17486239pfo.72.2020.01.27.12.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 12:33:59 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
Date:   Mon, 27 Jan 2020 13:33:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 7:07 AM, Pavel Begunkov wrote:
> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>> Ok. I can't promise it'll play handy for sharing. Though, you'll be out
>>> of space in struct io_uring_params soon anyway.
>>
>> I'm going to keep what we have for now, as I'm really not imagining a
>> lot more sharing - what else would we share? So let's not over-design
>> anything.
>>
> Fair enough. I prefer a ptr to an extendable struct, that will take the
> last u64, when needed.
> 
> However, it's still better to share through file descriptors. It's just
> not secure enough the way it's now.

Is the file descriptor value really a good choice? We just had some
confusion on ring sharing across forks. Not sure using an fd value
is a sane "key" to use across processes.

-- 
Jens Axboe

