Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB11014DE5E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 17:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgA3QGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 11:06:13 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38128 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgA3QGM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 11:06:12 -0500
Received: by mail-pg1-f196.google.com with SMTP id a33so1881580pgm.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 08:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rSGz9w7btB4KK55ku0g1UpHsAfMGJFwE+1DVK+2DXh8=;
        b=wVUZeqLf0SH5N/YHMVBVt/57mb2H0+pjJIg6ueO7znqezDCNb39h8BAr+hUx0iYBZ9
         n+oQpG/RlhH/NRKocL4d5KfASBmh6L10ZTgOj5k8YGIj7ugURASftiGaN8073Oglfa9w
         AehW5yXtbh2r6cNzjx6iqMK0NK1u23g6+mpLou4txoRXoFVVaJjGRcha1pnvnfZ+Nco9
         TApjzgyViKjHysFjjLBjrVJdQ5ItDUjQF4G23r7yc/QUT1yAGpZDM/onwskjw37melr5
         4/+8Q+DMun3+jhEiAfycdsGe5BITmtChXJXxV1d6jTU2Fit5NxqyK5oVnlFD7IESb5It
         I9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSGz9w7btB4KK55ku0g1UpHsAfMGJFwE+1DVK+2DXh8=;
        b=AnPmeMT3bIQKeVRH00g0HXUmjI7VhPpAv31AY90rmmDKg78gds8ffxFNiQRecqZBBd
         5yW8waNBOjPM4HKtvZmQILYwCu2HIRk+boxOAIi0Rq3aAXKkIMxV/aVyRpeJeXBZ7zGA
         k/57/tP/eR/90wegOeD6YOXhLKe6sttb95vaTwhdwhI7DllCMG4UMPl+HGVPNCxWFDoo
         6guaHZb5iKpJRlYlH88QjT9bynTGiSBRY8iBG3IK6f+8H2WobCmclmSfQnOPOUjx2rGr
         4WW80z5/ChvXCBHc636XFqqABj/bQadzZpHvgFCE//vtDYtSTOLWzLcVp0RvzFO2UQTX
         zQQg==
X-Gm-Message-State: APjAAAVjumtG2cSgG03xUZsV4DZJS7Ov8thvksELtRJwx2g0klomDM9G
        vbkd7+Nc5ofItnuSqAm/QuvTOIFHgjY=
X-Google-Smtp-Source: APXvYqxezgj7zlP9bYTgI5eBkwQNfPtDVhzq56aR22m/QE95BqkxLyUkFM918JRZkb2kVW3pGKc5hw==
X-Received: by 2002:a62:e80a:: with SMTP id c10mr5604399pfi.129.1580400371362;
        Thu, 30 Jan 2020 08:06:11 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1132::1035? ([2620:10d:c090:180::90b5])
        by smtp.gmail.com with ESMTPSA id v8sm6807324pfn.172.2020.01.30.08.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 08:06:10 -0800 (PST)
Subject: Re: [PATCH] io_uring: add BUILD_BUG_ON() to assert the layout of
 struct io_uring_sqe
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200129132253.7638-1-metze@samba.org>
 <20200129133941.11016-1-metze@samba.org>
 <285d990e-a3d9-a033-ba11-898c6522ef3a@kernel.dk>
 <69a9126f-abf6-d21e-257c-a62e5fc82d0d@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79c73732-cea0-bff2-cad1-be0a6c9a0112@kernel.dk>
Date:   Thu, 30 Jan 2020 09:06:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <69a9126f-abf6-d21e-257c-a62e5fc82d0d@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/20 9:01 AM, Stefan Metzmacher wrote:
> Am 30.01.20 um 16:51 schrieb Jens Axboe:
>> On 1/29/20 6:39 AM, Stefan Metzmacher wrote:
>>> With nesting of anonymous unions and structs it's hard to
>>> review layout changes. It's better to ask the compiler
>>> for these things.
>>
>> I don't think I've once messed it up while adding new features,
>> but I'm fine with adding this as an extra safeguard. Realistically,
>> the regression tests would fail spectacularly if we ever did mess
>> this up.
> 
> Only if you don't just use :-)
> 
> cp linux/include/uapi/linux/io_uring.h \
>    liburing/src/include/liburing/io_uring.h
> 
> BTW: the current diff is
> 
> --- linux/include/uapi/linux/io_uring.h
> +++ liburing/src/include/liburing/io_uring.h
> @@ -43,7 +43,7 @@ struct io_uring_sqe {
>                 struct {
>                         /* index into fixed buffers, if used */
>                         __u16   buf_index;
> -                       /* personality to use, if used */
> +                       /* personality to use */
>                         __u16   personality;
>                 };
>                 __u64   __pad2[3];
> @@ -112,7 +112,6 @@ enum {
>         IORING_OP_SEND,
>         IORING_OP_RECV,
>         IORING_OP_OPENAT2,
> -       IORING_OP_EPOLL_CTL,
> 
>         /* this goes last, obviously */
>         IORING_OP_LAST,
> @@ -203,7 +202,6 @@ struct io_uring_params {
>  #define IORING_FEAT_NODROP             (1U << 1)
>  #define IORING_FEAT_SUBMIT_STABLE      (1U << 2)
>  #define IORING_FEAT_RW_CUR_POS         (1U << 3)
> -#define IORING_FEAT_CUR_PERSONALITY    (1U << 4)
> 
>  /*
>   * io_uring_register(2) opcodes and arguments

I'll copy it in, I do that every now and then. But now's a good time
since everything has been flushed out to Linus.

-- 
Jens Axboe

