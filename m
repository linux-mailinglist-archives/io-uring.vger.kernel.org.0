Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D10321A109
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgGINjp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jul 2020 09:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgGINjo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jul 2020 09:39:44 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886FAC08C5CE;
        Thu,  9 Jul 2020 06:39:44 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 17so1853328wmo.1;
        Thu, 09 Jul 2020 06:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7m8lbz+pKqeYfeiDsb5nPYRTRUxn0M2Uz+PaOlj97fo=;
        b=I2p03NtTI9CF/cKlDrKmXVeL6wFHCt+bRmiYY0ankiZ+DIHqe4UmcIWX9TLwqaD9xw
         /lw5bLWeVGz5PNhgMMCK2jiHKmUyZrU8uTObZckjM7j1sYhv73W98jUgeiPvToBKxC71
         TC0OGD7P+c7eC3QQfPYadJb4RfbZ7OlEYJSZn3KN7sdjnDrU3dnvvIJGrUP4+P61qpPM
         AufEpk55/xSMf0zmjN6mB12bnb+LQsfzOzfVFAEKynY4sse3au0DhdFMnbSZvNvdykKU
         QryADMK4u2CwEDbbLEHnsYOgC8Pvv7OGh+jCQuQwyi8L6BIqL74/u1hIuRFlcOd0fXk6
         vi3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7m8lbz+pKqeYfeiDsb5nPYRTRUxn0M2Uz+PaOlj97fo=;
        b=ZMGA1/ZOUALq7w17mLdidTtlsdyX7yhpmK+rU2PVIFlhNb0m3wDdSCTDVrk/xYgV1N
         Pc+aULI8fKX9BwQDPoI2YjYaLqnHMWQ8VGMk2mIdYZqyWyPgJzTShS7ySvWtFoh1rpVX
         tnqeVu8zi1uleP1Dg5xIyiH5aHycnuFC5X2a5+/AfIhgUJxAYTwtyeP22lnhjHdqV7os
         Pf1gA+EIqACt7Q8QSePMDQvcMpTNqfsXs0OTM0SRPzh+D9ru7mqHri1WpPrPezy+/+IO
         TS9e4kbudcm/MZ2SsvW67nt/eGVuTSLcdpQCmV1dmNGjbsOFHqmEjiUxJUhBQFe7rrj+
         hxbw==
X-Gm-Message-State: AOAM532hPsFLYGeePUxOPWBmFmFsS21vwxh/o1jdP/EI2wgGBsVFR5Ps
        QScru2mDrfppeoGuxryloRk=
X-Google-Smtp-Source: ABdhPJxt5PllSIHTtVbOw8yU8/cZBRrj7wspsU1OdueCoJywpr2YCRtyK5jBa1fbsB/4PcW7Oao1Uw==
X-Received: by 2002:a1c:6354:: with SMTP id x81mr61693wmb.98.1594301983283;
        Thu, 09 Jul 2020 06:39:43 -0700 (PDT)
Received: from [192.168.43.42] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g14sm5623087wrm.93.2020.07.09.06.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 06:39:42 -0700 (PDT)
To:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <20200708222637.23046-1-willy@infradead.org>
 <20200709101705.GA2095@infradead.org>
 <20200709111036.GA12769@casper.infradead.org>
 <20200709132611.GA1382@infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] Remove kiocb ki_complete
Message-ID: <ffbd272c-32f3-8c8c-6395-5eab47725929@gmail.com>
Date:   Thu, 9 Jul 2020 16:37:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200709132611.GA1382@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/07/2020 16:26, Christoph Hellwig wrote:
> On Thu, Jul 09, 2020 at 12:10:36PM +0100, Matthew Wilcox wrote:
>> On Thu, Jul 09, 2020 at 11:17:05AM +0100, Christoph Hellwig wrote:
>>> I really don't like this series at all.  If saves a single pointer
>>> but introduces a complicated machinery that just doesn't follow any
>>> natural flow.  And there doesn't seem to be any good reason for it to
>>> start with.
>>
>> Jens doesn't want the kiocb to grow beyond a single cacheline, and we
>> want the ability to set the loff_t in userspace for an appending write,
>> so the plan was to replace the ki_complete member in kiocb with an
>> loff_t __user *ki_posp.
>>
>> I don't think it's worth worrying about growing kiocb, personally,
>> but this seemed like the easiest way to make room for a new pointer.
> 
> The user offset pointer has absolutely no business in the the kiocb
> itself - it is a io_uring concept which needs to go into the io_kiocb,
> which has 14 bytes left in the last cache line in my build.  It would
> fit in very well there right next to the result and user pointer.

After getting a valid offset, io_uring shouldn't do anything but
complete the request. And as io_kiocb implicitly contains a CQE entry,
not sure we need @append_offset in the first place.

Kanchan, could you take a look if you can hide it in req->cflags?

-- 
Pavel Begunkov
