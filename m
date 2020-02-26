Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919A7170116
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgBZOYK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 09:24:10 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38320 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBZOYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 09:24:09 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so3521172iog.5
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 06:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VjOUi1Fi7+2MpzROLuPBLYpl9LM0MiHFG+cIU7G/DUs=;
        b=CZ6SogvG+jLe4CyeZOEKf5Sl6s5/iivnqWDugz3ywfIG1HZ1peGLEafs38pRnulyth
         Cw9+Ifm3bjjTIlrM3KCoe+AuJbm1KrF1BMBD0Xypg89hOClvbsMu2FrpCfet2C9q0k/5
         bQ3WBlNC3gQbaBdW+VaNwnK4NqE9QYVyPzHOIyxCDs2WbG9eXBpu5p2K6z9mxmYBMV2t
         Fi46+auwvSjCghV1SoMlh0ZzipBn1rIFclBFNvwrNshChqHEDjd7+giv7yzTumUa52CD
         diVlQEiCxeBC2p+0OPlDgUuXLrgJs5arqz8O7DXBbb6YUyjq+PzXhkrsmRYTYQySD5cL
         ySlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VjOUi1Fi7+2MpzROLuPBLYpl9LM0MiHFG+cIU7G/DUs=;
        b=TURmsKE9ERU3gepWP4/gadiiJEvhIdWrEpYuPtB9W91twZkg/MwvHsU6spO3MwgPpp
         YhF27mSEYmg3BsC/cFPyWBOuZ1AIcKt21CL6iznK1KGjH5ny6JUAjY34jJl+oI8M4+oa
         6x1B4GvewaqK5uFGW72As1YUREoPpERuk0c6dXyqUzH48o9Y+YYt2GI3lt0yf7P3Oekb
         ITnq3Om7n1cipWdu9kpR+CW4Hofzaq5YIRIFW+Mpm89fwEfVSnaSJkBgv6eB0yCoXHL9
         j85jCIOvWsFlf+1QWurT5buC9EyX/Ur9QNfDLONkbMavaf/mA0+QMA9tUzRY4cMZEqVG
         whdA==
X-Gm-Message-State: APjAAAVdRA2WzSULgiI0Y/c6P5K5UYCrp9LoRxmfSmff7krPR+ZQsOCW
        LeXT0nsfCorjOLSZcq6jvfxsV+uTctfR7A==
X-Google-Smtp-Source: APXvYqwFNHqgHKYrcTeD09SifzEJkv7rgKvB2Q0zfnjOZ97sfYrsnpIOGWRvfm0QC3HjTi2ixxkfvQ==
X-Received: by 2002:a02:950d:: with SMTP id y13mr4507649jah.139.1582727047686;
        Wed, 26 Feb 2020 06:24:07 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b17sm622145ioj.81.2020.02.26.06.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 06:24:06 -0800 (PST)
Subject: Re: [PATCH 1/4] io_uring: add IORING_OP_READ{WRITE}V_PI cmd
To:     Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, io-uring@vger.kernel.org
References: <20200226083719.4389-1-bob.liu@oracle.com>
 <20200226083719.4389-2-bob.liu@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e466774-4dc5-861c-58b5-f0cc728bacff@kernel.dk>
Date:   Wed, 26 Feb 2020 07:24:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200226083719.4389-2-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/20 1:37 AM, Bob Liu wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index a3300e1..98fa3f1 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -62,6 +62,8 @@ enum {
>  	IORING_OP_NOP,
>  	IORING_OP_READV,
>  	IORING_OP_WRITEV,
> +	IORING_OP_READV_PI,
> +	IORING_OP_WRITEV_PI,
>  	IORING_OP_FSYNC,
>  	IORING_OP_READ_FIXED,
>  	IORING_OP_WRITE_FIXED,

So this one renumbers everything past IORING_OP_WRITEV, breaking the
ABI in a very bad way. I'm guessing that was entirely unintentional?
Any new command must go at the end of the list.

You're also not updating io_op_defs[] with the two new commands,
which means it won't compile at all. I'm guessing you tested this on
an older version of the kernel which didn't have io_op_defs[]?

-- 
Jens Axboe

