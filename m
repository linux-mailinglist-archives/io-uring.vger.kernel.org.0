Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889A31496AE
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 17:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAYQoL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 11:44:11 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35033 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYQoK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 11:44:10 -0500
Received: by mail-pf1-f196.google.com with SMTP id i23so2730080pfo.2
        for <io-uring@vger.kernel.org>; Sat, 25 Jan 2020 08:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JdcMu6qOC/l/h8yg4uxH4L0ReEXT+2wIHNQriVaWjMQ=;
        b=IgibN5/1C3vOuhyt9soXznfYTJA4ZJACrg0TWglaG8bZvcvArASh5Q3YpcWBVmabbc
         I4Eu9Drq68jEs8mHRoOWBeALNARc24UuDXs+vikqSnq4IeelZV9dN7RfjvNXkGOAQ/Cg
         pt2VeAh5z0Ni+H4PBtoToeNHQRI13e0AHCvujxrwgA+ON1clxQh9mqQHkYhuf5UyWjRP
         rOAlKlz/eeImsuav12dco8PfYFDSmycktNLhGiuYWH9clFwwX//4MxT5l08jHhcQrxsX
         qhr209bw4BafYwNz6xcp/9grsXMByCPS45/Fdub5Pu0JQn+XM5KICJNkCuaYZVsnRxuV
         fLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdcMu6qOC/l/h8yg4uxH4L0ReEXT+2wIHNQriVaWjMQ=;
        b=mHWBWLSkcESwADaGmPfmwX/KcWhp0tz/4cO0PVSdnMfEqj+JbW+Q2MEHj6Sz9mc+Gz
         V6ydH5EXGnCh0uZNLtL+dszY96RQMKLAXeXdik8SQdBdOqNET4nkoJQgDJYoBEkXSX8T
         /UDEX2dTlmJ9/mZUTuXWyzZaQB0lKHnB1UVVZ2Os1SiQm4CLFbU1TF7UbYlWlzvOKYci
         TX+E51uMN6yMjGC+Dx48zgRPdFuJ0I4j2bUYPFtyssN481sMPXLm3SWZORQkZ0sP/QYV
         Pa0hqgZnTcwc+fhWtKgkkRbNxYGRZUEA5UkWDky/i0A5z+x0/XLyqws+6d8MO7n5AnFY
         /rSA==
X-Gm-Message-State: APjAAAUMdxCXiJH4KmWD1CUGbIohMH1C3fSlkMsjw0qW8BB9tIn95lYr
        HQO46PpTQ9MdhBQT6bFzJ9EYLF0DVjI=
X-Google-Smtp-Source: APXvYqwvpGnKgGQvKn3Cap5WpEURrzoNeigwkoyihoDZ/yp1wu8Mr5dmFqt9wbegzg9WRbNKwvYxEQ==
X-Received: by 2002:a63:5c0e:: with SMTP id q14mr1926453pgb.313.1579970649726;
        Sat, 25 Jan 2020 08:44:09 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u11sm10209622pjn.2.2020.01.25.08.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 08:44:09 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: add support for sharing kernel io-wq
 workqueue
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200124213141.22108-1-axboe@kernel.dk>
 <20200124213141.22108-5-axboe@kernel.dk>
 <7ad7503b-cce2-ccbb-4d4d-9805ab342e8b@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <27935f36-9946-8556-49de-57a41204b314@kernel.dk>
Date:   Sat, 25 Jan 2020 09:44:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7ad7503b-cce2-ccbb-4d4d-9805ab342e8b@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/20 12:45 AM, Stefan Metzmacher wrote:
> Am 24.01.20 um 22:31 schrieb Jens Axboe:
>> An id field is added to io_uring_params, which always returns the ID of
>> the io-wq backend that is associated with an io_uring context. If an 'id'
>> is provided and IORING_SETUP_SHARED is set in the creation flags, then
>> we attempt to attach to an existing io-wq instead of setting up a new one.
> 
> Use the new name here too.

Already fixed that up yesterday.

>>  	ret = io_uring_create(entries, &p);
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 57d05cc5e271..f66e53c74a3d 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -75,6 +75,7 @@ enum {
>>  #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
>>  #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
>>  #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>> +#define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>>  
>>  enum {
>>  	IORING_OP_NOP,
>> @@ -183,7 +184,8 @@ struct io_uring_params {
>>  	__u32 sq_thread_cpu;
>>  	__u32 sq_thread_idle;
>>  	__u32 features;
>> -	__u32 resv[4];
>> +	__u32 id;
> 
> I think this should be wq_id;

Yeah, probably clearer, I'll make that change, thanks.

-- 
Jens Axboe

