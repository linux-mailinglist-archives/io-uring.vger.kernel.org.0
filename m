Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9585418EC10
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 21:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCVUFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 16:05:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46000 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgCVUFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 16:05:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so4939834pls.12
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 13:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0G30p0Y/YQbLgZ3vDhWE8H0801IdRthOnKZlMuhtwFs=;
        b=CICW1AUlOCTqtu8E2Art14j+wdDCeqpti5KdqaAS4/TbrFY2dMg++tcJNRZ+nvsgET
         52G5GEevI3A2V7cjMQdShqiO6ZawkB7d82VVfOiZUx6/DCJbdVPQ/NPmopCWrTkzY/9q
         LIBlNqa9Kd7wtPDv5qvq/VIYtUQ7mvKPSDvcNVncRPVR3KSkZi4LTMu1JQsr8gX3RXdL
         U8vPNteR16g51zrch2enK7Gf7af+QX88H/BNbmofx5vHUKvr8mjhKlRxpn5teCUWHZwL
         sS6iSR5gq2mLyhofGM3cz/jWBpfyWOgyiv2sbM4HpCcpJQlq6DoUCqHFnPiabqq+byPG
         TsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0G30p0Y/YQbLgZ3vDhWE8H0801IdRthOnKZlMuhtwFs=;
        b=EcyvxYPB9kdIotn5x/QJMbRsr/Vryh3s8UOKxpzpk726yzV79HlPqomWEKR90l8f5i
         dCDVh6e1+20UbjniOldKnjet0IGxuZTyUEKUbVbSQHh3O3CsE36UE7ndkNmyGsmhb1f6
         J7ZO/K+ftUSir5g1iZs09BuYm7hN43LeFM0W+VQvPVy4aaNkDVUPU34XUk9pDf6JqEO0
         X3NN1Aq4LM0+SPNrIkSFSghh3D8FQXK2KrN1cQ+zEO/yj82wKTsageYcT8ku87WH4IHL
         m4rGO7qM7uspZLcjOTgqmbUCKBEaldNaMqAU6y92uT+OH5mF8dSwh9UuGCPPsWvyj4YK
         9+HA==
X-Gm-Message-State: ANhLgQ3AYs51YJMPnFIEvT/kF4Y+hI68IBahKUBimczAu435lwWVZNYY
        7bOPMqaZsa2vtomc4wAW9QZQesz/0MYI1A==
X-Google-Smtp-Source: ADFU+vvrdGyT85vLWjZ7Gu/4dR3KYDgLkC5RFWYpLKp5rZQRecMwIUS5cKYizegSY7kNGbL+U7kZng==
X-Received: by 2002:a17:90a:af81:: with SMTP id w1mr21666919pjq.14.1584907522359;
        Sun, 22 Mar 2020 13:05:22 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g16sm10679359pgb.54.2020.03.22.13.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:05:21 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
Message-ID: <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
Date:   Sun, 22 Mar 2020 14:05:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 1:51 PM, Jens Axboe wrote:
>> Please, tell if you see a hole in the concept. And as said, there is
>> still a bug somewhere.

One quick guess would be that you're wanting to use both work->list and
work->data, the latter is used by links which is where you are crashing.
Didn't check your list management yet so don't know if that's the case,
but if you're still on the list (or manipulating it after), then that
would be a bug.

-- 
Jens Axboe

