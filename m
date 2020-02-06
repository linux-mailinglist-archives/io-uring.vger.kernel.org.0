Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A1C154BB5
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBFTOB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:14:01 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45688 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFTOB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:14:01 -0500
Received: by mail-il1-f195.google.com with SMTP id p8so6132816iln.12
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 11:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fuAtZGaCJLnRfRW9tioJuGtCORfcLJllHTneidLFrY0=;
        b=TAUYIg1hc12D/FHuuz7zKsdIz/zIocwX/pLPJUaDvf2bBMqNDI90oAnj3UrExzjXx3
         4i7oLdb675ZYE/FVKfD6qmFmegDuiTGbU0PZLUcHOT92l2lTtfw4nACT6n0Jr0yIKjjy
         P3PPk60wjdNe/s6TKeUMGqRtHxeJKGTu1EJ32ChqSPEU4seTFJ1iX6hmP90HBu205h7h
         o1Bo6u3NZuJn10HDnZ5VtTHZr0e8WryEanzOfYGpCOAHBSUCA7Z46bjCDx+VMmp8NDpt
         HdmJtP3LdEcrCRnEAnivORmRYRvPYrRx87mW1Epo7I4qTcIR1TYwGd2bg933IIyU4kaD
         beCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fuAtZGaCJLnRfRW9tioJuGtCORfcLJllHTneidLFrY0=;
        b=PvhO4UyCoc7YWXV25OX5gdVMIxZvNP3ekM84BWbkSEqko+ayCQvpteKbP849rFG1u1
         PJ3TEQwKzncJpJOm+8V0S38fh9eSzXyuMkV/A7AWG/t4sLo5iZ2nPin3kWogtGQEhTKE
         Q7UNsi3Lu9dCoEN53lP+uywUuNzdNuuE0DO3zMCbelaDHQnv9/7yQupUxvNacP2JGFNm
         CBBy1vUKySLOWjvD/3HyjoUSJJIhCX1SsWfM6DpEbCra6kYN+F4CMzDl2sAy9gQHh1+b
         HTkgBhWIhyyoE6U4x1FHxQDUlKvwHtOEg96aWpT29DbRwRrgMuA4Q9EDnkSVbs6lWSGH
         1OUQ==
X-Gm-Message-State: APjAAAUNm/cXIZt/6DRArcjpcZNGUrZ3FRC6upOhgHUXTE1uXl+EyXzY
        nfAJcaavuDVEqO9mcXcKpVYKR+hzS2w=
X-Google-Smtp-Source: APXvYqyZ83IOhw8KyPvUBUOunBq1DQTTM9uRFrdYm/qmCKxgurBAyhJD/yfAm5PvTAOwHJmAfR9rcg==
X-Received: by 2002:a92:5d5d:: with SMTP id r90mr4956270ilb.284.1581016440001;
        Thu, 06 Feb 2020 11:14:00 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k11sm124412ion.32.2020.02.06.11.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:13:59 -0800 (PST)
Subject: Re: [PATCH v1] io_uring_cqe_get_data() only requires a const struct
 io_uring_cqe *cqe
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200206160209.14432-1-metze@samba.org>
 <94d5b40d-a5d8-706f-ab5c-3a8bd512d831@kernel.dk>
 <a26428e4-39d7-972c-cc68-45f7230d51b9@samba.org>
 <95e6c04d-e66f-06f8-3a04-ac59b35c2ac7@kernel.dk>
 <1c61d1da-9c1e-2d57-81da-f251d8e1992a@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2bf57f94-aaf4-8da6-b05f-9e9356c57151@kernel.dk>
Date:   Thu, 6 Feb 2020 12:13:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1c61d1da-9c1e-2d57-81da-f251d8e1992a@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 10:05 AM, Stefan Metzmacher wrote:
>>> While researching that I noticed that IOSQE_FIXED_FILE
>>> seems to be ignored for some new commands, I think that
>>> all commands with on input fd, should be able to use that flag.
>>> Can this be fixed before 5.6 final?
>>
>> Do you have specifics? Generally the file grabbing happens as part of
>> request prep, and the individual opcodes should not need to bother with
>> it.
> 
> io_statx_prep():
> io_openat_prep():
> io_openat2_prep():
> 
>   req->open.dfd = READ_ONCE(sqe->fd);
> 
> 
> io_statx():
>   ret = filename_lookup(ctx->dfd, ctx->filename, lookup_flags...
> 
> io_openat2():
> 
>   file = do_filp_open(req->open.dfd, req->open.filename, &op);
> 
> io_close_prep(): has this to make it clear that IOSQE_FIXED_FILE is not
> supported, I guess because FILE_UPDATE with -1 needs to be used instead?
> 
>         if (sqe->flags & IOSQE_FIXED_FILE)
>                 return -EINVAL;
> 
>         req->close.fd = READ_ONCE(sqe->fd);
> 
> 
> I guess at least we need if (sqe->flags & IOSQE_FIXED_FILE) in all
> cases, if we can't just fix it.

Ah yes good point, on both honoring it and failing it for close() when
we do honor it. I'll fix that up.

-- 
Jens Axboe

