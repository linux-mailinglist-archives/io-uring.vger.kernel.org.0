Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091953F1C68
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 17:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhHSPPp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 11:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238587AbhHSPPo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 11:15:44 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4954C061756
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:15:08 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u10so8975615oiw.4
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 08:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tdmg6TTFQ/Ot8jb2adMxctxRWhiV2wL5JMi4BPla+4U=;
        b=1hSpz+5yXZtubJfQF4N8v8tl9W6NAL9aZbfe3iuPM2KeMIj7l6Lrv3Tabidov2rVhE
         TXrEngwakqnbSTvW45CugI7t97zP9MfIPVgr5cAHN9SsNdMKYShcLoztva5RjvvFoUj4
         wtCNA+vqDbN/8FzZkr9J7+Os1SIdNCGISHeGQd4tn+dX/qGmF8PiSCu3fkGNZfY0M+/O
         kVwSYwsFIhRyYxBeeQnl6nJ3l7fFFwk9KqRwb4dRpAz6RB09RFZsjBzoHZJ+hXZPbqDx
         RjH6DtKd4vlowRWSW12iS8G3y80SA/kDpXlcSnYew/FaNfFRXwETpefQWZwPf4UcFTLF
         vP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tdmg6TTFQ/Ot8jb2adMxctxRWhiV2wL5JMi4BPla+4U=;
        b=ictnMENLOwXBhR36b6ZmS1HoT7K3217zmg+14+cXbeI4p297/PzfeJqAW8WazcAlDH
         VI3XUQ3rv/nFoBxI7FALYzRiO78B4n4icPhrTxzsjHCeK+pyauuMCeGgRtpmnv1eGZd2
         b5gPh4Xb3HlM5ZkgoTPcX0FWVdPinP8FZ4nviAL4EvEpaaptFNN8hUHQq4c/mF7j3jQK
         PQ/vIGKLeOdOJm8vvJV8zDzzfQYXFQMZUHYW1ljeGdT54512dtZSq3zFcw+tTrUA7wx8
         q0QlIYQ3Whqh6TaPAr9KXcEr/HugGGuMIAiO1+UC2oLiJw2p8lFyI7HfV3qSDoj74MOt
         NWHA==
X-Gm-Message-State: AOAM531VI4NP82Cw7BiM8/nDeCd5GQbko+aebSSbRimPhPwcEYssunjh
        QgOZXJdHb1VsRFfw/B+KSOBM3Lghw9TsvUWt
X-Google-Smtp-Source: ABdhPJyaieB8cT5A/g8uvMeiUBogH2EI0ASLSoldGHgceQUcAcMvDfxgQy6B6md0yraoPqLXxmUq2w==
X-Received: by 2002:a05:6808:cd:: with SMTP id t13mr2919899oic.111.1629386107801;
        Thu, 19 Aug 2021 08:15:07 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l13sm299001otp.29.2021.08.19.08.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 08:15:07 -0700 (PDT)
Subject: Re: [PATCH RFC] Enable bio cache for IRQ driven IO from io_uring
To:     Christoph Hellwig <hch@lst.de>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <3bff2a83-cab2-27b6-6e67-bdae04440458@kernel.dk>
 <20210819090150.GA11498@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ed3237b-573d-029a-4cc2-0b6cbc22e32a@kernel.dk>
Date:   Thu, 19 Aug 2021 09:15:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210819090150.GA11498@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 3:01 AM, Christoph Hellwig wrote:
> On Wed, Aug 18, 2021 at 10:54:45AM -0600, Jens Axboe wrote:
>> We previously enabled this for O_DIRECT polled IO, however io_uring
>> completes all IO from task context these days, so it can be enabled for
>> that path too. This requires moving the bio_put() from IRQ context, and
>> this can be accomplished by passing the ownership back to the issuer.
>>
>> Use kiocb->private for that, which should be (as far as I can tell) free
>> once we get to the completion side of things. Add a IOCB_PUT_CACHE flag
>> to tell the issuer that we passed back the ownership, then the issuer
>> can put the bio from a safe context.
>>
>> Like the polled IO ditto, this is good for a 10% performance increase.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> Just hacked this up and tested it, Works For Me. Would welcome input on
>> alternative methods here, if anyone has good suggestions.
> 
> 10% performance improvement looks really nice, but I don't think we can
> just hardcode assumptions about bios in iomap->private.  The easiest
> would be to call back into the file systems for the freeing, but that
> would add an indirect call.

That's why it's an RFC - while it's not the prettiest, the ->ki_complete
assigner is also the one that sets IOCB_ALLOC_CACHE, and hence it's not
that hard to verify that it does IOCB_PUT_CACHE correctly too. That
said, I would prefer a better way of passing the bio back. There are
other optimizations that could be done if we do that. But I have no good
ideas on how to do the passing differently right now.

-- 
Jens Axboe

