Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6B4170119
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 15:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgBZOZP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 09:25:15 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42185 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBZOZO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 09:25:14 -0500
Received: by mail-il1-f196.google.com with SMTP id x2so2497398ila.9
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 06:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=99t4/LSu709UOxxHgYYUFaE6oXsju8vQQ+Dan2LeyS0=;
        b=AKk/C6blVn64C2GdGSB/11TdQP23YBX8LXOs3f/XbzIXqr7hAnkujGrXxJ0GQT48Lv
         2v5ZX98cPy5pTkdPtua8t2/B0nKg9uc8DXXJrgFFNrM1ag3T47CbyZQQ/aCH3Ktr8Pxk
         uoFERM1qWTnUf9//HAleqtIGtpdyRsFlXwkO/saMKUFejE4NjFAzPQz7EIcm8ldY6mxL
         wzHwYSGXsezQVveXPAngRMU9mkVfuA2WXc77iJlvVCARQ5NAX4g4/H26RuVa6sPk/qX9
         V7FXAFJxM1RtJXLYWiCgnE1VNOnXBPFjmc+JnL1kw5r1pWsPl7338FTsvxLmLOylZZC/
         CCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=99t4/LSu709UOxxHgYYUFaE6oXsju8vQQ+Dan2LeyS0=;
        b=bKjWJpl3Akt1svRZ3GiS7bstjpk19lhjL7TWS7kM00xtYiTONTfua5ZWHy9k6EhCeM
         vqC4rq9/xEHZVQyN0aeNIZTqaSkZ2bE0rlNlksDwzMxoeV5o9gTTrN9Rgy5q88wG1cNR
         WLGHoRrgMIBVf4A3njwgh0ZBSRgENbbSRrC5nIq/9AkuZFq5d/+Go7MLdNBx+LVVD2cU
         chelZLJs/nqEOBK7AS8fEpMU5n4kw71XOhT6Ybr4p7ju3ISzQBinyj8TIVGd9OrgQhV9
         XV+T4ipwQCtCI6Q7aVeCwec1vLkl7ucE91rMIFxU6X1LoDxnK506UUlhNdYkQOWQMv19
         GseA==
X-Gm-Message-State: APjAAAV4KIZMjc4ilC5ygr8OHbzpbO5RDu4zez37hyZRVgc3a5McCxi+
        JeB+jaBAyu2mkMqAuBir7bUAL6zOJyhtjQ==
X-Google-Smtp-Source: APXvYqzJN5sYhszLLxiqSgaobFmDkIvmEoRA1VDdlBLUayiIJ2XsJh54cxRdrAFsQuKLE4ruGUvNOg==
X-Received: by 2002:a92:5e9b:: with SMTP id f27mr5359159ilg.263.1582727112384;
        Wed, 26 Feb 2020 06:25:12 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v64sm756538ila.36.2020.02.26.06.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 06:25:12 -0800 (PST)
Subject: Re: [RFC PATCH 0/4] userspace PI passthrough via io_uring
To:     Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, io-uring@vger.kernel.org
References: <20200226083719.4389-1-bob.liu@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4defe33b-689e-04c1-a1d5-c2e7a572027e@kernel.dk>
Date:   Wed, 26 Feb 2020 07:25:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226083719.4389-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/20 1:37 AM, Bob Liu wrote:
> This RFC provides a rough implementation of a mechanism to allow
> userspace to attach protection information (e.g. T10 DIF) data to a
> disk write and to receive the information alongside a disk read.
> The interface is an extension to the io_uring interface:
> two new commands (IORING_OP_READV{WRITEV}_PI) are provided.
> The last struct iovec in the arg list is interpreted to point to a buffer
> containing the the PI data.
> 
> Patch #1 add two new commands to io_uring.
> Patch #2 introduces two helper funcs in bio-integrity.
> Patch #3 implement the PI passthrough in direct-io of block-dev.
> (Similar extensions may add to fs/direct-io.c and fs/maps/directio.c)
> Patch #4 add io_uring use space test case to liburing.

No strong feelings on the support in general, the io_uring bits are
trivial enough (once fixed up, per comments in that patch) that I
have no objections on that front.

I'd really like Martin to render an opinion on the API (PI info in
last vec), since he's the integrity guy.

-- 
Jens Axboe

