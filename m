Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529FB25C3CB
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 16:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgICOIj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgICOHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 10:07:55 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE03EC0611E0
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 07:07:43 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q6so2557515ild.12
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 07:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CB3FH1QTmBm5WlgHNeHzU8TKjErR+j9aqn+2gr2lPEw=;
        b=uDSAKNtWtRc8PWxUu0oPgJvfab/Bga9fBkkRGIIgQRqyCST1bhF02ygsIzz2i/xBxZ
         MtlnOt+1zNDQCKvvgR4PV1z/54LjcQdTc9McD3ScL4K5OLpJwGC8SyH8n6fyTLbal7WG
         afQbDqvOe5JaqD5krBY3LkRnjLDpMx/6sdhrjJk5YeQs+E0ng3kVa5Cg17SBTQuUpQHP
         qv/J723U4VdNybmZGzJJvUSpYqaOD4CJ5SFVOW47m8g0T/MoT8+IT/xA0Gw/A/TIlYkT
         lalpQ2Kb7ZwsepnWPSWsQbsGy6/Gx7hdM35VU+zkYrkkvtbUpR9yVmtJWW/WUHEZvuo9
         IrVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CB3FH1QTmBm5WlgHNeHzU8TKjErR+j9aqn+2gr2lPEw=;
        b=e53AMy+w5AhiPRX7v8hm6Dta0Z1UE0cxCPRjBrhMcdZ38qmDDbyjym9DA1cdzhXoSt
         jYLeBR+/TwkRLEKsVFzELBMy3xJeSmbzPLEwOHfow7SEjGhpJN2+469s2uVlJdG2ulof
         GsbwJEnt+HSJHgQ4sJjujbbf+xp7qu3Ltza5QtXGaYD/GbpQjpZwYXdkZBUFzAzuNESZ
         SBUDDIwn+axJi8x8BChtNq2726bSl1zZGBF3qnQqzKDWyz1HRnE65/x0WztUDjnMLMaq
         qVwkXMIuJjDT4Utg5Qx8aEnlw25pAvbLZZtEze9T0a0P1ovNdiK7eG/sEzslXaXGsi4W
         bUlw==
X-Gm-Message-State: AOAM532aJaA6w5bzwPa30jdGgqy4lCMZnznYEFwU2xpfi5KFovfF7iFv
        XKU06dFrbe3bLJ36UPn5XlrQGA8FWD6ME1Ot
X-Google-Smtp-Source: ABdhPJxXroKmKQ10gJDWIpNfRgglbkAEgQnZGGeTDbrG0AaTg20iBVmDDt2vx3NE6+TcJhc0uxLCJQ==
X-Received: by 2002:a92:3402:: with SMTP id b2mr3253560ila.181.1599142062711;
        Thu, 03 Sep 2020 07:07:42 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u18sm320881iln.78.2020.09.03.07.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 07:07:42 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] fsstress: add IO_URING read and write operations
To:     Brian Foster <bfoster@redhat.com>, Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, io-uring@vger.kernel.org
References: <20200823063032.17297-1-zlang@redhat.com>
 <20200823063032.17297-2-zlang@redhat.com> <20200903124247.GA444163@bfoster>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eab6aa7a-3a3a-d47e-f38f-24cd00191ff6@kernel.dk>
Date:   Thu, 3 Sep 2020 08:07:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903124247.GA444163@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/20 6:42 AM, Brian Foster wrote:
> On Sun, Aug 23, 2020 at 02:30:29PM +0800, Zorro Lang wrote:
>> IO_URING is a new feature of curent linux kernel, add basic IO_URING
>> read/write into fsstess to cover this kind of IO testing.
>>
>> Signed-off-by: Zorro Lang <zlang@redhat.com>
>> ---
>>  README                 |   4 +-
>>  configure.ac           |   1 +
>>  include/builddefs.in   |   1 +
>>  ltp/Makefile           |   5 ++
>>  ltp/fsstress.c         | 139 ++++++++++++++++++++++++++++++++++++++++-
>>  m4/Makefile            |   1 +
>>  m4/package_liburing.m4 |   4 ++
>>  7 files changed, 152 insertions(+), 3 deletions(-)
>>  create mode 100644 m4/package_liburing.m4
>>
> ...
>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>> index 709fdeec..7a0e278a 100644
>> --- a/ltp/fsstress.c
>> +++ b/ltp/fsstress.c
> ...
>> @@ -2170,6 +2189,108 @@ do_aio_rw(int opno, long r, int flags)
>>  }
>>  #endif
>>  
>> +#ifdef URING
>> +void
>> +do_uring_rw(int opno, long r, int flags)
>> +{
>> +	char		*buf;
>> +	int		e;
>> +	pathname_t	f;
>> +	int		fd;
>> +	size_t		len;
>> +	int64_t		lr;
>> +	off64_t		off;
>> +	struct stat64	stb;
>> +	int		v;
>> +	char		st[1024];
>> +	struct io_uring_sqe	*sqe;
>> +	struct io_uring_cqe	*cqe;
>> +	struct iovec	iovec;
>> +	int		iswrite = (flags & (O_WRONLY | O_RDWR)) ? 1 : 0;
>> +
>> +	init_pathname(&f);
>> +	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
>> +		if (v)
>> +			printf("%d/%d: do_uring_rw - no filename\n", procid, opno);
>> +		goto uring_out3;
>> +	}
>> +	fd = open_path(&f, flags);
>> +	e = fd < 0 ? errno : 0;
>> +	check_cwd();
>> +	if (fd < 0) {
>> +		if (v)
>> +			printf("%d/%d: do_uring_rw - open %s failed %d\n",
>> +			       procid, opno, f.path, e);
>> +		goto uring_out3;
>> +	}
>> +	if (fstat64(fd, &stb) < 0) {
>> +		if (v)
>> +			printf("%d/%d: do_uring_rw - fstat64 %s failed %d\n",
>> +			       procid, opno, f.path, errno);
>> +		goto uring_out2;
>> +	}
>> +	inode_info(st, sizeof(st), &stb, v);
>> +	if (!iswrite && stb.st_size == 0) {
>> +		if (v)
>> +			printf("%d/%d: do_uring_rw - %s%s zero size\n", procid, opno,
>> +			       f.path, st);
>> +		goto uring_out2;
>> +	}
>> +	sqe = io_uring_get_sqe(&ring);
>> +	if (!sqe) {
>> +		if (v)
>> +			printf("%d/%d: do_uring_rw - io_uring_get_sqe failed\n",
>> +			       procid, opno);
>> +		goto uring_out2;
>> +	}
> 
> I'm not familiar with the io_uring bits, but do we have to do anything
> to clean up this sqe object (or the cqe) before we return?

The cqe/sqe resources are tied to the ring, so as long as
io_uring_queue_exit() is called, then they are freed. And it is after
the run, so looks fine to me.

-- 
Jens Axboe

