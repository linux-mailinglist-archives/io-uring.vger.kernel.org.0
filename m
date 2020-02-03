Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A1D150A0F
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 16:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgBCPnb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 10:43:31 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:38140 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbgBCPnb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 10:43:31 -0500
Received: by mail-il1-f195.google.com with SMTP id f5so13004172ilq.5
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2020 07:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tqYcgHc5VOj+fbH6k9sfeEL1lPZODVdx63DLzZEZWGM=;
        b=OC9GYtA5uaUGUTNxpxQP/8l4Y2Kmkh6U/EDEHCHesaZEfX9yBWA2ezdOt6+moxwlHA
         fvWoLToypZUAE/X/KcjKoMOUwGFX1jv2lDCMzgP13MzrkTXz9IqkvAsBru1XMrBRMX8y
         xwfcccVkfpWsSPduRMbDU/ECQFb1hqkDshtDOEmOYITnJDsj1tyUheUp2g8/yT2kLcAU
         /z8WF2AHtU/dPDmdye//GZGZ4BuyeFI+8KokNEPRHRRQ2v9LycDhYeQQmGo/4iSwu7pF
         NhLsacjk8qNBsYCduXgCE+Ap+uOTU+s7qcWhCmSK04kTXkUHuySuSo6uk+XW1NLRNoHA
         1lyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tqYcgHc5VOj+fbH6k9sfeEL1lPZODVdx63DLzZEZWGM=;
        b=IvV2uSy6CescjjihwTA0OQtLYMaWtDGI5zdOtETYeFfI14D41cTlroVGkyCzLo99Ys
         jRHXVVE2umh7BX/+cBs+gE44uPy7jS6RpoeDd3dAE/wTfkZOEhlYekNm1hmBP31Qb5U/
         B5lKrwWX7uCEWyqGsdiHNIJUlAOW6380NUy+lorJZiRoyccfqy/tMCxhJUZO4nycr6to
         VHM1T5r9bCrCsLQGXelN4AG+JvY4VDg/yHkuKt/3OE5cYPhOE9GCbCJECj82QjDI5uN3
         qi2rAMuh+zZYl4TDENNuoN9pHUqrUIBupygb6CMJZyztrCTq40ldOXCC8kp52nmJHryh
         eimA==
X-Gm-Message-State: APjAAAWGtT3zt5rJAtqpfBxgsAPJYW8SRkVBnv1HHPGWfuCbXaklkACP
        zvcNcCthcoAsnx8xjuIYpwmw7+T3P84=
X-Google-Smtp-Source: APXvYqzcTRKaGJoUO23/z186pV0Ri5qk49RtXpG070hlIWnLWwd1jK0I3EojhgnXaUiM+3Vq9ztGGA==
X-Received: by 2002:a92:4818:: with SMTP id v24mr14416711ila.96.1580744609930;
        Mon, 03 Feb 2020 07:43:29 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x62sm7393197ill.86.2020.02.03.07.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 07:43:29 -0800 (PST)
Subject: Re: [PATCH liburing v2 1/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <20200131142943.120459-2-sgarzare@redhat.com>
 <00610b2b-2110-36c2-d6ce-85599e46013f@kernel.dk>
 <20200203090406.mlgmw2u7lv7a76vd@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d3763cdb-dee0-9312-2a4c-08ed939eae70@kernel.dk>
Date:   Mon, 3 Feb 2020 08:43:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203090406.mlgmw2u7lv7a76vd@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/20 2:04 AM, Stefano Garzarella wrote:
> On Fri, Jan 31, 2020 at 08:41:49AM -0700, Jens Axboe wrote:
>> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
>>> This patch add the epoll test case that has four sub-tests:
>>> - test_epoll
>>> - test_epoll_sqpoll
>>> - test_epoll_nodrop
>>> - test_epoll_sqpoll_nodrop
>>
>> Since we have EPOLL_CTL now, any chance you could also include
>> a test case that uses that instead of epoll_ctl()?
> 
> Sure, I'll add a test case for EPOLL_CTL!

Awesome, thanks!

-- 
Jens Axboe

