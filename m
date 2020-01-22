Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75155145B88
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAVSZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 13:25:17 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:44967 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 13:25:17 -0500
Received: by mail-io1-f47.google.com with SMTP id e7so203856iof.11
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 10:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TXitCiK1j0TS/yR3uyw0LXx4fQjWZQa6DYDTHFzq0mQ=;
        b=Dt2d3irW2fGGNMv5+NfApU2ExT+kxH0Zn2CwYHzpAxRHZeclA0ggY2BMk4lvS0csQ/
         zhGa65aDrmrxeE61LJsMDlsHyMN1virNoTNSPI12MNzSmb+pox5diBfumrX1ESEBV+t5
         VjiI5jB5eChJAbXFQ9395wIyUcQQo/3cOYyoKlAxNczOuGrANbuWrDQi0wb+iljXUmxj
         fdZ587rm5qz1YO/LDcIhnOm6x3H2l2fUnJOg4/VugiIeh2FSwwY9A3s6Pw3QJyCRkrZw
         XaTcTBxuA4B1ApTFEvr3UI8i0swoy7x2DKkUYkgZoMhbX28l3poWiLKeH9ceb8QF5AGi
         9EIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TXitCiK1j0TS/yR3uyw0LXx4fQjWZQa6DYDTHFzq0mQ=;
        b=psP3WJQ0mFg8MPc45lqlSAPx5QxCC2nAYcT/rWVVkFobOE/8UC0wBZ8CtvK+GpVJeu
         oPPpyAHphXW+4m8XtCNgR3W4LVDFdVuXvOvnToJqLcUNriig42Fc9Y15+rp+iCnQvQqc
         Ty0UlbZhwVeFRn8fRwS6/LOl9OvsD+reH5M2fNTlvjYfVVit1Z5wosDwLYc7cYGNBw1i
         Xgo6ji/uPEiFhBnyk3vXHgt9/U73OHtBUaXc4DB5zEzStyQOFp7TjcnXUuRhosOpD35e
         1Jf4MFKRPiz7wN2OK2ZRHgR2pxqW8XaAYaxjiKDJUAkwGVGnKGNFUCoNFskBf0+HF/Qo
         y8AA==
X-Gm-Message-State: APjAAAVu4XjsxkRrmHD0j014Z5DH/CIXxCUbynGNTM7y6gBzffNpH2VC
        OmJ2hK4AODbimNX6AiuRJpKi2yM2AAQ=
X-Google-Smtp-Source: APXvYqzjUKt1Ym2J7gj6DGsIbXZG8j54smmFDg+7F95123dxF7egJydnXGSaIZwwbCUaxGmnimdWUQ==
X-Received: by 2002:a6b:5b0e:: with SMTP id v14mr7393314ioh.154.1579717516293;
        Wed, 22 Jan 2020 10:25:16 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a82sm14579563ill.38.2020.01.22.10.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 10:25:15 -0800 (PST)
Subject: Re: First kernel version with uring sockets support
To:     Dmitry Sychov <dmitry.sychov@gmail.com>, io-uring@vger.kernel.org
References: <CADPKF+cOiZ9ydRVzpj1GN4amjzoyH1Y_NRA7PZ4CLPpb-FrYfQ@mail.gmail.com>
 <7a6ee3ab-6786-7fdd-05d4-a5ee9f078e6a@kernel.dk>
 <CADPKF+d_B=CqL1cYttB-8H2n5XTHth_auUMM3B+2yPuc3g9q4w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f294617-14be-5da3-ddf0-9891d0e421e3@kernel.dk>
Date:   Wed, 22 Jan 2020 11:25:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CADPKF+d_B=CqL1cYttB-8H2n5XTHth_auUMM3B+2yPuc3g9q4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/22/20 11:22 AM, Dmitry Sychov wrote:
>> You mean the one in liburing?
> 
> I'am referring to
> https://github.com/frevib/io_uring-echo-server/blob/master/src/include/liburing/io_uring.h
> with sockets OPs as the latest interface reference, thinking it will
> help the io_uring newcomers if
> IORING_OP_* lines will have corresponding comments of the minimum
> kernel requirement for now and the future.

The above obviously isn't mine, but it's probably forked/pulled from my
liburing.

I think the best thing to do here is update the io_uring_enter(2)
man page, since it has opcode descriptions. In those descriptions,
each of them should include "Supported since version 5.x" to make
this perfectly clear.

Longer term, I expect the probe to be the most useful for applications.

I don't want to change io_uring.h itself, as I've keep that sane so it
can simply be copied from the kernel repository to liburing. I intend
to keep it that way.

-- 
Jens Axboe

