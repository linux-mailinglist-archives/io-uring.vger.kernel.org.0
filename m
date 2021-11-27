Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B42345FF08
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 15:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243460AbhK0ONU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 09:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhK0OLT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 09:11:19 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E78BC06173E
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 06:08:05 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id m5so11934559ilh.11
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 06:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RWi2CG+nAnrQUUuAvjobRe+jVeZCzFI56+rNYVOXVD0=;
        b=quMPngJe6S+cbrYa6lGvvGD4vAV5s8wKhtcCln16iTBIJyrGjnWEfkVt4+ifuzdMR7
         8A85Ad18z02DRHiR90W5qV+l8ScbFVzprbZFhzdeZoZff1a74G25WJoPyB/bDYalnz3C
         eL5SMxxw7+4KYEWBW92ml6DIRtVsn/ceQtFIGCT3uzztYzsgOIAQZJ4dun1PAh92tS1y
         6/FRXsfMQtSX6azoaetjtbVaCzkPIZMRYkBTU6a7Q4y55lOZlkCFU3imCLGzS7nrdGv4
         D3Oaculwhl/brc0n27eNNVKQck/s61ErRKEM4TDJ9M79Qj17YqfWHRsA8s3LEOC8ntj+
         hVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RWi2CG+nAnrQUUuAvjobRe+jVeZCzFI56+rNYVOXVD0=;
        b=DR1TqIMp9scaZxkoucLJLbkY7iDlbG0ZGdwOsYEGuDpxNOlRuttt8Mljx+eeM+qVtU
         nXlA8M242Om0Rmb9etRwk29/TLjdWyy6uC35yNdvn2P6yERoW8bM8/b5TU6nGIqBrUrx
         xfEWrvZlhu6Lb3ian4zNVxF65xnRBPwJkdtKMv3q500X74A0bMeW9RvyXVRJO6mrdwk3
         do/HrotC375qw2w/Wfewe9VcUm6uuHhJf1g2OxVtMQPQDG2jE6+ERYC58CZ4v4MFqvgI
         E2bx2m5Wefp4WLtCPsOMoGxrK8zduRAeIFkMy+V0dk8Z5sj6fkM4kZCT12rOJsS1TUl6
         HceQ==
X-Gm-Message-State: AOAM5333cxE4CgXHamIygtR7k/hkIcipQTz/RxxYqBg4rDjLo1Og06io
        ifLhSjYaxJmkt+WzPaEIam4HzNuP+mKlBs/7
X-Google-Smtp-Source: ABdhPJwL6KjbVT3RmozUQWZvIPmzsrx8Vd9GVpCuzuq2DT/GWVzVzROpipx0ADnc3RE2+I3zECXXEw==
X-Received: by 2002:a05:6e02:154c:: with SMTP id j12mr5142591ilu.51.1638022084345;
        Sat, 27 Nov 2021 06:08:04 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h14sm5310945ild.16.2021.11.27.06.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 06:08:03 -0800 (PST)
Subject: Re: [PATCH liburing] man/io_uring_enter.2: document
 IOSQE_CQE_SKIP_SUCCESS
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <381237725f0f09a2668ea7f38b804d5733595b1f.1637977800.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1aa70085-c405-4818-96af-9f4a409eecc1@kernel.dk>
Date:   Sat, 27 Nov 2021 07:08:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <381237725f0f09a2668ea7f38b804d5733595b1f.1637977800.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 6:50 PM, Pavel Begunkov wrote:
> Add a section about IOSQE_CQE_SKIP_SUCCESS describing the behaviour and
> use cases.

Thanks, applied with a few language edits.

-- 
Jens Axboe

