Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D990933F6A4
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCQRWW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 13:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbhCQRVz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 13:21:55 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B71C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 10:21:54 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c17so2242336ilj.7
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 10:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CC7Mf0q3EnAE5rDEZdcJka8pLybrmwi+35ZtT7cRNpY=;
        b=R8f/RSCPIzz9NYQuI5TblmZ75ivWjoBIXluRtO7AEotdMv7v7KHCvEai003M94RWSH
         l7ILlTeFi0m1sdeTXej8XNycu+0HFhG6iNN3ZHXCR/4bjs9eo67PDUYjkLZD9x4Y74vb
         OKdz6O6CIbjhSB2kmfLYXL/bOtf6+fmgvHPvvsE9YEdRoMDY+0jEMRjwoOEKaWo+P147
         WAd7wWzTJhC2SZTVkAjqUP+rhpB0cZ4l/w73CkqZMiEj42SrMqdZXG1xDawpQZHR1BVR
         R+kPCGhZLsdQ8NIowpoztRaT8kUyq1r0pVG2oYvOmVRGH4p0yYAmhvxkMfTKFCjkpCBK
         S+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CC7Mf0q3EnAE5rDEZdcJka8pLybrmwi+35ZtT7cRNpY=;
        b=nYaJCkk0QNQkT3DtWpbSBz357GQqRERofOVCkMRHxc4K3bBVYZLhuvUm9g2tBoqGvs
         iR92o1N76/34f6bZy0n9vqCltFPRXftk817X0TWzq2PMZCbgEuwaNhCeMx3ljfGgQH7o
         am7Vsl5bOClyTl2gr8M4xFqlubxwOSQxK92+urPSdYqqN2BkcVl+ytj9LCoaMGlVR+Zl
         fghv+Ji/M3eaoxe5xX5xAJo4iHdncEOwDr8D54MG89LuImoQuS1SzJUh1geIIFjqWAsr
         hgvpFWtYOxDCbwDJ+rd2n18piRZQr/00fpAvYG0E8iwE6o/OKA8P+m8mAZvqRzvmQKZj
         GbCQ==
X-Gm-Message-State: AOAM5320Fy4XZw56XxMEw/VSb9JPZsdHpOMpQhGNLqyyb38T5OXvA7Fl
        es9knUNsSFa97uK8npEtu7yX5A==
X-Google-Smtp-Source: ABdhPJybXw8bDKBlONIbtrQr8SGL+GEIUjjPZXAv+okD787KixQ5uvITZ2lF3f2Rihl32Q2eFqYSNw==
X-Received: by 2002:a05:6e02:1bc2:: with SMTP id x2mr8024672ilv.205.1616001714337;
        Wed, 17 Mar 2021 10:21:54 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d22sm10108387iof.48.2021.03.17.10.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 10:21:53 -0700 (PDT)
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com>
 <20210316140126.24900-4-joshi.k@samsung.com> <20210317085258.GA19580@lst.de>
 <149d2bc7-ec80-2e51-7db1-15765f35a27f@kernel.dk>
 <20210317165959.GA25097@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3b383e8e-b248-b8c4-2eea-6f5708845604@kernel.dk>
Date:   Wed, 17 Mar 2021 11:21:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210317165959.GA25097@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 10:59 AM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2021 at 10:49:28AM -0600, Jens Axboe wrote:
>> I will post it soon, only reason I haven't reposted is that I'm not that
>> happy with how the sqe split is done (and that it's done in the first
>> place). But I'll probably just post the current version for comments,
>> and hopefully we can get it to where it needs to be soon.
> 
> Yes, I don't like that at all either.  I almost wonder if we should
> use an entirely different format after opcode and flags, although
> I suspect fd would be nice to have in the same spot as well.

Exactly - trying to think of how best to do this. It's somewhat a shame
that I didn't place user_data right after fd, or even at the end of the
struct. But oh well.

One idea would be to have io_uring_sqe_hdr and have that be
op/flags/prio/fd as we should have those for anything, and just embed
that at the top of both io_uring_sqe (our general command), and
io_uring_whatever which is what the passthrough stuff would use.

Not sure, I need to dabble in the code a bit and see how we can make it
the cleanest.

> On a related note: I think it really should have a generic cmd
> dispatching mechanism like ioctls have, preferably even enforcing
> the _IO* mechanism.

Yes, we could certainly do that. I don't want to turn it into a
free-for-all and the wild west of passthrough, some notion of coherent
definitions would be prudent.

-- 
Jens Axboe

