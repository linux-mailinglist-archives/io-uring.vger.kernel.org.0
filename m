Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C142A845E
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 18:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgKERCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 12:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgKERCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 12:02:44 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536F6C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 09:02:44 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id p7so2505990ioo.6
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 09:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jw01l9Wkqe/+4b5Rxz+E+SDHHhozxyFGH766daSEy/0=;
        b=RViMJXxN9W7Hx+Xmwe4ELIOCDk0ke8WwdVV/JaOf1gTJ2/w1wHwg2UHPSZ2f0IPdl9
         iZsWlsZ0GhSeWOLLr1XBOMW0c1wki+LO+7LVxgN1NPj3ektonxyXJmXOQ2lv5mXSyFIc
         WHKaGQnaU8rhLjM2FCVe0Wgsuqko4zShm5PG6rfUT4ZdBzny0oMv5/FVZXL8nNUuvpn5
         PDUPR40t3lflShE/ShrwOXuHi6P6yxjjOK1e9U6GGNRuiizEzkY2QlRkngIy0DArCd97
         SGWfT/gLeN3YCNQ8XNxQXfqH0H54ljYO6pz2JmX4PJNIWr9SIrepcCBVKbxkMqsPc5eK
         EvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jw01l9Wkqe/+4b5Rxz+E+SDHHhozxyFGH766daSEy/0=;
        b=Xe8RHCZxIlizXMxvtJ3Hw6kD9h/jdRSANvPHYaHUaqbeU+fvjTvFQpH6DWOgjVvWup
         gEbVm5lYtg8jTfBIRVuLlSsDkYtoPoIZcmUWNI+TCSIguZzGDuqE3NQjT37JkL6rZuR6
         3EXsP75mRFWAz/cUokrgCcDkTFMHWFHc2Ql36YcOMZZQVKm4nabX9uVTNzsFLTtEkna1
         P6FU0WZDPkpFgbvR0vwgYxFasnJX6VPNfI253SXzltIgdqlmtDa4xac/ZrLwpyoN5Cwp
         lwPzDn4IyyCnnpS+LvDJRuH/Ai9k4klUBwQQzvxydiVD4BAyZav0f5Jce5fmiuWqDDTf
         gWTg==
X-Gm-Message-State: AOAM530s/2yas1t00NTG7R3EdKknm1RBIZkeA+lMGzMUfKozhh6cyf/e
        +smrDqTaQTgznX97A3dOYSsTBIVdz+43Sg==
X-Google-Smtp-Source: ABdhPJzWz08mlJT3qIoEH+ygFWKTzv+1nB/cZ5km/m7ZY0h1osPLPoixiYL9+LV04+mATFJLanEQNQ==
X-Received: by 2002:a05:6638:d46:: with SMTP id d6mr2708764jak.124.1604595763331;
        Thu, 05 Nov 2020 09:02:43 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m9sm1322957ioc.15.2020.11.05.09.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 09:02:42 -0800 (PST)
Subject: Re: [PATCH] remove zero-size array in io_uring.h
To:     Akinobu Mita <akinobu.mita@gmail.com>, io-uring@vger.kernel.org
References: <20201105140251.8035-1-akinobu.mita@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a1a101fc-f538-ae6a-1fd5-50b1b5e8d1c5@kernel.dk>
Date:   Thu, 5 Nov 2020 10:02:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201105140251.8035-1-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 7:02 AM, Akinobu Mita wrote:
> This fixes compilation with -Werror=pedantic.

Applied, thanks.

-- 
Jens Axboe

