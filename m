Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485601BAC0C
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 20:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgD0SLb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 14:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725995AbgD0SLb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 14:11:31 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29D5C0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:11:30 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id f3so19937112ioj.1
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r4RiKU4HCxcz2Q0wlRr5EAPEIq0bgfQDiB5LdjfnRo4=;
        b=e0wZPt/9a0MXA7H4PVsmiGLfzeBfDbFRBKmfQ8pTHL46aHRAl4rIjrbzIuFziVwRqD
         828wMEhYdzey6OcjQS1uzKo2HH1jyi0WAKqLtP+ry0dm/gXKxv6m4la8nSvNyQMXzAzE
         B2WtUBmtBunP+LKYgdfPEAjoNozriDWMffQvMklL7Dv3FFHp2p/hyjrXd32vg2UMgfWn
         Pv2HpmDCaR19qaLZhM+tpGEReoXtuqqbSPG9HIfg+ydi2ezDBtd3918PHKxJyJoX+Bfa
         oH+4AJSnEbLz9+8PUCQ9vuJy4HyUQ0GeRLXZxDG65yDU8fgl4RqeQfFYmv0OGG+MlJKt
         BsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r4RiKU4HCxcz2Q0wlRr5EAPEIq0bgfQDiB5LdjfnRo4=;
        b=QJjZ/DoduXbV/YiM8QAUT4bhJOyGGw+WCkiJZvsvxxXSCdw8A5mzO3lGGmt6D2eUow
         jLeR3EpcFrlMay/vN5dwNOWjUicX6CkDCO8RZKqfDwpywIkd2eUa/3HmN8r48a/H/vDC
         CmBnSVg11lXFGAO2/b+GGleLFAlwOZy9YOlB1MLI5tNq4Ma6TupOEtd9UVp3C445+YKX
         I0ZHewsPxqDRIhAIN5/e9YBANzLa0nxsx9ZkfpWrexjL7jKqNtCkAFM3XcmLOtrWvHxO
         4lonWwQQcVU6khzvt8BA4oZgqaVcBAJKqYqKA5uZJG4zdwX6y/2Xap/M1FHaAFoVuhAu
         uFbQ==
X-Gm-Message-State: AGi0PuZFU/i5jjI/6Ey+WTF8+aE9TL8ufLAawHt2NLfP6bauQCI9TwPE
        yUwPCbILdns4TI/vz86UjXW5tIqUv4FdHQ==
X-Google-Smtp-Source: APiQypI7DIusjnKXGuIPJ1/V6mz1HkHwMpvIG78Yu2ql42xMsn5Lg8QdR/Xau2c4hwuo+8ArURhbIg==
X-Received: by 2002:a5d:85d7:: with SMTP id e23mr22316137ios.174.1588011089510;
        Mon, 27 Apr 2020 11:11:29 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k13sm2200141ils.62.2020.04.27.11.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 11:11:28 -0700 (PDT)
Subject: Re: Feature request: Please implement IORING_OP_TEE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Clay Harris <bugs@claycon.org>
Cc:     io-uring@vger.kernel.org
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
 <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
 <ed2433e5-a8a7-65e2-8241-5900bf5e3b5a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <45f90025-62c5-8fff-9f1a-e52b17dad928@kernel.dk>
Date:   Mon, 27 Apr 2020 12:11:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ed2433e5-a8a7-65e2-8241-5900bf5e3b5a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/20 12:03 PM, Pavel Begunkov wrote:
> On 27/04/2020 18:55, Jens Axboe wrote:
>> On 4/27/20 9:40 AM, Clay Harris wrote:
>>> I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
>>> didn't go in at the same time.  It would be very useful to copy pipe
>>> buffers in an async program.
>>
>> Pavel, care to wire up tee? From a quick look, looks like just exposing
>> do_tee() and calling that, so should be trivial.
> 
> Yes, should be, I'll add it

Only other thing I spotted is making the inode lock / double lock honor
nowait, which is separate from the SPLICE_F_NONBLOCK flag.

-- 
Jens Axboe

