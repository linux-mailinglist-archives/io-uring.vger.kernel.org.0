Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BCD3137B8
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 16:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhBHP3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 10:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhBHP0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 10:26:54 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA51C061786
        for <io-uring@vger.kernel.org>; Mon,  8 Feb 2021 07:26:13 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q7so15386968iob.0
        for <io-uring@vger.kernel.org>; Mon, 08 Feb 2021 07:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AbxJsuEu2qc+tTf3f/WFDiFgtDzDNZuB5efHjrxq3lk=;
        b=tboWuYVPH6tRHIgYW2Z6EH6lxQ+73hHzDyPWaqN8TaNzx8pKudgCywAKakH7TkA8ws
         rAZfasNCFJXnL+owM1o45igRXkIH+JHrA+Ij+71ZONHbA58Nle6+VinU0V4cSBxxwAa1
         VLSku+kMLr6PSq4o6CzQHBmEbAtHyhPmLhuTa+9sfPMOVO09CEK9WoE5cZQQlwhrmkH4
         kbPm+DgHIVbrp9z7cHGa5EIZm988SkOiFqdKrbkN0+TnvveAD2Vi7RygKu4+eB5KZL15
         RKgGCxwuyc5vdVJT9gu3pesDiIztIZqbu2p8EDDJcMSWQ7E2klX/f53Lg/R5WU9jYeN3
         4ASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AbxJsuEu2qc+tTf3f/WFDiFgtDzDNZuB5efHjrxq3lk=;
        b=QzZ9NHz6jot8gnCIkdv32wYKQ2NS1x+JtGU4rubckKHG9e+410Ruzg/EEWs9QIcFWP
         JpH1Dzjdiw0WEPqTWIo6NWlskSc7haS1plxo5vnC6WY0Tzf3kmvSC+gnq1+gLiwbJbBz
         9nD7lOhUg2GAqYm3I3wstz+vwXm0aZBB0t+sbW2STZLpscR5zOTRd5NTTpxNwQuQOyR0
         32eXb0nOVbWeCnYTwicd7c4bUj5GG+QhuInAPzmypUplcfrR6p11lEPO8lOI3d1e69vZ
         NTZiH8onFUBIZWS8NdDT07nuRWoe5yz52xxxJrjSWkm2eSsjZ6fscX7qztA7xQdPolFt
         vtrg==
X-Gm-Message-State: AOAM5335X3aDMNsCLfBgXuWXHpvfQahCMiFTz8Ky9FyMh0gGsqwqyB2I
        iPrXoqbzw4tiGpcUKeYKNNTXdFOHLzy88/SY
X-Google-Smtp-Source: ABdhPJyFGvHGaS/8Jc3FsUfM8Neatn+ttRp8e6mZy9wQHxVf4S/sTQoPicpGjrdQNEEXOBqIsOwbPA==
X-Received: by 2002:a5d:9710:: with SMTP id h16mr16070462iol.192.1612797972883;
        Mon, 08 Feb 2021 07:26:12 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r7sm9090814ilo.31.2021.02.08.07.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:26:12 -0800 (PST)
Subject: Re: [PATCH liburing 0/3] fix _io_uring_get_cqe()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612740655.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a726117c-9d75-8ad3-e8bd-302a40f26adf@kernel.dk>
Date:   Mon, 8 Feb 2021 08:26:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1612740655.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/21 4:32 PM, Pavel Begunkov wrote:
> address live-locking of _io_uring_get_cqe() reported
> by Victor.
> 
> Pavel Begunkov (3):
>   src/queue: don't wait for less than expected
>   src/queue: clean _io_uring_get_cqe() err handling
>   src/queue: don't loop when don't enter
> 
>  src/queue.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)

Nice, thanks Pavel! Applied.

-- 
Jens Axboe

