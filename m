Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB49317060
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 20:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhBJTjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 14:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhBJTiQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 14:38:16 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD34C061574
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 11:37:36 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q20so1947293pfu.8
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 11:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GMMMjxVi90GIiNAiLm9pBdNdSuf9cn6U1jj4BLV0EeE=;
        b=UP0jgbJDO/1o/KcIRTq5rlG1dJGuf7I1JAZDSoiiyO+Eot/eZEDuFzCYM9XdwwYpFb
         4NozM5cfgIV9NgltWha9fIcBsEY5rmTJ1d/0m7d7KQY2MJ5LKkXUYCYTNVn44zzVC8a0
         Pb1ZwRZPYdpLeApbDjqlJQhoMtRfUU0A+ZBPocuRF0tjunq86dLD9o5ktTr6ns+JP7r/
         kuNQBezb+AEjbhfpTaTxjhPLmJ6DV0SwMswBKacXDxNVhMFzk7mYRdMcogkPSZwFVE5X
         fXO39axJBK+gozv8igm6IaKmi/nWb1p8NpvifzFQ6GTZbELY/KJGwPF0QV2XMcKHnjOo
         Op+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GMMMjxVi90GIiNAiLm9pBdNdSuf9cn6U1jj4BLV0EeE=;
        b=BnIvubn9BdytpbDcdzb2jcp4pXmR4XFV7Ykj/d/Bri7pp8Hv3ELzOWTKRoaHKBdup4
         vp1+/9dP63KtzjCXWeNrcpsDdFyiUmqQ0Te6WlWlLbqVaUdLbMxFdCK2Ejpd881UgXis
         lJ1H5bdBWl1e9XuQcEyDd90G9YU3Q7zdBIramXQwxFlLF3k51jYoiWVOwZNJTX7Y7EAF
         R1a2kH0tyOQhhl25gPmxelE9lOzGhHsR0A/q+UmUWq77aGNO8YTP+abtPFqqDiddBTtG
         riJlh3/Ol3NDF9Wz2gNZguHyKVMe3nPWQX7dR2ervDBVw0Dux0MzvIn28HepB1LGkMcx
         ohoA==
X-Gm-Message-State: AOAM5338zUGszKmOhf9xlqt2AH+cCvWS0vIPleGUm5GkPgtUcu/0R2oM
        I5y/oa/uGqirqIsVrf77U93JGA==
X-Google-Smtp-Source: ABdhPJwMVsxIX9190gpXf4eXv3SXOW+/fYYIQ3jfB8fyvFEBqykRU1lESVTAFXzX3lqqJy7321gdUA==
X-Received: by 2002:a63:1a44:: with SMTP id a4mr4487450pgm.41.1612985855897;
        Wed, 10 Feb 2021 11:37:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y24sm3096831pfr.152.2021.02.10.11.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:37:35 -0800 (PST)
Subject: Re: CVE-2020-29373 reproducer fails on v5.11
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Petr Vorel <pvorel@suse.cz>, io-uring@vger.kernel.org
Cc:     Nicolai Stange <nstange@suse.de>, Martin Doucha <mdoucha@suse.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        ltp@lists.linux.it
References: <YCQvL8/DMNVLLuuf@pevik>
 <b74d54ed-85ba-df4c-c114-fe11d50a3bce@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <270c474f-476a-65d2-1f5b-57d3330efb04@kernel.dk>
Date:   Wed, 10 Feb 2021 12:37:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b74d54ed-85ba-df4c-c114-fe11d50a3bce@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/21 12:32 PM, Pavel Begunkov wrote:
> On 10/02/2021 19:08, Petr Vorel wrote:
>> Hi all,
>>
>> I found that the reproducer for CVE-2020-29373 from Nicolai Stange (source attached),
>> which was backported to LTP as io_uring02 by Martin Doucha [1] is failing since
>> 10cad2c40dcb ("io_uring: don't take fs for recvmsg/sendmsg") from v5.11-rc1.
> 
> Thanks for letting us know, we need to revert it

I'll queue up a revert. Would also be nice to turn that into
a liburing regression test.

-- 
Jens Axboe

