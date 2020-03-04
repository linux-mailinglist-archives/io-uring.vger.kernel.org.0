Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6691796FB
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 18:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgCDRsM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 12:48:12 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43697 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbgCDRsM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 12:48:12 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so3333587ioo.10
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 09:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9SraZV6RcvEth8Ec3DOfUy0ca87MEG1jsjcwrJzs5cs=;
        b=cfNT6jssVl2C/wGkMCrPj7o6LPMPgCjAE5JzTiRcLe2n5kFQ49Ds+jgbgNjkouNXtt
         t2Fg7Qo7cmg94zvu5rPWOlqhwkjOeO3mQ+lwi/6O55NLaN/WJ+noXJVM75wAmuAMuhBf
         lF8RBle2+4PvKJeo1G7z1TVKLB2kGjzoa7FFCB23l21/6t+5y30QLsxDGCeB4+nr82A5
         ekd/Mv2PHNL71cgP6mufAtxemEun+qzCPYFYnbCyKUhLC7TUUfrmPNY2y9NCJ/4QExcd
         VlcwgtmA6k7vARdq7YhQH/W3i94Q+uQWGZlJFEalcO+YaCEm14Cocoq2LNm8ZSr+0MYx
         6MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9SraZV6RcvEth8Ec3DOfUy0ca87MEG1jsjcwrJzs5cs=;
        b=MrZtQfp73NtSXX49gM/W80kBSR4pMdOTWPt+NMm1GxTlWNepeuatqMIXaLqi9Kjg0R
         G4kFwQQk/geevAOLcI4amWAMQESC76ecMO+bIj/sclPWAQLDd/43aeVfr3nvPsHlaxS1
         K6eWjHZ5keCaUZITlQSPaI4smZIW8fJnPvR0N80F3JjeNRrhCIt3MitJWaFh0hi5pGJg
         3FeH6ud8yOEytgNGgFABBhje4UkE3gLSk+A8V+mHixLP2erTs8c6T9XvU9hXQi0K1Lzl
         9dibkYV9YrjEL7aNxzG8+C2LFBYt+4M7yvSmJ6fJ9OeUeFQwbA/uZ+YgoYpBn2ZcLl/x
         kFHA==
X-Gm-Message-State: ANhLgQ2uAiIET1CyxPtKljrOV+py7LWjHxe+fiytggxsJl0tYDPDZjhw
        JOAiQgW+c0B8CVycqJ9nJFcwHQ==
X-Google-Smtp-Source: ADFU+vsCgCX87p2SaVjeruE1oAxcj/NZvIieALDHguDyYT/7TX0pE6UB/LLstb9QHE7xmCpR8ZPmEg==
X-Received: by 2002:a5d:8ad8:: with SMTP id e24mr3138006iot.291.1583344091635;
        Wed, 04 Mar 2020 09:48:11 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p78sm5903442ilk.76.2020.03.04.09.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 09:48:10 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: test patch for fd passing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     jlayton@kernel.org
References: <20200303235053.16309-1-axboe@kernel.dk>
 <20200303235053.16309-5-axboe@kernel.dk>
 <b2568465-1f35-fbb7-96df-f1aa4801c969@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7287df70-3605-6ef4-a578-9a99b5444480@kernel.dk>
Date:   Wed, 4 Mar 2020 10:48:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b2568465-1f35-fbb7-96df-f1aa4801c969@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 6:13 AM, Pavel Begunkov wrote:
> On 04/03/2020 02:50, Jens Axboe wrote:
>> This allows a chain link to set ->fd to IOSQE_FD_LAST_OPEN, which will
>> then be turned into the results from the last open (or accept) request
>> in the chain. If no open has been done, this isn't valid and the request
>> will be errored with -EBADF.
>>
>> With this, we can define chains of open+read+close, where the read and
>> close part can work on the fd instantiated by the open request.
>>
>> Totally a work in progress, POC so far.
> 
> I'm concerned of having and supporting all these IOSQE flavours. Isn't it the
> thing that can be potentially done with eBPF?

It could totally be done with BPF, but honestly I'd love to avoid the
extra dependency.

But in talks with Josh, I really like his suggestion on being able to ask
for a specific fd instead. I've reworked it to sit on top of that instead,
I'll post a new series soon.

-- 
Jens Axboe

