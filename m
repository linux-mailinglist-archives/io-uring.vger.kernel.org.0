Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C243217B0E
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 00:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgGGWiA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 18:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729342AbgGGWiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 18:38:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BE9C08C5DC
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 15:37:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q17so2905833pls.9
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ujEygxc3d5j3mD7Fz8DXKzp+VHqFRmCSAyV6TACKRqY=;
        b=k5O7SoEuB4v6eAKTQCGR+WdOKA3x9uxJYb+gAPfh3XvulB0NUO8KAQitfuJa9ojiSH
         hxKVrpKXGznJXSNUg9l/jd5QyFaTM+4Eb3lSE69M4/KL2f9OFW1/Ms8Fw7c5Z7VudOMo
         tCLp+SrSLpUSbbAMy+WG/OHB+odh5rndXsxAiBUnwSaS34Ahhg0rVR+db6V3tTCIu1NN
         eDfPa05dmlFdw9/Mb/JNujhTLFEzBBdOagseogP3GiACZ4+xPX0M877Cm544V+awZNDO
         BpbhGyU+kbXhZowakppxW8sAXBwZssx2nSOq1RHiXZjqDiktcfi8tcZpEBVn+DPU4bVv
         mENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ujEygxc3d5j3mD7Fz8DXKzp+VHqFRmCSAyV6TACKRqY=;
        b=cKcBimmdVlTXXDrhu3wE3pQMBrMDUiDPmPS2y/rdK4ttV5b74cYWMZZJNuZpn3pUuE
         Kudlxf66D/5pjQgOg+VGCnO/UrcvIOVS7TDPB9zMpGJQwC+2nxP5U/6ts/lfRxstKrpF
         0L0VAJy0G4pFzhxR9rM5KA4mCjwjFUbyRk3p2dlZbGiHpi+H/9iMvTVbynmMia26Lg3I
         RH6kTj+7RXDf3I9L+dQPtfGW6e29mVTeaozxmbMvdGhqmYYukwMN5xi6OYoMx2sgnN8T
         2748pfFZUgr6CaNAnELALy8fcMzTvjto3Ckn/To7KekbPNDQLVcRBoKpJjAvE/12jZwQ
         KRog==
X-Gm-Message-State: AOAM533SOl3KGF0rHAXLHRb/lZyLvbX/am9/L3cWfhvsPEv/fgKEr1h1
        ruBQKNm8Ye6odfYyh5O8xxSRPA==
X-Google-Smtp-Source: ABdhPJynwm1vS5HIwknN1B1A+r1QOKKGTnZqhLY/x2Zvdjf5NrFMJCsGKME8x1h9+LkeExWE4OO7ig==
X-Received: by 2002:a17:90a:9f4a:: with SMTP id q10mr6612744pjv.139.1594161479264;
        Tue, 07 Jul 2020 15:37:59 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e6sm15496691pfh.176.2020.07.07.15.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 15:37:58 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
 <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
 <20200706141002.GZ25523@casper.infradead.org>
 <4a9bf73e-f3ee-4f06-7fad-b8f8861b0bc1@kernel.dk>
 <20200706143208.GA25523@casper.infradead.org>
 <20200707151105.GA23395@test-zns>
 <20200707155237.GM25523@casper.infradead.org>
 <20200707202342.GA28364@test-zns>
 <7a44d9c6-bf7d-0666-fc29-32c3cba9d1d8@kernel.dk>
 <20200707221812.GN25523@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <145cc0ad-af86-2d6a-78b3-9ade007aae52@kernel.dk>
Date:   Tue, 7 Jul 2020 16:37:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707221812.GN25523@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/20 4:18 PM, Matthew Wilcox wrote:
> On Tue, Jul 07, 2020 at 02:40:06PM -0600, Jens Axboe wrote:
>>>> so we have another 24 bytes before io_kiocb takes up another cacheline.
>>>> If that's a serious problem, I have an idea about how to shrink struct
>>>> kiocb by 8 bytes so struct io_rw would have space to store another
>>>> pointer.
>>> Yes, io_kiocb has room. Cache-locality wise whether that is fine or
>>> it must be placed within io_rw - I'll come to know once I get to
>>> implement this. Please share the idea you have, it can come handy.
>>
>> Except it doesn't, I'm not interested in adding per-request type fields
>> to the generic part of it. Before we know it, we'll blow past the next
>> cacheline.
>>
>> If we can find space in the kiocb, that'd be much better. Note that once
>> the async buffered bits go in for 5.9, then there's no longer a 4-byte
>> hole in struct kiocb.
> 
> Well, poot, I was planning on using that.  OK, how about this:

Figured you might have had your sights set on that one, which is why I
wanted to bring it up upfront :-)

> +#define IOCB_NO_CMPL		(15 << 28)
> 
>  struct kiocb {
> [...]
> -	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
> +	loff_t __user *ki_uposp;
> -	int			ki_flags;
> +	unsigned int		ki_flags;
> 
> +typedef void ki_cmpl(struct kiocb *, long ret, long ret2);
> +static ki_cmpl * const ki_cmpls[15];
> 
> +void ki_complete(struct kiocb *iocb, long ret, long ret2)
> +{
> +	unsigned int id = iocb->ki_flags >> 28;
> +
> +	if (id < 15)
> +		ki_cmpls[id](iocb, ret, ret2);
> +}
> 
> +int kiocb_cmpl_register(void (*cb)(struct kiocb *, long, long))
> +{
> +	for (i = 0; i < 15; i++) {
> +		if (ki_cmpls[id])
> +			continue;
> +		ki_cmpls[id] = cb;
> +		return id;
> +	}
> +	WARN();
> +	return -1;
> +}

That could work, we don't really have a lot of different completion
types in the kernel.

-- 
Jens Axboe

