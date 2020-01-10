Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26995137806
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 21:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgAJUg1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 15:36:27 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46752 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgAJUg0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 15:36:26 -0500
Received: by mail-io1-f68.google.com with SMTP id t26so3446052ioi.13
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 12:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iYpRwiXcN0IajQDk+I/CVaNP78EBBEMWIm0hcTyxTDI=;
        b=jNFtpvi02UAGuf6AeEu4Z0GYITviqqLWiglXSRVIBwy4QjM9iFMloTz1ICVYAIR8Q7
         4IfYOx/7U8RLyoc+X0GQ1ztg0yle04RyVHRxax6JCV1yMxKbfKqrmhveGcRQNPY2bLMm
         Y4xzOYcKufJ5jwAFyAUBtPz8+Fd2yHeT2BzJ7Y6h3+yFyjwneR8lcDssLjiVhzvy11eu
         BnbuIdO5blnHzQgxMvdXWxxANcADurlTDbv/AdUoyDHifGzv05FpLHTk0pGZsEpxLMzq
         DVUnH78iCO2I0q48USj9wGBnLLmy72gG0eEN37PWmy/b8/BnwNLCJ4A3dOH8NdGGUVo3
         3gmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iYpRwiXcN0IajQDk+I/CVaNP78EBBEMWIm0hcTyxTDI=;
        b=i8UidUBXRuOoN0HSOmWm398rtQj5/7dNO5uau3UKwClc8YfvdJAlTp9pheOAeinjTJ
         YS8K79RPlgu506QRI0MXx1jRMcCepp7tRdKkTJncrINEtRIoLxX6Gds+E9c2cCuPHog1
         /5x9QVSWUi7eFy+2fiqHAdPszYFbQyqKRQPH0NVPUKEqHeGZVj243kc/UcgUf6y31iKW
         B94Mh1LgF0VeoBFZksz4o2bpMz7BDENryW40/62weZApk8rJV1MLOPUhgKNbja5oBwn0
         fkqc2Me7mfLRCC96KuhA2aLNKBFr0WZdAW/tpDjXCJyL0gYGTAHKa5yRGCjULdOYVyzM
         Qn0A==
X-Gm-Message-State: APjAAAWhLMf+YWawKJL3g2JYen1s84LjlXtD6nyXHlbsfxGO9b6Zu8Jd
        hpT2hZEhddGoX1xUuxN7j4NNYWsX9cQ=
X-Google-Smtp-Source: APXvYqzsjLFFskgsCb8Kt6yj+6kskKlZlKTIHribP/6yWLxvvfqJpxD+lRDgehbAwTtlnb1IMHV/jg==
X-Received: by 2002:a5e:df46:: with SMTP id g6mr4065170ioq.240.1578688585855;
        Fri, 10 Jan 2020 12:36:25 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u64sm1002593ilc.78.2020.01.10.12.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 12:36:25 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.5-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <4f9e9ba4-4963-52d3-7598-b406b3a4ed35@kernel.dk>
 <CAHk-=wgLX0Axk+3Gd6YeRcXkW6GHOk0_CSpp3fJGgmmbN8_BMA@mail.gmail.com>
 <5b093882-16dd-0bcb-79b6-0f37be77a03c@kernel.dk>
 <CAHk-=wgFxvMZU01aT8eZaeKs07r__WM2fQZSBKPCyUJPJwsdQw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dbc0869e-37b6-2a84-60dc-2653d3fd3e51@kernel.dk>
Date:   Fri, 10 Jan 2020 13:36:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgFxvMZU01aT8eZaeKs07r__WM2fQZSBKPCyUJPJwsdQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/10/20 1:34 PM, Linus Torvalds wrote:
> On Fri, Jan 10, 2020 at 12:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> That's had a 100% success rate so far ;-)
> 
> I see that you like to live dangerously.

You ought to know by now.

> I _think_ I've been fairly good about not missing any pull requests,
> and checking my spam folders etc, but ..

I'd follow up if some were missed, haven't been an issue. I do love the
PR tracker responses, it's one of those things that you don't know how
you we ever lived without.

-- 
Jens Axboe

