Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB9B44980A
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 16:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKHPWI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbhKHPWI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 10:22:08 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28A7C061714
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 07:19:23 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so32681270edv.1
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 07:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zOVIg/NZqY2LEkgOFQOO9O8LthGIuXkRy3bx4iuP5FQ=;
        b=PGRaDMSmA38Fl6LZRDWk0rSh+omlKgQdV6K6S0PFChnxH7rQ9yBBpcrYGudPxNFV/r
         oeaAnjHJxRaoMlyM3h1Gy+hoH7JiiGmuFXmX8PAqyv7zw3rcWByl3bqwwhpfDG48faqu
         tkjeLsSPBKbgTZESbfskdUPySyz41hiCv7mnAz6knZWnXCEaVMcnZrU2QU2hcBiZKDxe
         cVx9ISQeHIW/pTXt1Yx2esDtS5AqiYqCb1WX4NxBDAextXIrAKUpqFA115sZ7qdo8M80
         HRN6iZ/zo2w5G2hHRfzZVcCSNadv/rWGpR/nhz8Q0iS9tAYwUNL8bYw89XCVgyw2+mdl
         bGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zOVIg/NZqY2LEkgOFQOO9O8LthGIuXkRy3bx4iuP5FQ=;
        b=gsijp6iC8gojfxv2qhLJ4TyMXXlcZ1no9AGVZ+X7onXe/hZ1JOY0klLpqAQiMNLC4b
         xr+CeanT+9vtXzfRK2ktYm09oMfC1pBYQr6suYqH3xGaTzfZpYYjTZags9sxukPWvGbO
         xR8GeZr+bme5OB0vzG+qYIUHqOiGUqSDQ9CYbhbHtqXVSRcFM39reOGPvl7p/Uv/zsad
         lglvRwY4b6f36m8dsoOL3w39OUnlJsL3Llp2zyXTL4BW1s3BVG0SqdlgdeSClq0rTWIz
         7WeWYxf+1bXr1c9np8qHdIHp9LX1ChcVT1FqR/+76mgJgB4Mbv1M6v4e2/PNxFuYNY9F
         BxYw==
X-Gm-Message-State: AOAM531NR+Jc+vHwPVu/LHnnsOIdHd+QOzQ1/j+z8S1zhQ8GaI7kRjuc
        KOEN/ASFea90bG+Zmnfikkks9aUq0Ho=
X-Google-Smtp-Source: ABdhPJweaud5Hw+y6NyvJn+0ocLyjDT/pOkkNF4CsrwSoVGNUUuvPIHzQQEmDDFgxbeWh5lhQudYwQ==
X-Received: by 2002:a17:906:12db:: with SMTP id l27mr115549ejb.244.1636384762199;
        Mon, 08 Nov 2021 07:19:22 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.239])
        by smtp.gmail.com with ESMTPSA id bm2sm9438260edb.39.2021.11.08.07.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:19:21 -0800 (PST)
Message-ID: <d49a7d24-7cea-0b4a-b577-3fac16ddc5fb@gmail.com>
Date:   Mon, 8 Nov 2021 15:19:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [bug report] io_uring: return iovec from __io_import_iovec
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <20211108134937.GA2863@kili>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211108134937.GA2863@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/21 13:49, Dan Carpenter wrote:
> Hello Pavel Begunkov,
> 
> The patch caa8fe6e86fd: "io_uring: return iovec from
> __io_import_iovec" from Oct 15, 2021, leads to the following Smatch
> static checker warning:
> 
> 	fs/io_uring.c:3218 __io_import_iovec()
> 	warn: passing zero to 'ERR_PTR'
> 
[...]
>      3188
>      3189         BUILD_BUG_ON(ERR_PTR(0) != NULL);
> 
> This is super paranoid.  :P

A bit, but gives an idea about assumptions

>      3209                 ret = import_single_range(rw, buf, sqe_len, s->fast_iov, iter);
>      3210                 return ERR_PTR(ret);

if (ret)
	return ERR_PTR(ret);
return NULL;

How about this? I have some hope in compilers, should be
optimised out

-- 
Pavel Begunkov
