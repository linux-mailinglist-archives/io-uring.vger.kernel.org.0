Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB414144C
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgAQWtw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:49:52 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46764 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgAQWtv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:49:51 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so12321340pgb.13
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 14:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZnIsvgBNU6IQmG/k8i440EZAGu2ojc3ERdtZNixfQFc=;
        b=nncCfH9sb+lCn6MBZwrKhtlnpXHpP12Uxnk3lrqoRTC/BwdpOG8vuwJXNu5mUKcg2q
         Jeji/YArjEjWoD9/2zfF+GH5NKR5gDGLXBpZ9SRorZfVtAF5AEV+d2Syc5yRu3dAcHey
         7EnVKIvntpJ4w5DxxBqhKCa8QzrBxGioD6svfLz7tfMj8FC9Y5jd+65540nO3Gow1K0G
         QjmxcsC+mq2LS4PEc4zbgC8JwnzqRkN7hb8YY76bFE/8Rl9zKrC/vHL9hr54FasKyuB2
         mFY2SEQw0VmR5oX3w7M9U8kR30KVmVroewdFcj6rprc96kuYdeqXNUjKHlJwTL+BXajD
         j9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZnIsvgBNU6IQmG/k8i440EZAGu2ojc3ERdtZNixfQFc=;
        b=Jmsn2SnhsIuDPu08XBtAUnld+0/6CBwH2Ksz1BRTz2MdLpaAJfeIyvA8rc/Q/rPGtW
         LeCjwtxooj13xToi6y9PMX/2cW47kRDRJhV/VVW4Ti/rncocmAf7NdjkvMfn5joa6tz1
         HW11C6pn2FL3CbD6Y+Zgyw288kljeshUywjSek48xcpRUBdxUs07UbwX2ZaNRZubih1y
         OPdnn5F01+5BG4e5MPQR4eJS1MKO7KwBx8TN1jDlwVrCcScFc0DN/5gC/PMM9fNzEkLh
         2V3gginRwZawJ+W1vsI7pohmCwKZYaiL6zLyME1IxhLhro+7+VjWCMHo1UWKnBWK3vnE
         vpHQ==
X-Gm-Message-State: APjAAAWw72fbx8VEzlgl7FPSJpZbhBGx9hqNZVPqcndhTrmqN8cGF0wz
        mSw4ywkOgu82+Rk5ZPEJbvpPQQ==
X-Google-Smtp-Source: APXvYqyP1JX8KQQ+k8UNOCKh6AuflWfxrSKjgA5dn9nT5h5a76BuIFfrtAcE7Ax9M7gjptqCTYoucw==
X-Received: by 2002:a62:1cd6:: with SMTP id c205mr5286906pfc.179.1579301390835;
        Fri, 17 Jan 2020 14:49:50 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y21sm30504299pfm.136.2020.01.17.14.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:49:50 -0800 (PST)
Subject: Re: [PATCH 0/2] optimise sqe-to-req flags
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
 <cover.1579300317.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cf0b8769-0365-2fd1-c87e-fe2e44052b51@kernel.dk>
Date:   Fri, 17 Jan 2020 15:49:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1579300317.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 3:41 PM, Pavel Begunkov wrote:
> *lost the cover-letter, but here we go*
> 
> The main idea is to optimise code like the following by directly
> copying sqe flags:
> 
> if (sqe_flags & IOSQE_IO_HARDLINK)
> 	req->flags |= REQ_F_HARDLINK;
> 
> The first patch is a minor cleanup, and the second one do the
> trick. No functional changes.
> 
> The other thing to consider is whether to use such flags as 
> REQ_F_LINK = IOSQE_IO_LINK, or directly use IOSQE_IO_LINK instead.

I think we should keep the names separate. I think it looks fine, though
I do wish that we could just have both in an enum and not have to do
weird naming. We sometimes do:

enum {
	__REQ_F_FOO
};

#define REQ_F_FOO	(1U << __REQ_F_FOO)

and with that we could have things Just Work in terms of numbering, if
we keep the overlapped values at the start. Would need IOSQE_* to also
use an enum, ala:

enum {
	__IOSQE_FIXED_FILE,
	__IOSQE_IO_DRAIN,
	...
};

and then do

#define IOSQE_FIXED_FILE	(1U << __IOSQE_FIXED_FILE)

and have the __REQ enum start with

enum {
	__REQ_F_FIXED_FILE = __IOSQE_FIXED_FILE,
	__REQ_F_IO_DRAIN = __IOSQE_IO_DRAIN,
	...
	__REQ_F_LINK_NEXT,
	__REQ_F_FAIL_LINK,
	...
};

-- 
Jens Axboe

