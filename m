Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0081798AA
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 20:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCDTJR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 14:09:17 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34372 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCDTJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 14:09:17 -0500
Received: by mail-il1-f193.google.com with SMTP id n11so2810054ild.1
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 11:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ps8C0xmejjlbPpOPxaw7qA9NxtL5C0JUCImhMS39/k8=;
        b=bg4T10VTUzXqudjUUjYABUq7JboikLm0lF6G44WeZJhkaKK3wnzztLUPqxamBB/wo8
         BRIZiW5psZSiO8Fnj2CNntpQlT1DA4Ekd/7zuJWj0rMr3HMJivVF3ISXY43dPu3qO4ri
         k4kJ0d7EHlxT1CPdHmsTRUMx7WvTV1IuG6MdivJhf7gtW7lY41IB/rszcGYmisaA4bXO
         eLU3QL5nWlMOnE1/Kx/eSl7XMZQyAR++MFx/SrRQictbU8L5hFXZQ1XX5/8tWVWPNf4p
         mD5gpQLYOifQReScJ8FfGfkacXCLdaIGU5lWccyViWrDm+ajJ0ptJlURdFg1tmiwgayn
         6PAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ps8C0xmejjlbPpOPxaw7qA9NxtL5C0JUCImhMS39/k8=;
        b=kgG4ihV4OVO7ltD/FyboB8Z31hWXw6acyxvyepU+C83DFZvon+swLAVUhzpWziN5s6
         k5W52eqfv7ouLROObc5g8BhN01cGvu4a2EdXIUE/3YxLNTa/pxvt5ybA9grZa6l6t6u7
         Wq9D0u9ZmaG2Pn6gMRaGjKUmQzyC4TpsALOYD0UlVwUpx825d4/mj748bCL9cBml0bEN
         RnioF6k8if4tUk7rsyaRPvk50jFiZdVHyMpp6oAJYO6k2HWNNP/UNKyK7uaniSw1QyFs
         vapeCXE1LXkkMYDT1DVNcSeMga7ln7IYUujgrTq7juQwm9iVWTH2i+kQ0Lu7s1iPd6p5
         YMDQ==
X-Gm-Message-State: ANhLgQ28uP5DFcCUDTitQKMEiKWdXOhnCpiv5Vxssy1KWtWmHZRUNfh0
        rzXAr8smssPJT7ac9WDYRnZG+A==
X-Google-Smtp-Source: ADFU+vsXGbUMzZrXtDjuEW1DjjvNlOWhzkqCSGPm1Y60BmX9MsMsp3c60PbBduPHkCpe50lC45bz8Q==
X-Received: by 2002:a92:8893:: with SMTP id m19mr4047903ilh.54.1583348955757;
        Wed, 04 Mar 2020 11:09:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y14sm2582660ilb.29.2020.03.04.11.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 11:09:15 -0800 (PST)
Subject: Re: [PATCH 6/6] io_uring: allow specific fd for IORING_OP_ACCEPT
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304180016.28212-7-axboe@kernel.dk> <20200304190223.GA16251@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <54cbb2d9-e1d7-07b1-2806-6f430a420dd8@kernel.dk>
Date:   Wed, 4 Mar 2020 12:09:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304190223.GA16251@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 12:02 PM, Josh Triplett wrote:
> On Wed, Mar 04, 2020 at 11:00:16AM -0700, Jens Axboe wrote:
>> sqe->len can be set to a specific fd we want to use for accept4(), so
>> it uses that one instead of just assigning a free unused one.
> [...]
>> +	accept->open_fd = READ_ONCE(sqe->len);
>> +	if (!accept->open_fd)
>> +		accept->open_fd = -1;
> 
> 0 is a valid file descriptor. I realize that it seems unlikely, but I
> went to a fair bit of trouble in my patch series to ensure that
> userspace could use any valid file descriptor openat2, without a corner
> case like "you can't open as file descriptor 0", even though it would
> have been more convenient to just say "if you pass a non-zero fd in
> open_how". Please consider accepting a flag to determine the validity of
> open_fd.

Heh, I actually just changed this, just added that as a temporary hack to
verify that things were working. Now SOCK_SPECIFIC_FD is required, and we
just gate on that. OP_ACCEPT disallowed fd != 0 before, so we continue
to do that if SOCK_SPECIFIC_FD isn't set:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fd-select

top two patches.

-- 
Jens Axboe

