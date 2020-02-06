Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B99154D10
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 21:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgBFUmT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 15:42:19 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42728 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFUmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 15:42:19 -0500
Received: by mail-il1-f196.google.com with SMTP id x2so6362100ila.9
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 12:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hSKAPXuw/qdxw9inxEswmgHt8h2yXurDtN2Z4Xr63Z0=;
        b=vrehnZkfqdhinR2vRNC3Cj7Yx65Lc6yH5V7n3a268mzPSpu0KywkM/5TyaQu3C9Hrk
         Kk3c8M67vgErRSUXFhgzJ7YFH9GcPj2xQ7Hfjd5Gr0SsDpTw/AOOIEDSUBbpoMeJhfTZ
         YIX/zm6EoV6aVw/2C9ETCyq2HOsUmMfOBDg4ivf0VLUKojXXKX8U7J7fl7vY1yDrwh/5
         YjGFywENwJ82kNXN2utfVKGhFF2BXVxQDocn4szgvA9zSm3wdTMJb4GrE7KcyN8+7Ym0
         IiRY2AFpJqDJra4Kc7qqXJoGlssEFa3dbnxiVYeau70ZJufKogA5XV/L1F48fh8xJSeJ
         JN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hSKAPXuw/qdxw9inxEswmgHt8h2yXurDtN2Z4Xr63Z0=;
        b=lqHRJfdoRhDBnniATZC4fRk8ggxN/lWkVWKlTLIgf0DZDqdl12IJXfxdbhFFVJ0bgM
         Y/S4aBO/eOwhi3VnZbl8UmTpK9DFNeMsIAfJysS/epFNDbyBOyHD283q8f0Q+Q9k4w++
         +U1kxEQ5OOINpxAKIo8pu9H6XrKoyDiVAhq5P7DaK/CbhXtG6aoQL2ufLhAMpchbwQgW
         GunuPmVOoca8bVekmQ8SbmB44gtTqO68Eq15caqU2MQ1e+7kQXSKCi5c+dvjXZLHgrzh
         cs0XSg0z3Y2c6z2/foHR6DqQgcSnvryCPfnf3sOrWATynaR/w5Uy9vMHro2Wgq5gPrKW
         +Brw==
X-Gm-Message-State: APjAAAVESQq9aAG/NwIC6qzjnSjf9T68QR1PXS0LyPyHt+gRyS7nI0wA
        DMw0V7uuMDjQJwBQZALYSSmrBeBl/8I=
X-Google-Smtp-Source: APXvYqwZB2x3Iz0V+ifgm6G+KSO+hCUJuDxsNlIVwShchirorpQ/wv92n2XKP5n1MJ+xMd/IYNcv9w==
X-Received: by 2002:a05:6e02:e06:: with SMTP id a6mr5715310ilk.88.1581021738435;
        Thu, 06 Feb 2020 12:42:18 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k129sm190195iof.82.2020.02.06.12.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 12:42:18 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix 1-bit bitfields to be unsigned
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
References: <3917704d-2149-881c-f9e5-2a7764dccd3f@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed4cfaad-d6b3-3add-a329-0b574b8fe380@kernel.dk>
Date:   Thu, 6 Feb 2020 13:42:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3917704d-2149-881c-f9e5-2a7764dccd3f@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/5/20 9:57 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Make bitfields of size 1 bit be unsigned (since there is no room
> for the sign bit).
> This clears up the sparse warnings:
> 
>   CHECK   ../fs/io_uring.c
> ../fs/io_uring.c:207:50: error: dubious one-bit signed bitfield
> ../fs/io_uring.c:208:55: error: dubious one-bit signed bitfield
> ../fs/io_uring.c:209:63: error: dubious one-bit signed bitfield
> ../fs/io_uring.c:210:54: error: dubious one-bit signed bitfield
> ../fs/io_uring.c:211:57: error: dubious one-bit signed bitfield
> 
> Found by sight and then verified with sparse.

Always thought those were pretty silly, it's not like this change is
suddenly going to make:

if (ctx->compat < 0)

be anymore valid (or invalid) than they already are. We also have
cases of:

bool foo:1;

does sparse warn about those?

-- 
Jens Axboe

