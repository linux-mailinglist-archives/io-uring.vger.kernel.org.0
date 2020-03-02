Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928F0175DF8
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 16:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgCBPMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 10:12:46 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33209 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgCBPMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 10:12:46 -0500
Received: by mail-il1-f193.google.com with SMTP id r4so8243622iln.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 07:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JM8qiDVf3FT7foBs7e7M/gWL0uo4r9RuZV/GlhvHF5E=;
        b=RJ3kAcKBZkXKOQ23jTtmHNMnviZkbOHwmdnJQM7EDtr4Ug0obmdJogZPtQ/cXCGFCq
         pSTmU/F5qbGUS612kjfeOdV1m6rTn73IaD91E7WDIzaH9QZE9xS7ktEWmjk1srPFISNl
         dI9H3Ma9desXp6Z9LLoLHXb45qednni9M4fv2BGXFbKeCxvpZXTu+BKKT76BFHZcrlcd
         /UNs++0q6p87N8s/bW/pIzvMeqPt/4+v5lkS+knJCEZcQ3bLufj9Me344alsQK35KHWp
         tZ+AfknlqtRF9Yxb3HJ4MngCjdxByLCgepY415ZiIGYs2TZfzDvV8jLKbpmISYnIgv2P
         +9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JM8qiDVf3FT7foBs7e7M/gWL0uo4r9RuZV/GlhvHF5E=;
        b=ssjLP/wGBKjzhLHYBjtZjZhvtG/n2WURVQi4It3E8J1mbngWPBBmhpOu3ya1SxIqAa
         djjy+iPXddGc57AmbKQpuIHPYCdCG+6K9gA1HAbXH4cuR/XPhCfGzQ6J0ATVykhBDFxR
         Lzrmrm+eqYPFcrtuFG9b53MTlzuP0ApueNQAQLQStLPPKrrgxkb8ETwhrVB6eyE3t7y0
         M5ig2tBNBmJAzgqnshDPTgrQQw5YkwochBTbkW5osAeEIC1if/sV9tR9jyetugPBs5nW
         RSZWYmq+FSuObws6mYNCXFHFU5zsaOwpiTJCWR4kG1O064jcaMS4OZl7sNdBNKc+MHk8
         7zTA==
X-Gm-Message-State: ANhLgQ3NxKXgfF79OqaLbjyxRgppGHOHCoeHa2pHSawki8NnldF+Z7xK
        dzTPXnKVe3fEP9n6I8OrOeVZAg==
X-Google-Smtp-Source: ADFU+vscJJdirQrtM8w9QQkeIKWqzNeYMMO68t+2Mwpe1FD1DgCwrGbVglGsHC/mfGOrEBHwswejLw==
X-Received: by 2002:a92:de03:: with SMTP id x3mr112262ilm.146.1583161965402;
        Mon, 02 Mar 2020 07:12:45 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y4sm1345506iot.42.2020.03.02.07.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 07:12:44 -0800 (PST)
Subject: Re: [PATCH 9/9] io_uring: pass submission ref to async
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <29efa25e63ea86b9b038fff202a5f7423b5482c8.1583078091.git.asml.silence@gmail.com>
 <fb27a289-717c-b911-7981-db72cbc51c26@gmail.com>
 <fab1f954-98f0-3576-9142-966982988bc0@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <902c439f-81ff-7593-e6b4-eee3f217c292@kernel.dk>
Date:   Mon, 2 Mar 2020 08:12:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fab1f954-98f0-3576-9142-966982988bc0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 8:08 AM, Pavel Begunkov wrote:
> On 3/2/2020 12:39 AM, Pavel Begunkov wrote:
>> On 01/03/2020 19:18, Pavel Begunkov wrote:
>>> Currenlty, every async work handler accepts a submission reference,
>>> which it should put. Also there is a reference grabbed in io_get_work()
>>> and dropped in io_put_work(). This patch merge them together.
>>>
>>> - So, ownership of the submission reference passed to io-wq, and it'll
>>> be put in io_put_work().
>>> - io_get_put() doesn't take a ref now and so deleted.
>>> - async handlers don't put the submission ref anymore.
>>> - make cancellation bits of io-wq to call {get,put}_work() handlers
>>
>> Hmm, it makes them more like {init,fini}_work() and unbalanced/unpaired. May be
>> no a desirable thing.
> 
> Any objections against replacing {get,put}_work() with
> io_finilise_work()? It will be called once and only once, and a work
> must not go away until it happened. It will be enough for now, but not
> sure whether you have some plans for this get/put pinning.

I have no further plans there, the get/put work only exist to ensure that
the work item stays valid in case of cancelation lookups.

-- 
Jens Axboe

